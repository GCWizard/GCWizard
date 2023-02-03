import 'dart:math';

// p principal sum - Endkapital
// p_ original principal sum - Startkapital
// interest - Zins
// compound interest - Zinseszins
// r annual interest rate - Jahreszinssatz (in %)
// n compounding frequency - Zinsperioden im Jahr
// t total years

enum COMPOUND_FREQUENCY { YEARLY, MONTHLY, QUARTERLY, WEEKLY, DAILY_360, DAILY_365 }

int compoundFrequency(COMPOUND_FREQUENCY freq) {
  switch (freq) {
    case COMPOUND_FREQUENCY.YEARLY:
      return 1;
    case COMPOUND_FREQUENCY.MONTHLY:
      return 12;
    case COMPOUND_FREQUENCY.QUARTERLY:
      return 4;
    case COMPOUND_FREQUENCY.WEEKLY:
      return 52;
    case COMPOUND_FREQUENCY.DAILY_360:
      return 360;
    case COMPOUND_FREQUENCY.DAILY_365:
      return 365;
  }
}

double principalSumCompound(double p_, r, t, int n) {
  return p_ * pow(1 + (r / n / 100.0), n * t);
}

double principalSum(double p_, r, t) {
  var i = p_ * (r / 100.0);
  return p_ + t * i;
}

double originalPrincipalSumCompound(double p, r, t, int n) {
  return p / pow(1 + (r / n / 100.0), n * t);
}

double originalPrincipalSum(double p, r, t) {
  return p / (1 + t * (r / 100.0));
}

double annualInterestRateCompound(double p_, p, t, int n) {
  return n * 100.0 * (pow(p / p_, 1 / (t * n)) - 1);
}

double annualInterestRate(double p_, p, t) {
  return 100.0 * ((p - p_) / (t * p_));
}

double totalYearsCompound(double p_, p, r, int n) {
  return log(p / p_) / log(pow(r / n / 100.0 + 1, n));
}

double totalYears(double p_, p, r) {
  return (p - p_) / (p_ * (r / 100.0));
}
