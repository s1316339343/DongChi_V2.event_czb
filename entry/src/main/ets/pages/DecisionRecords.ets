/**
 * DecisionRecords - 我的决策记录页面
 *
 * 使用 relationalStore 本地数据库查询历史决策记录
 * 纯本地，无任何联网功能
 */
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { DbService, DecisionRecord } from '../service/DbService';
import { promptAction } from '@kit.ArkUI';
import { RecommendService } from '../service/RecommendService';

interface DisplayDish {
  name: string;
  icon: string;
}

/** 推荐页跳转参数 */
interface RecommendParams {
  category: number;
  time: number;
  budget: number;
  diet: number[];
  ingredients: string[];
  hasNoIngredients: boolean;
}

@Entry
@Component
struct DecisionRecords {
  @State showContent: boolean = false;
  @State records: DecisionRecord[] = [];
  @State isLoading: boolean = true;
  /** 记录 id → 解析后的菜品列表。缓存起来，避免每帧在 ForEach 里重新 JSON.parse */
  @State parsedDishMap: Map<number, DisplayDish[]> = new Map();

  aboutToAppear(): void {
    // 仅做进入动画，数据加载延迟到 onPageShow 统一处理
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  /**
   * 每次页面显示时刷新数据（包括首次打开和从其他页面返回时）
   */
  onPageShow(): void {
    const context = getContext(this);
    this.loadRecords(context);
  }

  /**
   * 从本地数据库加载决策记录
   */
  async loadRecords(context: common.Context): Promise<void> {
    this.isLoading = true;
    try {
      const records = await DbService.getAllDecisions(context);
      this.records = records;
      // 一次性解析所有记录的菜品，供渲染直接读取
      const cache: Map<number, DisplayDish[]> = new Map();
      for (const record of records) {
        if (record.id !== undefined) {
          cache.set(record.id, this.parseDishNames(record.results));
        }
      }
      this.parsedDishMap = cache;
    } catch (error) {
      console.error('加载决策记录失败：', JSON.stringify(error));
      this.records = [];
      this.parsedDishMap = new Map();
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 读取某条记录已缓存的菜品列表
   */
  dishListOf(record: DecisionRecord): DisplayDish[] {
    if (record.id === undefined) {
      return [];
    }
    return this.parsedDishMap.get(record.id) || [];
  }

  /**
   * 格式化时间
   */
  formatDate(isoStr: string): string {
    try {
      const date = new Date(isoStr);
      const y = date.getFullYear();
      const m = String(date.getMonth() + 1).padStart(2, '0');
      const d = String(date.getDate()).padStart(2, '0');
      const h = String(date.getHours()).padStart(2, '0');
      const min = String(date.getMinutes()).padStart(2, '0');
      return `${y}/${m}/${d} ${h}:${min}`;
    } catch (_) {
      return isoStr;
    }
  }

  /**
   * 从 results JSON 中解析出菜品名列表（显示用）
   */
  parseDishNames(resultsJson: string): DisplayDish[] {
    try {
      const dishes: Array<Record<string, string>> = JSON.parse(resultsJson) as Array<Record<string, string>>;
      if (Array.isArray(dishes)) {
        return dishes.map((d: Record<string, string>) => ({
          name: d['name'] || '',
          icon: d['icon'] || '🍽️',
        }) as DisplayDish);
      }
    } catch (_) {
      // 解析失败返回空
    }
    return [];
  }

  /**
   * 删除一条决策记录
   */
  async deleteRecord(record: DecisionRecord): Promise<void> {
    if (record.id === undefined) {
      return;
    }
    const context = getContext(this);
    try {
      await DbService.deleteDecision(context, record.id);
      // 删除决策会连带删除其关联收藏（见 DbService.deleteDecision），
      // 因此偏好画像缓存必须同步失效，否则推荐会继续用已删除的数据
      RecommendService.markProfileDirty();
      // 刷新列表
      await this.loadRecords(context);
    } catch (error) {
      console.error('删除决策记录失败：', JSON.stringify(error));
    }
  }

  /**
   * 确认删除全部记录
   */
  confirmDeleteAll(): void {
    promptAction.showDialog({
      title: '删除全部记录',
      message: '确定要删除所有决策记录吗？此操作不可恢复。',
      buttons: [
        {
          text: '取消',
          color: '#999999',
        },
        {
          text: '全部删除',
          color: '#FF4444',
        },
      ],
    }).then((result) => {
      if (result.index === 1) {
        this.deleteAllRecords();
      }
    }).catch(() => {});
  }

  /**
   * 删除全部决策记录
   */
  async deleteAllRecords(): Promise<void> {
    const context = getContext(this);
    try {
      await DbService.deleteAllDecisions(context);
      RecommendService.markProfileDirty();
      await this.loadRecords(context);
    } catch (error) {
      console.error('删除全部决策记录失败：', JSON.stringify(error));
    }
  }

  /**
   * 生成决策记录的摘要字符串
   */
  getRecordSummary(record: DecisionRecord): string {
    const parts: string[] = [record.categoryName];
    if (record.timeLabel) parts.push('⏰' + record.timeLabel);
    if (record.budgetLabel) parts.push('💰' + record.budgetLabel);
    if (record.dietLabels && record.dietLabels.length > 0) {
      parts.push('❌' + record.dietLabels.join('、'));
    }
    if (record.hasNoIngredients) {
      parts.push('🈚 无食材');
    } else if (record.ingredients && record.ingredients.length > 0) {
      parts.push('🥬' + record.ingredients.length + '种食材');
    }
    return parts.join(' | ');
  }

  /**
   * 确认删除弹窗
   */
  confirmDelete(record: DecisionRecord): void {
    promptAction.showDialog({
      title: '删除记录',
      message: '确定要删除这条决策记录吗？关联的收藏也将被删除。',
      buttons: [
        {
          text: '取消',
          color: '#999999',
        },
        {
          text: '删除',
          color: '#FF4444',
        },
      ],
    }).then((result) => {
      if (result.index === 1) {
        this.deleteRecord(record);
      }
    }).catch(() => {});
  }

  /**
   * 携带决策条件跳转到推荐页面，实现重复操作
   */
  navigateToRecommend(record: DecisionRecord): void {
    const params: RecommendParams = {
      category: record.category,
      time: record.time,
      budget: record.budget,
      diet: record.diet,
      ingredients: record.ingredients,
      hasNoIngredients: record.hasNoIngredients,
    };
    router.pushUrl({
      url: 'pages/Recommend',
      params: params,
    });
  }

  build() {
    Column() {
      // ========== 顶部导航栏 ==========
      Row() {
        Text('←')
          .fontSize(22)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            router.back();
          })

        Blank()

        Text('我的决策记录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Blank()

        // 占位 / 全部删除
        if (this.records.length > 0) {
          Text('全部删除')
            .fontSize(13)
            .fontColor('#FF4444')
            .onClick(() => {
              this.confirmDeleteAll();
            })
        } else {
          Text('  ')
            .fontSize(22)
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .alignItems(VerticalAlign.Center)

      // ========== 内容区 ==========
      if (this.isLoading) {
        // 加载中
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color($r('app.color.app_primary'))
            .margin({ bottom: 16 })

          Text('加载中...')
            .fontSize(15)
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .height('70%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.records.length === 0) {
        // 空状态
        Column() {
          Text('📋')
            .fontSize(64)
            .margin({ bottom: 16 })

          Text('暂无决策记录')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })

          Text('完成一次决策后，记录会显示在这里')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
        }
        .width('100%')
        .height('70%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 记录列表
        Scroll() {
          Column() {
            ForEach(this.records, (record: DecisionRecord, index: number) => {
              this.recordCard(record, index)
            }, (record: DecisionRecord, index: number) => (record.id ?? index).toString())
          }
          .width('100%')
.padding({ left: 20, right: 20, bottom: 36 })
        }
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  recordCard(record: DecisionRecord, index: number) {
    Column() {
      // 时间 + 删除按钮
      Row() {
        Row() {
          Text('🕐')
            .fontSize(14)
            .margin({ right: 4 })
          Text(this.formatDate(record.createdAt))
            .fontSize(13)
            .fontColor($r('app.color.text_light'))
        }

        Blank()

        Text('删除')
          .fontSize(12)
          .fontColor('#FF4444')
          .padding({ left: 10, right: 10, top: 3, bottom: 3 })
          .backgroundColor('rgba(255,68,68,0.08)')
          .borderRadius(8)
          .onClick(() => {
            this.confirmDelete(record);
          })
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 条件摘要
      Text(this.getRecordSummary(record))
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .width('100%')
        .margin({ bottom: 8 })
        .lineHeight(18)

      // 推荐菜品列表
      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Center,
      }) {
        ForEach(this.dishListOf(record), (dish: DisplayDish) => {
          Row() {
            Text(dish.icon || '🍽️')
              .fontSize(16)
              .margin({ right: 4 })
            Text(dish.name)
              .fontSize(13)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
          }
          .padding({ top: 4, bottom: 4, left: 10, right: 10 })
          .backgroundColor('rgba(255,107,53,0.06)')
          .borderRadius(12)
          .border({ width: 1, color: 'rgba(255,107,53,0.15)' })
          .margin({ right: 6, bottom: 6 })
        }, (dish: DisplayDish) => dish.name)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(14)
    .padding(16)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
    .margin({ top: index > 0 ? 12 : 0 })
    .onClick(() => {
      this.navigateToRecommend(record);
    })
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 20 })
    .animation({ duration: 400 + index * 80, curve: Curve.Smooth })
  }
}
