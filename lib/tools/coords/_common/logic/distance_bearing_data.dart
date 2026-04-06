import 'package:latlong2/latlong.dart';

class DistanceBearingData {
  double distance = 0.0;
  double bearingAToB = 0.0;
  double bearingBToA = 0.0;

  DistanceBearingData();

  set bearingAToBInRadian(double bearingAToB) {
    this.bearingAToB = radianToDeg(bearingAToB);
  }

  set bearingBToAInRadian(double bearingBToA) {
    this.bearingBToA = radianToDeg(bearingBToA);
  }

  double get bearingAToBInRadian {
    return degToRadian(bearingAToB);
  }

  double get bearingBToAInRadian {
    return degToRadian(bearingBToA);
  }

  @override
  String toString() {
    return 'distance: $distance, bearingAToB: $bearingAToB, bearingBToA: $bearingBToA';
  }
}
