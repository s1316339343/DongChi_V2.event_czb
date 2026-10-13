// ========== AI 推荐联网模块（Ollama，OpenAI 兼容接口）==========
// 服务地址与模型名不再硬编码：由 AiModelService 统一管理
// （持久化 + 局域网自动发现 + 地址失效自愈），见 AiModelService.ets
import { common } from '@kit.AbilityKit';
import { AiModelService } from './AiModelService';
import { AiDish, LocalDish, RecommendConditions, RecommendResult, ScoredDish, CATEGORY_NAMES, TIME_LABELS, BUDGET_LABELS, DIET_LABELS } from './DishTypes';
import { LOCAL_DISHES } from './LocalDishes';
import { DbService } from './DbService';

// ========== 模型 API 类型定义 ==========

interface DeepSeekMessage {
  content: string;
}

interface DeepSeekChoice {
  message: DeepSeekMessage;
}

interface DeepSeekResponse {
  choices: DeepSeekChoice[];
}

interface ParsedDishData {
  dishes: object[];
}

// ========== 用户偏好画像（P1：个性化反馈闭环）==========
// 从收藏 + 最近决策记录聚合而来，用于注入 AI prompt 与本地推荐打分
interface UserPreferenceProfile {
  favoritedDishes: string[];   // 收藏的菜名
  recentDishes: string[];      // 最近决策中出现过的菜名
  categoryCounts: number[];    // 最近决策的口味偏好计数（长度 4）
  timeCounts: number[];        // 时间偏好计数（长度 3）
  budgetCounts: number[];      // 预算偏好计数（长度 4）
}

// ========== 推荐服务 ==========

export class RecommendService {
  // "换一批"偏移计数器（每个优先级独立维护，切换标签时不互相干扰）
  public static refreshOffsetMap: Record<string, number> = {
    'balanced': 0,
    'time_budget': 0,
    'ingredients': 0
  };

  // ========== 用户偏好画像（P1：个性化反馈闭环）==========
  // 内存缓存；profileDirty 为 true（用户收藏变化）时从数据库重建
  private static cachedProfile: UserPreferenceProfile | null = null;

  /**
   * 加载用户偏好画像（收藏菜品 + 最近 5 次决策记录）
   * 失败时返回空画像，不影响推荐主流程
   */
  static async loadProfile(context: common.Context): Promise<UserPreferenceProfile> {
    if (RecommendService.cachedProfile !== null && !RecommendService.profileDirty) {
      return RecommendService.cachedProfile;
    }
    const emptyProfile: UserPreferenceProfile = {
      favoritedDishes: [],
      recentDishes: [],
      categoryCounts: [0, 0, 0, 0],
      timeCounts: [0, 0, 0],
      budgetCounts: [0, 0, 0, 0]
    };
    try {
      const favorites = await DbService.getAllFavorites(context);
      const favoritedDishes: string[] = [];
      for (const f of favorites) {
        if (favoritedDishes.indexOf(f.dishName) < 0) {
          favoritedDishes.push(f.dishName);
        }
      }
      const recent = await DbService.getRecentDecisions(context, 5);
      const recentDishes: string[] = [];
      const categoryCounts: number[] = [0, 0, 0, 0];
      const timeCounts: number[] = [0, 0, 0];
      const budgetCounts: number[] = [0, 0, 0, 0];
      for (const r of recent) {
        if (r.category >= 0 && r.category < 4) {
          categoryCounts[r.category]++;
        }
        if (r.time >= 0 && r.time < 3) {
          timeCounts[r.time]++;
        }
        if (r.budget >= 0 && r.budget < 4) {
          budgetCounts[r.budget]++;
        }
        try {
          const dishes: Array<Record<string, string>> = JSON.parse(r.results) as Array<Record<string, string>>;
          for (const d of dishes) {
            const name = String(d['name'] || '');
            if (name !== '' && recentDishes.indexOf(name) < 0) {
              recentDishes.push(name);
            }
          }
        } catch (_) {
          // 单条记录解析失败忽略
        }
      }
      RecommendService.cachedProfile = {
        favoritedDishes: favoritedDishes,
        recentDishes: recentDishes,
        categoryCounts: categoryCounts,
        timeCounts: timeCounts,
        budgetCounts: budgetCounts
      };
    } catch (error) {
      console.error('加载偏好画像失败，使用空画像', JSON.stringify(error));
      RecommendService.cachedProfile = emptyProfile;
    }
    RecommendService.profileDirty = false;
    return RecommendService.cachedProfile;
  }

  /**
   * 返回推荐结果及来源标识
   * 优先调用 AI 模型（Ollama），失败时自动降级本地推荐引擎
   */
  static async getRecommendations(
    context: common.Context,
    category: number,
    time: number,
    budget: number,
    diet: number[],
    ingredients: string[] = [],
    hasNoIngredients: boolean = false,
    priority: string = 'balanced'
  ): Promise<RecommendResult> {
    // P1：加载用户偏好画像（收藏 + 历史决策），注入 prompt 与本地打分
    const profile = await RecommendService.loadProfile(context);
    try {
      const conditions = RecommendService.buildConditions(
        category, time, budget, diet, ingredients, hasNoIngredients);
      const prompt = RecommendService.buildPrompt(conditions, profile);
      const responseText = await AiModelService.chat(prompt, context);
      let dishes = RecommendService.parseResponse(responseText);
      if (dishes.length === 0) {
        throw new Error('AI 返回菜品为空');
      }
      // P0 修复：AI 路径统一后校验 — 与本地路径执行同一套硬性约束校验（忌口一票否决 + 食材重算 + 超限标注）
      dishes = RecommendService.validateAiDishes(conditions, dishes);
      if (dishes.length === 0) {
        throw new Error('AI 返回菜品全部违反忌口限制，降级本地推荐');
      }
      return { dishes: dishes, isLocal: false } as RecommendResult;
    } catch (error) {
      // AI 不可用（断网/模型服务未启动/解析失败）时静默降级本地推荐
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      console.error('AI 推荐失败，降级本地推荐', errMsg);
      const dishes = RecommendService.getLocalRecommendations(
        category, time, budget, diet, ingredients, hasNoIngredients, priority, profile);
      return { dishes: dishes, isLocal: true, failReason: RecommendService.classifyFailReason(errMsg) } as RecommendResult;
    }
  }

  /**
   * 构建条件对象
   */
  private static buildConditions(
    category: number,
    time: number,
    budget: number,
    diet: number[],
    ingredients: string[] = [],
    hasNoIngredients: boolean = false
  ): RecommendConditions {
    return {
      category,
      categoryName: CATEGORY_NAMES[category] || '家常清淡',
      time,
      timeLabel: time >= 0 ? TIME_LABELS[time] : '无限制',
      budget,
      budgetLabel: budget >= 0 ? BUDGET_LABELS[budget] : '无限制',
      diet,
      dietLabels: diet.map(i => DIET_LABELS[i]),
      ingredients,
      hasNoIngredients
    };
  }

  // ========== 模型 API 相关方法（LM Studio / llama.cpp OpenAI 兼容接口）==========

  /**
   * 构建 AI Prompt
   */
  private static buildPrompt(conditions: RecommendConditions, profile: UserPreferenceProfile): string {
    const dietStr = conditions.dietLabels.length > 0
      ? conditions.dietLabels.join('、')
      : '无特殊忌口';

    let ingredientsStr = '无特殊说明';
    let noIngredientRule = '';
    if (conditions.hasNoIngredients) {
      ingredientsStr = '用户家里没有任何食材，请推荐不需要特殊食材、只需基础调料（油盐等家常必备）就能做的菜品';
      noIngredientRule = '\n【特别注意】用户家里没有任何食材，所有推荐的菜品必须设置 hasIngredients 为 false！请严格遵守。';
    } else if (conditions.ingredients.length > 0) {
      ingredientsStr = conditions.ingredients.join('、');
    }

    // P1：偏好画像注入 prompt（收藏菜品 + 历史口味偏好）
    let prefSection = '';
    const prefLines: string[] = [];
    if (profile.favoritedDishes.length > 0) {
      const favs = profile.favoritedDishes.slice(0, 8);
      prefLines.push('用户收藏过的菜品：' + favs.join('、'));
    }
    let catIdx = 0;
    let catMax = 0;
    for (let i = 0; i < profile.categoryCounts.length && i < 4; i++) {
      if (profile.categoryCounts[i] > catMax) {
        catMax = profile.categoryCounts[i];
        catIdx = i;
      }
    }
    if (catMax >= 2) {
      prefLines.push('用户最常选择的口味方向：' + (CATEGORY_NAMES[catIdx] || ''));
    }
    if (prefLines.length > 0) {
      prefSection = '【用户偏好】（来自用户收藏与历史记录，可作为优先参考，但不得违反上述硬性约束）\n'
        + prefLines.map((l: string) => '- ' + l).join('\n')
        + '\n- 可优先推荐与用户收藏菜品风格相近或食材相近的菜品\n';
    }

    return `你是一个专业的美食推荐助手。请根据以下用户的条件，推荐3道最适合的菜品。

用户选择：
- 口味方向：${conditions.categoryName}
- 时间限制：${conditions.timeLabel}
- 预算限制：${conditions.budgetLabel}
- 忌口限制：${dietStr}
- 家里现有食材：${ingredientsStr}
${noIngredientRule}
${prefSection}
核心要求：
1. 推荐3道符合用户口味方向且满足限制条件的菜品
2. 【最重要】优先使用"家里现有食材"中的食材来推荐菜品！如果现有食材不足以做某道菜，请如实标注hasIngredients为false并在reason中说明需要补买什么
3. 每道菜必须包含以下字段（以严格JSON格式返回）：
   - name: 菜名（中文）
   - icon: 对应的emoji图标
   - time: 自己做所需时间（如"15分钟"）
   - cost: 自己做食材成本（如"8元"）
   - difficulty: 难度（用⭐表示，最多三颗星）
   - hasIngredients: 是否家里现有食材足够做这道菜（boolean）
   - cookTime: 具体烹饪耗时（如"15分钟"）
   - deliveryTime: 外卖预计送达时间（如"25分钟"）
   - cookCost: 自己做花费金额（纯数字，单位元）
   - deliveryCost: 外卖花费金额（纯数字，单位元）
   - requiredIngredients: 这道菜所需的核心食材（字符串数组，2~5个常见食材名，如"鸡蛋"、"番茄"）
   - reason: 推荐理由（一句话，简洁有说服力，说明怎么用家里食材做）

4. 严格遵守用户的口味方向和忌口限制
5. 时间限制和预算限制作为筛选和排序依据
6. 尽量推荐多样化、不同风格的菜品
7. 如果家里食材有限，推荐以家里已有食材为主、只需少量购买的菜品
8. 【价格必填】每道菜的 cost 必须是"数字+元"格式（如"8元"），cookCost 和 deliveryCost 必须是大于0的纯数字（单位元），严禁返回 null、0、空字符串或"-"

请直接用以下JSON格式返回，不要加markdown代码块标记，不要输出JSON以外的任何文字：
{"dishes": [{"name": "菜名", "icon": "🍳", "time": "15分钟", "cost": "8元", "difficulty": "⭐", "hasIngredients": true, "cookTime": "15分钟", "deliveryTime": "25分钟", "cookCost": 8, "deliveryCost": 18, "requiredIngredients": ["食材1", "食材2"], "reason": "推荐理由"}]}`;
  }

  // ========== 响应解析与失败分类 ==========

  /**
   * 解析 API 返回的 JSON 数据
   */
  private static parseResponse(responseText: string): AiDish[] {
    try {
      const parsed: DeepSeekResponse = JSON.parse(responseText) as DeepSeekResponse;
      if (!parsed.choices || parsed.choices.length === 0) {
        throw new Error('API 返回为空');
      }

      const content = parsed.choices[0].message.content;
      // 尝试直接解析 content
      try {
        const dishData: ParsedDishData = JSON.parse(content) as ParsedDishData;
        if (dishData.dishes && Array.isArray(dishData.dishes)) {
          return RecommendService.sanitizeDishes(dishData.dishes);
        }
      } catch (e) {
        // content 可能包含 markdown 代码块或前后多余文字，提取其中的 JSON 部分
        const jsonMatch = content.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          const dishData: ParsedDishData = JSON.parse(jsonMatch[0]) as ParsedDishData;
            if (dishData.dishes && Array.isArray(dishData.dishes)) {
              return RecommendService.sanitizeDishes(dishData.dishes);
            }
          }

        throw new Error('无法解析推荐结果');
      }
      throw new Error('无法解析推荐结果');
    } catch (error) {
      console.error('解析响应失败', JSON.stringify(error));
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * 将 AI 失败原因分类为用户可读的中文描述
   */
  private static classifyFailReason(errMsg: string): string {
    // Ollama 服务相关的错误已带完整中文指引，直接展示
    if (errMsg.indexOf('Ollama') >= 0 || errMsg.indexOf('AI 模型配置未初始化') >= 0) {
      return errMsg;
    }
    if (errMsg.indexOf('无法解析') >= 0 || errMsg.indexOf('API 返回为空') >= 0) {
      return 'AI 返回的内容格式异常，无法识别推荐结果';
    }
    if (errMsg.indexOf('违反忌口') >= 0) {
      return 'AI 推荐的菜品不符合你的忌口要求，已按忌口要求从本地菜品库重新筛选';
    }
    if (errMsg.indexOf('菜品为空') >= 0) {
      return 'AI 未返回有效的菜品数据';
    }
    if (errMsg.indexOf('请求失败') >= 0) {
      return '无法连接 AI 模型服务（请检查手机与电脑是否在同一 WiFi、AI 模型服务是否已启动）';
    }
    if (errMsg.indexOf('API返回错误') >= 0) {
      return 'AI 模型服务返回了错误（请检查模型是否已正确加载）';
    }
    return 'AI 推荐服务出现异常，请稍后再试';
  }

  /**
   * 从字符串中提取价格数字（如 "8元" → 8，"约15元" → 15），失败返回 0
   */
  private static extractPrice(str: string): number {
    const m = str.match(/(\d+(\.\d+)?)/);
    if (m) {
      const n = Number(m[1]);
      if (Number.isFinite(n) && n > 0) {
        return n;
      }
    }
    return 0;
  }

  /**
   * 清洗字符串字段：null/undefined/"null"/"undefined"/"-" 等异常值统一返回空字符串
   */
  private static cleanString(value: Object | undefined): string {
    if (value === undefined || value === null) {
      return '';
    }
    const s = String(value).trim();
    const lower = s.toLowerCase();
    if (s === '' || s === '-' || lower === 'null' || lower === 'undefined') {
      return '';
    }
    return s;
  }

  /**
   * 安全地将字段转为价格数字，失败返回 0（页面显示为 "-"）
   */
  private static sanitizePrice(value: Object | undefined): number {
    if (value === undefined || value === null) {
      return 0;
    }
    if (typeof value === 'number') {
      const n = value as number;
      return Number.isFinite(n) && n > 0 ? n : 0;
    }
    if (typeof value === 'string') {
      return RecommendService.extractPrice(value as string);
    }
    return 0;
  }

  /**
   * 规范化单个 AI 返回菜品：
   * - 清洗字符串字段，杜绝 null/"-" 等异常值出现在 UI
   * - 校验价格字段：cost 与 cookCost 互相同步；无法得到有效价格时置为 0 / "-"
   */
  private static normalizeDish(raw: object): AiDish {
    const r: Record<string, Object> = raw as Record<string, Object>;
    const name = RecommendService.cleanString(r['name']);
    const icon = RecommendService.cleanString(r['icon']) || '🍽️';
    const time = RecommendService.cleanString(r['time']);
    const difficulty = RecommendService.cleanString(r['difficulty']) || '⭐';
    const hasIngredients = r['hasIngredients'] === true;
    const cookTime = RecommendService.cleanString(r['cookTime']) || time;
    const deliveryTime = RecommendService.cleanString(r['deliveryTime']);
    const reason = RecommendService.cleanString(r['reason']);

    const costRaw = RecommendService.cleanString(r['cost']);
    let cookCost = RecommendService.sanitizePrice(r['cookCost']);
    if (cookCost <= 0) {
      // cookCost 缺失时从 cost 字符串提取
      cookCost = RecommendService.extractPrice(costRaw);
    }
    const deliveryCost = RecommendService.sanitizePrice(r['deliveryCost']);
    // cost 与 cookCost 表示同一"自做成本"，互为兜底；都无效时显示 "-"
    let cost = costRaw;
    if (cost === '' || RecommendService.extractPrice(cost) <= 0) {
      cost = cookCost > 0 ? cookCost + '元' : '-';
    }

    // 所需食材数组：只保留有效的非空字符串
    const requiredIngredients: string[] = [];
    const rawIng = r['requiredIngredients'];
    if (rawIng !== undefined && rawIng !== null && Array.isArray(rawIng)) {
      const arr: Object[] = rawIng as Object[];
      for (const item of arr) {
        const s = RecommendService.cleanString(item);
        if (s !== '') {
          requiredIngredients.push(s);
        }
      }
    }

    return {
      name: name,
      icon: icon,
      time: time,
      cost: cost,
      difficulty: difficulty,
      hasIngredients: hasIngredients,
      cookTime: cookTime,
      deliveryTime: deliveryTime,
      cookCost: cookCost,
      deliveryCost: deliveryCost,
      reason: reason,
      requiredIngredients: requiredIngredients
    } as AiDish;
  }

  /**
   * 批量规范化 AI 返回的菜品列表，并剔除没有菜名的条目
   */
  private static sanitizeDishes(rawDishes: object[]): AiDish[] {
    const result: AiDish[] = [];
    for (const raw of rawDishes) {
      const dish = RecommendService.normalizeDish(raw);
      if (dish.name !== '') {
        result.push(dish);
      }
    }
    return result;
  }

  // ========== AI 路径统一后校验（P0：与本地路径同一套硬性约束）==========

  // 忌口关键词表：AI 返回的菜名/食材/理由命中任意关键词即视为违反对应忌口
  // 口径与本地菜品库的 isSpicy/isSeafood/isVegetarian 字段保持一致：
  // - 青椒在库中标为非辣，故辣味只认"辣/辣椒/花椒"等词，不单独认"椒"字（避免误杀青椒牛肉丝等）
  // - 咖喱在库中多数标为非辣（日式咖喱饭等），故不认"咖喱"
  // - 蛋类在库中标为非素（蛋炒饭等 isVegetarian=false），故素食忌口要认"蛋"
  // - 牛奶/奶油类在库中标为素食（燕麦牛奶杯 isVegetarian=true），故素食忌口不认奶制品
  private static spicyKeywords: string[] = ['辣', '辣椒', '椒麻', '花椒', '藤椒', '剁椒', '豆瓣', '泡椒', '干锅', '水煮', '火锅', '香辣', '麻辣'];

  private static seafoodKeywords: string[] = ['虾', '蟹', '鱼', '贝', '蛤', '蛏', '蚝', '鲍', '鳗', '鱿鱼', '章鱼', '墨鱼', '金枪', '海带', '紫菜', '虾皮', '海蜇', '海苔', '海米', '虾仁'];

  private static meatKeywords: string[] = ['肉', '鸡', '鸭', '鹅', '猪', '牛', '羊', '蛋', '排骨', '五花', '肘子', '火腿', '培根', '香肠', '腊肉'];

  /**
   * 检测文本是否包含任一关键词
   */
  private static containsAnyKeyword(text: string, keywords: string[]): boolean {
    for (const kw of keywords) {
      if (text.indexOf(kw) >= 0) {
        return true;
      }
    }
    return false;
  }

  /**
   * AI 返回菜品的统一后校验（P0 修复）：
   * 1. 忌口一票否决 — 忌口是用户声明的硬性约束，不信任模型自觉：
   *    对菜名+所需食材+推荐理由做关键词扫描，违反任一所选忌口即整道菜剔除
   * 2. hasIngredients 重算 — 不信任模型自报的 boolean，统一用本地同款 60% 食材匹配规则
   * 3. 超预算标注 — 超出预算档位的菜品在理由中追加提示（软约束只标注不剔除，避免误杀）
   * 4. 去重+截断 — 按菜名去重，最多保留前 3 道
   */
  private static validateAiDishes(conditions: RecommendConditions, dishes: AiDish[]): AiDish[] {
    const validated: AiDish[] = [];
    const usedNames = new Set<string>();

    for (const dish of dishes) {
      // 1. 去重
      if (dish.name === '' || usedNames.has(dish.name)) {
        continue;
      }

      // 2. 忌口一票否决：扫描菜名+食材+理由（菜名干净但食材/理由暴露违规内容的也剔除）
      const scanText = dish.name + ' ' + dish.requiredIngredients.join(' ') + ' ' + dish.reason;
      let rejected = false;
      for (const d of conditions.diet) {
        if (d === 0 && RecommendService.containsAnyKeyword(scanText, RecommendService.spicyKeywords)) {
          console.warn('AI 菜品违反忌口[不吃辣]，已剔除：' + dish.name);
          rejected = true;
          break;
        }
        if (d === 1 && scanText.indexOf('香菜') >= 0) {
          console.warn('AI 菜品违反忌口[不吃香菜]，已剔除：' + dish.name);
          rejected = true;
          break;
        }
        if (d === 2 && RecommendService.containsAnyKeyword(scanText, RecommendService.seafoodKeywords)) {
          console.warn('AI 菜品违反忌口[不吃海鲜]，已剔除：' + dish.name);
          rejected = true;
          break;
        }
        if (d === 3 && RecommendService.containsAnyKeyword(scanText, RecommendService.meatKeywords)) {
          console.warn('AI 菜品违反忌口[素食]，已剔除：' + dish.name);
          rejected = true;
          break;
        }
      }
      if (rejected) {
        continue;
      }

      // 3. hasIngredients 重算：统一采用本地同款 60% 食材匹配规则
      if (conditions.hasNoIngredients) {
        dish.hasIngredients = false;
      } else {
        dish.hasIngredients = RecommendService.hasRequiredIngredients(
          dish.requiredIngredients, conditions.ingredients
        );
      }

      // 4. 超预算标注（软约束，仅提示不剔除）
      // 档位上限：0=10元以内, 1=20元以内, 2=50元以内, 3=不设限（跳过）
      const budgetCap = [10, 20, 50, 0];
      if (conditions.budget >= 0 && conditions.budget < 3 && dish.cookCost > 0 && dish.cookCost > budgetCap[conditions.budget]) {
        dish.reason = dish.reason + '（注意：自做成本约' + dish.cookCost + '元，超出预算档位，供参考）';
      }

      usedNames.add(dish.name);
      validated.push(dish);
      if (validated.length >= 3) {
        break;
      }
    }

    return validated;
  }

  // ========== 本地推荐引擎 ==========

  /**
   * 克隆本地菜品为独立副本（P0 修复）
   * 本地引擎打分时会改写 hasIngredients/reason 等字段，直接在 LOCAL_DISHES 共享对象上修改
   * 会污染全局菜品库，导致多次推荐、不同条件之间互相串数据。所有打分逻辑必须基于副本进行。
   */
  private static cloneLocalDish(dish: LocalDish): LocalDish {
    const copy: LocalDish = {
      name: dish.name,
      icon: dish.icon,
      time: dish.time,
      cost: dish.cost,
      difficulty: dish.difficulty,
      hasIngredients: dish.hasIngredients,
      cookTime: dish.cookTime,
      deliveryTime: dish.deliveryTime,
      cookCost: dish.cookCost,
      deliveryCost: dish.deliveryCost,
      reason: dish.reason,
      requiredIngredients: dish.requiredIngredients.slice(),
      category: dish.category,
      isSpicy: dish.isSpicy,
      hasCoriander: dish.hasCoriander,
      isSeafood: dish.isSeafood,
      isVegetarian: dish.isVegetarian,
      timeRank: dish.timeRank,
      budgetRank: dish.budgetRank
    } as LocalDish;
    return copy;
  }

  /**
   * 判断用户是否拥有做某道菜所需的全部食材
   * 匹配规则：每道菜所需的"核心食材"中，用户拥有的数量 ≥ 总数量的 60% 即视为有食材
   */
  private static hasRequiredIngredients(
    required: string[],
    userIngredients: string[]
  ): boolean {
    if (userIngredients.length === 0) return false;
    if (required.length === 0) return true; // 无特殊食材要求（如速食产品）

    let matchCount = 0;
    for (const req of required) {
      if (userIngredients.indexOf(req) >= 0) {
        matchCount++;
      }
    }

    // 只要满足 60% 以上的核心食材就算有（允许少量缺少，reason 里提示补买）
    const threshold = Math.max(1, Math.ceil(required.length * 0.6));
    return matchCount >= threshold;
  }

  /**
   * 计算食材匹配度（0~1）
   */
  private static ingredientMatchRate(
    required: string[],
    userIngredients: string[]
  ): number {
    if (required.length === 0) return 1;
    if (userIngredients.length === 0) return 0;

    let matchCount = 0;
    for (const req of required) {
      if (userIngredients.indexOf(req) >= 0) {
        matchCount++;
      }
    }
    return matchCount / required.length;
  }

  /**
   * 本地推荐：根据用户条件从本地菜品库中智能筛选
   * 策略：
   * 1. 先筛选符合口味分类的菜品
   * 2. 排除违反忌口的菜品
   * 3. 根据时间和预算打分排序
   * 4. 动态计算食材匹配度（取代静态 hasIngredients）
   * 5. 食材匹配度高的菜品加分
   * 6. 保证多样性（不重复风格）
   * 7. 如果同分类不够，从其他分类补充
   */
  public static getLocalRecommendations(
    category: number,
    time: number,
    budget: number,
    diet: number[],
    ingredients: string[] = [],
    hasNoIngredients: boolean = false,
    priority: string = 'balanced',
    profile: UserPreferenceProfile | null = null
  ): AiDish[] {
    // 构建忌口过滤函数
    const noSpicy = diet.indexOf(0) >= 0;      // 不吃辣
    const noCoriander = diet.indexOf(1) >= 0;  // 不吃香菜
    const noSeafood = diet.indexOf(2) >= 0;    // 不吃海鲜
    const isVegetarian = diet.indexOf(3) >= 0;  // 素食

    // 筛选出可选菜品（忌口是硬约束，后续任何补充逻辑都不允许绕过这一步）
    const dietSafeDishes = LOCAL_DISHES.filter(dish => {
      // 忌口过滤
      if (noSpicy && dish.isSpicy) return false;
      if (noCoriander && dish.hasCoriander) return false;
      if (noSeafood && dish.isSeafood) return false;
      if (isVegetarian && !dish.isVegetarian) return false;
      return true;
    });

    // P0 修复：克隆为独立副本再打分 — 打分过程会改写 hasIngredients/reason，
    // 若直接在 LOCAL_DISHES 共享对象上修改会污染全局菜品库（不同条件推荐互相串数据）
    const candidates = dietSafeDishes.map(dish => RecommendService.cloneLocalDish(dish));

    // 为每个菜品计算匹配分数
    const scoredDishes = candidates.map(dish => {
      let score = 0;

      // ===== 根据优先级分配权重 =====
      let weightCategory = 40;
      let weightTime = 30;
      let weightBudget = 30;
      let weightIngredient = 30;

      if (priority === 'time_budget') {
        // ⏰💰 时间和预算优先：时间/预算权重极高，食材几乎不考虑
        weightCategory = 20;
        weightTime = 60;
        weightBudget = 60;
        weightIngredient = 5;
      } else if (priority === 'ingredients') {
        // 🥬 食材优先：食材匹配度占绝对主导，时间/预算几乎不考虑
        weightCategory = 20;
        weightTime = 5;
        weightBudget = 5;
        weightIngredient = 100;
      }
      // 'balanced' 使用默认值（各维度均衡）

      // 分类匹配
      if (dish.category === category) {
        score += weightCategory;
      } else {
        // 不同分类也有机会被选到（跨分类补充）
        score += Math.round(weightCategory * 0.25);
      }

      // 时间匹配
      if (time < 0) {
        score += weightTime; // 无时间限制
      } else if (dish.timeRank === time) {
        score += weightTime; // 精确匹配
      } else if (dish.timeRank < time) {
        score += Math.round(weightTime * 0.5); // 比要求的更快
      } else {
        score += Math.round(weightTime * 0.15); // 比要求的慢
      }

      // 预算匹配
      if (budget < 0) {
        score += weightBudget; // 无预算限制
      } else if (dish.budgetRank <= budget) {
        score += weightBudget; // 在预算内
      } else {
        score += Math.round(weightBudget * 0.15); // 超出预算
      }

      // ===== 食材匹配（动态计算，取代静态 hasIngredients） =====
      let matchRate = 0;
      if (hasNoIngredients) {
        // 用户声明没有任何食材 — 所有菜品 hasIngredients = false，不添加食材加分
        dish.hasIngredients = false;
        matchRate = 0;
      } else {
        matchRate = RecommendService.ingredientMatchRate(
          dish.requiredIngredients, ingredients
        );
        dish.hasIngredients = RecommendService.hasRequiredIngredients(
          dish.requiredIngredients, ingredients
        );
      }

      // 食材加分（按匹配比例折算）
      score += Math.round(matchRate * weightIngredient);

      // ===== 各优先级专属加成 =====
      if (priority === 'time_budget' && time >= 0 && budget >= 0) {
        // ⏰💰 时间和预算优先：超值加成 — 又快又便宜的额外奖分
        if (dish.timeRank < time) {
          score += (time - dish.timeRank) * 20; // 比时限更快，每档+20
        }
        if (dish.budgetRank < budget) {
          score += (budget - dish.budgetRank) * 15; // 比预算更省，每档+15
        }
      } else if (priority === 'ingredients') {
        // 🥬 食材优先：全匹配加成 & 无食材时推荐极简菜
        if (!hasNoIngredients && matchRate >= 1) {
          score += 40; // 所有食材家中已有，大幅加分
        } else if (matchRate >= 0.75) {
          score += 15; // 大部分食材已有，小幅加分
        }
        if (hasNoIngredients) {
          // 用户没食材：推荐所需食材最少的菜（越简单，买起来越省事）
          const ingredientCount = dish.requiredIngredients.length;
          score += Math.max(0, (10 - ingredientCount)) * 5;
        }
      } else if (priority === 'balanced') {
        // ⚖️ 综合推荐：全面均衡加成 — 各维度都好的菜额外加分
        let goodCount = 0;
        if (dish.category === category) goodCount++;
        if (dish.timeRank <= time || time < 0) goodCount++;
        if (dish.budgetRank <= budget || budget < 0) goodCount++;
        if (matchRate >= 0.6) goodCount++;
        if (goodCount >= 3) {
          score += 25; // 至少3个维度表现良好，加分
        }
        if (goodCount >= 4) {
          score += 15; // 4个维度都好，额外再加分
        }
      }

      // P1 偏好加成：用户收藏过的菜品小幅加分（不足以逆转上面的硬约束差距）
      if (profile !== null && profile.favoritedDishes.indexOf(dish.name) >= 0) {
        score += 15;
      }

      return { dish: dish, score: score } as ScoredDish;
    });

    // 按分数从高到低排序
    scoredDishes.sort((a, b) => b.score - a.score);

    // ===== 使用刷新偏移量实现"换一批"轮换推荐 =====
    // 偏移量由 Recommend.ets 中"换一批"按钮在调用前 +3 维护，此处仅读取不修改
    // 这样切换标签页再回来时，偏移不变，菜品保持一致

    // 选择结果：优先同分类，其次从高分中选取，确保多样性
    const primaryDishes = scoredDishes.filter(item => item.dish.category === category);
    const secondaryDishes = scoredDishes.filter(item => item.dish.category !== category);

    const selected: AiDish[] = [];
    const usedNames = new Set<string>();

    // 辅助函数：从池中按偏移量轮选取，确保每次"换一批"拿到不同的菜
    const pickUnique = (pool: ScoredDish[], count: number): void => {
      if (pool.length === 0) return;
      const offset = RecommendService.refreshOffsetMap[priority] % pool.length;
      for (let i = 0; i < pool.length; i++) {
        if (selected.length >= count) break;
        const idx = (offset + i) % pool.length;
        const item = pool[idx];
        if (usedNames.has(item.dish.name)) continue;
        usedNames.add(item.dish.name);
        selected.push(item.dish as AiDish);
      }
    };

    // 先选同分类（优先推荐），从偏移位置开始取
    pickUnique(primaryDishes, 5);

    // 不够的话从高分异类补充
    pickUnique(secondaryDishes, 5);

    // 如果还是不够（极端情况：忌口合规的菜品总数不足 3 道），从忌口合规候选中补充
    // P0 修复：原实现从 LOCAL_DISHES 全量补充，会绕过忌口过滤（如用户不吃辣仍可能被推辣菜）；
    // 现在只允许从忌口合规的 candidates 中补充，合规菜品不足时如实返回实际数量，绝不违反忌口
    if (selected.length < 3 && candidates.length > 0) {
      const fallbackOffset = RecommendService.refreshOffsetMap[priority] % candidates.length;
      for (let i = 0; i < candidates.length; i++) {
        if (selected.length >= 3) break;
        const idx = (fallbackOffset + i) % candidates.length;
        const dish = candidates[idx];
        if (usedNames.has(dish.name)) continue;
        usedNames.add(dish.name);
        selected.push(dish as AiDish);
      }
    }

    // 取前3道
    const result = selected.slice(0, 3);

    // 根据食材匹配情况，给每道菜配上有说服力的推荐理由
    result.forEach((dish, index) => {
      const localDish = LOCAL_DISHES.find(d => d.name === dish.name);

      if (hasNoIngredients) {
        // ===== 用户没有任何食材：生成"无需特殊食材"类理由 =====
        const noIngredientReasons = [
          '家里暂时没食材也没关系！这道菜只需基础调料就能做，快去采购吧',
          '无需特殊食材，基础调味料就能搞定，非常适合现买现做',
          '这道菜对食材要求低，简单买几样就能做出美味一餐'
        ];
        dish.reason = noIngredientReasons[index] || noIngredientReasons[0];
        dish.hasIngredients = false;
      } else if (localDish && ingredients.length > 0) {
        const matchRate = RecommendService.ingredientMatchRate(
          localDish.requiredIngredients, ingredients
        );
        const missingIngredients = localDish.requiredIngredients.filter(
          r => ingredients.indexOf(r) < 0
        );

        if (matchRate >= 0.8) {
          dish.reason = `你家里已有大部分食材，${missingIngredients.length > 0 ? `只需补买${missingIngredients.join('、')}就能做！` : '直接开做！'}`;
        } else if (matchRate >= 0.4) {
          dish.reason = `家里有部分食材，再买${missingIngredients.join('、')}就能复刻这道美味`;
        } else {
          // 保留原始推荐理由
          if (!dish.reason || dish.reason.length === 0) {
            const reasons = [
              '这道菜非常适合你今天的条件，快试试吧！',
              '简单易做又美味，强烈推荐！',
              '营养美味，轻松搞定一餐'
            ];
            dish.reason = reasons[index] || reasons[0];
          }
        }
      }
    });

    return result;
  }

  /**
   * 偏好缓存是否过期（用户收藏/取消收藏后设为 true，下次推荐时重新加载偏好）
   */
  public static profileDirty: boolean = false;

  /**
   * 标记偏好缓存需要刷新（用户收藏/取消收藏后调用）
   */
  public static markProfileDirty(): void {
    RecommendService.profileDirty = true;
  }
}
