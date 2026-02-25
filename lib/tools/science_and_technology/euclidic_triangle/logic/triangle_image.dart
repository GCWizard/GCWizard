part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

class _TickInfo {
  final double step;
  final double start;
  final double end;
  const _TickInfo(this.step, this.start, this.end);
}

_TickInfo _computeNiceTicks(double minVal, double maxVal, int maxTicks) {
  final range = _niceNumber(maxVal - minVal, round: false);
  final step = _niceNumber(range / (maxTicks - 1), round: true);

  final start = (minVal / step).floor() * step;
  final end = (maxVal / step).ceil() * step;

  return _TickInfo(step, start, end);
}

double _niceNumber(double range, {bool round = false}) {
  final exponent = (log(range) / ln10).floor();
  final fraction = range / pow(10, exponent);

  double niceFraction;

  if (round) {
    if (fraction < 1.5) {
      niceFraction = 1;
    } else if (fraction < 3) {
      niceFraction = 2;
    } else if (fraction < 7) {
      niceFraction = 5;
    } else {
      niceFraction = 10;
    }
  } else {
    if (fraction <= 1) {
      niceFraction = 1;
    } else if (fraction <= 2) {
      niceFraction = 2;
    } else if (fraction <= 5) {
      niceFraction = 5;
    } else {
      niceFraction = 10;
    }
  }

  return niceFraction * pow(10, exponent);
}

List<Offset> _intersectLineWithRect(
    XYPoint p1, XYPoint p2, _Bounds bounds, _Viewport v) {
  final List<Offset> pts = [];

  // Kanten des Rechtecks
  final edges = [
    [
      XYPoint(x: bounds.minX, y: bounds.maxY),
      XYPoint(x: bounds.maxX, y: bounds.maxY)
    ], // top
    [
      XYPoint(x: bounds.maxX, y: bounds.maxY),
      XYPoint(x: bounds.maxX, y: bounds.minY)
    ], // right
    [
      XYPoint(x: bounds.maxX, y: bounds.minY),
      XYPoint(x: bounds.minX, y: bounds.minY)
    ], // bottom
    [
      XYPoint(x: bounds.minX, y: bounds.minY),
      XYPoint(x: bounds.minX, y: bounds.maxY)
    ], // left
  ];

  for (final edge in edges) {
    final ip = intersectVectors(
        XYLine(P1: p1, P2: p2), XYLine(P1: edge[0], P2: edge[1]));
    if (ip != null) {
      final c = _transformPoint(ip, v);
      if (bounds.contains(ip)) pts.add(Offset(c.x, c.y));
    }
  }
  return pts;
}

void _drawEulerLine(
    Canvas canvas, XYPoint X2, XYPoint X4, _Bounds b, _Viewport v) {
  final paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 1.0;

  if (doubleEquals(X2.x, X4.x) && doubleEquals(X2.y, X4.y)) {
    final p = _transformPoint(X2, v);
    canvas.drawCircle(Offset(p.x, p.y), 6, paint);
    return;
  }

  final intersections = _intersectLineWithRect(X2, X4, b, v);

  if (intersections.length == 2) {
    canvas.drawLine(intersections[0], intersections[1], paint);
  } else {
    final p1 = _transformPoint(X2, v);
    final p2 = _transformPoint(X4, v);
    canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  }
}

void _drawLabel(Canvas canvas, Offset pos, String text) {
  final builder = ParagraphBuilder(
    ParagraphStyle(
      fontSize: 10,
      textAlign: TextAlign.center,
    ),
  )..addText(text);

  final paragraph = builder.build()
    ..layout(const ParagraphConstraints(width: 40));

  canvas.drawParagraph(paragraph, Offset(pos.dx - 20, pos.dy + 5));
}

void _drawAxesWithAutoTicks(
  Canvas canvas,
  _Bounds b,
  _Viewport v, {
  int maxTicks = 1,
  double axisWidth = 1.2,
  Color axisColor = const Color(0xFF555555),
  double tickScreenSize = 6.0,
}) {
  final paint = Paint()
    ..color = axisColor
    ..strokeWidth = axisWidth;

  final minX = b.minX;
  final maxX = b.maxX;
  final minY = b.minY;
  final maxY = b.maxY;

  // position of axis
  final axisY = (minY <= 0 && maxY >= 0) ? 0.0 : minY;
  final axisX = (minX <= 0 && maxX >= 0) ? 0.0 : minX;

  // draw axis
  final xStart = _transformPoint(XYPoint(x: minX, y: axisY), v);
  final xEnd = _transformPoint(XYPoint(x: maxX, y: axisY), v);
  canvas.drawLine(Offset(xStart.x, xStart.y), Offset(xEnd.x, xEnd.y), paint);

  final yStart = _transformPoint(XYPoint(x: axisX, y: minY), v);
  final yEnd = _transformPoint(XYPoint(x: axisX, y: maxY), v);
  canvas.drawLine(Offset(yStart.x, yStart.y), Offset(yEnd.x, yEnd.y), paint);

  // ---- Ticks X ----
  final xt = _computeNiceTicks(minX, maxX, maxTicks);
  for (double x = xt.start; x <= xt.end - xt.step; x += xt.step) {
    final p1 =
        _transformPoint(XYPoint(x: x, y: axisY - tickScreenSize / v.scale), v);
    final p2 =
        _transformPoint(XYPoint(x: x, y: axisY + tickScreenSize / v.scale), v);

    final labelPos = _transformPoint(XYPoint(x: x, y: axisY), v);

    if (minX <= x && x <= maxX) {
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
      _drawLabel(canvas, Offset(labelPos.x, labelPos.y + 4), x.toString());
    }
  }

  // ---- Ticks Y ----
  final yt = _computeNiceTicks(minY, maxY, 20);
  for (double y = yt.start; y <= yt.end - yt.step; y += yt.step) {
    final p1 =
        _transformPoint(XYPoint(x: axisX - tickScreenSize / v.scale, y: y), v);
    final p2 =
        _transformPoint(XYPoint(x: axisX + tickScreenSize / v.scale, y: y), v);

    final labelPos = _transformPoint(XYPoint(x: axisX, y: y), v);

    if (minY <= y && y <= maxY) {
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
      _drawLabel(canvas, Offset(labelPos.x - 20, labelPos.y - 6), y.toString());
    }
  }
}

Future<Uint8List> triangleData2Image({
  required Triangle triangle,
  required Map<String, String> labels,
}) async {
  const BOUNDS = 50.0;

  const MAXWIDTH = 5300.0;
  const MAXHEIGHT = 6000.0;

  const POINT = 2.0;
  const LINE = 1.0;

  const FONTSIZE = 12.0;
  const WIDTHLEGEND = 700.0;

  const LABELLENGTH = 30;
  const DIST = '     ';

  const constraintsLegend =
      ui.ParagraphConstraints(width: WIDTHLEGEND);

  double minX = double.maxFinite;
  double maxX = -1.0 * double.maxFinite;
  double minY = double.maxFinite;
  double maxY = -1.0 * double.maxFinite;

  XYPoint A = triangle.A;
  XYPoint B = triangle.B;
  XYPoint C = triangle.C;
  double area = triangle.area;
  double circumference = triangle.circumference;
  double a = triangle.sides.a;
  double b = triangle.sides.b;
  double c = triangle.sides.c;
  double alpha = triangle.angles.alpha;
  double beta = triangle.angles.beta;
  double gamma = triangle.angles.gamma;
  XYCircle IC = triangle.X1; // inner circle
  XYPoint CG = triangle.X2; // centroid
  XYCircle CC = triangle.X3; // circum circle
  XYPoint O = triangle.X4; // orthocenter
  XYPoint NP = triangle.X5; // nine point center
  XYPoint L = triangle.X6; // lemoine
  XYPoint G = triangle.X7; // gergonne
  XYPoint N = triangle.X8; // nagel
  XYPoint M = triangle.X9; // mitten
  XYPoint S = triangle.X10; // spieker
  XYPoint X11 = triangle.X11; //
  XYPoint F = triangle.X12; //feuerbach
  XYPoint X13 = triangle.X13; //
  XYPoint X14 = triangle.X14; //
  XYPoint X15 = triangle.X15; //
  XYPoint X16 = triangle.X16; //
  XYPoint N1 = triangle.X17; // napoleon I
  XYPoint N2 = triangle.X18; // napoleon II
  XYPoint X19 = triangle.X19; //
  XYPoint X20 = triangle.X20; //
  XYPoint X21 = triangle.X21; //
  XYPoint X22 = triangle.X22; //
  XYPoint MSA = triangle.sidesMidPoint[0]; // mid side a
  XYPoint MSB = triangle.sidesMidPoint[1]; // mid side b
  XYPoint MSC = triangle.sidesMidPoint[2]; // mid side c
  XYPoint AA = triangle.altitudesBasePoint[0]; // altitude base a
  XYPoint AB = triangle.altitudesBasePoint[1]; // altitude base b
  XYPoint AC = triangle.altitudesBasePoint[2]; // altitude base c
  XYCircle FC = triangle.feuerbachCircle; // feuerbach circle
  XYCircle EA = triangle.exCircles[0]; // ex circle a
  XYCircle EB = triangle.exCircles[1]; // ex circle b
  XYCircle EC = triangle.exCircles[2]; // ex circle c
  XYPoint ETA = triangle.exCirclesTouchPoints[0]; // touchpoint ex circle a
  XYPoint ETB = triangle.exCirclesTouchPoints[1]; // touchpoint ex circle b
  XYPoint ETC = triangle.exCirclesTouchPoints[2]; // touchpoint ex circle c
  XYPoint ITA = triangle.inCirclesTouchPoints[0]; // touchpoint in circle a
  XYPoint ITB = triangle.inCirclesTouchPoints[1]; // touchpoint in circle b
  XYPoint ITC = triangle.inCirclesTouchPoints[2]; // touchpoint in circle c
  XYPoint FTA =
      triangle.inFeuerbachCircleTouchPoints[0]; // touchpoint feuerbach circle a
  XYPoint FTB =
      triangle.inFeuerbachCircleTouchPoints[1]; // touchpoint in feuerbach b
  XYPoint FTC =
      triangle.inFeuerbachCircleTouchPoints[2]; // touchpoint in feuerbach c

  // calculating minX, mxX, minY, maxY for bounds and viewport
  List<XYPoint> points = [
    triangle.A,
    triangle.B,
    triangle.C,
    triangle.X2,
    triangle.X4,
    triangle.X5,
    triangle.X6,
    triangle.X7,
    triangle.X8,
    triangle.X9,
    triangle.X10,
    triangle.X11,
    triangle.X12,
    triangle.X13,
    triangle.X14,
    triangle.X15,
    triangle.X16,
    triangle.X17,
    triangle.X18,
    triangle.X19,
  ];

  List<XYCircle> circles = [
    triangle.X1,
    triangle.X3,
    triangle.feuerbachCircle,
    triangle.exCircles[0],
    triangle.exCircles[1],
    triangle.exCircles[2],
  ];

  for (XYCircle circle in circles) {
    if (circle.x - circle.r < minX) minX = (circle.x - circle.r);
    if (circle.x + circle.r > maxX) maxX = (circle.x + circle.r);
    if (circle.y - circle.r < minY) minY = (circle.y - circle.r);
    if (circle.y + circle.r > maxY) maxY = (circle.y + circle.r);
  }

  for (XYPoint point in points) {
    if (point.x < minX) minX = point.x;
    if (point.x > maxX) maxX = point.x;
    if (point.y < minY) minY = point.y;
    if (point.y > maxY) maxY = point.y;
  }

  final bounds =
      _Bounds(minX - BOUNDS, maxX + BOUNDS, minY - BOUNDS, maxY + BOUNDS);
  final vp =
      _computeViewport(bounds, MAXWIDTH - WIDTHLEGEND, MAXHEIGHT - 2 * BOUNDS);

  // starting drawing
  final canvasRecorder = ui.PictureRecorder();
  final canvas =
      ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, MAXWIDTH, MAXHEIGHT));

  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = LINE;

  // draw background
  canvas.drawRect(Rect.fromLTWH(0, 0, MAXWIDTH, MAXHEIGHT), paint);

  // draw axis
  _drawAxesWithAutoTicks(canvas, bounds, vp, maxTicks: 50);

  // draw triangle
  // colors according to https://de.wikipedia.org/wiki/Ausgezeichnete_Punkte_im_Dreieck#/media/Datei:Linien_am_Dreieck.svg
  paint.style = PaintingStyle.stroke;

  // draw sides a b c
  paint.color = Colors.blueAccent;
  var p1 = _transformPoint(triangle.A, vp);
  var p2 = _transformPoint(triangle.B, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p2 = _transformPoint(triangle.C, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p1 = _transformPoint(triangle.B, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);

  // draw altitudes ha hb hc
  paint.color = Colors.orange;
  p1 = _transformPoint(triangle.A, vp);
  p2 = _transformPoint(AA, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p1 = _transformPoint(triangle.B, vp);
  p2 = _transformPoint(AB, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p1 = _transformPoint(triangle.C, vp);
  p2 = _transformPoint(AC, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);

  // draw mid sides
  paint.color = Colors.orange.shade700;
  p1 = _transformPoint(triangle.A, vp);
  p2 = _transformPoint(MSA, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p1 = _transformPoint(triangle.B, vp);
  p2 = _transformPoint(MSB, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  p1 = _transformPoint(triangle.C, vp);
  p2 = _transformPoint(MSC, vp);
  canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);

  // draw points
  // draw Triangle points
  paint.color = Colors.blueAccent;
  p1 = _transformPoint(A, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'A');
  p1 = _transformPoint(B, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'B');
  p1 = _transformPoint(C, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'C');

  // draw Touchpoints exCircles
  paint.color = Colors.green;
  p1 = _transformPoint(ETA, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(ETB, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(ETC, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw Touchpoints inCircles
  paint.color = Colors.green.shade900;
  p1 = _transformPoint(ITA, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(ITB, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(ITC, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw Touchpoints FeuerbachCircle
  paint.color = Colors.purple;
  p1 = _transformPoint(FTA, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(FTB, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(FTC, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw exCircles center points
  p1 = _transformPoint(XYPoint(x: EA.x, y: EA.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'exA');
  p1 = _transformPoint(XYPoint(x: EB.x, y: EB.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'exB');
  p1 = _transformPoint(XYPoint(x: EC.x, y: EC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'exC');

  // draw Mid side base Points
  paint.color = Colors.orange;
  p1 = _transformPoint(MSA, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(MSB, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(MSC, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw Altitude base Points
  p1 = _transformPoint(AA, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(AB, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  p1 = _transformPoint(AC, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw Feuerbach circle center point
  paint.color = Colors.purple;
  p1 = _transformPoint(XYPoint(x: FC.x, y: FC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);

  // draw Clark Kimberling points
  paint.color = Colors.red;
  p1 = _transformPoint(XYPoint(x: IC.x, y: IC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X1');

  p1 = _transformPoint(CG, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X2');

  p1 = _transformPoint(XYPoint(x: CC.x, y: CC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X3');

  p1 = _transformPoint(O, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X4');

  p1 = _transformPoint(NP, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X5');

  p1 = _transformPoint(L, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X6');

  p1 = _transformPoint(G, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X7');

  p1 = _transformPoint(M, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X8');

  p1 = _transformPoint(N, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X9');

  p1 = _transformPoint(S, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X10');

  p1 = _transformPoint(X11, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X11');

  p1 = _transformPoint(F, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X12');

  p1 = _transformPoint(X13, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X13');

  p1 = _transformPoint(X14, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X14');

  p1 = _transformPoint(X15, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X15');

  p1 = _transformPoint(X16, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X16');

  p1 = _transformPoint(N1, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X17');

  p1 = _transformPoint(N2, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X18');

  p1 = _transformPoint(X19, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X19');

  p1 = _transformPoint(X20, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X20');

  p1 = _transformPoint(X21, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X21');

  p1 = _transformPoint(X22, vp);
  canvas.drawCircle(Offset(p1.x, p1.y), POINT, paint);
  _drawLabel(canvas, Offset(p1.x, p1.y), 'X22');

  // draw Circles
  paint.color = Colors.green.shade900;
  p1 = _transformPoint(XYPoint(x: IC.x, y: IC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(IC, vp), paint);
  p1 = _transformPoint(XYPoint(x: CC.x, y: CC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(CC, vp), paint);

  paint.color = Colors.green;
  p1 = _transformPoint(XYPoint(x: EA.x, y: EA.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(EA, vp), paint);
  p1 = _transformPoint(XYPoint(x: EB.x, y: EB.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(EB, vp), paint);
  p1 = _transformPoint(XYPoint(x: EC.x, y: EC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(EC, vp), paint);

  paint.color = Colors.purple;
  p1 = _transformPoint(XYPoint(x: FC.x, y: FC.y), vp);
  canvas.drawCircle(Offset(p1.x, p1.y), _transformRadius(FC, vp), paint);

  // draw Euler line
  if (!triangleIsEquilateral(a, b, c)) {
    _drawEulerLine(canvas, CG, O, bounds, vp);
  }

  // draw legend
  paint.color = Colors.white;
  paint.style = PaintingStyle.fill;
  canvas.drawRect(Rect.fromLTWH(0, 0, WIDTHLEGEND, 62 * FONTSIZE * 1.2), paint);

  paint.color = Colors.black;
  final textStyle = ui.TextStyle(
    color: paint.color,
    fontSize: FONTSIZE,
    fontFamily: 'Courier',
  );
  final paragraphStyle = ui.ParagraphStyle(
    textDirection: ui.TextDirection.ltr,
    textAlign: TextAlign.right,
  );

  var paragraphBuilderLegend = ui.ParagraphBuilder(paragraphStyle);
  paragraphBuilderLegend.pushStyle(textStyle);
  paragraphBuilderLegend.addText(labels['LEGEND']! +
      (' ').padRight(38, '-') +
      '\n' +
      '\n' +
      labels['COORDINATES']! +
      (' ').padRight(38, '-') +
      '\n' +
      'A'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      A.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      A.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'B'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      B.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      B.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'C'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      C.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      C.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      '\n' +
      labels['SIDES']! +
      (' ').padRight(38, '-') +
      '\n' +
      'a'.padLeft(LABELLENGTH, ' ') +
      DIST +
      a.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      'b'.padLeft(LABELLENGTH, ' ') +
      DIST +
      b.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      'c'.padLeft(LABELLENGTH, ' ') +
      DIST +
      c.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      '\n' +
      labels['ANGLES']! +
      (' ').padRight(38, '-') +
      '\n' +
      'α'.padLeft(LABELLENGTH, ' ') +
      DIST +
      alpha.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      'β'.padLeft(LABELLENGTH, ' ') +
      DIST +
      beta.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      'γ'.padLeft(LABELLENGTH, ' ') +
      DIST +
      gamma.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      '\n' +
      labels['TYPE']!.padLeft(LABELLENGTH, ' ') +
      DIST +
      labels['DESCRIPTION']!.padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      '\n' +
      labels['AREA']!.padLeft(LABELLENGTH, ' ') +
      DIST +
      area.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      labels['CIRCUMFERENCE']!.padLeft(LABELLENGTH, ' ') +
      DIST +
      circumference.toStringAsFixed(2).padLeft(21, ' ') +
      '           ' + NBSP + '\n' +
      '\n' +
      labels['SIDESMIDPOINTS']! +
      (' ').padRight(38, '-') +
      '\n' +
      'a'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      MSA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      MSA.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'b'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      MSB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      MSB.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'c'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      MSC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      MSC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      '\n' +
      labels['ALTITUDESBASEPOINTS']! +
      (' ').padRight(38, '-') +
      '\n' +
      'a'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      AA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      AA.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'b'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      AB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      AB.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      'c'.padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      AC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      AC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      '\n' +
      labels['TOUCHPOINTS']! +
      (' ').padRight(38, '-') +
      '\n' +
      (labels['EXCIRCLE']! + ' a').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ETA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ETA.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' b').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ETB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ETB.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' c').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ETC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ETC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['INCIRCLE']! + ' a').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ITA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ITA.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' b').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ITB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ITB.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' c').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      ITC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      ITC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['FEUERBACHCIRCLE']! + ' a').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      FTA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      FTA.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' b').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      FTB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      FTB.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (' c').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      FTC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      FTC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      '\nClark Kimberling, Encyclopedia of Triangle Centers' +
      (' ').padRight(38, '-') +
      '\n' +
      (labels['X1']! + ' X01').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      IC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      IC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X2']! + ' X02').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      CG.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      CG.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X3']! + ' X03').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      CC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      CC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X4']! + ' X04').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      O.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      O.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X5']! + ' X05').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      FC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      FC.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X6']! + ' X06').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      L.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      L.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X7']! + ' X07').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      G.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      G.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X8']! + ' X08').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      N.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      N.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X9']! + ' X09').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      M.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      M.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X10']! + ' X10').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      S.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      S.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X11']! + ' X11').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X11.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X11.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X12']! + ' X12').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      F.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      F.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X13']! + ' X13').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X13.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X13.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X14']! + ' X14').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X14.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X14.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X15']! + ' X15').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X15.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X15.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X16']! + ' X16').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X16.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X16.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X17']! + ' X17').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      N1.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      N1.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X18']! + ' X18').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      N2.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      N2.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X19']! + ' X19').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X19.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X19.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X20']! + ' X20').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X20.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X20.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X21']! + ' X21').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X21.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X21.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      (labels['X22']! + ' X22').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      X22.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      X22.y.toStringAsFixed(2).padLeft(9, ' ') +
      ')           ' + NBSP + '\n' +
      '\n' +
      labels['CIRCLES']! +
      (' ').padRight(38, '-') +
      '\n' +
      (labels['INCIRCLE']! + ' X1').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      IC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      IC.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      IC.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      (labels['CIRCUMCIRCLE']! + ' X3').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      CC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      CC.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      CC.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      (labels['FEUERBACHCIRCLE']! + ' X5').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      FC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      FC.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      FC.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      (labels['EXCIRCLE']! + ' xA').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      EA.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      EA.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      EA.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      (labels['EXCIRCLE']! + ' xB').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      EB.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      EB.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      EB.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      (labels['EXCIRCLE']! + ' xC').padLeft(LABELLENGTH, ' ') +
      DIST +
      '(' +
      EC.x.toStringAsFixed(2).padLeft(9, ' ') +
      '|' +
      EC.y.toStringAsFixed(2).padLeft(9, ' ') +
      '), r = ' +
      EC.r.toStringAsFixed(2).padLeft(6, ' ') +
      '\n' +
      '');
  final paragraphLegend = paragraphBuilderLegend.build();
  paragraphLegend.layout(constraintsLegend);
  canvas.drawParagraph(paragraphLegend, Offset(MAXWIDTH - WIDTHLEGEND - BOUNDS, BOUNDS));

  try {
    final img = await canvasRecorder
        .endRecording()
        //.toImage(width.floor(), height.floor());
        .toImage(MAXWIDTH.floor(), MAXHEIGHT.floor());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return trimNullBytes(data!.buffer.asUint8List());
  } catch (e) {
    return Uint8List.fromList([]);
  }
}
