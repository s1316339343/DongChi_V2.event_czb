import router from '@ohos.router';

interface ProfileData {
  userName: string;
  userAccount: string;
}

@Entry
@Component
struct ProfileDetail {
  @State showContent: boolean = false;
  @State userName: string = '';
  @State userAccount: string = '';

  // 【单机模式】绑定状态已注释，恢复联网功能时取消下方注释
  // @State douyinBound: boolean = false;
  // @State meituanBound: boolean = false;

  aboutToAppear(): void {
    // 获取路由传入的参数
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.userName = (params['userName'] as string) || '';
      this.userAccount = (params['userAccount'] as string) || '';
    }

    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('←')
          .fontSize(22)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            router.back();
          })

        Blank()

        Text('个人资料')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Blank()

        Text('  ')
          .fontSize(22)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .alignItems(VerticalAlign.Center)

      // 头像
      Column() {
        Text('😊')
          .fontSize(72)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 32, bottom: 12 })
      .opacity(this.showContent ? 1 : 0)

      // ===== 基本信息卡片 =====
      Column() {
        Row() {
          Text('姓名')
            .fontSize(15)
            .fontColor($r('app.color.text_light'))

          Blank()

          Text(this.userName)
            .fontSize(15)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })
        .alignItems(VerticalAlign.Center)

        // 分割线
        Divider()
          .width('100%')
          .color('#EEEEEE')
          .height(1)

        Row() {
          Text('账号')
            .fontSize(15)
            .fontColor($r('app.color.text_light'))

          Blank()

          Text(this.userAccount)
            .fontSize(15)
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .margin({ left: 20, right: 20, top: 24 })
      .opacity(this.showContent ? 1 : 0)
      .translate({ y: this.showContent ? 0 : 20 })

      // ===== 第三方绑定卡片（单机模式已注释）=====
      // 【注意】当前为单机本地模式，无需第三方账号绑定。
      // 后续如需接入后端 API，取消下方注释块即可恢复。
      /*
      Column() {
        Text('第三方账号绑定')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .width('100%')
          .margin({ bottom: 8 })
          .textAlign(TextAlign.Start)

        Divider()
          .width('100%')
          .color('#F0F0F0')
          .height(1)
          .margin({ bottom: 4 })

        // 抖音绑定
        Row() {
          Row() {
            Image($r('app.media.ic_douyin'))
              .width(26)
              .height(26)
              .margin({ right: 12 })

            Text('抖音')
              .fontSize(15)
              .fontColor($r('app.color.text_primary'))
          }
          .alignItems(VerticalAlign.Center)

          Blank()

          // 绑定状态标签
          Text(this.douyinBound ? '已绑定' : '未绑定')
            .fontSize(13)
            .fontColor(this.douyinBound ? '#4CAF50' : '#BBBBBB')
            .backgroundColor(this.douyinBound ? '#E8F5E9' : '#F5F5F5')
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .borderRadius(10)
        }
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .alignItems(VerticalAlign.Center)

        Divider()
          .width('100%')
          .color('#F0F0F0')
          .height(1)

        // 美团绑定
        Row() {
          Row() {
            Image($r('app.media.ic_meituan'))
              .width(26)
              .height(26)
              .margin({ right: 12 })

            Text('美团')
              .fontSize(15)
              .fontColor($r('app.color.text_primary'))
          }
          .alignItems(VerticalAlign.Center)

          Blank()

          Text(this.meituanBound ? '已绑定' : '未绑定')
            .fontSize(13)
            .fontColor(this.meituanBound ? '#4CAF50' : '#BBBBBB')
            .backgroundColor(this.meituanBound ? '#E8F5E9' : '#F5F5F5')
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .borderRadius(10)
        }
        .width('100%')
        .padding({ top: 12, bottom: 12 })
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 10 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .margin({ left: 20, right: 20, top: 16 })
      .opacity(this.showContent ? 1 : 0)
      .translate({ y: this.showContent ? 0 : 20 })
      */

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
