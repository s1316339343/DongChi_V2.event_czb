/**
 * FridgeEditPage - 编辑冰箱食材
 *
 * 用户在此页面选取/修改某个冰箱的食材清单。
 * 新建冰箱时自动生成名称（冰箱一、冰箱二……）
 * 保存后提示"已保存至冰箱X"并自动返回上一页。
 */
import router from '@ohos.router';
import { DbService } from '../service/DbService';
import { IngredientCategory, INGREDIENT_CATEGORIES } from '../service/IngredientCategories';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct FridgeEditPage {
  /** 编辑模式：传入的冰箱 id（0 表示新建） */
  @State fridgeId: number = 0;
  /** 冰箱名称 */
  @State fridgeName: string = '';
  /** 已选食材 */
  @State selectedIngredients: string[] = [];
  /** 动画 */
  @State showContent: boolean = false;
  /** 自定义输入 */
  @State customIngredient: string = '';
  /** 保存中 */
  @State isSaving: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params['fridgeId'] !== undefined) {
        this.fridgeId = params['fridgeId'] as number;
      }
      if (params['fridgeName'] !== undefined) {
        this.fridgeName = params['fridgeName'] as string;
      }
    }

    // 如果是编辑已有冰箱，加载已有食材
    if (this.fridgeId > 0) {
      this.loadExistingIngredients();
    }

    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  async loadExistingIngredients(): Promise<void> {
    try {
      const context = getContext(this);
      const fridge = await DbService.getFridgeById(context, this.fridgeId);
      if (fridge) {
        this.selectedIngredients = fridge.ingredients;
        this.fridgeName = fridge.name;
      }
    } catch (e) {
      console.error('FridgeEditPage: 加载冰箱信息失败', JSON.stringify(e));
    }
  }

  async handleSave(): Promise<void> {
    if (this.isSaving) return;
    this.isSaving = true;

    try {
      const context = getContext(this);

      if (this.fridgeId > 0) {
        // 编辑已有冰箱
        await DbService.updateFridge(context, this.fridgeId, null, this.selectedIngredients);
      } else {
        // 新建冰箱 — 自动生成名称
        const name = this.fridgeName || await DbService.getNextFridgeName(context);
        this.fridgeName = name;
        this.fridgeId = await DbService.addFridge(context, name, this.selectedIngredients);
      }

      // 跳转回冰箱列表页（通过 router.replace 刷新列表）
      router.replace({
        url: 'pages/FridgePage',
        params: {
          savedName: this.fridgeName,
          saved: true
        }
      });
    } catch (e) {
      console.error('FridgeEditPage: 保存失败', JSON.stringify(e));
      // 保存失败必须让用户感知，否则会误以为已保存
      promptAction.showToast({
        message: '保存失败，请重试',
        duration: 2000
      });
    } finally {
      this.isSaving = false;
    }
  }

  toggleIngredient(item: string): void {
    const idx = this.selectedIngredients.indexOf(item);
    if (idx >= 0) {
      const newArr = this.selectedIngredients.slice();
      newArr.splice(idx, 1);
      this.selectedIngredients = newArr;
    } else {
      this.selectedIngredients = [...this.selectedIngredients, item];
    }
  }

  removeIngredient(item: string): void {
    const idx = this.selectedIngredients.indexOf(item);
    if (idx >= 0) {
      const newArr = this.selectedIngredients.slice();
      newArr.splice(idx, 1);
      this.selectedIngredients = newArr;
    }
  }

  isCategoryAllSelected(items: string[]): boolean {
    for (const item of items) {
      if (this.selectedIngredients.indexOf(item) < 0) {
        return false;
      }
    }
    return true;
  }

  toggleCategorySelectAll(items: string[]): void {
    const allSelected = this.isCategoryAllSelected(items);
    if (allSelected) {
      let newArr = this.selectedIngredients.slice();
      for (const item of items) {
        const idx = newArr.indexOf(item);
        if (idx >= 0) {
          newArr.splice(idx, 1);
        }
      }
      this.selectedIngredients = newArr;
    } else {
      let newArr = this.selectedIngredients.slice();
      for (const item of items) {
        if (newArr.indexOf(item) < 0) {
          newArr = [...newArr, item];
        }
      }
      this.selectedIngredients = newArr;
    }
  }

  addCustomIngredient(): void {
    const val = this.customIngredient.trim();
    if (val && this.selectedIngredients.indexOf(val) < 0) {
      this.selectedIngredients = [...this.selectedIngredients, val];
    }
    this.customIngredient = '';
  }

  build() {
    Column() {
      // ===== 顶部导航栏 =====
      Row() {
        Text('←')
          .fontSize(22)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            router.back();
          })

        Blank()

        Column() {
          Text(this.fridgeName || '新建冰箱')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
          Text('勾选放入冰箱的食材')
            .fontSize(11)
            .fontColor($r('app.color.text_light'))
        }
        .alignItems(HorizontalAlign.Center)

        Blank()

        Text('  ')
          .fontSize(22)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 8 })
      .alignItems(VerticalAlign.Center)

      // ===== 已选食材概览 =====
      if (this.selectedIngredients.length > 0) {
        Row() {
          Text('已选 ' + this.selectedIngredients.length + ' 种食材')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.app_primary'))
          Blank()
          Text('清空')
            .fontSize(12)
            .fontColor($r('app.color.text_light'))
            .onClick(() => {
              this.selectedIngredients = [];
            })
        }
        .width('100%')
        .padding({ left: 4, right: 4, bottom: 6 })

        // 已选食材标签（横向滑动）
        Scroll() {
          Row() {
            ForEach(this.selectedIngredients, (item: string) => {
              Row() {
                Text(item)
                  .fontSize(12)
                  .fontColor(Color.White)
                  .margin({ right: 4 })
                Text('✕')
                  .fontSize(10)
                  .fontColor('rgba(255,255,255,0.7)')
              }
              .padding({ top: 4, bottom: 4, left: 10, right: 10 })
              .backgroundColor($r('app.color.app_primary'))
              .borderRadius(14)
              .margin({ right: 6 })
              .onClick(() => {
                this.removeIngredient(item);
              })
            }, (item: string) => item)
          }
          .width('auto')
        }
        .edgeEffect(EdgeEffect.Spring)
        .scrollable(ScrollDirection.Horizontal)
        .width('100%')
        .height(36)
        .margin({ bottom: 8 })
      }

      // ===== 自定义食材输入 =====
      Row() {
        TextInput({ placeholder: '输入不在列表中的食材...', text: this.customIngredient })
          .layoutWeight(1)
          .height(40)
          .fontSize(14)
          .placeholderColor($r('app.color.text_light'))
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .padding({ left: 16, right: 8 })
          .onChange((value: string) => {
            this.customIngredient = value;
          })
          .onSubmit(() => {
            this.addCustomIngredient();
          })

        Text('添加')
          .fontSize(14)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .padding({ top: 8, bottom: 8, left: 18, right: 18 })
          .backgroundColor($r('app.color.app_primary'))
          .borderRadius(20)
          .margin({ left: 8 })
          .onClick(() => {
            this.addCustomIngredient();
          })
      }
      .width('100%')
      .margin({ top: 4, bottom: 12 })

      // ===== 分类食材复选框（可滚动） =====
      Scroll() {
        Column() {
          ForEach(INGREDIENT_CATEGORIES, (category: IngredientCategory, catIndex: number) => {
            this.ingredientCategory(category, catIndex)
          }, (category: IngredientCategory) => category.name)
        }
        .width('100%')
        .padding({ bottom: 100 })
      }
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
      .width('100%')
      .padding({ right: 4 })
      .scrollable(ScrollDirection.Vertical)

      // ===== 底部保存按钮 =====
      Button() {
        if (this.isSaving) {
          LoadingProgress()
            .width(20)
            .height(20)
            .color(Color.White)
        } else {
          Text('保存至 ' + (this.fridgeName || '冰箱'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
      }
      .width('90%')
      .height(50)
      .backgroundColor(this.selectedIngredients.length > 0 ?
        $r('app.color.app_primary') : '#CCCCCC')
      .borderRadius(25)
      .margin({ bottom: 36 })
      .enabled(this.selectedIngredients.length > 0 && !this.isSaving)
      .onClick(() => {
        this.handleSave();
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 30 })
    .animation({ duration: 500, curve: Curve.Smooth })
  }

  @Builder
  ingredientCategory(category: IngredientCategory, catIndex: number) {
    Column() {
      Row() {
        Row() {
          Text(category.icon)
            .fontSize(18)
            .margin({ right: 6 })
          Text(category.name)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
        }

        Blank()

        Text(this.isCategoryAllSelected(category.items) ? '取消全选' : '全选')
          .fontSize(12)
          .fontColor($r('app.color.app_primary'))
          .fontWeight(FontWeight.Medium)
          .padding({ top: 2, bottom: 2, left: 10, right: 10 })
          .backgroundColor('rgba(255,107,53,0.08)')
          .borderRadius(10)
          .onClick(() => {
            this.toggleCategorySelectAll(category.items);
          })
      }
      .width('100%')
      .margin({ top: catIndex > 0 ? 12 : 4, bottom: 8 })

      Flex({
        direction: FlexDirection.Row,
        wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Center
      }) {
        ForEach(category.items, (item: string) => {
          this.ingredientTag(item)
        }, (item: string) => item)
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  ingredientTag(item: string) {
    Row() {
      Text(this.selectedIngredients.indexOf(item) >= 0 ? '✓ ' : '')
        .fontSize(11)
        .fontColor(Color.White)
        .margin({ right: 1 })

      Text(item)
        .fontSize(13)
        .fontColor(this.selectedIngredients.indexOf(item) >= 0 ? Color.White : $r('app.color.text_secondary'))
    }
    .padding({ top: 6, bottom: 6, left: 12, right: 12 })
    .backgroundColor(this.selectedIngredients.indexOf(item) >= 0 ?
      $r('app.color.app_primary') : '#FFFFFF')
    .borderRadius(16)
    .border({
      width: 1,
      color: this.selectedIngredients.indexOf(item) >= 0 ?
        $r('app.color.app_primary') : '#E8E8E8'
    })
    .margin({ right: 8, bottom: 8 })
    .onClick(() => {
      this.toggleIngredient(item);
    })
  }
}
