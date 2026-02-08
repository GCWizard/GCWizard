part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleLemoine(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Lemoinepunkt
  // https://mathematikgarten.hpage.com/get_file.php?id=33910985&vnr=826595

  Sides sides = triangleSidesXY(A, B, C);
  double divisor = sides.a * sides.a + sides.b * sides.b + sides.c * sides.c;
  XYPoint L = XYPoint(
    x: A.x * sides.a * sides.a / divisor + B.x * sides.b * sides.b / divisor + C.x * sides.c * sides.c / divisor,
    y: A.y * sides.a * sides.a / divisor + B.y * sides.b * sides.b / divisor + C.y * sides.c * sides.c / divisor,
  );
  return L;
}