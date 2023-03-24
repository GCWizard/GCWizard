part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

String _normalizeLUAmultiLineText(String LUA) {
  return LUA
      .replaceAll('[[\n', '[[')
      .replaceAll('<BR>\n', '<BR>')
      .replaceAll('&gt;', '>')
      .replaceAll('&lt;', '<')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('\\195\\164', 'ä')
      .replaceAll('\\195\\182', 'ö')
      .replaceAll('\\195\\188', 'ü')
      .replaceAll('\\195\\132', 'Ä')
      .replaceAll('\\195\\156', 'Ü')
      .replaceAll('\\195\\159', 'ß')
      .replaceAll('\\194\\176', '°')
      .replaceAll('\\194\\160', '')
      .replaceAll('\n\n', '\n');
}

WherigoZonePoint _getPoint(String line) {
  List<String> data = line
      .trimLeft()
      .replaceAll('ZonePoint(', '')
      .replaceAll('),', '')
      .replaceAll(')', '')
      .replaceAll(' ', '')
      .split(',');
  return WherigoZonePoint(double.parse(data[0]), double.parse(data[1]), double.parse(data[2]));
}

List<String> _getAnswers(int i, String line, String lineBefore, List<WherigoVariableData> variables) {
  if (line.trim().startsWith('if input == ') ||
      line.trim().startsWith('if input >= ') ||
      line.trim().startsWith('if input <= ') ||
      line.trim().startsWith('elseif input == ') ||
      line.trim().startsWith('elseif input >= ') ||
      line.trim().startsWith('elseif input <= ') ||
      line.trim().startsWith('if ' + _answerVariable + ' == ') ||
      line.trim().startsWith('elseif ' + _answerVariable + ' == ')) {
    if (line.contains('<=') && line.contains('>=')) {
      return [
        line
            .trimLeft()
            .replaceAll('if', '')
            .replaceAll('else', '')
            .replaceAll('==', '')
            .replaceAll('then', '')
            .replaceAll(' ', '')
            .replaceAll('and', ' and ')
            .replaceAll('or', ' or ')
      ];
    }
    return line
        .trimLeft()
        .replaceAll('if', '')
        .replaceAll('else', '')
        .replaceAll('input', '')
        .replaceAll('==', '')
        .replaceAll('then', '')
        .replaceAll(_answerVariable, '')
        .replaceAll(' ', '')
        .replaceAll('and', ' and ')
        .split(RegExp(r'(or)'));
  } else if (RegExp(r'(_Urwigo.Hash)').hasMatch(line)) {
    List<String> results = [];
    int hashvalue = 0;
    line = line.split('and')[0];
    line = line
        .trim()
        .replaceAll('if ', '')
        .replaceAll('elseif ', '')
        .replaceAll('_Urwigo.Hash', '')
        .replaceAll('input', '')
        .replaceAll('=', '')
        .replaceAll('string.lower', '')
        .replaceAll('string.upper', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('then', '')
        .replaceAll('else', '')
        .replaceAll('true', '')
        .replaceAll('and', '')
        .replaceAll('Contains', '')
        .replaceAll('Player', '')
        .replaceAll(':', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^or0-9]'), '+')
        .replaceAll('o+', '+')
        .replaceAll('+r', '+')
        .replaceAll('+', '');
    line.split('or').forEach((element) {
      hashvalue = int.parse(element.replaceAll('D+', ''));
      results.add(hashvalue.toString() +
          '\x01' +
          breakUrwigoHash(hashvalue, HASH.ALPHABETICAL).toString() +
          '\x01' +
          breakUrwigoHash(hashvalue, HASH.NUMERIC).toString());
    });
    return results;
  } else if (line.trim().startsWith('if Wherigo.NoCaseEquals(') ||
      line.trim().startsWith('elseif Wherigo.NoCaseEquals(')) {
    if (_answerVariable.isEmpty) _answerVariable = _getVariable(lineBefore);
    line = line
        .trim()
        .replaceAll('if ', '')
        .replaceAll('elseif ', '')
        .replaceAll('Wherigo.NoCaseEquals', '')
        .replaceAll(_answerVariable, '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('"', '')
        .replaceAll(',', '')
        .replaceAll('then', '')
        .replaceAll('tostring', '')
        .replaceAll('else', '')
        .replaceAll('input', '')
        .replaceAll('Answer,', '')
        .trim();
    //if (RegExp(r'(' + obfuscator + ')').hasMatch(line)) {
    //  line = deobfuscateUrwigoText(line.replaceAll(obfuscator, '').replaceAll('("', '').replaceAll('")', ''), dtable);
    //}
    line = line.split(' or ').map((element) {
      return element.trim();
    }).join('\n');
    line = removeWWB(line);
    // check if variable then provide information
    for (int i = 0; i < variables.length; i++) {
      if (line == variables[i].VariableLUAName) {
        line = variables[i].VariableName + '\x01' + line;
        i = variables.length;
      }
    }
    if (line.isEmpty) {
      return ['NIL'];
    }
    return [line];
  }

  throw Exception(
      'No Answers found'); // TODO Thomas: Please check if empty list instead is logically meaningful; I chose Exception because I believe this line should never be reached.
}

bool _isMessageActionElement(String line) {
  if (line.startsWith('Wherigo.PlayAudio') ||
      line.startsWith('Wherigo.GetInput') ||
      line.startsWith('Text = ') ||
      line.startsWith('Media = ') ||
      line.startsWith('Buttons = ')) {
    return true;
  } else {
    return false;
  }
}

WherigoActionMessageElementData _handleAnswerLine(String line) {
  line = line.trim();
  if (line.startsWith('Wherigo.PlayAudio')) {
    return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.COMMAND, line.trim());
  } else if (line.startsWith('Wherigo.GetInput')) {
    return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.COMMAND, line.trim());
  } else if (line.startsWith('Text = ')) {
    return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.TEXT, getTextData(line));
  } else if (line.startsWith('Media = ')) {
    return WherigoActionMessageElementData(
        WHERIGO_ACTIONMESSAGETYPE.IMAGE, line.trim().replaceAll('Media = ', '').replaceAll(',', ''));
  } else if (line.startsWith('Buttons = ')) {
    if (line.endsWith('}') || line.endsWith('},')) {
      // single line
      return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.BUTTON,
          getTextData(line.trim().replaceAll('Buttons = {', '').replaceAll('},', '').replaceAll('}', '')));
    }
  } else if (line.startsWith('if ') || line.startsWith('elseif ') || line.startsWith('else')) {
    return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.CASE, line.trim());
  } else {
    String actionLine = '';
    // if (RegExp(r'(' + obfuscator + ')').hasMatch(line)) {
    //   List<String> actions = line.trim().split('=');
    //   if (actions.length == 2) {
    //     actionLine = actions[0].trim() +
    //         ' = ' +
    //         deobfuscateUrwigoText(
    //             (actions[1].indexOf('")') > 0)
    //                 ? actions[1]
    //                 .substring(0, actions[1].indexOf('")'))
    //                 .replaceAll(obfuscator, '')
    //                 .replaceAll('("', '')
    //                 .replaceAll('")', '')
    //                 .trim()
    //                 : actions[1].replaceAll(obfuscator, '').replaceAll('("', '').replaceAll('")', '').trim(),
    //             dtable);
    //   } else {
    //     actionLine = deobfuscateUrwigoText(
    //         actions[0].replaceAll(obfuscator, '').replaceAll('("', '').replaceAll('")', '').trim(), dtable);
    //   }
    // } else
    actionLine = line.trimLeft();
    actionLine = actionLine.replaceAll('<BR>', '\n').replaceAll(']],', '');
    return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.COMMAND, actionLine);
  }
  return WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.NONE, '');
}

String _getVariable(String line) {
  if (line.trim().endsWith('= input')) line = line.trim().replaceAll(' = input', '').replaceAll(' ', '');
  if (line.trim().endsWith('~= nil then')) {
    line = line.trim().replaceAll('if', '').replaceAll(' ~= nil then', '').replaceAll(' ', '');
  }
  return line;
}

String _normalizeDate(String dateString) {

  if (dateString.isEmpty || dateString == '1/1/0001 12:00:00 AM') return WHERIGO_NULLDATE;

  List<String> dateTime = dateString.split(' ');
  List<String> date = dateTime[0].split('/');
  List<String> time = dateTime[1].split(':');

  return DateTime(
          int.parse(date[2]),
          int.parse(date[0]),
          int.parse(date[1]),
          (dateTime.length == 3 && dateTime[2] == 'PM') ? int.parse(time[0]) + 12 : int.parse(time[0]),
          int.parse(time[1]),
          int.parse(time[2]))
      .toString();
}

bool isInvalidLUASourcecode(String header) {
  return (!header.replaceAll('(', ' ').replaceAll(')', '').startsWith('require "Wherigo"'));
}

WherigoCartridgeLUA _faultyWherigoCartridgeLUA(String _LUAFile, WHERIGO_ANALYSE_RESULT_STATUS resultStatus,
    List<String> _http_code_http, int _httpCode, String _httpMessage) {
  return WherigoCartridgeLUA(
      LUAFile: _LUAFile,
      Characters: [],
      Items: [],
      Tasks: [],
      Inputs: [],
      Zones: [],
      Timers: [],
      Media: [],
      Messages: [],
      Answers: [],
      Variables: [],
      NameToObject: {},
      ResultStatus: resultStatus,
      ResultsLUA: _http_code_http,
      httpCode: _httpCode,
      httpMessage: _httpMessage);
}
