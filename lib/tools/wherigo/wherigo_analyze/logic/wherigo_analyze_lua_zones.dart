part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionZone(String currentLine) {
  if (RegExp(r'( Wherigo.ZCharacter\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZItem\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZTask\()').hasMatch(currentLine) ||
      RegExp(r'(.ZVariables =)').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZTimer\()').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.ZInput\()').hasMatch(currentLine) ||
      RegExp(r'(function)').hasMatch(currentLine) ||
      RegExp(r'( Wherigo.Zone\()').hasMatch(currentLine)) {
    return false;
  }
  return true;
}

WherigoZoneData _analyzeAndExtractZoneSectionData(List<String> lines) {
  String LUAname = '';
  String id = '';
  String name = '';
  String description = '';
  String visible = '';
  String media = '';
  String icon = '';
  String active = '';
  String distanceRange = '';
  String showObjects = '';
  String proximityRange = '';
  WherigoZonePoint originalPoint = WherigoZonePoint(0.0, 0.0, 0.0);
  String distanceRangeUOM = '';
  String proximityRangeUOM = '';
  String outOfRange = '';
  String inRange = '';
  List<WherigoZonePoint> points = [];

  bool _sectionDescription = true;

  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();
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
      description = description.replaceAll('[[', '').replaceAll(']]', '').replaceAll('<BR>', '\n');
      description = getLineData(description, LUAname, 'Description', _obfuscatorFunction, _obfuscatorTable).trim();
      if (description.startsWith('WWB_multi')) description = removeWWB(description);
    }

    if (lines[i].startsWith(LUAname + '.Visible')) {
      visible = getLineData(lines[i], LUAname, 'Visible', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Media')) {
      media = getLineData(lines[i], LUAname, 'Media', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Icon')) {
      icon = getLineData(lines[i], LUAname, 'Icon', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Active')) {
      active = getLineData(lines[i], LUAname, 'Active', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.DistanceRangeUOM =')) {
      distanceRangeUOM = getLineData(lines[i], LUAname, 'DistanceRangeUOM', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.ProximityRangeUOM =')) {
      proximityRangeUOM =
          getLineData(lines[i], LUAname, 'ProximityRangeUOM', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.DistanceRange =')) {
      distanceRange = getLineData(lines[i], LUAname, 'DistanceRange', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.ShowObjects')) {
      showObjects = getLineData(lines[i], LUAname, 'ShowObjects', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.ProximityRange =')) {
      proximityRange = getLineData(lines[i], LUAname, 'ProximityRange', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.OriginalPoint')) {
      String point = getLineData(lines[i], LUAname, 'OriginalPoint', _obfuscatorFunction, _obfuscatorTable);
      List<String> pointdata =
      point.replaceAll('ZonePoint(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      originalPoint =
          WherigoZonePoint(double.parse(pointdata[0]), double.parse(pointdata[1]), double.parse(pointdata[2]));
    }

    if (lines[i].startsWith(LUAname + '.OutOfRangeName')) {
      outOfRange = getLineData(lines[i], LUAname, 'OutOfRangeName', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.InRangeName')) {
      inRange = getLineData(lines[i], LUAname, 'InRangeName', _obfuscatorFunction, _obfuscatorTable);
    }

    if (lines[i].startsWith(LUAname + '.Points = ')) {
      i++;
      lines[i] = lines[i].trim();
      do {
        while (lines[i].trimLeft().startsWith('ZonePoint')) {
          points.add(_getPoint(lines[i]));
          i++;
          lines[i] = lines[i].trim();
        }
      } while (lines[i].trimLeft().startsWith('ZonePoint'));
    }
  }
  return WherigoZoneData(
    LUAname,
    id,
    name,
    description,
    visible,
    media,
    icon,
    active,
    distanceRange,
    showObjects,
    proximityRange,
    originalPoint,
    distanceRangeUOM,
    proximityRangeUOM,
    outOfRange,
    inRange,
    points,
  );
}
