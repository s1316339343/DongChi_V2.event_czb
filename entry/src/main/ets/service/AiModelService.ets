/**
 * AiModelService - Ollama 大模型服务：配置持久化 + 局域网自动发现 + 调用
 *
 * 设计目标（解决"每次换 IP 都要改代码"的问题）：
 * 1. 服务地址与模型名保存在应用本地配置（Preferences）中，
 *    在「我的 → AI 模型设置」页面修改一次即可长期生效，无需改代码。
 * 2. 当已保存的地址连不上时，自动扫描当前局域网（端口 11434）找到 Ollama，
 *    并自动记住结果 —— 电脑 IP 变了（DHCP 换地址）APP 也能自愈。
 * 3. 模型名与 Ollama 实际模型列表自动匹配（对应 ollama list 显示的名字），
 *    列表为空时自动选第一个可用模型。
 *
 * 电脑端前提（详见 AiSettings 页面底部说明）：
 *   - 设置系统环境变量 OLLAMA_HOST=0.0.0.0 后重启 Ollama（默认只监听本机，手机连不上）
 *   - 防火墙放行 11434 端口，手机与电脑连同一个 WiFi
 */
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import http from '@ohos.net.http';
import net from '@ohos.net.connection';

const PREF_NAME = 'ai_model_config';
const KEY_HOST = 'host';
const KEY_MODEL = 'model';
const KEY_AUTO = 'auto_discover';
const OLLAMA_PORT = 11434;
const SCAN_CONCURRENCY = 20;

// Ollama /api/tags 响应
interface OllamaModelInfo {
  name: string;
}

interface OllamaTagsResponse {
  models: OllamaModelInfo[];
}

interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequestBody {
  model: string;
  messages: ChatMessage[];
  temperature: number;
  max_tokens: number;
}

/** 当前生效的模型配置 */
export interface AiModelConfigData {
  host: string;
  model: string;
  autoDiscover: boolean;
}

/** 测试连接结果（设置页用） */
export interface AiTestResult {
  ok: boolean;
  host: string;
  models: string[];
  message: string;
}

export class AiModelService {
  private static prefs: preferences.Preferences | null = null;
  private static probing: boolean = false;

  // ========== 配置持久化 ==========

  static async init(context: common.Context): Promise<void> {
    if (AiModelService.prefs) {
      return;
    }
    AiModelService.prefs = await preferences.getPreferences(context, { name: PREF_NAME });
    console.info('AiModelService: 配置模块初始化成功');
  }

  static async getStoredHost(): Promise<string> {
    if (!AiModelService.prefs) {
      return '';
    }
    return (await AiModelService.prefs.get(KEY_HOST, '')) as string;
  }

  static async getStoredModel(): Promise<string> {
    if (!AiModelService.prefs) {
      return '';
    }
    return (await AiModelService.prefs.get(KEY_MODEL, '')) as string;
  }

  static async getStoredAutoDiscover(): Promise<boolean> {
    if (!AiModelService.prefs) {
      return true;
    }
    return (await AiModelService.prefs.get(KEY_AUTO, 1)) === 1;
  }

  static async saveHost(host: string): Promise<void> {
    if (!AiModelService.prefs) {
      return;
    }
    await AiModelService.prefs.put(KEY_HOST, host);
    await AiModelService.prefs.flush();
  }

  static async saveModel(model: string): Promise<void> {
    if (!AiModelService.prefs) {
      return;
    }
    await AiModelService.prefs.put(KEY_MODEL, model);
    await AiModelService.prefs.flush();
  }

  static async saveAutoDiscover(v: boolean): Promise<void> {
    if (!AiModelService.prefs) {
      return;
    }
    await AiModelService.prefs.put(KEY_AUTO, v ? 1 : 0);
    await AiModelService.prefs.flush();
  }

  /** 归一化用户输入的地址：去掉协议头/路径，localhost 转 127.0.0.1，缺省端口补 11434 */
  static normalizeHost(input: string): string {
    let h = input.trim();
    if (h.length === 0) {
      return '';
    }
    const lower = h.toLowerCase();
    if (lower.indexOf('http://') === 0) {
      h = h.substring(7);
    } else if (lower.indexOf('https://') === 0) {
      h = h.substring(8);
    }
    const slash = h.indexOf('/');
    if (slash >= 0) {
      h = h.substring(0, slash);
    }
    if (h.toLowerCase() === 'localhost') {
      h = '127.0.0.1';
    }
    if (h.indexOf(':') < 0) {
      h = h + ':' + OLLAMA_PORT;
    }
    return h;
  }

  // ========== 探测与发现 ==========

  /**
   * 探测指定地址是否为可用 Ollama 服务
   * @returns 可用时返回模型名列表（对应 ollama list）
   * @throws 不可用时抛出错误
   */
  static async probe(host: string): Promise<string[]> {
    const url = 'http://' + host + '/api/tags';
    const req = http.createHttp();
    try {
      const data = await req.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 2500,
        readTimeout: 6000
      });
      if (data.responseCode !== 200) {
        throw new Error('HTTP ' + data.responseCode);
      }
      const text = (data.result as string) || '';
      const parsed: OllamaTagsResponse = JSON.parse(text) as OllamaTagsResponse;
      const names: string[] = [];
      if (parsed.models) {
        for (let i = 0; i < parsed.models.length; i++) {
          if (parsed.models[i].name) {
            names.push(parsed.models[i].name);
          }
        }
      }
      return names;
    } finally {
      req.destroy();
    }
  }

  private static probeSafe(host: string): Promise<boolean> {
    return AiModelService.probe(host).then(() => true, () => false);
  }

  /** 判断错误是否为连接层失败（地址不可达/超时/拒绝） */
  private static isConnectionError(msg: string): boolean {
    const m = msg.toLowerCase();
    return m.indexOf('connect') >= 0 || m.indexOf('timeout') >= 0
      || m.indexOf('econnrefused') >= 0 || m.indexOf('etimedout') >= 0
      || m.indexOf('请求失败') >= 0;
  }

  /**
   * 自动发现 Ollama 服务：
   * 1. 已保存地址（跳过 skip 中已知的失效地址）
   * 2. 本机 127.0.0.1:11434（真机上的 Ollama / 模拟器场景）
   * 3. 当前局域网全段扫描（并发探测 11434 端口）
   * @returns 发现的主机（host:port），未发现返回 null
   */
  static async discover(skip: string[] = []): Promise<string | null> {
    if (AiModelService.probing) {
      return null; // 正在扫描中，避免重复扫描
    }
    AiModelService.probing = true;
    try {
      const saved = await AiModelService.getStoredHost();
      if (saved !== '' && skip.indexOf(saved) < 0) {
        if (await AiModelService.probeSafe(saved)) {
          return saved;
        }
      }
      const local = '127.0.0.1:' + OLLAMA_PORT;
      if (skip.indexOf(local) < 0 && await AiModelService.probeSafe(local)) {
        return local;
      }
      const candidates = await AiModelService.buildScanCandidates();
      const filtered: string[] = [];
      for (let i = 0; i < candidates.length; i++) {
        const c = candidates[i];
        if (skip.indexOf(c) < 0 && c !== saved && c !== local) {
          filtered.push(c);
        }
      }
      console.info('AiModelService: 开始局域网扫描，候选地址 ' + filtered.length + ' 个');
      return await AiModelService.probePool(filtered);
    } finally {
      AiModelService.probing = false;
    }
  }

  /** 并发探测候选地址，返回第一个可用的（未找到返回 null） */
  private static async probePool(candidates: string[]): Promise<string | null> {
    if (candidates.length === 0) {
      return null;
    }
    let found: string | null = null;
    let nextIdx = 0;
    const worker = (): Promise<void> => (async () => {
      while (!found) {
        const i = nextIdx++;
        if (i >= candidates.length) {
          return;
        }
        const c = candidates[i];
        try {
          await AiModelService.probe(c);
          found = c;
          console.info('AiModelService: 局域网扫描发现 Ollama → ' + c);
        } catch (e) {
          // 该地址不可用，继续
        }
      }
    })();
    const workers: Promise<void>[] = [];
    for (let i = 0; i < SCAN_CONCURRENCY; i++) {
      workers.push(worker());
    }
    await Promise.all(workers);
    return found;
  }

  /** 构建局域网扫描候选列表（基于本机 IP + 子网掩码，/24 全扫，其余扫描常见段） */
  private static async buildScanCandidates(): Promise<string[]> {
    const cands: string[] = [];
    const seen: string[] = [];
    const push = (c: string): void => {
      if (seen.indexOf(c) < 0) {
        seen.push(c);
        cands.push(c);
      }
    };
    try {
      const netHandle = await net.getDefaultNet();
      const props = await net.getConnectionProperties(netHandle);
      const links = props.linkAddresses;
      for (let i = 0; i < links.length; i++) {
        const addr = links[i].address.address;
        if (!AiModelService.isIPv4(addr)) {
          continue;
        }
        const prefix = links[i].prefixLength;
        const base = AiModelService.networkBaseByPrefix(addr, prefix);
        if (base === null) {
          continue;
        }
        if (prefix >= 24) {
          // /24（家用网络最常见）：扫 1~254
          for (let n = 1; n <= 254; n++) {
            push(base + '.' + n + ':' + OLLAMA_PORT);
          }
        } else {
          // /16 等（少见）：只扫网关 + 第一个 254 段，避免耗时过长
          const firstPart = base.split('.').slice(0, 3).join('.');
          push(firstPart + '.1:' + OLLAMA_PORT);
          for (let n = 1; n <= 254; n++) {
            push(firstPart + '.' + n + ':' + OLLAMA_PORT);
          }
        }
        break;
      }
    } catch (e) {
      console.error('AiModelService: 获取本机网络信息失败', JSON.stringify(e));
    }
    // 兜底：常见家用网段
    if (cands.length === 0) {
      const commonBase = ['192.168.1', '192.168.0', '10.0.0', '172.16.0', '172.17.0'];
      for (let s = 0; s < commonBase.length; s++) {
        for (let n = 1; n <= 254; n++) {
          push(commonBase[s] + '.' + n + ':' + OLLAMA_PORT);
        }
      }
    }
    return cands;
  }

  private static isIPv4(addr: string): boolean {
    const parts = addr.split('.');
    if (parts.length !== 4) {
      return false;
    }
    for (let i = 0; i < 4; i++) {
      const n = parseInt(parts[i], 10);
      if (isNaN(n) || n < 0 || n > 255) {
        return false;
      }
    }
    return true;
  }

  /** 根据 IP + 前缀长度计算网络基址（如 192.168.1.50/24 → "192.168.1"） */
  private static networkBaseByPrefix(addr: string, prefix: number): string | null {
    const parts = addr.split('.');
    if (parts.length !== 4) {
      return null;
    }
    const octets: number[] = [];
    for (let i = 0; i < 4; i++) {
      const n = parseInt(parts[i], 10);
      if (isNaN(n) || n < 0 || n > 255) {
        return null;
      }
      octets.push(n);
    }
    // 保留前 prefix 个二进制位对应的整字节，其余字节清零
    const fullBytes = Math.min(Math.floor(prefix / 8), 4);
    const base: number[] = [];
    for (let i = 0; i < 4; i++) {
      base.push(i < fullBytes ? octets[i] : 0);
    }
    if (fullBytes >= 4) {
      return base.join('.');
    }
    // 处理非整字节边界（如 /21、/25）
    const remainBits = prefix - fullBytes * 8;
    if (remainBits > 0) {
      const mask = 0xFF << (8 - remainBits) & 0xFF;
      base[fullBytes] = octets[fullBytes] & mask;
    }
    return base.join('.');
  }

  // ========== 核心入口 ==========

  /**
   * 确保 Ollama 服务可用并返回 {host, model}：
   * 已保存地址可用 → 直接用；不可用 → 自动发现；发现后自动记住地址与模型
   */
  static async ensureModel(): Promise<AiModelConfigData> {
    if (!AiModelService.prefs) {
      throw new Error('AI 模型配置未初始化，请重启应用后重试');
    }
    let host = await AiModelService.getStoredHost();
    let model = await AiModelService.getStoredModel();
    let models: string[] = [];
    let hostOk = false;
    if (host !== '') {
      try {
        models = await AiModelService.probe(host);
        hostOk = true;
      } catch (e) {
        hostOk = false;
      }
    }
    if (!hostOk) {
      const skip: string[] = host !== '' ? [host] : [];
      const found = await AiModelService.discover(skip);
      if (found === null) {
        throw new Error('未找到可用的 Ollama 服务：请在电脑上启动 Ollama（设置环境变量 OLLAMA_HOST=0.0.0.0），' +
          '并确认手机与电脑连同一个 WiFi；也可在「我的 → AI 模型设置」中手动填写地址');
      }
      host = found;
      await AiModelService.saveHost(host);
      try {
        models = await AiModelService.probe(host);
      } catch (e) {
        models = [];
      }
    }
    if (models.length > 0) {
      if (model === '' || models.indexOf(model) < 0) {
        model = models[0];
        await AiModelService.saveModel(model);
        console.info('AiModelService: 模型名自动切换为 ' + model);
      }
    } else if (model === '') {
      throw new Error('Ollama 服务中没有模型：请先在电脑执行 ollama pull qwen2.5:7b');
    }
    const auto = await AiModelService.getStoredAutoDiscover();
    return { host: host, model: model, autoDiscover: auto } as AiModelConfigData;
  }

  /**
   * 测试连接（设置页"测试连接"按钮用）
   */
  static async testConnection(inputHost: string): Promise<AiTestResult> {
    const host = AiModelService.normalizeHost(inputHost);
    if (host === '') {
      return { ok: false, host: '', models: [], message: '请先填写服务地址' } as AiTestResult;
    }
    try {
      const models = await AiModelService.probe(host);
      let message = '连接成功';
      if (models.length > 0) {
        message = message + '，发现 ' + models.length + ' 个可用模型';
      } else {
        message = message + '，但没有模型：请先在电脑执行 ollama pull qwen2.5:7b';
      }
      return { ok: true, host: host, models: models, message: message } as AiTestResult;
    } catch (e) {
      const detail = e instanceof Error ? e.message : JSON.stringify(e);
      return {
        ok: false, host: host, models: [],
        message: '无法连接 ' + host + '（' + detail + '）。请检查：地址是否正确、电脑防火墙是否放行 11434、是否同一 WiFi'
      } as AiTestResult;
    }
  }

  /**
   * 调用 Ollama 聊天接口（OpenAI 兼容），带自愈逻辑：
   * - 连接失败 → 重新自动发现地址并重试一次
   * - 模型名不存在 → 自动切换为列表中第一个模型并重试一次
   */
  static async chat(prompt: string, context?: common.Context): Promise<string> {
    if (context) {
      await AiModelService.init(context);
    }
    const cfg = await AiModelService.ensureModel();
    let host = cfg.host;
    let model = cfg.model;
    try {
      return await AiModelService.callChatApi(prompt, host, model);
    } catch (e) {
      const msg = e instanceof Error ? e.message : JSON.stringify(e);
      // 情况 1：连接失败 → 重新发现（跳过失效地址）并重试一次
      if (AiModelService.isConnectionError(msg)) {
        const found = await AiModelService.discover([host]);
        if (found !== null && found !== host) {
          console.info('AiModelService: Ollama 地址自动纠正为 ' + found);
          await AiModelService.saveHost(found);
          try {
            return await AiModelService.callChatApi(prompt, found, model);
          } catch (e2) {
            throw e2 instanceof Error ? e2 : new Error(String(e2));
          }
        }
        throw new Error('无法连接 Ollama 服务（' + host + '）。请确认：电脑上已启动 Ollama、' +
          '手机与电脑连同一个 WiFi；也可在「我的 → AI 模型设置」中手动填写地址');
      }
      // 情况 2：模型名不存在 → 自动切换到第一个可用模型并重试一次
      if (msg.toLowerCase().indexOf('model') >= 0 && msg.indexOf('not found') >= 0) {
        const models = await AiModelService.probe(host).catch((): string[] => []);
        if (models.length > 0 && models[0] !== model) {
          console.info('AiModelService: 模型名自动切换为 ' + models[0]);
          await AiModelService.saveModel(models[0]);
          try {
            return await AiModelService.callChatApi(prompt, host, models[0]);
          } catch (e2) {
            throw e2 instanceof Error ? e2 : new Error(String(e2));
          }
        }
      }
      throw new Error('AI 模型服务返回错误：' + msg);
    }
  }

  private static async callChatApi(prompt: string, host: string, model: string): Promise<string> {
    const url = 'http://' + host + '/v1/chat/completions';
    const httpRequest = http.createHttp();

    const messages: ChatMessage[] = [
      { role: 'system', content: '你是一个专业的美食推荐助手，擅长根据用户口味、预算、时间等条件推荐最合适的菜品。' },
      { role: 'user', content: prompt }
    ];

    const requestBody: ChatRequestBody = {
      model: model,
      messages: messages,
      temperature: 0.8,
      max_tokens: 2000
    };

    return new Promise<string>((resolve, reject) => {
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ollama'
          },
          extraData: JSON.stringify(requestBody),
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: 5000,
          // 本地小模型 CPU 推理较慢（可能 1~3 分钟），超时放宽到 5 分钟
          readTimeout: 300000
        },
        (err, data) => {
          if (err) {
            httpRequest.destroy();
            reject(new Error('请求失败: ' + (err.message ? err.message : JSON.stringify(err))));
            return;
          }
          if (data.responseCode !== 200) {
            httpRequest.destroy();
            reject(new Error('API返回错误: ' + data.responseCode + ', ' + (data.result?.toString() || '')));
            return;
          }
          httpRequest.destroy();
          resolve((data.result as string) || '');
        }
      );
    });
  }
}
