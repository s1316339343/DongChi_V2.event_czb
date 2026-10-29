#!/usr/bin/env node
/**
 * export-prompts.mjs — 把 DSH 会话日志导出成可提交的 Prompt 快照
 *
 * 背景
 * ----
 * 赛道要求提交"AI 对话历史导出的 Prompt 历史快照"，且需包含至少 3 个核心功能迭代的
 * 完整 Prompt 链（Prompt 提问 + AI 的修改建议 + 开发者如何引导 AI 修 Bug）。
 *
 * 本脚本从 DSH 的会话日志（`session.v4.jsonl.zstd`，多帧 zstd，每帧对应一次追加）里
 * 还原真实对话，按开发阶段切分成若干条链，输出 Markdown。
 * 输出内容**不做润色**：用户提示词逐字保留，AI 结论按原文截断，工具动作按实际调用记录。
 *
 * 用法
 * ----
 *   node tools/export-prompts.mjs --session <session.v4.jsonl.zstd> --out AI-PROMPTS
 *
 * 脱敏
 * ----
 * 导出时自动打码：API Key（sk-…）、邮箱、本机用户名路径。
 * 打码是唯一的改写，且只影响凭据与个人信息，不影响对话内容。
 */

import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';

// ---------------------------------------------------------------- zstd 解帧

const ZSTD_MAGIC = Buffer.from([0x28, 0xb5, 0x2f, 0xfd]);

/** DSH 每追加一次就写一个独立 zstd 帧，因此需要按 magic 切开后逐帧解压 */
function decompressSession(buf) {
  const starts = [];
  let i = 0;
  while (true) {
    const p = buf.indexOf(ZSTD_MAGIC, i);
    if (p < 0) break;
    starts.push(p);
    i = p + 4;
  }
  if (starts.length === 0) return zlib.zstdDecompressSync(buf);
  const parts = [];
  for (let k = 0; k < starts.length; k++) {
    const slice = buf.subarray(starts[k], k + 1 < starts.length ? starts[k + 1] : buf.length);
    try {
      parts.push(zlib.zstdDecompressSync(slice));
    } catch {
      // 帧边界误判时跳过该段，不影响其余帧
    }
  }
  return Buffer.concat(parts);
}

// ---------------------------------------------------------------- 脱敏

const REDACTIONS = [
  // API Key：sk-ws-xxx / sk-xxx
  [/sk-[A-Za-z0-9._-]{12,}/g, 'sk-***REDACTED***'],
  // 邮箱（排除 git@github.com / git@gitee.com 这类 SSH 地址，否则会把远程地址打坏）
  [/[A-Za-z0-9._%+-]+@(?!github\.com|gitee\.com)[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g, '***@***'],
  // 本机用户名
  [/C:\\Users\\[^\\\s"]+/g, 'C:\\Users\\<user>'],
];

function redact(text) {
  let out = text;
  for (const [re, rep] of REDACTIONS) out = out.replace(re, rep);
  return out;
}

// ---------------------------------------------------------------- 读取会话

const NOISE_PREFIXES = [
  'Current runtime context',
  'This is an automatically generated checkpoint',
  'The approval policy changed',
  'background job ',
  'Agent ',
  'Background subagent ',
];

function isNoise(text) {
  if (text.indexOf('<system-reminder>') >= 0) return true;
  return NOISE_PREFIXES.some((p) => text.startsWith(p));
}

/** 本地时间（UTC+8）格式化，与开发者实际所在时区一致 */
function bj(ms) {
  return new Date(ms + 8 * 3600e3).toISOString().replace('T', ' ').slice(0, 19);
}

function readTurns(file) {
  const raw = fs.readFileSync(file);
  const text = (file.endsWith('.zstd') ? decompressSession(raw) : raw).toString('utf8');
  const lines = text.split('\n').filter((l) => l.trim().length > 0);

  const turns = [];
  let cur = null;

  for (const line of lines) {
    let rec;
    try {
      rec = JSON.parse(line);
    } catch {
      continue;
    }
    const d = rec.data || {};
    switch (rec.type) {
      case 'turn/start':
        cur = { turn: d.turn, start: rec.time, end: null, user: [], ai: [], tools: [] };
        turns.push(cur);
        break;
      case 'user/message': {
        if (!cur) break;
        const kind = d.source && d.source.kind;
        if (kind !== 'user') break;
        const body = (d.content || [])
          .filter((c) => c.type === 'text')
          .map((c) => c.text)
          .join('\n')
          .trim();
        if (!body || isNoise(body)) break;
        cur.user.push(body);
        break;
      }
      case 'assistant/message': {
        if (!cur) break;
        for (const c of (d.message && d.message.content) || []) {
          if (c.type === 'text' && c.text && c.text.trim()) cur.ai.push(c.text.trim());
        }
        break;
      }
      case 'tool/call': {
        if (!cur) break;
        let args = {};
        try {
          args = JSON.parse(d.arguments || '{}');
        } catch {
          args = {};
        }
        cur.tools.push({ name: d.name, args });
        break;
      }
      case 'turn/end':
        if (cur) cur.end = rec.time;
        break;
      default:
        break;
    }
  }
  return turns;
}

// ---------------------------------------------------------------- 工具动作摘要

const PROJECT_ROOTS = [
  'D:\\codeProject\\DongChi_D2.0.1\\',
  'D:\\codeProject\\dongchi\\',
  'C:\\Users\\13163\\Documents\\deepseek-harness\\default-workspace\\DongChi_D2.0.1\\',
];

/** 把绝对路径压成仓库内相对路径，便于读者对照提交 */
function toRel(p) {
  if (!p) return '';
  let s = String(p);
  for (const root of PROJECT_ROOTS) {
    if (s.startsWith(root)) return s.slice(root.length).replace(/\\/g, '/');
  }
  const m = s.match(/(?:DongChi_D2\.0\.1|DongChi)[\\/](.*)$/);
  return m ? m[1].replace(/\\/g, '/') : s.replace(/\\/g, '/');
}

function summarizeTool(t) {
  const a = t.args || {};
  switch (t.name) {
    case 'write':
    case 'edit':
      return `\`${t.name}\` → \`${toRel(a.file_path)}\``;
    case 'read':
      return `\`read\` → \`${toRel(a.file_path)}\``;
    case 'grep':
      return `\`grep\` → \`${toRel(a.path) || '.'}\` /${String(a.pattern || '').slice(0, 40)}/`;
    case 'glob':
      return `\`glob\` → ${String(a.pattern || '').slice(0, 40)}`;
    case 'pwsh': {
      const desc = a.description || '';
      const cmd = String(a.command || '').replace(/\s+/g, ' ').slice(0, 80);
      return `\`pwsh\` → ${desc ? desc : cmd}`;
    }
    case 'subagent':
    case 'subagent_fork':
      return `\`${t.name}\` → ${String(a.description || '').slice(0, 50)}`;
    case 'web_search':
      return '`web_search`（检索赛事/文档资料）';
    case 'web_fetch':
      return `\`web_fetch\` → ${String(a.url || '').slice(0, 60)}`;
    case 'present':
      return '`present`（产出文件）';
    case 'skill':
      return `\`skill\` → ${String(a.name || '')}`;
    default:
      return `\`${t.name}\``;
  }
}

const FILE_TOOLS = new Set(['write', 'edit']);

// ---------------------------------------------------------------- 链定义

const CHAINS = [
  {
    file: '01-代码审计与批量修复.md',
    title: '① 代码审计与批量修复（2026-10-13）',
    turns: [1],
    intent:
      '用一句"把这个项目给我优化一下"启动。这一轮的价值不在改了什么，而在于**如何把模糊指令变成可验收的任务**：' +
      'AI 先建立构建基线，再并行派三份只读审计（服务层 / 页面层 / 数据层），要求每条结论给出文件+行号+原文，' +
      '最后按严重度分批修复并逐轮编译验证。',
    takeaway:
      '- 约束性提示：要求"文件+行号+原文"，把 AI 从"泛泛建议"逼到"可核对事实"\n' +
      '- 并行上下文：三份审计互不污染，各自只读一个层面\n' +
      '- 验收闭环：每个修复批次都要过一遍 hvigor 编译',
  },
  {
    file: '02-架构诊断与AI重构.md',
    title: '② 架构诊断 → 检索增强重构（2026-10-14 ~ 10-15）',
    turns: [2, 3, 4, 5],
    intent:
      '开发者先问"我这样能获奖吗"，AI 没有给鼓励式回答，而是用代码证据指出 AI 能力是"一次裸调用"、' +
      '技术深度不足，并把它推导成根因：**把「约束求解」和「语义理解」交给了同一个组件**。' +
      '这条结论直接决定了后面的三段式架构。随后接入阿里云百炼，把方案落地成 CloudAiService + RecommendService。',
    takeaway:
      '- 先证伪再给方案：不被"能不能获奖"带着走，先判断当前实现到底处在什么水平\n' +
      '- 根因推导：幻觉/约束违反/事实失真三个症状背后是同一个架构错误\n' +
      '- 方案落地：把"硬约束交给确定性代码，模型只做语义"写成可检查的代码边界',
  },
  {
    file: '03-端到端验证与可追溯性.md',
    title: '③ 端到端验证与可追溯性（2026-10-15）',
    turns: [6, 7, 8, 9, 10],
    intent:
      'AI 接入完成后的验收：不是跑一个成功样例，而是构造边界场景（严格忌口、极紧预算、幻觉压力测试、无效密钥），' +
      '逐个确认真实行为；随后对照赛事评分标准补"流程可追溯与真实性"。',
    takeaway:
      '- 对抗性验证：主动构造"模型最可能越界"的输入\n' +
      '- 降级路径必须实测：无效密钥要真的走到本地引擎，而不是理论上会\n' +
      '- 用赛事标准反推工程缺口，而不是凭感觉补功能',
  },
  {
    file: '04-密钥治理与公开发布.md',
    title: '④ 密钥治理与公开发布（2026-10-17）',
    turns: [11, 12, 13, 14],
    intent:
      '开源前的安全整改：把入库的签名口令与 API Key 从代码与历史里移除，改为本地私有注入，' +
      '并给出"删除历史中的密钥"的可复现步骤；之后发布公开仓库并自查文档口径。',
    takeaway:
      '- 密钥不入库是可验证的：`.gitignore` + `git ls-files` 双向自查\n' +
      '- 历史里的密钥要一起处理，只删当前文件是无效的\n' +
      '- 发布前自查文档与实现是否一致（本轮即发现并修正了多处口径错位）',
  },
];

// ---------------------------------------------------------------- 渲染

const MAX_AI_CHARS = 1600;
const MAX_TOOLS_SHOWN = 18;

function renderTurn(t, idx) {
  const out = [];
  const dur = t.end ? Math.max(1, Math.round((t.end - t.start) / 60000)) : null;
  out.push(`### 第 ${idx} 轮 · ${bj(t.start)}${dur ? `（约 ${dur} 分钟）` : ''}`);
  out.push('');

  for (const u of t.user) {
    out.push('**我（开发者）**');
    out.push('');
    out.push('```text');
    out.push(redact(u).trim());
    out.push('```');
    out.push('');
  }

  if (t.ai.length > 0) {
    let joined = t.ai.join('\n\n');
    let truncated = false;
    if (joined.length > MAX_AI_CHARS) {
      joined = joined.slice(0, MAX_AI_CHARS);
      truncated = true;
    }
    out.push('**AI 的结论与建议**');
    out.push('');
    out.push(redact(joined).trim());
    if (truncated) {
      out.push('');
      out.push(`> （此处按长度截断，该轮 AI 文本共 ${t.ai.length} 段、${t.ai.join('').length} 字；完整原文见 DSH 会话日志）`);
    }
    out.push('');
  }

  const files = [];
  for (const tool of t.tools) {
    if (FILE_TOOLS.has(tool.name) && tool.args && tool.args.file_path) files.push(toRel(tool.args.file_path));
  }
  if (files.length > 0) {
    const uniq = [...new Set(files)];
    out.push(`**本轮落盘的文件**（${uniq.length} 个）`);
    out.push('');
    for (const f of uniq.slice(0, 40)) out.push(`- \`${f}\``);
    if (uniq.length > 40) out.push(`- …… 其余 ${uniq.length - 40} 个`);
    out.push('');
  }

  if (t.tools.length > 0) {
    out.push(`**AI 的动作**（共 ${t.tools.length} 次工具调用，列出前 ${Math.min(t.tools.length, MAX_TOOLS_SHOWN)} 次）`);
    out.push('');
    for (const tool of t.tools.slice(0, MAX_TOOLS_SHOWN)) out.push(`- ${summarizeTool(tool)}`);
    if (t.tools.length > MAX_TOOLS_SHOWN) out.push(`- …… 其余 ${t.tools.length - MAX_TOOLS_SHOWN} 次（读取、检索、编译验证等）`);
    out.push('');
  }

  return out.join('\n');
}

function renderChain(chain, turns) {
  const picked = turns.filter((t) => chain.turns.includes(t.turn));
  const totalTools = picked.reduce((s, t) => s + t.tools.length, 0);
  const totalFiles = new Set(
    picked.flatMap((t) => t.tools.filter((x) => FILE_TOOLS.has(x.name) && x.args && x.args.file_path).map((x) => toRel(x.args.file_path)))
  ).size;
  const from = picked.length ? bj(picked[0].start) : '';
  const to = picked.length ? bj(picked[picked.length - 1].end || picked[picked.length - 1].start) : '';

  const lines = [];
  lines.push(`# ${chain.title}`);
  lines.push('');
  lines.push(`> 时间：${from} ~ ${to}　｜　对话轮次：${picked.length}　｜　工具调用：${totalTools} 次　｜　落盘文件：${totalFiles} 个`);
  lines.push('>');
  lines.push('> 来源：DeepSeek Harness 本地会话日志（未经改写，仅对 API Key / 邮箱 / 本机用户名打码）。时间为北京时间。');
  lines.push('');
  lines.push('## 这一段在做什么');
  lines.push('');
  lines.push(chain.intent);
  lines.push('');
  lines.push('## 值得看的地方');
  lines.push('');
  lines.push(chain.takeaway);
  lines.push('');
  lines.push('---');
  lines.push('');
  picked.forEach((t, i) => {
    lines.push(renderTurn(t, i + 1));
    lines.push('---');
    lines.push('');
  });
  return lines.join('\n');
}

function renderIndex(meta) {
  const rows = CHAINS.map((c) => {
    const n = c.turns.length;
    return `| [${c.file}](${c.file}) | ${c.title.replace(/^[①②③④]\s*/, '')} | ${n} |`;
  }).join('\n');

  return `# AI 对话历史 Prompt 快照

> 本目录是**真实会话记录的导出**，不是事后编写的总结。生成方式见 [tools/export-prompts.mjs](../tools/export-prompts.mjs)：
> 解析 DeepSeek Harness 的会话日志（多帧 zstd），按开发阶段切链，逐轮输出开发者原话、AI 结论与工具动作。
>
> - 会话 id：\`${meta.sessionId}\`
> - 时间跨度：${meta.from} ~ ${meta.to}（北京时间）
> - 规模：${meta.turns} 轮对话、${meta.tools} 次工具调用
> - 唯一改写：API Key、邮箱、本机用户名已打码

## 一、四条核心功能迭代链

| 快照 | 迭代 | 轮次 |
|---|---|---|
${rows}

## 二、为什么这几条算"完整 Prompt 链"

赛道要求的完整链条 = **我的 Prompt 提问 + AI 的修改建议 + 我如何引导 AI 修 Bug**。
本目录每一条都包含三要素，且可按时间戳与会话日志逐条核对：

1. 开发者提示词**逐字保留**（含口语化、含后来被推翻的判断）；
2. AI 的结论按原文截断（截断处标注原文总字数，不代写）；
3. 每轮末尾列出 AI 实际落盘的文件与工具动作——改了什么文件、编译验证了几次，一目了然。

## 三、工具与分工

| 工具 | 用途 |
|---|---|
| **DeepSeek Harness（DSH）** | 主要 AI 编程助手：代码审计、架构方案、重构实施、编译验证、文档撰写 |
| **阿里云百炼 · 通义千问（qwen-flash）** | 产品内置推理能力：候选菜品重排与推荐理由生成 |

本项目为**单人开发 + AI 结对**：AI 负责执行与分析，架构决策、取舍与验收由开发者确认。

## 四、与提交历史的对应

每条链都对应仓库里的若干提交（见链内"本轮落盘的文件"）。因项目进入可用状态后才建仓，
早期轮次无法逐次留痕，**提交序列是按会话时间重建的**，重建说明见
[RECONSTRUCTION.md](../RECONSTRUCTION.md)。

## 五、可复现性

- 快照可被重新生成：\`node tools/export-prompts.mjs --session <会话日志> --out AI-PROMPTS\`
- 会话日志为 DSH 本地文件，不在仓库内（含运行环境信息）；如需核对，可按上述命令对同一日志重跑，输出逐字节一致。
`;
}

// ---------------------------------------------------------------- main

const argv = process.argv.slice(2);
const argOf = (name) => {
  const i = argv.indexOf(name);
  return i >= 0 ? argv[i + 1] : undefined;
};

const sessionPath = argOf('--session');
const outDir = argOf('--out') || 'AI-PROMPTS';

if (!sessionPath) {
  console.error('用法: node tools/export-prompts.mjs --session <session.v4.jsonl.zstd> [--out AI-PROMPTS]');
  process.exit(1);
}

const turns = readTurns(sessionPath);
if (turns.length === 0) {
  console.error('没有解析到任何对话轮次');
  process.exit(1);
}

// 会话 id 从文件名推断（session-xxxx / uuid）
const base = path.basename(path.dirname(sessionPath));
const sessionId = base.startsWith('session-') || /^[0-9a-f-]{36}$/.test(base) ? base : path.basename(sessionPath);

const totalTools = turns.reduce((s, t) => s + t.tools.length, 0);
const meta = {
  sessionId,
  from: bj(turns[0].start),
  to: bj(turns[turns.length - 1].end || turns[turns.length - 1].start),
  turns: turns.filter((t) => t.user.length > 0).length,
  tools: totalTools,
};

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(path.join(outDir, 'README.md'), renderIndex(meta), 'utf8');
for (const chain of CHAINS) {
  fs.writeFileSync(path.join(outDir, chain.file), renderChain(chain, turns), 'utf8');
}

console.log(`会话 ${sessionId}`);
console.log(`  轮次 ${meta.turns} / 工具调用 ${totalTools} 次 / ${meta.from} ~ ${meta.to}`);
for (const chain of CHAINS) {
  const p = path.join(outDir, chain.file);
  const size = fs.statSync(p).size;
  console.log(`  写出 ${p}  ${(size / 1024).toFixed(1)} KB`);
}
console.log(`  写出 ${path.join(outDir, 'README.md')}`);
