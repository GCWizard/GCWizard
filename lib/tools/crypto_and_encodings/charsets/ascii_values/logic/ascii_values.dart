const int _MAX_UTF16 = 1112064;

List<int> asciiEncode(String input) {
  if (input.isEmpty) return <int>[];

  return input.codeUnits;
}

String asciiDecode(List<int?> input) {
  if (input.isEmpty) return '';

  var list = List<int>.from(input.where((value) => value != null));
  list = list.where((value) => value < _MAX_UTF16).toList();

  if (list.isEmpty) return '';

  return String.fromCharCodes(list);
}
