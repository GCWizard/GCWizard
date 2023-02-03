final int _MAX_UTF16 = 1112064;

List<int> asciiEncode(String input) {
  if (input == null || input.isEmpty) return <int>[];

  return input.codeUnits;
}

String asciiDecode(List<int> input) {
  if (input == null || input.isEmpty) return '';

  List<int> list = List<int>.from(input);
  list = list.where((value) => value != null && value < _MAX_UTF16).toList();

  if (list.isEmpty) return '';

  return String.fromCharCodes(list);
}
