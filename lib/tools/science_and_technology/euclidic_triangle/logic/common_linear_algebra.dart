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

// XYPoint _vectorDiv(XYPoint a, double s) {
//   return XYPoint(
//     x: a.x / s,
//     y: a.y / s,
//   );
// }

XYPoint _vectorMult(XYPoint a, double s) {
  return XYPoint(
    x: a.x * s,
    y: a.y * s,
  );
}

double _vectorProductDot(XYPoint a, XYPoint b) {
  return a.x * b.x + a.y * b.y;
}

// bool _vectorParallel(XYPoint a, XYPoint b) {
//   a = _vectorNormalize(a);
//   b = _vectorNormalize(b);
//   return (a.x.abs() == b.x.abs() && a.y.abs() == b.y.abs());
// }

// bool _vectorEqual(XYPoint a, XYPoint b) {
//   a = _vectorNormalize(a);
//   b = _vectorNormalize(b);
//   return (a.x == b.x && a.y == b.y);
// }

double _vectorLength(XYPoint v) {
  return sqrt(v.x * v.x + v.y * v.y);
}

// XYPoint _vectorNorm(XYPoint a) {
//   return XYPoint(
//     x: -a.y,
//     y: a.x,
//   );
// }

XYPoint _vectorNormalize(XYPoint v) {
  double factor = _vectorLength(v);
  return XYPoint(
    x: v.x / factor,
    y: v.y / factor,
  );
}

XYPoint? intersectVectors(XYLine l1, XYLine l2) {
  return l1.intersectLine(l2);
}

bool vectorContainsPoint(XYLine l, XYPoint p) {
  return l.containsPoint(p);
}


List<XYPoint>? intersectTwoCircles(XYCircle a, XYCircle b) {
  return a.intersectCircle(b);
}

bool circleContainsPoint(XYCircle c, XYPoint p) {
  return c.containsPoint(p);
}

bool onCircumference(XYCircle c, XYPoint p) {
  return c.onCircumference(p);
}

double distance(XYPoint p, XYPoint q) {
  return p.distanceToPoint(q);
}
