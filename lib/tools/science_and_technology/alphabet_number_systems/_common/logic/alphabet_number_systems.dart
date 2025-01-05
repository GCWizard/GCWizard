import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/_common/logic/alphabet_number_systems_data.dart';

Map<int, String> _buildCode(ALPHABET_NUMBER_SYSTEMS alphabetNumberSystem) {
  Map<int, String> code = {};
  code.addAll(switchMapKeyValue(ALPHABETNUMBERSYSTEMS[alphabetNumberSystem]![100]!));
  code.addAll(switchMapKeyValue(ALPHABETNUMBERSYSTEMS[alphabetNumberSystem]![10]!));
  code.addAll(switchMapKeyValue(ALPHABETNUMBERSYSTEMS[alphabetNumberSystem]![1]!));

  return code;
}

String encodeNumberToNumeralWord(int number, ALPHABET_NUMBER_SYSTEMS alphabetNumberSystem) {
  Map<int, String> CODE = _buildCode(alphabetNumberSystem);

  return CODE[(number - number % 100)]! + CODE[((number % 100) ~/ 10) * 10]! + CODE[number % 10]!;
}

String decodeNumeralWordToNumber(String numeralWord) {
  return int.parse(numeralWord).toString();
}
