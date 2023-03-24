import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/astronomy_constants.dart';

String? getAstrologicalSign(AstrologicalSign sign) {
  switch (sign) {
    case AstrologicalSign.ARIES:
      return 'astronomy_signs_aries';
    case AstrologicalSign.TAURUS:
      return 'astronomy_signs_taurus';
    case AstrologicalSign.GEMINI:
      return 'astronomy_signs_gemini';
    case AstrologicalSign.CANCER:
      return 'astronomy_signs_cancer';
    case AstrologicalSign.LEO:
      return 'astronomy_signs_leo';
    case AstrologicalSign.VIRGO:
      return 'astronomy_signs_virgo';
    case AstrologicalSign.LIBRA:
      return 'astronomy_signs_libra';
    case AstrologicalSign.SCORPIO:
      return 'astronomy_signs_scorpio';
    case AstrologicalSign.SAGITTARIUS:
      return 'astronomy_signs_sagittarius';
    case AstrologicalSign.CAPRICORN:
      return 'astronomy_signs_capricorn';
    case AstrologicalSign.AQUARIUS:
      return 'astronomy_signs_aquarius';
    case AstrologicalSign.PISCES:
      return 'astronomy_signs_pisces';
    default:
      return null;
  }
}

String? getMoonPhase(MoonPhase phase) {
  switch (phase) {
    case MoonPhase.NEW_MOON:
      return 'astronomy_moonphase_newmoon';
    case MoonPhase.INCREASING_CRESCENT:
      return 'astronomy_moonphase_increasingcrescent';
    case MoonPhase.FIRST_QUARTER:
      return 'astronomy_moonphase_firstquarter';
    case MoonPhase.INCREASING_MOON:
      return 'astronomy_moonphase_increasingmoon';
    case MoonPhase.FULL_MOON:
      return 'astronomy_moonphase_fullmoon';
    case MoonPhase.DECREASING_MOON:
      return 'astronomy_moonphase_decreasingmoon';
    case MoonPhase.LAST_QUARTER:
      return 'astronomy_moonphase_lastquarter';
    case MoonPhase.DECREASING_CRESCENT:
      return 'astronomy_moonphase_decreasingcrescent';
    default:
      return null;
  }
}
