part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';


class Bounds {
  final double minX, maxX, minY, maxY;
  const Bounds(this.minX, this.maxX, this.minY, this.maxY);
}


class Viewport {
  final double scale;
  final double offsetX;
  final double offsetY;

  const Viewport(this.scale, this.offsetX, this.offsetY);
}

Viewport computeViewport(
    Bounds b,
    double canvasWidth,
    double canvasHeight, {
      double padding = 20,
    }) {
  final w = b.maxX - b.minX;
  final h = b.maxY - b.minY;

  final scaleX = (canvasWidth - 2 * padding) / w;
  final scaleY = (canvasHeight - 2 * padding) / h;

  // Gleichmäßige Skalierung (keine Verzerrung)
  final scale = min(scaleX, scaleY);

  // Zentrierung
  final offsetX = -b.minX * scale + (canvasWidth - w * scale) / 2;
  final offsetY = -b.minY * scale + (canvasHeight - h * scale) / 2;

  return Viewport(scale, offsetX, offsetY);
}


XYPoint transform(XYPoint p, Viewport v) {
  return XYPoint(
    x: p.x * v.scale + v.offsetX,
    y: p.y * v.scale + v.offsetY,
  );
}

// Angenommen,dein Koordinatensystem geht von
// in X: − 100  … 300
// in Y:    50  … 450
// Canvas ist 512×512
//
// 4096 x 4096 max

// final bounds = Bounds(-100, 300, 50, 450);
// final vp = computeViewport(bounds, 512, 512);
//
// final p = XYPoint(x: 0, y: 100);
// final mapped = transform(p, vp);



