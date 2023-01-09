/*
 * Port from https://github.com/Krevo/WherigoTools/blob/master/readustring.php
 * Port from Dennis Treysa
 *
 * MIT License
 */

String _udecrypt(String str, String dtable) {
  var res = '';
  for (var i = 0; i < str.length; i++) {
    var b = str.codeUnits[i];
    if (b > 0 && b <= 127) {
      if ((b - 1) >= dtable.length) continue;
      res += dtable[b - 1];
    } else {
      res += str[i];
    }
  }

  return res;
}

String luaStringToString(String pString) {
  String tNewString = "";
  int tOffset = 0;
  int tOrd = 0;
  int tStrLen = pString.length;

  var tEscapeMapping = {"t": 9, "n": 10, "r": 13, "a": 7, "f": 12, "v": 11, "b": 8, "e": 27, "\\": 92, "\"": 34};

  while (tOffset < tStrLen) {
    if (pString[tOffset] == '\\') {
      tOffset += 1;
      if (tOffset < tStrLen) if (int.tryParse(pString[tOffset]) != null) tOffset += 1;

      if (tOffset < tStrLen && (int.tryParse(pString[tOffset]) != null)) tOffset += 1;

      if (tOffset < tStrLen && (int.tryParse(pString[tOffset]) != null)) {
        tOrd =
            int.parse(pString[tOffset - 2]) * 100 + int.parse(pString[tOffset - 1]) * 10 + int.parse(pString[tOffset]);
        tNewString += String.fromCharCode(tOrd);
      } else if (tOffset < tStrLen && tEscapeMapping[pString[tOffset]] != null)
        tNewString += String.fromCharCode(tEscapeMapping[pString[tOffset]]);
    } else
      tNewString += pString[tOffset];

    tOffset += 1;
  }
  return tNewString;
}

String readustring(String input, String dtable) {
  return _udecrypt(luaStringToString(input), luaStringToString(dtable));
}

/*
 Testcases
 ytrohs_und_der Folterknecht aus Bayern
   dtable `:\024G\bj\f\003IOY'dAWfC&VbD X\017eJ\0159]\020E}\nLBil^7TP=\vw2!Q\"~1?rs\025\r{-(zF\027kHv\tR.3)N\022\\a;c\014u\002yt>+\026\004K\0304\018\028q[6</\0198_%o\023*\000#\031\005S$\029\001@m\016|n\021x50UhpZ\a,\006Mg
          obfus ~$4IKM%$t
          plain Miraculix
          obfus ?M\025PP\025\022@cr\022)IyI\022jKx%Moy\016
          plain Huette von Papa Schlumpf
          obfus ~$4IKM%$t\022\0204IMKxP\022rcKx\022\025$r$\127\025\022U4I\025MP\0254\022\016M\0254\022\r\025r\022(4Mr>C\022)\016%M\025K>\025\022\r$\0255\025\022IM\016\022\r\0254\022\1274c55\025r\022\015$\0255\025C
          plain Miraculix braucht noch einige Kraeuter fuer den Trunk. Pfluecke diese auf der grossen Wiese.
 */
