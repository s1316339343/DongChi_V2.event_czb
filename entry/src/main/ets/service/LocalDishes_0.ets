import { LocalDish } from "./DishTypes";

// ===== �ҳ��嵭 (Category 0) =====

export const LOCAL_DISHES_0: LocalDish[] = [
  {
    name: '醋溜白菜', icon: '🥬', time: '10分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 15, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['白菜', '醋'],
    reason: '清爽脆嫩，简单快手，解腻必备'
  },
  {
    name: '蛋炒饭', icon: '🍚', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米饭', '鸡蛋'],
    reason: '剩饭翻身的经典，简单却充满幸福感'
  },
  {
    name: '清蒸鲈鱼', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 42, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '葱'],
    reason: '鲜嫩原味，蒸菜最健康，宴客也有面子'
  },
  {
    name: '红烧排骨', icon: '🍖', time: '40分钟', cost: '30元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 30, deliveryCost: 48, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['排骨', '生抽', '老抽', '白糖'],
    reason: '色泽红亮，软烂入味，适合慢慢享受的一餐'
  },
  {
    name: '蒜蓉西兰花', icon: '🥦', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['西兰花', '蒜'],
    reason: '脆嫩清爽，蒜香扑鼻，低脂又营养'
  },
  {
    name: '可乐鸡翅', icon: '🍗', time: '25分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 18, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡翅', '可乐', '生抽'],
    reason: '甜而不腻，简单零失败，大人小孩都爱'
  },
  {
    name: '酸辣土豆丝', icon: '🥔', time: '15分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 16, category: 0, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['土豆', '醋', '辣椒'],
    reason: '酸爽开胃，很便宜却超下饭的家常菜'
  },
  {
    name: '宫保鸡丁', icon: '🐔', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 15, deliveryCost: 30, category: 0, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡胸肉', '花生', '辣椒', '花椒'],
    reason: '麻辣鲜香，花生脆爽，经典下饭菜'
  },
  {
    name: '蚂蚁上树', icon: '🍜', time: '15分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 8, deliveryCost: 20, category: 0, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['粉丝', '猪肉', '豆瓣酱'],
    reason: '粉丝吸满肉汁，简单又美味的一盘菜'
  },
  {
    name: '冬瓜排骨汤', icon: '🥣', time: '40分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 22, deliveryCost: 38, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['冬瓜', '排骨', '姜'],
    reason: '清淡鲜美，暖心暖胃，适合慢慢炖煮'
  },
  {
    name: '鸡蛋羹', icon: '🥚', time: '10分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 4, deliveryCost: 14, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['鸡蛋'],
    reason: '嫩滑如布丁，老少皆宜的营养快手菜'
  },
  {
    name: '麻婆豆腐', icon: '🫘', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['豆腐', '豆瓣酱', '花椒', '辣椒'],
    reason: '麻辣嫩滑，几块钱就能搞定的人气下饭菜'
  },
  {
    name: '小炒肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 0, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['五花肉', '青椒', '蒜'],
    reason: '五花肉配辣椒，香而不腻，米饭杀手'
  },
  {
    name: '清炒时蔬', icon: '🥬', time: '8分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 15, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['白菜', '蒜'],
    reason: '健康清爽，保留蔬菜原味，每天都要吃青菜'
  },
  {
    name: '木耳炒鸡蛋', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['木耳', '鸡蛋'],
    reason: '黑木耳配鸡蛋，口感丰富，简单快捷的家常菜'
  },
  {
    name: '土豆炖牛肉', icon: '🥩', time: '40分钟', cost: '28元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 28, deliveryCost: 48, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['土豆', '牛肉', '生抽'],
    reason: '软烂入味，经典下饭菜，全家都爱'
  },
  {
    name: '西葫芦炒蛋', icon: '🥒', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['西葫芦', '鸡蛋'],
    reason: '清爽脆嫩，低脂健康，小朋友也爱吃'
  },
  {
    name: '干煸四季豆', icon: '🫘', time: '15分钟', cost: '8元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 8, deliveryCost: 20, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['四季豆', '蒜'],
    reason: '煸炒出香，外焦里嫩，下饭好帮手'
  },
  {
    name: '红烧茄子', icon: '🍆', time: '20分钟', cost: '8元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 8, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['茄子', '蒜', '生抽'],
    reason: '软糯入味，酱香四溢，素菜也能吃出肉味'
  },
  {
    name: '玉米排骨汤', icon: '🥣', time: '45分钟', cost: '28元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '45分钟', deliveryTime: '40分钟',
    cookCost: 28, deliveryCost: 46, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['排骨', '玉米', '胡萝卜'],
    reason: '鲜甜可口，汤清味美，温补养胃'
  },
  {
    name: '山药炒木耳', icon: '🥬', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['山药', '木耳', '胡萝卜'],
    reason: '脆嫩爽口，养胃又清肺，老少皆宜'
  },
  {
    name: '蒜苗回锅肉', icon: '🥬', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蒜苗', '五花肉'],
    reason: '蒜香浓郁，肉片焦香，不辣版回锅肉'
  },
  {
    name: '清炒豆苗', icon: '🌱', time: '8分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['豆苗'],
    reason: '清爽脆嫩，一分钟快炒，保留原汁原味'
  },
  {
    name: '西红柿牛腩', icon: '🍅', time: '50分钟', cost: '32元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '50分钟', deliveryTime: '45分钟',
    cookCost: 32, deliveryCost: 52, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['番茄', '牛肉', '洋葱'],
    reason: '酸甜浓郁，牛肉软烂，汤汁拌饭一绝'
  },
  {
    name: '清蒸带鱼', icon: '🐟', time: '20分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 22, deliveryCost: 38, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '葱'],
    reason: '鲜嫩肥美，简单蒸制，原汁原味的海鲜'
  },
  {
    name: '韭菜炒鸡蛋', icon: '🥬', time: '8分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['韭菜', '鸡蛋'],
    reason: '韭菜鲜嫩，鸡蛋软香，简单快手经典菜'
  },
  {
    name: '胡萝卜炒肉', icon: '🥕', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['胡萝卜', '猪肉'],
    reason: '胡萝卜甜脆，肉片鲜嫩，营养好吃'
  },
  {
    name: '香菇青菜', icon: '🍄', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['香菇', '青菜'],
    reason: '香菇肥厚，青菜清脆，清爽又鲜美'
  },
  {
    name: '藕片炒肉', icon: '🪷', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['莲藕', '猪肉'],
    reason: '藕片脆甜，肉片嫩滑，口感丰富'
  },
  {
    name: '葱爆羊肉', icon: '🐑', time: '15分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 42, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['羊肉', '大葱'],
    reason: '葱香四溢，羊肉鲜嫩，冬季暖身佳品'
  },
  {
    name: '白灼虾', icon: '🦐', time: '10分钟', cost: '20元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '25分钟',
    cookCost: 20, deliveryCost: 35, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 2,
    requiredIngredients: ['虾', '姜'],
    reason: '鲜甜弹牙，白灼最考验食材的新鲜度'
  },
  {
    name: '上汤娃娃菜', icon: '🥬', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['娃娃菜', '皮蛋', '火腿'],
    reason: '汤汁鲜美，娃娃菜软嫩，高颜值素菜'
  },
  {
    name: '芹菜炒肉', icon: '🥬', time: '12分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['芹菜', '猪肉'],
    reason: '芹菜脆嫩清香，肉丝嫩滑，口感清爽'
  },
  {
    name: '豆腐炖鱼头', icon: '🐟', time: '30分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 22, deliveryCost: 40, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼头', '豆腐', '姜'],
    reason: '鱼头鲜美，豆腐嫩滑，汤白味浓营养好'
  },
  {
    name: '蒜蓉豆角', icon: '🫘', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['豆角', '蒜'],
    reason: '蒜香浓郁，豆角翠绿，简单又下饭'
  },
  {
    name: '虾仁蒸蛋', icon: '🦐', time: '15分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡蛋', '虾'],
    reason: '蛋羹嫩滑如布丁，虾仁鲜美，老少皆宜'
  },
  {
    name: '青椒炒肉', icon: '🫑', time: '12分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 20, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['青椒', '猪肉'],
    reason: '青椒脆嫩，肉片焦香，最简单的家常下饭菜'
  },
  {
    name: '素炒蘑菇', icon: '🍄', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蘑菇', '蒜'],
    reason: '蘑菇鲜嫩多汁，素炒保留原香'
  },
  {
    name: '丝瓜炒蛋', icon: '🥒', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['丝瓜', '鸡蛋'],
    reason: '丝瓜清甜软滑，鸡蛋嫩香，清爽好吃'
  },
  {
    name: '山药排骨汤', icon: '🥣', time: '40分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 25, deliveryCost: 45, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['山药', '排骨', '姜'],
    reason: '山药绵密，排骨浓香，温补养胃'
  },
  {
    name: '冬瓜薏米汤', icon: '🥣', time: '30分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '30分钟',
    cookCost: 12, deliveryCost: 25, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['冬瓜', '薏米', '排骨'],
    reason: '祛湿消暑，清淡鲜美，夏天必备'
  },
  {
    name: '西芹炒百合', icon: '🥬', time: '8分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 12, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['西芹', '百合'],
    reason: '清爽脆嫩，润肺清心，素菜中的上品'
  },
  {
    name: '胡萝卜玉米排骨汤', icon: '🥕', time: '40分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 22, deliveryCost: 42, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['排骨', '胡萝卜', '玉米', '姜'],
    reason: '清甜暖胃，老少皆宜，一锅好汤'
  },
  {
    name: '南瓜小米粥', icon: '🎃', time: '20分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 14, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['南瓜', '小米'],
    reason: '香甜软糯，养胃暖身，早餐首选'
  },
  {
    name: '白灼菜心', icon: '🥬', time: '6分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '6分钟', deliveryTime: '18分钟',
    cookCost: 4, deliveryCost: 15, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['菜心', '生抽'],
    reason: '简单白灼，保留蔬菜原味，清爽可口'
  },
  {
    name: '清炒山药木耳', icon: '🥬', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 20, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['山药', '木耳'],
    reason: '山药脆滑，木耳爽口，清淡养生'
  },
  {
    name: '嫩豆腐汤', icon: '🥣', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['嫩豆腐', '葱花'],
    reason: '滑嫩清爽，汤鲜味美，三两下就搞定'
  },
  {
    name: '香菇油菜', icon: '🍄', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['香菇', '油菜'],
    reason: '香菇肥厚，油菜清脆，经典素菜搭配'
  },
  {
    name: '尖椒炒蛋', icon: '🌶️', time: '8分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['尖椒', '鸡蛋'],
    reason: '微辣清香，鸡蛋嫩滑，快手家常菜'
  },
  {
    name: '菜花炒肉', icon: '🥦', time: '12分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['菜花', '猪肉'],
    reason: '菜花吸收肉香，软中带脆，好吃不贵'
  },
  {
    name: '洋葱炒肉', icon: '🧅', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['洋葱', '猪肉'],
    reason: '洋葱焦甜，肉片嫩滑，成本低又下饭'
  },
  {
    name: '蒜苗炒肉', icon: '🥬', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['蒜苗', '猪肉'],
    reason: '蒜苗清香微辣，肉香四溢，春意盎然'
  },
  {
    name: '韭菜炒河虾', icon: '🦐', time: '8分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 35, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 2,
    requiredIngredients: ['韭菜', '河虾'],
    reason: '河虾鲜甜，韭菜提味，春天的时令鲜'
  },
  {
    name: '砂锅娃娃菜', icon: '🥬', time: '20分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['娃娃菜', '粉丝', '蒜'],
    reason: '娃娃菜清甜软烂，粉丝吸饱汤汁，暖心暖胃'
  },
  {
    name: '蜜汁鸡腿', icon: '🍗', time: '25分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '28分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鸡腿', '蜂蜜', '生抽'],
    reason: '外焦里嫩，蜜汁甜香，烤箱或平底锅都能做'
  },
  {
    name: '番茄牛肉', icon: '🥩', time: '30分钟', cost: '30元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '30分钟',
    cookCost: 30, deliveryCost: 48, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['番茄', '牛肉', '姜'],
    reason: '番茄酸甜，牛肉软嫩，汤汁拌饭绝了'
  },
  {
    name: '土豆炖鸡块', icon: '🥔', time: '25分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 35, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['土豆', '鸡腿', '生抽'],
    reason: '土豆绵软，鸡肉鲜嫩，一锅端的美味'
  },
  {
    name: '糖醋里脊', icon: '🥩', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '糖醋里脊做法简单零失败，厨房新手也能做'
  },
  {
    name: '清蒸排骨', icon: '🍖', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '清蒸排骨，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '白切鸡', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '白切鸡营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '盐焗鸡', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道盐焗鸡好吃又好做，强烈推荐'
  },
  {
    name: '豉汁蒸排骨', icon: '🍖', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的豉汁蒸排骨，配米饭一绝'
  },
  {
    name: '梅菜扣肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的梅菜扣肉，配米饭一绝'
  },
  {
    name: '粉蒸肉', icon: '🥩', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的粉蒸肉，配米饭一绝'
  },
  {
    name: '红烧肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '红烧肉做法简单零失败，厨房新手也能做'
  },
  {
    name: '糖醋鱼', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '糖醋鱼做法简单零失败，厨房新手也能做'
  },
  {
    name: '红烧鱼块', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '鲜香可口的红烧鱼块，配米饭一绝'
  },
  {
    name: '清炖鸡汤', icon: '🍲', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '鲜香可口的清炖鸡汤，配米饭一绝'
  },
  {
    name: '老母鸡汤', icon: '🍲', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '鲜香可口的老母鸡汤，配米饭一绝'
  },
  {
    name: '鲫鱼豆腐汤', icon: '🐟', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '鲫鱼豆腐汤营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '萝卜炖牛腩', icon: '🥩', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '萝卜炖牛腩做法简单零失败，厨房新手也能做'
  },
  {
    name: '番茄牛腩', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的番茄牛腩，配米饭一绝'
  },
  {
    name: '土豆烧牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '土豆烧牛肉做法简单零失败，厨房新手也能做'
  },
  {
    name: '洋葱炒牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的洋葱炒牛肉，配米饭一绝'
  },
  {
    name: '青椒牛肉丝', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '青椒牛肉丝，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '京酱肉丝', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的京酱肉丝，配米饭一绝'
  },
  {
    name: '木须肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '木须肉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '地三鲜', icon: '🍆', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '地三鲜，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '红烧豆腐', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '红烧豆腐，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '家常豆腐', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '家常豆腐，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '葱烧豆腐', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道葱烧豆腐好吃又好做，强烈推荐'
  },
  {
    name: '皮蛋豆腐', icon: '🫘', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '皮蛋豆腐营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '凉拌豆腐', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道凉拌豆腐好吃又好做，强烈推荐'
  },
  {
    name: '肉末茄子', icon: '🍆', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道肉末茄子好吃又好做，强烈推荐'
  },
  {
    name: '蒜蓉茄子', icon: '🍆', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的蒜蓉茄子，配米饭一绝'
  },
  {
    name: '蚝油生菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道蚝油生菜好吃又好做，强烈推荐'
  },
  {
    name: '蒜蓉油麦菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '蒜蓉油麦菜营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '清炒小白菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道清炒小白菜好吃又好做，强烈推荐'
  },
  {
    name: '香菇菜心', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '香菇菜心营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '蒜蓉空心菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '蒜蓉空心菜营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '清炒苋菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的清炒苋菜，配米饭一绝'
  },
  {
    name: '蒜蓉娃娃菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '蒜蓉娃娃菜做法简单零失败，厨房新手也能做'
  },
  {
    name: '上汤菠菜', icon: '🥬', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '上汤菠菜做法简单零失败，厨房新手也能做'
  },
  {
    name: '蒜蓉菠菜', icon: '🥬', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的蒜蓉菠菜，配米饭一绝'
  },
  {
    name: '白灼秋葵', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '白灼秋葵，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '蒜蓉秋葵', icon: '🫘', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '蒜蓉秋葵做法简单零失败，厨房新手也能做'
  },
  {
    name: '凉拌木耳', icon: '🍄', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '凉拌木耳，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '洋葱炒鸡蛋', icon: '🥚', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '洋葱炒鸡蛋营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '蒜苔炒肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '蒜苔炒肉做法简单零失败，厨房新手也能做'
  },
  {
    name: '豆角焖面', icon: '🍜', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道豆角焖面好吃又好做，强烈推荐'
  },
  {
    name: '莲藕排骨汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '莲藕排骨汤做法简单零失败，厨房新手也能做'
  },
  {
    name: '海带排骨汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '海带排骨汤，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '玉米胡萝卜汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '玉米胡萝卜汤，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '番茄蛋花汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '番茄蛋花汤营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '紫菜虾皮汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '鲜香可口的紫菜虾皮汤，配米饭一绝'
  },
  {
    name: '黄瓜蛋汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '黄瓜蛋汤营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '菠菜猪肝汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '鲜香可口的菠菜猪肝汤，配米饭一绝'
  },
  {
    name: '菌菇汤', icon: '🍄', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '菌菇汤做法简单零失败，厨房新手也能做'
  },
  {
    name: '豆腐青菜汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '鲜香可口的豆腐青菜汤，配米饭一绝'
  },
  {
    name: '冬瓜蛤蜊汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '鲜香可口的冬瓜蛤蜊汤，配米饭一绝'
  },
  {
    name: '韭菜盒子', icon: '🥟', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的韭菜盒子，配米饭一绝'
  },
  {
    name: '鸡蛋饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鸡蛋饼做法简单零失败，厨房新手也能做'
  },
  {
    name: '土豆丝饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '土豆丝饼，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '南瓜饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '南瓜饼，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '葱油饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道葱油饼好吃又好做，强烈推荐'
  },
  {
    name: '清炒豆芽', icon: '🌱', time: '8分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 3, deliveryCost: 13, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['豆芽', '蒜'],
    reason: '清脆爽口，便宜又健康，一分钟快炒'
  },
  {
    name: '肉末蒸蛋', icon: '🥚', time: '15分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 8, deliveryCost: 21, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['鸡蛋', '猪肉'],
    reason: '嫩滑蒸蛋配上肉末，营养美味，老少皆宜'
  },
  {
    name: '西红柿炒菜花', icon: '🍅', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['番茄', '菜花'],
    reason: '酸甜可口，菜花脆嫩，素菜也下饭'
  },
  {
    name: '蒜蓉蒿子秆', icon: '🥬', time: '6分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '6分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 16, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蒿子秆', '蒜'],
    reason: '蒜香扑鼻，清脆爽口，快手素菜'
  },
  {
    name: '板栗烧鸡', icon: '🍗', time: '30分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '40分钟',
    cookCost: 20, deliveryCost: 40, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鸡腿', '板栗', '生抽'],
    reason: '板栗香甜软糯，鸡肉鲜嫩入味，秋季必吃'
  },
  {
    name: '芥蓝炒牛肉', icon: '🥩', time: '15分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 20, deliveryCost: 40, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['芥蓝', '牛肉', '蒜'],
    reason: '芥蓝脆嫩，牛肉嫩滑，经典粤式家常菜'
  },
  {
    name: '酿豆腐', icon: '🫘', time: '25分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['豆腐', '猪肉', '香菇'],
    reason: '豆腐吸饱肉汁，嫩滑鲜香，客家经典菜'
  },
  {
    name: '青瓜炒肉片', icon: '🥒', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['黄瓜', '猪肉', '木耳'],
    reason: '青瓜脆嫩，肉片滑嫩，清爽不油腻'
  },
  {
    name: '银耳莲子羹', icon: '🥣', time: '30分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '40分钟',
    cookCost: 10, deliveryCost: 24, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 1,
    requiredIngredients: ['银耳', '莲子', '冰糖'],
    reason: '胶质满满，滋润养颜，甜而不腻'
  },
  {
    name: '栗子烧鸡', icon: '🍗', time: '30分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '40分钟',
    cookCost: 22, deliveryCost: 43, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鸡腿', '栗子', '生抽'],
    reason: '栗子粉糯香甜，鸡肉鲜嫩，秋冬必吃'
  },
  {
    name: '葱油拌面', icon: '🍜', time: '10分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 4, deliveryCost: 14, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面条', '葱', '生抽'],
    reason: '葱香扑鼻，简单快手，上海经典面食'
  },
  {
    name: '腐竹炒木耳', icon: '🥬', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['腐竹', '木耳', '胡萝卜'],
    reason: '腐竹软韧，木耳脆爽，素菜也下饭'
  },
  {
    name: '鸡蛋炒米粉', icon: '🍜', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米粉', '鸡蛋', '豆芽'],
    reason: '米粉Q弹，鸡蛋嫩香，快手主食'
  },
  {
    name: '红薯粥', icon: '🍠', time: '20分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 3, deliveryCost: 13, category: 0, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['红薯', '大米'],
    reason: '香甜软糯，暖胃养身，早餐好选择'
  },
  {
    name: '干锅手撕包菜', icon: '🥬', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 0, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['包菜', '干辣椒', '五花肉', '蒜'],
    reason: '焦香爽脆，微辣回甘，素菜中的下饭王'
  },
];