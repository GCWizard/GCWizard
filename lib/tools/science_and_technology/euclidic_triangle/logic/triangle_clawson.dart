part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleClawsonPointXY(XYPoint a, XYPoint b, XYPoint c){
  Triangle t = Triangle(a, b, c);
  double sa = t.sides.a * t.sides.a;
  double sb = t.sides.b * t.sides.b;
  double sc = t.sides.c * t.sides.c;
  return XYPoint.fromBarycentric(t, t.sides.a / (-sa + sb + sc), t.sides.b / (sa - sb + sc), t.sides.c / (sa + sb - sc));
}
