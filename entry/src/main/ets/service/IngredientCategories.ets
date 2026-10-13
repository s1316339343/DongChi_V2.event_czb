/**
 * IngredientCategories - 冰箱/食材选择器使用的食材分类常量
 *
 * 原先在 StepThree.ets 与 FridgeEditPage.ets 中逐字节重复了两份（各 37 行），
 * 任一处增删食材都会导致两个页面可选食材不一致，因此抽取为单一数据源。
 */
import { promptAction } from '@kit.ArkUI';

/** 食材分类 */
export interface IngredientCategory {
  name: string;
  icon: string;
  items: string[];
}

/** 七大食材分类（StepThree 与 FridgeEditPage 共用） */
export const INGREDIENT_CATEGORIES: IngredientCategory[] = [
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

/**
 * 追加用户自定义食材。
 * @returns 是否追加成功（空串或已存在时返回 false）
 */
export function appendCustomIngredient(selected: string[], raw: string): boolean {
  const name = raw.trim();
  if (name.length === 0) {
    return false;
  }
  if (selected.indexOf(name) >= 0) {
    promptAction.showToast({ message: '「' + name + '」已在列表中', duration: 1500 });
    return false;
  }
  selected.push(name);
  return true;
}
