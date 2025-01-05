import 'dart:math';

import 'package:gc_wizard/tools/wherigo/krevo/logic/readestring.dart';
import 'package:gc_wizard/tools/wherigo/krevo/logic/readustring.dart';
import 'package:gc_wizard/tools/wherigo/krevo/logic/ucommons.dart';

enum HASH { ALPHABETICAL, NUMERIC }

String? findHashAlphabetical(int hashToFind, int len) {
  return findHash(hashToFind, len);
}

String? findHashNumeric(int hashToFind, int len) {
  var max = pow(26, len);
  for (var i = 0; i < max; i++) {
    var s = urwigoConvBase(i, '0123456789', '01234567890').padLeft(len, '0');

    if (RSHash(s) == hashToFind) {
      return s;
    }
  }

  return null;
}

String? breakUrwigoHash(int input, HASH type) {
  if (input < 0 || input >= 65535) return null;

  String? out;

  for (int i = 1; i <= 5; i++) {
    type == HASH.ALPHABETICAL ? out = findHashAlphabetical(input, i) : out = findHashNumeric(input, i);
    if (out != null && out.isNotEmpty) return out;
  }

  return null;
}

String deobfuscateUrwigoText(String text, String dtable) {
  if (text.isEmpty) return '';

  if (dtable.isEmpty) return '';

  if (dtable == 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~') {
    return gsub_wig(text);
  } else {
    return readustring(text, dtable);
  }
}

String obfuscateUrwigoText(String text, String dtable) {
  if (text.isEmpty) return '';

  if (dtable.isEmpty) return '';

  const searchReplace = {
    8: "\\b", // x08   backspace
    11: "\\v", // x0B   vertical tab
    7: "\\a", // x07   alarm beep
    9: "\\t", // \t    tab
    13: "\\r", // \r    carriage return
    10: "\\n", // \n    line feed
    12: "\\f", // \f    form feed
    92: "\\\\", // \\    backslash
    34: '\\"', // \"    Guillemets
  };

  String result = '';

  List<int> dtableCodeUnits = luaStringToString(dtable).codeUnits;

  int codeUnit = 0;
  text.split('').forEach((char) {
    if (char.codeUnitAt(0) < dtableCodeUnits.length) {
      codeUnit = 1 + dtableCodeUnits.indexOf(char.codeUnitAt(0));
    } else {
      codeUnit = 1 + char.codeUnitAt(0);
    }
    if (searchReplace[codeUnit] == null) {
      if (32 <= codeUnit && codeUnit < 127) {
        result = result + String.fromCharCode(codeUnit);
      } else {
        result = result + '\\' + codeUnit.toString().padLeft(3, '0');
      }
    } else {
      result = result + searchReplace[codeUnit]!;
    }
  });

  return result;
}
