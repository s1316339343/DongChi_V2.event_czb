import { LocalDish } from "./DishTypes";

// ===== ������ʳ (Category 2) =====

export const LOCAL_DISHES_2: LocalDish[] = [
  {
    name: '鸡胸肉沙拉', icon: '🥗', time: '10分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['鸡胸肉', '生菜', '番茄', '沙拉酱'],
    reason: '高蛋白低脂肪，减脂增肌的首选'
  },
  {
    name: '水果燕麦碗', icon: '🥣', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['燕麦', '酸奶', '水果'],
    reason: '水果清甜燕麦饱腹，三分钟搞定营养早餐'
  },
  {
    name: '蔬菜三明治', icon: '🥪', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面包', '生菜', '番茄', '沙拉酱'],
    reason: '清爽不腻，蔬菜满满，野餐必备'
  },
  {
    name: '酸奶水果杯', icon: '🫐', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '18分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['酸奶', '水果'],
    reason: '酸甜可口，颜值超高，健康小甜品'
  },
  {
    name: '蔬菜卷饼', icon: '🌯', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面粉', '生菜', '黄瓜'],
    reason: '卷饼包裹新鲜蔬菜，营养均衡又方便'
  },
  {
    name: '清蒸三文鱼', icon: '🐟', time: '20分钟', cost: '28元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 28, deliveryCost: 48, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['三文鱼', '姜'],
    reason: '三文鱼富含Omega-3，清蒸保留原汁原味'
  },
  {
    name: '藜麦沙拉', icon: '🥗', time: '15分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 30, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['生菜', '番茄', '黄瓜'],
    reason: '藜麦是全营养谷物，搭配蔬菜清爽又抗饿'
  },
  {
    name: '南瓜浓汤', icon: '🎃', time: '20分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['南瓜', '牛奶'],
    reason: '南瓜天然甜味，浓汤丝滑暖胃'
  },
  {
    name: '水煮蛋全麦面包', icon: '🥚', time: '8分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 15, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['鸡蛋', '面包'],
    reason: '优质蛋白+粗粮碳水，简单却完美的轻食组合'
  },
  {
    name: '蔬菜豆腐汤', icon: '🫘', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['豆腐', '青菜', '番茄'],
    reason: '清淡鲜美，嫩豆腐配青菜，暖身又低卡'
  },
  {
    name: '凉拌黄瓜', icon: '🥒', time: '8分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 3, deliveryCost: 14, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['黄瓜', '蒜', '醋'],
    reason: '脆嫩爽口，开胃解腻，百吃不厌'
  },
  {
    name: '蒸红薯酸奶', icon: '🍠', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['红薯', '酸奶'],
    reason: '红薯甘甜酸奶丝滑，膳食纤维满满'
  },
  {
    name: '菠菜鸡蛋饼', icon: '🥞', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['菠菜', '鸡蛋', '面粉'],
    reason: '菠菜鸡蛋黄金搭配，软嫩营养又好看'
  },
  {
    name: '番茄蔬菜汤', icon: '🍅', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['番茄', '鸡蛋', '青菜'],
    reason: '酸甜开胃，满满茄红素，轻食也能很满足'
  },
  {
    name: '黑米杂粮饭', icon: '🍚', time: '20分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '22分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['黑米', '糙米'],
    reason: '富含膳食纤维，低脂饱腹，健康主食首选'
  },
  {
    name: '烟熏三文鱼牛油果卷', icon: '🥑', time: '10分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '25分钟',
    cookCost: 22, deliveryCost: 38, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 2,
    requiredIngredients: ['三文鱼', '牛油果'],
    reason: '无需烹饪，健康脂肪+优质蛋白，轻食之王'
  },
  {
    name: '紫菜蛋花汤', icon: '🥣', time: '8分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '16分钟',
    cookCost: 3, deliveryCost: 12, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['紫菜', '鸡蛋'],
    reason: '清淡鲜美，零脂肪，暖胃好汤'
  },
  {
    name: '鸡丝凉面', icon: '🍜', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '鸡胸肉', '黄瓜'],
    reason: '低脂高蛋白，清爽开胃，夏日轻食首选'
  },
  {
    name: '藜麦水果沙拉', icon: '🥗', time: '8分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 15, deliveryCost: 28, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['藜麦', '水果'],
    reason: '超级食物+维生素，高颜值健康碗'
  },
  {
    name: '鲜虾牛油果沙拉', icon: '🥗', time: '10分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '25分钟',
    cookCost: 20, deliveryCost: 35, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 2,
    requiredIngredients: ['虾', '牛油果', '蔬菜'],
    reason: '高蛋白优质脂肪，营养全面又美味'
  },
  {
    name: '冬瓜薏仁汤', icon: '🥣', time: '25分钟', cost: '5元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '25分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 0,
    requiredIngredients: ['冬瓜', '薏仁'],
    reason: '祛湿消肿，清爽低卡，夏日养生汤'
  },
  {
    name: '全麦鸡肉卷饼', icon: '🌯', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡胸肉', '全麦饼', '生菜'],
    reason: '低卡高蛋白，饱腹感强，健身餐首选'
  },
  {
    name: '玉米南瓜糊', icon: '🎃', time: '20分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '22分钟',
    cookCost: 6, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['玉米', '南瓜'],
    reason: '天然香甜，顺滑暖胃，低脂粗粮好搭档'
  },
  {
    name: '什锦蔬菜沙拉', icon: '🥗', time: '8分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 8, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['生菜', '黄瓜', '番茄'],
    reason: '色彩缤纷，清爽可口，每天都要吃够蔬菜'
  },
  {
    name: '豆腐皮卷', icon: '🫘', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['豆腐皮', '黄瓜', '胡萝卜'],
    reason: '低脂高蛋白，清爽脆嫩，减脂期好选择'
  },
  {
    name: '鱼肉蔬菜饼', icon: '🐟', time: '15分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鱼肉', '蔬菜', '鸡蛋'],
    reason: '无油煎制，外酥里嫩，高蛋白低脂肪'
  },
  {
    name: '绿豆汤', icon: '🥣', time: '30分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '22分钟',
    cookCost: 4, deliveryCost: 12, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 0,
    requiredIngredients: ['绿豆', '冰糖'],
    reason: '清热解暑，消暑必备，冰镇更好喝'
  },
  {
    name: '水果燕麦酸奶杯', icon: '🫐', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '18分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['燕麦', '酸奶', '水果'],
    reason: '颜值超高，营养均衡，早餐轻食两相宜'
  },
  {
    name: '虾仁西兰花', icon: '🥦', time: '12分钟', cost: '16元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 16, deliveryCost: 30, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['虾', '西兰花'],
    reason: '低脂高蛋白，翠绿鲜嫩，健身餐标配'
  },
  {
    name: '山药小米粥', icon: '🥣', time: '25分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '22分钟',
    cookCost: 5, deliveryCost: 14, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 0,
    requiredIngredients: ['山药', '小米'],
    reason: '养胃暖身，绵密顺滑，早餐好选择'
  },
  {
    name: '蔬菜鸡胸肉汤', icon: '🥣', time: '20分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡胸肉', '蔬菜', '姜'],
    reason: '清淡鲜美，高蛋白低脂，暖身又营养'
  },
  {
    name: '烤南瓜鹰嘴豆', icon: '🎃', time: '25分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '25分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 1,
    requiredIngredients: ['南瓜', '鹰嘴豆'],
    reason: '烤制香甜，高纤维高蛋白，素食者最爱'
  },
  {
    name: '海带豆腐汤', icon: '🥣', time: '15分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['海带', '豆腐'],
    reason: '清爽低卡，补碘补钙，简单又营养'
  },
  {
    name: '鲜果拼盘', icon: '🍉', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '15分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['水果'],
    reason: '色彩缤纷，天然维生素，清新解腻'
  },
  {
    name: '白灼芥兰', icon: '🥬', time: '8分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['芥兰'],
    reason: '脆嫩爽口，最简单的烹饪，最纯正的味道'
  },
  {
    name: '番茄豆腐汤', icon: '🍅', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['番茄', '豆腐'],
    reason: '酸甜开胃，豆腐嫩滑，低卡饱腹'
  },
  {
    name: '菠菜粉丝', icon: '🥬', time: '10分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['菠菜', '粉丝', '蒜'],
    reason: '清爽不油腻，粉丝吸满汤汁，简单又美味'
  },
  {
    name: '青豆玉米粒', icon: '🫛', time: '10分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['青豆', '玉米'],
    reason: '清甜可口，色彩好看，小朋友的最爱'
  },
  {
    name: '水果寿司卷', icon: '🍣', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '水果', '海苔'],
    reason: '清甜清爽，颜值高，健康又美味'
  },
  {
    name: '椰香芒果饭', icon: '🥭', time: '20分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['糯米', '芒果', '椰奶'],
    reason: '椰香浓郁，芒果清甜，东南亚风情甜品'
  },
  {
    name: '蓝莓酸奶碗', icon: '🫐', time: '3分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '3分钟', deliveryTime: '16分钟',
    cookCost: 10, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['酸奶', '蓝莓', '燕麦'],
    reason: '不用开火，三分钟搞定，健康又美味'
  },
  {
    name: '牛油果吐司', icon: '🥑', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '18分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面包', '牛油果'],
    reason: '绵密牛油果配烤吐司，ins风早午餐在家做'
  },
  {
    name: '番茄意面', icon: '🍝', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['意大利面', '番茄', '洋葱'],
    reason: '酸甜可口，简单西餐，比外卖好吃又干净'
  },
  {
    name: '藜麦鸡肉碗', icon: '🥗', time: '20分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 35, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['藜麦', '鸡胸肉', '西兰花'],
    reason: '超级食物藜麦，搭配鸡胸和蔬菜，健身餐天花板'
  },
  {
    name: '紫菜包饭', icon: '🍙', time: '15分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['米饭', '海苔', '黄瓜', '鸡蛋'],
    reason: '清爽不油腻，野餐便当首选，简单又快手'
  },
  {
    name: '煮玉米', icon: '🌽', time: '15分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '18分钟',
    cookCost: 4, deliveryCost: 14, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['玉米'],
    reason: '水煮十分钟，最纯净的谷物香甜'
  },
  {
    name: '紫薯牛奶', icon: '🥛', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['紫薯', '牛奶'],
    reason: '紫薯绵密搭配牛奶，暖胃又养颜'
  },
  {
    name: '蒸红薯', icon: '🍠', time: '20分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '18分钟',
    cookCost: 3, deliveryCost: 12, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['红薯'],
    reason: '蒸一蒸就搞定，香甜绵密，最健康的零食'
  },
  {
    name: '红豆薏米水', icon: '🥤', time: '20分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '18分钟',
    cookCost: 4, deliveryCost: 12, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['红豆', '薏米'],
    reason: '祛湿消肿，养生必备，比奶茶健康百倍'
  },
  {
    name: '蔬菜沙拉', icon: '🥗', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '18分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['生菜', '圣女果', '黄瓜'],
    reason: '五彩缤纷，清爽开胃，低卡零负担'
  },
  {
    name: '柠檬蜂蜜水', icon: '🍋', time: '2分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '2分钟', deliveryTime: '14分钟',
    cookCost: 3, deliveryCost: 12, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['柠檬', '蜂蜜'],
    reason: '维C满满，美白养颜，每天一杯好气色'
  },
  {
    name: '鸡蛋蔬菜卷饼', icon: '🌯', time: '12分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面粉', '鸡蛋', '生菜'],
    reason: '卷饼裹一切，营养丰富，快手早餐首选'
  },
  {
    name: '红枣枸杞茶', icon: '🍵', time: '10分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '14分钟',
    cookCost: 3, deliveryCost: 10, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['红枣', '枸杞'],
    reason: '暖暖一杯，补气养血，养生女孩必备'
  },
  {
    name: '香蕉松饼', icon: '🥞', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['香蕉', '面粉', '鸡蛋'],
    reason: '不用加糖，香蕉自带甜味，松软香甜'
  },
  {
    name: '秋葵蒸蛋', icon: '🥚', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['秋葵', '鸡蛋'],
    reason: '嫩滑蒸蛋配上秋葵星星切面，好看又好吃'
  },
  {
    name: '凉拌海带丝', icon: '🥬', time: '8分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 4, deliveryCost: 15, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['海带', '蒜', '醋'],
    reason: '酸爽开胃，低卡高纤维，夏日凉菜必吃'
  },
  {
    name: '燕麦拿铁', icon: '☕', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 8, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['燕麦奶', '咖啡'],
    reason: '植物奶低卡健康，在家复刻咖啡馆味道'
  },
  {
    name: '草莓酸奶昔', icon: '🍓', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 10, deliveryCost: 22, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['草莓', '酸奶'],
    reason: '酸甜可口，水果搅拌即饮，比奶茶健康'
  },
  {
    name: '蔬菜小米粥', icon: '🥣', time: '20分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '22分钟',
    cookCost: 5, deliveryCost: 15, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['小米', '青菜', '胡萝卜'],
    reason: '清淡养胃，蔬菜鲜甜，早餐暖胃粥'
  },
  {
    name: '鸡蛋土豆沙拉', icon: '🥗', time: '15分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['土豆', '鸡蛋', '沙拉酱'],
    reason: '绵密土豆搭配水煮蛋，简单饱腹又营养'
  },
  {
    name: '牛油果鸡肉卷', icon: '🥑', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的牛油果鸡肉卷，配米饭一绝'
  },
  {
    name: '牛油果鸡蛋卷', icon: '🥑', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '牛油果鸡蛋卷，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '牛油果虾仁卷', icon: '🥑', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '这道牛油果虾仁卷好吃又好做，强烈推荐'
  },
  {
    name: '全麦鸡肉卷', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '全麦鸡肉卷，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '全麦蔬菜卷', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '全麦蔬菜卷做法简单零失败，厨房新手也能做'
  },
  {
    name: '全麦鸡蛋卷', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '全麦鸡蛋卷营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '藜麦牛油果碗', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '藜麦牛油果碗营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '藜麦虾仁碗', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '这道藜麦虾仁碗好吃又好做，强烈推荐'
  },
  {
    name: '藜麦鸡胸碗', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道藜麦鸡胸碗好吃又好做，强烈推荐'
  },
  {
    name: '藜麦豆腐碗', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '藜麦豆腐碗，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '燕麦酸奶杯', icon: '🥛', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的燕麦酸奶杯，配米饭一绝'
  },
  {
    name: '燕麦牛奶杯', icon: '🥛', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道燕麦牛奶杯好吃又好做，强烈推荐'
  },
  {
    name: '奇亚籽布丁', icon: '🍮', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的奇亚籽布丁，配米饭一绝'
  },
  {
    name: '奇亚籽酸奶', icon: '🥛', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '奇亚籽酸奶做法简单零失败，厨房新手也能做'
  },
  {
    name: '隔夜燕麦', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的隔夜燕麦，配米饭一绝'
  },
  {
    name: '水果燕麦片', icon: '🥣', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的水果燕麦片，配米饭一绝'
  },
  {
    name: '坚果酸奶碗', icon: '🥛', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道坚果酸奶碗好吃又好做，强烈推荐'
  },
  {
    name: '莓果酸奶碗', icon: '🥛', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '莓果酸奶碗，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '芒果酸奶碗', icon: '🥭', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道芒果酸奶碗好吃又好做，强烈推荐'
  },
  {
    name: '香蕉燕麦饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '香蕉燕麦饼做法简单零失败，厨房新手也能做'
  },
  {
    name: '鸡蛋燕麦饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鸡蛋燕麦饼，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '南瓜燕麦饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '南瓜燕麦饼做法简单零失败，厨房新手也能做'
  },
  {
    name: '红薯燕麦饼', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '红薯燕麦饼，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '全麦松饼', icon: '🥞', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '全麦松饼做法简单零失败，厨房新手也能做'
  },
  {
    name: '荞麦面沙拉', icon: '🥗', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '荞麦面沙拉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '荞麦面鸡丝', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的荞麦面鸡丝，配米饭一绝'
  },
  {
    name: '魔芋凉皮', icon: '🍜', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道魔芋凉皮好吃又好做，强烈推荐'
  },
  {
    name: '魔芋面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '魔芋面做法简单零失败，厨房新手也能做'
  },
  {
    name: '魔芋丝', icon: '🍜', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道魔芋丝好吃又好做，强烈推荐'
  },
  {
    name: '魔芋结', icon: '🍜', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '魔芋结营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '西葫芦面条', icon: '🥒', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的西葫芦面条，配米饭一绝'
  },
  {
    name: '彩虹沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的彩虹沙拉，配米饭一绝'
  },
  {
    name: '鸡肉牛油果沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鸡肉牛油果沙拉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '虾仁牛油果沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '鲜香可口的虾仁牛油果沙拉，配米饭一绝'
  },
  {
    name: '豆腐牛油果沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '豆腐牛油果沙拉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '鸡蛋牛油果沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鸡蛋牛油果沙拉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '南瓜沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '南瓜沙拉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '红薯沙拉', icon: '🥗', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '红薯沙拉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '鹰嘴豆泥', icon: '🫘', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道鹰嘴豆泥好吃又好做，强烈推荐'
  },
  {
    name: '鹰嘴豆沙拉', icon: '🫘', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道鹰嘴豆沙拉好吃又好做，强烈推荐'
  },
  {
    name: '毛豆沙拉', icon: '🫘', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的毛豆沙拉，配米饭一绝'
  },
  {
    name: '毛豆炒鸡蛋', icon: '🥚', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道毛豆炒鸡蛋好吃又好做，强烈推荐'
  },
  {
    name: '番茄西葫芦', icon: '🍅', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '番茄西葫芦，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '番茄蘑菇', icon: '🍅', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '番茄蘑菇，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '清炒芦笋', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '清炒芦笋营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '蒜蓉芦笋', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的蒜蓉芦笋，配米饭一绝'
  },
  {
    name: '烤芦笋', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '烤芦笋营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '烤西兰花', icon: '🥦', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '烤西兰花营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '烤蔬菜拼盘', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的烤蔬菜拼盘，配米饭一绝'
  },
  {
    name: '蒸蔬菜拼盘', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '蒸蔬菜拼盘营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '蔬菜浓汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '蔬菜浓汤做法简单零失败，厨房新手也能做'
  },
  {
    name: '南瓜蔬菜汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '南瓜蔬菜汤做法简单零失败，厨房新手也能做'
  },
  {
    name: '番茄蔬菜浓汤', icon: '🥣', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '这道番茄蔬菜浓汤好吃又好做，强烈推荐'
  },
  {
    name: '玉米浓汤', icon: '🌽', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '玉米浓汤营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '西兰花浓汤', icon: '🥦', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '西兰花浓汤做法简单零失败，厨房新手也能做'
  },
  {
    name: '蘑菇浓汤', icon: '🍄', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['姜', '葱'],
    reason: '蘑菇浓汤，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '牛油果奶昔', icon: '🥑', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '牛油果奶昔营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '菠菜奶昔', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '菠菜奶昔，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '羽衣甘蓝奶昔', icon: '🥬', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '羽衣甘蓝奶昔营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '椰子水奇亚籽', icon: '🥥', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '椰子水奇亚籽营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '柠檬黄瓜水', icon: '🥒', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '柠檬黄瓜水做法简单零失败，厨房新手也能做'
  },
  {
    name: '蜂蜜姜茶', icon: '🍯', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的蜂蜜姜茶，配米饭一绝'
  },
  {
    name: '火龙果酸奶碗', icon: '🐉', time: '5分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['火龙果', '酸奶', '燕麦'],
    reason: '清爽甜美，高颜值低卡路里，仙女早餐'
  },
  {
    name: '南瓜小米糊', icon: '🎃', time: '15分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['南瓜', '小米'],
    reason: '香甜软滑，暖胃养身，早餐好选择'
  },
  {
    name: '紫薯燕麦粥', icon: '🍠', time: '15分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 5, deliveryCost: 16, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['紫薯', '燕麦'],
    reason: '紫薯香甜，燕麦饱腹，低脂又营养'
  },
  {
    name: '芦笋虾仁沙拉', icon: '🥗', time: '10分钟', cost: '20元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 20, deliveryCost: 40, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 2,
    requiredIngredients: ['芦笋', '虾仁', '沙拉酱'],
    reason: '芦笋脆嫩，虾仁鲜美，高蛋白低脂肪'
  },
  {
    name: '番茄沙拉', icon: '🍅', time: '5分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['番茄', '沙拉酱'],
    reason: '酸甜清爽，维生素丰富，三分钟搞定'
  },
  {
    name: '藜麦沙拉碗', icon: '🥗', time: '15分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['藜麦', '牛油果', '番茄', '生菜'],
    reason: '藜麦高蛋白，牛油果顺滑，超级食物沙拉'
  },
  {
    name: '三明治', icon: '🥪', time: '8分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面包', '火腿', '生菜', '鸡蛋'],
    reason: '简单快手，营养均衡，早餐首选'
  },
  {
    name: '蔬菜鸡胸肉卷', icon: '🌯', time: '15分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡胸肉', '生菜', '番茄', '卷饼'],
    reason: '高蛋白低脂，蔬菜脆嫩，清爽健康'
  },
  {
    name: '牛油果拌饭', icon: '🥑', time: '10分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 15, deliveryCost: 32, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['牛油果', '米饭', '芝麻', '酱油'],
    reason: '牛油果绵密，芝麻飘香，简单又健康'
  },
  {
    name: '凯撒沙拉', icon: '🥗', time: '10分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 18, deliveryCost: 37, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['生菜', '面包丁', '鸡胸肉', '沙拉酱'],
    reason: '经典凯撒，鸡肉鲜嫩，面包丁酥脆'
  },
  {
    name: '金枪鱼沙拉', icon: '🥗', time: '5分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '20分钟',
    cookCost: 15, deliveryCost: 32, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['金枪鱼罐头', '生菜', '玉米', '沙拉酱'],
    reason: '金枪鱼高蛋白，玉米清甜，五分钟搞定'
  },
  {
    name: '牛油果吐司', icon: '🥑', time: '8分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 12, deliveryCost: 25, category: 2, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['牛油果', '全麦面包', '柠檬', '海盐'],
    reason: '牛油果绵密顺滑，搭配酥脆吐司，营养轻食首选'
  },
];