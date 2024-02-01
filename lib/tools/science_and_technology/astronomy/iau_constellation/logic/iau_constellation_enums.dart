// https://en.wikipedia.org/wiki/IAU_designated_constellations
// https://de.wikipedia.org/wiki/Liste_der_Sternbilder
// https://www.iau.org/public/themes/constellations/

part of 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/logic/iau_constellation.dart';

enum IAU_CONSTELLATION_SORT { CONSTELLATION, NAME, STAR, AREA, VISIBILIY, MAGNITUDO }

Map<IAU_CONSTELLATION_SORT, String> IAU_SORT = {
  IAU_CONSTELLATION_SORT.CONSTELLATION: 'iau_constellation_iauname',
  IAU_CONSTELLATION_SORT.NAME: 'iau_constellation_name',
  IAU_CONSTELLATION_SORT.STAR: 'iau_constellation_star',
  IAU_CONSTELLATION_SORT.AREA: 'iau_constellation_area',
  IAU_CONSTELLATION_SORT.VISIBILIY: 'iau_constellation_visibility',
  IAU_CONSTELLATION_SORT.MAGNITUDO: 'iau_constellation_magnitudo',
};
