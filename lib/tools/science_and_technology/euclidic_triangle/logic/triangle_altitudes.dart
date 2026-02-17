part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Sides triangleAltitudesXY(XYPoint a, XYPoint b, XYPoint c){
  double area = triangleAreaXY(a, b, c);
  Sides sides = triangleSidesXY(a, b, c);

  return Sides(
    a: 2 * area / sides.a,
    b: 2 * area / sides.b,
    c: 2 * area / sides.c,
  );

  // alternative
  // final Ha = foot(a, b, c); final Hb = foot(b, a, c); final Hc = foot(c, a, b);
  // return Sides(
  //     a: distance(a, Ha),
  //     b: distance(b, Hb),
  //     c: distance(c, Hc)
  //   );
}
