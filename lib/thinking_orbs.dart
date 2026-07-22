/// Thinking Orbs - dotted thought-orb loading indicators for AI & agent
/// UIs. Six tuned states, two sizes, auto dark/light.
///
/// Quick start:
/// ```dart
/// import 'package:thinking_orbs/thinking_orbs.dart';
///
/// ThinkingOrb(state: OrbState.searching, size: OrbSize.large)
/// ```
library;

export 'src/engine/profiles.dart' show ModeOpts;
export 'src/engine/registry.dart' show modeDraws;
export 'src/orb_painter.dart' show OrbPainter;
export 'src/presets.dart' show Resolved, stateToMode, resolvePreset;
export 'src/thinking_orb.dart' show ThinkingOrb;
export 'src/types.dart' show OrbState, OrbSize, OrbTheme;
