part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint? triangleLongchampsPointXY(XYPoint a, XYPoint b, XYPoint c){
  Triangle t = Triangle(a, b, c);
  double sa = t.sides.a * t.sides.a;
  double sb = t.sides.b * t.sides.b;
  double sc = t.sides.c * t.sides.c;

  final bary = _longchampsBarycentricFromSides(sa, sb, sc);

  if (bary == null) {
    return null;
  }

  return XYPoint.fromBarycentric(t,
      bary.a,
      bary.b,
      bary.c
      );
}

BarycentricPoint? _longchampsBarycentricFromSides(
   double a, // |BC|
   double b, // |CA|
   double c, // |AB|
) {
   final double dA = b * b + c * c - a * a;
   final double dB = c * c + a * a - b * b;
   final double dC = a * a + b * b - c * c;

   if (dA == 0 || dB == 0 || dC == 0) {
     return null;
   }

   final double wA = 1.0 / (dA * dA);
   final double wB = 1.0 / (dB * dB);
   final double wC = 1.0 / (dC * dC);

   return BarycentricPoint(a: wA, b: wB, c: wC);
 }

