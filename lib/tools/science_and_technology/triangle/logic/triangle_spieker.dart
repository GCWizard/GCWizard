part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleSpieker(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Spieker-Punkt

  List<XYPoint> sidesmidpoint = triangleSidesMidPointsXY(A, B, C);

  XYCircle S = triangleInCircleXY(sidesmidpoint[0], sidesmidpoint[1], sidesmidpoint[2]);
  return XYPoint(
    x: S.x,
    y: S.y,
  );
}