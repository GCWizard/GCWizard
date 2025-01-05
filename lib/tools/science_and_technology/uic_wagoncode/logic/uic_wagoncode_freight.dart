part of 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';

// https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2010:280:0029:0058:de:PDF
// https://www.lokifahrer.ch/Lukmanier/Rollmaterial/Bezeichnungen/Bez-Wagen-G.htm
// https://de.wikipedia.org/wiki/UIC-Wagennummer#Beispiel_UIC-Entschl%C3%BCsselung
// https://de.wikipedia.org/wiki/UIC-Bauart-Bezeichnungssystem_für_Güterwagen


enum _UICWagonCodeFreightGaugeType {FIXED, VARIABLE, BOTH_POSSIBLE, INVALID}
enum _UICWagonCodeFreightAxleType {SINGLE, BOGIE, INVALID}
enum _UICWagonCodeFreightWagonTypes {NORMAL_PPW, NORMAL_TEN_RIV, NORMAL_TEN_INTERFRIGO, MAINTENANCE, MISC, NOT_IN_EU_REGISTERED, INVALID, FRIDGE_LEGACY}

class _UICWagenCodeFreightCategory {
  late final String letterCode;
  late final String numberCode;
  late final String name;

  String _getCategoryLetterCode(String number) {
    var letterCodes = <String, String>{};
    switch(number[4]) {
      case '0': letterCodes = const {'0': 'T', '1': 'T','2': 'T','3': 'T','4': 'T','5': 'T','6': 'T','7': 'T','8': 'T','9': 'T'}; break;
      case '1': letterCodes = const {'0': 'G', '1': 'G','2': 'G','3': 'G','4': 'G','5': 'G','6': 'G','7': 'G','8': 'G','9': 'G'}; break;
      case '2': letterCodes = const {'0': 'H', '1': 'H','2': 'H','3': 'H','4': 'H','5': 'H','6': 'H','7': 'H','8': 'H','9': 'H'}; break;
      case '3': letterCodes = const {'0': 'K', '1': 'K','2': 'K','3': 'K','4': 'K','5': 'R','6': 'R','7': 'O','8': 'R','9': 'R'}; break;
      case '4': letterCodes = const {'0': 'L', '1': 'L','2': 'L','3': 'L','4': 'L','5': 'S','6': 'S','7': 'S','8': 'S','9': 'S'}; break;
      case '5': letterCodes = const {'0': 'E', '1': 'E','2': 'E','3': 'E','4': 'E','5': 'E','6': 'E','7': 'E','8': 'E','9': 'E'}; break;
      case '6': letterCodes = const {'0': 'F', '1': 'F','2': 'F','3': 'F','4': 'F','5': 'F','6': 'F','7': 'F','8': 'F','9': 'F'}; break;
      case '7': letterCodes = const {'0': 'Z', '1': 'Z','2': 'Z','3': 'Z','4': 'Z','5': 'Z','6': 'Z','7': 'Z','8': 'Z','9': 'Z'}; break;
      case '8': letterCodes = const {'0': 'I', '1': 'I','2': 'I','3': 'I','4': 'I','5': 'I','6': 'I','7': 'I','8': 'I','9': 'I'}; break;
      case '9': letterCodes = const {'0': 'U', '1': 'U','2': 'U','3': 'U','4': 'U','5': 'U','6': 'U','7': 'U','8': 'U','9': 'U'}; break;
      default: return '';
    }

    return letterCodes[number[5]]!;
  }

  _UICWagenCodeFreightCategory(String number) {
    numberCode = number[4];
    letterCode = _getCategoryLetterCode(number);
    name = 'uic_freight_category_' + letterCode.toLowerCase();
  }
}

class _UICWagenCodeFreightClassification {
  late final String uicNumberCode;
  late final List<String> uicLetterCode;
  late final Map<String, String> descriptions;

  List<String> _getLetterCode(String uicNumberCode) {
    var categoryNumberCode = uicNumberCode[0];
    var classification1 = uicNumberCode.substring(2);
    var classification2 = uicNumberCode.substring(1,2);

    var classificationLetterCode_Lvl1 = UICWagonCodesFreightClassificationCodes[categoryNumberCode]![classification1];
    if (classificationLetterCode_Lvl1 == null) {
      return [];
    }

    var classificationLetterCode = classificationLetterCode_Lvl1[classification2];
    if (classificationLetterCode == null) {
      return [];
    }

    return splitGroupsOfSameCharacters(classificationLetterCode);
  }

  Map<String, Map<String, List<String>>> _joinDescriptionMapsAndFilterRelevantCodes(List<String> classificationLetterCode, String? countryCode) {
    var descriptionMap = <String, Map<String, List<String>>>{};

    for (var descriptions in _UICWagonCodeFreightClassificationDescriptions.entries) {
      if (classificationLetterCode.contains(descriptions.key)) {
        descriptionMap.putIfAbsent(descriptions.key, () => descriptions.value);
      }
    }

    if (countryCode != null && UICWagonCodeFreightClassificationDescriptionsCountry.containsKey(countryCode)) {
      for (var description in UICWagonCodeFreightClassificationDescriptionsCountry[countryCode]!.entries) {
        if (classificationLetterCode.contains(description.key)) {
          descriptionMap.putIfAbsent(description.key, () => description.value);
        }
      }
    }

    return descriptionMap;
  }

  Map<String, String> _setDescriptions(Map<String, Map<String, List<String>>> descriptionMap, List<String> classificationLetterCode) {
    var _descriptionMap = <String, String>{};

    for (var descriptions in descriptionMap.entries) {
      var _descriptions = <String, String>{};

      for (var description in descriptions.value.entries) {
        var categories = description.value;
        for (var category in categories) {
          var letterCodes = splitGroupsOfSameCharacters(category);
          if (isSublist(classificationLetterCode, letterCodes)) {
            _descriptions.putIfAbsent(category, () => description.key);
          }
        }
      }

      if (_descriptions.isNotEmpty) {
        var categories = _descriptions.keys.toList();
        categories.sort((String a, String b) => b.length.compareTo(a.length));
        _descriptionMap.putIfAbsent(descriptions.key, () => _descriptions[categories.first]!);
      }
    }

    return _descriptionMap;
  }

  Map<String, String> _getDescriptions(String categoryLetterCode, List<String> classificationLetterCode, String? countryCode) {
    var descriptionMap = _joinDescriptionMapsAndFilterRelevantCodes(classificationLetterCode, countryCode);

    var allLetters = List<String>.from(classificationLetterCode);
    allLetters.add(categoryLetterCode);

    return _setDescriptions(descriptionMap, allLetters);
  }

  _UICWagenCodeFreightClassification(String number, _UICWagenCodeFreightCategory category, String? countryCode) {
    uicNumberCode = number.substring(4,8);
    uicLetterCode = _getLetterCode(uicNumberCode);
    descriptions = _getDescriptions(category.letterCode, uicLetterCode, countryCode);
  }
}

class UICWagonCodeFreightWagon extends UICWagonCodeWagon {
  late final _UICWagonCodeFreightGaugeType gaugeType;
  late final _UICWagonCodeFreightAxleType axleType;
  late final _UICWagonCodeFreightWagonTypes freightWagonType;
  late final _UICWagenCodeFreightCategory category; //Gattung
  late final _UICWagenCodeFreightClassification classification;

  _UICWagonCodeFreightWagonTypes _getType(int number1, int number2) {
    if ([0, 1, 2, 3].contains(number1)) {
      if (number2 == 0) return _UICWagonCodeFreightWagonTypes.INVALID;
      if ([0, 1].contains(number1) && [3, 4, 5, 6, 7, 8].contains(number2)) return _UICWagonCodeFreightWagonTypes.FRIDGE_LEGACY;
      if (number2 == 9) return _UICWagonCodeFreightWagonTypes.NORMAL_PPW;
      if ([0, 1].contains(number1)) return _UICWagonCodeFreightWagonTypes.NORMAL_TEN_INTERFRIGO;
      if ([2, 3].contains(number1)) return _UICWagonCodeFreightWagonTypes.NORMAL_TEN_RIV;
      return _UICWagonCodeFreightWagonTypes.INVALID;
    } else {
      if (number2 == 0) return _UICWagonCodeFreightWagonTypes.MAINTENANCE;
      if (number2 == 9) return _UICWagonCodeFreightWagonTypes.NOT_IN_EU_REGISTERED;
      return _UICWagonCodeFreightWagonTypes.MISC;
    }
  }

  _UICWagonCodeFreightGaugeType _getGaugeType(int number1, int number2) {
    if ([4, 8].contains(number1) && [0, 9].contains(number2)) return _UICWagonCodeFreightGaugeType.BOTH_POSSIBLE;
    if ([0, 1].contains(number1) && [9].contains(number2))  return _UICWagonCodeFreightGaugeType.VARIABLE;
    if ([2, 3].contains(number1) && [9].contains(number2))  return _UICWagonCodeFreightGaugeType.FIXED;

    if ([2,4,6,8].contains(number2)) return _UICWagonCodeFreightGaugeType.VARIABLE;
    if ([1, 3, 4, 5, 7].contains(number2)) return _UICWagonCodeFreightGaugeType.FIXED;

    return _UICWagonCodeFreightGaugeType.INVALID;
  }

  _UICWagonCodeFreightAxleType _getAxleType(int number1) {
    if ([0,2,4].contains(number1)) return _UICWagonCodeFreightAxleType.SINGLE;
    if ([1, 3, 8].contains(number1)) return _UICWagonCodeFreightAxleType.BOGIE;

    return _UICWagonCodeFreightAxleType.INVALID;
  }

  UICWagonCodeFreightWagon(String number) : super(number) {
    var number1 = int.parse(interoperabilityCode[0]);
    var number2 = int.parse(interoperabilityCode[1]);

    freightWagonType = _getType(number1, number2);
    gaugeType = _getGaugeType(number1, number2);
    axleType = _getAxleType(number1);
    category = _UICWagenCodeFreightCategory(number);
    classification = _UICWagenCodeFreightClassification(number, category, countryCode);
  }
}