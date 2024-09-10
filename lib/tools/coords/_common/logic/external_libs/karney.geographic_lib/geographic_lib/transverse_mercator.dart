/**
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2008-2022) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

const int _GEOGRAPHICLIB_TRANSVERSEMERCATOR_ORDER = 8;

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _TransverseMercator {
  final int maxpow_ = _GEOGRAPHICLIB_TRANSVERSEMERCATOR_ORDER;
  final int numit_ = 5;
  late double _a, _f, _k0, _e2, _es, _e2m, _c, _n;
  late double _a1, _b1;
  // _alp[0] and _bet[0] unused
  final List<double> _alp = [0.0];
  final List<double> _bet = [0.0];

  /**
   * Constructor for an eipsoid with
   *
   * @param[in] a equatorial radius (meters).
   * @param[in] f flattening of eipsoid.  Setting \e f = 0 gives a sphere.
   *   Negative \e f gives a prolate eipsoid.
   * @param[in] k0 central scale factor.
   * @exception GeographicErr if \e a, (1 &minus; \e f) \e a, or \e k0 is
   *   not positive.
   **********************************************************************/
  _TransverseMercator(double a, double f, double k0) {
    _a = a;
    _f = f;
    _k0 = k0;
    _e2 = _f * (2 - _f);
    _es = (_f < 0 ? -1 : 1) * sqrt(_e2.abs());
    _e2m = (1 - _e2);
    // _c = sqrt( pow(1 + _e, 1 + _e) * pow(1 - _e, 1 - _e) ) )
    // See, for example, Lee (1976), p 100.
    _c = (sqrt(_e2m) * exp(_GeoMath.eatanhe(1.0, _es)));
    _n = (_f / (2 - _f));

    if (_GEOGRAPHICLIB_TRANSVERSEMERCATOR_ORDER != 8) {
      return;
    }

    const List<double> b1coeff = [
      // b1*(n+1), polynomial in n2 of order 4
      25, 64, 256, 4096, 16384, 16384,
    ];

    const List<double> alpcoeff = [
      // alp[1]/n^1, polynomial in n of order 7
      -75900428, 37884525, 42422016, -89611200, 46287360, 63504000, -135475200,
      101606400, 203212800,
      // alp[2]/n^2, polynomial in n of order 6
      148003883, 83274912, -178508970, 77690880, 67374720, -104509440,
      47174400, 174182400,
      // alp[3]/n^3, polynomial in n of order 5
      318729724, -738126169, 294981280, 178924680, -234938880, 81164160,
      319334400,
      // alp[4]/n^4, polynomial in n of order 4
      -40176129013, 14967552000, 6971354016, -8165836800, 2355138720,
      7664025600,
      // alp[5]/n^5, polynomial in n of order 3
      10421654396, 3997835751, -4266773472, 1072709352, 2490808320,
      // alp[6]/n^6, polynomial in n of order 2
      175214326799, -171950693600, 38652967262, 58118860800,
      // alp[7]/n^7, polynomial in n of order 1
      -67039739596, 13700311101, 12454041600,
      // alp[8]/n^8, polynomial in n of order 0
      1424729850961, 743921418240,
    ];

    const List<double> betcoeff = [
      // bet[1]/n^1, polynomial in n of order 7
      31777436, -37845269, 43097152, -42865200, -752640, 104428800, -180633600,
      135475200, 270950400,
      // bet[2]/n^2, polynomial in n of order 6
      24749483, 14930208, -100683990, 152616960, -105719040, 23224320, 7257600,
      348364800,
      // bet[3]/n^3, polynomial in n of order 5
      -232468668, 101880889, 39205760, -29795040, -28131840, 22619520,
      638668800,
      // bet[4]/n^4, polynomial in n of order 4
      324154477, 1433121792, -876745056, -167270400, 208945440, 7664025600,
      // bet[5]/n^5, polynomial in n of order 3
      457888660, -312227409, -67920528, 70779852, 2490808320,
      // bet[6]/n^6, polynomial in n of order 2
      -19841813847, -3665348512, 3758062126, 116237721600,
      // bet[7]/n^7, polynomial in n of order 1
      -1989295244, 1979471673, 49816166400,
      // bet[8]/n^8, polynomial in n of order 0
      191773887257, 3719607091200,
    ];

    int m = maxpow_ ~/ 2;
    _b1 = _GeoMath.polyval(m, b1coeff, 0, _GeoMath.sq(_n)) / (b1coeff[m + 1] * (1 + _n));
    // _a1 is the equivalent radius for computing the circumference of
    // ellipse.
    _a1 = _b1 * _a;
    int o = 0;
    double d = _n;
    for (int l = 1; l <= maxpow_; ++l) {
      m = maxpow_ - l;
      _alp.add(d * _GeoMath.polyval(m, alpcoeff.sublist(o), 0, _n) / alpcoeff[o + m + 1]);
      _bet.add(d * _GeoMath.polyval(m, betcoeff.sublist(o), 0, _n) / betcoeff[o + m + 1]);
      o += m + 2;
      d *= _n;
    }
  }
}
