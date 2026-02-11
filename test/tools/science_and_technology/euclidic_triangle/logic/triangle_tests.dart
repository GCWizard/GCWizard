import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
String toString(dynamic o) {
  if (o is XYPoint) {
    return '(${o.x}, ${o.y})';
  } else if (o is Sides) {
    return '(${o.a}, ${o.b}, ${o.c})';
  } else if (o is Angles) {
    return '(${o.alpha}, ${o.beta}, ${o.gamma})';
  } else if (o is TriLinearPoint) {
    return '(${o.x}, ${o.y}, ${o.z})';
  } else if (o is XYLine) {
    return '(P1 (${o.P1.x}, ${o.P1.y}), P2 (${o.P2.x}, ${o.P2.y}))';
  } else if (o is XYCircle) {
    return '(${o.x}, ${o.y}, ${o.r})';
  }
  return o?.toString() ?? 'null';
}


void pointTest(XYPoint p1, XYPoint p2) {
  if (p1.x.isNaN || p1.y.isNaN) {
    expect(p1.x.isNaN, p2.x.isNaN);
    expect(p1.y.isNaN, p2.y.isNaN);
  } else {
    expect(p1.x, p2.x);
    expect(p1.y, p2.y);
  }
}

void pointListTest(List<XYPoint> pL1, List<XYPoint> pL2) {
  expect(pL1.length, pL2.length);
  for(var i = 0; i < pL1.length; i++) {
    pointTest(pL1[i], pL2[i]);
  }
}

void sidesTest(Sides s1, Sides s2) {
  if (s1.a.isNaN || s1.b.isNaN || s1.c.isNaN) {
    expect(s1.a.isNaN, s2.a.isNaN);
    expect(s1.b.isNaN, s2.b.isNaN);
    expect(s1.c.isNaN, s2.c.isNaN);
  } else {
    expect(s1.a, s2.a);
    expect(s1.b, s2.b);
    expect(s1.c, s2.c);
  }
}

void anglesTest(Angles? a1, Angles? a2) {
  if (a1 == null || a2 == null) {
    return expect(a1, a2);
  } else if (a1.alpha.isNaN || a1.beta.isNaN || a1.gamma.isNaN) {
    expect(a1.alpha.isNaN, a2.alpha.isNaN);
    expect(a1.beta.isNaN, a2.beta.isNaN);
    expect(a1.gamma.isNaN, a2.gamma.isNaN);
  } else {
    expect(a1.alpha, a2.alpha);
    expect(a1.beta, a2.beta);
    expect(a1.gamma, a2.gamma);
  }
}