# 复盘手记 (fupan_shouji)

本地优先的个人 A 股交易手账：随手记交易、自动算持仓、天天写复盘、长期看统计。
目标平台：**iOS + 鸿蒙 HarmonyOS NEXT**（安卓白送）。

需求文档见 `../docs/需求分析.md`。

## 技术栈

| 项 | 选型 |
|---|---|
| 框架 | Flutter 3.22.1-ohos（openharmony-sig 官方移植版，统一作为三端主 SDK） |
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

两套 SDK（项目代码同一份）：

- **鸿蒙版（主 SDK）**：`D:\dev\flutter_ohos`（gitee openharmony-sig/flutter_flutter，分支 3.22.1-ohos-0.1.0）
- **官方版（备用）**：`D:\dev\flutter`（3.47.2，仅参考/工具用）

国内镜像（建议写入系统环境变量）：

```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

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

## 当前状态（M0）

- [x] 5 Tab 导航骨架（今日/交易/持仓/复盘/统计）
- [x] 主题：Material 3、深浅色、A股红涨绿跌
- [x] drift 7 张表（标的最优证券/流水/复盘/价格/快照/标签/设置）
- [x] 持仓计算引擎（移动加权平均，手续费入成本）+ 单元测试
- [ ] flutter analyze / test 全绿（等 SDK 就绪）
- [ ] 鸿蒙模拟器跑通（等 DevEco Studio + 华为开发者账号）

## 已知风险

- `sqlite3_flutter_libs` 在鸿蒙端可能需要社区 ohos 适配版（等工具链就绪后验证；
  必要时用 dependency_overrides 指到 gitee 适配仓库，或数据层换成 sqflite ohos 版）。
- iOS 打包需要 macOS（云 Mac / CI），M3 阶段处理。
