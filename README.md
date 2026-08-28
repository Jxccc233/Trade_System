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
`HOS_SDK_HOME`（指向 DevEco Studio 的 HarmonyOS SDK）。DevEco 未安装期间，
ohos 脚手架暂存在 `D:\Trade\ohos_scaffold_stash`，DevEco 装好后移回或执行：

```bash
flutter create --platforms ohos --project-name fupan_shouji --org com.fupan .
```

重新生成即可（脚手架是纯生成物）。ohos 构建还需要 DevEco Studio 5.0+（API 12）、
JDK 17，及环境变量 `TOOL_HOME` / `DEVECO_SDK_HOME`（hvigor、ohpm、node 均在其 tools/ 下）。

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

## 当前状态（M0 完成）

- [x] 5 Tab 导航骨架（今日/交易/持仓/复盘/统计）
- [x] 主题：Material 3、深浅色、A股红涨绿跌
- [x] drift 7 张表（标的/流水/复盘/价格/快照/标签/设置）+ 代码生成
- [x] 持仓计算引擎（移动加权平均，手续费入成本）+ 单元测试
- [x] 平台脚手架：android / ios / ohos（ohos 暂存，待 DevEco）
- [x] `flutter analyze` 零问题、`flutter test` 10/10 通过（鸿蒙版 SDK 上验证）
- [ ] 鸿蒙模拟器/真机跑通（等 DevEco Studio + JDK17 + 华为开发者账号）

## 已知风险

- `sqlite3_flutter_libs` 在鸿蒙端可能需要社区 ohos 适配版（等工具链就绪后验证；
  必要时用 dependency_overrides 指到 gitee 适配仓库，或数据层换成 sqflite ohos 版）。
- iOS 打包需要 macOS（云 Mac / CI），M3 阶段处理。
