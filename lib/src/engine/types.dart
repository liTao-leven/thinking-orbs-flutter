// Engine-level contracts shared by every mode implementation.

import 'dart:ui';

import 'profiles.dart';

/// A single drawable dot in 3D space.
class Dot {
  Dot({
    required this.x,
    required this.y,
    required this.z,
    required this.r,
    required this.white,
    this.a,
  });

  /// Screen-space x.
  double x;

  /// Screen-space y.
  double y;

  /// Depth (used for z-sort and depth shading).
  double z;

  /// Dot radius in CSS pixels.
  double r;

  /// Ink value: 0 = darkest ink on paper. Mirrored on dark themes.
  double white;

  /// Optional alpha; null means fully opaque.
  double? a;
}

/// Projects a 3D point to 2D screen coords + retained depth.
typedef Projector = List<double> Function(double x, double y, double z);

/// One frame painter: draws a mode into a 2D canvas at `size` CSS pixels.
typedef ModeDraw = void Function(
  Canvas canvas,
  double size,
  double t,
  bool dark,
  ModeOpts opts,
);
