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

      // 【单机模式】此处原为第三方账号绑定卡片（抖音/美团），当前版本无此功能，
      // 相关实现已移除；如后续接入联网绑定，请从备份/版本历史中恢复。
      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
