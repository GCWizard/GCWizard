part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleCentroidXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Geometrischer_Schwerpunkt
  return XYPoint(
    x: (A.x + B.x + C.x) / 3,
    y: (A.y + B.y + C.y) / 3,
  );
}

