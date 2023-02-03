// https://de.wikipedia.org/wiki/Blutalkoholkonzentration

enum BloodAlcoholGender { MEN, WOMEN, CHILDREN }

double _DENSITY_ETHANOL_IN_G_PER_ML = 0.78924;

double alcoholMassInG(double volumeInML, double alcoholByMassInPercent) {
  if (alcoholByMassInPercent <= 0.0 || volumeInML <= 0.0) return 0.0;

  return volumeInML * alcoholByMassInPercent / 100.0 * _DENSITY_ETHANOL_IN_G_PER_ML;
}

double alcoholVolumeInML(double alcoholMassInG, double alcoholByMassInPercent) {
  if (alcoholByMassInPercent <= 0.0 || alcoholMassInG <= 0.0) return 0.0;

  return alcoholMassInG / (alcoholByMassInPercent / 100.0 * _DENSITY_ETHANOL_IN_G_PER_ML);
}

double alcoholByMassInPercent(double alcoholMassInG, double volumeInML) {
  if (alcoholMassInG <= 0.0 || volumeInML <= 0.0) return 0.0;

  return 100 * (alcoholMassInG / (volumeInML * _DENSITY_ETHANOL_IN_G_PER_ML));
}

double _bloodAlcoholInPermille(double waterRatioPerWeight, double alcoholMassInG, double massOfPersonInKG) {
  if (alcoholMassInG <= 0.0) return 0.0;

  return alcoholMassInG / (massOfPersonInKG * waterRatioPerWeight);
}

Map<String, double> bloodAlcoholInPermilleWidmark(
    BloodAlcoholGender gender, double alcoholMassInG, double massOfPersonInKG) {
  if (alcoholMassInG <= 0.0 || massOfPersonInKG <= 0.0) return {'min': 0.0, 'max': 0.0};

  var waterRatio;
  switch (gender) {
    case BloodAlcoholGender.MEN:
      waterRatio = [0.68, 0.7];
      break;
    case BloodAlcoholGender.WOMEN:
      waterRatio = [0.55, 0.6];
      break;
    case BloodAlcoholGender.CHILDREN:
      waterRatio = [0.75, 0.8];
      break;
  }

  return {
    'min': _bloodAlcoholInPermille(waterRatio[0], alcoholMassInG, massOfPersonInKG),
    'max': _bloodAlcoholInPermille(waterRatio[1], alcoholMassInG, massOfPersonInKG),
  };
}

double bloodAlcoholInPermilleWidmarkSeidl(
    BloodAlcoholGender gender, double alcoholMassInG, double massOfPersonInKG, double bodyHeightInCM) {
  if (alcoholMassInG <= 0.0 || massOfPersonInKG <= 0.0 || bodyHeightInCM <= 0.0) return 0.0;

  var waterRatio;
  switch (gender) {
    case BloodAlcoholGender.WOMEN:
      waterRatio = 0.31233 - 0.006446 * massOfPersonInKG + 0.004466 * bodyHeightInCM;
      break;
    case BloodAlcoholGender.MEN:
      waterRatio = 0.31608 - 0.004821 * massOfPersonInKG + 0.004432 * bodyHeightInCM;
      break;
    default:
      return null;
  }

  return _bloodAlcoholInPermille(waterRatio, alcoholMassInG, massOfPersonInKG);
}

double bloodAlcoholInPermilleWidmarkUlrich(
    BloodAlcoholGender gender, double alcoholMassInG, double massOfPersonInKG, double bodyHeightInCM) {
  if (alcoholMassInG <= 0.0 || massOfPersonInKG <= 0.0 || bodyHeightInCM <= 0.0) return 0.0;

  var waterRatio;
  switch (gender) {
    case BloodAlcoholGender.MEN:
      waterRatio = 0.715 - 0.00462 * massOfPersonInKG + 0.0022 * bodyHeightInCM;
      break;
    default:
      return null;
  }

  return _bloodAlcoholInPermille(waterRatio, alcoholMassInG, massOfPersonInKG);
}

double _bloodAlcoholInPermilleWidmarkWatson(
    double volumeWaterInBodyInL, double alcoholMassInG, double massOfPersonInKG) {
  if (volumeWaterInBodyInL <= 0.0 || massOfPersonInKG <= 0.0) return 0.0;

  double _BLOOD_DENSITY_IN_G_PER_CM3 = 1.055;
  var waterRatio =
      _BLOOD_DENSITY_IN_G_PER_CM3 * volumeWaterInBodyInL / (_DENSITY_ETHANOL_IN_G_PER_ML * massOfPersonInKG);

  return _bloodAlcoholInPermille(waterRatio, alcoholMassInG, massOfPersonInKG);
}

double bloodAlcoholInPermilleWidmarkWatson(
    BloodAlcoholGender gender, double alcoholMassInG, double massOfPersonInKG, double bodyHeightInCM, int age) {
  if (alcoholMassInG <= 0.0 || massOfPersonInKG <= 0.0 || bodyHeightInCM <= 0.0 || age <= 0) return 0.0;

  var volumeWaterInBodyInL;

  switch (gender) {
    case BloodAlcoholGender.MEN:
      volumeWaterInBodyInL = 2.447 - 0.09516 * age + 0.1074 * bodyHeightInCM + 0.3362 * massOfPersonInKG;
      break;
    case BloodAlcoholGender.WOMEN:
      volumeWaterInBodyInL = -2.097 + 0.1069 * bodyHeightInCM + 0.2466 * massOfPersonInKG;
      break;
    default:
      return null;
  }

  return _bloodAlcoholInPermilleWidmarkWatson(volumeWaterInBodyInL, alcoholMassInG, massOfPersonInKG);
}

double bloodAlcoholInPermilleWidmarkWatsonEicker(
    BloodAlcoholGender gender, double alcoholMassInG, double massOfPersonInKG, double bodyHeightInCM, int age) {
  if (alcoholMassInG <= 0.0 || massOfPersonInKG <= 0.0 || bodyHeightInCM <= 0.0 || age <= 0) return 0.0;

  var volumeWaterInBodyInL;

  switch (gender) {
    case BloodAlcoholGender.WOMEN:
      volumeWaterInBodyInL = 0.203 + 0.07 * age + 0.1069 * bodyHeightInCM + 0.2466 * massOfPersonInKG;
      break;
    default:
      return null;
  }

  return _bloodAlcoholInPermilleWidmarkWatson(volumeWaterInBodyInL, alcoholMassInG, massOfPersonInKG);
}
