import { describe, it, expect } from '@ohos/hypium';
import { CloudAiService, CandidateDish, RerankItem } from '../../../main/ets/service/CloudAiService';
import { RecommendConditions } from '../../../main/ets/service/DishTypes';

/**
 * AiPipelineTest - 云端 AI 链路的关键逻辑测试
 *
 * 重点覆盖 validateRerank 这道"防止大模型幻觉与约束违反"的闸门。
 * 这些用例不依赖网络，可重复执行；联网效果另做人工评估。
 *
 * 注意：ArkTS 禁止无类型对象字面量，因此所有测试数据都先声明接口再构造。
 */

/** 测试用：模型返回的单条 item */
interface PayloadItem {
  name: string;
  score?: number;
  reason?: string;
}

/** 测试用：模型返回的整体结构 */
interface Payload {
  items: PayloadItem[];
}

function item(name: string, score: number, reason: string): PayloadItem {
  const it: PayloadItem = { name: name, score: score, reason: reason };
  return it;
}

function itemNoReason(name: string, score: number): PayloadItem {
  const it: PayloadItem = { name: name, score: score };
  return it;
}

function payloadOf(items: PayloadItem[]): Payload {
  const p: Payload = { items: items };
  return p;
}

/** 构造测试用的候选菜品 */
function buildCandidate(name: string, ingredients: string[]): CandidateDish {
  const c: CandidateDish = {
    name: name,
    icon: '🍽️',
    category: '家常清淡',
    cookTime: '15分钟',
    cookCost: 10,
    deliveryTime: '25分钟',
    deliveryCost: 20,
    requiredIngredients: ingredients,
    ownedCount: 0,
    localScore: 50
  };
  return c;
}

/** 构造测试用的用户条件 */
function buildConditions(diet: number[], dietLabels: string[]): RecommendConditions {
  const c: RecommendConditions = {
    category: 0,
    categoryName: '家常清淡',
    time: 1,
    timeLabel: '30分钟',
    budget: 1,
    budgetLabel: '20元以内',
    diet: diet,
    dietLabels: dietLabels,
    ingredients: ['鸡蛋'],
    hasNoIngredients: false
  };
  return c;
}

/** 无忌口条件 */
function noDiet(): RecommendConditions {
  const empty: number[] = [];
  const emptyLabels: string[] = [];
  return buildConditions(empty, emptyLabels);
}

/** 不吃辣条件 */
function noSpicyDiet(): RecommendConditions {
  const diet: number[] = [0];
  const labels: string[] = ['不吃辣'];
  return buildConditions(diet, labels);
}

/** 默认候选集合：三道合规菜 */
function defaultCandidates(): CandidateDish[] {
  const list: CandidateDish[] = [
    buildCandidate('番茄炒蛋', ['番茄', '鸡蛋']),
    buildCandidate('青椒土豆丝', ['青椒', '土豆']),
    buildCandidate('紫菜蛋花汤', ['紫菜', '鸡蛋'])
  ];
  return list;
}

export default function aiPipelineTest() {
  describe('AiPipelineTest', () => {

    /**
     * 幻觉防护：模型只能从候选集合里选。
     * 这是整个架构的核心假设——本地检索收敛出的候选是可信的，
     * 模型不得引入清单外的菜名（否则用户会看到菜品库里不存在的菜）。
     */
    it('应丢弃候选集合之外的菜名_防幻觉', 0, () => {
      const items: PayloadItem[] = [
        item('番茄炒蛋', 90, '家里食材齐了'),
        item('佛跳墙', 99, '顶级享受'),
        item('青椒土豆丝', 80, '快手家常')
      ];
      const result: RerankItem[] = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      // 佛跳墙 不在候选里，必须被剔除；剩下 2 条
      expect(result.length).assertEqual(2);
      for (let i = 0; i < result.length; i++) {
        const ok: boolean = result[i].name === '番茄炒蛋' || result[i].name === '青椒土豆丝';
        expect(ok).assertTrue();
      }
    });

    /**
     * 忌口是硬约束：即使模型返回了违规菜名，也必须被二次拦截。
     * 候选里混入辣菜以模拟"本地过滤失效"的极端情况。
     */
    it('应拒绝推荐违反忌口的菜品', 0, () => {
      const candidates: CandidateDish[] = [
        buildCandidate('番茄炒蛋', ['番茄', '鸡蛋']),
        buildCandidate('麻辣香锅', ['辣椒']),
        buildCandidate('水煮鱼', ['鱼'])
      ];
      const items: PayloadItem[] = [
        item('麻辣香锅', 95, '够味过瘾'),
        item('番茄炒蛋', 85, '清淡合适')
      ];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), candidates, noSpicyDiet());
      expect(result.length).assertEqual(1);
      expect(result[0].name).assertEqual('番茄炒蛋');
    });

    /** 结果数量上限为 3，模型多给的要截断 */
    it('结果数量应截断为3条', 0, () => {
      const candidates: CandidateDish[] = [
        buildCandidate('菜A', ['a']), buildCandidate('菜B', ['b']),
        buildCandidate('菜C', ['c']), buildCandidate('菜D', ['d']),
        buildCandidate('菜E', ['e'])
      ];
      const items: PayloadItem[] = [
        item('菜A', 90, 'ra'), item('菜B', 80, 'rb'), item('菜C', 70, 'rc'),
        item('菜D', 60, 'rd'), item('菜E', 50, 're')
      ];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), candidates, noDiet());
      expect(result.length).assertEqual(3);
    });

    /** 越界分数必须被夹到 0~100，防止 UI 出现"适合度 9999" */
    it('越界分数应被夹到0到100', 0, () => {
      const items: PayloadItem[] = [
        item('番茄炒蛋', 9999, '过高'),
        item('青椒土豆丝', -50, '过低')
      ];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      expect(result.length).assertEqual(2);
      // 结果按分数降序：9999 夹到 100 排在前，-50 夹到 0 排在后
      expect(result[0].score).assertEqual(100);
      expect(result[1].score).assertEqual(0);
    });

    /** 超长理由要截断，避免撑坏卡片布局 */
    it('超长推荐理由应被截断', 0, () => {
      const longReason: string = '这是一段特别特别长的推荐理由'.repeat(10);
      const items: PayloadItem[] = [item('番茄炒蛋', 90, longReason)];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
      expect(result[0].reason.length <= 40).assertTrue();
    });

    /** 理由缺失时用中性兜底句，不能出现空白理由 */
    it('理由为空时应填充兜底文案', 0, () => {
      const items: PayloadItem[] = [itemNoReason('番茄炒蛋', 90)];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
      expect(result[0].reason.length > 0).assertTrue();
    });

    /** 完全无法解析的返回必须判为无效，交由上层降级到本地推荐 */
    it('非JSON返回应判为无效结果', 0, () => {
      const result = CloudAiService.validateRerankForTest(
        '抱歉，我无法完成这个请求。', defaultCandidates(), noDiet());
      expect(result.length).assertEqual(0);
    });

    /** 重名菜只能出现一次 */
    it('重复菜名应只保留一条', 0, () => {
      const items: PayloadItem[] = [
        item('番茄炒蛋', 90, '第一次'),
        item('番茄炒蛋', 85, '第二次')
      ];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
    });

    /**
     * JSON 提取要能穿透 markdown 代码块与前后解释文字。
     * 这是真实模型最常见的两种"不听话"输出形态。
     */
    it('应能从markdown代码块中提取JSON', 0, () => {
      const text: string =
        '好的，以下是推荐结果：\n```json\n{"items":[{"name":"番茄炒蛋","score":90,"reason":"合适"}]}\n```\n希望你喜欢！';
      const extracted: string = CloudAiService.extractJsonForTest(text);
      expect(extracted.length > 0).assertTrue();
      const result = CloudAiService.validateRerankForTest(extracted, defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
    });

    /** 嵌套对象时括号配对不能提前截断 */
    it('应正确处理嵌套JSON对象', 0, () => {
      const text: string =
        '{"items":[{"name":"番茄炒蛋","score":90,"reason":"理由","meta":{"a":1}}]}';
      const extracted: string = CloudAiService.extractJsonForTest(text);
      const result = CloudAiService.validateRerankForTest(extracted, defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
    });

    /** 字符串里出现花括号不能干扰配对 */
    it('字符串内的花括号不应影响JSON提取', 0, () => {
      const items: PayloadItem[] = [item('番茄炒蛋', 90, '用{这个}做的')];
      const result = CloudAiService.validateRerankForTest(
        JSON.stringify(payloadOf(items)), defaultCandidates(), noDiet());
      expect(result.length).assertEqual(1);
    });
  });
}
