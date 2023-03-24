import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/external_libs/astronomie_info/astronomy.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:latlong2/latlong.dart';

class SunRiseSet {
  late double astronomicalMorning;
  late double nauticalMorning;
  late double civilMorning;
  late double rise;
  late double transit;
  late double set;
  late double civilEvening;
  late double nauticalEvening;
  late double astronomicalEvening;

  SunRiseSet(LatLng coords, JulianDate julianDate, Duration timezone, Ellipsoid ellipsoid) {
    RiseSet riseSet = sunRise(julianDate.julianDateUTCNoon, julianDate.deltaT, coords.longitudeInRad,
        coords.latitudeInRad, timezone.inMinutes / 60.0, false, ellipsoid);

    astronomicalMorning = riseSet.astronomicalTwilightMorning;
    astronomicalEvening = riseSet.astronomicalTwilightEvening;
    civilMorning = riseSet.civilTwilightMorning;
    civilEvening = riseSet.civilTwilightEvening;
    nauticalMorning = riseSet.nauticalTwilightMorning;
    nauticalEvening = riseSet.nauticalTwilightEvening;

    rise = riseSet.rise;
    transit = riseSet.transit;
    set = riseSet.set;
  }
}
