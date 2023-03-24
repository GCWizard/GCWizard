import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String decodeZamonian(String input) {
  return input
      .split(RegExp(r'[^0-7]+'))
      .map((block) {
        if (block.isEmpty) return null;

        return convertBase(block, 8, 10);
      })
      .whereType<String>()
      .join(' ');
}

String encodeZamonian(String input) {
  return input
      .split(RegExp(r'\D+'))
      .map((block) {
        if (block.isEmpty) return null;

        return convertBase(block, 10, 8);
      })
      .whereType<String>()
      .join(' ');
}
