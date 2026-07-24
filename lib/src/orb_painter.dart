// The CustomPainter that draws a single ThinkingOrb frame. It reads the
// accumulated animation time from a [ValueNotifier] and delegates to the
// engine's mode-specific draw function.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'engine/registry.dart';
import 'presets.dart';
import 'types.dart';

/// The [CustomPainter] that draws a single ThinkingOrb frame.
///
/// Reads the accumulated animation time from a [ValueNotifier] and delegates
/// to the engine's mode-specific draw function. Used internally by
/// [ThinkingOrb]; exposed for advanced composition where you drive your own
/// [CustomPaint] with a pre-resolved [Resolved] preset.
class OrbPainter extends CustomPainter {
  OrbPainter({
    required Listenable repaint,
    required this.state,
    required this.size,
    required this.dark,
    required this.time,
    required this.speed,
    required this.label,
  })  : _resolved = resolvePreset(state, size),
        super(repaint: repaint);

  final OrbState state;
  final OrbSize size;
  final bool dark;
  final double time;
  final double speed;
  final String label;

  final Resolved _resolved;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final draw = modeDraws[_resolved.mode]!;
    final t = time * speed;
    draw(canvas, size.pixels, t, dark, _resolved.opts);
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.dark != dark ||
        oldDelegate.state != state ||
        oldDelegate.size != size ||
        oldDelegate.speed != speed;
  }

  /// Accessibility semantics label for this painter.
  String? get semanticsLabel => label;
}
