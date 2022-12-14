import 'package:prefs/prefs.dart';

enum PrefType { STRING, STRINGLIST, INT, DOUBLE, BOOL }

PrefType getPrefType(String key) {
  try {
    String x = Prefs.get(key);
    return PrefType.STRING;
  } catch (e) {}

  try {
    List<String> x = Prefs.get(key);
    return PrefType.STRINGLIST;
  } catch (e) {}

  try {
    List<Object> x = Prefs.get(key);
    return PrefType.STRINGLIST;
  } catch (e) {}

  try {
    int x = Prefs.get(key);
    return PrefType.INT;
  } catch (e) {}

  try {
    double x = Prefs.get(key);
    return PrefType.DOUBLE;
  } catch (e) {}

  try {
    bool x = Prefs.get(key);
    return PrefType.BOOL;
  } catch (e) {}

  return null;
}

setUntypedPref(String key, dynamic value) {
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

      if (value is List<String> || value is List<Object>) {
        var saveList = <String>[];
        if (value is List<String>) {
          saveList = value;
          saveList.removeWhere((element) => element.isEmpty);
        } else {
          (value as List<Object>).forEach((element) => saveList.add(element.toString()));
        }

        Prefs.setStringList(key, saveList);
      }
      break;
  }
}