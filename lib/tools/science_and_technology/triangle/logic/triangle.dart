import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_classes.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/common_linear_algebra.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/common_trilinear_xy.dart';

Sides triangleAngleBiSectors(XYPoint A, XYPoint B, XYPoint C,){
  Angles angles = triangleAngles(A, B, C)!;
  Sides sides = triangleSides(A, B, C);

  return Sides(
    a: 2 * sides.b * sides.c * cos(angles.alpha * pi / 180 / 2 ) / (sides.b + sides.c),
    b: 2 * sides.a * sides.c * cos(angles.beta * pi / 180 / 2 ) / (sides.a + sides.c),
    c: 2 * sides.a * sides.b * cos(angles.gamma * pi / 180 / 2) / (sides.b + sides.a),
  );
}

Sides triangleMedians(XYPoint A, XYPoint B, XYPoint C,){
  Sides sides = triangleSides(A, B, C);

  return Sides(
    a: sqrt(2  * (sides.b * sides.b + sides.c * sides.c) - sides.a * sides.a) / 2,
    b: sqrt(2  * (sides.a * sides.a + sides.c * sides.c) - sides.b * sides.b) / 2,
    c: sqrt(2  * (sides.b * sides.b + sides.a * sides.a) - sides.c * sides.c) / 2,
  );
}

Sides triangleAltitudes(XYPoint A, XYPoint B, XYPoint C,){
  double area = triangleArea(A, B, C);
  Sides sides = triangleSides(A, B, C);

  return Sides(
    a: 2 * area / sides.a,
    b: 2 * area / sides.b,
    c: 2 * area / sides.c,
  );
}

Sides triangleSides(XYPoint A, XYPoint B, XYPoint C,){
  return Sides(
    c: _vectorLength(_vectorAB(A, B)),
    b: _vectorLength(_vectorAB(A, C)),
    a: _vectorLength(_vectorAB(B, C)),
  );
}

Angles? triangleAngles(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Dreieck#Berechnung_eines_beliebigen_Dreiecks Kosinussatz
  try {
    return Angles(
        alpha: 180 /
            pi *
            acos(_vectorProductDot(_vectorAB(A, B), _vectorAB(A, C)) /
                _vectorLength(_vectorAB(A, B)) /
                _vectorLength(_vectorAB(A, C))),
        beta: 180 /
            pi *
            acos(_vectorProductDot(_vectorAB(B, A), _vectorAB(B, C)) /
                _vectorLength(_vectorAB(B, A)) /
                _vectorLength(_vectorAB(B, C))),
        gamma: 180 /
            pi *
            acos(_vectorProductDot(_vectorAB(C, A), _vectorAB(C, B)) /
                _vectorLength(_vectorAB(C, A)) /
                _vectorLength(_vectorAB(C, B))));
  } catch (e) {
    return null;
  }
}

double triangleArea(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Dreiecksfl%C3%A4che
  Sides sides = triangleSides(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return sqrt(s * (s - sides.a) * (s - sides.b) * (s - sides.c));
}

double triangleCircumference(XYPoint A, XYPoint B, XYPoint C,){
  Sides sides = triangleSides(A, B, C);
  return sides.a + sides.b + sides.c;
}

XYPoint triangleCentroid(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Geometrischer_Schwerpunkt
  return XYPoint(
    x: (A.x + B.x + C.x) / 3,
    y: (A.y + B.y + C.y) / 3,
  );
}

XYPoint triangleOrthocenter(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/H%C3%B6henschnittpunkt
  return intersectVectors(
    XYLine(P1: A, P2: _vectorNorm(_vectorAB(B, C))),
    XYLine(P1: B, P2: _vectorNorm(_vectorAB(A, C))),
  );
}

XYPoint triangleLemoine(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Lemoinepunkt
  // https://mathematikgarten.hpage.com/get_file.php?id=33910985&vnr=826595

  Sides sides = triangleSides(A, B, C);
  double divisor = sides.a * sides.a + sides.b * sides.b + sides.c * sides.c;
  XYPoint L = XYPoint(
    x: A.x * sides.a * sides.a / divisor + B.x * sides.b * sides.b / divisor + C.x * sides.c * sides.c / divisor,
    y: A.y * sides.a * sides.a / divisor + B.y * sides.b * sides.b / divisor + C.y * sides.c * sides.c / divisor,
  );
  return L;
}

XYPoint triangleGergonne(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Gergonne-Punkt
  // https://mathworld.wolfram.com/GergonnePoint.html
  XYCircle MC = triangleInCircle(A, B, C);
  XYPoint M = XYPoint(x: MC.x, y: MC.y);
  XYPoint X = intersectVectors(
      XYLine(P1: B, P2: _vectorAB(B, C)),
      XYLine(P1: M, P2: _vectorNorm(_vectorAB(B, C)))
  );
  XYPoint Z = intersectVectors(
      XYLine(P1: A, P2: _vectorAB(A, B)),
      XYLine(P1: M, P2: _vectorNorm(_vectorAB(A, B)))
  );
  return intersectVectors(
    XYLine(P1: A, P2: _vectorAB(A, X)),
    XYLine(P1: C, P2: _vectorAB(C, Z)),
  );
}

XYPoint triangleNagel(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Nagel-Punkt

  Sides sides = triangleSides(A, B, C);

  double ac = (sides.a - sides.b + sides.c) / 2;
  double ab = (sides.a + sides.b - sides.c) / 2;

  XYPoint BexB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), ab));
  XYPoint BexA = _vectorAdd(C, _vectorMult(_vectorNormalize(_vectorAB(C, B)), ac));

  XYPoint N = intersectVectors(
      XYLine(P1: A, P2: BexA),
      XYLine(P1: B, P2: BexB)
  );
  return N;
}

XYPoint triangleSpieker(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Spieker-Punkt

  List<XYPoint> sidesmidpoint = triangleSidesMidPoints(A, B, C);

  XYCircle S = triangleInCircle(sidesmidpoint[0], sidesmidpoint[1], sidesmidpoint[2]);
  return XYPoint(
    x: S.x,
    y: S.y,
  );
}

XYPoint triangleMitten(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Mittenpunkt
  // https://mathworld.wolfram.com/Mittenpunkt.html

  List<XYPoint> sidesmidpoint = triangleSidesMidPoints(A, B, C);
  List<XYCircle> excircles = triangleExCircles(A, B, C);

  XYPoint M = intersectVectors(
      XYLine(
          P1: XYPoint(
            x: excircles[1].x,
            y: excircles[1].y,
          ),
          P2: sidesmidpoint[1]),
      XYLine(
          P1: XYPoint(
            x: excircles[0].x,
            y: excircles[0].y,
          ),
          P2: sidesmidpoint[0])
  );
  return M;
}

XYPoint triangleFeuerbach(XYPoint A, XYPoint B, XYPoint C){
  // https://de.wikipedia.org/wiki/Feuerbachkreis

  XYCircle incircle = triangleInCircle(A, B, C);
  XYCircle feuerbachcircle = triangleFeuerbachCircle(A, B, C);

  List<XYPoint> feuerbachpoints = intersectTwoCircles(incircle, feuerbachcircle);

  if (feuerbachpoints.isNotEmpty) {
    return feuerbachpoints[0];
  } else {
    return XYPoint(x: 0, y: 0);
  }
}

List<XYPoint> triangleSidesMidPoints(XYPoint A, XYPoint B, XYPoint C,){

  List<XYPoint> sidesMidpoint = [];
  Sides sides = triangleSides(A, B, C);

  XYPoint MA = _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(B, C))), sides.a / 2));
  XYPoint MB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, C))), sides.b / 2));
  XYPoint MC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, B))), sides.c / 2));

  sidesMidpoint.add(XYPoint(x: MA.x, y: MA.y));
  sidesMidpoint.add(XYPoint(x: MB.x, y: MB.y));
  sidesMidpoint.add(XYPoint(x: MC.x, y: MC.y));

  return sidesMidpoint;
}

List<XYPoint> triangleAnglesMidPoints(XYPoint A, XYPoint B, XYPoint C,){

  List<XYPoint> sidesMidpoint = [];
  Sides sides = triangleSides(A, B, C);

  XYPoint MA = _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(B, C))), sides.a / 2));
  XYPoint MB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, C))), sides.b / 2));
  XYPoint MC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, B))), sides.c / 2));

  sidesMidpoint.add(XYPoint(x: MA.x, y: MA.y));
  sidesMidpoint.add(XYPoint(x: MB.x, y: MB.y));
  sidesMidpoint.add(XYPoint(x: MC.x, y: MC.y));

  return sidesMidpoint;
}

List<XYPoint> triangleSymmediandPoints(XYPoint A, XYPoint B, XYPoint C,){

  List<XYPoint> sidesMidpoint = [];
  Sides sides = triangleSides(A, B, C);

  XYPoint MA = _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(B, C))), sides.a / 2));
  XYPoint MB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, C))), sides.b / 2));
  XYPoint MC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorNormalize(_vectorAB(A, B))), sides.c / 2));

  sidesMidpoint.add(XYPoint(x: MA.x, y: MA.y));
  sidesMidpoint.add(XYPoint(x: MB.x, y: MB.y));
  sidesMidpoint.add(XYPoint(x: MC.x, y: MC.y));

  return sidesMidpoint;
}

List<XYPoint> triangleAltitudesBasePoints(XYPoint A, XYPoint B, XYPoint C,){
  List<XYPoint> result = [];
  XYPoint H = triangleOrthocenter(A, B, C);

  result.add(intersectVectors(
      XYLine(P1: B, P2: _vectorDiv(_vectorAB(B, C), _vectorLength(_vectorAB(B, C)))),
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, H), _vectorLength(_vectorAB(A, H))))));
  result.add(intersectVectors(
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, C), _vectorLength(_vectorAB(A, C)))),
      XYLine(P1: B, P2: _vectorDiv(_vectorAB(B, H), _vectorLength(_vectorAB(B, H))))));
  result.add(intersectVectors(
      XYLine(P1: A, P2: _vectorDiv(_vectorAB(A, B), _vectorLength(_vectorAB(A, B)))),
      XYLine(P1: C, P2: _vectorDiv(_vectorAB(C, H), _vectorLength(_vectorAB(C, H))))));
  return result;
}

XYCircle triangleInCircle(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Inkreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle

  XYPoint S = intersectVectors(
      XYLine(P1: A, P2: _vectorAdd(_vectorDiv(_vectorAB(A, B), _vectorLength(_vectorAB(A, B))), _vectorDiv(_vectorAB(A, C), _vectorLength(_vectorAB(A, C))))),
      XYLine(P1: B, P2: _vectorAdd(_vectorDiv(_vectorAB(B, A), _vectorLength(_vectorAB(B, A))), _vectorDiv(_vectorAB(B, C), _vectorLength(_vectorAB(B, C)))))
  );

  Sides sides = triangleSides(A, B, C);
  double s = (sides.a + sides.b + sides.c) / 2;

  return XYCircle(
    x: S.x,
    y: S.y,
    // ri = sqrt((s - a)·(s - b)·(s - c)/s) mit s = u/2
    r: sqrt((s - sides.a) * (s -sides.b) * (s - sides.c) / s),
  );
}

XYCircle triangleCircumCircle(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Umkreis

  Sides sides = triangleSides(A, B, C);
  Angles angles = triangleAngles(A, B, C)!;

  XYPoint SB =  _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), sides.b / 2));
  XYPoint SA =  _vectorAdd(B, _vectorMult(_vectorNormalize(_vectorAB(B, C)), sides.a / 2));

  XYPoint S = intersectVectors(
      XYLine(P1: SA, P2: _vectorNorm(_vectorAB(B, C))),
      XYLine(P1: SB, P2: _vectorNorm(_vectorAB(A, C)))
  );
  return XYCircle(
    x: S.x,
    y: S.y,
    r: sides.a / (2 * sin(angles.alpha * pi /180)),
  );
}

XYCircle triangleFeuerbachCircle(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Feuerbachkreis
  List<XYPoint> sidemidpoints = triangleSidesMidPoints(A, B, C);
  XYCircle F = triangleCircumCircle(
    XYPoint(x: sidemidpoints[0].x, y: sidemidpoints[0].y),
    XYPoint(x: sidemidpoints[1].x, y: sidemidpoints[1].y),
    XYPoint(x: sidemidpoints[2].x, y: sidemidpoints[2].y),
  );
  return F;
}

List<XYCircle> triangleExCircles(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/Ankreis
  // https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
  List<XYCircle> exCircle = [];

  Sides sides = triangleSides(A, B, C);
  double area = triangleArea(A, B, C);

  double ra = area / ((sides.a + sides.b + sides.c) / 2 - sides.a);
  double rb = area / ((sides.a + sides.b + sides.c) / 2 - sides.b);
  double rc = area / ((sides.a + sides.b + sides.c) / 2 - sides.c);

  double ac = (sides.a - sides.b + sides.c) / 2;
  double ab = (sides.a + sides.b - sides.c) / 2;

  XYPoint BexC = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, B)), ac));
  XYPoint BexB = _vectorAdd(A, _vectorMult(_vectorNormalize(_vectorAB(A, C)), ab));
  XYPoint BexA = _vectorAdd(C, _vectorMult(_vectorNormalize(_vectorAB(C, B)), ac));

  XYPoint MexC = _vectorAdd(BexC, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(A, B))), rc));
  XYPoint MexB = _vectorAdd(BexB, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(C, A))), rb));
  XYPoint MexA = _vectorAdd(BexA, _vectorMult(_vectorNormalize(_vectorNorm(_vectorAB(B, C))), ra));

  exCircle.add(XYCircle(x: MexA.x, y: MexA.y, r: ra));
  exCircle.add(XYCircle(x: MexB.x, y: MexB.y, r: rb));
  exCircle.add(XYCircle(x: MexC.x, y: MexC.y, r: rc));

  return exCircle;
}

Future<Uint8List > triangleData2Image({
  required XYPoint A,
  required XYPoint B,
  required XYPoint C,
  required XYPoint O, // orthocenter
  required XYPoint L, // lemoine
  required XYPoint CG, // centroid
  required XYPoint S, // spieker
  required XYPoint M, // mitten
  required XYPoint F, //feuerbach
  required XYPoint N, // nagel
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
}) async {

  const BOUNDS = 100.0;
  const SCALE = 100.0;

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
    ..strokeWidth = 2.0;

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
  const constraints = ui.ParagraphConstraints(width: 300);

  int i = 0;
  while (offsetX + i * SCALE < width - BOUNDS) {
    canvas.drawLine(Offset(offsetX + i * SCALE, offsetY - 10), Offset(offsetX + i * SCALE, offsetY - 10), paint);
    canvas.drawLine(Offset(offsetX - i * SCALE, offsetY - 10), Offset(offsetX - i * SCALE, offsetY - 10), paint);
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(offsetX + i * SCALE, offsetY - 20));
    canvas.drawParagraph(paragraph, Offset(offsetX - i * SCALE, offsetY - 20));
    i++;
  }

  // draw measurement y axis
  i = 0;
  while (offsetY + i * SCALE < height - BOUNDS) {
    canvas.drawLine(Offset(offsetX - 10, offsetY  + i * SCALE), Offset(offsetX + 10, offsetY + i * SCALE), paint);
    canvas.drawLine(Offset(offsetX - 10, offsetY  - i * SCALE), Offset(offsetX + 10, offsetY - i * SCALE), paint);
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(i.toString());
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(offsetX - 20, offsetY  + i * SCALE - 10));
    canvas.drawParagraph(paragraph, Offset(offsetX - 20, offsetY  - i * SCALE - 10));
    i++;
  }

  // draw sides a bc
  paint.color = Colors.orange.shade900;
  canvas.drawLine(Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(B.x * SCALE + offsetX, B.y * SCALE + offsetY), Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), paint);
  canvas.drawLine(Offset(C.x * SCALE + offsetX, C.y * SCALE + offsetY), Offset(A.x * SCALE + offsetX, A.y * SCALE + offsetY), paint);

  // draw altitudes
  paint.color = Colors.orange.shade700;
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
  paint.color = Colors.blue;
  canvas.drawCircle(Offset(F.x * SCALE + offsetX, F.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(G.x * SCALE + offsetX, G.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(S.x * SCALE + offsetX, S.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(O.x * SCALE + offsetX, O.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(L.x * SCALE + offsetX, L.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(M.x * SCALE + offsetX, M.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(N.x * SCALE + offsetX, N.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(CG.x * SCALE + offsetX, CG.y * SCALE + offsetY), 1.0, paint);

  // draw Mid side base Points
  paint.color = Colors.green.shade700;
  canvas.drawCircle(Offset(MSA.x * SCALE + offsetX, MSA.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(MSB.x * SCALE + offsetX, MSB.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(MSC.x * SCALE + offsetX, MSC.y * SCALE + offsetY), 1.0, paint);

  // draw Altitude base Points
  paint.color = Colors.green.shade500;
  canvas.drawCircle(Offset(AA.x * SCALE + offsetX, AA.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(AB.x * SCALE + offsetX, AB.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(AC.x * SCALE + offsetX, AC.y * SCALE + offsetY), 1.0, paint);

  // draw Circles
  paint.color = Colors.red.shade900;
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, IC.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(IC.x * SCALE + offsetX, IC.y * SCALE + offsetY), IC.r * SCALE, paint);
  paint.color = Colors.red.shade600;
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, CC.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(CC.x * SCALE + offsetX, CC.y * SCALE + offsetY), CC.r * SCALE, paint);
  paint.color = Colors.red.shade400;
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, EA.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(EA.x * SCALE + offsetX, EA.y * SCALE + offsetY), EA.r * SCALE, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, EB.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(EB.x * SCALE + offsetX, EB.y * SCALE + offsetY), EB.r * SCALE, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, EC.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(EC.x * SCALE + offsetX, EC.y * SCALE + offsetY), EC.r * SCALE, paint);

  paint.color = Colors.purple;
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, FC.y * SCALE + offsetY), 1.0, paint);
  canvas.drawCircle(Offset(FC.x * SCALE + offsetX, FC.y * SCALE + offsetY), FC.r * SCALE, paint);

  // draw legend
  paint.color = Colors.black;
  final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
    ..pushStyle(textStyle)
    ..addText(
        'A         (' + A.x.toStringAsFixed(2) + '|' + A.y.toStringAsFixed(2) + ')\n' +
        'B         (' + B.x.toStringAsFixed(2) + '|' + B.y.toStringAsFixed(2) + ')\n' +
        'C         (' + C.x.toStringAsFixed(2) + '|' + C.y.toStringAsFixed(2) + ')\n' +
        'Feuerbach (' + F.x.toStringAsFixed(2) + '|' + F.y.toStringAsFixed(2) + ')\n' +
        'Spiegel   (' + S.x.toStringAsFixed(2) + '|' + S.y.toStringAsFixed(2) + ')\n' +
        'Gergonne  (' + G.x.toStringAsFixed(2) + '|' + G.y.toStringAsFixed(2) + ')\n' +
        'Mitten    (' + M.x.toStringAsFixed(2) + '|' + M.y.toStringAsFixed(2) + ')\n' +
        'Nagel     (' + N.x.toStringAsFixed(2) + '|' + N.y.toStringAsFixed(2) + ')\n' +
        'Lemoine   (' + L.x.toStringAsFixed(2) + '|' + L.y.toStringAsFixed(2) + ')\n'
    );
  final paragraph = paragraphBuilder.build();
  paragraph.layout(constraints);
  canvas.drawParagraph(paragraph, Offset(BOUNDS, BOUNDS));

  final img = await canvasRecorder.endRecording().toImage(width.floor(), height.floor());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return trimNullBytes(data!.buffer.asUint8List());
}

