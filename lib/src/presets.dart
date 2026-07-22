// The shipped tunings: six states × two sizes, baked from the inkform
// mini-page tuning session. `count`/`size` are multipliers over the base
// fine profiles; `speed` multiplies the shared clock. Resolved once per
// (state, size) pair and cached - the render loop sees plain numbers.

import 'types.dart';
import 'engine/profiles.dart';

/// Maps a public [OrbState] to its internal mode key.
final Map<OrbState, String> stateToMode = {
  OrbState.working: 'orbits',
  OrbState.searching: 'globe',
  OrbState.solving: 'rubik',
  OrbState.listening: 'wave',
  OrbState.composing: 'ribbon',
  OrbState.shaping: 'morph',
};

/// The fully resolved configuration for a (state, size) pair.
class Resolved {
  Resolved({required this.mode, required this.speed, required this.opts});

  /// Internal mode key (e.g. 'orbits', 'globe').
  final String mode;

  /// Speed multiplier applied to the animation clock.
  final double speed;

  /// Fully-scaled draw options.
  final ModeOpts opts;
}

class _Preset {
  _Preset({
    required this.speed,
    required this.count,
    required this.size,
    this.extra,
  });
  final double speed;
  final double count;
  final double size;
  final ModeOpts? extra;
}

final Map<String, Map<OrbSize, _Preset>> _presets = {
  'orbits': {
    OrbSize.large: _Preset(speed: 1.885, count: 1, size: 1),
    OrbSize.small: _Preset(speed: 3.9, count: 0.238, size: 2.4),
  },
  'globe': {
    OrbSize.large:
        _Preset(speed: 2.015, count: 0.42, size: 1.15, extra: {'scanMul': 4.08, 'dimBase': 0.45}),
    OrbSize.small: _Preset(
        speed: 2.665, count: 0.105, size: 1.75, extra: {'scanMul': 4.335, 'dimBase': 0.45}),
  },
  'rubik': {
    OrbSize.large: _Preset(speed: 1.82, count: 0.35, size: 1.05),
    OrbSize.small: _Preset(speed: 1.95, count: 0.088, size: 1.9),
  },
  'wave': {
    OrbSize.large: _Preset(speed: 4.388, count: 0.341, size: 1),
    OrbSize.small: _Preset(speed: 3.998, count: 0.105, size: 1.6),
  },
  'ribbon': {
    OrbSize.large: _Preset(
        speed: 2.34, count: 0.25, size: 0.85, extra: {'spin': 0, 'bandMul': 3.9, 'wobMul': 1}),
    OrbSize.small: _Preset(
        speed: 3.12, count: 0.051, size: 1.073, extra: {'spin': 0, 'bandMul': 4.94, 'wobMul': 1}),
  },
  'morph': {
    OrbSize.large:
        _Preset(speed: 2.405, count: 0.54, size: 0.395, extra: {'spread': 1.45}),
    OrbSize.small:
        _Preset(speed: 2.08, count: 0.53, size: 1.011, extra: {'spread': 1.45}),
  },
};

final Map<String, Resolved> _cache = {};

/// Resolve a (state, size) pair to its mode + fully-scaled draw options.
Resolved resolvePreset(OrbState state, OrbSize size) {
  final key = '${state.name}-${size.name}';
  final hit = _cache[key];
  if (hit != null) return hit;

  final mode = stateToMode[state]!;
  final preset = _presets[mode]![size]!;
  var opts = Map<String, double>.from(baseProfiles[mode]!);
  if (preset.count != 1) opts = scaleCounts(opts, preset.count);
  if (preset.size != 1) opts = scaleRadii(opts, preset.size);
  if (preset.extra != null) opts.addAll(preset.extra!);

  final resolved = Resolved(mode: mode, speed: preset.speed, opts: opts);
  _cache[key] = resolved;
  return resolved;
}
