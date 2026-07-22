// Mode key -> frame painter. Kept separate from the presets so unused
// modes can be tree-shaken in custom builds.

import 'lattice.dart';
import 'morph.dart';
import 'orbits.dart';
import 'ribbon.dart';
import 'types.dart';

/// Maps each mode key to its frame draw function.
final Map<String, ModeDraw> modeDraws = {
  'orbits': drawOrbits,
  'globe': drawGlobe,
  'rubik': drawRubik,
  'wave': drawWave,
  'ribbon': drawRibbon,
  'morph': drawMorph,
};
