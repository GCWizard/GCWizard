part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

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
