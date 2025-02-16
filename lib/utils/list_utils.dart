import 'dart:typed_data';

bool isSublist<T>(List<T> list, List<T> sublist) {
  var _list = List<T>.from(list);
  var _sublist = List<T>.from(sublist);

  for (var element in sublist) {
    if (_list.contains(element)) {
      _sublist.remove(element);
      _list.remove(element);
    }
  }

  return _sublist.isEmpty;
}

bool uint8ListEquals(Uint8List list1, Uint8List list2) {
  if (list1.length != list2.length) return false;

  for (var x =0; x < list1.length; x++) {
    if (list1[x] != list2[x]) return false;
  }
  return true;
}
