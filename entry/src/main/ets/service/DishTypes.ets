/**
 * DishTypes - 菜品相关类型定义和常量
 *
 * 从 RecommendService.ets 拆分，包含所有接口和常量定义
 */

// ========== 菜品类型定义 ==========

// 返回的菜品推荐
export interface AiDish {
  name: string;
  icon: string;
  time: string;        // 自己做需要的时间描述，如"15分钟"
  cost: string;        // 自己做成本，如"8元"
  difficulty: string;  // 难度，如"⭐"、"⭐⭐"
  hasIngredients: boolean;
  cookTime: string;    // 具体做菜时间，如"15分钟"
  deliveryTime: string; // 外卖配送时间，如"25分钟"
  cookCost: number;    // 自己做花费金额
  deliveryCost: number; // 外卖花费金额
  reason: string;      // 推荐理由
  requiredIngredients: string[];  // 所需食材列表
}

// 用户条件
export interface RecommendConditions {
  category: number;
  categoryName: string;
  time: number;
  timeLabel: string;
  budget: number;
  budgetLabel: string;
  diet: number[];
  dietLabels: string[];
  ingredients: string[];
  hasNoIngredients: boolean;
}

// 本地菜品（比AiDish多了标签字段用于筛选）
export interface LocalDish extends AiDish {
  category: number;       // 所属口味分类 0-家常清淡 1-重口过瘾 2-健康轻食 3-快餐速食
  isSpicy: boolean;        // 是否辣
  hasCoriander: boolean;   // 是否含香菜
  isSeafood: boolean;      // 是否海鲜
  isVegetarian: boolean;   // 是否素食
  timeRank: number;        // 时间等级 0-10分钟 1-30分钟 2-1小时以上
  budgetRank: number;      // 预算等级 0-10元 1-20元 2-50元 3-不限
}

// 推荐结果：菜品列表 + 来源标识
export interface RecommendResult {
  dishes: AiDish[];
  isLocal: boolean;
  /** AI 失败的具体原因（isLocal 为 true 时填写，用于弹窗告知用户） */
  failReason?: string;
}

// 带分数的推荐菜品
export interface ScoredDish {
  dish: LocalDish;
  score: number;
}


// ========== 菜品详情类型定义 ==========

// 营养信息
export interface NutritionInfo {
  calories: string;   // 热量，如 "180~250 kcal"
  protein: string;    // 蛋白质，如 "8~15g"
  fat: string;        // 脂肪
  carbs: string;      // 碳水化合物
}

// 菜品详情（步骤 + 营养）
export interface DishDetailInfo {
  steps: string[];           // 文字步骤列表
  nutrition: NutritionInfo;  // 营养估算
}

// ========== 分类标签常量 ==========

export const CATEGORY_NAMES: string[] = ['家常清淡', '重口过瘾', '健康轻食', '快餐速食'];
export const TIME_LABELS: string[] = ['10分钟搞定', '30分钟', '1小时以上'];
export const BUDGET_LABELS: string[] = ['10元以内', '20元以内', '50元以内', '不设限'];
export const DIET_LABELS: string[] = ['不吃辣', '不吃香菜', '不吃海鲜', '素食'];
