part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleGergonnePointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Gergonne-Punkt
  // https://mathworld.wolfram.com/GergonnePoint.html
  XYCircle mC = triangleInCircleXY(a, b, c);
  XYPoint m = XYPoint(x: mC.x, y: mC.y);
  XYPoint x = intersectVectors(
      XYLine(P1: b, P2: _vectorAB(b, c)),
      XYLine(P1: m, P2: _vectorNorm(_vectorAB(b, c)))
  );
  XYPoint z = intersectVectors(
      XYLine(P1: a, P2: _vectorAB(a, b)),
      XYLine(P1: m, P2: _vectorNorm(_vectorAB(a, b)))
  );
  return intersectVectors(
    XYLine(P1: a, P2: _vectorAB(a, x)),
    XYLine(P1: c, P2: _vectorAB(c, z)),
  );
}