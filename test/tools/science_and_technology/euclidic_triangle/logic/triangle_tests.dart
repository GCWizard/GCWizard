import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

void pointTest(XYPoint p1, XYPoint p2) {
  if (p1.x.isNaN || p1.y.isNaN || p2.x.isNaN || p2.y.isNaN) {
    expect(p1.x.isNaN, p2.x.isNaN);
    expect(p1.y.isNaN, p2.y.isNaN);
  } else {
    expect(p1.x, p2.x);
    expect(p1.y, p2.y);
  }
}

void pointListTest(List<XYPoint> pL1, List<XYPoint> pL2) {
  expect(pL1.length, pL2.length);
  for(var i = 0; i < pL1.length; i) {
    pointTest(pL1[i], pL2[i]);
  }
}