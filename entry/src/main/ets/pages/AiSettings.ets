/**
 * AiSettings - AI 模型设置页
 *
 * 功能：
 * 1. 配置 Ollama 服务地址（电脑 IP:11434）与模型名，保存后长期生效（无需改代码）
 * 2. 测试连接：验证地址是否可达，并列出 Ollama 中实际可用的模型
 * 3. 自动发现：一键扫描当前局域网，自动找到 Ollama 服务
 * 4. 自动发现开关：开启后，地址失效时 APP 会自动重新扫描并记住新地址
 */
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { AiModelService, AiTestResult } from '../service/AiModelService';

@Entry
@Component
struct AiSettings {
  @State hostInput: string = '';
  @State modelInput: string = '';
  @State autoDiscover: boolean = true;
  @State testing: boolean = false;
  @State discovering: boolean = false;
  @State testResult: AiTestResult | null = null;
  @State discoveredModels: string[] = [];

  aboutToAppear(): void {
    const context = getContext(this) as common.Context;
    this.loadConfig(context);
  }

  /**
   * 从本地配置加载已保存的设置
   */
  async loadConfig(context: common.Context): Promise<void> {
    try {
      await AiModelService.init(context);
      this.hostInput = await AiModelService.getStoredHost();
      this.modelInput = await AiModelService.getStoredModel();
      this.autoDiscover = await AiModelService.getStoredAutoDiscover();
    } catch (error) {
      console.error('加载 AI 配置失败：', JSON.stringify(error));
    }
  }

  /**
   * 测试连接：验证输入的服务地址是否可用
   */
  async doTestConnection(): Promise<void> {
    if (this.hostInput.trim().length === 0) {
      promptAction.showToast({ message: '请先填写服务地址' });
      return;
    }
    this.testing = true;
    this.testResult = null;
    this.discoveredModels = [];
    try {
      const r = await AiModelService.testConnection(this.hostInput);
      this.testResult = r;
      if (r.ok) {
        this.discoveredModels = r.models;
      }
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : JSON.stringify(error);
      this.testResult = { ok: false, host: this.hostInput, models: [], message: '测试出错：' + errMsg } as AiTestResult;
    } finally {
      this.testing = false;
    }
  }

  /**
   * 自动发现：扫描局域网中的 Ollama 服务，成功后自动回填地址与模型
   */
  async doAutoDiscover(): Promise<void> {
    if (this.discovering) {
      return;
    }
    this.discovering = true;
    this.testResult = null;
    this.discoveredModels = [];
    promptAction.showToast({ message: '正在扫描局域网，请稍候…' });
    try {
      const found = await AiModelService.discover();
      if (found !== null) {
        const host = AiModelService.normalizeHost(found);
        this.hostInput = host;
        const r = await AiModelService.testConnection(host);
        this.testResult = r;
        this.discoveredModels = r.models;
        if (r.ok && r.models.length > 0 && this.modelInput.trim().length === 0) {
          this.modelInput = r.models[0];
        }
        await this.saveConfig();
      } else {
        this.testResult = {
          ok: false, host: '', models: [],
          message: '未扫描到 Ollama 服务。请确认：电脑已启动 Ollama 且设置了 OLLAMA_HOST=0.0.0.0、手机与电脑连同一个 WiFi'
        } as AiTestResult;
      }
    } finally {
      this.discovering = false;
    }
  }

  /**
   * 保存配置到本地（长期生效）
   */
  async saveConfig(): Promise<void> {
    try {
      const context = getContext(this) as common.Context;
      await AiModelService.init(context);
      await AiModelService.saveHost(AiModelService.normalizeHost(this.hostInput));
      await AiModelService.saveModel(this.modelInput.trim());
      await AiModelService.saveAutoDiscover(this.autoDiscover);
      promptAction.showToast({ message: '已保存，AI 推荐立即生效' });
    } catch (error) {
      console.error('保存 AI 配置失败：', JSON.stringify(error));
      promptAction.showToast({ message: '保存失败，请重试' });
    }
  }

  /**
   * 点击已发现的模型名 → 回填到模型名输入框
   */
  pickModel(name: string): void {
    this.modelInput = name;
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

        Text('AI 模型设置')
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

      // ========== 内容区 ==========
      Scroll() {
        Column() {
          // ---- 服务地址 ----
          Column() {
            Text('📡 服务地址（电脑 IP）')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            TextInput({ placeholder: '如：192.168.1.100:11434', text: this.hostInput })
              .width('100%')
              .height(44)
              .fontSize(15)
              .margin({ top: 10 })
              .backgroundColor('#F7F7F7')
              .borderRadius(10)
              .onChange((value: string) => {
                this.hostInput = value;
              })

            Text('查看方法：电脑上按 win+R 输入 cmd，执行 ipconfig，找"无线局域网适配器"下的 IPv4 地址')
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

          // ---- 模型名 ----
          Column() {
            Text('🧠 模型名')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            TextInput({ placeholder: '如：qwen2.5:7b（留空自动选择）', text: this.modelInput })
              .width('100%')
              .height(44)
              .fontSize(15)
              .margin({ top: 10 })
              .backgroundColor('#F7F7F7')
              .borderRadius(10)
              .onChange((value: string) => {
                this.modelInput = value;
              })

            Text('对应电脑上 ollama list 命令显示的模型名；留空时自动使用第一个可用模型')
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

          // ---- 操作按钮 ----
          Row() {
            Button() {
              if (this.testing) {
                LoadingProgress().width(20).height(20).color(Color.White)
              } else {
                Text('测试连接').fontSize(15).fontColor(Color.White)
              }
            }
            .layoutWeight(1)
            .height(46)
            .backgroundColor('#4A90D9')
            .borderRadius(23)
            .margin({ right: 10 })
            .enabled(!this.testing && !this.discovering)
            .onClick(() => {
              this.doTestConnection();
            })

            Button() {
              if (this.discovering) {
                LoadingProgress().width(20).height(20).color(Color.White)
              } else {
                Text('自动发现').fontSize(15).fontColor(Color.White)
              }
            }
            .layoutWeight(1)
            .height(46)
            .backgroundColor($r('app.color.app_primary'))
            .borderRadius(23)
            .enabled(!this.testing && !this.discovering)
            .onClick(() => {
              this.doAutoDiscover();
            })
          }
          .width('100%')
          .margin({ top: 16 })

          // ---- 测试结果 ----
          if (this.testResult !== null) {
            Column() {
              Text((this.testResult?.ok ? '✅ ' : '❌ ') + (this.testResult?.message ?? ''))
                .fontSize(13)
                .fontColor(this.testResult?.ok ? '#4CAF50' : '#FF5252')
                .lineHeight(19)

              // 发现的模型列表（点击可直接选用）
              if (this.discoveredModels.length > 0) {
                Text('可用模型（点击选用）：')
                  .fontSize(13)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ top: 10 })

                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach(this.discoveredModels, (name: string, index: number) => {
                    Text(name)
                      .fontSize(13)
                      .fontColor(this.modelInput === name ? Color.White : $r('app.color.app_primary'))
                      .backgroundColor(this.modelInput === name ? $r('app.color.app_primary') : '#FFF0E8')
                      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                      .borderRadius(14)
                      .margin({ top: 8, right: 8 })
                      .onClick(() => {
                        this.pickModel(name);
                      })
                  }, (name: string, index: number) => name)
                }
                .width('100%')
              }
            }
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(14)
            .padding(16)
            .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
            .margin({ top: 16 })
          }

          // ---- 自动发现开关 ----
          Row() {
            Column() {
              Text('地址失效时自动重新扫描')
                .fontSize(15)
                .fontColor($r('app.color.text_primary'))

              Text('电脑 IP 变化后，APP 自动扫描局域网找到 Ollama 并记住新地址，无需手动修改')
                .fontSize(12)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 4 })
                .lineHeight(17)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Toggle({ type: ToggleType.Switch, isOn: this.autoDiscover })
              .selectedColor($r('app.color.app_primary'))
              .onChange((isOn: boolean) => {
                this.autoDiscover = isOn;
              })
          }
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(14)
          .padding(16)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
          .margin({ top: 12 })
          .alignItems(VerticalAlign.Center)

          // ---- 使用说明 ----
          Column() {
            Text('💻 电脑端 Ollama 配置（只需做一次）')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))

            Column() {
              this.guideRow('1', '设置环境变量 OLLAMA_HOST=0.0.0.0（关键！Ollama 默认只监听本机，手机连不上）')
              this.guideRow('2', '重启 Ollama（右下角托盘退出后重新打开）')
              this.guideRow('3', '防火墙放行 11434 端口（Ollama 启动时弹窗选择"允许"，或手动添加规则）')
              this.guideRow('4', '下载模型：ollama pull qwen2.5:7b（电脑配置低可用 qwen2.5:3b）')
              this.guideRow('5', '确认手机与电脑连同一个 WiFi，然后回到本页点"测试连接"或"自动发现"')
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

          // ---- 保存按钮 ----
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
