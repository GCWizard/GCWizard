import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/triangle/logic/common_linear_algebra.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/common_trilinear_xy.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_classes.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_image.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_napoleon.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_lemoine.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_gergonne.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_nagel.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_spieker.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_mitten.dart';
part 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle_feuerbach.dart';



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


