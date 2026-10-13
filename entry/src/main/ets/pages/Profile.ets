import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

// 默认账号（自动登录用）
const DEFAULT_ACCOUNT: string = 'admin';
const DEFAULT_USERNAME: string = '本地测试';

@Entry
@Component
struct Profile {
  @State showContent: boolean = false;
  @State isLoggedIn: boolean = true;      // 自动登录
  @State userName: string = DEFAULT_USERNAME;
  @State userAccount: string = DEFAULT_ACCOUNT;

  aboutToAppear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  build() {
    Stack() {
      // ========== 主页面内容 ==========
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

          Text('我的')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Blank()

          // 占位，保持标题居中
          Text('  ')
            .fontSize(22)
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 16 })
        .alignItems(VerticalAlign.Center)

        // 头像/用户区域 - 点击查看个人资料
        Column() {
          Text('😊')
            .fontSize(64)

          Text(this.userName)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .margin({ top: 12 })

          Text('点击查看个人资料')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
            .margin({ top: 6 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .margin({ top: 40, bottom: 40 })
        .opacity(this.showContent ? 1 : 0)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ProfileDetail',
            params: {
              userName: this.userName,
              userAccount: this.userAccount
            }
          });
        })

        // 功能列表
        Column() {
          this.menuItem('📋', '我的决策记录', '查看历史决策', () => {
            router.pushUrl({
              url: 'pages/DecisionRecords',
              params: {}
            });
          })
          this.menuItem('❤️', '我的收藏', '收藏的菜品和推荐', () => {
            router.pushUrl({
              url: 'pages/Favorites',
              params: {}
            });
          })
          this.menuItem('🧊', '我的冰箱', '维护常备食材，推荐自动匹配', () => {
            router.pushUrl({
              url: 'pages/FridgePage',
              params: {}
            });
          })
          this.menuItem('📊', '我的饮食统计仪表盘', '决策数据可视化分析', () => {
            router.pushUrl({
              url: 'pages/DietDashboard',
              params: {}
            });
          })
          this.menuItem('🤖', 'AI 模型设置', '配置 Ollama 模型服务，一次配置长期生效', () => {
            router.pushUrl({
              url: 'pages/AiSettings',
              params: {}
            });
          })
          this.menuItem('💬', '意见反馈', '告诉我们你的想法', () => {
            promptAction.showDialog({
              message: '目前处于开发阶段，仅为本地使用，意见反馈渠道，WX：Song1316339343；邮箱：1316339343@qq.com',
              buttons: [{ text: '确定', color: $r('app.color.app_primary') }]
            });
          })
          this.menuItem('📖', '关于懂吃', 'v1.1.0', () => {
            promptAction.showDialog({
              message: '目前处于开发V1.1.0阶段，仅为本地使用，暂无联网功能，后续会继续开发，感谢使用',
              buttons: [{ text: '确定', color: $r('app.color.app_primary') }]
            });
          })
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
        .opacity(this.showContent ? 1 : 0)
        .translate({ y: this.showContent ? 0 : 20 })

        Blank()
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.app_bg'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  menuItem(icon: string, title: string, desc: string, onClick?: () => void) {
    Row() {
      Text(icon)
        .fontSize(24)
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

      Blank()

      Text('›')
        .fontSize(22)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
    .alignItems(VerticalAlign.Center)
    .borderRadius(12)
    .onClick(() => {
      if (onClick) {
        onClick();
      }
    })
  }
}
