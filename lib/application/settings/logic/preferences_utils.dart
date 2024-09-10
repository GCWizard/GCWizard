import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:prefs/prefs.dart';

enum PrefType { STRING, STRINGLIST, INT, DOUBLE, BOOL }

PrefType getPrefType(String key) {
  try {
    Prefs.getString(key);
    return PrefType.STRING;
  } catch (e) {}

  try {
    Prefs.getStringList(key);
    return PrefType.STRINGLIST;
  } catch (e) {}

  try {
    Prefs.getInt(key);
    return PrefType.INT;
  } catch (e) {}

  try {
    Prefs.getDouble(key);
    return PrefType.DOUBLE;
  } catch (e) {}

  try {
    Prefs.getBool(key);
    return PrefType.BOOL;
  } catch (e) {}

  throw Exception('Unexpected Preference Type');
}

void setUntypedPref(String key, Object value) {
  switch (getPrefType(key)) {
    case PrefType.STRING:
      Prefs.setString(key, value.toString());
      break;
    case PrefType.INT:
      if (value is int) Prefs.setInt(key, value);
      break;
    case PrefType.DOUBLE:
      if (value is double) Prefs.setDouble(key, value);
      break;
    case PrefType.BOOL:
      if (value is bool) Prefs.setBool(key, value);
      break;
    case PrefType.STRINGLIST:
      if (value is List<String> || value is List<Object> || value is List<dynamic>) {
        var saveList = <String>[];

        if (value is List<String>) {
          saveList = value;
        } else if (value is List<Object>) {
          for (var element in value) {
            saveList.add(element.toString());
          }
        } else if (value is List<dynamic>){ // JSON Objects
          for (var element in value) {
            saveList.add(element.toString());
          }
        } else {
          throw Exception('No valid Preference STRINGLIST type');
        }

        saveList.removeWhere((element) => element.isEmpty);
        Prefs.setStringList(key, saveList);
      }
      break;
    default:
      throw Exception('No valid preference type');
  }
}

bool isValidPreference(String key) {
  return ALL_PREFERENCES.contains(key.toLowerCase());
}

bool isCorrectType(String key, Object? value) {
  if (value == null) return false;

  switch (getPrefType(key.toLowerCase())) {
    case PrefType.STRING:
      return value is String;
    case PrefType.INT:
      return value is int;
    case PrefType.DOUBLE:
      return value is double;
    case PrefType.BOOL:
      return value is bool;
    case PrefType.STRINGLIST:
      if (value is List<String>) return true;
      if (value is List<Object>) {
        var allStrings = true;
        for (var element in value) {
          allStrings &= element is String;
        }

        return allStrings;
      }
      if (value is List<dynamic>) {
        var allStrings = true;
        for (var element in value) {
          allStrings &= element is String;
        }

        return allStrings;
      }
      return false;
  }
}
