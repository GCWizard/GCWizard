// https://myscope.net/hitzeindex-gefuehle-temperatur/

enum SUMMERSIMMER_HEATSTRESS_CONDITION { BLUE, LIGHT_BLUE, WHITE, LIGHT_YELLOW, YELLOW, ORANGE, RED }

final Map<SUMMERSIMMER_HEATSTRESS_CONDITION, double> SUMMERSIMMER_HEAT_STRESS = {
  SUMMERSIMMER_HEATSTRESS_CONDITION.BLUE: 21.3,
  SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_BLUE: 25.0,
  SUMMERSIMMER_HEATSTRESS_CONDITION.WHITE: 28.3,
  SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_YELLOW: 32.8,
  SUMMERSIMMER_HEATSTRESS_CONDITION.YELLOW: 37.8,
  SUMMERSIMMER_HEATSTRESS_CONDITION.ORANGE: 44.4,
  SUMMERSIMMER_HEATSTRESS_CONDITION.RED: 51.7,
};

double calculateSummerSimmerIndex(double temperature, double humidity) {
  double summerSimmerIndex = 0;

  temperature = temperature * 1.8 + 32;
  summerSimmerIndex = ((1.98 * (temperature - (0.55 - 0.0055 * humidity) * (temperature - 58)) - 56.83) - 32) * 5 / 9;

  return summerSimmerIndex;
}
