part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYCircle triangleCircumscribedCircleXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Umkreis

  Sides sides = triangleSidesXY(a, b, c);
  Angles angles = triangleAnglesXY(a, b, c);

  final S = XYPoint.fromBarycentric(
    Triangle(a, b, c),
      sin(degToRadian(angles.alpha * 2)),
      sin(degToRadian(angles.beta * 2)),
      sin(degToRadian(angles.gamma * 2)),
    );

  return XYCircle(
    x: S.x,
    y: S.y,
    r: sides.a / (2 * sin(angles.alpha * pi /180)),
  );
}