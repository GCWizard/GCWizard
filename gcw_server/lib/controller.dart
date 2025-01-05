import 'dart:convert';

import 'package:gc_wizard/application/webapi/api_mapper.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/api_mapper/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/api_mapper/morse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/api_mapper/reverse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/api_mapper/roman_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/api_mapper/rotation.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gcw_server/web_parameter.dart';

final Set<APIMapper> _apiList = {
  AlphabetValuesAPIMapper(),
  //CoordsFormatconverterAPIMapper(), //problem: dart.ui used
  MorseAPIMapper(),
  ReverseAPIMapper(),
  RomanNumbersAPIMapper(),
  RotatorAPIMapper(),
};

String? request(WebParameter parameter) {
  APIMapper? apiMapper;

  try {
    var title = parameter.title.toLowerCase();
    if (title != '?') {
      apiMapper = _apiList.firstWhere((entry) => title == entry.Key);
    } else {
      apiMapper = APIInfo();
    }
  } catch (e) {}

  if (apiMapper == null) return null;
  apiMapper.setParams(parameter.arguments);

  return jsonEncode(apiMapper.calculate());
}

class APIInfo extends APIMapper {
  @override
  String doLogic() {
    return _apiList.map((entry) => entry.apiSpecification()).join('\n\n');
  }

  /// convert doLogic output to map
  @override
  Map<String, String> toMap(Object result) {
    return <String, String>{enumName(WEBPARAMETER.result.toString()) : result.toString()};
  }
}

