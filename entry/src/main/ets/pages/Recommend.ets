import router from '@ohos.router';
// import { common } from '@kit.AbilityKit';  // [单机化] 不再需要 openLink 等联网功能
// import bundleManager from '@ohos.bundle.bundleManager';  // [单机化] 移除第三方应用检测
import { promptAction } from '@kit.ArkUI';
import { RecommendService } from '../service/RecommendService';
import { AiDish } from '../service/DishTypes';
import { DbService, DecisionRecord, FavoriteDish } from '../service/DbService';
import { RecommendSpeaker, DishOverview } from '../service/TtsService';

// 菜品数据结构
class Dish {
  name: string = '';
  icon: string = '';
  time: string = '';
  cost: string = '';
  difficulty: string = '';
  hasIngredients: boolean = false;
  cookTime: string = '';
  deliveryTime: string = '';
  cookCost: number = 0;
  deliveryCost: number = 0;
  reason: string = '';
  requiredIngredients: string[] = [];

  constructor(name: string, icon: string, time: string, cost: string,
    difficulty: string, hasIngredients: boolean, cookTime: string,
    deliveryTime: string, cookCost: number, deliveryCost: number,
    reason: string = '', requiredIngredients: string[] = []) {
    this.name = name;
    this.icon = icon;
    this.time = time;
    this.cost = cost;
    this.difficulty = difficulty;
    this.hasIngredients = hasIngredients;
    this.cookTime = cookTime;
    this.deliveryTime = deliveryTime;
    this.cookCost = cookCost;
    this.deliveryCost = deliveryCost;
    this.reason = reason;
    this.requiredIngredients = requiredIngredients;
  }

  // 从 AI 返回数据创建 Dish
  static fromAiDish(ai: AiDish): Dish {
    return new Dish(
      ai.name, ai.icon, ai.time, ai.cost, ai.difficulty,
      ai.hasIngredients, ai.cookTime, ai.deliveryTime,
      ai.cookCost, ai.deliveryCost, ai.reason,
      ai.requiredIngredients || []
    );
  }
}

// 决策结果菜品数据（用于保存到数据库的 JSON 序列化）
interface DishResultData {
  name: string;
  icon: string;
  time: string;
  cost: string;
  difficulty: string;
  hasIngredients: boolean;
  cookTime: string;
  deliveryTime: string;
  cookCost: number;
  deliveryCost: number;
  reason: string;
  requiredIngredients: string[];
}

// 用于导航传递的菜品数据结构
interface NavDishData {
  name: string;
  icon: string;
  time: string;
  cost: string;
  difficulty: string;
  hasIngredients: boolean;
  cookTime: string;
  deliveryTime: string;
  cookCost: number;
  deliveryCost: number;
  reason: string;
  requiredIngredients: string[];
}

@Entry
@Component
struct Recommend {
  // 接收参数
  @State category: number = 0;
  @State time: number = -1;
  @State budget: number = -1;
  @State diet: number[] = [];
  @State ingredients: string[] = [];
  @State hasNoIngredients: boolean = false;

  // 推荐菜品数据
  @State dishes: Dish[] = [];
  @State animTrigger: boolean = false;
  @State isLoading: boolean = true;
  @State isLocalRecommend: boolean = false;
  @State priorityMode: string = 'balanced'; // 'balanced' | 'time_budget' | 'ingredients'
  @State priorityActive: string = 'balanced'; // 实际生效的优先级

  // 收藏状态映射
  @State favoritedMap: Record<string, boolean> = {};
  // 当前决策记录ID（保存后赋值，用于收藏关联）
  private currentDecisionId: number = -1;
  // P2 修复：本次会话是否已写入决策记录 — 只有首次推荐写一条，
  // "换一批"/切换优先级属于同一决策的多次刷新，不再重复写库（此前每次换一批都新增一条，
  // 导致决策日记和仪表盘统计被浏览行为灌水）
  private decisionRecordSaved: boolean = false;

  // ====== TTS 语音播报 ======
  @State ttsSpeaking: boolean = false;
  private recommendSpeaker: RecommendSpeaker = new RecommendSpeaker();
  /** 语音播报世代计数器 — 每次新请求递增，旧异步任务检测到不匹配则放弃播报 */
  private ttsGeneration: number = 0;

  categories: string[] = ['家常清淡', '重口过瘾', '健康轻食', '快餐速食'];
  timeLabels: string[] = ['10分钟搞定', '30分钟', '1小时以上'];
  budgetLabels: string[] = ['10元以内', '20元以内', '50元以内', '不设限'];
  dietLabels: string[] = ['不吃辣', '不吃香菜', '不吃海鲜', '素食'];

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params['category'] !== undefined) this.category = params['category'] as number;
      if (params['time'] !== undefined) this.time = params['time'] as number;
      if (params['budget'] !== undefined) this.budget = params['budget'] as number;
      if (params['diet'] !== undefined) this.diet = params['diet'] as number[];
      if (params['ingredients'] !== undefined) this.ingredients = params['ingredients'] as string[];
      if (params['hasNoIngredients'] !== undefined) this.hasNoIngredients = params['hasNoIngredients'] as boolean;
    }

    // 初始化本地数据库
    this.initDatabase();

    // P2：每次进入页面重置"已写决策记录"标记（仅首次推荐写一条）
    this.decisionRecordSaved = false;

    // 通过 AI 获取推荐（每次页面进入都重置偏移，确保全新推荐）
    this.fetchAIRecommendations(undefined, true);
  }

  /**
   * 初始化本地数据库
   */
  async initDatabase(): Promise<void> {
    try {
      const context = getContext(this);
      await DbService.init(context);
    } catch (error) {
      console.error('数据库初始化失败：', JSON.stringify(error));
    }
  }

  /**
   * 自动语音播报推荐结果
   * @param generation 调用时的世代号，用于检测并发失效
   */
  async autoSpeakRecommendations(generation: number): Promise<void> {
    if (this.dishes.length === 0) {
      return;
    }
    // 如果世代已过期（新的优先级切换已经发生），放弃播报
    if (generation !== this.ttsGeneration) {
      return;
    }
    try {
      this.ttsSpeaking = true;
      const overviews: DishOverview[] = [];
      for (let i: number = 0; i < this.dishes.length; i++) {
        const d = this.dishes[i];
        const item: DishOverview = {
          name: d.name,
          reason: d.reason,
          cost: d.cost,
          time: d.time,
        };
        overviews.push(item);
      }
      // 播报前二次检查世代，防止 await 期间被新请求覆盖
      if (generation !== this.ttsGeneration) {
        this.ttsSpeaking = false;
        return;
      }
      await this.recommendSpeaker.speakRecommendations(
        overviews,
        this.categories[this.category] || '家常清淡'
      );
    } catch (_) {
      console.error('语音播报失败');
    } finally {
      // 只在仍然是自己世代时才清零，避免覆盖后续世代的 ttsSpeaking
      if (generation === this.ttsGeneration) {
        this.ttsSpeaking = false;
      }
    }
  }

  /**
   * 手动切换语音播报（点击喇叭图标）
   */
  async toggleTts(): Promise<void> {
    if (this.ttsSpeaking) {
      // 正在播报则停止
      await this.recommendSpeaker.stop();
      this.ttsSpeaking = false;
    } else {
      // 未播报则开始 — 手动触发时也递增世代，确保与最新一次播报对应
      this.ttsGeneration++;
      await this.autoSpeakRecommendations(this.ttsGeneration);
    }
  }

  /**
   * 页面销毁时释放 TTS 资源
   */
  aboutToDisappear(): void {
    this.recommendSpeaker.release();
  }

  /**
   * 调用 DeepSeek API 获取 AI 推荐（失败后自动降级为本地推荐）
   */
  async fetchAIRecommendations(priority?: string, resetOffset: boolean = false): Promise<void> {
    this.isLoading = true;
    this.animTrigger = false;
    if (priority) {
      this.priorityActive = priority;
    }

    // 递增播报世代 + 强制停止当前语音播报（无论 ttsSpeaking 状态，防止竞态条件）
    this.ttsGeneration++;
    try {
      await this.recommendSpeaker.stop();
    } catch (_) { /* 忽略 stop 异常 */ }
    this.ttsSpeaking = false;

    // 重置偏移量 — 仅切换优先级时重置（确保全新推荐），换一批时保留偏移实现轮换
    if (resetOffset) {
      RecommendService.refreshOffsetMap[this.priorityActive] = 0;
    }

    try {
      const result = await RecommendService.getRecommendations(
        getContext(this), this.category, this.time, this.budget, this.diet, this.ingredients, this.hasNoIngredients, this.priorityActive
      );

      this.isLocalRecommend = result.isLocal;

      // 进入本地推荐模式时弹窗告知用户具体原因
      if (this.isLocalRecommend) {
        this.showLocalFallbackDialog(result.failReason || 'AI 推荐服务暂不可用');
      }

      // 转换为 Dish 对象
      this.dishes = result.dishes.map(ai => Dish.fromAiDish(ai));

      // 入场动画
      animateTo({ duration: 600, curve: Curve.Smooth }, () => {
        this.animTrigger = true;
      });
    } catch (error) {
      // 兜底：降级到本地推荐引擎（尊重用户的所有选择条件）
      this.isLocalRecommend = true;
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      console.error('AI 推荐失败，降级本地推荐', errMsg);
      try {
        const result = RecommendService.getLocalRecommendations(
          this.category, this.time, this.budget, this.diet, this.ingredients, this.hasNoIngredients, this.priorityActive
        );
        this.dishes = result.map(ai => Dish.fromAiDish(ai));
      } catch (_) {
        // 极端情况下的硬编码兜底
        this.dishes = [
          new Dish('番茄炒蛋', '🍅', '15分钟', '8元', '⭐', true, '15分钟', '25分钟', 8, 18,
            '经典家常菜，简单快手，人人都爱'),
          new Dish('清炒时蔬', '🥬', '10分钟', '5元', '⭐', false, '10分钟', '20分钟', 5, 15,
            '健康清爽，营养丰富'),
          new Dish('蛋炒饭', '🍚', '15分钟', '6元', '⭐', true, '15分钟', '20分钟', 6, 16,
            '剩饭变身，方便又美味')
        ];
      }
      // 极端情况：AI 与本地推荐均失败，弹窗告知用户
      this.showLocalFallbackDialog('AI 服务与本地推荐均出现异常，已使用内置基础菜品兜底');
      animateTo({ duration: 600, curve: Curve.Smooth }, () => {
        this.animTrigger = true;
      });
    } finally {
      this.isLoading = false;
      // 保存本次决策记录到本地数据库
      this.saveCurrentDecision();
      // 加载各菜品的收藏状态
      this.loadFavoriteStatus();
      // 语音播报推荐结果
      this.autoSpeakRecommendations(this.ttsGeneration);
    }
  }

  /**
   * 保存当前决策记录到本地数据库
   */
  async saveCurrentDecision(): Promise<void> {
    // P2：同一次页面会话只写一条决策记录 — "换一批"/切换优先级是同一决策的多次刷新，不重复写库
    if (this.decisionRecordSaved) {
      return;
    }
    if (this.dishes.length === 0) {
      return;
    }
    try {
      const context = getContext(this);
      // 构建 results JSON
      const resultsData: DishResultData[] = this.dishes.map(d => ({
        name: d.name,
        icon: d.icon,
        time: d.time,
        cost: d.cost,
        difficulty: d.difficulty,
        hasIngredients: d.hasIngredients,
        cookTime: d.cookTime,
        deliveryTime: d.deliveryTime,
        cookCost: d.cookCost,
        deliveryCost: d.deliveryCost,
        reason: d.reason,
        requiredIngredients: d.requiredIngredients,
      } as DishResultData));
      const record: DecisionRecord = {
        category: this.category,
        categoryName: this.categories[this.category] || '家常清淡',
        time: this.time,
        timeLabel: this.time >= 0 ? (this.timeLabels[this.time] || '') : '',
        budget: this.budget,
        budgetLabel: this.budget >= 0 ? (this.budgetLabels[this.budget] || '') : '',
        diet: this.diet,
        dietLabels: this.diet.map(i => this.dietLabels[i] || ''),
        ingredients: this.ingredients,
        hasNoIngredients: this.hasNoIngredients,
        results: JSON.stringify(resultsData),
        createdAt: '',
      };
      this.currentDecisionId = await DbService.saveDecision(context, record);
      this.decisionRecordSaved = true;
    } catch (error) {
      console.error('保存决策记录失败：', JSON.stringify(error));
    }
  }

  /**
   * 加载各菜品的收藏状态
   */
  async loadFavoriteStatus(): Promise<void> {
    try {
      const context = getContext(this);
      const map: Record<string, boolean> = {};
      for (const dish of this.dishes) {
        const isFav = await DbService.isFavorited(context, dish.name);
        map[dish.name] = isFav;
      }
      this.favoritedMap = map;
    } catch (error) {
      console.error('加载收藏状态失败：', JSON.stringify(error));
    }
  }

  /**
   * 切换收藏状态
   */
  async toggleFavorite(dish: Dish): Promise<void> {
    try {
      const context = getContext(this);
      const isFav = this.favoritedMap[dish.name] || false;
      if (isFav) {
        await DbService.removeFavorite(context, dish.name);
        this.favoritedMap[dish.name] = false;
      } else {
        const favDish: FavoriteDish = {
          dishName: dish.name,
          dishIcon: dish.icon,
          time: dish.time,
          cost: dish.cost,
          difficulty: dish.difficulty,
          hasIngredients: dish.hasIngredients,
          cookTime: dish.cookTime,
          deliveryTime: dish.deliveryTime,
          cookCost: dish.cookCost,
          deliveryCost: dish.deliveryCost,
          reason: dish.reason,
          decisionId: this.currentDecisionId >= 0 ? this.currentDecisionId : undefined,
          createdAt: '',
        };
        const id = await DbService.addFavorite(context, favDish);
        if (id > 0) {
          this.favoritedMap[dish.name] = true;
        }
      }
      // P1：收藏状态变化，失效偏好画像缓存，下次推荐立即反映本次变更
      RecommendService.markProfileDirty();
    } catch (error) {
      console.error('切换收藏状态失败：', JSON.stringify(error));
    }
  }

  /**
   * 获取条件摘要文字
   */
  getConditionSummary(): string {
    const parts: string[] = [];
    parts.push(this.categories[this.category] || '家常清淡');

    if (this.time >= 0 && this.time < this.timeLabels.length) {
      parts.push('⏰' + this.timeLabels[this.time]);
    }

    if (this.budget >= 0 && this.budget < this.budgetLabels.length) {
      parts.push('💰' + this.budgetLabels[this.budget]);
    }

    if (this.diet.length > 0) {
      const dietTexts = this.diet.map(i => this.dietLabels[i]).join('、');
      parts.push('❌' + dietTexts);
    }

    if (this.hasNoIngredients && this.ingredients.length === 0) {
      parts.push('🈚 没有食材');
    } else if (this.ingredients.length > 0) {
      parts.push('🥬' + this.ingredients.length + '种食材');
    }

    return parts.join(' | ');
  }

  /**
   * AI 失败降级本地推荐时的原因提示弹窗
   */
  async showLocalFallbackDialog(reason: string): Promise<void> {
    try {
      await promptAction.showDialog({
        title: '已切换本地推荐模式',
        message: 'AI 推荐未能成功：' + reason +
          '\n\n已自动切换至本地推荐模式，从内置菜品库中为你匹配推荐，请放心使用。',
        buttons: [
          {
            text: '知道了',
            color: '#FF6B35'
          }
        ]
      });
    } catch (error) {
      console.error('本地模式提示弹窗失败：', JSON.stringify(error));
    }
  }

  /**
   * 自己做花费显示（无有效价格时显示 -）
   */
  formatCookCost(cost: number): string {
    return cost > 0 ? '¥' + cost : '-';
  }

  /**
   * 外卖花费显示（无有效价格时显示 -）
   */
  formatDeliveryCost(cost: number): string {
    return cost > 0 ? '约 ¥' + cost : '-';
  }

  /**
   * 菜品卡片头部元信息（难度/时间/成本），成本缺失（cost 为 "-"）时不显示成本段
   */
  dishMetaText(dish: Dish): string {
    let s = dish.difficulty + '  ' + dish.time;
    if (dish.cost !== '' && dish.cost !== '-') {
      s += '  ～' + dish.cost;
    }
    return s;
  }

  build() {
    Column() {
      // 顶部
      Row() {
        this.stepDot(0, true)
        this.stepLine(true)
        this.stepDot(1, true)
        this.stepLine(true)
        this.stepDot(2, true)
      }
      .width('60%')
      .margin({ top: 40, bottom: 8 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 标题 + 语音播报按钮
      Row() {
        Text('AI 为你精选推荐')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        // 语音播报按钮
        if (!this.isLoading && this.dishes.length > 0) {
          Text(this.ttsSpeaking ? '🔊' : '🔈')
            .fontSize(24)
            .margin({ left: 8, right: 4 })
            .onClick(async () => {
              await this.toggleTts();
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 4, bottom: 4 })
      .padding({ left: 20, right: 20 })
      .alignItems(VerticalAlign.Center)

      // 条件回显
      Text(this.getConditionSummary())
        .fontSize(13)
        .fontColor($r('app.color.text_light'))
        .margin({ bottom: 20 })
        .textAlign(TextAlign.Center)
        .padding({ left: 16, right: 16 })

      // 本地推荐提示条（降级模式时显示）
      if (this.isLocalRecommend) {
        Row() {
          Row() {
            Text('📍')
              .fontSize(16)
              .margin({ right: 8 })
            Column() {
              Text('本地推荐模式')
                .fontSize(13)
                .fontWeight(FontWeight.Medium)
                .fontColor('#8B6914')
              Text('AI 服务暂不可用，已切换至本地匹配')
                .fontSize(11)
                .fontColor('#B8860B')
                .margin({ top: 1 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)

          Text('本地库·500道')
            .fontSize(10)
            .fontColor('#DAA520')
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor('rgba(218,165,32,0.15)')
            .borderRadius(10)
        }
        .width('100%')
        .padding({ top: 10, bottom: 10, left: 16, right: 16 })
        .backgroundColor('rgba(255,193,7,0.10)')
        .borderRadius(12)
        .border({ width: 1, color: 'rgba(218,165,32,0.35)' })
        .margin({ bottom: 16 })
        .padding({ left: 16, right: 16 })
      }

      // ===== 推荐优先级切换按钮 =====
      if (!this.isLoading && this.dishes.length > 0) {
        Row() {
          // 以时间和预算为准
          Row() {
            Text('⏰💰')
              .fontSize(14)
              .margin({ right: 4 })
            Text('时间和预算优先')
              .fontSize(12)
              .fontWeight(this.priorityActive === 'time_budget' ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.priorityActive === 'time_budget' ? Color.White : $r('app.color.app_primary'))
          }
          .padding({ top: 5, bottom: 5, left: 12, right: 12 })
          .backgroundColor(this.priorityActive === 'time_budget' ? $r('app.color.app_primary') : 'rgba(255,107,53,0.08)')
          .borderRadius(16)
          .margin({ right: 8 })
          .onClick(() => {
            if (this.priorityActive !== 'time_budget') {
              this.priorityMode = 'time_budget';
              this.fetchAIRecommendations('time_budget');
            }
          })

          // 以食材为准
          Row() {
            Text('🥬')
              .fontSize(14)
              .margin({ right: 4 })
            Text('食材优先')
              .fontSize(12)
              .fontWeight(this.priorityActive === 'ingredients' ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.priorityActive === 'ingredients' ? Color.White : $r('app.color.app_primary'))
          }
          .padding({ top: 5, bottom: 5, left: 12, right: 12 })
          .backgroundColor(this.priorityActive === 'ingredients' ? $r('app.color.app_primary') : 'rgba(255,107,53,0.08)')
          .borderRadius(16)
          .margin({ right: 8 })
          .onClick(() => {
            if (this.priorityActive !== 'ingredients') {
              this.priorityMode = 'ingredients';
              this.fetchAIRecommendations('ingredients');
            }
          })

          // 平衡推荐（默认）
          Row() {
            Text('⚖️')
              .fontSize(14)
              .margin({ right: 4 })
            Text('综合推荐')
              .fontSize(12)
              .fontWeight(this.priorityActive === 'balanced' ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.priorityActive === 'balanced' ? Color.White : $r('app.color.app_primary'))
          }
          .padding({ top: 5, bottom: 5, left: 12, right: 12 })
          .backgroundColor(this.priorityActive === 'balanced' ? $r('app.color.app_primary') : 'rgba(255,107,53,0.08)')
          .borderRadius(16)
          .onClick(() => {
            if (this.priorityActive !== 'balanced') {
              this.priorityMode = 'balanced';
              this.fetchAIRecommendations('balanced');
            }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
      }

      // 加载中状态
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color($r('app.color.app_primary'))
            .margin({ bottom: 16 })

          Text('AI正在为你思考推荐...')
            .fontSize(15)
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .height('60%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 菜品推荐列表
        Scroll() {
          Column() {
            ForEach(this.dishes, (dish: Dish, index: number) => {
              this.dishCard(dish, index)
            }, (item: Dish) => item.name)
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
        }
        .edgeEffect(EdgeEffect.Spring)
        .height('60%')

        // 底部按钮
        Button() {
          Row() {
            Text('换一批')
              .fontSize(16)
              .fontColor($r('app.color.app_primary'))
            Text('↻')
              .fontSize(18)
              .fontColor($r('app.color.app_primary'))
              .margin({ left: 6 })
          }
          .alignItems(VerticalAlign.Center)
        }
        .width('50%')
        .height(44)
        .backgroundColor(Color.White)
        .borderRadius(22)
        .border({ width: 1.5, color: $r('app.color.app_primary') })
        .margin({ bottom: 16 })
        .onClick(() => {
          // 先偏移，再刷新 — 确保换一批时拿到不同的菜
          RecommendService.refreshOffsetMap[this.priorityActive] += 3;
          this.fetchAIRecommendations(undefined, false);
        })

        Button() {
          Text('重新选择条件')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
        }
        .backgroundColor(Color.Transparent)
        .margin({ bottom: 8 })
        .onClick(() => {
          router.back();
        })
        .enabled(!this.isLoading)

        Button() {
          Text('🔄 重新开始')
            .fontSize(12)
            .fontColor($r('app.color.text_light'))
        }
        .backgroundColor(Color.Transparent)
        .margin({ bottom: 56 })
        .onClick(() => {
          router.clear();
          router.pushUrl({ url: 'pages/Index' });
        })
        .enabled(!this.isLoading)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  dishCard(dish: Dish, index: number) {
    Column() {
      // 菜品头部：图标 + 名称 + 难度 + 收藏按钮
      Row() {
        Text(dish.icon)
          .fontSize(32)
          .margin({ right: 12 })

        Column() {
          Text(dish.name)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          // AI推荐理由
          if (dish.reason.length > 0) {
            Text('💡 ' + dish.reason)
              .fontSize(12)
              .fontColor('#FF8C00')
              .margin({ top: 2 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          Text(this.dishMetaText(dish))
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 收藏按钮
        Text(this.favoritedMap[dish.name] ? '❤️' : '🤍')
          .fontSize(24)
          .margin({ left: 8 })
          .onClick(async () => {
            await this.toggleFavorite(dish);
          })
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 食材状态提示（当 hasNoIngredients=true 时，所有菜品都视为缺食材）
      if (this.hasNoIngredients) {
        // 用户没有任何食材 — 无论 AI/本地返回什么，都显示"需要购买食材"
        Text('🛒 需要购买食材（家里暂无食材）')
          .fontSize(12)
          .fontColor($r('app.color.text_light'))
          .margin({ bottom: 4 })
      } else if (dish.hasIngredients) {
        Text('✅ 家中常备食材，可以直接做')
          .fontSize(12)
          .fontColor('#4CAF50')
          .margin({ bottom: 4 })
      } else {
        Text('🛒 需要购买食材')
          .fontSize(12)
          .fontColor($r('app.color.text_light'))
          .margin({ bottom: 4 })
      }

      // 自己做 vs 外卖对比
      Row() {
        // 自己做
        Column() {
          Text('👨‍🍳 自己做')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Text(dish.cookTime)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })

          Text(this.formatCookCost(dish.cookCost))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#4CAF50')
            .margin({ top: 2 })

          Button() {
            Text('看教程')
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(80)
          .height(28)
          .backgroundColor('#4CAF50')
          .borderRadius(14)
          .margin({ top: 8 })
          .onClick(async () => {
            await this.openTutorial(dish);
          })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(10)

        // VS
        Text('VS')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_light'))

        // 点外卖
        Column() {
          Text('🛵 点外卖')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Text(dish.deliveryTime)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })

          Text(this.formatDeliveryCost(dish.deliveryCost))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.app_primary'))
            .margin({ top: 2 })

          Button() {
            Text('点外卖')
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(80)
          .height(28)
          .backgroundColor($r('app.color.app_primary'))
          .borderRadius(14)
          .margin({ top: 8 })
          .onClick(async () => {
            await this.openDelivery(dish);
          })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(10)
      }
      .width('100%')
      .padding({ top: 12 })
      .alignItems(VerticalAlign.Center)
      // 需要购买食材时显示"一键导出购物清单"按钮
      if (!dish.hasIngredients || this.hasNoIngredients) {
        Button() {
          Row() {
            Text('🛒')
              .fontSize(16)
              .margin({ right: 6 })
            Text('一键导出购物清单')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height(40)
        .backgroundColor($r('app.color.app_primary'))
        .borderRadius(20)
        .shadow({ radius: 6, color: 'rgba(255,107,53,0.30)', offsetY: 3 })
        .margin({ top: 12 })
        .onClick(() => {
          this.navigateToShoppingListForDish(dish);
        })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(16)
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetY: 3 })
    .margin({ bottom: 16 })
    .opacity(this.animTrigger ? 1 : 0)
    .translate({ y: this.animTrigger ? 0 : 40 + index * 20 })
    .animation({ duration: 500 + index * 150, curve: Curve.Smooth })
    .onClick(async () => {
      await this.openTutorial(dish);
    })
  }

  @Builder
  stepDot(index: number, active: boolean) {
    Circle()
      .width(10)
      .height(10)
      .fill(active ? $r('app.color.app_primary') : '#E0E0E0')
  }

  @Builder
  stepLine(active: boolean) {
    Line()
      .width(40)
      .height(2)
      .stroke(active ? $r('app.color.app_primary') : '#E0E0E0')
      .strokeWidth(2)
      .margin({ left: 6, right: 6 })
  }

  // ========== [单机化] 第三方应用安装检测已移除 ==========
  // 原 isAppInstalledBySchemes() 方法—通过 URL Scheme 检测外部 App 是否安装
  // 单机模式下不再需要跳转第三方平台，此方法已废弃

  // ========== [单机化] 第三方平台跳转对话框已移除 ==========
  // 原 showRedirectDialog() — 跳转到下厨房等第三方网站
  // 单机模式下不再需要跳转第三方平台，此方法已废弃

  // 导航到菜品详情页
  async openTutorial(dish: Dish): Promise<void> {
    const navItem: NavDishData = {
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
      requiredIngredients: dish.requiredIngredients,
    };
    router.pushUrl({
      url: 'pages/DishDetail',
      params: {
        name: navItem.name,
        icon: navItem.icon,
        reason: navItem.reason,
        difficulty: navItem.difficulty,
        time: navItem.time,
        cost: navItem.cost,
        requiredIngredients: JSON.stringify(navItem.requiredIngredients),
      }
    });
  }

  // [单机化] "点外卖" — 联网功能暂未开放
  async openDelivery(dish: Dish): Promise<void> {
    try {
      await promptAction.showDialog({
        title: '联网功能暂未开发',
        message: '联网功能暂未开发，敬请期待',
        buttons: [
          {
            text: '好的',
            color: '#4CAF50'
          }
        ]
      });
    } catch (_) {
      console.error('对话框取消或出错');
    }
  }

  /**
   * 导航到购物清单页面（针对单个菜品）
   */
  navigateToShoppingListForDish(dish: Dish): void {
    const navItem: NavDishData = {
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
      requiredIngredients: dish.requiredIngredients,
    };
    router.pushUrl({
      url: 'pages/ShoppingList',
      params: {
        dishes: JSON.stringify([navItem]),
        hasNoIngredients: this.hasNoIngredients,
        userIngredients: JSON.stringify(this.ingredients),
      }
    });
  }

  /**
   * 导航到购物清单页面（全部菜品）
   */
  navigateToShoppingList(): void {
    // 将当前推荐菜品数据序列化后传递
    const dishesData: NavDishData[] = this.dishes.map(d => {
      const navItem: NavDishData = {
        name: d.name,
        icon: d.icon,
        time: d.time,
        cost: d.cost,
        difficulty: d.difficulty,
        hasIngredients: d.hasIngredients,
        cookTime: d.cookTime,
        deliveryTime: d.deliveryTime,
        cookCost: d.cookCost,
        deliveryCost: d.deliveryCost,
        reason: d.reason,
        requiredIngredients: d.requiredIngredients,
      };
      return navItem;
    });
    router.pushUrl({
      url: 'pages/ShoppingList',
      params: {
        dishes: JSON.stringify(dishesData),
        hasNoIngredients: this.hasNoIngredients,
        userIngredients: JSON.stringify(this.ingredients),
      }
    });
  }
}
