/**
 * Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================
 *
 * \brief %Geodesic intersections
 *
 * Find the intersections of two geodesics \e X and \e Y.  Four calling
 * sequences are supported.
 * - The geodesics are defined by a position (latitude and longitude) and an
 *   azimuth.  In this case the \e closest intersection is found.
 * - The geodesics are defined by two endpoints.  The intersection of the two
 *   segments is found.  It they don't intersect, the the closest
 *   intersection is returned.
 * - The geodesics are defined as an intersection point, a single position
 *   and two azimuths.  In this case, the next closest intersection is found.
 * - The geodesics are defined as in the first case and all intersection
 *   within a specified distance are returned.
 * .
 * In all cases the position of the intersection is given by the signed
 * displacements \e x and \e y along the geodesics from the starting point
 * (the first point in the case of a geodesic segment).  The closest
 * itersection is defined as the one that minimizes the L1 distance,
 * Intersect::Dist([<i>x</i>, <i>y</i>) = |<i>x</i>| + |<i>y</i>|.
 *
 * The routines also optionally return a coincidence indicator \e c.  This is
 * typically 0.  However if the geodesics lie on top of one another at the
 * point of intersection, then \e c is set to +1, if they are parallel, and
 * &minus;1, if they are antiparallel.
 *
 * Example of use:
 * \include example-Intersect.cpp
 *
 * <a href="IntersectTool.1.html">IntersectTool</a> is a command-line utility
 * providing access to the functionality of this class.
 *
 * This solution for intersections is described in
 * - C. F. F. Karney,<br>
 *   <a href="https://arxiv.org/abs/yymm.nnnnn">
 *   Geodesic intersections</a>,<br>
 *   Technical Report, SRI International, MMM 2023.<br>
 *   <a href="https://arxiv.org/abs/yymm.nnnnn">arxiv:yymm.nnnnn</a>
 * .
 * It is based on the work of
 * - S. Baseldga and J. C. Martinez-Llario,
 *   <a href="https://doi.org/10.1007/s11200-017-1020-z">
 *   Intersection and point-to-line solutions for geodesics
 *   on the ellipsoid</a>,
 *   Stud. Geophys. Geod. <b>62</b>, 353--363 (2018);
 *   DOI: <a href="https://doi.org/10.1007/s11200-017-1020-z">
 *   10.1007/s11200-017-1020-z</a>.
 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

class _Intersect {
  static const int LineCaps = _GeodesicMask.LATITUDE | _GeodesicMask.LONGITUDE |
  _GeodesicMask.AZIMUTH | _GeodesicMask.REDUCEDLENGTH | _GeodesicMask.GEODESICSCALE |
  _GeodesicMask.DISTANCE_IN;

  static const int numit_ = 100;
  late final _Geodesic _geod;
  final double _a, _f;          // equatorial radius, flattening
  late final double _R,         // authalic radius
      _d,                       // pi*_R
      _eps,                     // criterion for intersection + coincidence
      _tol,                     // convergence for Newton in Solve1
      _delta,                   // for equality tests, safety margin for tiling
      _t1,                      // min distance between intersections
      _t2,                      // furthest dist to closest intersection
      _t3,                      // 1/2 furthest min dist to next intersection
      _t4,                      // capture radius for spherical sol in Solve0
      _t5,                      // longest shortest geodesic
      _d1,                      // tile spacing for Closest
      _d2,                      // tile spacing for Next
      _d3;                      // tile spacing for All
  late int _cnt0, _cnt1, _cnt2, _cnt3, _cnt4;
  late final _SetComp _comp;

  _Intersect(this._a, this._f) {
    _geod = _Geodesic(_a, _f);
    _R = sqrt(_geod.ellipsoidArea() / (4 * _GeoMath.pi()));
    _d = _R * _GeoMath.pi();      // Used to normalize intersection points
    _eps = 3 * practical_epsilon;
    _tol = _d * pow(practical_epsilon, 3/4.0);
    _delta = _d * pow(practical_epsilon, 1/5.0);
    _comp = _SetComp(_delta);
    _cnt0 = 0;
    _cnt1 = 0;
    _cnt2 = 0;
    _cnt3 = 0;
    _cnt4 = 0;

    _t1 = _a * (1 - _f) * _GeoMath.pi();
    _t2 = 2 * distpolar(90).ret;
    _t5 = _geod.inverse(0, 0, 90, 0).s12 * 2;
    if (_f > 0) {
      _t3 = distoblique().ret;
      _t4 = _t1;
    } else {
      _t3 = _t5;
      _t4 = polarb().ret;
      var h = _t1; _t1 = _t2; _t2 = h;
    }
    _d1 = _t2 / 2;
    _d2 = 2 * _t3 / 3;
    _d3 = _t4 - _delta;
    // if (! (_d1 < _d3 && _d2 < _d3 && _d2 < 2 * _t1) )
    //   throw GeographicErr("Ellipsoid too eccentric for Closest");
  }

  _PolarBReturn polarb({double? lata, double? latb}) {
    if (_f == 0) {
      lata = 64;
      latb = 90-64;
      return _PolarBReturn(_d, lata, latb);
    }
    double
    lat0 = 63, s0 = distpolar(lat0).ret,
    lat1 = 65, s1 = distpolar(lat1).ret,
    lat2 = 64, s2 = distpolar(lat2).ret,
    latx = lat2, sx = s2;
    // Solve for ds(lat)/dlat = 0 with a quadratic fit
    for (int i = 0; i < 10; ++i) {
      double den = (lat1-lat0)*s2 + (lat0-lat2)*s1 + (lat2-lat1)*s0;
      if (!(den < 0 || den > 0)) break; // Break if nan
      double latn = ((lat1-lat0)*(lat1+lat0)*s2 + (lat0-lat2)*(lat0+lat2)*s1 +
      (lat2-lat1)*(lat2+lat1)*s0) / (2*den);
      lat0 = lat1; s0 = s1;
      lat1 = lat2; s1 = s2;
      lat2 = latn; s2 = distpolar(lat2).ret;
      if (_f < 0 ? (s2 < sx) : (s2 > sx)) {
        sx = s2;
        latx = lat2;
      }
    }
    lata = latx;
    if (latb != null) latb = distpolar(latx, latb).lat2!;
    return _PolarBReturn(2 * sx, lata, latb);
  }
  
  _DistPolarReturn distpolar(double lat1, [double? lat2]) {
    _GeodesicLine line = _geod._Line(lat1, 0, 0,
        _GeodesicMask.REDUCEDLENGTH |
        _GeodesicMask.GEODESICSCALE |
        _GeodesicMask.DISTANCE_IN
    );
    double s = ConjugateDist(line, (1 + _f / 2) * _a * _GeoMath.pi() / 2, true);
    if (lat2 != null) {
      lat2 = line._genPosition(false, s, _GeodesicMask.LATITUDE).lat2;
    }
    return _DistPolarReturn(s, lat2);
  }

  // Find {semi-,}conjugate point relative to s0 which is close to s1.
  double ConjugateDist(_GeodesicLine line, double s3,
      bool semi, {double m12 = 0, double M12 = 1, double M21 = 1}) {
    // semi = false: solve for m23 = 0 using dm23/ds3 = M32
    // semi = true : solve for M23 = 0 using dM23/ds3 = - (1 - M23*M32)/m23
    // Here 2 is point with given m12, M12, M21 and default values s.t. point 2
    // = point 1.
    double s = s3;
    for (int i = 0; i < 100; ++i) {
      double m13, M13, M31;
      var data = line._genPosition(false, s,
          _GeodesicMask.REDUCEDLENGTH |
          _GeodesicMask.GEODESICSCALE);

      m13 = data.m12;
      M13 = data.M12;
      M31 = data.M21;

      double
      // See "Algorithms for geodesics", eqs. 31, 32, 33.
      m23 = m13 * M12 - m12 * M13,
      // when m12 -> eps, (1 - M12 * M21) -> eps^2, I suppose.
      M23 = M13 * M21 + (m12 == 0 ? 0 : (1 - M12 * M21) * m13/m12),
      M32 = M31 * M12 + (m13 == 0 ? 0 : (1 - M13 * M31) * m12/m13);
      double ds = semi ? m23 * M23 / (1 - M23*M32) : -m23 / M32;
      s = s + ds;
      if (!(ds.abs() > _tol)) break;
    }
    return s;
  }

  _DistObliqueReturn distoblique({double? azi, double? sp, double? sm}) {
    if (_f == 0) {
      azi = 45;
      sp = 0.5;
      sm = -1.5;
      return _DistObliqueReturn(_d, azi, sp, sm);
    }
    double azi0 = 46;
    _ConjDistReturn cdr = conjdist(azi0);
    double s0 = cdr.ret, ds0 = cdr.ds, sa = cdr.sp, sb = cdr.sm;
    double azi1 = 44;
    cdr = conjdist(azi1);
    double s1 = cdr.ret, ds1 = cdr.ds; sa = cdr.sp; sb = cdr.sm;

    double azix = azi1, dsx = ds1.abs(), sx = s1, sax = sa, sbx = sb;
    // find ds(azi) = 0 by secant method
    for (int i = 0; i < 10 && ds1 != ds0; ++i) {
      double azin = (azi0*ds1-azi1*ds0)/(ds1-ds0);
      azi0 = azi1; s0 = s1; ds0 = ds1;
      azi1 = azin;
      cdr = conjdist(azi1);
      s1 = cdr.ret; ds1 = cdr.ds; sa = cdr.sp; sb = cdr.sm;
      if (ds1.abs() < dsx) {
        azix = azi1; sx = s1; dsx = ds1.abs();
        sax = sa; sbx = sb;
        if (ds1 == 0) break;
      }
    }

    azi = azix;
    sp = sax;
    sm = sbx;

    return _DistObliqueReturn(sx, azi, sp, sm);
  }

  _ConjDistReturn conjdist(double azi) {
    _GeodesicLine line = _geod._Line(0, 0, azi, LineCaps);
    double s = ConjugateDist(line, _d, false);

    _XPoint p = Basic(line, line, _XPoint(s/2, -3*s/2));
    double sp = p.x;
    double sm = p.y;
    double ds = p.Dist() - 2*s;

    return _ConjDistReturn(s, ds, sp, sm);
  }

  _XPoint Spherical(_GeodesicLine lineX, _GeodesicLine lineY, _XPoint p) {
    // threshold for coincident geodesics and intersections; this corresponds
    // to about 4.3 nm on WGS84.
    var data = lineX._genPositionOnlyDistance(p.x);
    double latX = data.lat2, lonX = data.lon2, aziX = data.azi2;
    data = lineY._genPositionOnlyDistance(p.y);
    double latY = data.lat2, lonY = data.lon2, aziY = data.azi2;
    data = _geod.inverse(latX, lonX, latY, lonY);
    double z = data.s12, aziXa = data.azi1, aziYa = data.azi2;
    double sinz = sin(z/_R), cosz = cos(z/_R);
    // X = interior angle at X, Y = exterior angle at Y
    _Pair X_ADE = _GeoMath.AngDiffError(aziX, aziXa), Y_ADE = _GeoMath.AngDiffError(aziY, aziYa);
    double X = X_ADE.first, Y = Y_ADE.first;
    _Pair XY_ADE = _GeoMath.AngDiffError(X, Y);
    double XY = XY_ADE.first, dX = X_ADE.second, dY = Y_ADE.second, dXY = XY_ADE.second;

    double s = _copySign(1.0, XY + (dXY + dY - dX)); // inverted triangle
    // For z small, sinz -> z, cosz -> 1
    // ( sinY*cosX*cosz - cosY*sinX) =
    // (-sinX*cosY*cosz + cosX*sinY) -> sin(Y-X)
    // for z = pi, sinz -> 0, cosz -> -1
    // ( sinY*cosX*cosz - cosY*sinX) -> -sin(Y+X)
    // (-sinX*cosY*cosz + cosX*sinY) ->  sin(Y+X)
    _Pair pX = _Pair(), pY = _Pair();
    _GeoMath.sincosde(s*X, s*dX, pX);
    double sinX = pX.first, cosX = pX.second;
    _GeoMath.sincosde(s*Y, s*dY, pY);
    double sinY = pY.first, cosY = pY.second;
    double sX, sY;
    int c;
    if (z <= _eps * _R) {
      sX = sY = 0;              // Already at intersection
      // Determine whether lineX and lineY are parallel or antiparallel
      if ((sinX - sinY).abs() <= _eps && (cosX - cosY).abs() <= _eps) {
        c = 1;
      }else if ((sinX + sinY).abs() <= _eps && (cosX + cosY).abs() <= _eps) {
        c = -1;
      } else {
        c = 0;
      }
    } else if ((sinX).abs() <= _eps && (sinY).abs() <= _eps) {
      c = cosX * cosY > 0 ? 1 : -1;
      // Coincident geodesics, place intersection at midpoint
      sX =  cosX * z/2; sY = -cosY * z/2;
      // alt1: sX =  cosX * z; sY = 0;
      // alt2: sY = -cosY * z; sX = 0;
    } else {
      // General case.  [SKIP: Divide args by |sinz| to avoid possible
      // underflow in {sinX,sinY}*sinz; this is probably not necessary].
      // Definitely need to treat sinz < 0 (z > pi*R) correctly.  Without
      // this we have some convergence failures in Basic.
      sX = _R * atan2(sinY * sinz,  sinY * cosX * cosz - cosY * sinX);
      sY = _R * atan2(sinX * sinz, -sinX * cosY * cosz + cosX * sinY);
      c = 0;
    }
    return _XPoint(sX, sY, c);
  }

  _XPoint Basic(_GeodesicLine lineX, _GeodesicLine lineY, _XPoint p0) {
    ++_cnt1;
    _XPoint q = p0;
    for (int n = 0; n < numit_ || _GEOGRAPHICLIB_PANIC; ++n) {
      ++_cnt0;
      _XPoint dq = Spherical(lineX, lineY, q);
      q += dq;
      if (q.c != 0 || !(dq.Dist() > _tol)) break; // break if nan
    }
    return q;
  }

  /**
   * Find the closest intersection point, with each geodesic specified by
   *   position and azimuth.
   *
   * @param[in] latX latitude of starting point for geodesic \e X (degrees).
   * @param[in] lonX longitude of starting point for geodesic \e X  (degrees).
   * @param[in] aziX azimuth at starting point for geodesic \e X (degrees).
   * @param[in] latY latitude of starting point for geodesic \e Y (degrees).
   * @param[in] lonY longitude of starting point for geodesic \e Y  (degrees).
   * @param[in] aziY azimuth at starting point for geodesic \e Y (degrees).
   * @param[in] p0 an optional offset for the starting points (meters),
   *   default = [0,0].
   * @param[out] c optional pointer to an integer coincidence indicator.
   * @return \e p the intersection point closest to \e p0.
   *
   * The returned intersection minimizes Intersect::Dist(\e p, \e p0).
   **********************************************************************/
  _Point closest(double latX, double lonX, double aziX, double latY, double lonY, double aziY) {
    return _closest(_geod._Line(latX, lonX, aziX, LineCaps), _geod._Line(latY, lonY, aziY, LineCaps));
  }

  _Point _closest(_GeodesicLine lineX, _GeodesicLine lineY) {
    _XPoint p = ClosestInt(lineX, lineY);
    return p.data();
  }

  _XPoint ClosestInt(_GeodesicLine lineX, _GeodesicLine lineY) {
    const int num = 5;
    const ix = <int>[0,  1, -1,  0,  0];
    const iy = <int>[0,  0,  0,  1, -1];
    var skip = <bool>[false,  false,  false,  false,  false];
    _XPoint q = _XPoint.fromDefault();                    // Best intersection so far
    for (int n = 0; n < num; ++n) {
      if (skip[n]) continue;
      _XPoint qx = Basic(lineX, lineY, _XPoint(ix[n] * _d1, iy[n] * _d1));
      if (_comp.eq(q, qx)) continue;
      if (qx.Dist() < _t1) { q = qx; ++_cnt2; break; }
      if (n == 0 || qx.Dist() < q.Dist()) { q = qx; ++_cnt2; }
      for (int m = n + 1; m < num; ++m) {
        skip[m] = skip[m] ||
            qx.Dist(_XPoint(ix[m] * _d1, iy[m] * _d1)) < 2 * _t1 - _d1 - _delta;
      }
    }
    return q;
  }
}

class _Point {
  final double first;
  final double second;
  
  _Point(this.first, this.second);
}

// An internal version of Point with a little more functionality
class _XPoint {
  double x, y;
  int c;

  _XPoint(this.x, this.y, [this.c = 0]);

  static _XPoint fromDefault() {
    return _XPoint(double.nan, double.nan, 0);
  }

  static _XPoint fromPoint(_Point p) {
    return _XPoint(p.first, p.second, 0);
  }

  _XPoint operator +(_XPoint p) {
    _XPoint t = this;

    t.x += p.x; t.y += p.y;
    if (p.c != 0) t.c = p.c;

    return t;
  }

  double Dist([_XPoint? p]) {
    if (p == null) return _d1(x, y);

    return _d1(x - p.x, y - p.y);
  }

  _Point data() { return _Point(x, y);}
}

class _SetComp {
  final double _delta;

  _SetComp(this._delta);

  bool eq(_XPoint p, _XPoint q) {
    return _d1(p.x - q.x, p.y - q.y) <= _delta;
  }
  
  // bool operator()(XPoint p, XPoint q) {
  //   return !eq(p, q) && ( p.x != q.x ? p.x < q.x : p.y < q.y );
  // }
}

double _d1(double x, double y) {
  return x.abs() + y.abs();
}

class _PolarBReturn {
  final double? lata, latb;
  final double ret;

  _PolarBReturn(this.ret, [this.lata, this.latb]);
}

class _DistPolarReturn {
  final double? lat2;
  final double ret;

  _DistPolarReturn(this.ret, [this.lat2]);
}

class _DistObliqueReturn {
  final double? azi, sp, sm;
  final double ret;

  _DistObliqueReturn(this.ret, [this.azi, this.sp, this.sm]);
}

class _ConjDistReturn {
  final double ds, sp, sm;
  final double ret;

  _ConjDistReturn(this.ret, this.ds, this.sp, this.sm);
}