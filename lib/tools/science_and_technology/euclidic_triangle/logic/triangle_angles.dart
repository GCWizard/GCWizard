part of 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

Angles triangleAnglesXY(XYPoint a, XYPoint b, XYPoint c) {
  // https://de.wikipedia.org/wiki/Dreieck#Berechnung_eines_beliebigen_Dreiecks Kosinussatz
  return Angles(
      alpha: 180 /
          pi *
          acos(_vectorProductDot(_vectorAB(a, b), _vectorAB(a, c)) /
              _vectorLength(_vectorAB(a, b)) /
              _vectorLength(_vectorAB(a, c))),
      beta: 180 /
          pi *
          acos(_vectorProductDot(_vectorAB(b, a), _vectorAB(b, c)) /
              _vectorLength(_vectorAB(b, a)) /
              _vectorLength(_vectorAB(b, c))),
      gamma: 180 /
          pi *
          acos(_vectorProductDot(_vectorAB(c, a), _vectorAB(c, b)) /
              _vectorLength(_vectorAB(c, a)) /
              _vectorLength(_vectorAB(c, b))));
}
