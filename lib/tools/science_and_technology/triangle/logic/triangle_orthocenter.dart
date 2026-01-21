part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

XYPoint triangleOrthocenterXY(XYPoint A, XYPoint B, XYPoint C,){
  // https://de.wikipedia.org/wiki/H%C3%B6henschnittpunkt
  return intersectVectors(
    XYLine(P1: A, P2: _vectorNorm(_vectorAB(B, C))),
    XYLine(P1: B, P2: _vectorNorm(_vectorAB(A, C))),
  );
}
