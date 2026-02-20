part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint triangleFeuerbachPointXY(XYPoint a, XYPoint b, XYPoint c){
  // https://de.wikipedia.org/wiki/Feuerbachkreis

  XYCircle incircle = triangleInCircleXY(a, b, c);
  XYCircle feuerbachcircle = triangleFeuerbachCircleXY(a, b, c);

  List<XYPoint> feuerbachpoints = intersectTwoCircles(incircle, feuerbachcircle);

  if (feuerbachpoints.isNotEmpty) {
    return feuerbachpoints[0];
  } else {
    return XYPoint(x: 0, y: 0);
  }
}