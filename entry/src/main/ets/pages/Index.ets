import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State showStart: boolean = false;

  aboutToAppear(): void {
    // 入场动画
    animateTo({ duration: 800, curve: Curve.Smooth }, () => {
      this.showStart = true;
    });
  }

  build() {
    Column() {
      // 顶部间距
      Column()
        .height('15%')

      // Logo 区域
      Column() {
        Text('🍽️')
          .fontSize(80)
          .margin({ bottom: 16 })

        Text('懂 吃')
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .letterSpacing(8)

        Text('今天吃什么？不再纠结')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 12 })
          .letterSpacing(2)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 中间弹性
      Blank()

      // 特色介绍
      Column() {
        this.featureItem('🎯', 'AI三问决策', '口味→条件→食材，精准推荐')
        this.featureItem('🍳', '自己做 vs 外卖', '智能对比，帮你决策')
        this.featureItem('🚀', '一键跳转', '直达外卖/买菜/教程平台')
      }
      .width('100%')
      .padding({ left: 40, right: 40 })
      .alignItems(HorizontalAlign.Start)

      Blank()

      // 按钮区域
      Row() {
        // 开始决策按钮
        Button() {
          Row() {
            Text('开始决策')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)

            Text('→')
              .fontSize(20)
              .fontColor(Color.White)
              .margin({ left: 8 })
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .layoutWeight(1)
        .height(56)
        .backgroundColor($r('app.color.app_primary'))
        .borderRadius(28)
        .shadow({ radius: 12, color: 'rgba(255,107,53,0.4)', offsetY: 6 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/StepOne',
            params: {}
          });
        })

        // 我的按钮
        Button() {
          Text('我的')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.app_primary'))
        }
        .width(80)
        .height(56)
        .backgroundColor(Color.White)
        .borderRadius(28)
        .border({ width: 2, color: $r('app.color.app_primary') })
        .margin({ left: 12 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Profile',
            params: {}
          });
        })
      }
      .width('80%')
      .margin({ bottom: 40 })
      .opacity(this.showStart ? 1 : 0)
      .translate({ y: this.showStart ? 0 : 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  featureItem(icon: string, title: string, desc: string) {
    Row() {
      Text(icon)
        .fontSize(28)
        .margin({ right: 16 })

      Column() {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Text(desc)
          .fontSize(13)
          .fontColor($r('app.color.text_light'))
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Center)
  }
}
