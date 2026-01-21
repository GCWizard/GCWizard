part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYCircle triangleInCircleXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  XYPoint S = intersectVectors(
      XYLine(P1: A, P2: _vectorAdd(_vectorDiv(_vectorAB(A, B), _vectorLength(_vectorAB(A, B))), _vectorDiv(_vectorAB(A, C), _vectorLength(_vectorAB(A, C))))),
      XYLine(P1: B, P2: _vectorAdd(_vectorDiv(_vectorAB(B, A), _vectorLength(_vectorAB(B, A))), _vectorDiv(_vectorAB(B, C), _vectorLength(_vectorAB(B, C)))))
  );

  Sides sides = triangleSidesXY(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return XYCircle(
    x: S.x,
    y: S.y,
    // ri = sqrt((s - a)·(s - b)·(s - c)/s) mit s = u/2
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}

