part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint multiplyWithOmega(XYPoint p) {
  const double real = -0.5;
  final double imag = sqrt(3) / 2;

  return XYPoint(
    x: real * p.x - imag * p.y,
    y: imag * p.x + real * p.y,
  );
}

XYPoint multiplyWithOmega2(XYPoint p) {
  const double real = -0.5;
  double imag = -sqrt(3) / 2;

  return XYPoint(
    x: real * p.x - imag * p.y,
    y: imag * p.x + real * p.y,
  );
}

/// Inner Napoleonpoint
XYPoint triangleNapoleonInnerPointXY(XYPoint a, XYPoint b, XYPoint c) {
  final bOmega = multiplyWithOmega(b);
  final cOmega2 = multiplyWithOmega2(c);

  return (a + bOmega + cOmega2) / 3.0;
}

/// Outer Napoleonpoint
XYPoint triangleNapoleonOuterPointXY(XYPoint a, XYPoint b, XYPoint c) {
  // ω and ω² are changed
  final bOmega2 = multiplyWithOmega2(b);
  final cOmega = multiplyWithOmega(c);

  return (a + bOmega2 + cOmega) / 3.0;
}

