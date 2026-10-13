/**
 * FridgeState - 页面间传递选中冰箱的共享状态
 *
 * 用于 StepThree → FridgePage(选择模式) → 返回StepThree 的场景。
 * StepThree 设置 triggerMode = true，FridgePage 在 select 模式下
 * 设置 selectedFridgeId，StepThree 的 onPageShow 检测到后加载该冰箱食材。
 */
export class FridgeState {
  /** 是否为 StepThree 触发的选择模式 */
  static triggerMode: boolean = false;
  /** 用户选中的冰箱 id */
  static selectedFridgeId: number = 0;
}
