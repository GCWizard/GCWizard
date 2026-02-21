part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleConjugateX11PointXY(XYPoint a, XYPoint b, XYPoint c){

  // A(10, 50)  B(200, -90)  C(100, 150)
  // a 260,  b 134.536, c236.186
  // 𝑋(12) ≈ (84.9 , 51.0)

  final sa = _sideLength(b, c);
  final sb = _sideLength(c, a);
  final sc = _sideLength(a, b);
  final s = (sa + sb + sc) /2;

  final u = pow(sb + sc, 2) / (s - sa);
  final v = pow(sa + sc, 2) / (s - sb);
  final w = pow(sa + sb, 2) / (s - sc);

  final sum = u + v + w;

  return XYPoint(
    x: (u * a.x + v * b.x + w * c.x) / sum,
    y: (u * a.y + v * b.y + w * c.y) / sum,
  );
}
