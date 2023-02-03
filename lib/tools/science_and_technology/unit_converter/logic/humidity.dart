import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Humidity extends Unit {
  Function toDegree;
  Function fromDegree;

  Humidity({String name, String symbol, bool isReference: false, double inDegree})
      : super(name, symbol, isReference, (e) => e * inDegree, (e) => e / inDegree) {
    toDegree = this.toReference;
    fromDegree = this.fromReference;
  }
}

final HUMIDITY = Humidity(
  name: 'common_unit_humidity_name',
  symbol: '%',
  isReference: true,
);

final List<Unit> humidity = [HUMIDITY];
