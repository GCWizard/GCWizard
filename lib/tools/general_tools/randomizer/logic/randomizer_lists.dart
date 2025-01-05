import 'dart:math';

List<T> shuffleList<T>(List<T> list) {
  if (list.isEmpty) {
    return <T>[];
  }

  var outList = List<T>.from(list);
  outList.shuffle();

  return outList;
}

List<List<T>> shuffledSublistsByGroupCount<T>(List<T> originList, int numberSublists) {
  if (originList.isEmpty || numberSublists < 1) {
    return <List<T>>[];
  }

  var shuffled = shuffleList(originList);
  var lengthOrigin = shuffled.length;

  var out = List<List<T>>.generate(numberSublists, (index) => <T>[]);
  for (int i = 0; i < lengthOrigin; i++) {
    out[i % numberSublists].add(shuffled[i]);
  }

  return out;
}

List<List<T>> shuffledSublistsByElementCount<T>(List<T> originList, int elementCount) {
  if (originList.isEmpty || elementCount < 1) {
    return <List<T>>[];
  }

  var shuffled = shuffleList(originList);

  List<List<T>> out = [];
  while (shuffled.isNotEmpty) {
    var nextElements = min(shuffled.length, elementCount);
    out.add(shuffled.sublist(0, nextElements));
    shuffled.removeRange(0, nextElements);
  }

  return out;
}

List<T> randomListElements<T>(List<T> list, int numberElements) {
  if (numberElements <= 0) {
    return <T>[];
  }

  var shuffled = shuffleList(list);
  if (shuffled.isEmpty) {
    return shuffled;
  }

  return shuffled.sublist(0, min<int>(numberElements, shuffled.length));
}