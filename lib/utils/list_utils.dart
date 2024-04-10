bool isSublist<T>(List<T> list, List<T> sublist) {
  var _list = List<T>.from(list);
  var _sublist = List<T>.from(sublist);

  sublist.forEach((element) {
    if (_list.contains(element)) {
      _sublist.remove(element);
      _list.remove(element);
    }
  });

  return _sublist.isEmpty;
}