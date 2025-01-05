part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint _vectorAB(XYPoint A, XYPoint B) {
  return XYPoint(x: B.x - A.x, y: B.y - A.y);
}

XYPoint _vectorAdd(XYPoint A, XYPoint B) {
  return XYPoint(
    x: A.x + B.x,
    y: A.y + B.y,
  );
}

XYPoint _vectorDiv(XYPoint A, double s) {
  return XYPoint(
    x: A.x / s,
    y: A.y / s,
  );
}

XYPoint _vectorMult(XYPoint A, double s) {
  return XYPoint(
    x: A.x * s,
    y: A.y * s,
  );
}

double _vectorProductDot(XYPoint A, XYPoint B) {
  return A.x * B.x + A.y * B.y;
}

bool _vectorEqual(XYPoint A, XYPoint B) {
  A = _vectorNormalize(A);
  B = _vectorNormalize(B);
  return (A.x == B.x && B.y == B.y);
}

double _vectorLength(XYPoint V) {
  return sqrt(V.x * V.x + V.y * V.y);
}

XYPoint _vectorNorm(XYPoint A) {
  return XYPoint(
    x: -A.y,
    y: A.x,
  );
}

XYPoint _vectorNormalize(XYPoint V) {
  double factor = _vectorLength(V);
  return XYPoint(
    x: V.x / factor,
    y: V.y / factor,
  );
}

XYPoint intersectVectors(XYLine L1, XYLine L2){
  if (_vectorEqual(L1.P2, L2.P2)) {
    return XYPoint(x: 0, y: 0);
  }

  // return
  // XYPoint(
  //   x: (L2.a - L1.a) / (L1.m - L2.m),
  //   y: L1.m * (L2.a - L1.a) / (L1.m - L2.m) + L1.a
  // );

  try {
    double m = (L1.P1.y * L2.P2.x - L2.P1.y * L2.P2.x - L1.P1.x * L2.P2.y + L2.P1.x * L2.P2.y) / (L1.P2.x * L2.P2.y - L1.P2.y * L2.P2.x);

    return
      XYPoint(
          x: L1.P1.x + m * L1.P2.x,
          y: L1.P1.y + m * L1.P2.y
      );
  } catch (e) {
    return XYPoint(x:0, y:0);
  }
}

List<XYPoint> intersectTwoCircles(XYCircle A, XYCircle B){
  double AB0 = B.x - A.x;
  double AB1 = B.y - A.y;
  double c = sqrt(AB0 * AB0 + AB1* AB1);

  double a = A.r;
  double b = B.r;

  if (c ==  0) {
    return [];
  }

  double x = (a * a + c * c - b * b) / (2 * c);
  double y = a * a - x * x;
  if (y < 0) {
    // no intersection
    return [];
  }

  if (y > 0) y = sqrt( y );

  // compute unit vectors ex and ey
  double ex0 = AB0 / c;
  double ex1 = AB1 / c;
  double ey0 = -ex1;
  double ey1 =  ex0;
  double Q1x = A.x + x * ex0;
  double Q1y = A.y + x * ex1;

  if (y == 0) {
    // one touch point
    return [XYPoint(x: Q1x, y: Q1y)];
  }

  // two intersections
  double Q2x = Q1x - y * ey0;
  double Q2y = Q1y - y * ey1;
  Q1x += y * ey0;
  Q1y += y * ey1;
  return [
    XYPoint(x: Q1x, y: Q1y),
    XYPoint(x: Q2x, y: Q2y)
  ];

}
