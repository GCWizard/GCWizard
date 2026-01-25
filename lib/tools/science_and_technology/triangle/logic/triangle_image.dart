part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

Future<Uint8List > triangleData2Image({
  required XYPoint A,
  required XYPoint B,
  required XYPoint C,
  required double a,
  required double b,
  required double c,
  required double alpha,
  required double beta,
  required double gamma,
  required double area,
  required double circumference,
  required XYPoint O, // orthocenter
  required XYPoint L, // lemoine
  required XYPoint CG, // centroid
  required XYPoint S, // spieker
  required XYPoint M, // mitten
  required XYPoint F, //feuerbach
  required XYPoint N, // nagel
  required XYPoint N1, // napoleon I
  required XYPoint N2, // napoleon II
  required XYPoint G, // gergonne
  required XYPoint MSA, // mid side a
  required XYPoint MSB, // mid side b
  required XYPoint MSC, // mid side c
  required XYPoint AA, // altitude base a
  required XYPoint AB, // altitude base b
  required XYPoint AC, // altitude base c
  required XYCircle IC, // inner circle
  required XYCircle CC, // circum circle
  required XYCircle FC, // feuerbach circle
  required XYCircle EA, // ex circle a
  required XYCircle EB, // ex circle b
  required XYCircle EC, // ex circle c
  required List<String> labels, // labels for the points/circles
}) async {

  const BOUNDS = 100.0;
  const SCALE = 100.0;

  const POINT = 2.0;
  const LINE = 2.0;

  const LABELLENGTH = 30;
  const DIST = '     ';

  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  if (A.x < minX) minX = A.x; if (A.x > maxX) maxX = A.x;
  if (B.x < minX) minX = B.x; if (B.x > maxX) maxX = B.x;
  if (C.x < minX) minX = C.x; if (C.x > maxX) maxX = C.x;
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

  if (A.y < minY) minY = A.y; if (A.y > maxY) maxY = A.x;
  if (B.y < minY) minY = B.y; if (B.y > maxY) maxY = B.y;
  if (C.y < minY) minY = C.y; if (C.y > maxY) maxY = C.y;
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
  canvas.drawLine(Offset(BOUNDS, offsetY), Offset(width - BOUNDS, offsetY), paint);
  canvas.drawLine(Offset(offsetX, BOUNDS), Offset(offsetX, height - BOUNDS), paint);

  // draw measurement x axis
  final textStyle = ui.TextStyle(
    color: paint.color,
    fontSize: 16.0,
    fontFamily: 'Courier',
  );
  final paragraphStyle = ui.ParagraphStyle(
    textDirection: ui.TextDirection.ltr,
  );
  const constraints = ui.ParagraphConstraints(width: 600);

  int i = 1;
  while (offsetX + i * SCALE < width - BOUNDS) {
    canvas.drawLine(Offset(offsetX + i * SCALE, offsetY), Offset(offsetX + i * SCALE, offsetY + 10), paint);
    canvas.drawLine(Offset(offsetX - i * SCALE, offsetY), Offset(offsetX - i * SCALE, offsetY + 10), paint);
    final paragraphBuilderPos = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraphPos = paragraphBuilderPos.build();
    paragraphPos.layout(constraints);
    final paragraphBuilderNeg = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText((-i).toString());
    final paragraphNeg = paragraphBuilderNeg.build();
    paragraphNeg.layout(constraints);
    canvas.drawParagraph(paragraphPos, Offset(offsetX + i * SCALE, offsetY - 20));
    canvas.drawParagraph(paragraphNeg, Offset(offsetX - i * SCALE, offsetY - 20));
    i++;
  }

  // draw measurement y axis
  i = 1;
  while (offsetY + i * SCALE < height - BOUNDS) {
    canvas.drawLine(Offset(offsetX, offsetY  + i * SCALE), Offset(offsetX + 10, offsetY + i * SCALE), paint);
    canvas.drawLine(Offset(offsetX, offsetY  - i * SCALE), Offset(offsetX + 10, offsetY - i * SCALE), paint);
    final paragraphBuilderPos = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraphPos = paragraphBuilderPos.build();
    paragraphPos.layout(constraints);
    final paragraphBuilderNeg = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText((-i).toString());
    final paragraphNeg = paragraphBuilderNeg.build();
    paragraphNeg.layout(constraints);
    canvas.drawParagraph(paragraphNeg, Offset(offsetX - 20, offsetY  + i * SCALE - 10));
    canvas.drawParagraph(paragraphPos, Offset(offsetX - 20, offsetY  - i * SCALE - 10));
    i++;
  }

  // colors according to https://de.wikipedia.org/wiki/Ausgezeichnete_Punkte_im_Dreieck#/media/Datei:Linien_am_Dreieck.svg

  // draw sides a b c
  paint.color = Colors.blueAccent;
  canvas.drawLine(Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), paint);

  // draw altitudes ha hb hc
  paint.color = Colors.orange;
  canvas.drawLine(Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), Offset(AA.x * SCALE + offsetX, AA.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), Offset(AB.x * SCALE + offsetX, AB.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), Offset(AC.x * SCALE + offsetX, AC.y * SCALE + offsetY), paint);

  // draw mid sides
  paint.color = Colors.orange.shade500;
  canvas.drawLine(Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), Offset(MSA.x * SCALE + offsetX, MSA.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), Offset(MSB.x * SCALE + offsetX, MSB.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), Offset(MSC.x * SCALE + offsetX, MSC.y * SCALE + offsetY), paint);

  // draw Special Points
  paint.style = PaintingStyle.stroke;
  paint.color = Colors.red;
  canvas.drawCircle(Offset(F.x * SCALE + offsetX, F.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(G.x * SCALE + offsetX, G.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(S.x * SCALE + offsetX, S.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(O.x * SCALE + offsetX, O.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(L.x * SCALE + offsetX, L.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(M.x * SCALE + offsetX, M.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(N.x * SCALE + offsetX, N.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(N1.x * SCALE + offsetX, N1.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(N2.x * SCALE + offsetX, N2.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(CG.x * SCALE + offsetX, CG.y * SCALE + offsetY), POINT, paint);

  // draw Mid side base Points
  paint.color = Colors.green.shade700;
  canvas.drawCircle(Offset(MSA.x * SCALE + offsetX, MSA.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(MSB.x * SCALE + offsetX, MSB.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(MSC.x * SCALE + offsetX, MSC.y * SCALE + offsetY), POINT, paint);

  // draw Altitude base Points
  paint.color = Colors.orange;
  canvas.drawCircle(Offset(AA.x * SCALE + offsetX, AA.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(AB.x * SCALE + offsetX, AB.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(AC.x * SCALE + offsetX, AC.y * SCALE + offsetY), POINT, paint);

  // draw Circles
  paint.color = Colors.red.shade900;
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, IC.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, IC.y * SCALE + offsetY), IC.r * SCALE, paint);
  paint.color = Colors.red.shade600;
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, CC.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, CC.y * SCALE + offsetY), CC.r * SCALE, paint);
  paint.color = Colors.red.shade400;
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, EA.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, EA.y * SCALE + offsetY), EA.r * SCALE, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, EB.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, EB.y * SCALE + offsetY), EB.r * SCALE, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, EC.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, EC.y * SCALE + offsetY), EC.r * SCALE, paint);

  paint.color = Colors.purple;
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, FC.y * SCALE + offsetY), POINT, paint);
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, FC.y * SCALE + offsetY), FC.r * SCALE, paint);

  // draw legend
  paint.color = Colors.black;
  final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
    ..pushStyle(textStyle)
    ..addText(
                'A'.padLeft(LABELLENGTH, ' ') + DIST + '(' + A.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + A.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                'B'.padLeft(LABELLENGTH, ' ') + DIST + '(' + B.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + B.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                'C'.padLeft(LABELLENGTH, ' ') + DIST + '(' + C.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + C.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                '\n' +
                labels[0] + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST +  a.toStringAsFixed(2) + '\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST +  b.toStringAsFixed(2) + '\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST +  c.toStringAsFixed(2) + '\n' +
                labels[1] + '\n' +
                    'α'.padLeft(LABELLENGTH, ' ') + DIST +  alpha.toStringAsFixed(2) + '\n' +
                    'β'.padLeft(LABELLENGTH, ' ') + DIST +  beta.toStringAsFixed(2) + '\n' +
                    'γ'.padLeft(LABELLENGTH, ' ') + DIST +  gamma.toStringAsFixed(2) + '\n' +
                '\n' +
                labels[2].padLeft(LABELLENGTH, ' ') + DIST +   area.toStringAsFixed(2) + '\n' +
                labels[3].padLeft(LABELLENGTH, ' ') + DIST +   circumference.toStringAsFixed(2) + '\n' +
                '\n' +
                labels[4] + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSA.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + MSA.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSB.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + MSB.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST + '(' + MSC.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + MSC.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                '\n' +
                labels[5] + '\n' +
                    'a'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AA.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + AA.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                    'b'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AB.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + AB.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                    'c'.padLeft(LABELLENGTH, ' ') + DIST + '(' + AC.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + AC.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                '\nClark Kimberling, Encyclopedia of Triangle Centers\n' +
                (labels[16] + ' X01').padLeft(LABELLENGTH, ' ') + DIST + '(' + IC.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + IC.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[6] + ' X02').padLeft(LABELLENGTH, ' ') + DIST + '(' + CG.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + CG.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[17] + ' X03').padLeft(LABELLENGTH, ' ') + DIST + '(' + CC.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + CC.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[7] + ' X04').padLeft(LABELLENGTH, ' ') + DIST + '(' + O.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + O.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[21] + ' X05').padLeft(LABELLENGTH, ' ') + DIST + '(' + FC.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + FC.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[8] + ' X06').padLeft(LABELLENGTH, ' ') + DIST + '(' + L.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + L.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[9] + ' X07').padLeft(LABELLENGTH, ' ') + DIST + '(' + G.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + G.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[10] + ' X08').padLeft(LABELLENGTH, ' ') + DIST + '(' + N.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + N.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[13] + ' X09').padLeft(LABELLENGTH, ' ') + DIST + '(' + M.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + M.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[14] + ' X10').padLeft(LABELLENGTH, ' ') + DIST + '(' + S.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + S.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[15] + ' X11').padLeft(LABELLENGTH, ' ') + DIST + '(' + F.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + F.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[11] + ' X17').padLeft(LABELLENGTH, ' ') + DIST + '(' + N1.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + N1.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                (labels[12] + ' X18').padLeft(LABELLENGTH, ' ') + DIST + '(' + N2.x.toStringAsFixed(2).padLeft(6, ' ') + '|' + N2.y.toStringAsFixed(2).padLeft(6, ' ') + ')\n' +
                '\n' +
                    ''
    );
  final paragraph = paragraphBuilder.build();
  paragraph.layout(constraints);
  canvas.drawParagraph(paragraph, Offset(BOUNDS, BOUNDS));

  final img = await canvasRecorder.endRecording().toImage(width.floor(), height.floor());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return trimNullBytes(data!.buffer.asUint8List());
}
