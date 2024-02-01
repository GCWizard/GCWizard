const _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_EARTH = 'symboltables_alchemy_earth';
const _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_FIRE = 'symboltables_alchemy_fire';
const _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_WATER = 'symboltables_alchemy_water';
const _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_AIR = 'symboltables_alchemy_air';

const _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE = 'zodiac_attribute_polarity_masculine';
const _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE = 'zodiac_attribute_polarity_feminine';

const _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_CARDINAL = 'zodiac_attribute_quality_cardinal';
const _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_FIXED = 'zodiac_attribute_quality_fixed';
const _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_MUTABLE = 'zodiac_attribute_quality_mutable';

const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MARS = 'symboltables_planets_mars';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MERCURY = 'symboltables_planets_mercury';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_VENUS = 'symboltables_planets_venus';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MOON = 'coords_ellipsoid_moon';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_SUN = 'symboltables_planets_sun';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_CHIRON = 'symboltables_planets_chiron';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_JUPITER = 'symboltables_planets_jupiter';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_NEPTUNE = 'symboltables_planets_neptune';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_SATURN = 'symboltables_planets_saturn';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_URANUS = 'symboltables_planets_uranus';
const _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_PLUTO = 'symboltables_planets_pluto';

class ZodiacDate {
  final int start_month;
  final int start_day;
  final int end_month;
  final int end_day;

  const ZodiacDate(
      {required this.start_month, required this.start_day, required this.end_month, required this.end_day});
}

class ZodiacSign {
  final ZodiacDate date;
  final List<String> planet;
  final int house;
  final String element;
  final String polarity;
  final String quality;

  const ZodiacSign(
      {required this.date,
      required this.planet,
      required this.house,
      required this.element,
      required this.polarity,
      required this.quality});
}

const Map<String, ZodiacSign> ZODIACSIGNS = {
  'astronomy_signs_aries': ZodiacSign(
      date: ZodiacDate(
        start_month: 3,
        start_day: 21,
        end_month: 4,
        end_day: 20,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MARS],
      house: 1,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_FIRE,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_CARDINAL),
  'astronomy_signs_taurus': ZodiacSign(
      date: ZodiacDate(
        start_month: 4,
        start_day: 21,
        end_month: 5,
        end_day: 20,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_VENUS],
      house: 2,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_EARTH,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_FIXED),
  'astronomy_signs_gemini': ZodiacSign(
      date: ZodiacDate(
        start_month: 5,
        start_day: 21,
        end_month: 6,
        end_day: 21,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MERCURY],
      house: 3,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_AIR,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_MUTABLE),
  'astronomy_signs_cancer': ZodiacSign(
      date: ZodiacDate(
        start_month: 6,
        start_day: 22,
        end_month: 7,
        end_day: 22,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MOON],
      house: 4,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_WATER,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_CARDINAL),
  'astronomy_signs_leo': ZodiacSign(
      date: ZodiacDate(
        start_month: 7,
        start_day: 23,
        end_month: 8,
        end_day: 23,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_SUN],
      house: 5,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_FIRE,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_FIXED),
  'astronomy_signs_virgo': ZodiacSign(
      date: ZodiacDate(
        start_month: 8,
        start_day: 24,
        end_month: 9,
        end_day: 23,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_MERCURY, _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_CHIRON],
      house: 6,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_EARTH,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_MUTABLE),
  'astronomy_signs_libra': ZodiacSign(
      date: ZodiacDate(
        start_month: 9,
        start_day: 24,
        end_month: 10,
        end_day: 23,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_VENUS],
      house: 7,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_AIR,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_CARDINAL),
  'astronomy_signs_scorpio': ZodiacSign(
      date: ZodiacDate(
        start_month: 10,
        start_day: 24,
        end_month: 11,
        end_day: 22,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_PLUTO, _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_JUPITER],
      house: 8,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_WATER,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_FIXED),
  'astronomy_signs_sagittarius': ZodiacSign(
      date: ZodiacDate(
        start_month: 11,
        start_day: 23,
        end_month: 12,
        end_day: 21,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_JUPITER],
      house: 9,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_FIRE,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_MUTABLE),
  'astronomy_signs_capricorn': ZodiacSign(
      date: ZodiacDate(
        start_month: 12,
        start_day: 22,
        end_month: 1,
        end_day: 20,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_SATURN],
      house: 10,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_EARTH,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_CARDINAL),
  'astronomy_signs_aquarius': ZodiacSign(
      date: ZodiacDate(
        start_month: 1,
        start_day: 21,
        end_month: 2,
        end_day: 19,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_URANUS, _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_SATURN],
      house: 11,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_AIR,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_MASCULINE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_FIXED),
  'astronomy_signs_pisces': ZodiacSign(
      date: ZodiacDate(
        start_month: 2,
        start_day: 20,
        end_month: 3,
        end_day: 20,
      ),
      planet: [_ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_NEPTUNE, _ZODIACSIGNS_ATTRIBUTE_PLANET_VALUE_JUPITER],
      house: 12,
      element: _ZODIACSIGNS_ATTRIBUTE_ELEMENT_VALUE_WATER,
      polarity: _ZODIACSIGNS_ATTRIBUTE_POLARITY_VALUE_FEMININE,
      quality: _ZODIACSIGNS_ATTRIBUTE_QUALITY_VALUE_MUTABLE),
};
