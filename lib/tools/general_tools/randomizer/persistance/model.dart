import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

List<RandomizerList> randomizerLists = [];

List<RandomizerList> randomizerListsFromJson(Map<String, Object?> json) {
  var lists = <RandomizerList>[];

  for (MapEntry<String, Object?> entry in json.entries) {
    if (entry.key.isEmpty) {
      continue;
    }

    var list = RandomizerList(entry.key);
    list.list = toStringListOrNull(entry.value) ?? [];

    lists.add(list);
  }

  return lists;
}

class RandomizerList {
  String name = '';
  List<String> list = [];

  RandomizerList(this.name) {
    if (name.isEmpty) {
      throw const FormatException('RandomizerList name must not be empty.');
    }
  }

  Map<String, Object?> toMap() => {
    name: list
  };
}