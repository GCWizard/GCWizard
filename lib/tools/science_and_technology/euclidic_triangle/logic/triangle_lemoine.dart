part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleLemoinePointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Lemoinepunkt
  // https://mathematikgarten.hpage.com/get_file.php?id=33910985&vnr=826595

  Sides sides = triangleSidesXY(a, b, c);
  double divisor = sides.a * sides.a + sides.b * sides.b + sides.c * sides.c;
  XYPoint L = XYPoint(
    x: a.x * sides.a * sides.a / divisor + b.x * sides.b * sides.b / divisor + c.x * sides.c * sides.c / divisor,
    y: a.y * sides.a * sides.a / divisor + b.y * sides.b * sides.b / divisor + c.y * sides.c * sides.c / divisor,
  );
  return L;
}