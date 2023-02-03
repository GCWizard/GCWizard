import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

final _ALPHABET = '0123456789ABCDEFGHJKMNPQRTVWXYZ';
final _OFFSET = pow(16, 4) - 16 * pow(31, 3);
final _NO_VALID_GC_CODE = 'gccode_novalidgcode';

int gcCodeToID(String gcCode) {
  if (gcCode == null) return null;
  gcCode = gcCode.trim();
  if (gcCode.length == 0) return null;

  gcCode = gcCode.toUpperCase();

  if (gcCode.startsWith('GC')) gcCode = gcCode.substring(2);

  if (gcCode.length == 0) return null;

  if (gcCode.length <= 3 || (gcCode.length == 4 && gcCode.startsWith(RegExp('[0-9A-F]')))) {
    //hex
    if (gcCode.contains(RegExp('[G-Z]'))) throw FormatException(_NO_VALID_GC_CODE);

    return int.tryParse(convertBase(gcCode, 16, 10));
  } else {
    if (gcCode.contains(RegExp('[ILOSU]'))) throw FormatException(_NO_VALID_GC_CODE);

    var value = int.tryParse(convertBase(gcCode, 31, 10, alphabet: _ALPHABET));
    if (value == null) throw FormatException(_NO_VALID_GC_CODE);

    return value + _OFFSET; //Base31 with negative offset
  }
}

String idToGCCode(int id) {
  if (id == null || id < 0) return '';

  if (id < 65536) return 'GC' + convertBase('$id', 10, 16);

  id -= _OFFSET;
  return 'GC' + convertBase('$id', 10, 31, alphabet: _ALPHABET);
}
