import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Drag extends Unit {
  late double Function (double) toDrag;
  late double Function (double) fromDrag;

  Drag({
    required String name,
    required String symbol,
    bool isReference = false,
    double inDrag = 1.0,
  }) : super(name, symbol, isReference, (e) => e * inDrag, (e) => e / inDrag) {
    toDrag = toReference;
    fromDrag = fromReference;
  }
}

final DRAG = Drag(name: 'common_unit_drag', symbol: '', isReference: true);



final List<Drag> drags = [
  DRAG,
];
