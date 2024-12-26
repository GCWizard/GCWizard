// https://myscope.net/hitzeindex-gefuehle-temperatur/
//
// http://summersimmer.com/home.htm
// http://summersimmer.com/default.asp
// http://summersimmer.com/ssi.htm

enum SUMMERSIMMER_HEATSTRESS_CONDITION { BLUE, PINK, ORANGE, GREEN, PURPLE, RED, BROWN, BLACK }

final Map<SUMMERSIMMER_HEATSTRESS_CONDITION, double> SUMMERSIMMER_HEAT_STRESS = {
  SUMMERSIMMER_HEATSTRESS_CONDITION.BLUE: 21.3,
  SUMMERSIMMER_HEATSTRESS_CONDITION.PINK: 25.0,
  SUMMERSIMMER_HEATSTRESS_CONDITION.ORANGE: 28.3,
  SUMMERSIMMER_HEATSTRESS_CONDITION.GREEN: 32.8,
  SUMMERSIMMER_HEATSTRESS_CONDITION.PURPLE: 37.8,
  SUMMERSIMMER_HEATSTRESS_CONDITION.RED: 44.4,
  SUMMERSIMMER_HEATSTRESS_CONDITION.BROWN: 51.7,
  SUMMERSIMMER_HEATSTRESS_CONDITION.BLACK: 65.5,
};

double calculateSummerSimmerIndex(double temperature, double humidity) {
  double summerSimmerIndex = 0;

  temperature = temperature * 1.8 + 32;
  summerSimmerIndex = ((1.98 * (temperature - (0.55 - 0.0055 * humidity) * (temperature - 58)) - 56.83) - 32) * 5 / 9;

  return summerSimmerIndex;
}
