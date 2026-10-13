/**
 * NavigationBarService - 系统导航栏适配服务
 *
 * 提供统一的底部导航条安全区域适配能力：
 * 1. 获取底部导航条高度，为底部固定控件提供间距
 * 2. 获取系统安全区域，为可滚动内容提供底部padding
 * 3. 支持沉浸式场景（全屏/视频），动态隐藏/显示导航条
 */
import { window } from '@kit.ArkUI';

export class NavigationBarService {
  /** 底部导航条高度（vp）—— 缓存值，动态监听更新 */
  private static navBarHeight: number = 0;
  /** 是否已初始化 */
  private static initialized: boolean = false;
  /** 当前全屏沉浸模式是否激活 */
  private static immersiveMode: boolean = false;

  /**
   * 初始化导航栏适配服务
   * @param win 主窗口实例
   */
  static init(win: window.Window): void {
    if (this.initialized) return;

    try {
      // 获取当前导航条高度
      const avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.navBarHeight = avoidArea.bottomRect.height;
      this.initialized = true;

      // 监听导航条区域变化（折叠屏展开/收起、导航条显示/隐藏等）
      win.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          this.navBarHeight = avoidArea.bottomRect.height;
        }
      });
    } catch (err) {
      console.error('NavigationBarService init failed: ' + JSON.stringify(err));
    }
  }

  /**
   * 获取底部导航条高度（vp）
   */
  static getNavBarHeight(): number {
    return this.navBarHeight;
  }

  /**
   * 进入沉浸模式（全屏视频/游戏等）
   * 自动隐藏导航条，上滑恢复显示
   * @param win 主窗口实例
   */
  static async enterImmersiveMode(win: window.Window): Promise<void> {
    try {
      this.immersiveMode = true;
      // 隐藏导航条（用户上滑可临时唤出）
      await win.setWindowSystemBarEnable(['status']);
      console.info('NavigationBarService: 已进入沉浸模式');
    } catch (err) {
      console.error('NavigationBarService: 进入沉浸模式失败 ' + JSON.stringify(err));
    }
  }

  /**
   * 退出沉浸模式
   * 恢复导航条显示
   * @param win 主窗口实例
   */
  static async exitImmersiveMode(win: window.Window): Promise<void> {
    try {
      this.immersiveMode = false;
      // 恢复导航条和状态栏显示
      await win.setWindowSystemBarEnable(['navigation', 'status']);
      console.info('NavigationBarService: 已退出沉浸模式');
    } catch (err) {
      console.error('NavigationBarService: 退出沉浸模式失败 ' + JSON.stringify(err));
    }
  }

  /**
   * 当前是否在沉浸模式
   */
  static isImmersive(): boolean {
    return this.immersiveMode;
  }

  /**
   * 获取底部安全区域建议padding值（vp）
   * 为底部固定控件提供间距抬高，避免被导航条遮挡
   * @param existingBottomMargin 已有的底部margin值（vp）
   * @returns 建议的底部总间距（vp）
   */
  static getSafeBottomPadding(existingBottomMargin: number = 0): number {
    const navBarH = this.navBarHeight;
    if (navBarH <= 0) {
      // 无法获取导航条高度时，使用典型值（约40vp）+ 原有margin
      return existingBottomMargin + 16;
    }
    // 已有margin可以覆盖部分导航条高度，补足差值
    if (existingBottomMargin >= navBarH) {
      return existingBottomMargin;
    }
    // 需要额外增加间距让控件位于导航条上方
    return navBarH + 8;
  }
}
