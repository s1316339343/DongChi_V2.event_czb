import { LocalDish } from "./DishTypes";

// ===== 重口过瘾 (Category 1) =====

export const LOCAL_DISHES_1: LocalDish[] = [
  {
    name: '麻辣香锅', icon: '🥘', time: '25分钟', cost: '30元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 30, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['五花肉', '土豆', '西兰花', '干辣椒', '花椒'],
    reason: '想吃什么就放什么，麻辣过瘾超满足'
  },
  {
    name: '火锅', icon: '🍲', time: '20分钟', cost: '40元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '40分钟',
    cookCost: 40, deliveryCost: 68, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['五花肉', '土豆', '白菜', '豆腐', '火锅底料'],
    reason: '热热闹闹吃一顿，没有什么是一顿火锅解决不了的'
  },
  {
    name: '烤鱼', icon: '🐟', time: '40分钟', cost: '38元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 38, deliveryCost: 58, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼', '豆芽', '干辣椒', '花椒'],
    reason: '外焦里嫩，麻辣入味，夜宵首选'
  },
  {
    name: '麻辣烫', icon: '🥣', time: '15分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 25, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['土豆', '白菜', '豆腐', '豆瓣酱'],
    reason: '自选食材一锅煮，方便快捷又解馋'
  },
  {
    name: '烧烤拼盘', icon: '🥩', time: '30分钟', cost: '35元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 35, deliveryCost: 55, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['五花肉', '鸡翅', '牛肉', '辣椒'],
    reason: '烟火气十足，滋滋冒油最诱人'
  },
  {
    name: '酸菜鱼', icon: '🐟', time: '30分钟', cost: '28元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '30分钟',
    cookCost: 28, deliveryCost: 45, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '酸菜', '泡椒'],
    reason: '酸辣鲜香，鱼肉嫩滑，汤汁都能拌三碗饭'
  },
  {
    name: '辣子鸡', icon: '🐔', time: '25分钟', cost: '20元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 35, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡腿', '干辣椒', '花椒'],
    reason: '干香麻辣，越嚼越香，下酒神器'
  },
  {
    name: '毛血旺', icon: '🫕', time: '35分钟', cost: '32元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '35分钟', deliveryTime: '35分钟',
    cookCost: 32, deliveryCost: 50, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['豆芽', '豆腐', '干辣椒', '花椒', '豆瓣酱'],
    reason: '麻辣鲜香的重庆招牌，毛肚脆爽汤汁浓郁'
  },
  {
    name: '回锅肉', icon: '🥩', time: '25分钟', cost: '16元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '28分钟',
    cookCost: 16, deliveryCost: 30, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['五花肉', '豆瓣酱', '青椒'],
    reason: '经典川菜，肥而不腻，配米饭一绝'
  },
  {
    name: '香辣蟹', icon: '🦀', time: '35分钟', cost: '40元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '35分钟', deliveryTime: '35分钟',
    cookCost: 40, deliveryCost: 65, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 3,
    requiredIngredients: ['螃蟹', '干辣椒', '豆瓣酱'],
    reason: '蟹肉鲜甜配麻辣，极致味觉享受'
  },
  {
    name: '蒜香排骨', icon: '🍖', time: '40分钟', cost: '28元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 28, deliveryCost: 45, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['排骨', '蒜', '生抽'],
    reason: '蒜香四溢，外酥里嫩，大人小孩都抢着吃'
  },
  {
    name: '铁板牛肉', icon: '🥩', time: '25分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 40, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['牛肉', '洋葱', '生抽'],
    reason: '滋滋作响的铁板，黑椒牛肉嫩滑入味'
  },
  {
    name: '口水鸡', icon: '🐔', time: '30分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡腿', '辣椒油', '花椒'],
    reason: '麻辣鲜香，鸡肉嫩滑，名字就叫你流口水'
  },
  {
    name: '干锅花菜', icon: '🥦', time: '20分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['西兰花', '五花肉', '辣椒'],
    reason: '焦香爽脆，微辣回甘，素菜也能很过瘾'
  },
  {
    name: '水煮肉片', icon: '🥩', time: '30分钟', cost: '25元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 25, deliveryCost: 42, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['猪肉', '豆芽', '干辣椒', '花椒', '豆瓣酱'],
    reason: '麻辣鲜香，肉片嫩滑，经典川菜下饭王'
  },
  {
    name: '辣炒花甲', icon: '🐚', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['花甲', '辣椒', '蒜'],
    reason: '鲜辣过瘾，花甲嫩滑，下酒好菜'
  },
  {
    name: '秘制红烧肉', icon: '🥩', time: '50分钟', cost: '28元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '50分钟', deliveryTime: '40分钟',
    cookCost: 28, deliveryCost: 45, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['五花肉', '生抽', '老抽', '冰糖'],
    reason: '色泽红亮，肥而不腻，入口即化'
  },
  {
    name: '泡椒凤爪', icon: '🐔', time: '30分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 25, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 1,
    requiredIngredients: ['鸡爪', '泡椒'],
    reason: '酸辣爽脆，追剧必备，停不下来'
  },
  {
    name: '麻辣小龙虾', icon: '🦞', time: '40分钟', cost: '45元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '45分钟',
    cookCost: 45, deliveryCost: 68, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 3,
    requiredIngredients: ['小龙虾', '辣椒', '花椒'],
    reason: '麻辣鲜香，夏日标配，过瘾至极'
  },
  {
    name: '尖椒炒腊肉', icon: '🌶️', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['尖椒', '腊肉'],
    reason: '腊肉咸香，尖椒辣爽，超级下饭'
  },
  {
    name: '鱼香肉丝', icon: '🥩', time: '20分钟', cost: '14元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 14, deliveryCost: 26, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['猪肉', '木耳', '胡萝卜', '泡椒'],
    reason: '酸甜微辣，鱼香味浓，最经典的川菜之一'
  },
  {
    name: '辣子肥肠', icon: '🥩', time: '40分钟', cost: '22元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '35分钟',
    cookCost: 22, deliveryCost: 38, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['肥肠', '干辣椒', '花椒'],
    reason: '外酥里嫩，麻辣干香，重口味爱好者必吃'
  },
  {
    name: '火爆腰花', icon: '🥩', time: '20分钟', cost: '20元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 35, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['猪腰', '辣椒', '蒜'],
    reason: '脆嫩爽口，火候是关键，辣而不燥'
  },
  {
    name: '红油抄手', icon: '🥟', time: '15分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 25, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['饺子皮', '猪肉', '辣椒油'],
    reason: '红油鲜亮，皮薄馅大，麻辣鲜香'
  },
  {
    name: '酸辣粉', icon: '🍜', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['粉条', '花生', '辣椒油', '醋'],
    reason: '酸辣开胃，粉条Q弹，路边摊之王'
  },
  {
    name: '麻辣牛蛙', icon: '🐸', time: '30分钟', cost: '30元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 30, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['牛蛙', '辣椒', '花椒'],
    reason: '蛙肉嫩滑，麻辣入味，越吃越上瘾'
  },
  {
    name: '豆花鱼', icon: '🐟', time: '30分钟', cost: '30元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '38分钟',
    cookCost: 30, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼', '豆花', '辣椒'],
    reason: '豆花嫩滑，鱼片鲜美，麻辣鲜香三重享受'
  },
  {
    name: '姜葱炒蟹', icon: '🦀', time: '20分钟', cost: '35元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 35, deliveryCost: 55, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['蟹', '姜', '葱'],
    reason: '姜葱爆香，蟹肉鲜甜，粤式经典'
  },
  {
    name: '辣炒鱿鱼', icon: '🦑', time: '15分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鱿鱼', '辣椒', '蒜'],
    reason: '鱿鱼Q弹，辣味十足，下酒好菜'
  },
  {
    name: '虎皮青椒', icon: '🫑', time: '12分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 5, deliveryCost: 16, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['青椒'],
    reason: '虎皮酥脆，酱汁浓郁，素菜也能吃出大菜感'
  },
  {
    name: '麻辣豆腐锅', icon: '🫘', time: '20分钟', cost: '8元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 8, deliveryCost: 22, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['豆腐', '辣椒酱', '花椒'],
    reason: '麻辣鲜嫩，热腾腾的砂锅，暖身暖胃'
  },
  {
    name: '蒜蓉粉丝蒸扇贝', icon: '🐚', time: '15分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 38, category: 1, isSpicy: false, hasCoriander: true,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['扇贝', '粉丝', '蒜'],
    reason: '蒜香四溢，扇贝鲜甜，宴会级美味'
  },
  {
    name: '剁椒鱼头', icon: '🐟', time: '30分钟', cost: '28元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 28, deliveryCost: 45, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼头', '剁椒', '姜'],
    reason: '剁椒鲜辣，鱼头肥美，湘菜经典'
  },
  {
    name: '避风塘炒虾', icon: '🦐', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 42, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['虾', '蒜', '面包糠'],
    reason: '蒜香酥脆，虾肉弹牙，港式经典'
  },
  {
    name: '辣炒年糕', icon: '🍥', time: '12分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['年糕', '辣椒酱'],
    reason: '软糯Q弹，甜辣浓郁，韩式街头美味'
  },
  {
    name: '川味香肠', icon: '🌭', time: '15分钟', cost: '15元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 15, deliveryCost: 28, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['香肠'],
    reason: '麻辣咸香，蒸煮炒皆可，四川人家常味'
  },
  {
    name: '麻辣拌', icon: '🥣', time: '10分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 12, deliveryCost: 25, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['蔬菜', '粉丝', '辣椒油'],
    reason: '麻辣鲜香，自选食材，想吃什么拌什么'
  },
  {
    name: '跳跳蛙', icon: '🐸', time: '25分钟', cost: '32元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '35分钟',
    cookCost: 32, deliveryCost: 50, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['牛蛙', '辣椒', '泡椒'],
    reason: '蛙肉嫩滑，酸辣开胃，鲜美无比'
  },
  {
    name: '老干妈炒饭', icon: '🍚', time: '8分钟', cost: '7元',
    difficulty: '⭐', hasIngredients: false, cookTime: '8分钟', deliveryTime: '18分钟',
    cookCost: 7, deliveryCost: 18, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['米饭', '鸡蛋', '辣椒酱'],
    reason: '老干妈加持，粒粒香辣，最简单的重口味'
  },
  {
    name: '冒菜', icon: '🍲', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 38, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['火锅底料', '牛肉', '蔬菜'],
    reason: '一个人的火锅，麻辣鲜香，怎么吃都爽'
  },
  {
    name: '重庆小面', icon: '🍜', time: '12分钟', cost: '8元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 8, deliveryCost: 20, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['面条', '辣椒油', '花生'],
    reason: '麻辣鲜香，面条劲道，重庆人的灵魂早餐'
  },
  {
    name: '螺蛳粉', icon: '🍜', time: '15分钟', cost: '12元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '25分钟',
    cookCost: 12, deliveryCost: 25, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['螺蛳粉', '酸笋'],
    reason: '酸笋臭香，螺蛳汤浓郁，爱就爱到底'
  },
  {
    name: '辣子鸡丁', icon: '🐔', time: '20分钟', cost: '18元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸡腿', '干辣椒', '花椒'],
    reason: '辣椒堆里找鸡丁，香辣酥脆，下酒神器'
  },
  {
    name: '麻婆茄子', icon: '🍆', time: '15分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['茄子', '豆瓣酱', '蒜'],
    reason: '茄子软糯入味，麻辣鲜香，比肉还好吃'
  },
  {
    name: '鱼香茄盒', icon: '🍆', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '25分钟',
    cookCost: 15, deliveryCost: 28, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['茄子', '面粉', '鸡蛋'],
    reason: '外酥里嫩，鱼香酸甜，素菜吃出肉味'
  },
  {
    name: '辣炒花蛤', icon: '🐚', time: '12分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '25分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['花蛤', '辣椒', '蒜'],
    reason: '花蛤鲜嫩，辣炒入味，下酒小菜首选'
  },
  {
    name: '酸豆角炒肉', icon: '🥩', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '22分钟',
    cookCost: 10, deliveryCost: 22, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['酸豆角', '猪肉'],
    reason: '酸辣爽脆，超级下饭，吃三碗不是问题'
  },
  {
    name: '香辣烤翅', icon: '🍗', time: '25分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '28分钟',
    cookCost: 18, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鸡翅', '辣椒粉'],
    reason: '外焦里嫩，香辣入味，烤箱或空气炸锅就能做'
  },
  {
    name: '辣卤鸭脖', icon: '🦆', time: '30分钟', cost: '20元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '28分钟',
    cookCost: 20, deliveryCost: 35, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鸭脖', '卤料包', '辣椒'],
    reason: '麻辣鲜香，越啃越有味，追剧伴侣'
  },
  {
    name: '麻辣鱼', icon: '🐟', time: '25分钟', cost: '30元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '32分钟',
    cookCost: 30, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '火锅底料', '豆芽'],
    reason: '鱼片嫩滑，麻辣鲜香，豆芽吸满汤汁超好吃'
  },
  {
    name: '水煮牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道水煮牛肉好吃又好做，强烈推荐'
  },
  {
    name: '水煮鱼片', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '这道水煮鱼片好吃又好做，强烈推荐'
  },
  {
    name: '沸腾鱼', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '沸腾鱼做法简单零失败，厨房新手也能做'
  },
  {
    name: '酸菜鱼片', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '这道酸菜鱼片好吃又好做，强烈推荐'
  },
  {
    name: '剁椒鱼块', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '剁椒鱼块，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '香辣鱼块', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '香辣鱼块，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '香辣虾', icon: '🦐', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '香辣虾，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '麻辣虾尾', icon: '🦐', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['虾', '姜', '蒜'],
    reason: '这道麻辣虾尾好吃又好做，强烈推荐'
  },
  {
    name: '辣炒蚬子', icon: '🐚', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '鲜香可口的辣炒蚬子，配米饭一绝'
  },
  {
    name: '辣炒蛏子', icon: '🐚', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '这道辣炒蛏子好吃又好做，强烈推荐'
  },
  {
    name: '辣爆花蛤', icon: '🐚', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['海鲜', '姜', '蒜'],
    reason: '辣爆花蛤做法简单零失败，厨房新手也能做'
  },
  {
    name: '干锅肥肠', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '干锅肥肠，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '干锅千页豆腐', icon: '🫘', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '干锅千页豆腐，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '干锅土豆片', icon: '🥔', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '这道干锅土豆片好吃又好做，强烈推荐'
  },
  {
    name: '干锅藕片', icon: '🥬', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '干锅藕片做法简单零失败，厨房新手也能做'
  },
  {
    name: '干锅菌菇', icon: '🍄', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '干锅菌菇营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '冒烤鸭', icon: '🦆', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '冒烤鸭做法简单零失败，厨房新手也能做'
  },
  {
    name: '冒牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '冒牛肉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '口水鸡腿', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '口水鸡腿营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '红油鸡块', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '红油鸡块，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '红油肚丝', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '这道红油肚丝好吃又好做，强烈推荐'
  },
  {
    name: '夫妻肺片', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '鲜香可口的夫妻肺片，配米饭一绝'
  },
  {
    name: '冷吃兔', icon: '🐰', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '鲜香可口的冷吃兔，配米饭一绝'
  },
  {
    name: '冷吃牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道冷吃牛肉好吃又好做，强烈推荐'
  },
  {
    name: '灯影牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道灯影牛肉好吃又好做，强烈推荐'
  },
  {
    name: '泡椒牛肉', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '泡椒牛肉，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '泡椒鸡杂', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道泡椒鸡杂好吃又好做，强烈推荐'
  },
  {
    name: '酸辣鸡杂', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的酸辣鸡杂，配米饭一绝'
  },
  {
    name: '麻辣鸡胗', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '鲜香可口的麻辣鸡胗，配米饭一绝'
  },
  {
    name: '烧烤味土豆', icon: '🥔', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '烧烤味土豆做法简单零失败，厨房新手也能做'
  },
  {
    name: '麻辣烤串', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '麻辣烤串，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '香辣烤鱼', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '鲜香可口的香辣烤鱼，配米饭一绝'
  },
  {
    name: '锡纸烤鱼', icon: '🐟', time: '20分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '姜', '蒜'],
    reason: '这道锡纸烤鱼好吃又好做，强烈推荐'
  },
  {
    name: '香辣烤腿', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '这道香辣烤腿好吃又好做，强烈推荐'
  },
  {
    name: '麻辣烤茄子', icon: '🍆', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的麻辣烤茄子，配米饭一绝'
  },
  {
    name: '麻辣烤韭菜', icon: '🥬', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '鲜香可口的麻辣烤韭菜，配米饭一绝'
  },
  {
    name: '钵钵鸡', icon: '🍗', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['肉', '姜', '蒜', '生抽'],
    reason: '钵钵鸡，简单美味的家常菜，轻松搞定一餐'
  },
  {
    name: '冷锅串串', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '鲜香可口的冷锅串串，配米饭一绝'
  },
  {
    name: '麻辣涮串', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '麻辣涮串做法简单零失败，厨房新手也能做'
  },
  {
    name: '麻辣盆菜', icon: '🥬', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '麻辣盆菜营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '麻辣拌面', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的麻辣拌面，配米饭一绝'
  },
  {
    name: '酸辣宽粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '鲜香可口的酸辣宽粉，配米饭一绝'
  },
  {
    name: '麻辣苕粉', icon: '🍜', time: '10分钟', cost: '10元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 10, deliveryCost: 24, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['面粉', '鸡蛋'],
    reason: '麻辣苕粉营养丰富口感绝佳，家人都喜欢'
  },
  {
    name: '麻辣香锅底料版', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '麻辣香锅底料版做法简单零失败，厨房新手也能做'
  },
  {
    name: '火锅底料煮一切', icon: '🥩', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['食材', '盐', '油'],
    reason: '鲜香可口的火锅底料煮一切，配米饭一绝'
  },
  {
    name: '冒菜麻辣版', icon: '🥬', time: '20分钟', cost: '15元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '20分钟', deliveryTime: '30分钟',
    cookCost: 15, deliveryCost: 32, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['蔬菜', '蒜', '油'],
    reason: '冒菜麻辣版做法简单零失败，厨房新手也能做'
  },
  {
    name: '辣子肥牛', icon: '🥩', time: '15分钟', cost: '22元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 22, deliveryCost: 43, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['肥牛', '干辣椒', '花椒'],
    reason: '肥牛嫩滑麻辣，快手版辣子菜，过瘾解馋'
  },
  {
    name: '泡椒鸭胗', icon: '🦆', time: '15分钟', cost: '16元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 16, deliveryCost: 34, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['鸭胗', '泡椒', '蒜'],
    reason: '脆嫩爽口，酸辣开胃，下酒好菜'
  },
  {
    name: '干锅牛蛙', icon: '🐸', time: '25分钟', cost: '30元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 30, deliveryCost: 56, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['牛蛙', '辣椒', '蒜'],
    reason: '牛蛙嫩滑，麻辣鲜香，越吃越过瘾'
  },
  {
    name: '青花椒鱼', icon: '🐟', time: '25分钟', cost: '28元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 28, deliveryCost: 53, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['鱼', '青花椒', '豆芽'],
    reason: '青花椒清香麻辣，鱼肉嫩滑，清新又过瘾'
  },
  {
    name: '蒜泥白肉', icon: '🥩', time: '25分钟', cost: '16元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 16, deliveryCost: 34, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 1,
    requiredIngredients: ['五花肉', '蒜', '辣椒油'],
    reason: '肥而不腻，蒜香浓郁，经典川菜冷盘'
  },
  {
    name: '干煸肥肠', icon: '🥩', time: '30分钟', cost: '22元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '30分钟',
    cookCost: 22, deliveryCost: 43, category: 1, isSpicy: true, hasCoriander: true,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['肥肠', '干辣椒', '花椒', '蒜'],
    reason: '外酥里嫩，麻辣干香，下酒神器'
  },
  {
    name: '羊肉串', icon: '🍢', time: '25分钟', cost: '25元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '25分钟', deliveryTime: '30分钟',
    cookCost: 25, deliveryCost: 48, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 1, budgetRank: 2,
    requiredIngredients: ['羊肉', '孜然', '辣椒粉'],
    reason: '滋滋冒油，孜然飘香，在家也能做烧烤'
  },
  {
    name: '辣卤鸡爪', icon: '🐔', time: '40分钟', cost: '12元',
    difficulty: '⭐⭐', hasIngredients: false, cookTime: '40分钟', deliveryTime: '40分钟',
    cookCost: 12, deliveryCost: 27, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 1,
    requiredIngredients: ['鸡爪', '干辣椒', '生抽', '八角'],
    reason: '软糯入味，麻辣回甘，追剧必备零食'
  },
  {
    name: '剁椒炒鸡蛋', icon: '🌶️', time: '10分钟', cost: '6元',
    difficulty: '⭐', hasIngredients: false, cookTime: '10分钟', deliveryTime: '20分钟',
    cookCost: 6, deliveryCost: 18, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 0, budgetRank: 0,
    requiredIngredients: ['鸡蛋', '剁椒', '葱花'],
    reason: '咸香微辣，鸡蛋嫩滑，快手开胃菜'
  },
  {
    name: '辣炒蛤蜊', icon: '🐚', time: '12分钟', cost: '18元',
    difficulty: '⭐', hasIngredients: false, cookTime: '12分钟', deliveryTime: '20分钟',
    cookCost: 18, deliveryCost: 37, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 0, budgetRank: 1,
    requiredIngredients: ['蛤蜊', '辣椒', '蒜', '姜'],
    reason: '蛤蜊鲜嫩，辣味提鲜，几分钟搞定'
  },
  {
    name: '香煎豆腐', icon: '🫘', time: '15分钟', cost: '5元',
    difficulty: '⭐', hasIngredients: false, cookTime: '15分钟', deliveryTime: '30分钟',
    cookCost: 5, deliveryCost: 16, category: 1, isSpicy: false, hasCoriander: false,
    isSeafood: false, isVegetarian: true, timeRank: 1, budgetRank: 0,
    requiredIngredients: ['豆腐', '生抽', '葱花'],
    reason: '外焦里嫩，酱香入味，便宜又好吃'
  },
  {
    name: '红烧猪蹄', icon: '🐷', time: '50分钟', cost: '28元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '50分钟', deliveryTime: '40分钟',
    cookCost: 28, deliveryCost: 52, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: false, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['猪蹄', '冰糖', '生抽', '八角'],
    reason: '猪蹄软糯，酱香浓郁，满满胶原蛋白的宴客硬菜'
  },
  {
    name: '水煮鱼', icon: '🐟', time: '30分钟', cost: '30元',
    difficulty: '⭐⭐⭐', hasIngredients: false, cookTime: '30分钟', deliveryTime: '35分钟',
    cookCost: 30, deliveryCost: 52, category: 1, isSpicy: true, hasCoriander: false,
    isSeafood: true, isVegetarian: false, timeRank: 2, budgetRank: 2,
    requiredIngredients: ['鱼', '豆芽', '干辣椒', '花椒', '豆瓣酱'],
    reason: '鱼片嫩滑，麻辣鲜香，经典的川菜大菜'
  },
];