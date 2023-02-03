import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/drawable_image_data.dart';

Map<String, int> colorMap = {
  '0': 0xFFFFFFFF, //Colors.white
  '1': 0xFF000000, //Colors.black
  '2': 0xFFFF5252, //Colors.redAccent //light red
  '3': 0xFFFFF9C4, //Colors.yellow.shade100 //light yellow
  '4': 0xFF8BC34A, //Colors.lightGreen
  '5': 0xFF18FFFF, //Colors.cyanAccent //light cyan,
  '6': 0xFF03A9F4, //Colors.lightBlue
  '7': 0xFFFF80AB, //Colors.pinkAccent.shade100 //light magenta,
  '8': 0xFFF44336, //Colors.red,
  '9': 0xFFFFFF00, //Colors.yellowAccent
  'A': 0xFF4CAF50, //Colors.green
  'B': 0xFF00BCD4, //Colors.cyan
  'C': 0xFF2196F3, //Colors.blue
  'D': 0xFFE040FB, //Colors.purpleAccent //magenta,
  'E': 0xFFB71C1C, //Colors.red.shade900 //dark red,
  'F': 0xFFFFEB3B, //Colors.yellow, //dark yellow,
  'G': 0xFF1B5E20, //Colors.green.shade900 //dark green,
  'H': 0xFF006064, //Colors.cyan.shade900 //dark cyan,
  'I': 0xFF0D47A1, //Colors.blue.shade900 //dark blue,
  'J': 0xFF9C27B0, //Colors.purple //dark magenta
  'K': 0xFFFF9800, //Colors.orange
  'L': 0xFFFF5722, //Colors.deepOrange
  'M': 0xFFFFAB40, //Colors.orangeAccent
  'N': 0xFF795548, //Colors.brown
  'O': 0xFF3E2723, //Colors.brown.shade900
  '#': 0xFFE0E0E0, //Colors.grey.shade300
};

DrawableImageData binary2image(String input, bool squareFormat, bool invers) {
  var filter = _buildFilter(input);
  if (filter.length < 2) return null;

  if (!squareFormat) filter += "\n";
  input = _filterInput(input, filter);

  if (invers)
    input = substitution(input, {filter[0]: '1', filter[1]: '0'});
  else
    input = substitution(input, {filter[0]: '0', filter[1]: '1'});

  if (squareFormat) {
    var size = sqrt(input.length).ceil();
    input = insertSpaceEveryNthCharacter(input, size);
    input = input.replaceAll(RegExp('[ ]'), '\n');
  }

  return binary2Image(input);
}

String _buildFilter(String input) {
  var alphabet = removeDuplicateCharacters(input);
  alphabet = alphabet.replaceAll(RegExp('[\r\n\t]'), '');
  var alphabetTmp = alphabet.split('').toList();
  alphabetTmp.sort();
  alphabet = alphabetTmp.join();

  if (alphabet.length <= 2) {
    return alphabet;
  }

  if (alphabet.length == 3 && alphabet.contains(' ')) return alphabet.replaceAll(' ', '');

  var filter = '';
  var map = Map<String, int>();

  alphabet.split('').forEach((char) {
    map.addAll({char: char.allMatches(input).length});
  });

  var countList = map.values.toList();
  countList.sort();

  for (int i = 0; i < countList.length; i++) {
    map.forEach((key, value) {
      if (value == countList[i]) filter += key;
    });
    map.removeWhere((key, value) => value == countList[i]);
  }
  filter = filter.split('').reversed.join();

  filter = filter.substring(0, 3);
  if (filter.contains(' '))
    return filter.replaceAll(' ', '');
  else
    return filter.substring(0, 2);
}

String _filterInput(String input, String filter) {
  var special = ".\$*+-?";
  special.split('').forEach((char) {
    filter = filter.replaceAll(char, '\\' + char);
  });

  return input.replaceAll(RegExp('[^$filter]'), '');
}

DrawableImageData binary2Image(String input) {
  if (input == '' || input == null) return null;

  var lines = input.split('\n');

  if (lines.length == 1)
    lines.addAll(List<String>.filled(9, lines[0]));
  return DrawableImageData(lines, colorMap);
}

