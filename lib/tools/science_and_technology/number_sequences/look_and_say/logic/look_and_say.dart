
String lookAndSay(String input) {
  if (input.isEmpty) return '';

  final regex = RegExp(r'(.)\1*');
  return input.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}