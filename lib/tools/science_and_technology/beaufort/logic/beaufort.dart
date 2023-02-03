import 'dart:math';

int meterPerSecondToBeaufort(double velocity) {
  if (velocity == null || velocity < 0) return null;

  if (velocity > 60.0) return 17;

  var vRounded = (velocity * 10).round() / 10.0;
  return pow(vRounded / 0.836, 2.0 / 3.0).round();
}

List<double> beaufortToMeterPerSecond(int beaufort) {
  if (beaufort == null || beaufort < 0) return null;

  if (beaufort > 16) {
    return [56.1, double.infinity];
  }

  var lowerV;
  var upperV = 0.0;

  for (int i = 0; i < 570; i++) {
    var mPerS = i / 10.0;
    var b = meterPerSecondToBeaufort(mPerS);

    if (b < beaufort) continue;

    if (b == beaufort) {
      if (lowerV == null) lowerV = mPerS;
      upperV = mPerS;
    }

    if (b > beaufort) break;
  }

  return [lowerV, upperV];
}
