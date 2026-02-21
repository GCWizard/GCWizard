part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleGergonnePointXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Gergonne-Punkt
  // https://mathworld.wolfram.com/GergonnePoint.html

  final sa = _sideLength(b, c);
  final sb = _sideLength(c, a);
  final sc = _sideLength(a, b);

  return XYPoint.fromBarycentric(Triangle(a, b, c), 1 / (sb + sc - sa),
      1 / (sc + sa - sb), 1 / (sa + sb - sc));
}
