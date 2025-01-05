part of 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';

// https://www.0-gleich-dampflok.de/fotogalerie-db/die-umzeichnung-der-db-dampflokomotiven-1968-1969/

const List<String> _UICWagonCodesTractiveUnitCountrySpecificTypeCodes = ['80', '85'];

class UICWagonCodeTractiveUnit extends UICWagonCode {
  late final String typeCode;
  late final String type;
  late final String clazzCode;
  String? clazz;
  bool? oilBurner;

  UICWagonCodeTractiveUnit(String number) : super(number) {
    typeCode = _getTypeCode(number);
    type = _getType(number);
    clazzCode = _getClassCode(number);
    clazz = _getClass();
    oilBurner = _getOilBurner();
  }

  bool? _getOilBurner() {
    if (countryCode == '80' && typeCode == '90') {
      return [12, 42, 43, 59].contains(int.parse(clazzCode.substring(1)));
    }

    return null;
  }

  String? _getClass() {
    switch (countryCode) {
      case '80':
        switch (typeCode) {
          case '90':
             var steamClass = int.parse(clazzCode.substring(1));

             if (steamClass >= 1 && steamClass <= 19) {
               return 'uic_tractiveunit_class_80_steam_001_019';
             }
             if (steamClass >= 20 && steamClass <= 39) {
               return 'uic_tractiveunit_class_80_steam_020_039';
             }
             if (steamClass >= 40 && steamClass <= 59) {
               return 'uic_tractiveunit_class_80_steam_040_059';
             }
             if (steamClass >= 60 && steamClass <= 79) {
               return 'uic_tractiveunit_class_80_steam_060_079';
             }
             if (steamClass >= 80 && steamClass <= 96) {
               return 'uic_tractiveunit_class_80_steam_080_096';
             }
             if (steamClass >= 97 && steamClass <= 98) {
               return 'uic_tractiveunit_class_80_steam_097_098';
             }
             if (steamClass == 99) {
               return 'uic_tractiveunit_class_80_steam_099';
             }
             return null;
          default: return null;
        }
      default: return null;
    }
  }

  String _getClassCode(String number) {
    return number.substring(4, 8);
  }

  String _getTypeCode(String number) {
    return number.substring(0, 2);
  }

  String _getType(String number) {
    if (_UICWagonCodesTractiveUnitCountrySpecificTypeCodes.contains(countryCode)) {
      return 'uic_tractiveunit_typecode_' + countryCode + '_' + typeCode;
    } else {
      return 'uic_tractiveunit_typecode_' + typeCode;
    }
  }
}