/**
 * FridgePage - 我的冰箱（冰箱列表页）
 *
 * 类似收藏页风格，展示所有已创建的冰箱。
 * 两种模式：
 *   普通模式 - 从"我的"页面进入，可添加/编辑/删除冰箱
 *   选择模式 - 从 StepThree 进入，选中冰箱后返回 StepThree 并加载食材
 */
import router from '@ohos.router';
import { DbService, FridgeInfo } from '../service/DbService';
import { FridgeState } from '../service/FridgeState';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct FridgePage {
  @State showContent: boolean = false;
  @State fridges: FridgeInfo[] = [];
  @State isLoading: boolean = true;
  @State savedName: string = '';
  @State showSavedTip: boolean = false;
  /** 保存提示的自动隐藏定时器，页面销毁时必须清理 */
  private savedTipTimer: number = -1;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params['mode'] === 'select') {
        FridgeState.triggerMode = true;
      }
      if (params['saved'] === true && params['savedName']) {
        this.savedName = params['savedName'] as string;
        this.showSavedTip = true;
        this.savedTipTimer = setTimeout(() => {
          this.showSavedTip = false;
          this.savedTipTimer = -1;
        }, 2500);
      }
    }

    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  onPageShow(): void {
    this.loadFridges();
  }

  /**
   * 页面销毁时清理未触发的定时器，避免回调打到已销毁的组件上
   */
  aboutToDisappear(): void {
    if (this.savedTipTimer !== -1) {
      clearTimeout(this.savedTipTimer);
      this.savedTipTimer = -1;
    }
    // 选择模式标志是一次性状态，离开页面必须复位，
    // 否则下次正常进入时标题与点击行为都会残留为"选择冰箱"
    FridgeState.triggerMode = false;
  }

  async loadFridges(): Promise<void> {
    this.isLoading = true;
    try {
      const context = getContext(this);
      this.fridges = await DbService.getAllFridges(context);
    } catch (e) {
      console.error('FridgePage: 加载冰箱列表失败', JSON.stringify(e));
      this.fridges = [];
    } finally {
      this.isLoading = false;
    }
  }

  /** 新建冰箱 */
  goToAddFridge(): void {
    router.pushUrl({ url: 'pages/FridgeEditPage', params: {} });
  }

  /** 编辑已有冰箱 */
  goToEditFridge(fridge: FridgeInfo): void {
    if (FridgeState.triggerMode) {
      // 选择模式：直接选中后返回 StepThree
      this.selectFridge(fridge);
    } else {
      // 普通模式：跳转编辑
      FridgeState.triggerMode = false;
      router.pushUrl({
        url: 'pages/FridgeEditPage',
        params: { fridgeId: fridge.id, fridgeName: fridge.name }
      });
    }
  }

  /** 选择模式 — 选中冰箱，返回 StepThree */
  selectFridge(fridge: FridgeInfo): void {
    FridgeState.selectedFridgeId = fridge.id;
    FridgeState.triggerMode = false;
    router.back();
  }

  /** 删除冰箱 */
  async deleteFridge(fridge: FridgeInfo): Promise<void> {
    try {
      const data = await promptAction.showDialog({
        title: '删除冰箱',
        message: '确定要删除"' + fridge.name + '"吗？已选食材将丢失。',
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '删除', color: '#FF3B30' }
        ]
      });
      if (data.index === 1) {
        const context = getContext(this);
        await DbService.deleteFridge(context, fridge.id);
        await this.loadFridges();
      }
    } catch (e) {
      // 区分"用户取消"与"DB 删除失败"，避免把真实故障记为取消而掩盖问题
      console.error('FridgePage: 删除冰箱失败', JSON.stringify(e));
      promptAction.showToast({ message: '删除失败，请重试', duration: 2000 });
    }
  }

  /** 确认全部删除 */
  confirmDeleteAll(): void {
    promptAction.showDialog({
      title: '全部删除',
      message: '确定要删除所有冰箱吗？此操作不可恢复。',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '全部删除', color: '#FF3B30' }
      ]
    }).then((data) => {
      if (data.index === 1) {
        this.deleteAllFridges();
      }
    }).catch(() => {
      console.error('FridgePage: 全部删除对话框取消');
    });
  }

  /** 执行全部删除 */
  async deleteAllFridges(): Promise<void> {
    try {
      const context = getContext(this);
      await DbService.deleteAllFridges(context);
      await this.loadFridges();
    } catch (e) {
      console.error('FridgePage: 全部删除失败', JSON.stringify(e));
    }
  }

  /** 格式化时间 */
  formatDate(isoStr: string): string {
    try {
      const date = new Date(isoStr);
      const m = String(date.getMonth() + 1).padStart(2, '0');
      const d = String(date.getDate()).padStart(2, '0');
      return m + '月' + d + '日';
    } catch (_) {
      return isoStr;
    }
  }

  build() {
    Column() {
      // ===== 顶部导航栏 =====
      Row() {
        Text('←')
          .fontSize(22)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            if (FridgeState.triggerMode) {
              FridgeState.triggerMode = false;
            }
            router.back();
          })

        Blank()

        Column() {
          Text(FridgeState.triggerMode ? '选择冰箱' : '我的冰箱')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
          if (FridgeState.triggerMode) {
            Text('选择冰箱自动加载食材到 StepThree')
              .fontSize(11)
              .fontColor($r('app.color.text_light'))
          } else {
            Text('管理家里的冰箱')
              .fontSize(11)
              .fontColor($r('app.color.text_light'))
          }
        }
        .alignItems(HorizontalAlign.Center)

        Blank()

        if (this.savedName && this.showSavedTip) {
          Text('✓ 已保存至' + this.savedName)
            .fontSize(12)
            .fontColor($r('app.color.app_primary'))
            .fontWeight(FontWeight.Medium)
        } else if (this.fridges.length > 0) {
          Text('全部删除')
            .fontSize(13)
            .fontColor('#FF4444')
            .onClick(() => {
              this.confirmDeleteAll();
            })
        } else {
          Text('  ')
            .fontSize(13)
            .fontColor($r('app.color.text_light'))
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .alignItems(VerticalAlign.Center)

      // ===== 保存提示横幅 =====
      if (this.savedName && this.showSavedTip) {
        Row() {
          Text('✓ 已保存至' + this.savedName)
            .fontSize(13)
            .fontColor(Color.White)
        }
        .width('90%')
        .padding({ top: 10, bottom: 10 })
        .backgroundColor($r('app.color.app_primary'))
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 8 })
      }

      // ===== 内容区 =====
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
      } else if (this.fridges.length === 0 && !FridgeState.triggerMode) {
        // 空状态
        Column() {
          Text('🧊')
            .fontSize(64)
            .margin({ bottom: 16 })
          Text('暂无冰箱数据')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })
          Text('点击下方添加冰箱，维护常备食材')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
        }
        .width('100%')
        .height('70%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .opacity(this.showContent ? 1 : 0)
      } else if (this.fridges.length === 0 && FridgeState.triggerMode) {
        // 选择模式无冰箱
        Column() {
          Text('🧊')
            .fontSize(64)
            .margin({ bottom: 16 })
          Text('暂无可选的冰箱')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
          Text('请先在"我的→我的冰箱"中添加冰箱')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
            .margin({ top: 8 })
        }
        .width('100%')
        .height('70%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .opacity(this.showContent ? 1 : 0)
      } else {
        // 冰箱列表
        Scroll() {
          Column() {
            ForEach(this.fridges, (fridge: FridgeInfo, index: number) => {
              this.fridgeCard(fridge, index)
            }, (fridge: FridgeInfo) => String(fridge.id))
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 100 })
        }
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
        .width('100%')
      }

      // ===== 底部按钮（仅非选择模式显示"添加冰箱"）=====
      if (!FridgeState.triggerMode) {
        Button() {
          Row() {
            Text('＋')
              .fontSize(20)
              .fontColor(Color.White)
              .margin({ right: 6 })
            Text('添加冰箱')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
        }
        .width('90%')
        .height(50)
        .backgroundColor($r('app.color.app_primary'))
        .borderRadius(25)
        .margin({ bottom: 36 })
        .onClick(() => {
          this.goToAddFridge();
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  fridgeCard(fridge: FridgeInfo, index: number) {
    Column() {
      Row() {
        // 冰箱信息
        Column() {
          // 第一行：名称 + 食材数
          Row() {
            Text('🧊')
              .fontSize(24)
              .margin({ right: 10 })
            Text(fridge.name)
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
          }
          .alignItems(VerticalAlign.Center)

          // 食材预览
          Text(fridge.ingredients.length > 0 ?
            fridge.ingredients.slice(0, 6).join('、') + (fridge.ingredients.length > 6 ? '...' : '') :
            '暂无食材')
            .fontSize(13)
            .fontColor($r('app.color.text_light'))
            .margin({ top: 6 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Row() {
            Text(fridge.ingredients.length + ' 种食材')
              .fontSize(12)
              .fontColor($r('app.color.app_primary'))
            Text(' · ' + this.formatDate(fridge.updatedAt))
              .fontSize(12)
              .fontColor($r('app.color.text_light'))
              .margin({ left: 6 })
          }
          .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        if (FridgeState.triggerMode) {
          // 选择模式：显示"使用"按钮
          Button('使用此冰箱')
            .fontSize(13)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.app_primary'))
            .borderRadius(16)
            .height(32)
            .padding({ left: 14, right: 14 })
            .onClick(() => {
              this.selectFridge(fridge);
            })
        } else {
          // 普通模式：右侧箭头 + 长按删除提示
          Column() {
            Text('›')
              .fontSize(22)
              .fontColor('#CCCCCC')
            Text('长按删除')
              .fontSize(10)
              .fontColor('#CCCCCC')
              .margin({ top: 2 })
          }
        }
      }
      .width('100%')
      .padding(16)

      // 食材标签快速预览
      if (fridge.ingredients.length > 0) {
        Flex({
          direction: FlexDirection.Row,
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Center
        }) {
          ForEach(fridge.ingredients.slice(0, 12), (item: string) => {
            Text(item)
              .fontSize(11)
              .fontColor($r('app.color.text_secondary'))
              .padding({ top: 3, bottom: 3, left: 8, right: 8 })
              .backgroundColor('#F5F5F5')
              .borderRadius(10)
              .margin({ right: 6, bottom: 6 })
          }, (item: string) => item)
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 12 })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(14)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
    .margin({ top: index > 0 ? 12 : 0 })
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 20 + index * 10 })
    .animation({ duration: 400 + index * 80, curve: Curve.Smooth })
    .onClick(() => {
      this.goToEditFridge(fridge);
    })
    .gesture(
      LongPressGesture({ repeat: false })
        .onAction(() => {
          if (!FridgeState.triggerMode) {
            this.deleteFridge(fridge);
          }
        })
    )
  }
}
