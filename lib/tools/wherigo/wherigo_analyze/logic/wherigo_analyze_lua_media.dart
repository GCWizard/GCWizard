part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionMedia(String currentLine) {
  if (RegExp(r'(Wherigo.ZMedia\()').hasMatch(currentLine)) {
    return false;
  }
  return _notDoneWithMedias(currentLine);
}

bool _notDoneWithMedias(String currentLine) {
  if (RegExp(r'(Wherigo.ZCharacter\()').hasMatch(currentLine) ||
      RegExp(r'(Wherigo.ZItem\()').hasMatch(currentLine) ||
      RegExp(r'(Wherigo.ZTask\()').hasMatch(currentLine) ||
      RegExp(r'(.ZVariables =)').hasMatch(currentLine) ||
      RegExp(r'(Wherigo.ZTimer\()').hasMatch(currentLine) ||
      RegExp(r'(Wherigo.ZInput\()').hasMatch(currentLine) ||
      RegExp(r'(function)').hasMatch(currentLine) ||
      RegExp(r'(Wherigo.Zone\()').hasMatch(currentLine) ||
      currentLine.startsWith(_CartridgeLUAName + '.')) {
    return false;
  }
  return true;
}

WherigoMediaData _analyzeAndExtractMediaSectionData(List<String> lines) {
  String LUAname = '';
  String id = '';
  String name = '';
  String description = '';
  String alttext = '';
  String type = '';
  String filename = '';

  bool _sectionInner = true;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();
    //print(lines[i]);
    if (RegExp(r'(Wherigo.ZMedia\()').hasMatch(lines[i])) {
      LUAname = getLUAName(lines[i]);
    }
    if (lines[i].replaceAll(LUAname + '.', '').startsWith('Id')) {
      id = getLineData(lines[i], LUAname, 'Id', _obfuscatorFunction, _obfuscatorTable);
    } else if (lines[i].replaceAll(LUAname + '.', '').startsWith('Name')) {
      name = getLineData(lines[i], LUAname, 'Name', _obfuscatorFunction, _obfuscatorTable);
    } else if (lines[i].replaceAll(LUAname + '.', '').startsWith('Description')) {
      if (lines[i + 1].trim().replaceAll(LUAname + '.', '').startsWith('AltText')) {
        description = getLineData(lines[i], LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable);
      } else {
        _sectionInner = true;
        description = lines[i].replaceAll(LUAname + '.', '');
        i++;
        do {
          if (lines[i].replaceAll(LUAname + '.', '').startsWith('AltText')) {
            _sectionInner = false;
          } else {
            description = description + lines[i];
          }
          i++;
        } while (_sectionInner);
      }
      if (description.startsWith('WWB_multi')) description = removeWWB(description);
    } else if (lines[i].replaceAll(LUAname + '.', '').startsWith('AltText')) {
      alttext = getLineData(lines[i], LUAname, 'AltText', _obfuscatorFunction, _obfuscatorTable);
    } else if (lines[i].replaceAll(LUAname + '.', '').startsWith('Resources')) {
      if (lines[i].replaceAll(LUAname + '.', '').endsWith('{}')) {
        filename = '';
        type = '';
      } else {
        i++;
        _sectionInner = true;
        do {
          if (lines[i].startsWith('Filename = ')) {
            filename = getStructData(lines[i], 'Filename');
          } else if (lines[i].startsWith('Type = ')) {
            type = getStructData(lines[i], 'Type');
          } else if (lines[i].startsWith('Directives = ')) {
            _sectionInner = false;
          }
          i++;
        } while (_sectionInner);
      }
    }
  }

  return WherigoMediaData(
    MediaLUAName: LUAname,
    MediaID: id,
    MediaName: name,
    MediaDescription: description,
    MediaAltText: alttext,
    MediaType: type,
    MediaFilename: filename,
  );
}
