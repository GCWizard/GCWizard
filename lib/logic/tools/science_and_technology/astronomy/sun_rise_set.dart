import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/astronomie_info/astronomy.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/julian_date.dart';
import 'package:latlong/latlong.dart';

class SunRiseSet {
  double astronomicalMorning;
  double nauticalMorning;
  double civilMorning;
  double rise;
  double transit;
  double set;
  double civilEvening;
  double nauticalEvening;
  double astronomicalEvening;

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
