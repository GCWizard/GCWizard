import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/utils/alphabets.dart';

enum PortaTableVersion { ORIGINAL, REVERSE }

List<String>? _createPortaTable(PortaTableVersion version, {bool classic = false}) {
  String alphabet = alphabet_AZ.keys.join('');
  if (classic) {alphabet = alphabet.replaceAll(RegExp('[JKUW]'), '');}

  String head = alphabet.substring(0, alphabet.length ~/ 2);
  String initialLine = alphabet.substring(alphabet.length ~/ 2);
  int shift = (version == PortaTableVersion.ORIGINAL) ? -1 : 1;

  List<String> table = [head];
  for (int i = 0; i < initialLine.length; i++) {
    table.add(Rotator(alphabet: initialLine).rotate(initialLine, shift * i));
  }

  return table;
}

String togglePorta(String text, String key, { PortaTableVersion version = PortaTableVersion.ORIGINAL, bool classic = false }) {
  List<String>? table = _createPortaTable(version, classic: classic);

  if (text.isEmpty || key.isEmpty || table == null) { return ""; }

  StringBuffer output = StringBuffer();
  int rowLength = table[0].length;
  text = text.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
  key = key.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');

  if (classic) {
    text = text.replaceAll(RegExp('[JKUW]'), '');
    key = key.replaceAll(RegExp('[JKUW]'), '');
  }

  for (var i = 0; i < text.length; i++) {
    var row = ((key[i % key.length].codeUnitAt(0) - 65) ~/ 2) % rowLength + 1;
    output.write( (table[row].contains(text[i]))
        ? table[0][table[row].indexOf(text[i])]
        : table[row][table[0].indexOf(text[i])]
    );
  }

  return output.toString();
}