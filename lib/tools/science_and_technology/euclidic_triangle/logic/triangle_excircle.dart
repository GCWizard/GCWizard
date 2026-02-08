part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

List<XYCircle> triangleExCirclesXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Ankreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
  List<XYCircle> exCircle = [];

  final Sides sides = triangleSidesXY(A, B, C);
  final double area = triangleAreaXY(A, B, C);

  final a = sides.a;
  final b = sides.b;
  final c = sides.c;

  final s = (a + b + c) / 2;

  final rA = area / (s - a);
  final rB = area / (s - b);
  final rC = area / (s - c);

  final denomA = (b + c - a);
  final denomB = (a + c - b);
  final denomC = (a + b - c);

  final IA = XYPoint(
    x: (-a * A.x + b * B.x + c * C.x) / denomA,
    y: (-a * A.y + b * B.y + c * C.y) / denomA,
  );

  final IB = XYPoint(
    x: (a * A.x - b * B.x + c * C.x) / denomB,
    y: (a * A.y - b * B.y + c * C.y) / denomB,
  );

  final IC = XYPoint(
    x: (a * A.x + b * B.x - c * C.x) / denomC,
    y: (a * A.y + b * B.y - c * C.y) / denomC,
  );

  exCircle.add(XYCircle(x: IA.x, y: IA.y, r: rA));
  exCircle.add(XYCircle(x: IB.x, y: IB.y, r: rB));
  exCircle.add(XYCircle(x: IC.x, y: IC.y, r: rC));

  return exCircle;
}

XYPoint _footOnLine(XYPoint P, XYPoint B, XYPoint C) {
  final v = C - B;
  final w = P - B;
  final denom = _dot(v, v);
  if (denom == 0) return B; // degeneriert
  final t = _dot(w, v) / denom;
  return B + v * t;
}

double _dot(XYPoint a, XYPoint b) => a.x * b.x + a.y * b.y;

List<XYPoint> triangleTouchPointsExcircleXY(XYPoint A, XYPoint B, XYPoint C){
  final ex = triangleExCirclesXY(A, B, C);

  // Ankreis gegenüber A berührt Seite BC
     final IA = XYPoint(x: ex[0].x, y: ex[0].y);
     final HA = _footOnLine(IA, B, C);

  // Ankreis gegenüber B berührt Seite CA
     final IB = XYPoint(x: ex[1].x, y: ex[1].y);
     final HB = _footOnLine(IB, C, A);

  // Ankreis gegenüber C berührt Seite AB
     final IC = XYPoint(x: ex[2].x, y: ex[2].y);
     final HC = _footOnLine(IC, A, B);

  return [HA, HB, HC,];
}