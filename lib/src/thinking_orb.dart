// The ThinkingOrb widget. A single [Ticker] drives the animation; each
// instance pauses automatically when the app goes to the background
// (via [WidgetsBindingObserver]) and when [paused] is true. Reduced-motion
// users get a static representative frame that still follows the live
// theme.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'engine/registry.dart';
import 'orb_painter.dart';
import 'presets.dart';
import 'types.dart';

/// Default accessibility labels per state.
const Map<OrbState, String> _defaultLabels = {
  OrbState.working: 'Working…',
  OrbState.searching: 'Searching…',
  OrbState.solving: 'Solving…',
  OrbState.listening: 'Listening…',
  OrbState.composing: 'Composing…',
  OrbState.shaping: 'Shaping…',
};

/// A dotted "thought-orb" loading indicator for AI & agent UIs.
///
/// Renders one of six hand-tuned animations on a transparent canvas. The
/// widget handles animation ticking, lifecycle pausing, theme resolution,
/// and accessibility automatically.
class ThinkingOrb extends StatefulWidget {
  const ThinkingOrb({
    super.key,
    this.state = OrbState.working,
    this.size = OrbSize.large,
    this.theme = OrbTheme.auto,
    this.speed = 1,
    this.paused = false,
    this.semanticsLabel,
  });

  /// Which animation to show.
  final OrbState state;

  /// Tuned size preset - [OrbSize.large] (64px) or [OrbSize.small] (20px).
  final OrbSize size;

  /// Theme mode; [OrbTheme.auto] detects from the ambient [ThemeData].
  final OrbTheme theme;

  /// Animation speed multiplier on top of the preset's baked speed.
  final double speed;

  /// Freeze the animation on the current frame.
  final bool paused;

  /// Override the auto-generated accessibility label.
  final String? semanticsLabel;

  @override
  State<ThinkingOrb> createState() => _ThinkingOrbState();
}

class _ThinkingOrbState extends State<ThinkingOrb>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker;
  final ValueNotifier<double> _timeNotifier = ValueNotifier<double>(0);

  /// Accumulated animation time in seconds (scaled by preset speed later).
  double _accumulated = 0;
  Duration _lastElapsed = Duration.zero;
  bool _tickerActive = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addObserver(this);
    // Paint at least one static frame before the first tick.
    if (!widget.paused) _maybeStartTicker();
  }

  @override
  void didUpdateWidget(covariant ThinkingOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paused != widget.paused) {
      if (widget.paused) {
        _stopTicker();
      } else {
        _maybeStartTicker();
      }
    }
  }

  @override
  void dispose() {
    _stopTicker();
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _timeNotifier.dispose();
    super.dispose();
  }

  // --- WidgetsBindingObserver: pause when app is backgrounded ---------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stopTicker();
    } else if (state == AppLifecycleState.resumed) {
      _maybeStartTicker();
    }
  }

  // --- Ticker management ----------------------------------------------

  void _maybeStartTicker() {
    if (_tickerActive || widget.paused || !mounted) return;
    _tickerActive = true;
    _lastElapsed = Duration.zero;
    _ticker.start();
  }

  void _stopTicker() {
    if (!_tickerActive) return;
    _tickerActive = false;
    _ticker.stop();
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    final delta = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    _accumulated += delta;
    _timeNotifier.value = _accumulated;
  }

  // --- Theme resolution ------------------------------------------------

  bool _resolveDark(BuildContext context) {
    switch (widget.theme) {
      case OrbTheme.dark:
        return true;
      case OrbTheme.light:
        return false;
      case OrbTheme.auto:
        return Theme.of(context).brightness == Brightness.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = _resolveDark(context);
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final label = widget.semanticsLabel ?? _defaultLabels[widget.state]!;

    // Reduced motion -> one static, deterministic frame (t = 0.6).
    if (reducedMotion) {
      _stopTicker();
      final resolved = resolvePreset(widget.state, widget.size);
      return Semantics(
        container: true,
        image: true,
        label: label,
        child: CustomPaint(
          size: Size(widget.size.pixels, widget.size.pixels),
          painter: _StaticOrbPainter(
            resolved: resolved,
            size: widget.size,
            dark: dark,
            label: label,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _timeNotifier,
      builder: (context, _) {
        return Semantics(
          container: true,
          image: true,
          label: label,
          child: CustomPaint(
            size: Size(widget.size.pixels, widget.size.pixels),
            painter: OrbPainter(
              repaint: _timeNotifier,
              state: widget.state,
              size: widget.size,
              dark: dark,
              time: _timeNotifier.value,
              speed: widget.speed,
              label: label,
            ),
          ),
        );
      },
    );
  }
}

/// Paints a single static frame (for reduced-motion users).
class _StaticOrbPainter extends CustomPainter {
  _StaticOrbPainter({
    required this.resolved,
    required this.size,
    required this.dark,
    required this.label,
  });

  final Resolved resolved;
  final OrbSize size;
  final bool dark;
  final String label;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final draw = modeDraws[resolved.mode]!;
    draw(canvas, size.pixels, 0.6, dark, resolved.opts);
  }

  @override
  bool shouldRepaint(covariant _StaticOrbPainter oldDelegate) {
    return oldDelegate.dark != dark ||
        oldDelegate.size != size ||
        oldDelegate.resolved.mode != resolved.mode;
  }

  /// Accessibility semantics label for this painter.
  String? get semanticsLabel => label;
}
