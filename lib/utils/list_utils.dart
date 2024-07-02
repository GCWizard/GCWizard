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
