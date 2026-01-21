part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';


XYCircle triangleFeuerbachCircleXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Feuerbachkreis
  List<XYPoint> sidemidpoints = triangleSidesMidPointsXY(A, B, C);
  XYCircle F = triangleCircumCircleXY(
    XYPoint(x: sidemidpoints[0].x, y: sidemidpoints[0].y),
    XYPoint(x: sidemidpoints[1].x, y: sidemidpoints[1].y),
    XYPoint(x: sidemidpoints[2].x, y: sidemidpoints[2].y),
  );
  return F;
}
