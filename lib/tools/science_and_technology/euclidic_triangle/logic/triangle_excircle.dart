part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYCircle> triangleExCirclesXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Ankreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
  List<XYCircle> exCircle = [];

  final Sides sides = triangleSidesXY(a, b, c);
  final double area = triangleAreaXY(a, b, c);

  final as = sides.a;
  final bs = sides.b;
  final cs = sides.c;

  final s = (as + bs + cs) / 2;

  final rA = area / (s - as);
  final rB = area / (s - bs);
  final rC = area / (s - cs);

  final denomA = (bs + cs - as);
  final denomB = (as + cs - bs);
  final denomC = (as + bs - cs);

  final iA = XYPoint(
    x: (-as * a.x + bs * b.x + cs * c.x) / denomA,
    y: (-as * a.y + bs * b.y + cs * c.y) / denomA,
  );

  final iB = XYPoint(
    x: (as * a.x - bs * b.x + cs * c.x) / denomB,
    y: (as * a.y - bs * b.y + cs * c.y) / denomB,
  );

  final iC = XYPoint(
    x: (as * a.x + bs * b.x - cs * c.x) / denomC,
    y: (as * a.y + bs * b.y - cs * c.y) / denomC,
  );

  exCircle.add(XYCircle(x: iA.x, y: iA.y, r: rA));
  exCircle.add(XYCircle(x: iB.x, y: iB.y, r: rB));
  exCircle.add(XYCircle(x: iC.x, y: iC.y, r: rC));

  return exCircle;
}

XYPoint _footOnLine(XYPoint p, XYPoint b, XYPoint c) {
  final v = c - b;
  final w = p - b;
  final denom = _dot(v, v);
  if (denom == 0) return b; // degenerated
  final t = _dot(w, v) / denom;
  return b + v * t;
}

double _dot(XYPoint a, XYPoint b) => a.x * b.x + a.y * b.y;

List<XYPoint> triangleTouchPointsExcircleXY(XYPoint a, XYPoint b, XYPoint c){
  final ex = triangleExCirclesXY(a, b, c);

  // Excircle in opposite A touches side BC
     final iA = XYPoint(x: ex[0].x, y: ex[0].y);
     final hA = _footOnLine(iA, b, c);

  // Excircle in opposite B touches side CA
     final iB = XYPoint(x: ex[1].x, y: ex[1].y);
     final hB = _footOnLine(iB, c, a);

  // Excircle in opposite C touches side AB
     final iC = XYPoint(x: ex[2].x, y: ex[2].y);
     final hC = _footOnLine(iC, a, b);

  return [hA, hB, hC,];
}