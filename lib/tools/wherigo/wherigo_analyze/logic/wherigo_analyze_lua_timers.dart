part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionTimer(String currentLine) {
  if (RegExp(r'( Wherigo.ZTimer\()').hasMatch(currentLine)) {
    return false;
  }
  return _notDoneWithTimers(currentLine);
}

bool _notDoneWithTimers(String currentLine) {
  if (RegExp(r'( Wherigo.ZInput\()').hasMatch(currentLine) || RegExp(r'(function)').hasMatch(currentLine)) {
    return false;
  }
  return true;
}

WherigoTimerData _analyzeAndExtractTimerSectionData(List<String> lines) {
  String LUAname = '';
  String id = '';
  String name = '';
  String description = '';
  String visible = '';
  String duration = '';
  String type = '';

  bool _sectionDescription = true;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();

    if (RegExp(r'( Wherigo.ZTimer\()').hasMatch(lines[i])) {
      LUAname = _getLUAName(lines[i]);
    }

    if (lines[i].trim().startsWith(LUAname + '.Id')) {
      id = _getLineData(lines[i], LUAname, 'Id', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].trim().startsWith(LUAname + '.Name')) {
      name = _getLineData(lines[i], LUAname, 'Name', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].trim().startsWith(LUAname + '.Description')) {
      description = '';
      _sectionDescription = true;

      do {
        description = description + lines[i];
        i++;
        lines[i] = lines[i].trim();
        if (i > lines.length - 1 || lines[i].trim().startsWith(LUAname + '.Visible')) _sectionDescription = false;
      } while (_sectionDescription);
      description = _getLineData(description, LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].trim().startsWith(LUAname + '.Duration')) {
      duration = _getLineData(lines[i], LUAname, 'Duration', _obfuscatorFunction, _obfuscatorTable).trim();
    }

    if (lines[i].trim().startsWith(LUAname + '.Type')) {
      type = _getLineData(lines[i], LUAname, 'Type', _obfuscatorFunction, _obfuscatorTable).trim().toLowerCase();
    }

    if (lines[i].trim().startsWith(LUAname + '.Visible')) {
      visible = _getLineData(lines[i], LUAname, 'Visible', _obfuscatorFunction, _obfuscatorTable).trim().toLowerCase();
    }
  }
  return WherigoTimerData(
    TimerLUAName: LUAname,
    TimerID: id,
    TimerName: name,
    TimerDescription: description,
    TimerVisible: visible,
    TimerDuration: duration,
    TimerType: type,
  );
}
