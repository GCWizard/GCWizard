part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionCharacter(String currentLine) {
  if (RegExp(r'( Wherigo.ZItem\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZTask\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZInput\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZTimer\()').hasMatch(currentLine) ||
      RegExp(r'(.ZVariables =)').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZCharacter\()').hasMatch(currentLine) ||
      RegExp(r'(function)').hasMatch(currentLine)) {
    return false;
  }
  return true;
}

WherigoCharacterData _analyzeAndExtractCharacterSectionData(List<String> lines, String container) {
  String LUAname = '';
  String id = '';
  String name = '';
  String description = '';
  String visible = '';
  String media = '';
  String icon = '';
  String location = '';
  WherigoZonePoint zonePoint = WherigoZonePoint(0.0, 0.0, 0.0);
  String type = '';
  String gender = '';

  bool _sectionDescription = true;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();
    if (lines[i].startsWith(LUAname + '.Container =')) {
      container = getContainer(lines[i]);
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
        if (i > lines.length - 2 || lines[i + 1].trim().startsWith(LUAname + '.Visible')) {
          _sectionDescription = false;
        }
        i++;
        lines[i] = lines[i].trim();
      } while (_sectionDescription);
      description = description.replaceAll('[[', '').replaceAll(']]', '').replaceAll('<BR>', '\n');
      description = getLineData(description, LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Visible')) {
      visible = getLineData(lines[i], LUAname, 'Visible', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Media')) {
      media = getLineData(lines[i], LUAname, 'Media', _obfuscatorFunction, _obfuscatorTable).trim();
    }

    if (lines[i].startsWith(LUAname + '.Icon')) {
      icon = getLineData(lines[i], LUAname, 'Icon', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].trim().startsWith(LUAname + '.ObjectLocation')) {
      location =
          lines[i].trim().replaceAll(LUAname + '.ObjectLocation', '').replaceAll(' ', '').replaceAll('=', '');
      if (location.endsWith('INVALID_ZONEPOINT')) {
        location = '';
      } else if (location.startsWith('ZonePoint')) {
        location = location.replaceAll('ZonePoint(', '').replaceAll(')', '').replaceAll(' ', '');
        zonePoint = WherigoZonePoint(double.parse(location.split(',')[0]), double.parse(location.split(',')[1]),
            double.parse(location.split(',')[2]));
        location = 'ZonePoint';
      } else {
        location = getLineData(lines[i], LUAname, 'ObjectLocation', _obfuscatorFunction, _obfuscatorTable);
      }
    }

    if (lines[i].startsWith(LUAname + '.Gender')) {
      gender = getLineData(lines[i], LUAname, 'Gender', _obfuscatorFunction, _obfuscatorTable).toLowerCase().trim();
    }

    if (lines[i].startsWith(LUAname + '.Type')) {
      type = getLineData(lines[i], LUAname, 'Type', _obfuscatorFunction, _obfuscatorTable);
    }
  }
  return WherigoCharacterData(
    LUAname, id, name, description, visible, media, icon, location, zonePoint, container, gender, type
  );
}
