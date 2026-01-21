part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

Sides triangleSidesXY(XYPoint A, XYPoint B, XYPoint C,){
  return Sides(
    c: _vectorLength(_vectorAB(A, B)),
    b: _vectorLength(_vectorAB(A, C)),
    a: _vectorLength(_vectorAB(B, C)),
  );
}

