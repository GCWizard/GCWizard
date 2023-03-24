import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Humidity extends Unit {
  late double Function (double) toDegree;
  late double Function (double) fromDegree;

  Humidity({required String name, required String symbol, bool isReference = false, required double inDegree})
      : super(name, symbol, isReference, (e) => e * inDegree, (e) => e / inDegree) {
    toDegree = toReference;
    fromDegree = fromReference;
  }
}

final HUMIDITY = Humidity(
  name: 'common_unit_humidity_name',
  symbol: '%',
  inDegree: 1.0,
  isReference: true,
);

final List<Unit> humidity = [HUMIDITY];
