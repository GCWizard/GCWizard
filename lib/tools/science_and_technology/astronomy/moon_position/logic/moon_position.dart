import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/astronomy_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/external_libs/astronomie_info/astronomy.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class MoonPosition {
  final LUNATION = 29.530589;

  late double distanceToEarthCenter;
  late double distanceToObserver;
  late double eclipticLongitude;
  late double eclipticLatitude;
  late double rightAscension;
  late double declination;
  late double azimuth;
  late double altitude;
  late double diameter;
  late int phaseNumber;
  late MoonPhase phaseName;
  late double age;
  late AstrologicalSign astrologicalSign;
  late double illumination;
  late double greenwichSiderealTime;
  late double localSiderealTime;

  MoonPosition(LatLng coords, JulianDate julianDate, Ellipsoid ellipsoid) {
    greenwichSiderealTime = GMST(julianDate.julianDate);
    localSiderealTime = GMST2LMST(greenwichSiderealTime, coords.longitudeInRad);

    Coor sunPos = sunPosition(julianDate.terrestrialDynamicalTime, ellipsoid.a / 1000.0, coords.latitudeInRad,
        degreesToRadian(localSiderealTime * 15.0), true);

    var observerCart =
        observer2EquCart(coords.longitudeInRad, coords.latitudeInRad, 0, greenwichSiderealTime, ellipsoid);

    Coor moonPos = moonPosition(
        sunPos, julianDate.terrestrialDynamicalTime, observerCart, degreesToRadian(localSiderealTime * 15.0), true);

    eclipticLongitude = radianToDegrees(moonPos.lon);
    eclipticLatitude = radianToDegrees(moonPos.lat);
    rightAscension = radianToDegrees(moonPos.ra) / 15.0;
    declination = radianToDegrees(moonPos.dec);
    azimuth = radianToDegrees(moonPos.az);
    altitude = radianToDegrees(moonPos.alt) + refraction(moonPos.alt);
    diameter = radianToDegrees(moonPos.diameter) * 60.0;

    distanceToEarthCenter = moonPos.distance;
    var moonCart = equPolar2Cart(moonPos.raGeocentric, moonPos.decGeocentric, moonPos.distance);
    distanceToObserver = sqrt(pow(moonCart.x - observerCart.x, 2) +
        pow(moonCart.y - observerCart.y, 2) +
        pow(moonCart.z - observerCart.z, 2));

    astrologicalSign = moonPos.sign;
    illumination = moonPos.phase * 100;
    phaseName = moonPos.moonPhase;
    phaseNumber = MoonPhase.values.indexOf(phaseName) + 1;
    age = moonPos.moonAge * LUNATION / (2 * pi);
  }
}
