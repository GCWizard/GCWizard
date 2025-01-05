import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/list_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_countrycodes.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_freight.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_freight_classification_codes.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_freight_classification_descriptions.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_passenger.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_passenger_heatingsystem_values.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_specialvehicles.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_tractiveunit.dart';
part 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_wagon.dart';

enum UICWagonTypes {INVALID, OUT_OF_ORDER, TRACTIVE, FREIGHT_WAGON, PASSENGER_WAGON, SPECIAL}

class UICWagonType {
  late final String code;
  late final UICWagonTypes name;

  UICWagonType(this.code, this.name);
}

class UICWagonCode {

  late final UICWagonType wagonType;

  late final String countryCode;
  late final String country;
  late final String runningNumber;
  late final String checkDigit;
  late final bool hasValidCheckDigit;

  UICWagonCode(String number) {
    var _number = sanitizeNumber(number);

    if (_number.length != 12) {
      throw const FormatException('uic_wagoncode_invalid_number');
    }

    wagonType = _getWagonType(_number);

    countryCode = _getCountryCode(_number);
    country = _getCountry(countryCode);
    runningNumber = _getRunningNumber(_number);
    checkDigit = _getCheckDigit(number);
    hasValidCheckDigit = _hasValidUICWagonCodeCheckDigit(_number);
  }

  static String sanitizeNumber(String number) {
    return number.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static UICWagonCode fromNumber(String number) {
    var _number = sanitizeNumber(number);

    if (_number.length != 12) {
      throw const FormatException('uic_wagoncode_invalid_number');
    }

    var mainType = _getWagonType(_number);
    switch(mainType.name) {
      case UICWagonTypes.OUT_OF_ORDER: return UICWagonCode(_number);
      case UICWagonTypes.TRACTIVE:  return UICWagonCodeTractiveUnit(_number);
      case UICWagonTypes.PASSENGER_WAGON: return UICWagonCodePassengerWagon(_number);
      case UICWagonTypes.FREIGHT_WAGON: return UICWagonCodeFreightWagon(_number);
      case UICWagonTypes.SPECIAL: return UICWagonCodeSpecialVehicle(_number);
      default: return UICWagonCode(_number);
    }
  }

  static UICWagonType _getWagonType(String number) {
    if (number.startsWith('00')) {
      return UICWagonType('00', UICWagonTypes.OUT_OF_ORDER);
    }

    if (number.startsWith('99') && number[4] == '9') {
      return UICWagonType('99', UICWagonTypes.SPECIAL);
    }

    var code = number[0];
    late UICWagonTypes type;

    switch (code) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4': type = UICWagonTypes.FREIGHT_WAGON; break;
      case '5':
      case '6':
      case '7': type = UICWagonTypes.PASSENGER_WAGON; break;
      case '8': type = UICWagonTypes.FREIGHT_WAGON; break;
      case '9': type = UICWagonTypes.TRACTIVE; break;
      default: type = UICWagonTypes.INVALID; break;
    }

    return UICWagonType(code, type);
  }

  String _getCountryCode(String number) {
    return number.substring(2, 4);
  }

  String _getCountry(String? code) {
    UICCountryCode? country = UICCountryCodes.firstWhereOrNull((element) => element.numberCode == code);
    return country == null ?  'uic_countrycode_invalid' : country.name;
  }

  String _getRunningNumber(String number) {
    return number.substring(8, 11);
  }

  String _getCheckDigit(String number) {
    return number[11];
  }

  bool _hasValidUICWagonCodeCheckDigit(String number) {
    return (checkDigit == calculateUICWagonCodeCheckDigit(number));
  }

  static String calculateUICWagonCodeCheckDigit(String number) {
    var _number = sanitizeNumber(number);
    if (_number.length < 11) {
      throw const FormatException('uic_wagoncode_invalid_number');
    }
    _number = _number.substring(0, 11);

    int sum = 0;
    int product = 0;
    String digits = '';
    for (int i = 0; i < _number.length; i++) {
      if (i % 2 == 0) {
        product = 2 * int.parse(_number[i]);
      } else {
        product = 1 * int.parse(_number[i]);
      }
      digits = digits + product.toString();
    }
    for (int i = 0; i < digits.length; i++) {
      sum = sum + int.parse(digits[i]);
    }
    if (sum % 10 == 0) {
      return '0';
    } else {
      return (10 * (sum ~/ 10 + 1) - sum).toString();
    }
  }
}


