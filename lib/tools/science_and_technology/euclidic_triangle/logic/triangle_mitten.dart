part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleMitten(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Mittenpunkt
  // https://mathworld.wolfram.com/Mittenpunkt.html

  List<XYPoint> sidesmidpoint = triangleSidesMidPointsXY(A, B, C);
  List<XYCircle> excircles = triangleExCirclesXY(A, B, C);

  XYPoint M = intersectVectors(
      XYLine(
          P1: XYPoint(
            x: excircles[1].x,
            y: excircles[1].y,
          ),
          P2: sidesmidpoint[1]),
      XYLine(
          P1: XYPoint(
            x: excircles[0].x,
            y: excircles[0].y,
          ),
          P2: sidesmidpoint[0])
  );
  return M;
}