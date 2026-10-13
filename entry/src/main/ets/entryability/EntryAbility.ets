import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

/**
 * 配置系统导航栏和状态栏为沉浸式效果
 * @param win 主窗口实例
 */
function configureSystemBars(win: window.Window): void {
  try {
    // 设置应用为全屏布局，允许绘制到系统栏区域下方
    win.setWindowLayoutFullScreen(true);

    // 设置系统导航栏和状态栏颜色与应用背景融合
    win.setWindowSystemBarProperties({
      navigationBarColor: '#FFF5F0',      // 与 app_bg (#FFF5F0) 保持一致实现沉浸融合
      navigationBarContentColor: '#2D2D2D', // 导航栏图标用深色
      statusBarColor: '#FFF5F0',           // 与 app_bg 保持一致
      statusBarContentColor: '#2D2D2D',    // 状态栏图标用深色
    });
  } catch (err) {
    hilog.error(DOMAIN, 'testTag', 'Failed to configure system bars. Cause: %{public}s', JSON.stringify(err));
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // ==== 底部导航条沉浸适配：配置全屏布局 + 导航条颜色 ====
    try {
      const mainWindow = windowStage.getMainWindowSync();
      configureSystemBars(mainWindow);

      // 监听系统栏区域变化（导航条显示/隐藏/大小变化），实时调整适配
      mainWindow.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          hilog.info(DOMAIN, 'testTag', 'Navigation area changed, area: %{public}s',
            JSON.stringify(data.area));
        }
      });
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to setup window. Cause: %{public}s', JSON.stringify(err));
    }

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}