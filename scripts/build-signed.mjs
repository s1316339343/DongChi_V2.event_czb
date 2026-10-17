#!/usr/bin/env node
/**
 * build-signed.mjs —— 用本地私有签名配置构建已签名 HAP
 *
 * 背景
 * ----
 * HarmonyOS 的签名信息（口令、证书路径）官方约定写在 build-profile.json5 里，
 * 而该文件又必须入库（它同时承载模块结构与编译配置）。
 * 若把口令直接写在里面，仓库一旦公开即等于泄露签名凭据。
 *
 * 本脚本的做法
 * ------------
 *  1. 从 signing/signing-config.local.json（已 gitignore）读取签名信息
 *  2. 临时注入到 build-profile.json5
 *  3. 执行 hvigor 构建
 *  4. 无论成功失败都还原 build-profile.json5（finally + 上次残留检测）
 *
 * 这样仓库中的 build-profile.json5 始终保持无口令状态，
 * 而已签名包仍可通过一条命令产出。
 *
 * 用法
 * ----
 *   node scripts/build-signed.mjs                       # 默认 debug
 *   node scripts/build-signed.mjs --buildMode release   # 指定构建模式
 *   node scripts/build-signed.mjs --extra --stacktrace  # 透传额外参数给 hvigor
 *
 * 前置：已设置 DEVECO_SDK_HOME 与 JAVA_HOME，且 java 在 PATH 中。
 */

import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(__dirname, '..');

const PROFILE = path.join(projectRoot, 'build-profile.json5');
const SIGNING = path.join(projectRoot, 'signing', 'signing-config.local.json');
const BACKUP = path.join(projectRoot, '.build-profile.json5.signed.backup');

const REQUIRED_MATERIAL = ['storeFile', 'storePassword', 'keyAlias', 'keyPassword', 'profile', 'certpath'];
const REQUIRED_FILES = ['storeFile', 'profile', 'certpath'];

function fail(message) {
  console.error('\n[build-signed] 错误：' + message + '\n');
  process.exit(1);
}

function log(message) {
  console.log('[build-signed] ' + message);
}

// ---------- 1) 读取并校验本地签名配置 ----------
if (!fs.existsSync(SIGNING)) {
  fail(
    '未找到本地签名配置：' + SIGNING + '\n' +
    '  请执行：cp signing/signing-config.example.json signing/signing-config.local.json\n' +
    '  然后填入你自己的签名信息（该文件已被 .gitignore 忽略）。'
  );
}

let signing;
try {
  signing = JSON.parse(fs.readFileSync(SIGNING, 'utf8'));
} catch (e) {
  fail('签名配置不是合法 JSON：' + e.message);
}

// 去掉模板里的说明字段，避免被注入进 build-profile 造成未知字段告警
delete signing['_说明'];
delete signing['_安全'];

if (!signing.material) {
  fail('签名配置缺少 material 对象');
}
for (const key of REQUIRED_MATERIAL) {
  const value = signing.material[key];
  if (typeof value !== 'string' || value.trim() === '') {
    fail('签名配置缺少字段 material.' + key);
  }
}
for (const key of REQUIRED_FILES) {
  const filePath = signing.material[key];
  if (!fs.existsSync(filePath)) {
    fail('证书文件不存在：' + filePath + '（material.' + key + '）');
  }
}

// ---------- 2) 处理上次异常退出的残留 ----------
if (fs.existsSync(BACKUP)) {
  fs.copyFileSync(BACKUP, PROFILE);
  fs.unlinkSync(BACKUP);
  log('检测到上次中断残留的备份，已先还原 build-profile.json5');
}

const original = fs.readFileSync(PROFILE, 'utf8');

// ---------- 3) 注入：填充 signingConfigs 并让 product 引用它 ----------
function injectSigning(text) {
  let output = text;

  // 3.1 填充 signingConfigs 数组
  const signingBlock = JSON.stringify([signing], null, 2).replace(/\n/g, '\n    ');
  const anchorRe = /"signingConfigs":\s*\[\s*\]/;
  if (!anchorRe.test(output)) {
    fail('注入失败：build-profile.json5 中未找到 `"signingConfigs": []` 锚点');
  }
  output = output.replace(anchorRe, '"signingConfigs": ' + signingBlock);

  // 3.2 给 default product 补上 signingConfig 引用
  const productRe = /("name":\s*"default",)(\s*\n\s*"targetSdkVersion")/;
  if (!productRe.test(output)) {
    fail('注入失败：未找到 products 中 default 产品的锚点');
  }
  output = output.replace(productRe, '"signingConfig": "default",$1$2');

  return output;
}

let injected;
try {
  injected = injectSigning(original);
  fs.writeFileSync(BACKUP, original, 'utf8');
  fs.writeFileSync(PROFILE, injected, 'utf8');
  log('已临时注入签名配置（build-profile.json5 已备份，构建结束后还原）');
} catch (e) {
  // 注入过程中的失败也尝试还原，避免留下半成品
  try { fs.writeFileSync(PROFILE, original, 'utf8'); } catch (_) { /* ignore */ }
  fail('注入过程异常：' + (e && e.message ? e.message : String(e)));
}

// ---------- 4) 解析命令行参数并构建 ----------
const argv = process.argv.slice(2);
let buildMode = 'debug';
const passthrough = [];
for (let i = 0; i < argv.length; i++) {
  const arg = argv[i];
  if (arg === '--buildMode' || arg === '--build-mode') {
    buildMode = argv[i + 1] || buildMode;
    i++;
  } else if (arg === '--extra') {
    // 后续参数全部透传
    for (let j = i + 1; j < argv.length; j++) {
      passthrough.push(argv[j]);
    }
    break;
  } else {
    passthrough.push(arg);
  }
}

const hvigorBat = process.env.HVIGOR_BAT || 'hvigorw.bat';

// 解析 hvigorw 实际路径：优先 HVIGOR_BAT，其次 PATH 中的 hvigorw.bat
function resolveHvigor() {
  if (process.env.HVIGOR_BAT) {
    return fs.existsSync(process.env.HVIGOR_BAT) ? process.env.HVIGOR_BAT : '';
  }
  const which = spawnSync('where', ['hvigorw.bat'], { encoding: 'utf8' });
  if (which.status === 0) {
    const first = (which.stdout || '').split(/\r?\n/).find((line) => line.trim() !== '');
    if (first && fs.existsSync(first.trim())) {
      return first.trim();
    }
  }
  return '';
}

function quoteArg(value) {
  const text = String(value);
  return /\s/.test(text) ? '"' + text + '"' : text;
}

const resolvedHvigor = resolveHvigor();
if (!resolvedHvigor) {
  fs.writeFileSync(PROFILE, original, 'utf8');
  if (fs.existsSync(BACKUP)) { fs.unlinkSync(BACKUP); }
  fail(
    '未找到 hvigorw。请任选其一：\n' +
    '  1) 设置环境变量 HVIGOR_BAT=<DevEco Studio>/tools/hvigor/bin/hvigorw.bat\n' +
    '  2) 把上述目录加入 PATH'
  );
}

const args = [
  'assembleHap',
  '--mode', 'module',
  '-p', 'product=default',
  '-p', 'buildMode=' + buildMode,
  '--no-daemon'
].concat(passthrough);

log('执行：' + resolvedHvigor + ' ' + args.join(' '));

// ---------- 5) 构建并在结束时无条件还原 ----------
let exitCode = 1;
try {
  // 用带引号的命令串 + shell 调用，兼容含空格的安装路径（如 "DevEco Studio"）
  const commandLine = [quoteArg(resolvedHvigor)].concat(args.map(quoteArg)).join(' ');
  const result = spawnSync(commandLine, {
    cwd: projectRoot,
    stdio: 'inherit',
    shell: true
  });
  exitCode = result.status === null ? 1 : result.status;
} catch (e) {
  console.error('[build-signed] 构建进程异常：' + (e && e.message ? e.message : String(e)));
  exitCode = 1;
} finally {
  // 无论成功、失败还是异常，都必须把带口令的文件还原掉
  try {
    fs.writeFileSync(PROFILE, original, 'utf8');
    if (fs.existsSync(BACKUP)) {
      fs.unlinkSync(BACKUP);
    }
    log('已还原 build-profile.json5（工作区不含签名口令）');
  } catch (e) {
    console.error('[build-signed] 严重：还原 build-profile.json5 失败，请手动恢复：' + e.message);
  }
}

process.exit(exitCode);
