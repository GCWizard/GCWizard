part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleConjugateX11PointXY(XYPoint a, XYPoint b, XYPoint c){

  final sa = b.distanceToPoint(c);
  final sb = c.distanceToPoint(a);
  final sc = a.distanceToPoint(b);
  final s = (sa + sb + sc) /2;

  final u = pow(sb + sc, 2) / (s - sa);
  final v = pow(sa + sc, 2) / (s - sb);
  final w = pow(sa + sb, 2) / (s - sc);

  final sum = u + v + w;

  return XYPoint(
    x: (u * a.x + v * b.x + w * c.x) / sum,
    y: (u * a.y + v * b.y + w * c.y) / sum,
  );
}
