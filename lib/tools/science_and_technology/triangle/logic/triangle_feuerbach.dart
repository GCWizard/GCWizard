part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleFeuerbach(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Feuerbachkreis

  XYCircle incircle = triangleInCircle(A, B, C);
  XYCircle feuerbachcircle = triangleFeuerbachCircle(A, B, C);

  List<XYPoint> feuerbachpoints = intersectTwoCircles(incircle, feuerbachcircle);

  if (feuerbachpoints.isNotEmpty) {
    return feuerbachpoints[0];
  } else {
    return XYPoint(x: 0, y: 0);
  }
}