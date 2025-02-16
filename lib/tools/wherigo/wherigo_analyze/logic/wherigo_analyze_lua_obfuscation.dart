part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

void _deObfuscateAllTexts() {
  _LUAFile = _LUAFile.replaceAll('([[', '(').replaceAll(']])', ')');

  for (int i = 0; i < _obfuscatorFunction.length; i++) {
    RegExp(r'' + _obfuscatorFunction[i] + '\\(".*?"\\)').allMatches(_LUAFile).forEach((obfuscatedText) {
      var group = obfuscatedText.group(0);
      if (group == null) return;
      _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction[i], _obfuscatorTable[i]) + '"');
    });
  }
}

void _checkAndGetObfuscatorURWIGO(List<String> lines) {
  String obFunction = '';
  String obTable = '';
  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();

    if (RegExp(r'(local dtable = ")').hasMatch(lines[i])) {
      obFunction = lines[i - 2].replaceAll('function ', '').replaceAll('(str)', '');
      _obfuscatorFunction.add(obFunction);
      _obfuscatorFound = true;

      obTable = lines[i].trim().substring(0, lines[i].length - 1).replaceAll('local dtable = "', '');
      _obfuscatorTable.add(obTable);
    }
  }
}

void _checkAndGetObfuscatorWWBorGSUB() {
  if (RegExp(r'(WWB_deobf)').hasMatch(_LUAFile)) {
    _obfuscatorFunction.add('WWB_deobf');
    _obfuscatorTable.add('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~');
    _obfuscatorFound = true;
    RegExp(r'WWB_deobf\(".*?"\)').allMatches(_LUAFile).forEach((obfuscatedText) {
      var group = obfuscatedText.group(0);
      if (group == null) return;

      _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction[0], _obfuscatorTable[0]) + '"');
    });
  } else if (RegExp(r'(gsub_wig)').hasMatch(_LUAFile)) {
    _obfuscatorFunction.add('gsub_wig');
    _obfuscatorTable.add('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.-~');
    _obfuscatorFound = true;
    RegExp(r'gsub_wig\(".*?"\)').allMatches(_LUAFile).forEach((obfuscatedText) {
      var group = obfuscatedText.group(0);
      if (group == null) return;

      _LUAFile = _LUAFile.replaceAll(group, '"' + deObfuscateText(group, _obfuscatorFunction[0], _obfuscatorTable[0]) + '"');
    });
  }
}
