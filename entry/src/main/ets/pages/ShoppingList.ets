import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import { fileIo as fs, fileUri, picker } from '@kit.CoreFileKit';
import pasteboard from '@ohos.pasteboard';

// 食材用量预估
interface IngredientItem {
  name: string;
  quantity: string;
  dishes: string[];   // 哪些菜需要该食材
}

/** 食材 → emoji 图标（模块级常量：原先在 getIngredientIcon 内每次调用都重建整个对象） */
const INGREDIENT_ICONS: Record<string, string> = {
  '番茄': '🍅', '土豆': '🥔', '胡萝卜': '🥕', '白菜': '🥬', '菠菜': '🥬',
  '生菜': '🥬', '黄瓜': '🥒', '茄子': '🍆', '青椒': '🌶️', '洋葱': '🧅',
  '大葱': '🧅', '姜': '🫚', '蒜': '🧄', '西兰花': '🥦', '花菜': '🥦',
  '豆角': '🫘', '蘑菇': '🍄', '金针菇': '🍄', '香菇': '🍄', '玉米': '🌽',
  '南瓜': '🎃', '冬瓜': '🥬', '芹菜': '🥬', '韭菜': '🥬', '豆芽': '🌱',
  '鸡蛋': '🥚', '鸡胸肉': '🍗', '鸡腿': '🍗', '鸡翅': '🍗', '猪肉': '🥩',
  '五花肉': '🥩', '排骨': '🍖', '瘦肉': '🥩', '牛肉': '🥩', '牛腩': '🥩',
  '羊肉': '🥩', '鸭肉': '🍗', '火腿肠': '🌭', '培根': '🥓', '腊肉': '🥩',
  '豆腐': '🫘', '嫩豆腐': '🫘', '豆腐干': '🫘', '千张': '🫘', '腐竹': '🫘',
  '豆皮': '🫘', '毛豆': '🫘', '黄豆': '🫘', '绿豆': '🫘',
  '虾': '🦐', '虾仁': '🦐', '鱼': '🐟', '鲫鱼': '🐟', '三文鱼': '🐟',
  '带鱼': '🐟', '蛤蜊': '🐚', '鱿鱼': '🦑', '螃蟹': '🦀', '扇贝': '🐚',
  '大米': '🍚', '米饭': '🍚', '面条': '🍜', '挂面': '🍜', '方便面': '🍜',
  '米粉': '🍜', '面粉': '🌾', '面包': '🍞', '馒头': '🥟', '年糕': '🍚',
  '燕麦': '🥣', '红薯': '🍠', '紫薯': '🍠',
  '牛奶': '🥛', '酸奶': '🥛', '黄油': '🧈', '芝士': '🧀', '淡奶油': '🥛',
  '炼乳': '🥛', '奶酪': '🧀',
  '油': '🫒', '盐': '🧂', '生抽': '🫗', '老抽': '🫗', '醋': '🫗', '料酒': '🫗',
  '蚝油': '🫗', '豆瓣酱': '🫗', '番茄酱': '🥫', '辣椒': '🌶️', '花椒': '🌶️',
  '八角': '⭐', '桂皮': '🪵', '白糖': '🧂', '蜂蜜': '🍯', '芝麻': '🫘',
  '辣椒酱': '🌶️', '黄豆酱': '🫗', '淀粉': '🌾', '胡椒粉': '🧂', '鸡精': '🧂',
  '孜然': '🌿', '蒜蓉': '🧄',
};

const QTY_VEGGIES: string[] = ['番茄', '土豆', '胡萝卜', '白菜', '菠菜', '生菜', '黄瓜', '茄子', '青椒', '洋葱',
  '西兰花', '花菜', '豆角', '玉米', '南瓜', '冬瓜', '芹菜', '韭菜', '豆芽', '大葱', '蒜苗',
  '空心菜', '油麦菜', '苋菜', '藕', '山药', '秋葵', '芦笋', '苦瓜', '丝瓜'];
const QTY_MEATS: string[] = ['鸡胸肉', '鸡腿', '鸡翅', '猪肉', '五花肉', '排骨', '瘦肉', '牛肉', '牛腩', '羊肉',
  '鸭肉', '培根', '腊肉', '里脊', '肥牛', '牛腱子', '猪蹄', '猪肝'];
const QTY_EGGS: string[] = ['鸡蛋', '鸭蛋', '皮蛋', '咸蛋'];
const QTY_DAIRY: string[] = ['牛奶', '酸奶', '黄油', '芝士', '淡奶油', '炼乳', '奶酪'];
const QTY_TOFU: string[] = ['豆腐', '嫩豆腐', '豆腐干', '千张', '腐竹', '豆皮', '毛豆', '黄豆', '绿豆'];
const QTY_SPICES: string[] = ['油', '盐', '生抽', '老抽', '醋', '料酒', '蚝油', '豆瓣酱', '番茄酱', '辣椒',
  '花椒', '八角', '桂皮', '白糖', '蜂蜜', '芝麻', '辣椒酱', '黄豆酱', '淀粉', '胡椒粉',
  '鸡精', '味精', '十三香', '孜然', '蒜蓉', '姜', '蒜'];

/** 精确匹配的用量（优先于模糊分类） */
const QTY_EXACT: Record<string, string> = {
  '鸡蛋': '2~3个',
  '米饭': '适量（约200g）',
  '面条': '适量（约200g）',
  '挂面': '适量（约200g）',
  '方便面': '1~2包',
  '火腿肠': '1~2根',
  '面包': '2~3片',
  '饺子皮': '适量（约20张）',
  '馄饨皮': '适量（约20张）',
  '粉丝': '1把',
  '粉条': '1把',
};

/**
 * 估算食材常用数量。
 * 桶顺序很关键：调味类必须排在蔬菜类之前，否则「番茄酱」「辣椒酱」会被
 * 「番茄」「辣椒」前缀命中而错拿蔬菜用量。
 */
function estimateQuantityOf(name: string): string {
  const exact: string | undefined = QTY_EXACT[name];
  if (exact !== undefined) {
    return exact;
  }
  if (QTY_SPICES.some(s => name.indexOf(s) >= 0)) return '适量';
  if (QTY_VEGGIES.some(v => name.indexOf(v) >= 0)) return '适量（1~2个）';
  if (QTY_MEATS.some(m => name.indexOf(m) >= 0)) return '200~300g';
  if (QTY_EGGS.some(e => name.indexOf(e) >= 0)) return '2~3个';
  if (QTY_DAIRY.some(d => name.indexOf(d) >= 0)) return '适量';
  if (QTY_TOFU.some(t => name.indexOf(t) >= 0)) return '200g';
  return '适量';
}

// 接收的菜品数据（简化版 Dish）
interface DishData {
  name: string;
  icon: string;
  time: string;
  cost: string;
  difficulty: string;
  hasIngredients: boolean;
  cookTime: string;
  deliveryTime: string;
  cookCost: number;
  deliveryCost: number;
  reason: string;
  requiredIngredients: string[];
}

@Entry
@Component
struct ShoppingList {
  @State dishes: DishData[] = [];
  @State hasNoIngredients: boolean = false;
  @State userIngredients: string[] = [];
  @State mergedList: IngredientItem[] = [];
  @State showContent: boolean = false;

  /**
   * 根据食材名估算常用数量
   */
  estimateQuantity(name: string): string {
    return estimateQuantityOf(name);
  }

  /**
   * 获取食材的emoji图标
   */
  getIngredientIcon(name: string): string {
    return INGREDIENT_ICONS[name] || '🥗';
  }

  /**
   * 合并食材清单：将多道菜的食材合并去重，标注用量和所属菜品
   * 自动过滤掉用户已有的食材（已在冰箱中的不加入购物清单）
   */
  mergeIngredients(dishes: DishData[]): IngredientItem[] {
    const map: Record<string, IngredientItem> = {};

    for (const dish of dishes) {
      for (const ing of dish.requiredIngredients) {
        // 跳过用户已有的食材
        if (this.isUserIngredient(ing)) {
          continue;
        }
        if (map[ing]) {
          // 已存在则追加菜品名
          if (map[ing].dishes.indexOf(dish.name) < 0) {
            map[ing].dishes.push(dish.name);
          }
        } else {
          map[ing] = {
            name: ing,
            quantity: this.estimateQuantity(ing),
            dishes: [dish.name],
          };
        }
      }
    }

    // 按食材名排序
    const items = Object.values(map);
    items.sort((a, b) => a.name.localeCompare(b.name, 'zh-CN'));
    return items;
  }


  /**
   * 判断食材是否已被用户拥有
   */
  isUserIngredient(ing: string): boolean {
    return !this.hasNoIngredients && this.userIngredients.indexOf(ing) >= 0;
  }

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      if (params['dishes'] !== undefined) {
        try {
          const parsed: Object = JSON.parse(params['dishes'] as string);
          if (Array.isArray(parsed)) {
            this.dishes = parsed as DishData[];
          } else {
            console.error('解析菜品数据失败：非数组');
          }
        } catch (_) {
          console.error('解析菜品数据失败');
        }
      }
      if (params['hasNoIngredients'] !== undefined) {
        // 严格判等：字符串 'false' 会被当作真值，从而反转整个过滤逻辑
        this.hasNoIngredients = params['hasNoIngredients'] === true;
      }
      if (params['userIngredients'] !== undefined) {
        try {
          const raw = JSON.parse(params['userIngredients'] as string) as string[];
          this.userIngredients = raw;
        } catch (_) {
          console.error('解析用户食材数据失败');
        }
      }
    }

    // 合并食材清单
    this.mergedList = this.mergeIngredients(this.dishes);

    // 入场动画
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
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

        Text('购物清单')
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

      if (this.dishes.length === 0) {
        // 空状态
        Column() {
          Text('🛒')
            .fontSize(64)
            .margin({ bottom: 16 })

          Text('暂无菜品数据')
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .height('60%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            // ===== 摘要头部 =====
            Row() {
              Text('🛒')
                .fontSize(32)
                .margin({ right: 12 })

              Column() {
                if (this.dishes.length === 1) {
                  Text(this.dishes[0].icon + ' ' + this.dishes[0].name + ' · ' + this.mergedList.length + ' 种食材')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                } else {
                  Text('共 ' + this.dishes.length + ' 道菜 · ' + this.mergedList.length + ' 种食材')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                }

              // 顶部小状态提示
              Row() {
                if (this.hasNoIngredients) {
                  Text('家中暂无食材，以下为所有所需食材清单')
                    .fontSize(13)
                    .fontColor($r('app.color.app_primary'))
                    .margin({ top: 2 })
                } else if (this.userIngredients.length > 0) {
                  Text('已排除 ' + this.userIngredients.length + ' 种家中已有食材')
                    .fontSize(13)
                    .fontColor('#4CAF50')
                    .margin({ top: 2 })
                } else {
                  Text('以下为需要购买的食材清单')
                    .fontSize(13)
                    .fontColor($r('app.color.app_primary'))
                    .margin({ top: 2 })
                }
              }
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .shadow({ radius: 6, color: 'rgba(0,0,0,0.06)', offsetY: 3 })
            .margin({ bottom: 16 })
            .opacity(this.showContent ? 1 : 0)
            .translate({ y: this.showContent ? 0 : 20 })

            // ===== 合并食材清单 =====
            if (this.mergedList.length > 0) {
              Text('─── 🧾 购物清单 ───')
                .fontSize(14)
                .fontColor($r('app.color.text_light'))
                .margin({ bottom: 12 })
                .opacity(this.showContent ? 1 : 0)

              ForEach(this.mergedList, (item: IngredientItem, index: number) => {
                this.ingredientCard(item, index)
              }, (item: IngredientItem) => item.name)
            }

            // ===== 各菜品所需食材分解 =====
            if (this.dishes.length > 0) {
              Text('─── 🍽️ 各菜品所需食材 ───')
                .fontSize(14)
                .fontColor($r('app.color.text_light'))
                .margin({ top: 8, bottom: 12 })
                .opacity(this.showContent ? 1 : 0)

              ForEach(this.dishes, (dish: DishData, index: number) => {
                this.dishIngredientsCard(dish, index)
              }, (item: DishData) => item.name)
            }

            // ===== 操作按钮 =====
            Row() {
              // 复制清单按钮
              Button() {
                Row() {
                  Text('📋')
                    .fontSize(16)
                    .margin({ right: 4 })
                  Text('复制清单')
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.app_primary'))
                }
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
              }
              .layoutWeight(1)
              .height(44)
              .backgroundColor(Color.White)
              .borderRadius(22)
              .border({ width: 1.5, color: $r('app.color.app_primary') })
              .margin({ right: 8 })
              .onClick(() => {
                this.copyShoppingList();
              })

              // 导出为文本按钮
              Button() {
                Row() {
                  Text('💾')
                    .fontSize(16)
                    .margin({ right: 4 })
                  Text('导出为文本')
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(Color.White)
                }
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
              }
              .layoutWeight(1)
              .height(44)
              .backgroundColor($r('app.color.app_primary'))
              .borderRadius(22)
              .shadow({ radius: 6, color: 'rgba(255,107,53,0.35)', offsetY: 3 })
              .onClick(() => {
                this.saveAsTextFile();
              })
            }
            .width('100%')
            .margin({ top: 16, bottom: 16 })
            .opacity(this.showContent ? 1 : 0)
            .translate({ y: this.showContent ? 0 : 20 })
          }
          .width('100%')
.padding({ left: 20, right: 20, bottom: 64 })
        }
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_bg'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 生成可复制的购物清单文本
   */
  generateShoppingListText(): string {
    let text = '🛒 购物清单\n';
    text += '═'.repeat(20) + '\n\n';

    // 合并清单
    text += '【需要购买的食材】\n';
    for (const item of this.mergedList) {
      text += `□ ${item.name}：${item.quantity}`;
      if (item.dishes.length > 0) {
        text += `（用于：${item.dishes.join('、')}）`;
      }
      text += '\n';
    }

    text += '\n' + '─'.repeat(16) + '\n\n';

    // 各菜品分解
    text += '【各菜品所需食材】\n';
    for (const dish of this.dishes) {
      text += `\n${dish.icon} ${dish.name}`;
      if (dish.requiredIngredients.length > 0) {
        text += '\n';
        for (const ing of dish.requiredIngredients) {
          const userHas = this.isUserIngredient(ing);
          text += userHas ? '  ✅ ' : '  🛒 ';
          text += ing + '\n';
        }
      }
      text += '\n';
    }

    text += '\n' + '═'.repeat(20) + '\n';
    text += `共 ${this.dishes.length} 道菜，需要购买 ${this.mergedList.length} 种食材\n`;
    if (!this.hasNoIngredients && this.userIngredients.length > 0) {
      text += `（已排除 ${this.userIngredients.length} 种家中已有食材）\n`;
    }
    text += '—— 来自「懂吃」App';

    return text;
  }

  /**
   * 复制购物清单到剪贴板
   */
  async copyShoppingList(): Promise<void> {
    try {
      const text = this.generateShoppingListText();
      const data = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
      const pb = pasteboard.getSystemPasteboard();
      await pb.setData(data);
      await promptAction.showToast({
        message: '✅ 购物清单已复制到剪贴板',
        duration: 2000,
      });
    } catch (error) {
      console.error('复制失败', JSON.stringify(error));
      await promptAction.showToast({
        message: '❌ 复制失败，请重试',
        duration: 2000,
      });
    }
  }

  /**
   * 导出为文本文件并保存到本地
   */
  async saveAsTextFile(): Promise<void> {
    try {
      const context = getContext(this);
      const text = this.generateShoppingListText();

      // 生成文件名（含时间戳）
      const now = new Date();
      const dateStr = `${now.getFullYear()}${(now.getMonth() + 1).toString().padStart(2, '0')}${now.getDate().toString().padStart(2, '0')}_${now.getHours().toString().padStart(2, '0')}${now.getMinutes().toString().padStart(2, '0')}`;
      const fileName = `购物清单_${dateStr}.txt`;

      // ① 交给用户选择保存位置（沙箱路径用户无法在"文件管理"里找到）
      let savedToUserVisible = false;
      try {
        const documentPicker = new picker.DocumentViewPicker();
        const uris = await documentPicker.save({ newFileNames: [fileName] });
        if (uris && uris.length > 0) {
          const file = fs.openSync(uris[0], fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
          try {
            fs.writeSync(file.fd, text);
          } finally {
            // 写入失败也必须关闭 fd，否则每次重试都泄漏一个描述符
            fs.closeSync(file);
          }
          savedToUserVisible = true;
        }
      } catch (pickErr) {
        console.warn('用户取消选择或保存器不可用，回退到应用目录：' + JSON.stringify(pickErr));
      }

      // ② 回退：写入应用沙箱，并告知完整路径
      if (!savedToUserVisible) {
        const filePath = context.filesDir + '/' + fileName;
        const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC);
        try {
          fs.writeSync(file.fd, text);
        } finally {
          fs.closeSync(file);
        }
        await promptAction.showToast({
          message: `✅ 已保存到应用目录：${filePath}`,
          duration: 3000,
        });
        console.info('购物清单已保存到：' + filePath);
        return;
      }

      await promptAction.showToast({
        message: `✅ 已保存：${fileName}`,
        duration: 3000,
      });
    } catch (error) {
      console.error('保存文件失败', JSON.stringify(error));
      await promptAction.showToast({
        message: '❌ 导出失败，请重试',
        duration: 2000,
      });
    }
  }

  // ===== 子组件 =====

  @Builder
  ingredientCard(item: IngredientItem, index: number) {
    Row() {
      Text(this.getIngredientIcon(item.name))
        .fontSize(24)
        .margin({ right: 12 })

      Column() {
        Text(item.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Text(item.quantity)
          .fontSize(13)
          .fontColor($r('app.color.text_light'))
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 用于哪些菜品
      Column() {
        ForEach(item.dishes, (dishName: string) => {
          Text(dishName)
            .fontSize(10)
            .fontColor($r('app.color.app_primary'))
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor('rgba(255,107,53,0.10)')
            .borderRadius(8)
            .margin({ top: 2 })
        }, (dishName: string) => dishName)
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
    .margin({ bottom: 8 })
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 15 + Math.min(index, 6) * 10 })
    .animation({ duration: 350, curve: Curve.Smooth, delay: Math.min(index, 6) * 40 })
  }

  @Builder
  dishIngredientsCard(dish: DishData, index: number) {
    Column() {
      // 菜品头部
      Row() {
        Text(dish.icon)
          .fontSize(24)
          .margin({ right: 10 })

        Text(dish.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Blank()

        // 食材状态
        if (this.hasNoIngredients) {
          Text('🛒')
            .fontSize(16)
        } else if (dish.hasIngredients) {
          Text('✅')
            .fontSize(16)
        } else {
          Text('⚠️')
            .fontSize(16)
        }
      }
      .width('100%')
      .margin({ bottom: 8 })

      // 食材列表
      if (dish.requiredIngredients.length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(dish.requiredIngredients, (ing: string) => {
            Row() {
              Text(this.getIngredientIcon(ing))
                .fontSize(14)
                .margin({ right: 4 })
              Text(ing)
                .fontSize(12)
                .fontColor(this.isUserIngredient(ing) ? '#4CAF50' : $r('app.color.text_secondary'))
              Text(this.isUserIngredient(ing) ? ' ✅' : ' 🛒')
                .fontSize(10)
            }
            .padding({ top: 4, bottom: 4, left: 10, right: 10 })
            .backgroundColor(this.isUserIngredient(ing) ? 'rgba(76,175,80,0.08)' : 'rgba(0,0,0,0.04)')
            .borderRadius(14)
            .border({ width: this.isUserIngredient(ing) ? 1 : 0, color: 'rgba(76,175,80,0.30)' })
            .margin({ right: 6, bottom: 6 })
          }, (ing: string) => ing)
        }
        .width('100%')
      } else {
        Text('无特殊食材要求')
          .fontSize(12)
          .fontColor($r('app.color.text_light'))
          .margin({ top: 4 })
      }
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
    .margin({ bottom: 8 })
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 15 + Math.min(index, 6) * 10 })
    .animation({ duration: 350, curve: Curve.Smooth, delay: Math.min(index, 6) * 40 })
  }
}
