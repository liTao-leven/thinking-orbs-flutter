// Public API types for the ThinkingOrb widget.

/// The six shipped states - each a hand-tuned animation:
/// - [working]   - particles on tilted orbits
/// - [searching] - a scan meridian sweeps a dotted globe
/// - [solving]   - bands scramble in quarter turns, then click back
/// - [listening] - a waveform rolls through latitude rings
/// - [composing] - an undulating multi-band sash
/// - [shaping]   - a dotted outline morphs circle -> triangle -> square
enum OrbState {
  working,
  searching,
  solving,
  listening,
  composing,
  shaping,
}

/// Tuned size presets.
///
/// Each size carries its own dot count, dot size and speed tuning - they
/// are separate designs, not a scale factor.
/// - [large] (64px) - chat-avatar scale
/// - [small] (20px) - inline-text scale
enum OrbSize {
  /// 64 CSS pixels - chat-avatar scale.
  large(64.0),

  /// 20 CSS pixels - inline-text scale.
  small(20.0);

  const OrbSize(this.pixels);

  /// The rendered size in logical pixels.
  final double pixels;
}

/// Theme mode.
///
/// - [auto] (default) resolves from the ambient [ThemeData] brightness,
///   updating live when the app theme changes.
/// - [dark] / [light] pin the palette regardless of context.
///
/// Dark renders light ink (for dark backgrounds); light renders dark ink
/// (for light backgrounds).
enum OrbTheme {
  auto,
  dark,
  light,
}
