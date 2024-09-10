part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

String getLUAName(String line) {
  String result = '';
  int i = 0;
  line = line.trim();
  while (line[i] != ' ') {
    result = result + line[i];
    i++;
  }
  return result;
}

String getLineData(String analyseLine, String LUAname, String type, List<String> obfuscator, List<String> dtable) {
  String result = analyseLine.replaceAll(LUAname + '.' + type + ' = ', '');
  for (int i = 0; i < obfuscator.length; i++) {
    if (result.startsWith(obfuscator[i])) {
      result = result.replaceAll(obfuscator[i] + '("', '').replaceAll('")', '');
      result = deobfuscateUrwigoText(result, dtable[i]);
    } else if (result.startsWith('WWB_multi')) {
      result = result.replaceAll('WWB_multiplatform_string("', '').replaceAll('")', '');
    } else {
      result = result.replaceAll('"', '');
    }
  }

  return normalizeWIGText(result).trim();
}

String getStructData(String analyseLine, String type) {
  return analyseLine.trimLeft().replaceAll(type + ' = ', '').replaceAll('"', '').replaceAll(',', '');
}

String getTextData(
  String analyseLine,
) {
  String result = analyseLine
      .trimLeft()
      .replaceAll('Text = ', '')
      .replaceAll('tostring(', '')
      .replaceAll('[[', '')
      .replaceAll(']]', '')
      .replaceAll('input)', 'input')
      .replaceAll('string.sub(Player.CompletionCode, 1, 15)', 'Player.CompletionCode');

  if (result.endsWith(',')) result = result.substring(0, result.length - 1);

  if (RegExp(r'(gsub_wig)').hasMatch(result)) {
    RegExp(r'gsub_wig\("[\w\s@\-.~]+"\)').allMatches(result).forEach((element) {
      var group = element.group(0);
      if (group == null) return;

      result =
          result.replaceAll(group, deobfuscateUrwigoText(group.replaceAll('gsub_wig("', '').replaceAll('")', ''), ''));
    });
    result = result.replaceAll('..', '').replaceAll('<BR>\\n', '').replaceAll('"', '');
    RegExp(r'ucode_wig\([\d]+\)').allMatches(result).forEach((element) {
      var group = element.group(0);
      if (group == null) return;

      result = result.replaceAll(
          group, String.fromCharCode(int.parse(group.replaceAll('ucode_wig(', '').replaceAll(')', ''))));
    });
    result = result.replaceAll('gsub_wig()', '');
  }

  return normalizeWIGText(result);
}

List<String> getChoicesSingleLine(String choicesLine, String LUAname, List<String> obfuscator, List<String> dtable) {
  List<String> result = [];
  choicesLine
      .replaceAll(LUAname + '.Choices = {', '')
      .replaceAll('"', '')
      .replaceAll('}', '')
      .split(',')
      .forEach((element) {
    result.add(element.trim());
  });
  return result;
}

String normalizeWIGText(String text) {
  if (RegExp(r'(WWB_multiplatform_string)').hasMatch(text)) text = removeWWB(text);
  return text
      .replaceAll(String.fromCharCode(92) + '"', "'")
      .replaceAll('"', '')
      .replaceAll('),', '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&gt;', '>')
      .replaceAll('&lt;', '<')
      .replaceAll('<BR>', '\n')
      .replaceAll(String.fromCharCode(92) + 'n', '\n')
      .replaceAll('{PocketPC = 1}', '')
      .replaceAll('{PocketPC = 1', '');
}

String getContainer(String line) {
  RegExp re = RegExp(r'(Container = )');
  String result = '';
  if (re.hasMatch(line)) {
    result = line;
    while (!result.startsWith('Container =')) {
      result = result.substring(1);
    }
    result = result.replaceAll('Container = ', '').replaceAll('}', '').replaceAll(')', '');
  }
  return result;
}

String removeWWB(String wwb) {
  if (wwb.endsWith(')')) wwb = wwb.substring(0, wwb.length - 2);
  if (wwb.endsWith('),')) wwb = wwb.substring(0, wwb.length - 3);
  return wwb.replaceAll('WWB_multiplatform_string(', '').replaceAll('WWB_multiplatform_string', '');
}

String deObfuscateText(String text, String obfuscatorFunction, String obfuscatorTable) {
  text = text.replaceAll(obfuscatorFunction + '("', '').replaceAll('")', '');

  if (obfuscatorFunction == 'WWB_deobf') {
    return deobfuscateEarwigoText(text, EARWIGO_DEOBFUSCATION.WWB_DEOBF);
  } else if (obfuscatorFunction == 'gsub_wig') {
    return deobfuscateEarwigoText(text, EARWIGO_DEOBFUSCATION.GSUB_WIG);
  } else {
    return deobfuscateUrwigoText(text, obfuscatorTable);
  }
}

List<String> addExceptionErrorMessage(int lineNumber, String section, Object exception) {
  return [
    'wherigo_error_runtime',
    'wherigo_error_runtime_exception',
    section,
    'wherigo_error_lua_line',
    '> ' + lineNumber.toString() + ' <',
    exception.toString(),
    '',
  ];
}
