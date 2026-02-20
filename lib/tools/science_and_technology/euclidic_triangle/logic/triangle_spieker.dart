part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleSpiekerPointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Spieker-Punkt

  List<XYPoint> sidesmidpoint = triangleSidesMidPointsXY(a, b, c);

  XYCircle S = triangleInCircleXY(sidesmidpoint[0], sidesmidpoint[1], sidesmidpoint[2]);
  return XYPoint(
    x: S.x,
    y: S.y,
  );
}