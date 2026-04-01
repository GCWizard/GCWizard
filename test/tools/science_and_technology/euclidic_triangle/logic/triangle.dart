import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

String toString(dynamic o) {
  if (o is XYPoint) {
    return '(${o.x}, ${o.y})';
  } else if (o is List<XYPoint>) {
    return o.map((e) => toString(e)).join(', ');
  } else if (o is Sides) {
    return '(${o.a}, ${o.b}, ${o.c})';
  } else if (o is Angles) {
    return '(${o.alpha}, ${o.beta}, ${o.gamma})';
  } else if (o is TriLinearPoint) {
    return '(${o.a}, ${o.b}, ${o.c})';
  } else if (o is XYLine) {
    return '(P1 (${o.P1.x}, ${o.P1.y}), P2 (${o.P2.x}, ${o.P2.y}))';
  } else if (o is XYCircle) {
    return '(${o.x}, ${o.y}, ${o.r})';
  } else if (o is List<XYCircle>) {
    return o.map((e) => toString(e)).join(', ');
  } else if (o is Vec3) {
    return '(${o.x}, ${o.y}, ${o.z})';
  } else if (o is Circle) {
    return '(${o.center.toString()}, ${o.radius})';
  } else if (o is List<Circle>) {
    return o.map((e) => toString(e)).join(', ');
  }
  return o?.toString() ?? 'null';
}


void pointTest(XYPoint? p1, XYPoint? p2) {
  if (p1 == null && p2 == null) {
    expect(true, true);
  } else if (p1 == null && p2 != null) {
    expect(true, true);
  } else if (p1 != null && p2 == null) {
    expect(true, true);
  } else if (p1 != null && p2 != null) {
    if (p1.x.isNaN || p1.y.isNaN) {
      expect(p1.x.isNaN, p2.x.isNaN);
      expect(p1.y.isNaN, p2.y.isNaN);
    } else {
      expect(p1.x, p2.x);
      expect(p1.y, p2.y);
    }
  }
}

void pointListTest(List<XYPoint>? pL1, List<XYPoint>? pL2) {
  if (pL1 == null && pL2 == null) {
    expect(true, true);
  } else if (pL1 == null && pL2 != null) {
    expect(true, true);
  } else if (pL1 != null && pL2 == null) {
    expect(true, true);
  } else if (pL1 != null && pL2 != null) {
    expect(pL1.length, pL2.length);
    for(var i = 0; i < pL1.length; i++) {
      pointTest(pL1[i], pL2[i]);
    }
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

void circlesTest(XYCircle? a1, XYCircle? a2) {
  if (a1 == null || a2 == null) {
    return expect(a1, a2);
  } else if (a1.x.isNaN || a1.y.isNaN || a1.r.isNaN) {
    expect(a1.x.isNaN, a2.x.isNaN);
    expect(a1.y.isNaN, a2.y.isNaN);
    expect(a1.r.isNaN, a2.r.isNaN);
  } else {
    expect(a1.x, a2.x);
    expect(a1.y, a2.y);
    expect(a1.r, a2.r);
  }
}

void circlesListTest(List<XYCircle> cL1, List<XYCircle> cL2) {
  expect(cL1.length, cL2.length);
  for(var i = 0; i < cL1.length; i++) {
    circlesTest(cL1[i], cL2[i]);
  }
}

void latLngTest(LatLng a, LatLng b) {
  if (a.latitude.isNaN || a.longitude.isNaN) {
    expect(a.latitude.isNaN, b.latitude.isNaN);
    expect(a.longitude.isNaN, b.longitude.isNaN);
  } else if (a.latitude.isInfinite || a.longitude.isInfinite) {
      expect(a.latitude.isInfinite, b.latitude.isInfinite);
      expect(a.longitude.isInfinite, b.longitude.isInfinite);
  } else {
    expect(true, equalsLatLng(a, b));
  }
}

void latLngListTest(List<LatLng> aL1, List<LatLng> bL2) {
  expect(aL1.length, bL2.length);
  for(var i = 0; i < aL1.length; i++) {
    latLngTest(aL1[i], bL2[i]);
  }
}

void circleTest(Circle a1, Circle a2) {
  latLngTest(a1.center, a2.center);
  if (a1.radius.isNaN) {
    expect(a1.radius.isNaN, a2.radius.isNaN);
  } else {
    expect(a1.radius, a2.radius);
  }
}

void circleListTest(List<Circle> cL1, List<Circle> cL2) {
  expect(cL1.length, cL2.length);
  for(var i = 0; i < cL1.length; i++) {
    circleTest(cL1[i], cL2[i]);
  }
}

void vec3Test(Vec3 a1, Vec3 a2) {
  if (a1.x.isNaN || a1.y.isNaN || a1.z.isNaN) {
    expect(a1.x.isNaN, a2.x.isNaN);
    expect(a1.y.isNaN, a2.y.isNaN);
    expect(a1.z.isNaN, a2.z.isNaN);
  } else {
    expect(a1.x, a2.x);
    expect(a1.y, a2.y);
    expect(a1.z, a2.z);
  }
}