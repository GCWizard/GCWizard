part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYCircle triangleCircumCircleXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Umkreis

  Sides sides = triangleSidesXY(A, B, C);
  Angles angles = triangleAnglesXY(A, B, C)!;

  XYPoint SB =  _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), sides.b / 2));
  XYPoint SA =  _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorAB(B, C)), sides.a / 2));

  XYPoint S = intersectVectors(
      XYLine(P1: SA, P2: _vectorNorm(_vectorAB(B, C))),
      XYLine(P1: SB, P2: _vectorNorm(_vectorAB(A, C)))
  );
  return XYCircle(
    x: S.x,
    y: S.y,
    r: sides.a / (2 * sin(angles.alpha * pi /180)),
  );
}

