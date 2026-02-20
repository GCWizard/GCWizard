part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Future<Uint8List > triangleData2Image({
  required Triangle triangle,
  required Map<String, String> labels,
}) async {

  const BOUNDS = 100.0;
  const SCALE = 5.0;

  const POINT = 2.0;
  const LINE = 1.0;

  const FONTSIZE = 10.0;
  const WIDTHLEGEND = 330.0;

  const LABELLENGTH = 30;
  const DIST = '     ';

  const constraintsLegend = ui.ParagraphConstraints(width: WIDTHLEGEND + BOUNDS);
  const constraintsAxisX = ui.ParagraphConstraints(width: 50);
  const constraintsAxisY = ui.ParagraphConstraints(width: 50);

  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  XYPoint A = triangle.A;
  XYPoint B = triangle.B;
  XYPoint C = triangle.C;
  double a = triangle.sides.a;
  double b = triangle.sides.b;
  double c = triangle.sides.c;
  double alpha = triangle.angles.alpha;
  double beta = triangle.angles.beta;
  double gamma = triangle.angles.gamma;
  double area = triangle.area;
  double circumference = triangle.circumference;
  XYCircle IC = triangle.X1; // inner circle
  XYPoint CG= triangle.X2; // centroid
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

  if (triangle.A.x < minX) minX = triangle.A.x; if (triangle.A.x > maxX) maxX = triangle.A.x;
  if (triangle.B.x < minX) minX = triangle.B.x; if (triangle.B.x > maxX) maxX = triangle.B.x;
  if (triangle.C.x < minX) minX = triangle.C.x; if (triangle.C.x > maxX) maxX = triangle.C.x;
  if (O.x < minX) minX = O.x; if (O.x > maxX) maxX = O.x;
  if (G.x < minX) minX = G.x; if (G.x > maxX) maxX = G.x;
  if (L.x < minX) minX = L.x; if (L.x > maxX) maxX = L.x;
  if (CG.x < minX) minX = CG.x; if (CG.x > maxX) maxX = CG.x;
  if (F.x < minX) minX = F.x; if (F.x > maxX) maxX = F.x;
  if (M.x < minX) minX = M.x; if (M.x > maxX) maxX = M.x;
  if (N.x < minX) minX = N.x; if (N.x > maxX) maxX = N.x;
  if (MSA.x < minX) minX = MSA.x; if (MSA.x > maxX) maxX = MSA.x;
  if (MSB.x < minX) minX = MSB.x; if (MSB.x > maxX) maxX = MSB.x;
  if (MSC.x < minX) minX = MSC.x; if (MSC.x > maxX) maxX = MSC.x;
  if (AA.x < minX) minX = AA.x; if (AA.x > maxX) maxX = AA.x;
  if (AB.x < minX) minX = AB.x; if (AB.x > maxX) maxX = AB.x;
  if (AC.x < minX) minX = AC.x; if (AC.x > maxX) maxX = AC.x;
  if (IC.x < minX) minX = IC.x; if (IC.x > maxX) maxX = IC.x;
  if (CC.x - CC.r < minX) minX = CC.x - CC.r; if (CC.x + CC.r > maxX) maxX = CC.x + CC.r;
  if (FC.x - FC.r < minX) minX = FC.x - FC.r; if (FC.x + FC.r > maxX) maxX = FC.x + FC.r;
  if (EA.x - EA.r < minX) minX = EA.x - EA.r; if (EA.x + EA.r > maxX) maxX = EA.x + EA.r;
  if (EB.x - EB.r < minX) minX = EB.x - EB.r; if (EB.x + EB.r > maxX) maxX = EB.x + EB.r;
  if (EC.x - EC.r < minX) minX = EC.x - EC.r; if (EC.x + EC.r > maxX) maxX = EC.x + EC.r;

  if (triangle.A.y < minY) minY = triangle.A.y; if (triangle.A.y > maxY) maxY = triangle.A.x;
  if (triangle.B.y < minY) minY = triangle.B.y; if (triangle.B.y > maxY) maxY = triangle.B.y;
  if (triangle.C.y < minY) minY = triangle.C.y; if (triangle.C.y > maxY) maxY = triangle.C.y;
  if (O.y < minY) minY = O.y; if (O.y > maxY) maxY = O.y;
  if (G.y < minY) minY = G.y; if (G.y > maxY) maxY = G.y;
  if (L.y < minY) minY = L.y; if (L.y > maxY) maxY = L.y;
  if (CG.y < minY) minY = CG.y; if (CG.y > maxY) maxY = CG.y;
  if (F.y < minY) minY = F.y; if (F.y > maxY) maxY = F.y;
  if (M.y < minY) minY = M.y; if (M.y > maxY) maxY = M.y;
  if (N.y < minY) minY = N.y; if (N.y > maxY) maxY = N.y;
  if (MSA.y < minY) minY = MSA.y; if (MSA.y > maxY) maxY = MSA.y;
  if (MSB.y < minY) minY = MSB.y; if (MSB.y > maxY) maxY = MSB.y;
  if (MSC.y < minY) minY = MSC.y; if (MSC.y > maxY) maxY = MSC.y;
  if (AA.y < minY) minY = AA.y; if (AA.y > maxY) maxY = AA.y;
  if (AB.y < minY) minY = AB.y; if (AB.y > maxY) maxY = AB.y;
  if (AC.y < minY) minY = AC.y; if (AC.y > maxY) maxY = AC.y;
  if (IC.y < minY) minY = IC.y; if (IC.y > maxY) maxY = IC.y;
  if (CC.y - CC.r < minY) minY = CC.y - CC.r; if (CC.y + CC.r > maxY) maxY = CC.y + CC.r;
  if (FC.y - FC.r < minY) minY = FC.y - FC.r; if (FC.y + FC.r > maxY) maxY = FC.y + FC.r;
  if (EA.y - EA.r < minY) minY = EA.y - EA.r; if (EA.y + EA.r > maxY) maxY = EA.y + EA.r;
  if (EB.y - EB.r < minY) minY = EB.y - EB.r; if (EB.y + EB.r > maxY) maxY = EB.y + EB.r;
  if (EC.y - EC.r < minY) minY = EC.y - EC.r; if (EC.y + EC.r > maxY) maxY = EC.y + EC.r;

  double width = BOUNDS + 2 * max(minX.abs(), maxX.abs()) * SCALE + BOUNDS;
  double height = BOUNDS + 2 * max(minY.abs(), maxY.abs()) * SCALE + BOUNDS;

  print('----- width $width height $height');
  double offsetX = width / 2;
  double offsetY = height / 2;

  final canvasRecorder = ui.PictureRecorder();
  final canvas = ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, width, height));

  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = LINE;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  // draw axis
  paint.color = Colors.black;
  paint.strokeWidth = 0.5;

  canvas.drawLine(Offset(BOUNDS, offsetY), Offset(width - BOUNDS, offsetY), paint);
  canvas.drawLine(Offset(offsetX, BOUNDS), Offset(offsetX, height - BOUNDS), paint);

  // draw measurement x axis
  final textStyle = ui.TextStyle(
    color: paint.color,
    fontSize: FONTSIZE,
    fontFamily: 'Courier',
  );
  var paragraphStyle = ui.ParagraphStyle(
    textDirection: ui.TextDirection.ltr,
    textAlign: TextAlign.center,
  );

  int i = 1;
  while (offsetX + i * SCALE < width - BOUNDS) {
    if (i % 10 == 0) {
      canvas.drawLine(Offset(offsetX + i * SCALE, offsetY), Offset(offsetX + i * SCALE, offsetY + 6), paint);
      canvas.drawLine(Offset(offsetX - i * SCALE, offsetY), Offset(offsetX - i * SCALE, offsetY + 6), paint);
    } else if (i % 5 == 0){
      canvas.drawLine(Offset(offsetX + i * SCALE, offsetY), Offset(offsetX + i * SCALE, offsetY + 3), paint);
      canvas.drawLine(Offset(offsetX - i * SCALE, offsetY), Offset(offsetX - i * SCALE, offsetY + 3), paint);
    } else {
      canvas.drawLine(Offset(offsetX + i * SCALE, offsetY), Offset(offsetX + i * SCALE, offsetY + 1.5), paint);
      canvas.drawLine(Offset(offsetX - i * SCALE, offsetY), Offset(offsetX - i * SCALE, offsetY + 1.5), paint);
    }
    final paragraphBuilderPos = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraphPos = paragraphBuilderPos.build();
    paragraphPos.layout(constraintsAxisX);
    final paragraphBuilderNeg = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText((-i).toString());
    final paragraphNeg = paragraphBuilderNeg.build();
    paragraphNeg.layout(constraintsAxisX);
    if (i % 10 == 0) {
      canvas.drawParagraph(paragraphPos, Offset(offsetX + i * SCALE - constraintsAxisX.width / 2, offsetY + 5));
      canvas.drawParagraph(paragraphNeg, Offset(offsetX - i * SCALE - constraintsAxisX.width / 2, offsetY + 5));
    }
    i++;
  }

  // draw measurement y axis
  paragraphStyle = ui.ParagraphStyle(
    textDirection: ui.TextDirection.ltr,
    textAlign: TextAlign.right,
  );
  i = 1;
  while (offsetY + i * SCALE < height - BOUNDS) {
    if (i % 10 == 0) {
      canvas.drawLine(Offset(offsetX - 6, offsetY  + i * SCALE), Offset(offsetX, offsetY + i * SCALE), paint);
      canvas.drawLine(Offset(offsetX - 6, offsetY  - i * SCALE), Offset(offsetX, offsetY - i * SCALE), paint);
    } else if (i % 5 == 0) {
      canvas.drawLine(Offset(offsetX - 3, offsetY  + i * SCALE), Offset(offsetX, offsetY + i * SCALE), paint);
      canvas.drawLine(Offset(offsetX - 3, offsetY  - i * SCALE), Offset(offsetX, offsetY - i * SCALE), paint);
    } else {
      canvas.drawLine(Offset(offsetX - 1.5, offsetY  + i * SCALE), Offset(offsetX, offsetY + i * SCALE), paint);
      canvas.drawLine(Offset(offsetX - 1.5, offsetY  - i * SCALE), Offset(offsetX, offsetY - i * SCALE), paint);
    }
    final paragraphBuilderPos = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraphPos = paragraphBuilderPos.build();
    paragraphPos.layout(constraintsAxisY);
    final paragraphBuilderNeg = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText((-i).toString());
    final paragraphNeg = paragraphBuilderNeg.build();
    paragraphNeg.layout(constraintsAxisY);
    if (i % 10 == 0) {
      canvas.drawParagraph(paragraphNeg, Offset(offsetX - 10 - constraintsAxisY.width, offsetY  + i * SCALE - 10));
      canvas.drawParagraph(paragraphPos, Offset(offsetX - 10 - constraintsAxisY.width, offsetY  - i * SCALE - 10));
    }
    i++;
  }

  // colors according to https://de.wikipedia.org/wiki/Ausgezeichnete_Punkte_im_Dreieck#/media/Datei:Linien_am_Dreieck.svg

  // draw sides a b c
  paint.color = Colors.blueAccent;
  canvas.drawLine(Offset(triangle.A.x * SCALE + offsetX, offsetY - triangle.A.y * SCALE), Offset(triangle.B.x * SCALE + offsetX, offsetY - triangle.B.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.B.x * SCALE + offsetX, offsetY - triangle.B.y * SCALE), Offset(triangle.C.x * SCALE + offsetX, offsetY - triangle.C.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.C.x * SCALE + offsetX, offsetY - triangle.C.y * SCALE), Offset(triangle.A.x * SCALE + offsetX, offsetY - triangle.A.y * SCALE), paint);

  // draw altitudes ha hb hc
  paint.color = Colors.orange;
  canvas.drawLine(Offset(triangle.A.x * SCALE + offsetX, offsetY - triangle.A.y * SCALE), Offset(AA.x * SCALE + offsetX, offsetY - AA.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.B.x * SCALE + offsetX, offsetY - triangle.B.y * SCALE), Offset(AB.x * SCALE + offsetX, offsetY - AB.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.C.x * SCALE + offsetX, offsetY - triangle.C.y * SCALE), Offset(AC.x * SCALE + offsetX, offsetY - AC.y * SCALE), paint);

  // draw mid sides
  paint.color = Colors.orange.shade700;
  canvas.drawLine(Offset(triangle.A.x * SCALE + offsetX, offsetY - triangle.A.y * SCALE), Offset(MSA.x * SCALE + offsetX, offsetY - MSA.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.B.x * SCALE + offsetX, offsetY - triangle.B.y * SCALE), Offset(MSB.x * SCALE + offsetX, offsetY - MSB.y * SCALE), paint);
  canvas.drawLine(Offset(triangle.C.x * SCALE + offsetX, offsetY - triangle.C.y * SCALE), Offset(MSC.x * SCALE + offsetX, offsetY - MSC.y * SCALE), paint);

  // draw Special Points
  paint.style = PaintingStyle.stroke;
  paint.color = Colors.red;
  canvas.drawCircle(Offset(F.x * SCALE + offsetX, offsetY - F.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(G.x * SCALE + offsetX, offsetY - G.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(S.x * SCALE + offsetX, offsetY - S.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(O.x * SCALE + offsetX, offsetY - O.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(L.x * SCALE + offsetX, offsetY - L.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(M.x * SCALE + offsetX, offsetY - M.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(N.x * SCALE + offsetX, offsetY - N.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(N1.x * SCALE + offsetX, offsetY - N1.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(N2.x * SCALE + offsetX, offsetY - N2.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(CG.x * SCALE + offsetX, offsetY - CG.y * SCALE), POINT, paint);

  // draw Touchpoints exCircles
  paint.color = Colors.green.shade700;
  canvas.drawCircle(Offset(ETA.x * SCALE + offsetX, offsetY - ETA.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(ETB.x * SCALE + offsetX, offsetY - ETB.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(ETC.x * SCALE + offsetX, offsetY - ETC.y * SCALE), POINT, paint);

  // draw Mid side base Points
  paint.color = Colors.green.shade700;
  canvas.drawCircle(Offset(MSA.x * SCALE + offsetX, offsetY - MSA.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(MSB.x * SCALE + offsetX, offsetY - MSB.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(MSC.x * SCALE + offsetX, offsetY - MSC.y * SCALE), POINT, paint);

  // draw Altitude base Points
  paint.color = Colors.orange;
  canvas.drawCircle(Offset(AA.x * SCALE + offsetX, offsetY - AA.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(AB.x * SCALE + offsetX, offsetY - AB.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(AC.x * SCALE + offsetX, offsetY - AC.y * SCALE), POINT, paint);

  // draw Circles
  paint.color = Colors.green.shade900;
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, offsetY - IC.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, offsetY - IC.y * SCALE), IC.r * SCALE, paint);
  paint.color = Colors.green.shade900;
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, offsetY - CC.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, offsetY - CC.y * SCALE), CC.r * SCALE, paint);
  paint.color = Colors.green;
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, offsetY - EA.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, offsetY - EA.y * SCALE), EA.r * SCALE, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, offsetY - EB.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, offsetY - EB.y * SCALE), EB.r * SCALE, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, offsetY - EC.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, offsetY - EC.y * SCALE), EC.r * SCALE, paint);

  paint.color = Colors.purple;
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, offsetY - FC.y * SCALE), POINT, paint);
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, offsetY - FC.y * SCALE), FC.r * SCALE, paint);

  // draw legend
  paint.color = Colors.grey.shade50;
  paint.style = PaintingStyle.fill;
  const LINES = 55;
  canvas.drawRect(Rect.fromLTWH(BOUNDS, BOUNDS, WIDTHLEGEND + BOUNDS / 2, BOUNDS + LINES * FONTSIZE), paint);
  paint.color = Colors.black;
  final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
    ..pushStyle(textStyle)
    ..addText(
                labels['COORDINATES']! + '\n' +
                'A'.padLeft(LABELLENGTH, ' ') + DIST + '(' + A.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + A.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                'B'.padLeft(LABELLENGTH, ' ') + DIST + '(' + B.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + B.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                'C'.padLeft(LABELLENGTH, ' ') + DIST + '(' + A.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + C.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                '\n' +
                labels['SIDES']! + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST +  a.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST +  b.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST +  c.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                '\n' +
                labels['ANGLES']! + '\n' +
                    'α'.padLeft(LABELLENGTH, ' ') + DIST +  alpha.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                    'β'.padLeft(LABELLENGTH, ' ') + DIST +  beta.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                    'γ'.padLeft(LABELLENGTH, ' ') + DIST +  gamma.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                '\n' +
                labels['AREA']!.padLeft(LABELLENGTH, ' ') + DIST +   area.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                labels['CIRCUMFERENCE']!.padLeft(LABELLENGTH, ' ') + DIST +   circumference.toStringAsFixed(2).padLeft(15, ' ') + '\n' +
                '\n' +
                labels['SIDESMIDPOINTS']! + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSA.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + MSA.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSB.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + MSB.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + MSC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                '\n' +
                labels['ALTITUDESBASEPOINTS']! + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AA.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + AA.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AB.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + AB.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + AC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                '\n' +
                labels['TOUCHPOINTS']! + '\n' +
                    labels['EXCIRCLE']!.replaceAll('\$1', 'a').padLeft(LABELLENGTH, ' ') + DIST + '(' + ETA.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + ETA.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    labels['EXCIRCLE']!.replaceAll('\$1', 'b').padLeft(LABELLENGTH, ' ') + DIST + '(' + ETB.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + ETB.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                    labels['EXCIRCLE']!.replaceAll('\$1', 'c').padLeft(LABELLENGTH, ' ') + DIST + '(' + ETC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + ETC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +

                '\nClark Kimberling, Encyclopedia of Triangle Centers\n' +
                (labels['X1']! + ' X01').padLeft(LABELLENGTH, ' ') + DIST + '(' + IC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + IC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X2']! + ' X02').padLeft(LABELLENGTH, ' ') + DIST + '(' + CG.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + CG.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X3']! + ' X03').padLeft(LABELLENGTH, ' ') + DIST + '(' + CC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + CC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X4']! + ' X04').padLeft(LABELLENGTH, ' ') + DIST + '(' + O.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + O.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X5']! + ' X05').padLeft(LABELLENGTH, ' ') + DIST + '(' + FC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + FC.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X6']! + ' X06').padLeft(LABELLENGTH, ' ') + DIST + '(' + L.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + L.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X7']! + ' X07').padLeft(LABELLENGTH, ' ') + DIST + '(' + G.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + G.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X8']! + ' X08').padLeft(LABELLENGTH, ' ') + DIST + '(' + N.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + N.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X9']! + ' X09').padLeft(LABELLENGTH, ' ') + DIST + '(' + M.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + M.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X10']! + ' X10').padLeft(LABELLENGTH, ' ') + DIST + '(' + S.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + S.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X11']! + ' X11').padLeft(LABELLENGTH, ' ') + DIST + '(' + F.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + F.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X17']! + ' X17').padLeft(LABELLENGTH, ' ') + DIST + '(' + N1.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + N1.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                (labels['X18']! + ' X18').padLeft(LABELLENGTH, ' ') + DIST + '(' + N2.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + N2.y.toStringAsFixed(2).padLeft(7, ' ') + ')\n' +
                '\n' + labels['']! + '\n' +
                labels['INCIRCLE']!.padLeft(LABELLENGTH, ' ') + DIST + '(' + IC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + IC.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + IC.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                labels['CIRCUMCIRCLE']!.padLeft(LABELLENGTH, ' ') + DIST + '(' + CC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + CC.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + CC.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                labels['FEUERBACHCIRCLE']!.padLeft(LABELLENGTH, ' ') + DIST + '(' + FC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + FC.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + FC.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                '\n' + labels['EXCIRCLE']! + '\n' +
                ('a').padLeft(LABELLENGTH, ' ') + DIST + '(' + EA.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + EA.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + EA.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                ('b').padLeft(LABELLENGTH, ' ') + DIST + '(' + EB.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + EB.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + EB.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                ('c').padLeft(LABELLENGTH, ' ') + DIST + '(' + EC.x.toStringAsFixed(2).padLeft(7, ' ') + '|' + EC.y.toStringAsFixed(2).padLeft(7, ' ') + '), r = ' + EC.r.toStringAsFixed(2).padLeft(6, ' ') + '\n' +
                ''
    );
  final paragraph = paragraphBuilder.build();
  paragraph.layout(constraintsLegend);
  canvas.drawParagraph(paragraph, Offset(15, BOUNDS + 25));
  try {
    final img = await canvasRecorder.endRecording().toImage(width.floor(), height.floor());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return trimNullBytes(data!.buffer.asUint8List());
  } catch (e) {
    return Uint8List.fromList([]);
  }
}