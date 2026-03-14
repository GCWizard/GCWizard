part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleIsoDynamic1PointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  Angles angles = t.angles;
  Sides sides = t.sides;
  double alpha = angles.alpha;
  double beta = angles.beta;
  double gamma = angles.gamma;
  double sa = sides.a;
  double sb = sides.b;
  double sc = sides.c;

  final u = sa * sin(degToRadian(alpha) + pi / 3.0);
  final v = sb * sin(degToRadian(beta) + pi / 3.0);
  final w = sc * sin(degToRadian(gamma) + pi / 3.0);

  return XYPoint.fromBarycentric(t, u, v, w);
}

XYPoint triangleIsoDynamic2PointXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  Angles angles = t.angles;
  Sides sides = t.sides;
  double alpha = angles.alpha;
  double beta = angles.beta;
  double gamma = angles.gamma;
  double sa = sides.a;
  double sb = sides.b;
  double sc = sides.c;

  final u = sa * sin(degToRadian(alpha) - pi / 3.0);
  final v = sb * sin(degToRadian(beta) - pi / 3.0);
  final w = sc * sin(degToRadian(gamma) - pi / 3.0);

  return XYPoint.fromBarycentric(t, u, v, w);
}
