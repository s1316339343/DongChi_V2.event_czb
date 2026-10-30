@echo off
REM ==========================================================================
REM 懂吃 DongChi · 环境变量模板（cmd / 批处理）
REM
REM 用法：
REM   1. 复制本文件为 env.local.bat（该文件已被 .gitignore 忽略，不会入库）
REM   2. 把 DevEcoRoot 改成本机 DevEco Studio 的实际位置
REM   3. 先执行 env.local.bat，再执行编译命令（同一窗口内有效）
REM
REM 只填路径，不要在这里写任何 API Key / 签名口令。
REM ==========================================================================

set "DevEcoRoot=C:\Program Files\Huawei\DevEco Studio"

set "DEVECO_SDK_HOME=%DevEcoRoot%\sdk"
set "JAVA_HOME=%DevEcoRoot%\jbr"
set "NODE_HOME=%DevEcoRoot%\tools\node"
set "HVIGOR_BAT=%DevEcoRoot%\tools\hvigor\bin\hvigorw.bat"

REM hvigor 打包过程会调用 java，必须把 JBR 的 bin 放进 PATH
set "PATH=%JAVA_HOME%\bin;%NODE_HOME%;%PATH%"

echo 环境变量已设置：
echo   DEVECO_SDK_HOME=%DEVECO_SDK_HOME%
echo   JAVA_HOME=%JAVA_HOME%
echo   HVIGOR_BAT=%HVIGOR_BAT%
