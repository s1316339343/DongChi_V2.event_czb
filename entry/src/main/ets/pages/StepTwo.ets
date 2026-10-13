import router from '@ohos.router';

@Entry
@Component
struct StepTwo {
  // 接收第一问的选择
  @State category: number = 0;

  // 限制条件选择
  @State timeSelect: number = -1; // 0:10分钟 1:30分钟 2:1小时以上
  @State budgetSelect: number = -1; // 0:10元 1:20元 2:50元 3:不设限
  @State dietSelect: number[] = [];
  @State canProceed: boolean = false; // 时间+预算都选了才能下一步

  @State showContent: boolean = false;
  @State showNext: boolean = false;

  categories: string[] = ['家常清淡', '重口过瘾', '健康轻食', '快餐速食'];

  aboutToAppear(): void {
    // 获取参数
    const params = router.getParams() as Record<string, Object>;
    if (params && params['category'] !== undefined) {
      this.category = params['category'] as number;
    }

    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  build() {
    Column() {
      // 顶部进度条 + 返回按钮
      Row() {
        Row()
          .width(40)
        Column() {
          Row() {
            this.stepDot(0, true)
            this.stepLine(true)
            this.stepDot(1, true)
            this.stepLine(false)
            this.stepDot(2, false)
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .layoutWeight(1)
        Text('返回')
          .fontSize(13)
          .fontColor($r('app.color.app_primary'))
          .width(40)
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
      .margin({ top: 40, bottom: 20 })
      .padding({ left: 20, right: 20 })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Column() {
          // 标题
          Text('第二问')
            .fontSize(14)
            .fontColor($r('app.color.app_primary'))
            .fontWeight(FontWeight.Medium)
            .letterSpacing(4)
            .margin({ bottom: 8 })

          Text('今天的"限制条件"是什么？')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 4 })

          Text('选好条件，AI为你精准推荐 (可多选)')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
            .margin({ bottom: 24 })

          // 已选口味提示
          Row() {
            Text('已选：' + this.categories[this.category])
              .fontSize(13)
              .fontColor($r('app.color.app_primary'))
            Text('  可随时返回修改')
              .fontSize(12)
              .fontColor($r('app.color.text_light'))
          }
          .margin({ bottom: 24 })

          // ⏰ 时间限制
          Text('⏰ 时间限制')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .width('100%')
            .margin({ bottom: 12 })

          Row() {
            this.tagButton('10分钟内搞定', 0, 'time')
            this.tagButton('30分钟', 1, 'time')
            this.tagButton('1小时以上', 2, 'time')
          }
          .width('100%')
          .margin({ bottom: 24 })

          // 💰 预算限制
          Text('💰 预算限制')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .width('100%')
            .margin({ bottom: 12 })

          Row() {
            this.tagButton('10元以内', 0, 'budget')
            this.tagButton('20元以内', 1, 'budget')
            this.tagButton('50元以内', 2, 'budget')
            this.tagButton('不设限', 3, 'budget')
          }
          .width('100%')
          .margin({ bottom: 24 })

          // ❌ 忌口限制
          Text('❌ 忌口限制')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .width('100%')
            .margin({ bottom: 12 })

          Row() {
            this.tagButton('不吃辣', 0, 'diet')
            this.tagButton('不吃香菜', 1, 'diet')
          }
          .width('100%')
          .margin({ bottom: 8 })

          Row() {
            this.tagButton('不吃海鲜', 2, 'diet')
            this.tagButton('素食', 3, 'diet')
          }
          .width('100%')
          .margin({ bottom: 32 })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
      }
      .edgeEffect(EdgeEffect.Spring)
      .height('75%')

      Blank()

      // 下一步按钮
      Button() {
        Text(this.canProceed ? '下一步：看看有什么食材 →' : '请先选择时间与预算')
          .fontSize(this.canProceed ? 16 : 14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width('80%')
      .height(52)
      .backgroundColor(this.canProceed ? $r('app.color.app_primary') : '#BDBDBD')
      .borderRadius(26)
      .margin({ bottom: 56 })
      .opacity(this.showContent ? 1 : 0)
      .enabled(this.canProceed)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/StepThree',
          params: {
            category: this.category,
            time: this.timeSelect,
            budget: this.budgetSelect,
            diet: this.dietSelect
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
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

  @Builder
  tagButton(label: string, index: number, type: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor(this.isSelected(type, index) ? Color.White : $r('app.color.text_secondary'))
        .fontWeight(this.isSelected(type, index) ? FontWeight.Medium : FontWeight.Regular)
    }
    .padding({ top: 8, bottom: 8, left: 16, right: 16 })
    .backgroundColor(this.isSelected(type, index) ? $r('app.color.app_primary') : '#FFFFFF')
    .borderRadius(20)
    .border({
      width: 1,
      color: this.isSelected(type, index) ? $r('app.color.app_primary') : '#E8E8E8'
    })
    .margin({ right: 8 })
    .onClick(() => {
      this.toggleSelect(type, index);
    })
  }

  isSelected(type: string, index: number): boolean {
    if (type === 'time') {
      return this.timeSelect === index;
    } else if (type === 'budget') {
      return this.budgetSelect === index;
    } else if (type === 'diet') {
      return this.dietSelect.indexOf(index) >= 0;
    }
    return false;
  }

  toggleSelect(type: string, index: number): void {
    if (type === 'time') {
      if (this.timeSelect === index) {
        this.timeSelect = -1;
      } else {
        this.timeSelect = index;
      }
    } else if (type === 'budget') {
      if (this.budgetSelect === index) {
        this.budgetSelect = -1;
      } else {
        this.budgetSelect = index;
      }
    } else if (type === 'diet') {
      const idx = this.dietSelect.indexOf(index);
      if (idx >= 0) {
        const newArr = this.dietSelect.slice();
        newArr.splice(idx, 1);
        this.dietSelect = newArr;
      } else {
        this.dietSelect = [...this.dietSelect, index];
      }
    }
    // 更新下一步按钮状态：时间+预算都选了才能点
    this.canProceed = this.timeSelect >= 0 && this.budgetSelect >= 0;
  }
}

