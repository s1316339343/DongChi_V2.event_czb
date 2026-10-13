import { LocalDish } from "./DishTypes";

// ===== 快餐速食 (Category 3) =====

export const LOCAL_DISHES_3: LocalDish[] = [
  {
    name: '速冻水饺', icon: '🥟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['饺子皮', '猪肉', '白菜'],
    reason: '冰箱必备，十分钟搞定热腾腾的一餐'
  },
  {
    name: '自热火锅', icon: '🍲', time: '15分钟', cost: '25元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 38, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['火锅底料', '土豆', '白菜'],
    reason: '不用火不用电，加水自煮，懒人福音'
  },
  {
    name: '微波炉速食饭', icon: '🍱', time: '5分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '20分钟',
    cookCost: 12, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米饭'],
    reason: '微波炉叮一下就能吃，最适合加班党'
  },
  {
    name: '挂面煎蛋', icon: '🍜', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['挂面', '鸡蛋'],
    reason: '最简单的温暖，一碗清汤面配溏心荷包蛋'
  },
  {
    name: '意大利面', icon: '🍝', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 10, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面条', '番茄', '番茄酱'],
    reason: '简单意面配上番茄酱，好吃又方便'
  },
  {
    name: '速冻披萨', icon: '🍕', time: '15分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 35, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面粉', '芝士', '番茄酱'],
    reason: '烤箱或微波炉加热，拉丝披萨轻松搞定'
  },
  {
    name: '冲泡粥', icon: '🥣', time: '3分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '3分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 15, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['大米'],
    reason: '开水冲泡即食，暖胃最快的方式'
  },
  {
    name: '速冻包子', icon: '🥟', time: '8分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面粉', '猪肉'],
    reason: '蒸一蒸就搞定，皮薄馅足超满足'
  },
  {
    name: '韩式拌饭', icon: '🍚', time: '15分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 28, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '鸡蛋', '菠菜', '胡萝卜', '辣椒酱'],
    reason: '甜辣酱配各种蔬菜，拌一拌超美味'
  },
  {
    name: '炒乌冬面', icon: '🍝', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面条', '白菜', '胡萝卜'],
    reason: 'Q弹乌冬面配上蔬菜，比外卖更快'
  },
  {
    name: '即食咖喱饭', icon: '🍛', time: '5分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 26, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米饭', '土豆', '胡萝卜'],
    reason: '即食咖喱包加热即食，浓郁日式咖喱味'
  },
  {
    name: '速冻春卷', icon: '🥟', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['饺子皮', '白菜', '猪肉'],
    reason: '空气炸锅或油炸，金黄酥脆超好吃'
  },
  {
    name: '泡菜炒饭', icon: '🍚', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米饭', '鸡蛋', '辣椒酱'],
    reason: '酸辣泡菜配上米饭，5分钟搞定的开胃炒饭'
  },
  {
    name: '番茄鸡蛋面', icon: '🍜', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面条', '番茄', '鸡蛋'],
    reason: '酸甜开胃，热腾腾的汤面，快手又好吃'
  },
  {
    name: '咖喱牛肉饭', icon: '🍛', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '牛肉', '咖喱块'],
    reason: '浓郁咖喱配上米饭，简单又满足'
  },
  {
    name: '煎饺', icon: '🥟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['饺子'],
    reason: '底部金黄酥脆，蘸醋更美味'
  },
  {
    name: '金枪鱼饭团', icon: '🍙', time: '8分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米饭', '金枪鱼', '海苔'],
    reason: '不用开火，捏一捏就能吃，野餐首选'
  },
  {
    name: '酸汤肥牛面', icon: '🍜', time: '12分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 15, deliveryCost: 28, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '肥牛', '番茄'],
    reason: '酸辣开胃，肥牛嫩滑，10分钟搞定的大餐感'
  },
  {
    name: '速食意面', icon: '🍝', time: '8分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面条', '意面酱'],
    reason: '煮面拌酱，简单快捷，西餐速食入门'
  },
  {
    name: '腊肠煲仔饭', icon: '🍚', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 15, deliveryCost: 28, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '腊肠', '鸡蛋'],
    reason: '锅巴焦脆，腊肠油润，一锅出的美味'
  },
  {
    name: '豆腐脑', icon: '🫘', time: '5分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 5, deliveryCost: 14, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['内酯豆腐'],
    reason: '嫩滑如丝，甜咸皆宜，早餐轻食首选'
  },
  {
    name: '芝士三明治', icon: '🥪', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 8, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面包', '芝士', '火腿'],
    reason: '简单快手，融化芝士超治愈，早餐首选'
  },
  {
    name: '牛肉面', icon: '🍜', time: '20分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 35, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['面条', '牛肉', '青菜'],
    reason: '汤浓味鲜，牛肉软烂，一碗满足'
  },
  {
    name: '酸辣土豆粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['粉条', '花生', '辣椒油'],
    reason: '酸辣爽滑，快手好做，比外卖还快'
  },
  {
    name: '电饭煲焖饭', icon: '🍚', time: '30分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '30分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 1,
    requiredIngredients: ['米饭', '胡萝卜', '土豆', '香肠'],
    reason: '一键搞定，饭菜同出，懒人必备'
  },
  {
    name: '热狗', icon: '🌭', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 8, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面包', '香肠'],
    reason: '简单快手的西式速食，加番茄酱更美味'
  },
  {
    name: '铁板炒饭', icon: '🍚', time: '10分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米饭', '鸡蛋', '蔬菜'],
    reason: '粒粒分明，锅气十足，路边摊最香'
  },
  {
    name: '酸汤水饺', icon: '🥟', time: '12分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['饺子', '辣椒油'],
    reason: '酸辣开胃，热汤配水饺，暖身又解馋'
  },
  {
    name: '微波炉蒸蛋', icon: '🥚', time: '5分钟', cost: '3元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '15分钟',
    cookCost: 3, deliveryCost: 12, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['鸡蛋'],
    reason: '最简单的高蛋白快手餐，微波炉3分钟搞定'
  },
  {
    name: '煎饼果子', icon: '🥞', time: '8分钟', cost: '6元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '天津名小吃，面糊摊开打个蛋，酥脆喷香'
  },
  {
    name: '凉皮', icon: '🍜', time: '5分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '18分钟',
    cookCost: 8, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['凉皮'],
    reason: '酸辣爽滑，夏日快手餐，不用开火'
  },
  {
    name: '烤冷面', icon: '🥟', time: '8分钟', cost: '6元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['冷面', '鸡蛋', '香肠'],
    reason: '东北街头小吃，酸甜酱汁配上筋道冷面'
  },
  {
    name: '三文鱼茶泡饭', icon: '🍚', time: '8分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '22分钟',
    cookCost: 15, deliveryCost: 28, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米饭', '三文鱼', '绿茶'],
    reason: '日式快手餐，茶香饭香，清爽暖心'
  },
  {
    name: '鸡蛋灌饼', icon: '🥞', time: '10分钟', cost: '6元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '外酥里嫩，灌入鸡蛋，早餐摊的王者'
  },
  {
    name: '肉夹馍', icon: '🥙', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['猪肉', '面粉'],
    reason: '馍酥肉香，汤汁浓郁，西安名吃'
  },
  {
    name: '冲调燕麦片', icon: '🥣', time: '3分钟', cost: '4元',
    difficulty: '⭐', hasIngredients: false, cookTime: '3分钟', deliveryTime: '14分钟',
    cookCost: 4, deliveryCost: 12, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['燕麦片'],
    reason: '三分钟搞定，高纤维早餐，健康又快捷'
  },
  {
    name: '炒方便面', icon: '🍜', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['方便面', '鸡蛋', '蔬菜'],
    reason: '泡面炒着吃，秒变路边摊高级货'
  },
  {
    name: '土豆泥', icon: '🥔', time: '12分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '18分钟',
    cookCost: 5, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['土豆', '牛奶'],
    reason: '绵密顺滑，简单快手，比肯德基还好吃'
  },
  {
    name: '火腿炒面', icon: '🍜', time: '12分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '火腿肠'],
    reason: '大火快炒，面条焦香，十分钟搞定一餐'
  },
  {
    name: '叉烧饭', icon: '🍚', time: '15分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 30, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '叉烧肉'],
    reason: '叉烧甜香，配上溏心蛋，港式茶餐厅风味'
  },
  {
    name: '干炒牛河', icon: '🍜', time: '12分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['河粉', '牛肉', '豆芽'],
    reason: '锅气十足，牛肉嫩滑，经典粤式炒粉'
  },
  {
    name: '鲜虾云吞面', icon: '🍜', time: '12分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 30, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '云吞', '虾'],
    reason: '汤鲜味美，云吞饱满，港式经典'
  },
  {
    name: '蛋包饭', icon: '🍛', time: '15分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '鸡蛋', '番茄酱'],
    reason: '嫩滑蛋皮包裹炒饭，淋上番茄酱，日式治愈系'
  },
  {
    name: '章鱼小丸子', icon: '🐙', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面粉', '章鱼', '鸡蛋'],
    reason: '外酥里嫩，配上木鱼花和沙拉酱，街头人气小吃'
  },
  {
    name: '关东煮', icon: '🍢', time: '10分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 12, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['萝卜', '鱼丸', '魔芋'],
    reason: '清汤煮万物，暖身又健康，便利店同款'
  },
  {
    name: '虾饺', icon: '🥟', time: '20分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 35, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['虾', '澄粉'],
    reason: '晶莹剔透，虾肉鲜甜，早茶必点'
  },
  {
    name: '烧卖', icon: '🥟', time: '12分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['糯米', '猪肉', '饺子皮'],
    reason: '糯米软糯，肉香四溢，蒸一蒸就好'
  },
  {
    name: '肠粉', icon: '🫘', time: '12分钟', cost: '10元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['粘米粉', '鸡蛋', '生抽'],
    reason: '滑嫩爽口，淋上酱油，广式早餐经典'
  },
  {
    name: '花甲粉', icon: '🍜', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 32, category: 3, isSpicy: true, hasCoriander: true,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['花甲', '粉丝', '蒜'],
    reason: '花甲鲜美，粉丝吸满汤汁，夜市排队王'
  },
  {
    name: '麻辣米线', icon: '🍜', time: '12分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米线', '辣椒油', '花生'],
    reason: '麻辣鲜香，米线爽滑，嗦到停不下来'
  },
  {
    name: '鱼蛋粉', icon: '🍜', time: '10分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米粉', '鱼丸'],
    reason: '鱼蛋Q弹，汤头鲜美，港式街头味道'
  },
  {
    name: '日式拉面', icon: '🍜', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 35, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['拉面', '鸡蛋', '猪肉'],
    reason: '浓汤配溏心蛋，在家复刻日本拉面店'
  },
  {
    name: '砂锅米线', icon: '🍲', time: '15分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米线', '豆芽', '肉末'],
    reason: '砂锅慢煮，米线入味，暖身又暖心'
  },
  {
    name: '牛腩面', icon: '🍜', time: '20分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 22, deliveryCost: 38, category: 3, isSpicy: false, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['面条', '牛腩', '萝卜'],
    reason: '牛腩软烂，萝卜清甜，一碗满足'
  },
  {
    name: '红烧牛肉面', icon: '🍜', time: '20分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 35, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['面条', '牛肉', '生抽'],
    reason: '红烧汤底浓郁，牛肉大块，一碗管饱'
  },
  {
    name: '卤肉饭', icon: '🍛', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 25, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['米饭', '五花肉', '生抽'],
    reason: '卤肉香浓入味，配上米饭，台湾经典'
  },
  {
    name: '蛋炒河粉', icon: '🍜', time: '8分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['河粉', '鸡蛋', '豆芽'],
    reason: '大火快炒，河粉Q弹，五分钟搞定一餐'
  },
  {
    name: '酱香饼', icon: '🫓', time: '12分钟', cost: '6元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '18分钟',
    cookCost: 6, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面粉', '甜面酱'],
    reason: '千层酥脆，刷上秘制酱料，秒杀路边摊'
  },
  {
    name: '手抓饼', icon: '🫓', time: '5分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '5分钟', deliveryTime: '16分钟',
    cookCost: 5, deliveryCost: 15, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['手抓饼', '鸡蛋'],
    reason: '不用和面，煎一煎就层层酥脆，早餐首选'
  },
  {
    name: '泡面炒年糕', icon: '🍡', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 22, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['方便面', '年糕', '辣椒酱'],
    reason: '年糕Q弹，泡面入味，甜辣过瘾的创新吃法'
  },
  {
    name: '韩式拉面', icon: '🍜', time: '8分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['方便面', '鸡蛋', '泡菜'],
    reason: '加蛋加泡菜，韩剧同款拉面，暖心暖胃'
  },
  {
    name: '韩式泡菜拌饭', icon: '🍚', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的韩式泡菜拌饭，配米饭一绝'
  },
  {
    name: '韩式炒饭', icon: '🍚', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '韩式炒饭，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '日式咖喱饭', icon: '🍛', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '日式咖喱饭做法简单零失败，厨房新手也能做'
  },
  {
    name: '日式牛肉饭', icon: '🍛', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '日式牛肉饭，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '亲子丼', icon: '🍛', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '亲子丼，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '照烧鸡腿饭', icon: '🍗', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['鸡腿', '生抽', '蜂蜜', '米饭'],
    reason: '这道照烧鸡腿饭好吃又好做，强烈推荐'
  },
  {
    name: '照烧鸡肉饭', icon: '🍗', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '照烧鸡肉饭做法简单零失败，厨房新手也能做'
  },
  {
    name: '猪排饭', icon: '🥩', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '猪排饭做法简单零失败，厨房新手也能做'
  },
  {
    name: '鳗鱼饭', icon: '🐟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '鳗鱼饭营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '三文鱼饭', icon: '🐟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '三文鱼饭营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '梅子茶泡饭', icon: '🍚', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的梅子茶泡饭，配米饭一绝'
  },
  {
    name: '玉子烧', icon: '🥚', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的玉子烧，配米饭一绝'
  },
  {
    name: '日式蛋包饭', icon: '🍛', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '日式蛋包饭营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '番茄蛋包饭', icon: '🍛', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道番茄蛋包饭好吃又好做，强烈推荐'
  },
  {
    name: '炒米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '炒米粉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '炒河粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '炒河粉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '星洲炒米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的星洲炒米粉，配米饭一绝'
  },
  {
    name: '泰式炒河粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '泰式炒河粉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '越式牛肉河粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道越式牛肉河粉好吃又好做，强烈推荐'
  },
  {
    name: '冬阴功汤面', icon: '🍜', time: '40分钟', cost: '18元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 18, deliveryCost: 37, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '冬阴功汤面做法简单零失败，厨房新手也能做'
  },
  {
    name: '冬阴功米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '这道冬阴功米粉好吃又好做，强烈推荐'
  },
  {
    name: '咖喱面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的咖喱面，配米饭一绝'
  },
  {
    name: '咖喱米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '咖喱米粉做法简单零失败，厨房新手也能做'
  },
  {
    name: '广式云吞面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的广式云吞面，配米饭一绝'
  },
  {
    name: '港式车仔面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '港式车仔面营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '港式鱼蛋面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的港式鱼蛋面，配米饭一绝'
  },
  {
    name: '潮汕牛肉丸面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '潮汕牛肉丸面营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '兰州拉面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '兰州拉面营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '陕西油泼面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的陕西油泼面，配米饭一绝'
  },
  {
    name: '山西刀削面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的山西刀削面，配米饭一绝'
  },
  {
    name: '四川担担面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道四川担担面好吃又好做，强烈推荐'
  },
  {
    name: '宜宾燃面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '宜宾燃面做法简单零失败，厨房新手也能做'
  },
  {
    name: '重庆豌杂面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '重庆豌杂面做法简单零失败，厨房新手也能做'
  },
  {
    name: '河南烩面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '河南烩面做法简单零失败，厨房新手也能做'
  },
  {
    name: '北京炸酱面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道北京炸酱面好吃又好做，强烈推荐'
  },
  {
    name: '延吉冷面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道延吉冷面好吃又好做，强烈推荐'
  },
  {
    name: '上海葱油拌面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的上海葱油拌面，配米饭一绝'
  },
  {
    name: '厦门沙茶面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '厦门沙茶面，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '贵州肠旺面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道贵州肠旺面好吃又好做，强烈推荐'
  },
  {
    name: '云南过桥米线', icon: '🍜', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '云南过桥米线，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '柳州螺蛳粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '柳州螺蛳粉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '南昌拌粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '南昌拌粉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '桂林米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道桂林米粉好吃又好做，强烈推荐'
  },
  {
    name: '湖南米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '湖南米粉做法简单零失败，厨房新手也能做'
  },
  {
    name: '新疆炒米粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '新疆炒米粉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '陕西凉皮', icon: '🥟', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '陕西凉皮营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '陕西肉夹馍', icon: '🥟', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '陕西肉夹馍，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '驴肉火烧', icon: '🥟', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '驴肉火烧，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '小笼包', icon: '🥟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '小笼包营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '生煎包', icon: '🥟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道生煎包好吃又好做，强烈推荐'
  },
  {
    name: '锅贴', icon: '🥟', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '这道锅贴好吃又好做，强烈推荐'
  },
  {
    name: '水晶虾饺', icon: '🥟', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '这道水晶虾饺好吃又好做，强烈推荐'
  },
  {
    name: '鸡蛋肠粉', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '这道鸡蛋肠粉好吃又好做，强烈推荐'
  },
  {
    name: '瘦肉肠粉', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的瘦肉肠粉，配米饭一绝'
  },
  {
    name: '虾仁肠粉', icon: '🫓', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '虾仁肠粉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '咖喱鱼蛋', icon: '🍡', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 3, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的咖喱鱼蛋，配米饭一绝'
  },
  {
    name: '港式丝袜奶茶', icon: '🧋', time: '12分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道港式丝袜奶茶好吃又好做，强烈推荐'
  },
  {
    name: '炒饼丝', icon: '🫓', time: '10分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 21, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['饼丝', '卷心菜', '鸡蛋'],
    reason: '简单快手，饼丝焦香，北方家常味道'
  },
  {
    name: '酱油炒饭', icon: '🍚', time: '8分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 16, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米饭', '鸡蛋', '生抽', '葱花'],
    reason: '酱香浓郁，粒粒分明，剩饭的神仙吃法'
  },
  {
    name: '热干面', icon: '🍜', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['面条', '芝麻酱', '葱花', '萝卜干'],
    reason: '芝麻酱浓郁，面条筋道，武汉过早经典'
  },
  {
    name: '炸酱面', icon: '🍜', time: '20分钟', cost: '10元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 10, deliveryCost: 24, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '五花肉', '甜面酱', '黄瓜'],
    reason: '炸酱咸香，菜码丰富，老北京的味道'
  },
  {
    name: '臊子面', icon: '🍜', time: '20分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 12, deliveryCost: 27, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['面条', '猪肉', '胡萝卜', '土豆'],
    reason: '臊子咸香，面条筋道，陕西名面在家做'
  },
  {
    name: '西红柿鸡蛋面', icon: '🍜', time: '15分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 6, deliveryCost: 18, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面条', '番茄', '鸡蛋'],
    reason: '酸甜开胃，热乎乎一碗，暖心又暖胃'
  },
  {
    name: '肥牛饭', icon: '🍚', time: '10分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 18, deliveryCost: 37, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['肥牛', '洋葱', '米饭', '生抽'],
    reason: '肥牛嫩滑，洋葱焦甜，日式肥牛饭在家复刻'
  },
  {
    name: '虾仁炒饭', icon: '🍚', time: '10分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 15, deliveryCost: 32, category: 3, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['米饭', '虾仁', '鸡蛋', '葱花'],
    reason: '虾仁鲜美，米饭粒粒分明，豪华版炒饭'
  },

];