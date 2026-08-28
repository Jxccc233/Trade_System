# 复盘手记 (fupan_shouji)

本地优先的个人 A 股交易手账：随手记交易、自动算持仓、天天写复盘、长期看统计。
目标平台：**iOS + 鸿蒙 HarmonyOS NEXT**（安卓白送）。

需求文档见 `docs/需求分析.md`。

## 技术栈

| 项 | 选型 |
|---|---|
| 框架 | Flutter 3.27.5-ohos-1.0.7（CPF-Flutter GitCode 镜像，统一作为三端主 SDK） |
| 数据库 | drift (SQLite) |
| 状态管理 | flutter_riverpod |
| 图表 | fl_chart |

## 目录结构

```
lib/
├── main.dart                  # 入口（ProviderScope）
├── app.dart                   # MaterialApp + 主题
├── core/
│   ├── theme/                 # 主题与配色（A股红涨绿跌）
│   ├── utils/format.dart      # 金额/百分比格式化
│   └── widgets/               # 通用组件
├── shell/app_shell.dart       # 底部 5 Tab 导航
├── pages/                     # 今日 / 交易 / 持仓 / 复盘 / 统计
├── data/db/                   # drift 表定义 + 数据库
└── domain/                    # 领域逻辑（持仓计算引擎等）
```

## 开发环境

- **主 SDK（鸿蒙版）**：`D:\dev\flutter_ohos327`（GitCode `CPF-Flutter/flutter_flutter` tag `3.27.5-ohos-1.0.7`，Dart 3.6.2）
- 备用：官方 stable（仅出安卓/iOS 包时可选）

国内镜像（建议写入系统环境变量）：

```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### ⚠️ ohos 目录的坑

项目里只要存在 `ohos/` 目录，鸿蒙版 SDK 的**所有**命令（包括 test/analyze）都会检查
`HOS_SDK_HOME`（指向 DevEco Studio 的 HarmonyOS SDK）。环境变量已持久化（setx）：

```
TOOL_HOME = D:\DevEco Studio
DEVECO_SDK_HOME / HOS_SDK_HOME = D:\DevEco Studio\sdk
NODE_HOME = D:\DevEco Studio\tools\node
JAVA_HOME = D:\DevEco Studio\jbr        # Java 21，DevEco 自带
ohpmBin = D:\DevEco Studio\tools\ohpm\bin\ohpm.bat
PATH 追加：flutter_ohos327\bin、jbr\bin、tools\{ohpm,hvigor,node}\bin、
          sdk\default\openharmony\toolchains（含 hdc）
```

### 出 HAP 包

```bash
flutter build hap --debug
```

工具硬性要求签名。首次需在 DevEco Studio：
打开 `D:\Trade\app\ohos` → File → Project Structure → Signing Configs →
勾选 Automatically generate signature（需登录华为开发者账号）→ Apply。
之后命令行构建产出已签名 hap，可用 hdc 安装到真机。

### ⚠️ hvigor ohpm 钩子补丁（重要，DevEco 升级后需重打）

DevEco 5.x 的 hvigor 在**命令行**（非 IDE）构建时自动 ohpm install 存在
Windows 批处理递归爆栈问题（IDE 内正常）。已补丁
`D:\DevEco Studio\tools\hvigor\hvigor-ohos-plugin\src\plugin\hooks\ohpm-load-install.js`
（跳过 CLI 构建时的自动安装；原文件备份 .bak，补丁副本在 `scripts/patches/`）。
若 hap 构建再次报 `ohpm install failed`，用补丁副本覆盖即可。
若 ohos 依赖变化，手动在 `ohos/` 下执行 `ohpm install --all`。

另：脚手架生成的 build-profile.json5 中 `targetSdkVersion: "1"` 非法（新 hvigor 校验），
已改为 `"5.0.0(12)"`。本机 SDK 为 HarmonyOS 6.1.1（API 24）。

## 常用命令

```bash
# 代码生成（改了 drift 表之后必须跑）
dart run build_runner build --delete-conflicting-outputs

# 静态检查 + 测试
flutter analyze
flutter test

# 鸿蒙端（需 DevEco Studio + HarmonyOS SDK，工具链见 M0.5）
flutter build hap --debug   # 或在 DevEco Studio 中直接运行

# 安卓端（需 JDK + Android SDK）
flutter build apk --debug
```

## 当前状态（M0 + M0.5 + M1 完成）

- [x] 5 Tab 导航骨架（今日/交易/持仓/复盘/统计）
- [x] 主题：Material 3、深浅色、A股红涨绿跌
- [x] drift 7 张表 + 代码生成；`flutter analyze` 零问题、`flutter test` 18/18
- [x] 鸿蒙工具链打通：`flutter build hap` 全流水线出包，hvigor ohpm 钩子已修补
- [x] **M1 记账**：记一笔表单（代码补全/市场推断/买卖校验/情绪标签/理由）
- [x] **M1 流水**：按日分组、长按删除、今日页汇总（当日已实现盈亏/市值/浮动盈亏）
- [x] **M1 持仓**：自动计算摊薄成本与浮动盈亏（手动填价）、清仓自动归档已了结轮次
- [x] 响应式布局（窄屏单栏 / 宽屏双栏或限宽居中），Mate X7 折叠屏与 Mate 80 兼容
- [ ] 签名配置（用户在 DevEco 登录华为账号一键生成）→ 已签名 hap → Mate X7 真机
- [ ] M2：复盘日历/表单、每日快照、核心统计

## 目标设备

- 华为 Mate X7（折叠屏，HarmonyOS NEXT）：页面自 M1 起响应式（折叠窄屏单栏 / 展开宽屏双栏），折叠屏专项优化 M3
- 华为 Mate 80（直板机）需同样可用

## 已知风险

- `sqlite3_flutter_libs` 在鸿蒙端可能需要社区 ohos 适配版（等工具链就绪后验证；
  必要时用 dependency_overrides 指到 gitee 适配仓库，或数据层换成 sqflite ohos 版）。
- iOS 打包需要 macOS（云 Mac / CI），M3 阶段处理。
