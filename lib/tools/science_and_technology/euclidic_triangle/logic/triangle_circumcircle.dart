part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYCircle triangleCircumCircleXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Umkreis

  Sides sides = triangleSidesXY(a, b, c);
  Angles angles = triangleAnglesXY(a, b, c);

  XYPoint SB =  _vectorAdd(a, _vectorMult(_vectorNormalize(_vectorAB(a, c)), sides.b / 2));
  XYPoint SA =  _vectorAdd(b, _vectorMult(_vectorNormalize(_vectorAB(b, c)), sides.a / 2));

  XYPoint S = intersectVectors(
      XYLine(P1: SA, P2: _vectorNorm(_vectorAB(b, c))),
      XYLine(P1: SB, P2: _vectorNorm(_vectorAB(a, c)))
  );
  return XYCircle(
    x: S.x,
    y: S.y,
    r: sides.a / (2 * sin(angles.alpha * pi /180)),
  );
}

