/**
 * AiSettings - AI 能力设置页
 *
 * 页面职责：
 * 1. 配置云端大模型（阿里云百炼 / 通义千问，OpenAI 兼容接口）的 API Key 与模型名
 * 2. 测试连通性：用一次极小的真实请求验证 Key 与模型是否可用，并显示实测耗时
 * 3. 一键开关 AI 能力（关闭后仅使用本地推荐引擎，完全离线可用）
 *
 * 设计说明（为什么不再是"填电脑 IP"）：
 * 旧版本对接的是局域网里的 Ollama，用户必须自己在电脑上装模型、改环境变量、
 * 放行防火墙、保证手机与电脑同一 WiFi —— 门槛高且换网络就失效。
 * 现在改为云端 API：只要有 Key 就能用，且**密钥与模型都可随时更换，无需改代码**。
 * 唯一代价是需要联网；作为补偿，无 Key / 断网 / 额度用尽时会自动降级到本地引擎，
 * 功能不会中断。
 */
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { CloudAiService, CloudAiConfig, CloudAiTestResult } from '../service/CloudAiService';

/** 百炼控制台 API Key 页面（提示用户去哪里申请） */
const CONSOLE_HINT = 'https://bailian.console.aliyun.com/settings/api-key';

@Entry
@Component
struct AiSettings {
  @State apiKeyInput: string = '';
  @State modelInput: string = '';
  @State aiEnabled: boolean = true;
  @State testing: boolean = false;
  @State testResult: CloudAiTestResult | null = null;
  /** 是否已有可用的本地配置（用于区分"开箱即用"与"需手动填 Key"） */
  @State hasKey: boolean = false;

  aboutToAppear(): void {
    const context = getContext(this) as common.Context;
    this.loadConfig(context);
  }

  /**
   * 读取已保存的配置
   */
  async loadConfig(context: common.Context): Promise<void> {
    try {
      await CloudAiService.init(context);
      const cfg: CloudAiConfig = await CloudAiService.loadConfig();
      this.apiKeyInput = cfg.apiKey;
      this.modelInput = cfg.model;
      this.aiEnabled = cfg.enabled;
      this.hasKey = cfg.apiKey.trim().length > 0;
    } catch (error) {
      console.error('加载 AI 配置失败：', JSON.stringify(error));
    }
  }

  /**
   * 测试连通性：发一次真实的小请求
   */
  async doTestConnection(): Promise<void> {
    if (this.apiKeyInput.trim().length === 0) {
      promptAction.showToast({ message: '请先填写 API Key' });
      return;
    }
    this.testing = true;
    this.testResult = null;
    try {
      this.testResult = await CloudAiService.testConnection(this.apiKeyInput, this.modelInput);
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      this.testResult = { ok: false, message: '测试出错：' + errMsg, latencyMs: 0 } as CloudAiTestResult;
    } finally {
      this.testing = false;
    }
  }

  /**
   * 保存配置（立即生效，无需重启）
   */
  async saveConfig(): Promise<void> {
    try {
      const context = getContext(this) as common.Context;
      await CloudAiService.init(context);
      await CloudAiService.saveConfig({
        apiKey: this.apiKeyInput,
        model: this.modelInput,
        enabled: this.aiEnabled,
        baseUrl: ''
      } as CloudAiConfig);
      this.hasKey = this.apiKeyInput.trim().length > 0;
      // 配置变了，允许下次失败时重新提示降级
      CloudAiService.resetDegradeNotice();
      promptAction.showToast({ message: '已保存，AI 推荐立即生效' });
    } catch (error) {
      console.error('保存 AI 配置失败：', JSON.stringify(error));
      promptAction.showToast({ message: '保存失败，请重试' });
    }
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

        Text('AI 能力设置')
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

      Scroll() {
        Column() {
          // ---- 当前状态 ----
          Row() {
            Text(this.hasKey && this.aiEnabled ? '✅' : '⚠️')
              .fontSize(20)
              .margin({ right: 10 })
            Column() {
              Text(this.hasKey && this.aiEnabled ? 'AI 已启用' : '当前使用本地推荐引擎')
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.text_primary'))
              Text(this.hasKey && this.aiEnabled
                ? '云端大模型参与候选重排并生成个性化推荐理由'
                : '未配置密钥或已关闭：功能完整可用，仅推荐理由为通用文案')
                .fontSize(12)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 3 })
                .lineHeight(17)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(14)
          .backgroundColor(this.hasKey && this.aiEnabled ? 'rgba(76,175,80,0.08)' : 'rgba(255,152,0,0.08)')
          .borderRadius(12)
          .alignItems(VerticalAlign.Center)

          // ---- AI 开关 ----
          Row() {
            Column() {
              Text('启用云端 AI')
                .fontSize(15)
                .fontColor($r('app.color.text_primary'))
              Text('关闭后完全离线运行，所有推荐逻辑在本机完成')
                .fontSize(12)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 4 })
                .lineHeight(17)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Toggle({ type: ToggleType.Switch, isOn: this.aiEnabled })
              .selectedColor($r('app.color.app_primary'))
              .onChange((isOn: boolean) => {
                this.aiEnabled = isOn;
              })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(14)
          .padding(16)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
          .margin({ top: 12 })
          .alignItems(VerticalAlign.Center)

          // ---- API Key ----
          Column() {
            Text('🔑 API Key')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            TextInput({ placeholder: 'sk-…（阿里云百炼控制台创建）', text: this.apiKeyInput })
              .type(InputType.Password)
              .showPasswordIcon(true)
              .width('100%')
              .height(44)
              .fontSize(14)
              .margin({ top: 10 })
              .backgroundColor('#F7F7F7')
              .borderRadius(10)
              .onChange((value: string) => {
                this.apiKeyInput = value;
              })

            Text('获取方式：登录阿里云百炼控制台 → API-KEY 页面创建（' + CONSOLE_HINT + '）。' +
              '新用户每个模型有约 100 万 Token 免费额度，有效期 90 天。')
              .fontSize(12)
              .fontColor($r('app.color.text_light'))
              .margin({ top: 8 })
              .lineHeight(17)
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(14)
          .padding(16)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
          .margin({ top: 12 })

          // ---- 模型名 ----
          Column() {
            Text('🧠 模型名')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            TextInput({ placeholder: 'qwen-flash（留空使用默认）', text: this.modelInput })
              .width('100%')
              .height(44)
              .fontSize(14)
              .margin({ top: 10 })
              .backgroundColor('#F7F7F7')
              .borderRadius(10)
              .onChange((value: string) => {
                this.modelInput = value;
              })

            Text('推荐 qwen-flash：速度快、在免费额度覆盖范围内。也可填 qwen-plus 等更强的模型。')
              .fontSize(12)
              .fontColor($r('app.color.text_light'))
              .margin({ top: 8 })
              .lineHeight(17)
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(14)
          .padding(16)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
          .margin({ top: 12 })

          // ---- 测试连接 ----
          Button() {
            if (this.testing) {
              Row() {
                LoadingProgress().width(18).height(18).color(Color.White).margin({ right: 8 })
                Text('测试中…').fontSize(15).fontColor(Color.White)
              }
              .alignItems(VerticalAlign.Center)
            } else {
              Text('测试连接').fontSize(15).fontColor(Color.White)
            }
          }
          .width('100%')
          .height(46)
          .backgroundColor('#4A90D9')
          .borderRadius(23)
          .margin({ top: 16 })
          .enabled(!this.testing)
          .onClick(() => {
            this.doTestConnection();
          })

          // ---- 测试结果 ----
          if (this.testResult !== null) {
            Column() {
              Text((this.testResult?.ok ? '✅ ' : '❌ ') + (this.testResult?.message ?? ''))
                .fontSize(13)
                .fontColor(this.testResult?.ok ? $r('app.color.state_success') : $r('app.color.state_danger'))
                .lineHeight(19)
            }
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(14)
            .padding(16)
            .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
            .margin({ top: 16 })
          }

          // ---- 工作原理说明 ----
          Column() {
            Text('⚙️ AI 是如何参与推荐的')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            Column() {
              this.guideRow('1', '本地检索：先按忌口、预算、时间做硬性筛选，从 500 道菜中收敛出候选')
              this.guideRow('2', '云端重排：大模型只在候选集合内排序，并结合你的补充说明写推荐理由')
              this.guideRow('3', '结果校验：越界分数、编造的菜名、违反忌口的结果一律丢弃并重试')
              this.guideRow('4', '自动降级：断网、额度用尽或校验失败时，自动回退本地排序，功能不中断')
            }
            .width('100%')
            .margin({ top: 10 })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(14)
          .padding(16)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
          .margin({ top: 12 })

          // ---- 保存 ----
          Button() {
            Text('保存设置').fontSize(16).fontColor(Color.White).fontWeight(FontWeight.Medium)
          }
          .width('100%')
          .height(50)
          .backgroundColor($r('app.color.app_primary'))
          .borderRadius(25)
          .margin({ top: 20, bottom: 36 })
          .onClick(() => {
            this.saveConfig();
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20 })
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
  guideRow(num: string, text: string) {
    Row() {
      Text(num)
        .fontSize(12)
        .fontColor(Color.White)
        .width(18)
        .height(18)
        .textAlign(TextAlign.Center)
        .borderRadius(9)
        .backgroundColor($r('app.color.app_secondary'))
        .margin({ right: 8, top: 2 })

      Text(text)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .layoutWeight(1)
        .lineHeight(19)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .margin({ top: 8 })
  }
}
