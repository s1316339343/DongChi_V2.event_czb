// ========== AI 推荐联网模块（Ollama，OpenAI 兼容接口）==========
// AI 接入：由 CloudAiService 统一管理（云端大模型 + 检索增强重排 + 自动降级）
// （持久化 + 局域网自动发现 + 地址失效自愈），见 AiModelService.ets
import { common } from '@kit.AbilityKit';
import { AiDish, LocalDish, RecommendConditions, RecommendResult, ScoredDish, CATEGORY_NAMES, TIME_LABELS, BUDGET_LABELS, DIET_LABELS } from './DishTypes';
import { LOCAL_DISHES } from './LocalDishes';
import { CloudAiService, CandidateDish, RerankItem, RerankResult } from './CloudAiService';
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

  /**
   * 送入云端重排的候选数量上限。
   * 太少会让模型没有语义发挥空间，太多则显著抬高 token 成本，12 是性价比折中。
   */
  private static readonly MAX_RERANK_CANDIDATES: number = 12;

  /**
   * 读取某优先级的轮换偏移量。
   * priority 是 string（public API 无法用联合类型约束），直接索引 Record 可能得到
   * undefined 并参与取模运算产生 NaN，最终导致取到 undefined 菜品而抛异常，
   * 被上层 catch 后静默降级为内置兜底菜。这里统一兜底为 0。
   */
  private static offsetFor(priority: string): number {
    const value: number | undefined = RecommendService.refreshOffsetMap[priority];
    if (value === undefined || !Number.isFinite(value) || value < 0) {
      return 0;
    }
    return value;
  }

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
      // 只返回空画像，不写入缓存：否则一次瞬时 DB 异常会把"无个性化"永久缓存下来，
      // 直到用户去收藏/决策页面触发 markProfileDirty 才能恢复
      console.error('加载偏好画像失败，本次使用空画像', JSON.stringify(error));
      return emptyProfile;
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
    priority: string = 'balanced',
    userNote: string = ''
  ): Promise<RecommendResult> {
    // P1：加载用户偏好画像（收藏 + 历史决策），用于本地加分与云端重排的上下文
    const profile = await RecommendService.loadProfile(context);
    const conditions = RecommendService.buildConditions(
      category, time, budget, diet, ingredients, hasNoIngredients);

    // ===== 第一段：本地结构化检索（确定性，硬约束在此收敛） =====
    const retrieved = RecommendService.retrieveCandidates(conditions, priority, profile);

    // 检索结果为空说明条件过严，直接降级到本地宽松挑选
    if (retrieved.length === 0) {
      const local = RecommendService.pickAndExplain(retrieved, conditions, priority, profile);
      return {
        dishes: local,
        isLocal: true,
        failReason: '没有同时满足全部忌口与预算条件的菜品，已放宽口味方向'
      } as RecommendResult;
    }

    // AI 开关关闭或未配置密钥 → 纯本地
    await CloudAiService.init(context);
    const enabled = await CloudAiService.isEnabled();
    const configured = await CloudAiService.isConfigured();
    if (!enabled || !configured) {
      const local = RecommendService.pickAndExplain(retrieved, conditions, priority, profile);
      return {
        dishes: local,
        isLocal: true,
        failReason: enabled ? '尚未配置云端 AI 密钥' : '云端 AI 已在设置中关闭'
      } as RecommendResult;
    }

    // ===== 第二段：云端语义重排 + 个性化理由（只在合规候选内排序） =====
    try {
      const candidates = RecommendService.toCandidateList(retrieved, conditions);
      const summary = RecommendService.buildProfileSummary(profile);

      await CloudAiService.init(context);
      const rerank: RerankResult = await CloudAiService.rerankCandidates(
        conditions, candidates, summary, userNote);

      if (!rerank.ok || rerank.items.length === 0) {
        throw new Error(rerank.failReason.length > 0 ? rerank.failReason : '云端重排未返回有效结果');
      }

      const dishes = RecommendService.mergeRerankWithLocal(retrieved, rerank.items, conditions);
      if (dishes.length === 0) {
        throw new Error('云端重排结果未能匹配到任何候选菜品');
      }
      // 成功：清空降级提示标记，让下次真失败时仍能提示
      CloudAiService.resetDegradeNotice();
      return { dishes: dishes, isLocal: false } as RecommendResult;
    } catch (error) {
      // ===== 第三段：降级（断网 / 额度用尽 / 输出不合规） =====
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      console.error('云端 AI 重排失败，降级本地排序', errMsg);
      const local = RecommendService.pickAndExplain(retrieved, conditions, priority, profile);
      return {
        dishes: local,
        isLocal: true,
        failReason: errMsg
      } as RecommendResult;
    }
  }

  /**
   * 第一段：本地结构化检索。
   *
   * 职责是**把不可信的生成空间收敛成可信的候选集**：忌口一票否决、
   * 预算与时间纳入评分，最终只把少量高相关候选交给云端模型重排。
   * 这样模型既无法推荐用户忌口的菜，也无法编造菜品库里不存在的菜。
   *
   * @returns 按本地评分降序的候选（含打分，供挑选与解释使用）
   */
  private static retrieveCandidates(
    conditions: RecommendConditions,
    priority: string,
    profile: UserPreferenceProfile | null
  ): ScoredDish[] {
    const category = conditions.category;
    const time = conditions.time;
    const budget = conditions.budget;
    const ingredients = conditions.ingredients;
    const hasNoIngredients = conditions.hasNoIngredients;

    const noSpicy = conditions.diet.indexOf(0) >= 0;
    const noCoriander = conditions.diet.indexOf(1) >= 0;
    const noSeafood = conditions.diet.indexOf(2) >= 0;
    const isVegetarian = conditions.diet.indexOf(3) >= 0;

    // 忌口与预算属硬约束：任何后续补充逻辑都不允许绕过
    const dietSafeDishes = LOCAL_DISHES.filter(dish => {
      if (noSpicy && dish.isSpicy) return false;
      if (noCoriander && dish.hasCoriander) return false;
      if (noSeafood && dish.isSeafood) return false;
      if (isVegetarian && !dish.isVegetarian) return false;
      if (budget >= 0 && dish.budgetRank > budget) return false;
      return true;
    });

    // 权重只依赖 priority，放在循环外计算
    let weightCategory = 40;
    let weightTime = 30;
    let weightBudget = 30;
    let weightIngredient = 30;
    if (priority === 'time_budget') {
      weightCategory = 20;
      weightTime = 60;
      weightBudget = 60;
      weightIngredient = 5;
    } else if (priority === 'ingredients') {
      weightCategory = 20;
      weightTime = 5;
      weightBudget = 5;
      weightIngredient = 100;
    }

    const scored: ScoredDish[] = dietSafeDishes.map(dish => {
      let score = 0;

      if (dish.category === category) {
        score += weightCategory;
      } else {
        score += Math.round(weightCategory * 0.25);
      }

      if (time < 0) {
        score += weightTime;
      } else if (dish.timeRank === time) {
        score += weightTime;
      } else if (dish.timeRank < time) {
        score += Math.round(weightTime * 0.5);
      } else {
        score += Math.round(weightTime * 0.15);
      }

      if (budget < 0) {
        score += weightBudget;
      } else if (dish.budgetRank <= budget) {
        score += weightBudget;
      } else {
        score += Math.round(weightBudget * 0.15);
      }

      let matchRate = 0;
      if (hasNoIngredients) {
        matchRate = 0;
      } else {
        matchRate = RecommendService.ingredientMatchRate(dish.requiredIngredients, ingredients);
      }
      score += Math.round(matchRate * weightIngredient);

      if (priority === 'time_budget' && time >= 0 && budget >= 0) {
        if (dish.timeRank < time) {
          score += (time - dish.timeRank) * 20;
        }
        if (dish.budgetRank < budget) {
          score += (budget - dish.budgetRank) * 15;
        }
      } else if (priority === 'ingredients') {
        if (!hasNoIngredients && matchRate >= 1) {
          score += 40;
        } else if (matchRate >= 0.75) {
          score += 15;
        }
        if (hasNoIngredients) {
          score += Math.max(0, (10 - dish.requiredIngredients.length)) * 5;
        }
      } else if (priority === 'balanced') {
        let goodCount = 0;
        if (dish.category === category) goodCount++;
        if (dish.timeRank <= time || time < 0) goodCount++;
        if (dish.budgetRank <= budget || budget < 0) goodCount++;
        if (matchRate >= 0.6) goodCount++;
        if (goodCount >= 3) score += 25;
        if (goodCount >= 4) score += 15;
      }

      if (profile !== null && profile.favoritedDishes.indexOf(dish.name) >= 0) {
        score += 15;
      }

      return { dish: dish, score: score } as ScoredDish;
    });

    scored.sort((a, b) => b.score - a.score);
    return scored;
  }

  /** 把打分结果转成送给云端重排的精简候选结构 */
  private static toCandidateList(
    scored: ScoredDish[],
    conditions: RecommendConditions
  ): CandidateDish[] {
    const limit = Math.min(scored.length, RecommendService.MAX_RERANK_CANDIDATES);
    const list: CandidateDish[] = [];
    for (let i = 0; i < limit; i++) {
      const item = scored[i];
      const dish = item.dish;
      let owned = 0;
      if (!conditions.hasNoIngredients) {
        for (const req of dish.requiredIngredients) {
          if (conditions.ingredients.indexOf(req) >= 0) {
            owned++;
          }
        }
      }
      list.push({
        name: dish.name,
        icon: dish.icon,
        category: CATEGORY_NAMES[dish.category] || '',
        cookTime: dish.cookTime,
        cookCost: dish.cookCost,
        deliveryTime: dish.deliveryTime,
        deliveryCost: dish.deliveryCost,
        requiredIngredients: dish.requiredIngredients,
        ownedCount: owned,
        localScore: item.score
      } as CandidateDish);
    }
    return list;
  }

  /** 生成给模型的用户画像摘要（自然语言，控制长度） */
  private static buildProfileSummary(profile: UserPreferenceProfile | null): string {
    if (profile === null) {
      return '';
    }
    const parts: string[] = [];
    if (profile.favoritedDishes.length > 0) {
      const favs = profile.favoritedDishes.slice(0, 6);
      parts.push('收藏过' + favs.join('、'));
    }
    let maxIdx = -1;
    let maxVal = 0;
    for (let i = 0; i < profile.categoryCounts.length; i++) {
      if (profile.categoryCounts[i] > maxVal) {
        maxVal = profile.categoryCounts[i];
        maxIdx = i;
      }
    }
    if (maxIdx >= 0 && maxVal > 0) {
      parts.push('最常选的口味方向是' + (CATEGORY_NAMES[maxIdx] || ''));
    }
    return parts.join('；');
  }

  /**
   * 把云端重排结果合并回本地数据。
   *
   * 关键设计：**只采纳模型的排序与理由，所有数值（时间/成本/食材）仍取自本地数据**。
   * 这样即使模型对价格或耗时的判断有偏差，也不会污染最终展示的事实信息。
   */
  private static mergeRerankWithLocal(
    scored: ScoredDish[],
    items: RerankItem[],
    conditions: RecommendConditions
  ): AiDish[] {
    const byName = new Map<string, LocalDish>();
    for (const item of scored) {
      byName.set(item.dish.name, item.dish);
    }

    const result: AiDish[] = [];
    for (const item of items) {
      const local = byName.get(item.name);
      if (local === undefined) {
        continue;
      }
      const dish = RecommendService.cloneLocalDish(local);
      dish.reason = item.reason;
      // 食材是否齐备由本地规则判定，不由模型决定
      dish.hasIngredients = conditions.hasNoIngredients ? false :
        RecommendService.hasRequiredIngredients(dish.requiredIngredients, conditions.ingredients);
      result.push(dish as AiDish);
    }
    return result;
  }

  /**
   * 本地挑选 + 模板理由（降级路径与本地推荐共用）。
   *
   * 先按偏移量做"换一批"轮换，再用本地食材匹配情况生成理由，
   * 全程不改写 LOCAL_DISHES 中的共享对象。
   */
  private static pickAndExplain(
    scored: ScoredDish[],
    conditions: RecommendConditions,
    priority: string,
    profile: UserPreferenceProfile | null
  ): AiDish[] {
    const hasNoIngredients = conditions.hasNoIngredients;
    const category = conditions.category;
    const ingredients = conditions.ingredients;

    const selected: LocalDish[] = [];
    const usedNames = new Set<string>();

    const pickUnique = (predicate: (d: LocalDish) => boolean, count: number): void => {
      let eligible = 0;
      for (let i = 0; i < scored.length; i++) {
        if (predicate(scored[i].dish)) eligible++;
      }
      if (eligible === 0) return;
      const offset = RecommendService.offsetFor(priority) % eligible;
      let seen = 0;
      for (let i = 0; i < scored.length; i++) {
        if (selected.length >= count) break;
        const dish = scored[i].dish;
        if (!predicate(dish)) continue;
        const idx = seen;
        seen++;
        if (idx < offset) continue;
        if (usedNames.has(dish.name)) continue;
        usedNames.add(dish.name);
        selected.push(dish);
      }
    };

    pickUnique((d: LocalDish) => d.category === category, 5);
    pickUnique((d: LocalDish) => d.category !== category, 5);

    if (selected.length < 3 && scored.length > 0) {
      const offset = RecommendService.offsetFor(priority) % scored.length;
      for (let i = 0; i < scored.length; i++) {
        if (selected.length >= 3) break;
        const dish = scored[(offset + i) % scored.length].dish;
        if (usedNames.has(dish.name)) continue;
        usedNames.add(dish.name);
        selected.push(dish);
      }
    }

    const result = selected.slice(0, 3).map(d => RecommendService.cloneLocalDish(d));

    result.forEach((dish, index) => {
      if (hasNoIngredients) {
        const noIngredientReasons = [
          '家里暂时没食材也没关系！这道菜只需基础调料就能做，快去采购吧',
          '无需特殊食材，基础调味料就能搞定，非常适合现买现做',
          '这道菜对食材要求低，简单买几样就能做出美味一餐'
        ];
        dish.reason = noIngredientReasons[index % noIngredientReasons.length];
        dish.hasIngredients = false;
      } else if (ingredients.length > 0) {
        const matchRate = RecommendService.ingredientMatchRate(dish.requiredIngredients, ingredients);
        const missing = dish.requiredIngredients.filter(r => ingredients.indexOf(r) < 0);
        if (matchRate >= 0.8) {
          dish.reason = missing.length > 0
            ? '你家里已有大部分食材，只需补买' + missing.join('、') + '就能做！'
            : '所需食材家里全都有，直接开做！';
        } else if (matchRate >= 0.4) {
          dish.reason = '家里有部分食材，再买' + missing.join('、') + '就能复刻这道美味';
        } else if (!dish.reason || dish.reason.length === 0) {
          const reasons = [
            '这道菜非常适合你今天的条件，快试试吧！',
            '简单易做又美味，强烈推荐！',
            '营养美味，轻松搞定一餐'
          ];
          dish.reason = reasons[index % reasons.length];
        }
      }
    });

    return result as AiDish[];
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
  // ========== 响应解析与失败分类 ==========

  /**
   * 解析 API 返回的 JSON 数据
   */
  /**
   * 将 AI 失败原因分类为用户可读的中文描述
   */
  /**
   * 从字符串中提取价格数字（如 "8元" → 8，"约15元" → 15），失败返回 0
   */
  /**
   * 清洗字符串字段：null/undefined/"null"/"undefined"/"-" 等异常值统一返回空字符串
   */
  /**
   * 安全地将字段转为价格数字，失败返回 0（页面显示为 "-"）
   */
  /**
   * 规范化单个 AI 返回菜品：
   * - 清洗字符串字段，杜绝 null/"-" 等异常值出现在 UI
   * - 校验价格字段：cost 与 cookCost 互相同步；无法得到有效价格时置为 0 / "-"
   */
  /**
   * 批量规范化 AI 返回的菜品列表，并剔除没有菜名的条目
   */
  // ========== AI 路径统一后校验（P0：与本地路径同一套硬性约束）==========

  // ========== 本地推荐引擎 ==========

  /**
   * 克隆本地菜品为独立副本（P0 修复）
   * 本地引擎会改写 hasIngredients/reason 等字段，直接在 LOCAL_DISHES 共享对象上修改
   * 会污染全局菜品库，导致多次推荐、不同条件之间互相串数据。
   * 现在只在最终选中菜品时克隆（约 3 次/次推荐），打分阶段只读取原对象。
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
   * 本地推荐（降级路径）：复用同一套结构化检索与挑选逻辑，
   * 仅使用本地模板理由，不依赖云端。
   */
  /**
   * 检索结果的**可测试入口**。
   *
   * 本地检索是"硬约束收敛"的唯一执行者，它决定了模型能看到什么，
   * 因此必须能被单元测试直接验证（忌口零泄漏、预算不越界、候选数量受控）。
   * 生产代码请通过 getRecommendations / getLocalRecommendations 间接调用。
   */
  static retrieveCandidatesForTest(
    category: number,
    time: number,
    budget: number,
    diet: number[],
    ingredients: string[],
    hasNoIngredients: boolean,
    priority: string
  ): ScoredDish[] {
    const conditions = RecommendService.buildConditions(
      category, time, budget, diet, ingredients, hasNoIngredients);
    return RecommendService.retrieveCandidates(conditions, priority, null);
  }

  /**
   * 送给云端重排的候选转换（可测试入口，用于验证候选数量与结构）
   */
  static toCandidateListForTest(
    category: number,
    time: number,
    budget: number,
    diet: number[],
    ingredients: string[],
    hasNoIngredients: boolean
  ): CandidateDish[] {
    const conditions = RecommendService.buildConditions(
      category, time, budget, diet, ingredients, hasNoIngredients);
    const scored = RecommendService.retrieveCandidates(conditions, 'balanced', null);
    return RecommendService.toCandidateList(scored, conditions);
  }

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
    const conditions = RecommendService.buildConditions(
      category, time, budget, diet, ingredients, hasNoIngredients);
    const scored = RecommendService.retrieveCandidates(conditions, priority, profile);
    return RecommendService.pickAndExplain(scored, conditions, priority, profile);
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
