/**
 * DbService - 使用 relationalStore API 的本地数据库服务
 *
 * 功能：
 * 1. 存储决策记录（决策条件 + 推荐结果）
 * 2. 收藏/取消收藏菜品
 * 3. 查询历史决策记录和收藏列表
 *
 * 纯本地，无任何联网调用
 */
import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

// ===== 数据库表定义 =====

/** 决策记录表名 */
const TABLE_DECISIONS = 'decision_records';
/** 收藏表名 */
const TABLE_FAVORITES = 'favorites';
/** 冰箱食材表名 */
const TABLE_FRIDGE = 'fridge_items';
/* [已注释] 用户会话表名 — 登录功能已移除
const TABLE_SESSION = 'user_session';
*/

/** 数据库配置 */
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'dongchi.db',
  securityLevel: relationalStore.SecurityLevel.S1,
};

/** 建表 SQL */
const CREATE_TABLE_DECISIONS_SQL =
  `CREATE TABLE IF NOT EXISTS ${TABLE_DECISIONS} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category INTEGER NOT NULL,
    categoryName TEXT NOT NULL,
    time INTEGER,
    timeLabel TEXT,
    budget INTEGER,
    budgetLabel TEXT,
    diet TEXT,
    dietLabels TEXT,
    ingredients TEXT,
    hasNoIngredients INTEGER DEFAULT 0,
    results TEXT NOT NULL,
    createdAt TEXT NOT NULL
  )`;

const CREATE_TABLE_FAVORITES_SQL =
  `CREATE TABLE IF NOT EXISTS ${TABLE_FAVORITES} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dishName TEXT NOT NULL,
    dishIcon TEXT,
    time TEXT,
    cost TEXT,
    difficulty TEXT,
    hasIngredients INTEGER DEFAULT 0,
    cookTime TEXT,
    deliveryTime TEXT,
    cookCost REAL DEFAULT 0,
    deliveryCost REAL DEFAULT 0,
    reason TEXT,
    decisionId INTEGER,
    createdAt TEXT NOT NULL,
    FOREIGN KEY (decisionId) REFERENCES ${TABLE_DECISIONS}(id) ON DELETE SET NULL
  )`;

/** 冰箱食材建表 SQL — 单行存储，ingredients 存 JSON 数组 */
const CREATE_TABLE_FRIDGE_SQL =
  `CREATE TABLE IF NOT EXISTS ${TABLE_FRIDGE} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ingredients TEXT NOT NULL DEFAULT '[]',
    updatedAt TEXT NOT NULL
  )`;

/** 多冰箱列表建表 SQL — 每个冰箱一条记录，name 为冰箱名称 */
const TABLE_FRIDGE_LIST = 'fridge_list';
const CREATE_TABLE_FRIDGE_LIST_SQL =
  `CREATE TABLE IF NOT EXISTS ${TABLE_FRIDGE_LIST} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    ingredients TEXT NOT NULL DEFAULT '[]',
    updatedAt TEXT NOT NULL
  )`;

/* [已注释] 用户会话建表 SQL — 登录功能已移除
const CREATE_TABLE_SESSION_SQL =
  `CREATE TABLE IF NOT EXISTS ${TABLE_SESSION} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isLoggedIn INTEGER DEFAULT 0,
    account TEXT,
    username TEXT,
    updatedAt TEXT NOT NULL
  )`;
*/
// ===== 数据接口 =====

/** 决策记录数据结构 */
export interface DecisionRecord {
  id?: number;
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
  results: string; // JSON 字符串：推荐菜品的完整数据
  createdAt: string;
}

/** 收藏菜品数据结构 */
export interface FavoriteDish {
  id?: number;
  dishName: string;
  dishIcon: string;
  time: string;
  cost: string;
  difficulty: string;
  hasIngredients: boolean;
  cookTime: string;
  deliveryTime: string;
  cookCost: number;
  deliveryCost: number;
  reason: string;
  decisionId?: number;
  createdAt: string;
}

/* [已注释] 登录会话数据结构 — 登录功能已移除
export interface SessionData {
  isLoggedIn: boolean;
  account: string;
  username: string;
}
*/

/** 冰箱数据结构 */
export interface FridgeInfo {
  id: number;
  name: string;
  ingredients: string[];
  updatedAt: string;
}

// ===== 数据库服务 =====

export class DbService {
  private static rdbStore: relationalStore.RdbStore | null = null;

  /**
   * 初始化数据库（建表）
   */
  static async init(context: common.Context): Promise<void> {
    if (DbService.rdbStore) {
      return;
    }
    DbService.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
    await DbService.rdbStore.executeSql(CREATE_TABLE_DECISIONS_SQL);
    await DbService.rdbStore.executeSql(CREATE_TABLE_FAVORITES_SQL);
    await DbService.rdbStore.executeSql(CREATE_TABLE_FRIDGE_SQL);
    await DbService.rdbStore.executeSql(CREATE_TABLE_FRIDGE_LIST_SQL);
    // 用户会话表 — 登录功能已移除
    console.info('DbService: 数据库初始化成功');
  }

  /**
   * 确保数据库已初始化
   */
  private static async ensureDb(context: common.Context): Promise<relationalStore.RdbStore> {
    if (!DbService.rdbStore) {
      await DbService.init(context);
    }
    return DbService.rdbStore!;
  }

  // ========== 决策记录操作 ==========

  /**
   * 保存一条决策记录
   * @returns 新记录的 id
   */
  static async saveDecision(context: common.Context, record: DecisionRecord): Promise<number> {
    const db = await DbService.ensureDb(context);
    const now = new Date().toISOString();

    const valueBucket: relationalStore.ValuesBucket = {
      category: record.category,
      categoryName: record.categoryName,
      time: record.time,
      timeLabel: record.timeLabel,
      budget: record.budget,
      budgetLabel: record.budgetLabel,
      diet: JSON.stringify(record.diet),
      dietLabels: JSON.stringify(record.dietLabels),
      ingredients: JSON.stringify(record.ingredients),
      hasNoIngredients: record.hasNoIngredients ? 1 : 0,
      results: record.results,
      createdAt: now,
    };

    const rowId = await db.insert(TABLE_DECISIONS, valueBucket);
    console.info(`DbService: 决策记录已保存，id=${rowId}`);
    return rowId;
  }

  /**
   * 查询所有决策记录（按时间倒序）
   */
  static async getAllDecisions(context: common.Context): Promise<DecisionRecord[]> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_DECISIONS);
    predicates.orderByDesc('createdAt');

    const resultSet = await db.query(predicates, [
      'id', 'category', 'categoryName', 'time', 'timeLabel',
      'budget', 'budgetLabel', 'diet', 'dietLabels',
      'ingredients', 'hasNoIngredients', 'results', 'createdAt',
    ]);

    const records: DecisionRecord[] = [];
    while (resultSet.goToNextRow()) {
      records.push(DbService.parseDecisionResult(resultSet));
    }
    resultSet.close();
    return records;
  }

  /**
   * 查询最近 N 条决策记录（按时间倒序）
   * 用于构建用户偏好画像（P1 偏好学习），避免每次全量加载决策表
   */
  static async getRecentDecisions(context: common.Context, limit: number): Promise<DecisionRecord[]> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_DECISIONS);
    predicates.orderByDesc('createdAt');
    predicates.limitAs(limit);

    const resultSet = await db.query(predicates, [
      'id', 'category', 'categoryName', 'time', 'timeLabel',
      'budget', 'budgetLabel', 'diet', 'dietLabels',
      'ingredients', 'hasNoIngredients', 'results', 'createdAt',
    ]);

    const records: DecisionRecord[] = [];
    while (resultSet.goToNextRow()) {
      records.push(DbService.parseDecisionResult(resultSet));
    }
    resultSet.close();
    return records;
  }

  /**
   * 根据 id 查询单条决策记录
   */
  static async getDecisionById(context: common.Context, id: number): Promise<DecisionRecord | null> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_DECISIONS);
    predicates.equalTo('id', id);

    const resultSet = await db.query(predicates, [
      'id', 'category', 'categoryName', 'time', 'timeLabel',
      'budget', 'budgetLabel', 'diet', 'dietLabels',
      'ingredients', 'hasNoIngredients', 'results', 'createdAt',
    ]);

    if (resultSet.goToFirstRow()) {
      const record = DbService.parseDecisionResult(resultSet);
      resultSet.close();
      return record;
    }
    resultSet.close();
    return null;
  }

  /**
   * 删除一条决策记录（同时删除关联的收藏）
   */
  static async deleteDecision(context: common.Context, id: number): Promise<void> {
    const db = await DbService.ensureDb(context);

    // 先删除关联的收藏
    const favPred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    favPred.equalTo('decisionId', id);
    await db.delete(favPred);

    // 再删除决策记录
    const pred = new relationalStore.RdbPredicates(TABLE_DECISIONS);
    pred.equalTo('id', id);
    await db.delete(pred);
    console.info(`DbService: 决策记录已删除，id=${id}`);
  }

  /**
   * 将 ResultSet 解析为 DecisionRecord
   */
  private static parseDecisionResult(rs: relationalStore.ResultSet): DecisionRecord {
    return {
      id: rs.getLong(rs.getColumnIndex('id')),
      category: rs.getLong(rs.getColumnIndex('category')),
      categoryName: rs.getString(rs.getColumnIndex('categoryName')),
      time: rs.getLong(rs.getColumnIndex('time')),
      timeLabel: rs.getString(rs.getColumnIndex('timeLabel')),
      budget: rs.getLong(rs.getColumnIndex('budget')),
      budgetLabel: rs.getString(rs.getColumnIndex('budgetLabel')),
      diet: JSON.parse(rs.getString(rs.getColumnIndex('diet')) || '[]') as number[],
      dietLabels: JSON.parse(rs.getString(rs.getColumnIndex('dietLabels')) || '[]') as string[],
      ingredients: JSON.parse(rs.getString(rs.getColumnIndex('ingredients')) || '[]') as string[],
      hasNoIngredients: rs.getLong(rs.getColumnIndex('hasNoIngredients')) === 1,
      results: rs.getString(rs.getColumnIndex('results')),
      createdAt: rs.getString(rs.getColumnIndex('createdAt')),
    };
  }

  // ========== 收藏操作 ==========

  /**
   * 收藏一道菜
   * @returns 新收藏的 id；如果已存在则返回现有 id
   */
  static async addFavorite(context: common.Context, dish: FavoriteDish): Promise<number> {
    const db = await DbService.ensureDb(context);

    // 检查是否已收藏（按菜品名查重）
    const checkPred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    checkPred.equalTo('dishName', dish.dishName);
    const existing = await db.query(checkPred, ['id']);
    if (existing.goToFirstRow()) {
      const existingId = existing.getLong(existing.getColumnIndex('id'));
      existing.close();
      console.info(`DbService: 菜品已收藏，id=${existingId}`);
      return existingId;
    }
    existing.close();

    const now = new Date().toISOString();
    const valueBucket: relationalStore.ValuesBucket = {
      dishName: dish.dishName,
      dishIcon: dish.dishIcon,
      time: dish.time,
      cost: dish.cost,
      difficulty: dish.difficulty,
      hasIngredients: dish.hasIngredients ? 1 : 0,
      cookTime: dish.cookTime,
      deliveryTime: dish.deliveryTime,
      cookCost: dish.cookCost,
      deliveryCost: dish.deliveryCost,
      reason: dish.reason,
      decisionId: dish.decisionId ?? null,
      createdAt: now,
    };

    const rowId = await db.insert(TABLE_FAVORITES, valueBucket);
    console.info(`DbService: 收藏成功，id=${rowId}`);
    return rowId;
  }

  /**
   * 取消收藏（按菜品名删除）
   */
  static async removeFavorite(context: common.Context, dishName: string): Promise<void> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    pred.equalTo('dishName', dishName);
    await db.delete(pred);
    console.info(`DbService: 已取消收藏，dishName=${dishName}`);
  }

  /**
   * 查询某道菜是否已收藏
   */
  static async isFavorited(context: common.Context, dishName: string): Promise<boolean> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    pred.equalTo('dishName', dishName);
    const resultSet = await db.query(pred, ['id']);
    const exists = resultSet.goToFirstRow();
    resultSet.close();
    return exists;
  }

  /**
   * 查询所有收藏（按收藏时间倒序）
   */
  static async getAllFavorites(context: common.Context): Promise<FavoriteDish[]> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    predicates.orderByDesc('createdAt');

    const resultSet = await db.query(predicates, [
      'id', 'dishName', 'dishIcon', 'time', 'cost', 'difficulty',
      'hasIngredients', 'cookTime', 'deliveryTime',
      'cookCost', 'deliveryCost', 'reason', 'decisionId', 'createdAt',
    ]);

    const favorites: FavoriteDish[] = [];
    while (resultSet.goToNextRow()) {
      favorites.push(DbService.parseFavoriteResult(resultSet));
    }
    resultSet.close();
    return favorites;
  }

  /**
   * 将 ResultSet 解析为 FavoriteDish
   */
  private static parseFavoriteResult(rs: relationalStore.ResultSet): FavoriteDish {
    const decisionIdIdx = rs.getColumnIndex('decisionId');
    const decisionIdValue: number | undefined = rs.isColumnNull(decisionIdIdx) ? undefined : rs.getLong(decisionIdIdx);
    return {
      id: rs.getLong(rs.getColumnIndex('id')),
      dishName: rs.getString(rs.getColumnIndex('dishName')),
      dishIcon: rs.getString(rs.getColumnIndex('dishIcon')),
      time: rs.getString(rs.getColumnIndex('time')),
      cost: rs.getString(rs.getColumnIndex('cost')),
      difficulty: rs.getString(rs.getColumnIndex('difficulty')),
      hasIngredients: rs.getLong(rs.getColumnIndex('hasIngredients')) === 1,
      cookTime: rs.getString(rs.getColumnIndex('cookTime')),
      deliveryTime: rs.getString(rs.getColumnIndex('deliveryTime')),
      cookCost: rs.getDouble(rs.getColumnIndex('cookCost')),
      deliveryCost: rs.getDouble(rs.getColumnIndex('deliveryCost')),
      reason: rs.getString(rs.getColumnIndex('reason')),
      decisionId: decisionIdValue,
      createdAt: rs.getString(rs.getColumnIndex('createdAt')),
    };
  }

  /**
   * 清空所有收藏
   */
  static async clearAllFavorites(context: common.Context): Promise<void> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    await db.delete(pred);
    console.info('DbService: 所有收藏已清空');
  }

  // ========== 冰箱食材操作（多冰箱） ==========

  /**
   * 获取所有冰箱列表
   */
  static async getAllFridges(context: common.Context): Promise<FridgeInfo[]> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_FRIDGE_LIST);
    predicates.orderByDesc('updatedAt');
    const resultSet = await db.query(predicates, ['id', 'name', 'ingredients', 'updatedAt']);
    const fridges: FridgeInfo[] = [];
    while (resultSet.goToNextRow()) {
      const jsonStr = resultSet.getString(resultSet.getColumnIndex('ingredients'));
      let ingredients: string[] = [];
      try {
        ingredients = JSON.parse(jsonStr || '[]') as string[];
      } catch (e) {
        ingredients = [];
      }
      fridges.push({
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        ingredients: ingredients,
        updatedAt: resultSet.getString(resultSet.getColumnIndex('updatedAt')),
      });
    }
    resultSet.close();
    return fridges;
  }

  /**
   * 根据 id 获取单个冰箱
   */
  static async getFridgeById(context: common.Context, id: number): Promise<FridgeInfo | null> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_FRIDGE_LIST);
    predicates.equalTo('id', id);
    const resultSet = await db.query(predicates, ['id', 'name', 'ingredients', 'updatedAt']);
    if (resultSet.goToFirstRow()) {
      const jsonStr = resultSet.getString(resultSet.getColumnIndex('ingredients'));
      let ingredients: string[] = [];
      try {
        ingredients = JSON.parse(jsonStr || '[]') as string[];
      } catch (e) {
        ingredients = [];
      }
      const fridge: FridgeInfo = {
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        ingredients: ingredients,
        updatedAt: resultSet.getString(resultSet.getColumnIndex('updatedAt')),
      };
      resultSet.close();
      return fridge;
    }
    resultSet.close();
    return null;
  }

  /**
   * 自动生成下一个冰箱名称（冰箱一、冰箱二……）
   */
  static async getNextFridgeName(context: common.Context): Promise<string> {
    const fridges = await DbService.getAllFridges(context);
    const count = fridges.length;
    const chineseNums = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    if (count < chineseNums.length) {
      return '冰箱' + chineseNums[count];
    }
    return '冰箱' + (count + 1);
  }

  /**
   * 添加一个新冰箱
   * @returns 新冰箱的 id
   */
  static async addFridge(context: common.Context, name: string, ingredients: string[]): Promise<number> {
    const db = await DbService.ensureDb(context);
    const now = new Date().toISOString();
    const valueBucket: relationalStore.ValuesBucket = {
      name: name,
      ingredients: JSON.stringify(ingredients),
      updatedAt: now,
    };
    const rowId = await db.insert(TABLE_FRIDGE_LIST, valueBucket);
    console.info(`DbService: 冰箱已创建，id=${rowId}, name=${name}`);
    return rowId;
  }

  /**
   * 更新冰箱食材
   */
  static async updateFridge(context: common.Context, id: number, name: string | null, ingredients: string[]): Promise<void> {
    const db = await DbService.ensureDb(context);
    const now = new Date().toISOString();
    const valueBucket: relationalStore.ValuesBucket = {
      ingredients: JSON.stringify(ingredients),
      updatedAt: now,
    };
    if (name !== null) {
      valueBucket['name'] = name;
    }
    const predicates = new relationalStore.RdbPredicates(TABLE_FRIDGE_LIST);
    predicates.equalTo('id', id);
    await db.update(valueBucket, predicates);
    console.info(`DbService: 冰箱已更新，id=${id}`);
  }

  /**
   * 删除冰箱
   */
  static async deleteFridge(context: common.Context, id: number): Promise<void> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_FRIDGE_LIST);
    predicates.equalTo('id', id);
    await db.delete(predicates);
    console.info(`DbService: 冰箱已删除，id=${id}`);
  }

  // ========== 批量删除操作 ==========

  /**
   * 删除所有决策记录（同时删除关联的收藏）
   */
  static async deleteAllDecisions(context: common.Context): Promise<void> {
    const db = await DbService.ensureDb(context);

    // 删除所有关联收藏（匹配任何 decisionId > 0 或非空）
    const favPred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    favPred.isNotNull('decisionId');
    await db.delete(favPred);

    // 删除所有决策记录
    const pred = new relationalStore.RdbPredicates(TABLE_DECISIONS);
    await db.delete(pred);
    console.info('DbService: 所有决策记录已删除');
  }

  /**
   * 删除所有收藏
   */
  static async deleteAllFavorites(context: common.Context): Promise<void> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_FAVORITES);
    await db.delete(pred);
    console.info('DbService: 所有收藏已删除');
  }

  /**
   * 删除所有冰箱
   */
  static async deleteAllFridges(context: common.Context): Promise<void> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_FRIDGE_LIST);
    await db.delete(pred);
    console.info('DbService: 所有冰箱已删除');
  }

  /* ========== [已注释] 用户会话操作 — 登录功能已移除 ==========

  static async saveSession(context: common.Context, account: string, username: string): Promise<void> {
    const db = await DbService.ensureDb(context);
    const now = new Date().toISOString();

    // 先清空旧会话
    const delPred = new relationalStore.RdbPredicates(TABLE_SESSION);
    await db.delete(delPred);

    // 插入新会话
    const valueBucket: relationalStore.ValuesBucket = {
      isLoggedIn: 1,
      account: account,
      username: username,
      updatedAt: now,
    };
    await db.insert(TABLE_SESSION, valueBucket);
    console.info('DbService: 登录会话已保存');
  }

  static async loadSession(context: common.Context): Promise<SessionData | null> {
    const db = await DbService.ensureDb(context);
    const predicates = new relationalStore.RdbPredicates(TABLE_SESSION);
    predicates.limitAs(1);
    const resultSet = await db.query(predicates, ['isLoggedIn', 'account', 'username']);

    if (resultSet.goToFirstRow()) {
      const isLoggedIn = resultSet.getLong(resultSet.getColumnIndex('isLoggedIn')) === 1;
      const account = resultSet.getString(resultSet.getColumnIndex('account'));
      const username = resultSet.getString(resultSet.getColumnIndex('username'));
      resultSet.close();
      const data: SessionData = {
        isLoggedIn: isLoggedIn,
        account: account,
        username: username
      };
      return data;
    }
    resultSet.close();
    return null;
  }

  static async clearSession(context: common.Context): Promise<void> {
    const db = await DbService.ensureDb(context);
    const pred = new relationalStore.RdbPredicates(TABLE_SESSION);
    await db.delete(pred);
    console.info('DbService: 登录会话已清除');
  }
  */
}
