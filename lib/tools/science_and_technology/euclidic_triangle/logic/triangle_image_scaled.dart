/*
part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';


// ------------------------------------------------------------
// BASIC DATA TYPES
// ------------------------------------------------------------

// ------------------------------------------------------------
// TRIANGLE + KIMBERLING X1–X19
// ------------------------------------------------------------

class Triangle {
  final XYPoint A;
  final XYPoint B;
  final XYPoint C;

  const Triangle(this.A, this.B, this.C);

  double get a => (B - C).r;
  double get b => (A - C).r;
  double get c => (A - B).r;

  double get area {
    final s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  double get circumference => a + b + c;

  // X1 – Incenter
  XYPoint get X1 {
    final p = a + b + c;
    return XYPoint(
      x: (a * A.x + b * B.x + c * C.x) / p,
      y: (a * A.y + b * B.y + c * C.y) / p,
    );
  }

  // X2 – Centroid
  XYPoint get X2 =>
      XYPoint(x: (A.x + B.x + C.x) / 3, y: (A.y + B.y + C.y) / 3);

  // X3 – Circumcenter
  XYPoint get X3 {
    final d = 2 *
        (A.x * (B.y - C.y) +
            B.x * (C.y - A.y) +
            C.x * (A.y - B.y));

    final ux = ((A.x * A.x + A.y * A.y) * (B.y - C.y) +
        (B.x * B.x + B.y * B.y) * (C.y - A.y) +
        (C.x * C.x + C.y * C.y) * (A.y - B.y)) /
        d;

    final uy = ((A.x * A.x + A.y * A.y) * (C.x - B.x) +
        (B.x * B.x + B.y * B.y) * (A.x - C.x) +
        (C.x * C.x + C.y * C.y) * (B.x - A.x)) /
        d;

    return XYPoint(x: ux, y: uy);
  }

  // X4 – Orthocenter
  XYPoint get X4 {
    final D = (A.x - B.x) * (A.y - C.y) - (A.x - C.x) * (A.y - B.y);
    final Dx = (A.x * (A.y - C.y) - A.y * (A.x - C.x)) * (A.y - B.y) -
        (A.x * (A.y - B.y) - A.y * (A.x - B.x)) * (A.y - C.y);
    final Dy = (A.x - B.x) *
        (A.x * (A.y - C.y) - A.y * (A.x - C.x)) -
        (A.x - C.x) *
            (A.x * (A.y - B.y) - A.y * (A.x - B.x));

    return XYPoint(x: Dx / D, y: Dy / D);
  }

  // X5 – Nine-point center
  XYPoint get X5 => XYPoint(
    x: (X3.x + X4.x) / 2,
    y: (X3.y + X4.y) / 2,
  );

  // X6 – Symmedian point
  XYPoint get X6 {
    final wA = a * a;
    final wB = b * b;
    final wC = c * c;

    return XYPoint(
      x: (wA * A.x + wB * B.x + wC * C.x) / (wA + wB + wC),
      y: (wA * A.y + wB * B.y + wC * C.y) / (wA + wB + wC),
    );
  }

  // X7 – Gergonne point (simplified baryzentrische Form)
  XYPoint get X7 {
    final s = (a + b + c) / 2;
    return _bary(1 / (s - a), 1 / (s - b), 1 / (s - c));
  }

  // X8 – Nagel point
  XYPoint get X8 {
    final s = (a + b + c) / 2;
    return _bary(s - a, s - b, s - c);
  }

  // X9 – Mittenpunkt (Feuerbach)
  XYPoint get X9 => _bary(a * (b + c - a), b * (c + a - b), c * (a + b - c));

  // X10 – Spieker center
  XYPoint get X10 => _bary(a, b, c);

  // X11–X19 – classic barycentric Variants
  XYPoint get X11 => _bary(a, b, c);
  XYPoint get X12 => _bary(1 / a, 1 / b, 1 / c);
  XYPoint get X13 => _bary(a * a, b * b, c * c);
  XYPoint get X14 => _bary(1 / (a * a), 1 / (b * b), 1 / (c * c));
  XYPoint get X15 => _bary(b + c - a, c + a - b, a + b - c);
  XYPoint get X16 => _bary(1 / (b + c - a), 1 / (c + a - b), 1 / (a + b - c));
  XYPoint get X17 => _bary(a * (b + c - a), b * (c + a - b), c * (a + b - c));
  XYPoint get X18 =>
      _bary(1 / (a * (b + c - a)), 1 / (b * (c + a - b)), 1 / (c * (a + b - c)));
  XYPoint get X19 => _bary(a * (b - c), b * (c - a), c * (a - b));

  XYPoint _bary(double a, double b, double c) {
  final s = a + b + c;
  return XYPoint(
  x: (a * A.x + b * B.x + c * C.x) / s,
  y: (a * A.y + b * B.y + c * C.y) / s,
  );
  }

  List<XYPoint> get kimberlingX1to19 => [
  X1,
  X2,
  X3,
  X4,
  X5,
  X6,
  X7,
  X8,
  X9,
  X10,
  X11,
  X12,
  X13,
  X14,
  X15,
  X16,
  X17,
  X18,
  X19,
  ];
}

// ------------------------------------------------------------
// VIEWPORT SCALING
// ------------------------------------------------------------

class Viewport {
  final double scale;
  final double offsetX;
  final double offsetY;

  const Viewport(this.scale, this.offsetX, this.offsetY);
}

Viewport computeViewport(List<XYPoint> pts, double targetSize, double padding) {
  final xs = pts.map((p) => p.x);
  final ys = pts.map((p) => p.y);

  final minX = xs.reduce(min);
  final maxX = xs.reduce(max);
  final minY = ys.reduce(min);
  final maxY = ys.reduce(max);

  final w = maxX - minX;
  final h = maxY - minY;

  final scale = (targetSize - 2 * padding) / max(w, h);

  return Viewport(
    scale,
    -minX * scale + padding,
    -minY * scale + padding,
  );
}

XYPoint transform(XYPoint p, Viewport v) =>
    XYPoint(x: p.x * v.scale + v.offsetX, y: p.y * v.scale + v.offsetY);

// ------------------------------------------------------------
// TEXT (ParagraphBuilder) + LABEL
// ------------------------------------------------------------

ui.Paragraph _buildParagraph(String text, double size, ui.Color color) {
  final builder = ui.ParagraphBuilder(
    ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: size,
    ),
  )
    ..pushStyle(ui.TextStyle(color: color))
    ..addText(text);

  final paragraph = builder.build();
  paragraph.layout(const ui.ParagraphConstraints(width: double.maxFinite));
  return paragraph;
}

void drawLabel(
    ui.Canvas canvas,
    XYPoint p,
    String text,
    double size,
    ui.Color color,
    ) {
  final paragraph = _buildParagraph(text, size, color);
  final w = paragraph.maxIntrinsicWidth;
  final h = paragraph.height;
  // zentriert über dem Punkt
  canvas.drawParagraph(
    paragraph,
    ui.Offset(p.x - w / 2, p.y - h / 2),
  );
}

// ------------------------------------------------------------
// RENDERING + EXPORT ALS Uint8List (PNG)
// ------------------------------------------------------------

Future<Uint8List> renderTriangleToPngBytes(
    Triangle t, {
      double imageSize = 512,
    }) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(
    recorder,
    ui.Rect.fromLTWH(0, 0, imageSize, imageSize),
  );

  // Hintergrund
  final bgPaint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);
  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, imageSize, imageSize),
    bgPaint,
  );

  // Alle relevanten Punkte für Viewport
  final allPoints = <XYPoint>[
    t.A,
    t.B,
    t.C,
    ...t.kimberlingX1to19,
  ];

  final vp = computeViewport(allPoints, imageSize, 32);

  final A2 = transform(t.A, vp);
  final B2 = transform(t.B, vp);
  final C2 = transform(t.C, vp);

  final edgePaint = ui.Paint()
    ..color = const ui.Color(0xFF000000)
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = 2;

  // Dreiecksseiten
  canvas.drawLine(
    ui.Offset(A2.x, A2.y),
    ui.Offset(B2.x, B2.y),
    edgePaint,
  );
  canvas.drawLine(
    ui.Offset(B2.x, B2.y),
    ui.Offset(C2.x, C2.y),
    edgePaint,
  );
  canvas.drawLine(
    ui.Offset(C2.x, C2.y),
    ui.Offset(A2.x, A2.y),
    edgePaint,
  );

  // Eckpunkte
  final vertexPaint = ui.Paint()
    ..color = const ui.Color(0xFF0000FF)
    ..style = ui.PaintingStyle.fill;

  void drawPoint(XYPoint p, ui.Paint paint, double r) {
    canvas.drawCircle(ui.Offset(p.x, p.y), r, paint);
  }

  drawPoint(A2, vertexPaint, 4);
  drawPoint(B2, vertexPaint, 4);
  drawPoint(C2, vertexPaint, 4);

  drawLabel(canvas, A2, 'A', 14, const ui.Color(0xFF000000));
  drawLabel(canvas, B2, 'B', 14, const ui.Color(0xFF000000));
  drawLabel(canvas, C2, 'C', 14, const ui.Color(0xFF000000));

  // Kimberling-Punkte X1–X19
  final kpPaint = ui.Paint()
    ..color = const ui.Color(0xFFFF0000)
    ..style = ui.PaintingStyle.fill;

  final kp = t.kimberlingX1to19;
  for (var i = 0; i < kp.length; i++) {
    final pT = transform(kp[i], vp);
    print(i.toString()+' '+kp[i].x.toString()+' '+kp[i].y.toString()+' '+pT.x.toString()+' '+pT.y.toString());
    if (pT.x.toString() != 'NaN'  && pT.y.toString() != 'NaN') {
      drawPoint(pT, kpPaint, 3);
      drawLabel(
        canvas,
        pT,
        'X${i + 1}',
        10,
        const ui.Color(0xFF444444),
      );
    }
  }

  // Bild erzeugen
  final picture = recorder.endRecording();
  final img = await picture.toImage(
    imageSize.toInt(),
    imageSize.toInt(),
  );
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
*/
