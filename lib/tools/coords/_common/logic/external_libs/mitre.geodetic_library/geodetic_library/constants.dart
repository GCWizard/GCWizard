/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

const _M_PI = pi;
const _M_2PI = pi * 2;
const _M_PI_2 = pi / 2;

/*
 *   \brief Tolerance
 *   \returns double tolerance of 1.0e-9
 *   \note Order 8260.54A Appendix 2, 3.3 Tolerances, states
 *   "Empirical studies have shown that eps = 0.5e-13 and
 *   tol = 1.0-e9 work well."
 *
 */
const _TOL = 1.0e-9;
/* Not a scientific number, but something near zero is needed in a few cases */
const _INTERNAL_ZERO = 1.0e-15;

const _MAX_ITERATIONS = 100;

const _NMI_IN_METERS = 1852.0;

double _MAX_ELLIPSOIDAL_ARC_RADIUS_NMI(Ellipsoid ellipsoid) {
  return (_M_PI_2 * (1.0 - ellipsoid.f) * ellipsoid.a / _NMI_IN_METERS);
}