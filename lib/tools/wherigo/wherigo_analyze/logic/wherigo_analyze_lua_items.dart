part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionItem(String currentLine) {
  if (RegExp(r'( Wherigo.ZItem\()').hasMatch(currentLine)) {
    return false;
  }

  return _notDoneWithItems(currentLine);
}

bool _notDoneWithItems(String currentLine) {
  if (RegExp(r'( Wherigo.ZTask\()').hasMatch(currentLine) ||
      RegExp(r'(.ZVariables =)').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZTimer\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZInput\()').hasMatch(currentLine) ||
      RegExp(r'(function)').hasMatch(currentLine)) {
    return false;
  }
  return true;
}

WherigoItemData _analyzeAndExtractItemSectionData(List<String> lines) {
  String LUAname = '';
  String container = '';
  String id = '';
  String name = '';
  String description = '';
  String visible = '';
  String media = '';
  String icon = '';
  String location = '';
  WherigoZonePoint zonePoint = WHERIGO_NULLPOINT ;
  String locked = '';
  String opened = '';

  bool _sectionDescription = true;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();
    if (RegExp(r'( Wherigo.ZItem\()').hasMatch(lines[i])) {
      LUAname = getLUAName(lines[i]);
      container = getContainer(lines[i]);
    }
    if (lines[i].startsWith(LUAname + 'Container =')) {
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
      description = getLineData(description, LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable).trim();
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

    if (lines[i].startsWith(LUAname + '.Locked')) {
      locked = getLineData(lines[i], LUAname, 'Locked', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Opened')) {
      opened = getLineData(lines[i], LUAname, 'Opened', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.ObjectLocation')) {
      location =
          lines[i].trim().replaceAll(LUAname + '.ObjectLocation', '').replaceAll(' ', '').replaceAll('=', '');
      if (location.endsWith('INVALID_ZONEPOINT')) {
        location = '';
      } else if (location.startsWith('ZonePoint')) {
        location = location.replaceAll('ZonePoint(', '').replaceAll(')', '').replaceAll(' ', '');
        zonePoint = WherigoZonePoint(
            Latitude: double.parse(location.split(',')[0]),
            Longitude: double.parse(location.split(',')[1]),
            Altitude: double.parse(location.split(',')[2]));
        location = 'ZonePoint';
      } else {
        location = getLineData(lines[i], LUAname, 'ObjectLocation', _obfuscatorFunction, _obfuscatorTable);
      }
    }
  }
  return WherigoItemData(
      ItemLUAName: LUAname,
      ItemID: id,
      ItemName: name,
      ItemDescription: description,
      ItemVisible: visible,
      ItemMedia: media,
      ItemIcon: icon,
      ItemLocation: location,
      ItemZonepoint: zonePoint,
      ItemContainer: container,
      ItemLocked: locked,
      ItemOpened: opened);
}
