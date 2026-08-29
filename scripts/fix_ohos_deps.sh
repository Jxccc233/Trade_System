#!/usr/bin/env bash
# 重装 ohos 依赖（DevEco 清理 oh_modules 或依赖变化后执行）
# 用法：bash scripts/fix_ohos_deps.sh
set -e
cd "$(dirname "$0")/../ohos"

export TOOL_HOME="D:\\DevEco Studio"
export DEVECO_SDK_HOME="D:\\DevEco Studio\\sdk"
export NODE_HOME="D:\\DevEco Studio\\tools\\node"
export JAVA_HOME="D:\\DevEco Studio\\jbr"
export PATH="/d/DevEco Studio/tools/node:/d/DevEco Studio/jbr/bin:$PATH"

# 依赖映射由 hvigor 在上次构建时生成；若不存在，先跑一次 flutter build 让它生成
if [ ! -f .hvigor/dependencyMap/oh-package.json5 ]; then
  echo "dependencyMap 不存在，请先执行一次 flutter build hap --debug 再运行本脚本"
  exit 1
fi

ohpm i --all --target_path .hvigor/dependencyMap
echo "ohos 依赖已重装"
