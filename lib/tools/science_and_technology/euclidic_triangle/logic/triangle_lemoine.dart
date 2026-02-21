part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleLemoinePointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Lemoinepunkt
  // https://mathematikgarten.hpage.com/get_file.php?id=33910985&vnr=826595

  Sides sides = triangleSidesXY(a, b, c);
  return XYPoint.fromBarycentric(
    Triangle(a, b, c),
      sides.a * sides.a,
      sides.b * sides.b,
      sides.c * sides.c
  );
}