part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

Angles? triangleAnglesXY(XYPoint A, XYPoint B, XYPoint C,){
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

/// Berechnet den Winkel am Punkt A im sphärischen Dreieck ABC
double sphericalAngle(Vec3 a, Vec3 b, Vec3 c) {
  // Projektion von b und c in die Tangentialebene bei a
  final ab = b - a * a.dot(b);
  final ac = c - a * a.dot(c);

  final cosAngle = ab.dot(ac) / (ab.norm() * ac.norm());
  return acos(cosAngle);
}
