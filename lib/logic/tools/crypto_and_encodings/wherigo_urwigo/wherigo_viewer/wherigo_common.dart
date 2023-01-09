import 'package:gc_wizard/logic/tools/crypto_and_encodings/wherigo_urwigo/earwigo_tools.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/wherigo_urwigo/urwigo_tools.dart';

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

String getLineData(String analyseLine, String LUAname, String type, String obfuscator, String dtable) {
  String result = analyseLine.replaceAll(LUAname + '.' + type + ' = ', '');
  if (result.startsWith(obfuscator)) {
    result = result.replaceAll(obfuscator + '("', '').replaceAll('")', '');
    result = deobfuscateUrwigoText(result, dtable);
  } else if (result.startsWith('WWB_multi'))
    result = result.replaceAll('WWB_multiplatform_string("', '').replaceAll('")', '');
  else {
    result = result.replaceAll('"', '');
  }

  return normalizeWIGText(result).trim();
}

String getStructData(String analyseLine, String type) {
  return analyseLine.trimLeft().replaceAll(type + ' = ', '').replaceAll('"', '').replaceAll(',', '');
}

String getTextData(String analyseLine, String obfuscator, String dtable) {
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
    // deobfuscate/replace all Matches gsub_wig\("[\w\s@]+"\)
    RegExp(r'gsub_wig\("[\w\s@\-.~]+"\)').allMatches(result).forEach((element) {
      result = result.replaceAll(element.group(0),
          deobfuscateUrwigoText(element.group(0).replaceAll('gsub_wig("', '').replaceAll('")', ''), dtable));
    });
    result = result.replaceAll('..', '').replaceAll('<BR>\\n', '').replaceAll('"', '');
    RegExp(r'ucode_wig\([\d]+\)').allMatches(result).forEach((element) {
      result = result.replaceAll(element.group(0),
          String.fromCharCode(int.parse(element.group(0).replaceAll('ucode_wig(', '').replaceAll(')', ''))));
    });
    result = result.replaceAll('gsub_wig()', '');
  } else if (result.startsWith(RegExp(r'(\()+' + obfuscator))) {
    while (result.startsWith(RegExp(r'(\()+' + obfuscator))) result = result.substring(1);
    result = result.replaceAll('(' + obfuscator, obfuscator).replaceAll('),', ')').replaceAll('))', ')');
    result = _getDetails(result, obfuscator, dtable);
  } else if (result.startsWith(obfuscator)) {
    if (_compositeObfuscatedText(result, obfuscator))
      result = _getDetails(result, obfuscator, dtable);
    else if (_compositeText(result)) {
      result = _getCompositeText(result, obfuscator, dtable);
    } else {
      result = result.replaceAll(obfuscator + '("', '').replaceAll('"),', '').replaceAll('")', '');
      result = deobfuscateUrwigoText(result, dtable);
    }
  } else if (result.replaceAll('Player.Name .. ', '').startsWith(obfuscator)) {
    result = result.replaceAll('Player.Name .. ', '');
    if (_compositeObfuscatedText(result, obfuscator))
      result = _getDetails(result, obfuscator, dtable);
    else if (_compositeText(result)) {
      result = _getCompositeText(result, obfuscator, dtable);
    } else {
      result = result.replaceAll(obfuscator + '("', '').replaceAll('"),', '').replaceAll('")', '');
      result = deobfuscateUrwigoText(result, dtable);
    }
    result = 'Player.Name .. ' + result;
  }

  return normalizeWIGText(result);
}

String _getDetails(String line, String obfuscator, String dtable) {
  // line is a concatination of several obfuscated strings
  String element = '';
  String result = '';
  int i = 0;
  bool section = true;
  do {
    i = obfuscator.length + 2;
    element = '';

    do {
      //get obfuscated string
      element = element + line[i];
      i = i + 1;
    } while ((line[i] + line[i + 1] != '")') && (i + 2 < line[i].length));
    result = result + deobfuscateUrwigoText(element, dtable);
    line = line.substring(i + 2);

    i = 0;
    section = true;
    if (line.length != 0) {
      do {
        // get something else in between
        if (line.substring(i).startsWith(obfuscator))
          section = false;
        else
          i = i + 1;
      } while (section && i < line.length);
      //i--;
      result = result + line.substring(0, i).replaceAll(')', '');
      line = line.substring(i);
    }
  } while (line.length != 0);

  return normalizeWIGText(result);
}

List<String> getChoicesSingleLine(String choicesLine, String LUAname, String obfuscator, String dtable) {
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

bool _compositeText(String text) {
  RegExp expr = RegExp(r'"\) .. ');
  return (expr.hasMatch(text));
}

bool _compositeObfuscatedText(String text, String obfuscator) {
  return (RegExp(r'' + obfuscator).allMatches(text).length > 1);
}

String _getCompositeText(String text, String obfuscator, String dtable) {
  String hashText = '';
  String result = '';

  int i = obfuscator.length + 2;
  do {
    hashText = hashText + text[i];
    i++;
  } while ((text[i] + text[i + 1] != '")'));
  text = text.substring(i + 2);
  result = result + deobfuscateUrwigoText(hashText, dtable) + text;
  return normalizeWIGText(result);
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

List<String> addExceptionErrorMessage(int lineNumber, String section, var exception) {
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
