part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

XYPoint _vectorAB(XYPoint a, XYPoint b) {
  return XYPoint(x: b.x - a.x, y: b.y - a.y);
}

XYPoint _vectorAdd(XYPoint a, XYPoint b) {
  return XYPoint(
    x: a.x + b.x,
    y: a.y + b.y,
  );
}

XYPoint _vectorDiv(XYPoint a, double s) {
  return XYPoint(
    x: a.x / s,
    y: a.y / s,
  );
}

XYPoint _vectorMult(XYPoint a, double s) {
  return XYPoint(
    x: a.x * s,
    y: a.y * s,
  );
}

double _vectorProductDot(XYPoint a, XYPoint b) {
  return a.x * b.x + a.y * b.y;
}

bool _vectorEqual(XYPoint a, XYPoint b) {
  a = _vectorNormalize(a);
  b = _vectorNormalize(b);
  return (a.x == b.x && a.y == b.y);
}

double _vectorLength(XYPoint v) {
  return sqrt(v.x * v.x + v.y * v.y);
}

XYPoint _vectorNorm(XYPoint a) {
  return XYPoint(
    x: -a.y,
    y: a.x,
  );
}

XYPoint _vectorNormalize(XYPoint v) {
  double factor = _vectorLength(v);
  return XYPoint(
    x: v.x / factor,
    y: v.y / factor,
  );
}

XYPoint intersectVectors(XYLine l1, XYLine l2){
  if (_vectorEqual(l1.P2, l2.P2)) {
    return XYPoint(x: 0, y: 0);
  }


  try {
    double m = (l1.P1.y * l2.P2.x - l2.P1.y * l2.P2.x - l1.P1.x * l2.P2.y + l2.P1.x * l2.P2.y) / (l1.P2.x * l2.P2.y - l1.P2.y * l2.P2.x);

    return
      XYPoint(
          x: l1.P1.x + m * l1.P2.x,
          y: l1.P1.y + m * l1.P2.y
      );
  } catch (e) {
    return XYPoint(x:0, y:0);
  }
}

List<XYPoint> intersectTwoCircles(XYCircle a, XYCircle b){
  double ab0 = b.x - a.x;
  double ab1 = b.y - a.y;
  double c = sqrt(ab0 * ab0 + ab1* ab1);

  double ar = a.r;
  double br = b.r;

  if (c ==  0) {
    return [];
  }

  double x = (ar * ar + c * c - br * br) / (2 * c);
  double y = ar * ar - x * x;
  if (y < 0) {
    // no intersection
    return [];
  }

  if (y > 0) y = sqrt( y );

  // compute unit vectors ex and ey
  double ex0 = ab0 / c;
  double ex1 = ab1 / c;
  double ey0 = -ex1;
  double ey1 =  ex0;
  double q1x = a.x + x * ex0;
  double q1y = a.y + x * ex1;

  if (y == 0) {
    // one touch point
    return [XYPoint(x: q1x, y: q1y)];
  }

  // two intersections
  double q2x = q1x - y * ey0;
  double q2y = q1y - y * ey1;
  q1x += y * ey0;
  q1y += y * ey1;
  return [
    XYPoint(x: q1x, y: q1y),
    XYPoint(x: q2x, y: q2y)
  ];

}

double distance(XYPoint p, XYPoint q) {
  final dx = p.x - q.x;
  final dy = p.y - q.y;
  return sqrt(dx * dx + dy * dy);
}
