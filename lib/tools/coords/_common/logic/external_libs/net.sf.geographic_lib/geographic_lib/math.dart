part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/*
 * Constant by which to multiply an angular value in degrees to obtain an
 * angular value in radians.
 */
const double _DEGREES_TO_RADIANS = 0.017453292519943295;

/*
 * Constant by which to multiply an angular value in radians to obtain an
 * angular value in degrees.
 */
const double _RADIANS_TO_DEGREES = 57.29577951308232;

/*
 * Converts an angle measured in degrees to an approximately
 * equivalent angle measured in radians.  The conversion from
 * degrees to radians is generally inexact.
 *
 * @param   angdeg   an angle, in degrees
 * @return  the measurement of the angle {@code angdeg}
 *          in radians.
 */
double _toRadians(double angdeg) {
  return angdeg * _DEGREES_TO_RADIANS;
}

/*
 * Converts an angle measured in radians to an approximately
 * equivalent angle measured in degrees.  The conversion from
 * radians to degrees is generally inexact; users should
 * <i>not</i> expect {@code cos(toRadians(90.0))} to exactly
 * equal {@code 0.0}.
 *
 * @param   angrad   an angle, in radians
 * @return  the measurement of the angle {@code angrad}
 *          in degrees.
 */
double _toDegrees(double angrad) {
  return angrad * _RADIANS_TO_DEGREES;
}

/*
 * @summary Copy the sign.
 * @param {number} x gives the magitude of the result.
 * @param {number} y gives the sign of the result.
 * @returns {number} value with the magnitude of x and with the sign of y.
 */
double _copySign(double x, double y) {
  return x.abs() * (y < 0 || (y == 0 && 1 / y < 0) ? -1 : 1);
}

double _hypot(double x, double y) {
  return sqrt(pow(x, 2) + pow(y, 2));
}

double _cbrt(double x) {
  return pow(x.abs(), 1.0 / 3.0) * x.sign;
}

double _logBase(double a, double base) {
  return log(a) / log(base);
}

double _log2(double a) {
  return _logBase(a, 2);
}

double _exp2(double a) {
  return pow(2.0, a).toDouble();
}

/// from dart_numerics: Hyperbolic Area Sine.
double _asinh(double value) {
  // asinh(x) = Sign(x) * ln(|x| + sqrt(x*x + 1))
  // if |x| > huge, asinh(x) ~= Sign(x) * ln(2|x|)

  if (value.abs() >= 268435456.0) {
    // 2^28, taken from freeBSD
    return value.sign * (log(value.abs()) + log(2.0));
  }

  return value.sign *
      log(value.abs() + sqrt((value * value) + 1));
}

/// from dart_numerics: Hyperbolic Sine.
double _sinh(double angle) {
  return (exp(angle) - exp(-angle)) / 2;
}

/// from dart_numerics: Hyperbolic Cosine.
double _cosh(double angle) {
  return (exp(angle) + exp(-angle)) / 2;
}

