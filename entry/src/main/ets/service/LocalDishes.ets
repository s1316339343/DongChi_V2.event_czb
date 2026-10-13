import { LocalDish } from "./DishTypes";
import { LOCAL_DISHES_0 } from "./LocalDishes_0";
import { LOCAL_DISHES_1 } from "./LocalDishes_1";
import { LOCAL_DISHES_2 } from "./LocalDishes_2";
import { LOCAL_DISHES_3 } from "./LocalDishes_3";

// ========== 合并所有分类的菜品数据 ==========

export const LOCAL_DISHES: LocalDish[] = LOCAL_DISHES_0.concat(
  LOCAL_DISHES_1, LOCAL_DISHES_2, LOCAL_DISHES_3
);
