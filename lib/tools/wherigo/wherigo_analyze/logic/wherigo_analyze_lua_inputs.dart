part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionInput(String currentLine) {
  if (RegExp(r'( Wherigo.ZInput\()').hasMatch(currentLine)) {
    return false;
  }
  return _notDoneWithInputs(currentLine);
}

bool _notDoneWithInputs(String currentLine) {
  if (RegExp(r'(function)').hasMatch(currentLine) ||
      RegExp(r'(:OnProximity)').hasMatch(currentLine) ||
      RegExp(r'(:OnStart)').hasMatch(currentLine)) {
    return false;
  }
  return true;
}

WherigoInputData _analyzeAndExtractInputSectionData(List<String> lines) {
  String LUAname = '';
  String id = '';
  String name = '';
  String description = '';
  String visible = '';
  String media = '';
  String icon = '';
  String variableID = '';
  String inputType = '';
  String text = '';
  List<String> listChoices = [];

  bool _sectionDescription = true;
  bool _sectionChoices = false;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();

    if (RegExp(r'( Wherigo.ZInput\()').hasMatch(lines[i])) {
      LUAname = getLUAName(lines[i]);
    }

    if (lines[i].startsWith(LUAname + '.Id')) {
      id = getLineData(lines[i], LUAname, 'Id', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Name')) {
      name = getLineData(lines[i], LUAname, 'Name', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Description')) {
      description = '';
      _sectionDescription = true;

      do {
        description = description + lines[i];
        i++;
        lines[i] = lines[i].trim();
        if (i > lines.length - 1 || lines[i].startsWith(LUAname + '.Visible')) _sectionDescription = false;
      } while (_sectionDescription);
      i--;
      description = getLineData(description, LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Media')) {
      media = getLineData(lines[i], LUAname, 'Media', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Visible')) {
      visible = getLineData(lines[i], LUAname, 'Visible', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Icon')) {
      icon = getLineData(lines[i], LUAname, 'Icon', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.InputType')) {
      inputType = getLineData(lines[i], LUAname, 'InputType', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.InputVariableId')) {
      variableID = getLineData(lines[i], LUAname, 'InputVariableId', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Text')) {
      if (lines[i].endsWith('"')) {
        text = getLineData(lines[i], LUAname, 'Text', _obfuscatorFunction, _obfuscatorTable);
      } else if (lines[i].contains('[[') && lines[i].endsWith(']]')) {
        text = getLineData(lines[i].replaceAll('[[', '"').replaceAll(']]', '"'), LUAname, 'Text', _obfuscatorFunction,
            _obfuscatorTable);
      } else if (lines[i].contains('WWB_multi') && lines[i].endsWith(')')) {
        text = getLineData(lines[i].replaceAll('WWB_multiplatform_string("', '"').replaceAll('")', '"'), LUAname,
            'Text', _obfuscatorFunction, _obfuscatorTable);
      } else {
        // multi Lines of Text
        text = '';
        do {
          i++;
          text = text + lines[i];
        } while (_notEndOfInputText(lines[i + 1], LUAname));
        text = normalizeWIGText(text.replaceAll(']]', '').replaceAll('<BR>', '\n'));
      }
    }

    if (lines[i].startsWith(LUAname + '.Choices')) {
      listChoices = [];
      if (lines[i + 1].trim().startsWith(LUAname + '.InputType') || lines[i + 1].trim().startsWith(LUAname + '.Text')) {
        listChoices.addAll(getChoicesSingleLine(lines[i], LUAname, _obfuscatorFunction, _obfuscatorTable));
      } else {
        i++;
        _sectionChoices = true;
        do {
          if (lines[i].startsWith('"')) {
            listChoices.add(lines[i].replaceAll('",', '').replaceAll('"', ''));
            i++;
          } else {
            _sectionChoices = false;
          }
        } while (_sectionChoices);
      }
    }
  }
  return WherigoInputData(
    InputLUAName: LUAname,
    InputID: id,
    InputVariableID: variableID,
    InputName: name,
    InputDescription: description,
    InputVisible: visible,
    InputMedia: media,
    InputIcon: icon,
    InputType: inputType,
    InputText: text,
    InputChoices: listChoices,
    InputAnswers: [],
  );
}

bool _notEndOfInputText(String nextLine, String LUAname) {
  if (RegExp(r'( Wherigo.ZInput)').hasMatch(nextLine) || nextLine.startsWith('function')) {
    return false;
  }
  return true;
}
