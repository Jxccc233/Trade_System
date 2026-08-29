#!/usr/bin/env bash
# 编译 sqlite3 动态库（ohos x86_64 + arm64）并放进 entry/libs
# 用法：bash scripts/build_sqlite_so.sh <sqlite-amalgamation 目录>
set -e
SRC="${1:?用法: build_sqlite_so.sh <sqlite-amalgamation-目录>}"
CLANG="/d/DevEco Studio/sdk/default/openharmony/native/llvm/bin/clang.exe"
OUT="$(cd "$(dirname "$0")/.." && pwd)/ohos/entry/libs"

build() {
  local target=$1 abi=$2
  mkdir -p "$OUT/$abi"
  "$CLANG" --target=$target -shared -fPIC -O2 \
    -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_RTREE \
    -DSQLITE_THREADSAFE=2 \
    "$SRC/sqlite3.c" -o "$OUT/$abi/libsqlite3.so"
  echo "built $OUT/$abi/libsqlite3.so"
}

build x86_64-linux-ohos x86_64
build aarch64-linux-ohos arm64-v8a
