/**
 * TTS（文本转语音）服务
 * 基于 @hms.ai.textToSpeech (CoreSpeechKit) 模块实现
 * 提供推荐结果的语音播报功能
 */

import textToSpeech from '@hms.ai.textToSpeech';

/**
 * TTS 播报状态
 */
export enum TtsState {
  /** 空闲 */
  IDLE = 'idle',
  /** 正在播报 */
  SPEAKING = 'speaking',
  /** 暂停 */
  PAUSED = 'paused',
  /** 出错 */
  ERROR = 'error',
  /** 引擎未初始化 */
  UNINITIALIZED = 'uninitialized',
}

/**
 * TTS 引擎配置
 */
export interface TtsConfig {
  /** 语言，默认为 'zh-CN' */
  language?: string;
  /** 语速，范围 0.0~2.0，默认 1.0 */
  speed?: number;
  /** 音调，范围 0.0~2.0，默认 1.0 */
  pitch?: number;
  /** 音量，范围 0.0~1.0，默认 0.85 */
  volume?: number;
}

/**
 * 推荐菜品概览（播报用）
 */
export interface DishOverview {
  name: string;
  reason: string;
  cost: string;
  time: string;
}

/**
 * 菜品详情（播报用）
 */
export interface DishDetail extends DishOverview {
  difficulty: string;
  cookTime: string;
  deliveryTime: string;
  cookCost: number;
  deliveryCost: number;
}

/**
 * TTS 服务 - 单例
 * 封装 @hms.ai.textToSpeech 的初始化、播报、停止等操作
 */
export class TtsService {
  private static instance: TtsService;
  /** 当前播报状态 */
  private state: TtsState = TtsState.UNINITIALIZED;
  /** 引擎实例 */
  private engine: textToSpeech.TextToSpeechEngine | null = null;
  /** 当前语言 */
  private currentLanguage: string = 'zh-CN';
  /** 当前请求 ID */
  private currentRequestId: string = '';
  /** 请求 ID 自增计数器 */
  private requestIdCounter: number = 0;
  /** 语言设定 */
  private voiceLanguage: string = 'zh-CN';
  /** 音色编号（0=女声，1=男声） */
  private voicePerson: number = 0;

  /** 播报完成回调 */
  public onFinish?: () => void;
  /** 出错回调 */
  public onError?: (err: string) => void;

  /** 当前 speak() 的 Promise resolve 函数 — 用于在 stop() 时强制释放旧播报 */
  private currentSpeakResolve: (() => void) | null = null;
  /** 当前 speak() 的 Promise reject 函数 */
  private currentSpeakReject: ((reason?: Error) => void) | null = null;
  /** 正在进行的初始化任务 — 避免并发 init() 各自创建一个引擎而泄漏其中一个 */
  private initTask: Promise<void> | null = null;

  private constructor() {
  }

  /**
   * 获取单例实例
   */
  static getInstance(): TtsService {
    if (!TtsService.instance) {
      TtsService.instance = new TtsService();
    }
    return TtsService.instance;
  }

  /**
   * 生成唯一的请求 ID
   */
  private generateRequestId(): string {
    this.requestIdCounter++;
    return 'tts_' + this.requestIdCounter.toString() + '_' + Date.now().toString();
  }

  /**
   * 初始化 TTS 引擎
   * 使用离线模式（online: 1）
   * @param config 可选配置
   * @returns Promise，初始化成功时 resolve
   */
  init(config?: TtsConfig): Promise<void> {
    // 并发调用共享同一个初始化任务：否则两个调用者都会看到 engine === null，
    // 各自 createEngine，后完成者覆盖 this.engine，先创建的引擎永远不会 shutdown()。
    if (this.initTask !== null) {
      return this.initTask;
    }
    const task = this.doInit(config);
    this.initTask = task;
    task.then(() => {
      this.initTask = null;
    }, () => {
      this.initTask = null;
    });
    return task;
  }

  private doInit(config?: TtsConfig): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      // 如果已初始化，先释放（shutdown 可能抛错，不能让它阻断重新初始化）
      if (this.engine !== null) {
        try {
          this.engine.shutdown();
        } catch (err) {
          console.error('TTS 引擎释放异常：' + JSON.stringify(err));
        }
        this.engine = null;
      }

      // 应用配置
      if (config !== undefined) {
        if (config.language !== undefined) {
          this.voiceLanguage = config.language;
        }
      }

      // 构建引擎创建参数
      const engineParams: textToSpeech.CreateEngineParams = {
        language: this.voiceLanguage,
        person: this.voicePerson,
        online: 1, // 1=离线模式
      };

      try {
        textToSpeech.createEngine(engineParams, (err: Error, engine: textToSpeech.TextToSpeechEngine) => {
          if (err) {
            this.state = TtsState.ERROR;
            console.error('TTS 引擎创建失败：' + JSON.stringify(err));
            reject(err);
          } else {
            this.engine = engine;
            this.state = TtsState.IDLE;

            // === 设置永久监听器（不会被 speak() 替换） ===
            // 所有 speak/stop 事件都由这个监听器处理
            // 回调必须校验 requestId 归属：
            // stop() 会触发引擎异步抛出上一条请求的 onStop/onComplete，
            // 若不加校验，这些迟到事件会 resolve 掉"新"一次 speak() 的 Promise，
            // 使新播报被提前判定完成 → 喇叭图标与实际音频状态脱节。
            const listener: textToSpeech.SpeakListener = {
              onStart: (requestId: string, _response: object): void => {
                if (requestId !== this.currentRequestId) {
                  return;
                }
                console.info('TTS 开始播报');
                this.state = TtsState.SPEAKING;
              },
              onComplete: (requestId: string, _response: object): void => {
                if (requestId !== this.currentRequestId) {
                  return;
                }
                console.info('TTS 播报完成');
                this.state = TtsState.IDLE;
                this.onFinish?.();
                // 释放当前 speak() 的 Promise
                this.resolveCurrentSpeak();
              },
              onStop: (requestId: string, _response: object): void => {
                if (requestId !== this.currentRequestId) {
                  return;
                }
                console.info('TTS 已停止');
                this.state = TtsState.IDLE;
                // 停止时也释放 speak() 的 Promise
                this.resolveCurrentSpeak();
              },
              onError: (requestId: string, errorCode: number, errorMessage: string): void => {
                if (requestId !== this.currentRequestId) {
                  return;
                }
                console.error('TTS 播报错误：code=' + errorCode.toString() + ', msg=' + errorMessage);
                this.state = TtsState.ERROR;
                this.onError?.(errorCode.toString() + ': ' + errorMessage);
                this.rejectCurrentSpeak(new Error(errorMessage));
              },
            };
            this.engine?.setListener(listener);

            console.info('TTS 引擎初始化成功');
            resolve();
          }
        });
      } catch (error) {
        this.state = TtsState.ERROR;
        console.error('TTS 初始化异常：' + JSON.stringify(error));
        reject(error);
      }
    });
  }

  /**
   * 播报文本
   * @param text 要播报的文本
   * @returns Promise，播报完成时 resolve
   */
  speak(text: string): Promise<void> {
    // 如果有前一个播报未完成，先 resolve 它（此时旧播报已由 stop() 触发引擎停止）
    if (this.currentSpeakResolve) {
      this.currentSpeakResolve();
      this.currentSpeakResolve = null;
    }

    return new Promise<void>((resolve, reject) => {
      if (this.engine === null) {
        const errMsg: string = 'TTS 引擎未初始化，请先调用 init()';
        console.error(errMsg);
        reject(new Error(errMsg));
        return;
      }

      if (!text || text.trim().length === 0) {
        resolve();
        return;
      }

      try {
        this.currentRequestId = this.generateRequestId();

        const speakParams: textToSpeech.SpeakParams = {
          requestId: this.currentRequestId,
        };

        // 存储 resolve/reject，供永久监听器的 onComplete/onStop/onError 调用
        this.currentSpeakResolve = resolve;
        this.currentSpeakReject = reject;

        // 注意：不使用 setListener 替换监听器，永久监听器已在 init() 中设定
        // 直接调用 engine.speak()
        this.engine?.speak(text, speakParams);
      } catch (error) {
        this.currentSpeakResolve = null;
        this.currentSpeakReject = null;
        this.state = TtsState.ERROR;
        console.error('TTS 播报异常：' + JSON.stringify(error));
        reject(error);
      }
    });
  }

  /**
   * 停止播报
   */
  stop(): void {
    // 1. 先释放旧 Promise，让旧 autoSpeakRecommendations 立即退出
    this.resolveCurrentSpeak();
    // 2. 调用引擎停止（onStop 回调会在引擎内部触发，但即使不触发也无害）
    if (this.engine !== null) {
      try {
        this.engine?.stop();
      } catch (error) {
        console.error('TTS 停止异常：' + JSON.stringify(error));
      }
    }
    this.state = TtsState.IDLE;
  }

  /**
   * 释放 TTS 引擎资源
   */
  release(): void {
    if (this.engine !== null) {
      try {
        this.engine.shutdown();
      } catch (error) {
        console.error('TTS 释放异常：' + JSON.stringify(error));
      }
      this.engine = null;
      this.state = TtsState.UNINITIALIZED;
    }
  }

  /**
   * 获取当前状态
   */
  /**
   * 获取当前状态
   */
  getState(): TtsState {
    return this.state;
  }

  /**
   * 引擎是否就绪
   */
  isReady(): boolean {
    return this.engine !== null;
  }

  /**
   * 引擎是否在播报中
   */
  isBusy(): boolean {
    if (this.engine === null) {
      return false;
    }
    try {
      return this.engine.isBusy();
    } catch (_err) {
      return false;
    }
  }

  /** 释放当前 speak() 的 Promise（正常完成/停止时调用） */
  private resolveCurrentSpeak(): void {
    if (this.currentSpeakResolve) {
      this.currentSpeakResolve();
      this.currentSpeakResolve = null;
      this.currentSpeakReject = null;
    }
  }

  /** 强制拒绝当前 speak() 的 Promise（出错时调用） */
  private rejectCurrentSpeak(reason: Error): void {
    if (this.currentSpeakReject) {
      this.currentSpeakReject(reason);
      this.currentSpeakReject = null;
      this.currentSpeakResolve = null;
    }
  }
}

/**
 * 推荐结果语音播报工具
 * 将推荐菜品数据转为自然语言描述并播报
 */
export class RecommendSpeaker {
  private tts: TtsService;

  constructor() {
    this.tts = TtsService.getInstance();
  }

  /**
   * 播报推荐菜品概览
   * @param dishes 菜品数组
   * @param categoryName 分类名称
   */
  async speakRecommendations(dishes: DishOverview[], categoryName: string): Promise<void> {
    if (dishes.length === 0) {
      return;
    }

    let text: string = '';
    if (dishes.length === 1) {
      const d = dishes[0];
      text = `为你推荐${d.name}，${d.reason}。花费约${d.cost}，只需${d.time}。快去试试吧！`;
    } else {
      const names: string = dishes.map(d => d.name).join('、');
      const first: DishOverview = dishes[0];
      text = `为你推荐以下${categoryName}的美食：${names}。`;
      text += `首推${first.name}，${first.reason}。花费约${first.cost}，只需${first.time}。`;
      text += '快去试试吧！';
    }

    await this.speak(text);
  }

  /**
   * 播报单道菜品的详细信息
   * @param dish 菜品
   */
  async speakDishDetail(dish: DishDetail): Promise<void> {
    const text: string =
      `${dish.name}，${dish.reason}。` +
      `自己做花费约${dish.cost}，需要${dish.cookTime}。` +
      `点外卖约${dish.deliveryCost}元，配送约${dish.deliveryTime}。` +
      (dish.difficulty.length <= 2 ? `难度${dish.difficulty}。` : '');

    await this.speak(text);
  }

  /**
   * 播报决策引导语
   * @param text 引导文本
   */
  async speakGuide(text: string): Promise<void> {
    await this.speak(text);
  }

  /**
   * 停止播报
   */
  async stop(): Promise<void> {
    await this.tts.stop();
  }

  /**
   * 释放资源
   */
  release(): void {
    this.tts.release();
  }

  /**
   * 内部封装的播报方法，自动处理初始化
   */
  private async speak(text: string): Promise<void> {
    try {
      if (!this.tts.isReady()) {
        await this.tts.init();
      }
      await this.tts.speak(text);
    } catch (error) {
      console.error('语音播报失败：' + JSON.stringify(error));
    }
  }

  /**
   * 是否正在播报
   */
  isSpeaking(): boolean {
    return this.tts.getState() === TtsState.SPEAKING;
  }
}
