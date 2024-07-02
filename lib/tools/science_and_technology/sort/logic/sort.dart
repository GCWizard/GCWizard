enum SortingMode {ASCENDING, DESCENDING}

List<T> _sortList<T>(List<T> list, SortingMode mode) {
  list.sort();

  if (mode == SortingMode.DESCENDING) {
    list = list.reversed.toList();
  }

  return list;
}

String sortTextASCII(String input, SortingMode mode) {
  var sort = input.split('').toList();
  return _sortList<String>(sort, mode).join();
}

List<T> sortList<T>(List<T> input, SortingMode mode) {
  var sort = List<T>.from(input);
  return _sortList<T>(sort, mode);
}

String sortBlocks(String input, SortingMode mode) {
  if (input.isEmpty) return input;

  var delimiters = input.replaceAll(RegExp(r'[^\s]'), '');
  var blocks = sortList<String>(input.split(RegExp(r'[\s]')).toList(), mode);

  var output = blocks.first;
  for (int i = 0; i < delimiters.length; i++) {
    output += delimiters[i] + blocks[i + 1];
  }

  return output;
}

String sortTextInBlocks(String input, SortingMode mode) {
  if (input.isEmpty) return input;

  var delimiters = input.replaceAll(RegExp(r'[^\s]'), '');
  var blocks = input.split(RegExp(r'[\s]')).map((block) => sortTextASCII(block, mode)).toList();

  var output = blocks.first;
  for (int i = 0; i < delimiters.length; i++) {
    output += delimiters[i] + blocks[i + 1];
  }

  return output;
}