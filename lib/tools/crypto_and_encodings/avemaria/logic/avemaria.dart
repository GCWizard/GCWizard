import 'dart:math';

part 'package:gc_wizard/tools/crypto_and_encodings/avemaria/logic/avemaria_data.dart';

RegExp _delimiters = RegExp('\t|\n|\r|\r\n');

String decodeAveMaria(String chiffre) {
  List<String> result = [];

  List<String> code = chiffre.toLowerCase()
      .replaceAll(_delimiters, ' ')
      .split(RegExp(' {2,}'));

  for (String line in code) {
    for (var word in line.split(' ')){
      result.add(_AVE_MARIA[word] ?? ' ');
    }
    result.add(' '); // if double space or delimiter, place a space
  }

  return result.join('').trim();
}

String encodeAveMaria(String plain) {
  List<String> result = [];
  List<String> code = plain.toUpperCase().replaceAll(_delimiters, '  ')
      .split(RegExp(r' {2,}'));
  var aveMaria = _AVE_MARIA.entries.toList();
  aveMaria.addAll(_AVE_MARIA_ENCODE_EXTENSION);

  for (String word in code) {
    for (String letter in word.split('')) {
      var results = aveMaria.where((entry) => entry.value == letter);
      if (results.isNotEmpty) {
        result.add(results.elementAt(Random().nextInt(results.length)).key);
      }
    }
    result.add(' ');
  }
  return result.join(' ').trim();
}
