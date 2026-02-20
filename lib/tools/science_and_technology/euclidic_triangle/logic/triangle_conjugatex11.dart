part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleConjugateX11PointXY(XYPoint a, XYPoint b, XYPoint c){
  Triangle t = Triangle(a, b, c);
  return XYPoint.fromBarycentric(t, 1 / t.sides.a, 1 / t.sides.b, 1 / t.sides.c);
}
