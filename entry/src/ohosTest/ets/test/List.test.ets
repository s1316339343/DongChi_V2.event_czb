import abilityTest from './Ability.test';
import aiPipelineTest from './AiPipelineTest';

export default function testsuite() {
  abilityTest();
  // AI 链路关键逻辑（候选校验、幻觉防护、JSON 提取）
  aiPipelineTest();
}
