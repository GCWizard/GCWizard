part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleFermatTorricelliPointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  Angles angles = triangleAnglesXY(a, b, c);

  double csc(double x) => 1.0 / sin(x);
  final sa = b.distanceToPoint(c);
  final sb = c.distanceToPoint(a);
  final sc = a.distanceToPoint(b);

  final u = sa * csc(degToRadian(angles.alpha) + pi / 3); // +60°
  final v = sb * csc(degToRadian(angles.beta) + pi / 3);
  final w = sc * csc(degToRadian(angles.gamma) + pi / 3);

  return XYPoint.fromBarycentric(
      t,
      u,
      v,
      w,
  );
}
