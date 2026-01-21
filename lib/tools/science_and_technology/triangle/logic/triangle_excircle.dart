part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

List<XYCircle> triangleExCirclesXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Ankreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
  List<XYCircle> exCircle = [];

  Sides sides = triangleSidesXY(A, B, C);
  double area = triangleAreaXY(A, B, C);

  double ra = area / ((sides.a + sides.b + sides.c) / 2 - sides.a);
  double rb = area / ((sides.a + sides.b + sides.c) / 2 - sides.b);
  double rc = area / ((sides.a + sides.b + sides.c) / 2 - sides.c);

  double ac = (sides.a - sides.b + sides.c) / 2;
  double ab = (sides.a + sides.b - sides.c) / 2;

  XYPoint BexC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, B)), ac));
  XYPoint BexB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), ab));
  XYPoint BexA = _vectorAdd(C, _vectorMult(_vectorNormalize(_vectorAB(C, B)), ac));

  XYPoint MexC = _vectorAdd(BexC, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(A, B))), rc));
  XYPoint MexB = _vectorAdd(BexB, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(C, A))), rb));
  XYPoint MexA = _vectorAdd(BexA, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(B, C))), ra));

  exCircle.add(XYCircle(x: MexA.x, y: MexA.y, r: ra));
  exCircle.add(XYCircle(x: MexB.x, y: MexB.y, r: rb));
  exCircle.add(XYCircle(x: MexC.x, y: MexC.y, r: rc));

  return exCircle;
}
