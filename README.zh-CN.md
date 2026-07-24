# thinking-orbs（思考球）

专为 AI 和 Agent 界面设计的点阵动画加载指示器。六种精调动画状态、两种预设尺寸，全部使用 Flutter 原生 `Canvas` 渲染——不依赖 WebGL、无滤镜，在 iOS、Android、macOS、Web 等平台效果完全一致。

本项目是 [thinking-orbs](https://github.com/Jakubantalik/thinking-orbs)（React + Canvas 2D 版）的 Flutter 移植，忠实还原了原版引擎的几何算法、深度着色和每个状态的调参细节。

[✨ 在线演示](https://litao-leven.github.io/thinking-orbs-flutter/) - 六种状态、两种尺寸，浏览器中直接体验。（[原版 JS](https://orbs.jakubantalik.com)）

<p align="center">
  <img src="assets/demo/demo-large-dark.gif" alt="thinking-orbs Flutter 演示 — 六种 64px 状态" width="500">
</p>

[English](../README.md) | 简体中文

## 安装

添加到 `pubspec.yaml`：

```yaml
dependencies:
  thinking_orbs_flutter: ^1.0.0
```

或通过 git 安装：

```yaml
dependencies:
  thinking_orbs_flutter: ^1.0.0
```

## 快速开始

```dart
import 'package:thinking_orbs_flutter/thinking_orbs.dart';

class Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThinkingOrb(state: OrbState.searching, size: OrbSize.large);
  }
}
```

## 状态

六种 Agent 可能执行的动作，每种对应一种独特动画：

```dart
ThinkingOrb(state: OrbState.working)     // 粒子在倾斜轨道上旋转
ThinkingOrb(state: OrbState.searching)   // 扫描经线扫过点阵球体
ThinkingOrb(state: OrbState.solving)     // 带状打乱后重新归位
ThinkingOrb(state: OrbState.listening)   // 波形在圆环中滚动
ThinkingOrb(state: OrbState.composing)   // 起伏的多波段饰带
ThinkingOrb(state: OrbState.shaping)     // 点阵轮廓：圆形→三角形→正方形
```

## 尺寸

两种独立调优的预设——不是简单缩放。`OrbSize.large`（64px）适合聊天头像级别的展示；`OrbSize.small`（20px）适合行内文本旁的小指示器。每种尺寸都有独立的点数、点大小和速度调参：

```dart
ThinkingOrb(state: OrbState.working, size: OrbSize.large)  // 大尺寸
ThinkingOrb(state: OrbState.working, size: OrbSize.small)  // 小尺寸
```

## 主题

严格黑白配色——深色背景用亮色点，浅色背景用暗色点。默认自动从当前 `ThemeData` 中读取亮度：

```dart
ThinkingOrb(theme: OrbTheme.auto)   // 默认：自动检测 ThemeData.brightness
ThinkingOrb(theme: OrbTheme.dark)   // 固定：深色背景用亮色点
ThinkingOrb(theme: OrbTheme.light)  // 固定：浅色背景用暗色点
```

`auto` 模式会实时响应主题切换（例如应用运行中切换明暗模式）。

## 其他属性

```dart
ThinkingOrb(
  state: OrbState.solving,
  size: OrbSize.small,
  speed: 1.5,                 // 预设速度的倍率
  paused: false,              // 冻结在当前帧
  semanticsLabel: '正在分析代码库…',  // 覆盖默认无障碍标签
)
```

## 无障碍与性能

- 默认内置 `Semantics(image: true)`，每个状态都有合理的默认标签（如「正在搜索…」「正在处理…」）。
- 系统开启「减弱动画」时，渲染一帧有代表性的静态画面——完全不动，但仍会响应主题变化。
- 所有实例会在应用退到后台时自动暂停（通过 `WidgetsBindingObserver` / `AppLifecycleState`），也可通过 `paused` 手动控制。恢复时使用累计 ticker 时间，保证相位同步。
- 仅使用 `Canvas.drawCircle`：无滤镜、无着色器、无离屏图层——所有平台像素一致，低性能设备也很轻量。每一帧内所有圆点复用同一个 `Paint` 对象，最小化内存分配。

## 高级 API

如果你需要在 widget 之外自行绘制到 Canvas：

```dart
import 'package:thinking_orbs_flutter/thinking_orbs.dart';

final resolved = resolvePreset(OrbState.searching, OrbSize.large);
final draw = modeDraws[resolved.mode]!;

// 在你的 CustomPainter.paint() 中：
draw(canvas, 64, elapsedTime * resolved.speed, isDark, resolved.opts);
```

| 导出 | 说明 |
|---|---|
| `ThinkingOrb` | 主 Widget |
| `OrbState` | 六种状态的枚举 |
| `OrbSize` | 两种尺寸枚举（`large` 64px / `small` 20px） |
| `OrbTheme` | 主题枚举（`auto` 自动 / `dark` 暗色 / `light` 亮色） |
| `OrbPainter` | `CustomPainter`（用于高级组合场景） |
| `resolvePreset(state, size)` | 解析 (状态, 尺寸) 得到内部模式、速度、缩放后参数 |
| `stateToMode` | 映射 `OrbState` → 内部模式键 |
| `modeDraws` | 映射模式键 → 帧绘制函数 |

## 运行演示

运行内置 demo app，可查看六种状态×两种尺寸，并支持主题、暂停、速度实时调节：

```bash
flutter run
```

## 许可证

MIT © Jakub Antalik（原版库）。Flutter 移植版使用相同许可证。
