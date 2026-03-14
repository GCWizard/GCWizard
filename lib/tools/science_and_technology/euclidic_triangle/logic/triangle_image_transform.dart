part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class _Bounds {
  final double minX, maxX, minY, maxY;
  const _Bounds(this.minX, this.maxX, this.minY, this.maxY);

  bool contains(XYPoint p) {
    return minX.floor() <= p.x &&
        p.x <= maxX.ceil() &&
        minY.floor() <= p.y &&
        p.y <= maxY.ceil();
  }
}

class _Viewport {
  final double scale;
  final double offsetX;
  final double offsetY;
  final double canvasHeight;

  const _Viewport(this.scale, this.offsetX, this.offsetY, this.canvasHeight);
}

_Viewport _computeViewport(
  _Bounds b,
  double canvasWidth,
  double canvasHeight, {
  double padding = 20,
}) {
  final w = b.maxX - b.minX;
  final h = b.maxY - b.minY;

  final scaleX = (canvasWidth - 2 * padding) / w;
  final scaleY = (canvasHeight - 2 * padding) / h;

  // equal scaling in x-axis and y-axis (no distortion)
  final scale = min(scaleX, scaleY);

  // centric
  final offsetX = -b.minX * scale + (canvasWidth - w * scale) / 2;
  final offsetY = -b.minY * scale + (canvasHeight - h * scale) / 2;

  return _Viewport(scale, offsetX, offsetY, canvasHeight);
}

XYPoint? _transformPoint(XYPoint p, _Viewport v) {
  if (p.x.isNaN || p.y.isNaN) {
    return null;
  }
  return XYPoint(
    x: p.x * v.scale + v.offsetX,
    y: v.canvasHeight - (p.y * v.scale + v.offsetY),
  );
}

double? _transformRadius(XYCircle c, _Viewport v) {
  if (c.x.isNaN || c.y.isNaN) {
    return null;
  }
  final pCenter = _transformPoint(XYPoint(x: c.x, y: c.y), v);
  final pRight = _transformPoint(XYPoint(x: c.x + c.r, y: c.y), v);

  final dx = pRight!.x - pCenter!.x;
  final dy = pRight.y - pCenter.y;

  return sqrt(dx * dx + dy * dy);
}

// Assumed,your coordinate system ranges from
// in X: − 100  … 300
// in Y:    50  … 450
// Canvas is 512×512
//
// 4096 x 4096 max

// final bounds = Bounds(-100, 300, 50, 450);
// final vp = computeViewport(bounds, 512, 512);
//
// final p = XYPoint(x: 0, y: 100);
// final mapped = transform(p, vp);
