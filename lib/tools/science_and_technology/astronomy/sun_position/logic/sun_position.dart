import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/astronomy_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/external_libs/astronomie_info/astronomy.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class SunPosition {
  double distanceToEarthCenter;
  double distanceToObserver;
  double eclipticLongitude;
  double rightAscension;
  double declination;
  double azimuth;
  double altitude;
  double diameter;
  AstrologicalSign astrologicalSign;

  double greenwichSiderealTime;
  double localSiderealTime;

  SunPosition(LatLng coords, JulianDate julianDate, Ellipsoid ellipsoid) {
    greenwichSiderealTime = GMST(julianDate.julianDate);
    localSiderealTime = GMST2LMST(greenwichSiderealTime, coords.longitudeInRad);

    Coor sunPos = sunPosition(julianDate.terrestrialDynamicalTime, ellipsoid.a / 1000.0, coords.latitudeInRad,
        degreesToRadian(localSiderealTime * 15.0), true);

    eclipticLongitude = radianToDegrees(sunPos.lon);
    rightAscension = radianToDegrees(sunPos.ra) / 15.0;
    declination = radianToDegrees(sunPos.dec);
    azimuth = radianToDegrees(sunPos.az);
    altitude = radianToDegrees(sunPos.alt) + refraction(sunPos.alt);
    astrologicalSign = sunPos.sign;
    diameter = radianToDegrees(sunPos.diameter) * 60.0;
    distanceToEarthCenter = sunPos.distance;

    var sunCart = equPolar2Cart(sunPos.ra, sunPos.dec, sunPos.distance);
    var observerCart =
        observer2EquCart(coords.longitudeInRad, coords.latitudeInRad, 0, greenwichSiderealTime, ellipsoid);
    distanceToObserver = sqrt(
        pow(sunCart.x - observerCart.x, 2) + pow(sunCart.y - observerCart.y, 2) + pow(sunCart.z - observerCart.z, 2));
  }
}
