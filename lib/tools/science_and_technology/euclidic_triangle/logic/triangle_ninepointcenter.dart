part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleNinePointCenterXY(XYPoint a, XYPoint b, XYPoint c) {
  Triangle t = Triangle(a, b, c);
  XYPoint X3 = XYPoint(x: t.X3.x, y: t.X3.y);
  XYPoint X4 = t.X4;
  return XYPoint(x: (X3.x + X4.x) / 2, y: (X3.y + X4.y) / 2,
  );
}
