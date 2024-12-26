part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

class _AzimuthalEquidistantReturn {
  final double xOrLon;
  final double yOrLat;
  final double azi;
  final double rk;
  
  _AzimuthalEquidistantReturn(this.xOrLon, this.yOrLat, this.azi, this.rk);
}

var eps_ = 0.01 * sqrt(practical_epsilon);

class _AzimuthalEquidistant {
  static _AzimuthalEquidistantReturn forward(double lat0, double lon0, double lat, double lon, Ellipsoid ellipsoid) {
    double sig, s, azi0, m;
    var data = _Geodesic(ellipsoid.a, ellipsoid.f).inverse(lat0, lon0, lat, lon);
    s = data.s12;
    azi0 = data.azi1;
    var azi = data.azi2;
    m = data.m12;

    sig = data.a12;
    var p = _Pair();
    _GeoMath.sincosd(azi0, p);
    var x = p.first;
    var y = p.second;
    x *= s;
    y *= s;
    double rk = !(sig <= eps_) ? m / s : 1;

    return _AzimuthalEquidistantReturn(x, y, azi, rk);
  }

  static _AzimuthalEquidistantReturn reverse(double lat0, double lon0, double x, double y, Ellipsoid ellipsoid) {
    double azi0 = _GeoMath.atan2d(x, y),
        s = _GeoMath.hypot(x, y);
    double sig, m;
    var data = _Geodesic(ellipsoid.a, ellipsoid.f).direct(lat0, lon0, azi0, s);
    var lat = data.lat2;
    var lon = data.lon2;
    var azi = data.azi2;
    m = data.m12;
    sig = data.a12;
    var rk = !(sig <= eps_) ? m / s : 1.0;

    return _AzimuthalEquidistantReturn(lon, lat, azi, rk);
  }
}