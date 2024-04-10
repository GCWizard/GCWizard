part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

void _deObfuscateAllTexts() {
  _LUAFile = _LUAFile.replaceAll('([[', '(').replaceAll(']])', ')');

  RegExp(r'' + _obfuscatorFunction + '\\(".*?"\\)').allMatches(_LUAFile).forEach((obfuscatedText) {
    var group = obfuscatedText.group(0);
    if (group == null) return;
    _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction, _obfuscatorTable) + '"');
  });
}

void _checkAndGetObfuscatorURWIGO(List<String> lines) {
  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();

    if (RegExp(r'(local dtable = ")').hasMatch(lines[i])) {
      _obfuscatorFunction = lines[i - 2].trim().substring(9);
      for (int j = _obfuscatorFunction.length - 1; j > 0; j--) {
        if (_obfuscatorFunction[j] == '(') {
          _obfuscatorFunction = _obfuscatorFunction.substring(0, j);
          j = 0;
        }
      }
      _obfuscatorFound = true;

      _obfuscatorTable = lines[i].trim().substring(0, lines[i].length - 1);
      _obfuscatorTable = _obfuscatorTable.trimLeft().replaceAll('local dtable = "', '');

      i = lines.length;
    }
  }
}

void _checkAndGetObfuscatorWWBorGSUB() {
  if (RegExp(r'(WWB_deobf)').hasMatch(_LUAFile)) {
    _obfuscatorFunction = 'WWB_deobf';
    _obfuscatorTable = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~';
    _obfuscatorFound = true;
    RegExp(r'WWB_deobf\(".*?"\)').allMatches(_LUAFile).forEach((obfuscatedText) {
      var group = obfuscatedText.group(0);
      if (group == null) return;

      _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction, _obfuscatorTable) + '"');
    });
  } else if (RegExp(r'(gsub_wig)').hasMatch(_LUAFile)) {
    _obfuscatorFunction = 'gsub_wig';
    _obfuscatorTable = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~';
    _obfuscatorFound = true;
    RegExp(r'gsub_wig\(".*?"\)').allMatches(_LUAFile).forEach((obfuscatedText) {
      var group = obfuscatedText.group(0);
      if (group == null) return;

      _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction, _obfuscatorTable) + '"');
    });
  }
}
