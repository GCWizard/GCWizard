part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleCentroidXY(XYPoint a, XYPoint b, XYPoint c,){
  // https://de.wikipedia.org/wiki/Geometrischer_Schwerpunkt
  return XYPoint(
    x: (a.x + b.x + c.x) / 3,
    y: (a.y + b.y + c.y) / 3,
  );
}

