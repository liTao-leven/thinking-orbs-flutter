// Density profiles + the multiplier machinery that scales them. The base
// rows are inkform's `fine` profiles; each shipped preset (state × size)
// applies count / radius multipliers on top, resolved once per mount.

import 'dart:math' as math;

/// Open bag of optional numbers that parameterize a mode's draw function.
typedef ModeOpts = Map<String, double>;

// 2-D lattices (rings × dots-per-ring) come in pairs - each side takes
// √scale so the TOTAL dot count scales by `scale`; flat lists scale
// linearly. `iconD` sets the morph outline's sampling density.
const List<List<String>> _countPairs = [
  ['latRings', 'lonDensity'],
  ['rings', 'lonDensity'],
  ['lanes', 'segs'],
];
const List<String> _countKeys = ['orbitN', 'ghostN'];
const List<String> _iconDensityKeys = ['iconD'];

// Every key that sets a dot's rendered radius - scaling all of them keeps
// a dot's near/far falloff intact while shrinking or growing the mark.
const List<String> _radiusKeys = [
  'rBase',
  'rDepth',
  'rActive',
  'rDot',
  'ghostR',
  'partR',
  'partRDepth',
];

/// Scale dot-count keys: paired dimensions take √scale, flat lists scale
/// linearly.
ModeOpts scaleCounts(ModeOpts opts, double scale) {
  final out = Map<String, double>.from(opts);
  final done = <String>{};
  final rt = math.sqrt(scale);

  for (final pair in _countPairs) {
    final a = pair[0];
    final b = pair[1];
    final va = out[a];
    final vb = out[b];
    if (va != null && vb != null && !done.contains(a) && !done.contains(b)) {
      out[a] = (va * rt).roundToDouble().clamp(2, double.infinity);
      out[b] = (vb * rt).roundToDouble().clamp(2, double.infinity);
      done.add(a);
      done.add(b);
    }
  }
  for (final k in _countKeys) {
    final v = out[k];
    if (v != null && !done.contains(k)) {
      out[k] = (v * scale).round().clamp(1, double.infinity).toDouble();
    }
  }
  for (final k in _iconDensityKeys) {
    final v = out[k];
    if (v != null) {
      out[k] = (v * scale).clamp(0.02, double.infinity);
    }
  }
  return out;
}

/// Scale all radius keys (preserves near/far falloff) and remember the
/// multiplier in `rSizeMul`.
ModeOpts scaleRadii(ModeOpts opts, double scale) {
  final out = Map<String, double>.from(opts);
  for (final k in _radiusKeys) {
    final v = out[k];
    if (v != null) out[k] = v * scale;
  }
  out['rSizeMul'] = (out['rSizeMul'] ?? 1.0) * scale;
  return out;
}

/// Base (fine) profiles per mode, before preset multipliers.
final Map<String, ModeOpts> baseProfiles = {
  'globe': {
    'latRings': 17,
    'lonDensity': 44,
    'rBase': 0.6,
    'rDepth': 1.7,
    'rBoost': 1.0,
    'inkFar': 0.62,
    'inkSpan': 0.54,
    'rsPow': 0.6,
    'rMin': 0.3,
  },
  'orbits': {
    'orbitN': 12,
    'ghostN': 40,
    'ghostR': 0.9,
    'ghostA': 0.5,
    'particles': 3,
    'partR': 1.2,
    'partRDepth': 1.6,
    'rsPow': 0.6,
    'rMin': 0.3,
  },
  'rubik': {
    'latRings': 15,
    'lonDensity': 40,
    'moveCount': 14,
    'rBase': 0.6,
    'rDepth': 1.7,
    'rActive': 0.3,
    'inkFar': 0.62,
    'inkSpan': 0.54,
    'rsPow': 0.6,
    'rMin': 0.3,
  },
  'wave': {
    'rings': 15,
    'lonDensity': 40,
    'rBase': 0.6,
    'rDepth': 1.7,
    'rsPow': 0.6,
    'rMin': 0.3,
  },
  'ribbon': {
    'lanes': 5,
    'segs': 88,
    'ghostN': 150,
    'rBase': 1.1,
    'rDepth': 1.7,
    'rsPow': 0.6,
    'rMin': 0.3,
  },
  'morph': {
    'rDot': 0.021,
    'iconD': 1,
    'rMin': 0.25,
  },
};
