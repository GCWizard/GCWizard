import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String decodeZamonian(String input) {
  if (input == null) return null;

  return input
      .split(RegExp(r'[^0-7]+'))
      .map((block) {
        if (block == null || block.isEmpty) return null;

        return convertBase(block, 8, 10);
      })
      .where((element) => element != null)
      .join(' ');
}

String encodeZamonian(String input) {
  if (input == null) return null;

  return input
      .split(RegExp(r'[^0-9]+'))
      .map((block) {
        if (block == null || block.isEmpty) return null;

        return convertBase(block, 10, 8);
      })
      .where((element) => element != null)
      .join(' ');
}
