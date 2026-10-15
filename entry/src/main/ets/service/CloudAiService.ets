/**
 * CloudAiService - 云端大模型服务（阿里云百炼 / 通义千问，OpenAI 兼容接口）
 *
 * 与旧实现的本质区别
 * ------------------
 * 旧实现（AiModelService）是"一次裸调用"：把用户条件丢给模型，模型直接吐出 3 道菜的 JSON。
 * 问题在于**生成式模型会违反硬约束**——推荐用户忌口的菜、超出预算的菜，
 * 也可能编造不在菜品库里的菜（幻觉），而后端只能被动接受。
 *
 * 新实现采用「检索增强 + 受约束重排」两段式：
 *   ① 本地结构化检索（确定性）：忌口一票否决 + 预算/时间过滤 + 评分排序，
 *      从 500 道菜里收敛出 10~15 个**必然合规**的候选，并携带各自的量化特征。
 *   ② 云端 LLM 重排（语义）：模型只在候选集合内排序，并结合用户自然语言化的
 *      真实处境（几个人吃、冰箱里有什么、今天累不累）给出个性化推荐理由。
 *   ③ 输出校验：解析失败/越界/幻觉菜名/超长理由 一律判为无效并重试一次。
 *   ④ 降级：仍失败则回退到「本地排序结果 + 模板理由」。
 *
 * 这样拆分的好处：**硬约束由本地保证，模型只负责它真正擅长的语义理解与解释**，
 * 既消除了幻觉风险，又让推荐理由从模板句变成有针对性的说明。
 *
 * 密钥管理
 * --------
 * API Key 绝不硬编码在业务逻辑里。优先级：
 *   1. 用户在「AI 设置」页填写的 Key（持久化在应用 Preferences）
 *   2. 首次运行时写入的默认 Key（见 DEFAULT_API_KEY，便于演示）
 * 需要彻底移除客户端密钥时，把 chat() 的请求地址换成自建服务端代理即可，
 * 其余逻辑无需改动。
 */
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
import { util } from '@kit.ArkTS';
import { LocalDish, RecommendConditions } from './DishTypes';

// ===== 默认配置 =====
const PREF_NAME = 'cloud_ai_config';
const KEY_API_KEY = 'api_key';
const KEY_MODEL = 'model';
const KEY_ENABLED = 'enabled';
const KEY_BASE_URL = 'base_url';

/** 百炼 OpenAI 兼容接口地址 */
const DEFAULT_BASE_URL = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
/** 默认模型：qwen-flash 属百炼新人免费额度覆盖范围，速度快、成本低 */
const DEFAULT_MODEL = 'qwen-flash';
/**
 * 密钥来源（**源码中不出现任何明文密钥**），按优先级：
 *   1. 用户在「AI 设置」页填写 → 持久化到应用 Preferences（最高优先级，可随时更换）
 *   2. 首次启动时从 rawfile/ai-config.local.json 读取（该文件已加入 .gitignore，
 *      不进入版本库，但会被打包进 App，便于演示开箱即用）
 *   3. 都没有时：AI 功能关闭并提示去设置页填写，本地推荐照常工作
 *
 * 若需彻底不在客户端持有密钥，把 baseUrl 改为自建服务端代理地址即可，
 * 检索/重排/校验逻辑无需任何改动。
 */
const LOCAL_KEY_FILE = 'ai-config.local.json';
/** 占位默认值：留空表示"必须由用户配置"，避免源码里出现密钥 */
const DEFAULT_API_KEY: string = '';

// ===== 超时与限制 =====
const CONNECT_TIMEOUT_MS = 8000;
const READ_TIMEOUT_MS = 60000;
/** 送入模型重排的候选数量上限：太少没有语义发挥空间，太多会拉高 token 成本 */
const MAX_CANDIDATES = 12;
/** 返回给用户的菜品数量 */
const RESULT_COUNT = 3;
/** 推荐理由长度上限（防止模型长篇大论撑坏卡片布局） */
const MAX_REASON_LEN = 40;

/** 候选菜品（送给模型重排的精简结构，只带模型判断所需的字段） */
export interface CandidateDish {
  name: string;
  icon: string;
  category: string;
  cookTime: string;
  cookCost: number;
  deliveryTime: string;
  deliveryCost: number;
  requiredIngredients: string[];
  /** 家里已有的所需食材数量 */
  ownedCount: number;
  /** 本地评分（供模型参考，不要求它照抄） */
  localScore: number;
}

/** 模型重排后的结果 */
export interface RerankItem {
  name: string;
  /** 0~100，模型对"最适合这位用户"的主观打分 */
  score: number;
  /** 个性化推荐理由（面向用户展示） */
  reason: string;
}

/** 重排调用的结果 */
export interface RerankResult {
  ok: boolean;
  items: RerankItem[];
  /** 失败原因（ok 为 false 时填写） */
  failReason: string;
}

/** 设置页使用的 AI 配置 */
export interface CloudAiConfig {
  apiKey: string;
  model: string;
  enabled: boolean;
  baseUrl: string;
}

/** 连接检测结果 */
export interface CloudAiTestResult {
  ok: boolean;
  message: string;
  /** 实测耗时（毫秒） */
  latencyMs: number;
}

// ===== HTTP 请求体结构 =====
interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequestBody {
  model: string;
  messages: ChatMessage[];
  temperature: number;
  max_tokens: number;
  response_format?: ResponseFormat;
}

interface ResponseFormat {
  type: string;
}

interface ChoiceMessage {
  content?: string;
}

interface ChatChoice {
  message?: ChoiceMessage;
}

interface ChatResponse {
  choices?: ChatChoice[];
  error?: ChatError;
}

interface ChatError {
  message?: string;
  code?: string;
}

/** ai-config.local.json 的结构 */
interface LocalKeyFile {
  apiKey?: string;
  model?: string;
}

/** 模型返回的单项（解析目标，字段全部可选以便逐项校验） */
interface RawRerankItem {
  name?: string;
  score?: number;
  reason?: string;
}

interface RawRerankPayload {
  items?: RawRerankItem[];
}

export class CloudAiService {
  private static prefs: preferences.Preferences | null = null;
  /** 本次会话内是否已提示过降级（避免每条推荐都弹窗打扰） */
  private static degradeNotified: boolean = false;

  // ==================== 配置读写 ====================

  static async init(context: common.Context): Promise<void> {
    if (CloudAiService.prefs) {
      return;
    }
    CloudAiService.prefs = await preferences.getPreferences(context, { name: PREF_NAME });

    // 首次运行：把 rawfile 中的本地密钥写入 Preferences 作为初始值。
    // 该文件被 .gitignore 忽略，因此不会出现在任何提交的源码里。
    const saved: string = await CloudAiService.prefs.get(KEY_API_KEY, '') as string;
    if (saved === '') {
      const local = await CloudAiService.readLocalApiKey(context);
      if (local.length > 0) {
        await CloudAiService.prefs.put(KEY_API_KEY, local);
        await CloudAiService.prefs.put(KEY_MODEL, DEFAULT_MODEL);
        await CloudAiService.prefs.put(KEY_ENABLED, 1);
        await CloudAiService.prefs.flush();
        console.info('CloudAiService: 已从本地配置文件载入 AI 配置');
      } else {
        console.info('CloudAiService: 未发现本地 AI 配置，请在「AI 设置」页填写');
      }
    }
  }

  /**
   * 读取 rawfile/ai-config.local.json 中的密钥（不存在或格式非法时返回空串）。
   * 文件内容形如： { "apiKey": "sk-xxxx", "model": "qwen-flash" }
   */
  private static async readLocalApiKey(context: common.Context): Promise<string> {
    try {
      const mgr = context.resourceManager;
      const bytes: Uint8Array = await mgr.getRawFileContent(LOCAL_KEY_FILE);
      const text = util.TextDecoder.create('utf-8').decodeToString(bytes);
      const parsed = JSON.parse(text) as LocalKeyFile;
      const key = parsed.apiKey;
      if (key === undefined || key.trim().length === 0) {
        return '';
      }
      return key.trim();
    } catch (e) {
      // 文件不存在属正常情况（用户选择在设置页填写），不视为错误
      console.info('CloudAiService: 未读取到本地 AI 配置文件');
      return '';
    }
  }

  static async getApiKey(): Promise<string> {
    if (!CloudAiService.prefs) {
      return DEFAULT_API_KEY;
    }
    return await CloudAiService.prefs.get(KEY_API_KEY, DEFAULT_API_KEY) as string;
  }

  static async getModel(): Promise<string> {
    if (!CloudAiService.prefs) {
      return DEFAULT_MODEL;
    }
    const m = await CloudAiService.prefs.get(KEY_MODEL, DEFAULT_MODEL) as string;
    return m.trim() === '' ? DEFAULT_MODEL : m;
  }

  static async getBaseUrl(): Promise<string> {
    if (!CloudAiService.prefs) {
      return DEFAULT_BASE_URL;
    }
    const u = await CloudAiService.prefs.get(KEY_BASE_URL, DEFAULT_BASE_URL) as string;
    return u.trim() === '' ? DEFAULT_BASE_URL : u;
  }

  static async isEnabled(): Promise<boolean> {
    if (!CloudAiService.prefs) {
      return true;
    }
    return (await CloudAiService.prefs.get(KEY_ENABLED, 1)) === 1;
  }

  static async saveConfig(config: CloudAiConfig): Promise<void> {
    if (!CloudAiService.prefs) {
      return;
    }
    await CloudAiService.prefs.put(KEY_API_KEY, config.apiKey.trim());
    await CloudAiService.prefs.put(KEY_MODEL, config.model.trim() === '' ? DEFAULT_MODEL : config.model.trim());
    await CloudAiService.prefs.put(KEY_ENABLED, config.enabled ? 1 : 0);
    await CloudAiService.prefs.put(KEY_BASE_URL, config.baseUrl.trim() === '' ? DEFAULT_BASE_URL : config.baseUrl.trim());
    await CloudAiService.prefs.flush();
  }

  /** 是否已配置可用的 Key */
  static async isConfigured(): Promise<boolean> {
    const key = await CloudAiService.getApiKey();
    return key.trim().length > 0;
  }

  /** 读取当前配置（设置页用） */
  static async loadConfig(): Promise<CloudAiConfig> {
    return {
      apiKey: await CloudAiService.getApiKey(),
      model: await CloudAiService.getModel(),
      enabled: await CloudAiService.isEnabled(),
      baseUrl: await CloudAiService.getBaseUrl()
    } as CloudAiConfig;
  }

  /** 重置"已提示过降级"标记（用户主动重试时调用） */
  static resetDegradeNotice(): void {
    CloudAiService.degradeNotified = false;
  }

  /** 是否应该弹出降级提示（每个会话只提示一次） */
  static shouldNotifyDegrade(): boolean {
    if (CloudAiService.degradeNotified) {
      return false;
    }
    CloudAiService.degradeNotified = true;
    return true;
  }

  // ==================== 连接检测 ====================

  /**
   * 用一次极小的真实请求检测 Key 与模型是否可用
   */
  static async testConnection(apiKey: string, model: string): Promise<CloudAiTestResult> {
    const start = Date.now();
    try {
      const reply = await CloudAiService.callChat(
        apiKey.trim(),
        model.trim() === '' ? DEFAULT_MODEL : model.trim(),
        '你是连通性测试助手，只回复 OK。',
        '回复 OK',
        8
      );
      const cost = Date.now() - start;
      return {
        ok: true,
        message: '连接成功，模型回复：' + reply.trim().substring(0, 20) + '（' + cost + 'ms）',
        latencyMs: cost
      } as CloudAiTestResult;
    } catch (err) {
      const msg = err instanceof Error ? err.message : JSON.stringify(err);
      return {
        ok: false,
        message: CloudAiService.friendlyError(msg),
        latencyMs: Date.now() - start
      } as CloudAiTestResult;
    }
  }

  /** 把底层错误翻译成用户能看懂的话 */
  private static friendlyError(msg: string): string {
    if (msg.indexOf('401') >= 0 || msg.indexOf('InvalidApiKey') >= 0 ||
      msg.indexOf('invalid_api_key') >= 0) {
      return 'API Key 无效或已失效，请重新生成后填写';
    }
    if (msg.indexOf('403') >= 0) {
      return '无权访问该模型：可能是免费额度已用尽，或该模型未开通';
    }
    if (msg.indexOf('404') >= 0) {
      return '模型名不存在，请检查模型名是否拼写正确';
    }
    if (msg.indexOf('429') >= 0) {
      return '请求过于频繁，请稍后再试';
    }
    if (msg.indexOf('timeout') >= 0 || msg.indexOf('Timeout') >= 0) {
      return '请求超时，请检查网络后重试';
    }
    if (msg.indexOf('Arrearage') >= 0) {
      return '账户欠费，请检查百炼控制台';
    }
    return msg;
  }

  // ==================== 核心：候选重排 ====================

  /**
   * 让云端模型对本地筛选出的候选菜品做语义重排并生成个性化推荐理由。
   *
   * @param conditions 用户条件
   * @param candidates 本地检索层产出的合规候选
   * @param profileSummary 用户画像摘要（自然语言，含收藏与近期偏好）
   * @param userNote 用户自由补充的处境描述（可为空）
   */
  static async rerankCandidates(
    conditions: RecommendConditions,
    candidates: CandidateDish[],
    profileSummary: string,
    userNote: string = ''
  ): Promise<RerankResult> {
    if (candidates.length === 0) {
      return { ok: false, items: [], failReason: '候选菜品为空' } as RerankResult;
    }
    const apiKey = await CloudAiService.getApiKey();
    if (apiKey.trim() === '') {
      return { ok: false, items: [], failReason: '未配置 API Key' } as RerankResult;
    }
    const model = await CloudAiService.getModel();

    const systemPrompt = CloudAiService.buildSystemPrompt();
    const userPrompt = CloudAiService.buildRerankPrompt(conditions, candidates, profileSummary, userNote);

    let lastErr = '';
    // 最多两次尝试：第一次解析/校验失败后带上更严格的提示重试
    for (let attempt = 0; attempt < 2; attempt++) {
      try {
        // 第二次重试降温，降低再次跑偏的概率
        const temperature = attempt === 0 ? 0.3 : 0.1;
        const raw = await CloudAiService.callChat(apiKey, model, systemPrompt, userPrompt, 900, temperature);
        const parsed = CloudAiService.parseRerank(raw);
        if (parsed === null) {
          lastErr = '返回内容不是合法 JSON';
          console.warn('CloudAiService: 第 ' + (attempt + 1) + ' 次解析失败');
          continue;
        }
        const validated = CloudAiService.validateRerank(parsed, candidates, conditions);
        if (validated.length === 0) {
          lastErr = '返回结果未通过约束校验';
          console.warn('CloudAiService: 第 ' + (attempt + 1) + ' 次校验失败');
          continue;
        }
        return { ok: true, items: validated, failReason: '' } as RerankResult;
      } catch (err) {
        lastErr = err instanceof Error ? err.message : JSON.stringify(err);
        // 认证类错误重试没有意义，直接返回
        if (lastErr.indexOf('401') >= 0 || lastErr.indexOf('403') >= 0) {
          break;
        }
        console.warn('CloudAiService: 第 ' + (attempt + 1) + ' 次调用异常：' + lastErr);
      }
    }
    return {
      ok: false,
      items: [],
      failReason: CloudAiService.friendlyError(lastErr)
    } as RerankResult;
  }

  private static buildSystemPrompt(): string {
    return '你是「懂吃」App 的资深美食顾问。' +
      '用户会给你一份【已经通过硬性约束筛选的候选菜品清单】，' +
      '你的任务是在这个清单内部排序，挑出最适合该用户当下处境的若干道菜，并为每道菜写一句有针对性的推荐理由。\n\n' +
      '必须遵守的规则：\n' +
      '1. 只能从候选清单里选，禁止引入清单之外的任何菜名，禁止编造菜名。\n' +
      '2. 推荐理由要结合用户的具体处境（几人吃、冰箱里已有什么、时间是否紧张、预算是否敏感），' +
      '不要说"营养美味""强烈推荐"这类空话。\n' +
      '3. 理由不超过 30 个字，直接给出判断依据，不要重复菜名。\n' +
      '4. 严格输出 JSON，不要输出任何解释文字、不要用 markdown 代码块包裹。\n\n' +
      '输出格式：{"items":[{"name":"菜名","score":92,"reason":"理由"}]}\n' +
      'score 是 0-100 的整数，表示"在当前处境下这道菜的适合程度"。';
  }

  private static buildRerankPrompt(
    conditions: RecommendConditions,
    candidates: CandidateDish[],
    profileSummary: string,
    userNote: string
  ): string {
    const lines: string[] = [];

    lines.push('【用户条件】');
    lines.push('- 口味方向：' + conditions.categoryName);
    lines.push('- 时间预算：' + (conditions.time >= 0 ? conditions.timeLabel : '不限'));
    lines.push('- 花费预算：' + (conditions.budget >= 0 ? conditions.budgetLabel : '不限'));
    lines.push('- 忌口限制：' + (conditions.dietLabels.length > 0 ? conditions.dietLabels.join('、') : '无'));
    if (conditions.hasNoIngredients) {
      lines.push('- 家里食材：完全没有食材，需要从零采购');
    } else if (conditions.ingredients.length > 0) {
      lines.push('- 家里现有食材：' + conditions.ingredients.join('、'));
    } else {
      lines.push('- 家里食材：未登记');
    }
    if (userNote.trim().length > 0) {
      lines.push('- 用户补充说明：' + userNote.trim());
    }
    if (profileSummary.trim().length > 0) {
      lines.push('- 历史偏好：' + profileSummary.trim());
    }

    lines.push('');
    lines.push('【候选菜品清单】（只能从这里选，共 ' + candidates.length + ' 道）');
    for (let i = 0; i < candidates.length; i++) {
      const c = candidates[i];
      let line = (i + 1).toString() + '. ' + c.name + '｜' + c.category +
        '｜自己做约' + c.cookTime + '/' + c.cookCost + '元' +
        '｜外卖约' + c.deliveryTime + '/' + c.deliveryCost + '元';
      if (c.requiredIngredients.length > 0) {
        line += '｜需要：' + c.requiredIngredients.join('、');
        line += '（家中已有 ' + c.ownedCount + '/' + c.requiredIngredients.length + ' 样）';
      }
      lines.push(line);
    }

    lines.push('');
    lines.push('请挑选最合适的 ' + RESULT_COUNT + ' 道（不足则按实际数量），按适合程度从高到低输出 JSON。');
    return lines.join('\n');
  }

  // ==================== 解析与校验 ====================

  /**
   * 解析模型返回的 JSON。
   * 兼容三种常见情况：纯 JSON、被 markdown 代码块包裹、前后带解释文字。
   */
  private static parseRerank(text: string): RawRerankPayload | null {
    const cleaned = CloudAiService.extractJsonObject(text);
    if (cleaned === '') {
      return null;
    }
    try {
      const parsed = JSON.parse(cleaned) as RawRerankPayload;
      if (parsed === null || parsed.items === undefined || !Array.isArray(parsed.items)) {
        return null;
      }
      return parsed;
    } catch (e) {
      console.warn('CloudAiService: JSON 解析异常 ' + JSON.stringify(e));
      return null;
    }
  }

  /**
   * 从可能含噪声的文本中提取第一个完整的 JSON 对象。
   * 做法是"从第一个 { 开始，逐个尝试收缩到每个 } 解析"，比贪婪正则可靠：
   * 贪婪匹配在模型输出解释文字时会一次性吞掉过多内容导致必然解析失败。
   */
  private static extractJsonObject(text: string): string {
    const start = text.indexOf('{');
    if (start < 0) {
      return '';
    }
    // 去掉 markdown 代码块围栏，避免影响括号配对
    const body = text.replace(/```json/g, '').replace(/```/g, '');
    const realStart = body.indexOf('{');
    if (realStart < 0) {
      return '';
    }
    let depth = 0;
    let inString = false;
    let escaped = false;
    for (let i = realStart; i < body.length; i++) {
      const ch = body.charAt(i);
      if (escaped) {
        escaped = false;
        continue;
      }
      if (ch === '\\') {
        escaped = true;
        continue;
      }
      if (ch === '"') {
        inString = !inString;
        continue;
      }
      if (inString) {
        continue;
      }
      if (ch === '{') {
        depth++;
      } else if (ch === '}') {
        depth--;
        if (depth === 0) {
          return body.substring(realStart, i + 1);
        }
      }
    }
    return '';
  }

  /**
   * 校验并清洗模型结果的**可测试入口**。
   *
   * 之所以是 public static 而非 private：这套校验是"防止大模型幻觉与约束违反"的
   * 最后一道闸门，必须在单元测试里被直接覆盖（见 ohosTest），
   * 否则只能靠联网手测，回归成本过高。
   * 生产调用请用 rerankCandidates()，不要直接调用本方法。
   */
  static validateRerankForTest(
    payloadText: string,
    candidates: CandidateDish[],
    conditions: RecommendConditions
  ): RerankItem[] {
    const parsed = CloudAiService.parseRerank(payloadText);
    if (parsed === null) {
      return [];
    }
    return CloudAiService.validateRerank(parsed, candidates, conditions);
  }

  /**
   * 解析模型返回文本（可测试入口，理由同上）
   */
  static extractJsonForTest(text: string): string {
    return CloudAiService.extractJsonObject(text);
  }

  /**
   * 校验并清洗模型结果。
   * 任何一项不满足就丢弃该项；全部无效则返回空数组，由上层降级到本地排序。
   */
  private static validateRerank(
    payload: RawRerankPayload,
    candidates: CandidateDish[],
    conditions: RecommendConditions
  ): RerankItem[] {
    const items = payload.items;
    if (items === undefined) {
      return [];
    }

    // 候选菜名白名单：杜绝幻觉出的菜
    const allowed = new Set<string>();
    for (const c of candidates) {
      allowed.add(c.name);
    }

    const noSpicy = conditions.diet.indexOf(0) >= 0;
    const noCoriander = conditions.diet.indexOf(1) >= 0;
    const noSeafood = conditions.diet.indexOf(2) >= 0;
    const vegetarian = conditions.diet.indexOf(3) >= 0;

    const result: RerankItem[] = [];
    const used = new Set<string>();

    for (const raw of items) {
      const name = (raw.name === undefined ? '' : raw.name).trim();
      if (name === '' || !allowed.has(name)) {
        console.warn('CloudAiService: 丢弃非候选菜名（疑似幻觉）：' + name);
        continue;
      }
      if (used.has(name)) {
        continue;
      }
      // 二次忌口校验：即使候选是本地过滤过的，也不信任模型不会串味
      if (!CloudAiService.dietSafe(name, noSpicy, noCoriander, noSeafood, vegetarian)) {
        console.warn('CloudAiService: 丢弃违反忌口的菜：' + name);
        continue;
      }

      let score = raw.score === undefined ? 60 : Number(raw.score);
      if (!Number.isFinite(score)) {
        score = 60;
      }
      score = Math.max(0, Math.min(100, Math.round(score)));

      let reason = (raw.reason === undefined ? '' : raw.reason).trim();
      reason = reason.replace(/\s+/g, ' ');
      if (reason.length > MAX_REASON_LEN) {
        reason = reason.substring(0, MAX_REASON_LEN);
      }
      if (reason === '') {
        // 理由为空不算致命，用中性句兜底
        reason = '综合你的时间和预算，这道菜最合适';
      }

      used.add(name);
      result.push({ name: name, score: score, reason: reason } as RerankItem);
      if (result.length >= RESULT_COUNT) {
        break;
      }
    }

    // 按模型给出的适合度降序，保证展示顺序与理由一致
    result.sort((a, b) => b.score - a.score);
    return result;
  }

  /** 菜名级忌口兜底校验（与本地关键词规则保持一致） */
  private static dietSafe(
    name: string,
    noSpicy: boolean,
    noCoriander: boolean,
    noSeafood: boolean,
    vegetarian: boolean
  ): boolean {
    if (noSpicy && name.indexOf('辣') >= 0) {
      return false;
    }
    if (noCoriander && name.indexOf('香菜') >= 0) {
      return false;
    }
    if (noSeafood && CloudAiService.containsAny(name, ['虾', '蟹', '鱼', '贝', '蛤', '鱿', '鲍', '海参', '海鲜'])) {
      return false;
    }
    if (vegetarian && CloudAiService.containsAny(name,
      ['猪', '牛', '羊', '鸡', '鸭', '鹅', '肉', '排骨', '培根', '火腿', '香肠', '虾', '蟹', '鱼', '贝', '蛤', '鱿'])) {
      return false;
    }
    return true;
  }

  private static containsAny(text: string, keywords: string[]): boolean {
    for (const k of keywords) {
      if (text.indexOf(k) >= 0) {
        return true;
      }
    }
    return false;
  }

  // ==================== 底层 HTTP ====================

  /** 单轮对话，返回模型文本内容 */
  private static callChat(
    apiKey: string,
    model: string,
    systemPrompt: string,
    userPrompt: string,
    maxTokens: number,
    temperature: number = 0.3
  ): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      CloudAiService.getBaseUrl().then((baseUrl) => {
        const url = baseUrl + '/chat/completions';
        const httpRequest = http.createHttp();
        const messages: ChatMessage[] = [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt }
        ];
        const requestBody: ChatRequestBody = {
          model: model,
          messages: messages,
          temperature: temperature,
          max_tokens: maxTokens
        };
        const bodyStr = JSON.stringify(requestBody);

        httpRequest.request(
          url,
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + apiKey
            },
            extraData: bodyStr,
            expectDataType: http.HttpDataType.STRING,
            connectTimeout: CONNECT_TIMEOUT_MS,
            readTimeout: READ_TIMEOUT_MS
          },
          (err: Error, data: http.HttpResponse) => {
            if (err) {
              httpRequest.destroy();
              reject(new Error('网络请求失败：' + JSON.stringify(err)));
              return;
            }
            const code = data.responseCode;
            const body = typeof data.result === 'string' ? data.result : JSON.stringify(data.result);
            httpRequest.destroy();

            if (code !== 200) {
              // 尽量把服务端返回的错误信息透出来，便于定位
              let detail = body;
              try {
                const parsed = JSON.parse(body) as ChatResponse;
                if (parsed.error !== undefined && parsed.error.message !== undefined) {
                  detail = parsed.error.message;
                }
              } catch (e) {
                // 保持原始 body
              }
              reject(new Error('HTTP ' + code + '：' + detail));
              return;
            }

            try {
              const parsed = JSON.parse(body) as ChatResponse;
              const choices = parsed.choices;
              if (choices === undefined || choices.length === 0) {
                reject(new Error('模型返回内容为空'));
                return;
              }
              const message = choices[0].message;
              if (message === undefined || message.content === undefined) {
                reject(new Error('模型返回结构异常'));
                return;
              }
              resolve(message.content);
            } catch (e) {
              reject(new Error('响应解析失败：' + JSON.stringify(e)));
            }
          }
        );
      }).catch((e: Error) => {
        reject(e);
      });
    });
  }
}
