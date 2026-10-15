/**
 * Favorites - 我的收藏页面
 *
 * 使用 relationalStore 本地数据库查询收藏的菜品
 * 纯本地，无任何联网功能
 */
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { DbService, FavoriteDish } from '../service/DbService';
import { RecommendService } from '../service/RecommendService';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Favorites {
  @State showContent: boolean = false;
  @State favorites: FavoriteDish[] = [];
  @State isLoading: boolean = true;

  aboutToAppear(): void {
    // 仅做进入动画，数据加载延迟到 onPageShow 统一处理
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  /**
   * 每次页面显示时刷新数据（包括首次打开和从其他页面返回时）
   */
  onPageShow(): void {
    const context = getContext(this);
    this.loadFavorites(context);
  }

  /**
   * 从本地数据库加载收藏列表
   */
  async loadFavorites(context: common.Context): Promise<void> {
    this.isLoading = true;
    try {
      this.favorites = await DbService.getAllFavorites(context);
    } catch (error) {
      console.error('加载收藏列表失败：', JSON.stringify(error));
      this.favorites = [];
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 取消收藏
   */
  async removeFavorite(dish: FavoriteDish): Promise<void> {
    const context = getContext(this);
    try {
      await DbService.removeFavorite(context, dish.dishName);
      // 刷新列表
      await this.loadFavorites(context);
      // 标记偏好缓存失效
      RecommendService.markProfileDirty();
    } catch (error) {
      console.error('取消收藏失败：', JSON.stringify(error));
    }
  }

  /**
   * 确认全部删除
   */
  async confirmRemoveAll(): Promise<void> {
    try {
      const result = await promptAction.showDialog({
        title: '确认删除',
        message: '确定要删除全部收藏吗？此操作不可恢复。',
        buttons: [
          {
            text: '取消',
            color: '#999999'
          },
          {
            text: '删除',
            color: '#FF4444'
          }
        ]
      });
      if (result.index === 1) {
        const context = getContext(this);
        await this.removeAllFavorites(context);
      }
    } catch (error) {
      console.error('确认删除对话框出错：', JSON.stringify(error));
    }
  }

  /**
   * 删除全部收藏
   */
  async removeAllFavorites(context: common.Context): Promise<void> {
    try {
      await DbService.deleteAllFavorites(context);
      await this.loadFavorites(context);
      // 收藏已全部清空，标记偏好缓存失效
      RecommendService.markProfileDirty();
    } catch (error) {
      console.error('删除全部收藏失败：', JSON.stringify(error));
    }
  }

  /**
   * 格式化时间
   */
  formatDate(isoStr: string): string {
    try {
      const date = new Date(isoStr);
      const m = String(date.getMonth() + 1).padStart(2, '0');
      const d = String(date.getDate()).padStart(2, '0');
      return `${m}月${d}日`;
    } catch (_) {
      return isoStr;
    }
  }

  /**
   * 价格显示（无有效价格时显示 -）
   */
  formatCost(cost: number): string {
    return cost > 0 ? '¥' + cost : '-';
  }

  /**
   * 外卖价格显示（无有效价格时显示 -）
   */
  formatDeliveryCost(cost: number): string {
    return cost > 0 ? '约 ¥' + cost : '-';
  }

  // "看教程" — 联网功能暂未开放
  async openTutorial(): Promise<void> {
    try {
      await promptAction.showDialog({
        title: '联网功能暂未开发',
        message: '联网功能暂未开发，敬请期待',
        buttons: [
          {
            text: '好的',
            color: '#4CAF50'
          }
        ]
      });
    } catch (_) {
      console.error('对话框取消或出错');
    }
  }

  // "点外卖" — 联网功能暂未开放
  async openDelivery(): Promise<void> {
    try {
      await promptAction.showDialog({
        title: '联网功能暂未开发',
        message: '联网功能暂未开发，敬请期待',
        buttons: [
          {
            text: '好的',
            color: '#4CAF50'
          }
        ]
      });
    } catch (_) {
      console.error('对话框取消或出错');
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

        Text('我的收藏')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Blank()

        // 全部删除按钮
        if (this.favorites.length > 0) {
          Text('全部删除')
            .fontSize(13)
            .fontColor('#FF4444')
            .onClick(() => {
              this.confirmRemoveAll();
            })
        } else {
          Text('  ')
            .fontSize(22)
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 16 })
      .alignItems(VerticalAlign.Center)

      // ========== 内容区 ==========
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
      } else if (this.favorites.length === 0) {
        // 空状态
        Column() {
          Text('❤️')
            .fontSize(64)
            .margin({ bottom: 16 })

          Text('暂无收藏')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .margin({ bottom: 8 })

          Text('在推荐结果中点击 ♥ 即可收藏菜品')
            .fontSize(14)
            .fontColor($r('app.color.text_light'))
        }
        .width('100%')
        .height('70%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 收藏列表
        Scroll() {
          Column() {
            ForEach(this.favorites, (dish: FavoriteDish, index: number) => {
              this.favoriteCard(dish, index)
            }, (dish: FavoriteDish, index: number) => (dish.id ?? index).toString())
          }
          .width('100%')
          .padding({ left: 20, right: 20, bottom: 36 })
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

  @Builder
  favoriteCard(dish: FavoriteDish, index: number) {
    Column() {
      Row() {
        // 菜品图标
        Text(dish.dishIcon || '🍽️')
          .fontSize(40)
          .margin({ right: 16 })

        // 菜品信息
        Column() {
          // 菜名 + 难度
          Row() {
            Text(dish.dishName)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))
              .layoutWeight(1)

            if (dish.difficulty) {
              Text(dish.difficulty)
                .fontSize(13)
                .fontColor('#FFB300')
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          // 时间 + 价格
          Row() {
            Row() {
              Text('⏱')
                .fontSize(12)
                .margin({ right: 3 })
              Text(dish.time || dish.cookTime || '')
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
            }
            .margin({ right: 16 })

            Row() {
              Text('💰')
                .fontSize(12)
                .margin({ right: 3 })
              Text('自做' + this.formatCost(dish.cookCost) + '/外卖' + this.formatCost(dish.deliveryCost))
                .fontSize(13)
                .fontColor($r('app.color.text_secondary'))
            }
          }
          .width('100%')
          .margin({ top: 6 })
          .alignItems(VerticalAlign.Center)

          // 推荐理由
          if (dish.reason) {
            Text(dish.reason)
              .fontSize(12)
              .fontColor($r('app.color.text_light'))
              .width('100%')
              .margin({ top: 6 })
              .lineHeight(16)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          // 收藏时间
          if (dish.createdAt) {
            Text('收藏于 ' + this.formatDate(dish.createdAt))
              .fontSize(11)
              .fontColor('#CCCCCC')
              .width('100%')
              .margin({ top: 6 })
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 取消收藏按钮
        Column() {
          Text('❤️')
            .fontSize(22)
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.removeFavorite(dish);
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      // 自己做 vs 外卖对比
      Row() {
        // 自己做
        Column() {
          Text('👨‍🍳 自己做')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Text(dish.cookTime)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })

          Text(this.formatCost(dish.cookCost))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.state_success'))
            .margin({ top: 2 })

          Button() {
            Text('看教程')
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(80)
          .height(28)
          .backgroundColor($r('app.color.state_success'))
          .borderRadius(14)
          .margin({ top: 8 })
          .onClick(() => {
            this.openTutorial();
          })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(10)

        // VS
        Text('VS')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_light'))

        // 点外卖
        Column() {
          Text('🛵 点外卖')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Text(dish.deliveryTime)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })

          Text(this.formatDeliveryCost(dish.deliveryCost))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.app_primary'))
            .margin({ top: 2 })

          Button() {
            Text('点外卖')
              .fontSize(12)
              .fontColor(Color.White)
          }
          .width(80)
          .height(28)
          .backgroundColor($r('app.color.app_primary'))
          .borderRadius(14)
          .margin({ top: 8 })
          .onClick(async () => {
            await this.openDelivery();
          })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(10)
      }
      .width('100%')
      .padding({ top: 12 })
      .margin({ top: 8 })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(14)
    .padding(16)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
    .margin({ top: index > 0 ? 12 : 0 })
    .opacity(this.showContent ? 1 : 0)
    .translate({ y: this.showContent ? 0 : 20 + index * 10 })
    .animation({ duration: 400 + index * 80, curve: Curve.Smooth })
  }
}
