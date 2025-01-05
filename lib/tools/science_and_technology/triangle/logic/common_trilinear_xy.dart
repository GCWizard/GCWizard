part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint TriLinearToXYPoint(TriLinearPoint P, XYPoint A, XYPoint B, XYPoint C) {
  // https://mathworld.wolfram.com/TrilinearCoordinates.html

  Sides s = triangleSides(A, B, C);
  XYPoint av = _vectorNormalize(_vectorAB(B, C));
  double a1 = av.x;
  double a2 = av.y;
  XYPoint cv = _vectorNormalize(_vectorAB(A, B));
  double c1= cv.x;
  double c2 = cv.y;
  double a = P.x;
  double c = P.z;
  double k = 2 * triangleArea(A, B, C) / (P.x * s.a + P.y * s.b + P.z * s.c);
  double lc = (k * a - c * k * (a1 * c1 + a2 * c2) + a2 * (A.x - C.x) + a1 * (C.y - A.y)) / (a1 * c2 - a2 * c1);

  return XYPoint(
      x: A.x + lc * c1 - k * P.z * c2,
      y: A.y + lc * c2 + k * P.z * c1
  );
}

