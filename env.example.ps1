# ============================================================================
# 懂吃 DongChi · 环境变量模板（PowerShell）
#
# 用法：
#   1. 复制本文件为 env.local.ps1（该文件已被 .gitignore 忽略，不会入库）
#   2. 把下面四个路径改成本机 DevEco Studio 的实际位置
#   3. 在项目根目录执行：  . .\env.local.ps1
#   4. 然后即可编译：      node scripts/build-signed.mjs  或直接调用 hvigorw
#
# 只填路径，不要在这里写任何 API Key / 签名口令。
# AI 密钥应放在 entry/src/main/resources/rawfile/ai-config.local.json（同样已 gitignore），
# 或在 App 内「我的 → AI 能力设置」里填写。
# ============================================================================

# DevEco Studio 安装根目录（下面四项都基于它，改这一行通常就够了）
$DevEcoRoot = "C:\Program Files\Huawei\DevEco Studio"

$env:DEVECO_SDK_HOME = "$DevEcoRoot\sdk"
$env:JAVA_HOME       = "$DevEcoRoot\jbr"
$env:NODE_HOME       = "$DevEcoRoot\tools\node"
$env:HVIGOR_BAT      = "$DevEcoRoot\tools\hvigor\bin\hvigorw.bat"

# hvigor 打包过程会调用 java，必须把 JBR 的 bin 放进 PATH
$env:PATH = "$env:JAVA_HOME\bin;$env:NODE_HOME;$env:PATH"

Write-Host "环境变量已设置：" -ForegroundColor Green
Write-Host "  DEVECO_SDK_HOME = $env:DEVECO_SDK_HOME"
Write-Host "  JAVA_HOME       = $env:JAVA_HOME"
Write-Host "  HVIGOR_BAT      = $env:HVIGOR_BAT"

# 自检：三个关键路径是否真的存在（缺哪个会直接决定编译能不能过）
foreach ($p in @($env:DEVECO_SDK_HOME, $env:JAVA_HOME, $env:HVIGOR_BAT)) {
  if (-not (Test-Path $p)) {
    Write-Host "  [警告] 路径不存在：$p" -ForegroundColor Yellow
  }
}
