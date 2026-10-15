import router from '@ohos.router';

@Entry
@Component
struct StepOne {
  @State selectedCategory: number = -1;
  @State showContent: boolean = false;

  aboutToAppear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  build() {
    Column() {
      // 顶部进度条
      Row() {
        this.stepDot(0, true)
        this.stepLine(true)
        this.stepDot(1, false)
        this.stepLine(false)
        this.stepDot(2, false)
      }
      .width('60%')
      .margin({ top: 40, bottom: 20 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 标题
      Text('第一问')
        .fontSize(14)
        .fontColor($r('app.color.app_primary'))
        .fontWeight(FontWeight.Medium)
        .letterSpacing(4)
        .margin({ bottom: 8 })

      Text('今天想吃什么"感觉"的？')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 8 })

      Text('选一个口味方向，AI帮你缩小范围')
        .fontSize(14)
        .fontColor($r('app.color.text_light'))
        .margin({ bottom: 32 })

      // 四个口味卡片
      this.categoryCard('🍚', '家常清淡', '米饭、炒菜、粥\n温暖家常的味道', 0)
      this.categoryCard('🍜', '重口过瘾', '火锅、烧烤、麻辣烫\n刺激味蕾的选择', 1)
      this.categoryCard('🥗', '健康轻食', '沙拉、减脂餐、轻食\n清爽无负担', 2)
      this.categoryCard('🍔', '快餐速食', '汉堡、炸鸡、披萨\n快速解决温饱', 3)

      Blank()

      // 完全随机按钮 - 一键跳过所有选择
      Button() {
        Row() {
          Text('🎲')
            .fontSize(22)
            .margin({ right: 8 })

          Column() {
            Text('随便吃点')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)

            Text('完全随机，直接出结果')
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.7)')
          }
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width('80%')
      .height(52)
      .backgroundColor('#7C4DFF')
      .borderRadius(26)
      .margin({ bottom: 16 })
      .shadow({ radius: 10, color: 'rgba(124,77,255,0.35)', offsetY: 4 })
      .opacity(this.showContent ? 1 : 0)
      .onClick(() => {
        const randomCategory = Math.floor(Math.random() * 4);
        router.pushUrl({
          url: 'pages/Recommend',
          params: {
            category: randomCategory,
            time: -1,
            budget: -1,
            diet: [] as number[],
            ingredients: [] as string[],
            hasNoIngredients: false
          }
        });
      })

      // 下一步按钮
      Button() {
        Text('下一步 →')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.selectedCategory >= 0 ? Color.White : $r('app.color.text_light'))
      }
      .width('80%')
      .height(52)
      .backgroundColor(this.selectedCategory >= 0 ? $r('app.color.app_primary') : '#F0F0F0')
      .borderRadius(26)
      .margin({ bottom: 56 })
      .enabled(this.selectedCategory >= 0)
      .opacity(this.showContent ? 1 : 0)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/StepTwo',
          params: { category: this.selectedCategory }
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .padding({ left: 24, right: 24 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  stepDot(index: number, active: boolean) {
    Circle()
      .width(10)
      .height(10)
      .fill(active ? $r('app.color.app_primary') : $r('app.color.step_inactive'))
  }

  @Builder
  stepLine(active: boolean) {
    Line()
      .width(40)
      .height(2)
      .stroke(active ? $r('app.color.app_primary') : $r('app.color.step_inactive'))
      .strokeWidth(2)
      .margin({ left: 6, right: 6 })
  }

  @Builder
  categoryCard(icon: string, title: string, desc: string, index: number) {
    Column() {
      Row() {
        Text(icon)
          .fontSize(36)
          .margin({ right: 16 })

        Column() {
          Text(title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Text(desc)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
            .lineHeight(18)
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        // 选中标记 - 使用条件表达式而非if语句
        Text(this.selectedCategory === index ? '✓' : '')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .width(24)
          .height(24)
          .textAlign(TextAlign.Center)
          .backgroundColor(this.selectedCategory === index ? $r('app.color.app_primary') : Color.Transparent)
          .borderRadius(12)
          .visibility(this.selectedCategory === index ? Visibility.Visible : Visibility.None)
      }
      .alignItems(VerticalAlign.Center)
      .padding(16)
      .width('100%')
      .backgroundColor(this.selectedCategory === index ?
        Color.White : (index % 2 === 0 ? '#FFFAF7' : '#FFFFFF'))
      .borderRadius(16)
      .shadow({
        radius: this.selectedCategory === index ? 8 : 4,
        color: this.selectedCategory === index ? 'rgba(255,107,53,0.2)' : 'rgba(0,0,0,0.04)',
        offsetY: 2
      })
      .margin({ bottom: 12 })
      .border({
        width: this.selectedCategory === index ? 2 : 1,
        color: this.selectedCategory === index ? $r('app.color.app_primary') : '#F0F0F0'
      })
      .onClick(() => {
        this.selectedCategory = index;
      })
      .opacity(this.showContent ? 1 : 0)
      .translate({ y: this.showContent ? 0 : 20 + index * 10 })
      .animation({ duration: 300, curve: Curve.Smooth, delay: Math.min(index, 4) * 60 })
    }
  }
}
