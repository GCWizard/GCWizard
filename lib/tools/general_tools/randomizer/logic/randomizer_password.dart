import 'dart:math';

String passwordGenerator(String characters, int length) {
  var out = '';
  if (characters.isEmpty || length <= 0) {
    return out;
  }

  var random = Random();
  for (int i = 0; i < length; i++) {
    var index = random.nextInt(characters.length);
    out += characters[index];
  }

  return out;
}

double bitEntropy(String text) {
  if (text.isEmpty) {
    return 0.0;
  }

  var symbolCount = 0;

  if (text.contains(RegExp(r'[0-9]'))) {
    symbolCount += 10;
  }

  if (text.contains(RegExp(r'[A-Z]'))) {
    symbolCount += 26;
  }

  if (text.contains(RegExp(r'[a-z]'))) {
    symbolCount += 26;
  }

  var specialChars = text.replaceAll(RegExp(r'[A-Za-z0-9]'), '');
  var maxASCII = 0;
  var maxExtASCII = 0;
  var maxTotal = 0;

  for (var char in specialChars.codeUnits) {
    if (char < 128 && char >= 32 && char > maxASCII) {
      maxASCII = char;
    }

    if (char > 161 && char <= 255 && char > maxExtASCII) {
      maxExtASCII = char;
    }

    if (char > 255 && char > maxTotal) {
      maxTotal = char;
    }
  }

  if (maxASCII > 0) {
    symbolCount = 95; // Notice: It is NOT += but a full reset to all ASCII chars
  }

  if (maxExtASCII > 0) {
    symbolCount += 95;
  }

  if (maxTotal > 0) {
    var bitLength = (log(maxTotal) / log(2)).ceil();
    symbolCount += pow(2, bitLength).toInt() - 255;
  }

  return text.length * log(symbolCount) / log(2);
}