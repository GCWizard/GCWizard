part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

String _normalizeLUAmultiLineText(String LUA) {
  return LUA
      .replaceAll('[[\n', '[[')
      .replaceAll('<BR>\n', '<BR>')
      .replaceAll('<BR>', ' ')
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
  return WherigoZonePoint(
      Latitude: double.parse(data[0]), Longitude: double.parse(data[1]), Altitude: double.parse(data[2]));
}

bool _isMessageActionElement(String line) {
  if (line.startsWith('Wherigo.PlayAudio') ||
      line.startsWith('Wherigo.ShowScreen') ||
      line.startsWith('Wherigo.GetInput') ||
      line.startsWith('Text = ') ||
      line.startsWith('Media = ') ||
      line.startsWith('Buttons = ') ||
      line.contains(':MoveTo') ||
      line.endsWith('= true') ||
      line.endsWith('= false')) {
    return true;
  } else {
    return false;
  }
}

WherigoActionMessageElementData _handleAnswerLine(String line) {
  line = line.trim();
  if (line.startsWith('Wherigo.PlayAudio')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: line.trim());
  } else if (line.startsWith('Wherigo.ShowScreen')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND,
        ActionMessageContent: line.trim().replaceAll('Wherigo.', '').replaceAll('(', ' ').replaceAll(')', ''));
  } else if (line.startsWith('Wherigo.GetInput')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: line.trim());
  } else if (line.startsWith('Text = ')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: getTextData(line));
  } else if (line.startsWith('Media = ')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE,
        ActionMessageContent: line.trim().replaceAll('Media = ', '').replaceAll(',', ''));
  } else if (line.startsWith('Buttons = ')) {
    if (line.endsWith('}') || line.endsWith('},')) {
      // single line
      return WherigoActionMessageElementData(
          ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON,
          ActionMessageContent:
              getTextData(line.trim().replaceAll('Buttons = {', '').replaceAll('},', '').replaceAll('}', '')));
    }
  } else if (line.startsWith('if ') || line.startsWith('elseif ') || line.startsWith('else')) {
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.CASE, ActionMessageContent: line.trim());
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
    return WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: actionLine);
  }
  return WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.NONE, ActionMessageContent: '');
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
      CartridgeLUAName: '',
      CartridgeGUID: '',
      ObfuscatorTable: '',
      ObfuscatorFunction: '',
      Builder: WHERIGO_BUILDER.NONE,
      BuilderVersion: '',
      TargetDevice: '',
      TargetDeviceVersion: '',
      StartLocation: const WherigoZonePoint(),
      StateID: '',
      UseLogging: '',
      CountryID: '',
      CreateDate: '',
      PublishDate: '',
      UpdateDate: '',
      LastPlayedDate: '',
      LUAFile: _LUAFile,
      Characters: [],
      Items: [],
      Tasks: [],
      Inputs: [],
      Zones: [],
      Timers: [],
      Media: [],
      Messages: [],
      Variables: [],
      BuilderVariables: [],
      NameToObject: {},
      ResultStatus: resultStatus,
      ResultsLUA: _http_code_http,
      httpCode: _httpCode,
      httpMessage: _httpMessage);
}
