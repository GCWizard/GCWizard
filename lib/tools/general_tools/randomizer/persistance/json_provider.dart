import 'dart:convert';

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/persistance/model.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:prefs/prefs.dart';

void refreshRandomizerLists() {
  var lists = Prefs.getString(PREFERENCE_RANDOMIZER_LISTS);
  if (lists.isEmpty) {
    randomizerLists = [];
    return;
  }

  randomizerLists = randomizerListsFromJson(asJsonMap(jsonDecode(lists))).toList();
}

void updateRandomizerLists() {
  _saveData();
}

void _saveData() {
  var map = <String, List<String>>{};
  for (var list in randomizerLists) {
    map.putIfAbsent(list.name, () => list.list);
  }

  var jsonData = jsonEncode(map);

  Prefs.setString(PREFERENCE_RANDOMIZER_LISTS, jsonData);
}