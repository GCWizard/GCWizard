part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleGergonnePointXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Gergonne-Punkt
  // https://mathworld.wolfram.com/GergonnePoint.html

  final sa = b.distanceToPoint(c);
  final sb = c.distanceToPoint(a);
  final sc = a.distanceToPoint(b);

  return XYPoint.fromBarycentric(Triangle(a, b, c), 1 / (sb + sc - sa),
      1 / (sc + sa - sb), 1 / (sa + sb - sc));
}
