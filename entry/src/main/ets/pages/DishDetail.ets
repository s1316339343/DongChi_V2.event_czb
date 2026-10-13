import router from '@ohos.router';
import { DISH_DETAIL_DATA } from '../service/DishDetailData';
import { DishDetailInfo, NutritionInfo } from '../service/DishTypes';

interface DetailParams {
  name: string;
  icon: string;
  requiredIngredients: string[];
  reason: string;
  difficulty: string;
  time: string;
  cost: string;
}

@Entry
@Component
struct DishDetail {
  @State dishName: string = '';
  @State dishIcon: string = '';
  @State dishReason: string = '';
  @State dishDifficulty: string = '';
  @State dishTime: string = '';
  @State dishCost: string = '';
  @State requiredIngredients: string[] = [];
  @State detail: DishDetailInfo | null = null;
  @State stepsExpanded: boolean = false;
  @State selectedStep: number = -1;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.dishName = params['name'] as string || '';
      this.dishIcon = params['icon'] as string || '🍽️';
      this.dishReason = params['reason'] as string || '';
      this.dishDifficulty = params['difficulty'] as string || '';
      this.dishTime = params['time'] as string || '';
      this.dishCost = params['cost'] as string || '';
      const ingsStr = params['requiredIngredients'] as string || '[]';
      try {
        this.requiredIngredients = JSON.parse(ingsStr) as string[];
      } catch (_) {
        this.requiredIngredients = [];
      }
      // 从预置数据中查找详情
      this.detail = DISH_DETAIL_DATA[this.dishName] || null;
      if (this.detail) {
        this.stepsExpanded = true;
      }
    }
  }

  /**
   * 元信息文本（难度/时间/成本），成本缺失（cost 为 "-" 或 null 等）时不显示成本段
   */
  metaText(): string {
    let s = this.dishDifficulty + '  ' + this.dishTime;
    if (this.dishCost !== '' && this.dishCost !== '-' && this.dishCost.toLowerCase() !== 'null') {
      s += '  ～' + this.dishCost;
    }
    return s;
  }

  build() {
    Column() {
      // 顶部返回栏
      Row() {
        Text('← 返回')
          .fontSize(16)
          .fontColor($r('app.color.app_primary'))
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column() {
          // ===== 菜品头部 =====
          Row() {
            Text(this.dishIcon)
              .fontSize(64)
              .margin({ right: 16 })

            Column() {
              Text(this.dishName)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              if (this.dishReason.length > 0) {
                Text('💡 ' + this.dishReason)
                  .fontSize(13)
                  .fontColor('#FF8C00')
                  .margin({ top: 4 })
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }

              Text(this.metaText())
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 6 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .margin({ bottom: 16 })

          // ===== 食材清单 =====
          if (this.requiredIngredients.length > 0) {
            Column() {
              Row() {
                Text('🥬 所需食材')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                Text('(' + this.requiredIngredients.length + '种)')
                  .fontSize(13)
                  .fontColor($r('app.color.text_light'))
                  .margin({ left: 8 })
              }
              .margin({ bottom: 12 })

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.requiredIngredients, (ing: string) => {
                  Text(ing)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .padding({ top: 6, bottom: 6, left: 14, right: 14 })
                    .backgroundColor('#F5F5F5')
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                })
              }
              .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          }

          // ===== 步骤 =====
          if (this.detail) {
            Column() {
              Row() {
                Text('📝 烹饪步骤')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)

                Text(this.stepsExpanded ? '收起' : '展开')
                  .fontSize(13)
                  .fontColor($r('app.color.app_primary'))
                  .margin({ left: 12 })
                  .onClick(() => {
                    this.stepsExpanded = !this.stepsExpanded;
                  })
              }
              .margin({ bottom: 12 })

              if (this.stepsExpanded) {
                Column() {
                  ForEach(this.detail.steps, (step: string, index: number) => {
                    Row() {
                      // 步骤编号
                      Text('' + (index + 1))
                        .fontSize(14)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.White)
                        .width(26)
                        .height(26)
                        .textAlign(TextAlign.Center)
                        .backgroundColor($r('app.color.app_primary'))
                        .borderRadius(13)

                      Text(step)
                        .fontSize(15)
                        .fontColor($r('app.color.text_primary'))
                        .margin({ left: 12 })
                        .layoutWeight(1)
                    }
                    .width('100%')
                    .padding({ top: 8, bottom: 8 })
                    .alignItems(VerticalAlign.Center)
                  })
                }
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          } else {
            Column() {
              Row() {
                Text('📝 烹饪步骤')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
              }
              .margin({ bottom: 12 })

              Text('暂无详细步骤数据')
                .fontSize(14)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 8, bottom: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          }

          // ===== 营养估算 =====
          if (this.detail && this.detail.nutrition) {
            Column() {
              Row() {
                Text('⚡ 营养估算')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                Text('（每份估算值）')
                  .fontSize(12)
                  .fontColor($r('app.color.text_light'))
                  .margin({ left: 8 })
              }
              .margin({ bottom: 16 })

              // 营养卡片网格
              Row() {
                // 热量
                this.nutritionCard('🔥', '热量', this.detail.nutrition.calories, '#FF6B35')
                // 蛋白质
                this.nutritionCard('🥩', '蛋白质', this.detail.nutrition.protein, '#4CAF50')
              }
              .width('100%')
              .margin({ bottom: 8 })

              Row() {
                // 脂肪
                this.nutritionCard('🧈', '脂肪', this.detail.nutrition.fat, '#FF9800')
                // 碳水
                this.nutritionCard('🌾', '碳水', this.detail.nutrition.carbs, '#2196F3')
              }
              .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          } else {
            Column() {
              Row() {
                Text('⚡ 营养估算')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
              }
              .margin({ bottom: 12 })

              Text('暂无营养数据')
                .fontSize(14)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 8, bottom: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .margin({ bottom: 16 })
          }

          // 底部留白
          Divider().height(0).margin(0)
        }
        .width('100%')
.padding({ left: 16, right: 16, bottom: 64 })
      }
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  nutritionCard(icon: string, label: string, value: string, color: string) {
    Column() {
      Text(icon)
        .fontSize(28)
        .margin({ bottom: 6 })
      Text(label)
        .fontSize(12)
        .fontColor($r('app.color.text_light'))
        .margin({ bottom: 4 })
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .layoutWeight(1)
    .padding(12)
    .backgroundColor('#FAFAFA')
    .borderRadius(12)
    .margin({ left: 4, right: 4 })
    .alignItems(HorizontalAlign.Center)
  }
}
