import 'package:latlong2/latlong.dart';

class DistanceBearingData {
  double _distance = 0.0;
  double _bearingAToB = 0.0;
  double _bearingBToA = 0.0;

  DistanceBearingData();

  set distance(double distance) {
    this._distance = distance;
  }

  set bearingAToB(double bearingAToB) {
    this._bearingAToB = bearingAToB;
  }

  set bearingBToA(double bearingBToA) {
    this._bearingBToA = bearingBToA;
  }

  set bearingAToBInRadian(double bearingAToB) {
    this._bearingAToB = radianToDeg(bearingAToB);
  }

  set bearingBToAInRadian(double bearingBToA) {
    this._bearingBToA = radianToDeg(bearingBToA);
  }

  get distance {
    return _distance;
  }

  get bearingAToB {
    return _bearingAToB;
  }

  get bearingBToA {
    return _bearingBToA;
  }

  get bearingAToBInRadian {
    return degToRadian(_bearingAToB);
  }

  get bearingBToAInRadian {
    return degToRadian(_bearingBToA);
  }

  @override
  String toString() {
    return 'distance: $distance, bearingAToB: $bearingAToB, bearingBToA: $bearingBToA';
  }
}
