part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYCircle triangleInCircleXY(XYPoint a, XYPoint b, XYPoint c,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  XYPoint iS = intersectVectors(
      XYLine(P1: a, P2: _vectorAdd(_vectorDiv(_vectorAB(a, b), _vectorLength(_vectorAB(a, b))), _vectorDiv(_vectorAB(a, c), _vectorLength(_vectorAB(a, c))))),
      XYLine(P1: b, P2: _vectorAdd(_vectorDiv(_vectorAB(b, a), _vectorLength(_vectorAB(b, a))), _vectorDiv(_vectorAB(b, c), _vectorLength(_vectorAB(b, c)))))
  );

  Sides sides = triangleSidesXY(a, b, c);
  double s = (sides.a + sides.b + sides.c) / 2;

  return XYCircle(
    x: iS.x,
    y: iS.y,
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}

XYPoint triangleInCenterXY(XYPoint a, XYPoint b, XYPoint c,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  XYPoint iS = intersectVectors(
      XYLine(P1: a, P2: _vectorAdd(_vectorDiv(_vectorAB(a, b), _vectorLength(_vectorAB(a, b))), _vectorDiv(_vectorAB(a, c), _vectorLength(_vectorAB(a, c))))),
      XYLine(P1: b, P2: _vectorAdd(_vectorDiv(_vectorAB(b, a), _vectorLength(_vectorAB(b, a))), _vectorDiv(_vectorAB(b, c), _vectorLength(_vectorAB(b, c)))))
  );

  Sides sides = triangleSidesXY(a, b, c);
  double s = (sides.a + sides.b + sides.c) / 2;

  return XYPoint(
    x: iS.x,
    y: iS.y,
  );
}


