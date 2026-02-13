part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleMitten(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Mittenpunkt
  // https://mathworld.wolfram.com/Mittenpunkt.html

  List<XYPoint> sidesmidpoint = triangleSidesMidPointsXY(a, b, c);
  List<XYCircle> excircles = triangleExCirclesXY(a, b, c);

  XYPoint m = intersectVectors(
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
  return m;
}