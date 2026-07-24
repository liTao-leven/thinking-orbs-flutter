# AGENTS.md - thinking-orbs-flutter

> 面向 AI coding agent 的项目协作约定。人类开发者也可参考。

## 项目概览

**thinking-orbs-flutter** 是 [thinking-orbs](https://github.com/Jakubantalik/thinking-orbs)（React + Canvas 2D）的 Flutter 移植版。提供 6 种点阵动画加载指示器（thought-orb），用于 AI / Agent 界面。

- **pub.dev 包名**: `thinking_orbs_flutter`
- **GitHub**: https://github.com/liTao-leven/thinking-orbs-flutter
- **许可证**: MIT
- **平台**: iOS / Android / macOS / Web / Windows / Linux（纯 Canvas，全平台一致）

## 技术栈与工具链

| 项 | 值 |
|---|---|
| Flutter | 3.44.0（stable） |
| Dart SDK | ^3.12.0 |
| 状态管理 | 无（纯无状态 widget + Ticker） |
| 渲染 | `Canvas.drawCircle` only — 无 filters / shaders / offscreen layers |
| Lint | `flutter_lints` ^6.0.0 |

所有 Flutter 命令通过 `fvm` 前缀执行（本机已配置），或直接用 `flutter`（已指向 fvm default）。

## 代码结构

```
lib/
├── thinking_orbs.dart          # 公共 API barrel export
├── main.dart                   # 开发用 demo app（不随包发布）
└── src/
    ├── thinking_orb.dart       # ThinkingOrb widget（核心入口）
    ├── orb_painter.dart        # OrbPainter (CustomPainter)
    ├── presets.dart            # 6 状态 × 2 尺寸 的调参 + resolvePreset()
    ├── types.dart              # 公共枚举: OrbState / OrbSize / OrbTheme
    └── engine/
        ├── types.dart           # 引擎层类型: Dot / Projector / ModeDraw
        ├── core.dart            # 共享原语: hashD / fibDir / makeProj / paintDots
        ├── profiles.dart        # 密度 profiles + scaleCounts/scaleRadii
        ├── registry.dart        # modeDraws: mode key -> draw function
        ├── orbits.dart          # working 状态: 倾斜轨道粒子
        ├── lattice.dart         # searching / solving / listening 状态
        ├── ribbon.dart          # composing 状态: 起伏饰带
        └── morph.dart           # shaping 状态: 圆形->三角->方形
```

### 状态映射

| OrbState | 内部 mode | 引擎文件 | 动画描述 |
|---|---|---|---|
| `working` | `orbits` | orbits.dart | 粒子在倾斜轨道上旋转 |
| `searching` | `globe` | lattice.dart | 扫描经线扫过点阵球体 |
| `solving` | `rubik` | lattice.dart | 带状打乱后重新归位 |
| `listening` | `wave` | lattice.dart | 波形在圆环中滚动 |
| `composing` | `ribbon` | ribbon.dart | 起伏的多波段饰带 |
| `shaping` | `morph` | morph.dart | 点阵轮廓变形循环 |

## 开发约定

### 代码风格

- 遵循 `flutter_lints`，**0 analysis issues** 是发布硬性要求
- `for` 循环体必须用 `{}` 包裹（pub.dev 静态分析扣分项）
- 单引号字符串
- 公共 API 必须有 `///` dartdoc 注释
- 引擎层私有类型用 `_` 前缀

### 渲染约束（重要）

> 这个包的核心卖点就是「所有平台像素一致」。**绝对不要引入** filters、shaders、offscreen layers 或平台特有渲染路径。只用 `Canvas.drawCircle`。

### 测试

```bash
flutter test
```

测试文件 `test/widget_test.dart` 覆盖：
- 单个 ThinkingOrb 无错误渲染
- 全部 6 个 OrbState 渲染
- 两种 OrbSize 渲染
- 每个 (state, size) 预设可正确解析

### 静态分析（发布前必做）

```bash
flutter analyze
```

必须 0 issues 才能发布。pub.dev 静态分析占 50 分。

## 发布流程

### 1. 预检

```bash
flutter pub publish --dry-run
```

确认 `Package has 0 warnings`。

### 2. 版本号

- 遵循 [semantic versioning](https://semver.org)
- 改 `pubspec.yaml` 的 `version` 字段
- 在 `CHANGELOG.md` 顶部新增版本条目

### 3. 发布

```bash
flutter pub publish
```

输入 `y` 确认。发布不可撤销。

### 4. 提交 & 推送

```bash
git add -A
git commit -m "chore: 发布 vX.Y.Z"
git push origin main
```

## pub.dev 评分要点

| 类别 | 满分 | 关键项 |
|---|---|---|
| 文件规范 | 30 | pubspec / README / CHANGELOG / LICENSE 齐全 |
| 文档 | 20 | API 注释覆盖 + **example/ 目录** |
| 平台支持 | 20 | 全平台（已满分） |
| 静态分析 | 50 | `flutter analyze` 0 issues |
| 依赖 | 40 | 最新版本兼容（已满分） |

## 已知的历史包

- `sunnyli_thinking_orbs` — 早期误发布的包名，已标记 DEPRECATED，指向 `thinking_orbs_flutter`。不可删除。
