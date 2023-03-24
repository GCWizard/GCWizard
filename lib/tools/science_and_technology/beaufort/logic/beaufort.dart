import 'dart:math';

int? meterPerSecondToBeaufort(double velocity) {
  if (velocity < 0) return null;

  if (velocity > 60.0) return 17;

  var vRounded = (velocity * 10).round() / 10.0;
  return pow(vRounded / 0.836, 2.0 / 3.0).round();
}

List<double>? beaufortToMeterPerSecond(int beaufort) {
  if (beaufort < 0) return null;

  if (beaufort > 16) {
    return [56.1, double.infinity];
  }

  double? lowerV;
  var upperV = 0.0;

  for (int i = 0; i < 570; i++) {
    var mPerS = i / 10.0;
    var b = meterPerSecondToBeaufort(mPerS);

    if (b == null || b < beaufort) continue;

    if (b == beaufort) {
      lowerV ??= mPerS;
      upperV = mPerS;
    }

    if (b > beaufort) break;
  }

  return [lowerV ?? 0, upperV];
}
