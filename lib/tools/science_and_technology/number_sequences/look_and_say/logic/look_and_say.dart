
String lookAndSay(String str) {
  final regex = RegExp(r'(.)\1*');
  return str.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}