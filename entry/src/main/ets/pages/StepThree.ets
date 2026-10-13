import router from '@ohos.router';
import { DbService } from '../service/DbService';
import { FridgeState } from '../service/FridgeState';
import { promptAction } from '@kit.ArkUI';

interface IngredientCategory {
  name: string;
  icon: string;
  items: string[];
}

const INGREDIENT_CATEGORIES: IngredientCategory[] = [
  {
    name: '蔬菜菌菇',
    icon: '🥬',
    items: ['番茄', '土豆', '胡萝卜', '白菜', '菠菜', '生菜', '黄瓜', '茄子', '青椒', '洋葱', '大葱', '姜', '蒜', '西兰花', '花菜', '豆角', '蘑菇', '金针菇', '香菇', '玉米', '南瓜', '冬瓜', '芹菜', '韭菜', '豆芽']
  },
  {
    name: '肉禽蛋类',
    icon: '🥩',
    items: ['鸡蛋', '鸡胸肉', '鸡腿', '鸡翅', '猪肉', '五花肉', '排骨', '瘦肉', '牛肉', '牛腩', '羊肉', '鸭肉', '火腿肠', '培根', '腊肉']
  },
  {
    name: '豆制品',
    icon: '🫘',
    items: ['豆腐', '嫩豆腐', '豆腐干', '千张', '腐竹', '豆皮', '豆浆', '毛豆', '黄豆', '绿豆']
  },
  {
    name: '海鲜水产',
    icon: '🐟',
    items: ['虾', '虾仁', '鱼', '鲫鱼', '三文鱼', '带鱼', '蛤蜊', '鱿鱼', '螃蟹', '扇贝']
  },
  {
    name: '主食米面',
    icon: '🍚',
    items: ['大米', '米饭', '面条', '挂面', '方便面', '米粉', '面粉', '饺子皮', '馄饨皮', '面包', '馒头', '年糕', '燕麦', '红薯', '紫薯']
  },
  {
    name: '调味佐料',
    icon: '🧂',
    items: ['油', '盐', '生抽', '老抽', '醋', '料酒', '蚝油', '豆瓣酱', '番茄酱', '辣椒', '花椒', '八角', '桂皮', '白糖', '蜂蜜', '芝麻', '辣椒酱', '黄豆酱']
  },
  {
    name: '乳制品',
    icon: '🥛',
    items: ['牛奶', '酸奶', '黄油', '芝士', '淡奶油', '炼乳']
  }
];

@Entry
@Component
struct StepThree {
  // 接收前两问参数
  @State category: number = 0;
  @State time: number = -1;
  @State budget: number = -1;
  @State diet: number[] = [];

  // 食材相关
  @State selectedIngredients: string[] = [];
  @State customIngredient: string = '';
  @State showContent: boolean = false;
  @State hasNoIngredients: boolean = false;

  categories: string[] = ['家常清淡', '重口过瘾', '健康轻食', '快餐速食'];
  dietLabels: string[] = ['不吃辣', '不吃香菜', '不吃海鲜', '素食'];

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params['category'] !== undefined) this.category = params['category'] as number;
      if (params['time'] !== undefined) this.time = params['time'] as number;
      if (params['budget'] !== undefined) this.budget = params['budget'] as number;
      if (params['diet'] !== undefined) this.diet = params['diet'] as number[];
    }

    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  /**
   * 每次页面显示时检测是否有从冰箱选中的食材
   */
  onPageShow(): void {
    if (FridgeState.selectedFridgeId > 0) {
      this.loadSelectedFridgeIngredients(FridgeState.selectedFridgeId);
      FridgeState.selectedFridgeId = 0;
      FridgeState.triggerMode = false;
    }
  }

  /**
   * 加载指定冰箱的食材
   */
  async loadSelectedFridgeIngredients(fridgeId: number): Promise<void> {
    try {
      const context = getContext(this);
      const fridge = await DbService.getFridgeById(context, fridgeId);
      if (fridge && fridge.ingredients.length > 0) {
        this.selectedIngredients = fridge.ingredients;
        this.hasNoIngredients = false;
        promptAction.showToast({ message: '已加载「' + fridge.name + '」的食材', duration: 1500 });
      }
    } catch (e) {
      console.error('StepThree: 加载冰箱食材失败', JSON.stringify(e));
    }
  }

  /** 跳转到冰箱选择页 */
  goToSelectFridge(): void {
    FridgeState.triggerMode = true;
    router.pushUrl({ url: 'pages/FridgePage', params: { mode: 'select' } });
  }

  build() {
    Column() {
      // 顶部进度条（三步全亮）+ 返回按钮
      Row() {
        Row()
          .width(40)
        Column() {
          Row() {
            this.stepDot(0, true)
            this.stepLine(true)
            this.stepDot(1, true)
            this.stepLine(true)
            this.stepDot(2, true)
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
      .margin({ top: 40, bottom: 12 })
      .padding({ left: 20, right: 20 })
      .alignItems(VerticalAlign.Center)

      // 标题区域
      Text('第三问')
        .fontSize(14)
        .fontColor($r('app.color.app_primary'))
        .fontWeight(FontWeight.Medium)
        .letterSpacing(4)
        .margin({ bottom: 4 })

      Text('现在家里有什么食材？')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 4 })

      Text('选一选你有的食材，AI将根据现有食材精准推荐')
        .fontSize(13)
        .fontColor($r('app.color.text_light'))
        .margin({ bottom: 8 })
        .textAlign(TextAlign.Center)
        .padding({ left: 16, right: 16 })

      // 已选食材概览 + 清空
      if (this.hasNoIngredients) {
        Row() {
          Text('🈚 你选择了家里没有任何食材')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FF6B35')
          Blank()
          Text('取消')
            .fontSize(12)
            .fontColor($r('app.color.text_light'))
            .onClick(() => {
              this.hasNoIngredients = false;
            })
        }
        .width('100%')
        .padding({ left: 4, right: 4, bottom: 6 })
      } else if (this.selectedIngredients.length > 0) {
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
              this.hasNoIngredients = false;
            })
        }
        .width('100%')
        .padding({ left: 4, right: 4, bottom: 6 })

        // ===== 已选食材标签展示（横向滑动，单行高度）=====
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
        .scrollable(ScrollDirection.Horizontal)
        .width('100%')
        .height(36)
        .margin({ bottom: 8 })
      }

      // 自定义食材输入
      Row() {
        TextInput({ placeholder: '输入不在列表中的食材，如瑶柱、松茸...', text: this.customIngredient })
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

        Button() {
          Text('添加')
            .fontSize(14)
            .fontColor(Color.White)
        }
        .width(60)
        .height(36)
        .backgroundColor($r('app.color.app_primary'))
        .borderRadius(18)
        .margin({ left: 8 })
        .onClick(() => {
          this.addCustomIngredient();
        })
      }
      .width('100%')
      .margin({ bottom: 8 })

      // ===== "使用预定的冰箱"按钮 =====
      Row() {
        Text('🧊 使用预定的冰箱')
          .fontSize(13)
          .fontColor($r('app.color.app_primary'))
          .fontWeight(FontWeight.Medium)

        Blank()

        Text('›')
          .fontSize(18)
          .fontColor($r('app.color.app_primary'))
      }
      .width('100%')
      .padding({ top: 8, bottom: 8, left: 12, right: 12 })
      .backgroundColor('rgba(255,107,53,0.06)')
      .borderRadius(10)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.goToSelectFridge();
      })

      // 滚动内容区 - 食材分类标签
      Scroll() {
        Column() {
          ForEach(INGREDIENT_CATEGORIES, (category: IngredientCategory, catIndex: number) => {
            this.ingredientCategory(category, catIndex)
          }, (item: IngredientCategory) => item.name)
        }
        .width('100%')
      }
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)

      // ===== "什么都没有" 按钮 =====
      Button() {
        Row() {
          Text('🈚')
            .fontSize(18)
            .margin({ right: 6 })
          Text('我家里什么食材都没有')
            .fontSize(15)
            .fontColor(this.hasNoIngredients ? Color.White : '#FF6B35')
            .fontWeight(FontWeight.Medium)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width('80%')
      .height(44)
      .backgroundColor(this.hasNoIngredients ? '#FF6B35' : 'rgba(255,107,53,0.10)')
      .borderRadius(22)
      .border({
        width: this.hasNoIngredients ? 0 : 1.5,
        color: '#FF6B35'
      })
.margin({ bottom: 12 })
      .onClick(() => {
        this.selectedIngredients = [];
        this.hasNoIngredients = !this.hasNoIngredients;
      })

      // 底部 AI推荐按钮
      Button() {
        Row() {
          Text(this.hasNoIngredients ? 'AI 推荐（无食材）→' : 'AI 根据食材推荐 →')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.isButtonEnabled() ? Color.White : $r('app.color.text_light'))

          if (!this.hasNoIngredients && this.selectedIngredients.length > 0) {
            Text('(' + this.selectedIngredients.length + ')')
              .fontSize(12)
              .fontColor(Color.White)
              .margin({ left: 4 })
          }
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .width('80%')
      .height(52)
      .backgroundColor(this.isButtonEnabled() ? $r('app.color.app_primary') : '#F0F0F0')
      .borderRadius(26)
.margin({ bottom: 56 })
      .enabled(this.isButtonEnabled())
      .opacity(this.showContent ? 1 : 0)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/Recommend',
          params: {
            category: this.category,
            time: this.time,
            budget: this.budget,
            diet: this.diet,
            ingredients: this.selectedIngredients,
            hasNoIngredients: this.hasNoIngredients
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .padding({ left: 20, right: 20 })
.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 判断底部按钮是否可用
   */
  isButtonEnabled(): boolean {
    return this.hasNoIngredients || this.selectedIngredients.length > 0;
  }

  /**
   * 添加自定义食材
   */
  addCustomIngredient(): void {
    const trimmed = this.customIngredient.trim();
    if (trimmed.length > 0 && this.selectedIngredients.indexOf(trimmed) < 0) {
      this.selectedIngredients = [...this.selectedIngredients, trimmed];
      // 用户手动添加食材时，自动取消"无食材"状态
      if (this.hasNoIngredients) {
        this.hasNoIngredients = false;
      }
    }
    this.customIngredient = '';
  }

  /**
   * 切换食材选择
   */
  toggleIngredient(item: string): void {
    const idx = this.selectedIngredients.indexOf(item);
    if (idx >= 0) {
      const newArr = this.selectedIngredients.slice();
      newArr.splice(idx, 1);
      this.selectedIngredients = newArr;
    } else {
      this.selectedIngredients = [...this.selectedIngredients, item];
      // 用户选择食材时，自动取消"无食材"状态
      if (this.hasNoIngredients) {
        this.hasNoIngredients = false;
      }
    }
  }

  /**
   * 移除单个已选食材
   */
  removeIngredient(item: string): void {
    const idx = this.selectedIngredients.indexOf(item);
    if (idx >= 0) {
      const newArr = this.selectedIngredients.slice();
      newArr.splice(idx, 1);
      this.selectedIngredients = newArr;
    }
  }

  /**
   * 判断分类中是否所有食材都已选中
   */
  isCategoryAllSelected(items: string[]): boolean {
    for (const item of items) {
      if (this.selectedIngredients.indexOf(item) < 0) {
        return false;
      }
    }
    return true;
  }

  /**
   * 切换分类全选/取消全选
   */
  toggleCategorySelectAll(items: string[]): void {
    const allSelected = this.isCategoryAllSelected(items);
    if (allSelected) {
      // 取消全选：从 selectedIngredients 中移除该分类的所有食材
      let newArr = this.selectedIngredients.slice();
      for (const item of items) {
        const idx = newArr.indexOf(item);
        if (idx >= 0) {
          newArr.splice(idx, 1);
        }
      }
      this.selectedIngredients = newArr;
    } else {
      // 全选：添加该分类中所有未选中的食材
      let newArr = this.selectedIngredients.slice();
      for (const item of items) {
        if (newArr.indexOf(item) < 0) {
          newArr = [...newArr, item];
        }
      }
      this.selectedIngredients = newArr;
    }
    // 用户操作时取消"无食材"状态
    if (this.hasNoIngredients) {
      this.hasNoIngredients = false;
    }
  }

  @Builder
  ingredientCategory(category: IngredientCategory, catIndex: number) {
    Column() {
      // 分类标题 + 全选/取消全选
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

        // 全选/取消全选按钮
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

      // 食材标签（流式布局使用Wrap）
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
}
