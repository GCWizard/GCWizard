part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleFeuerbachPointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://en.wikipedia.org/wiki/Feuerbach_point
  final sa = b.distanceToPoint(c);
  final sb = c.distanceToPoint(a);
  final sc = a.distanceToPoint(b);

  final s = (sa + sb + sc) / 2;

  final u = (s - sa) * pow(sb - sc, 2);
  final v = (s - sb) * pow(sc - sa, 2);
  final w = (s - sc) * pow(sa - sb, 2);

  return XYPoint.fromBarycentric(
    Triangle(a, b, c),
    u,
    v,
    w
  );
}