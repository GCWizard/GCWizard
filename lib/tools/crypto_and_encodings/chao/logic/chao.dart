enum ChaoAlphabet { AZ, ZA, CUSTOM }

String _permuteChiffreAlphabet(String chiffreChar, String alphabet) {
  int nadir = 13;
  int zenith = 0;
  String helpAlphabet = '';
  String returnAlphabet = '';
  int posChiffreChar = alphabet.indexOf(chiffreChar);

  for (int i = posChiffreChar; i <= 25; i++) {
    helpAlphabet = helpAlphabet + alphabet[i];
  }
  for (int i = 0; i < posChiffreChar; i++) {
    helpAlphabet = helpAlphabet + alphabet[i];
  }

  var helpChar = helpAlphabet[zenith + 1];

  returnAlphabet = helpAlphabet[0];
  for (int i = zenith + 2; i <= nadir; i++) {
    returnAlphabet = returnAlphabet + helpAlphabet[i];
  }
  returnAlphabet = returnAlphabet + helpChar;

  for (int i = nadir + 1; i <= 25; i++) {
    returnAlphabet = returnAlphabet + helpAlphabet[i];
  }
  return returnAlphabet;
}

String _permutePlainAlphabet(String plainChar, String alphabet) {
  int nadir = 13;
  int zenith = 0;
  String helpAlphabet = '';
  String returnAlphabet = '';
  int posPlainChar = alphabet.indexOf(plainChar);

  for (int i = posPlainChar; i <= 25; i++) {
    helpAlphabet = helpAlphabet + alphabet[i];
  }
  for (int i = 0; i < posPlainChar; i++) {
    helpAlphabet = helpAlphabet + alphabet[i];
  }

  returnAlphabet = helpAlphabet;
  helpAlphabet = '';
  var helpChar = returnAlphabet[0];
  for (int i = 1; i <= 25; i++) {
    helpAlphabet = helpAlphabet + returnAlphabet[i];
  }
  helpAlphabet = helpAlphabet + helpChar;

  helpChar = helpAlphabet[zenith + 2];

  returnAlphabet = helpAlphabet[0];
  returnAlphabet = returnAlphabet + helpAlphabet[1];
  for (int i = zenith + 3; i <= nadir; i++) {
    returnAlphabet = returnAlphabet + helpAlphabet[i];
  }
  returnAlphabet = returnAlphabet + helpChar;

  for (int i = nadir + 1; i <= 25; i++) {
    returnAlphabet = returnAlphabet + helpAlphabet[i];
  }

  return returnAlphabet;
}

String encryptChao(String plaintext, String alphabetPlain, String alphabetChiffre) {
  if (alphabetPlain.length < 26 || alphabetChiffre.length < 26) return '';
  String chiffretext = '';
  var chiffreChar;
  var plainChar;
  for (int i = 0; i < plaintext.length; i++) {
    plainChar = plaintext[i].toUpperCase();
    if (alphabetPlain.indexOf(plainChar) >= 0) {
      chiffreChar = alphabetChiffre[alphabetPlain.indexOf(plainChar)];
      chiffretext = chiffretext + chiffreChar;
      alphabetChiffre = _permuteChiffreAlphabet(chiffreChar, alphabetChiffre);
      alphabetPlain = _permutePlainAlphabet(plainChar, alphabetPlain);
    }
  }
  return chiffretext;
}

String decryptChao(String chiffretext, String alphabetPlain, String alphabetChiffre) {
  if (alphabetPlain.length < 26 || alphabetChiffre.length < 26) return '';
  String plaintext = '';
  var chiffreChar;
  var plainChar;
  for (int i = 0; i < chiffretext.length; i++) {
    chiffreChar = chiffretext[i].toUpperCase();
    if (alphabetChiffre.indexOf(chiffreChar) >= 0) {
      plainChar = alphabetPlain[alphabetChiffre.indexOf(chiffreChar)];
      plaintext = plaintext + plainChar;
      alphabetChiffre = _permuteChiffreAlphabet(chiffreChar, alphabetChiffre);
      alphabetPlain = _permutePlainAlphabet(plainChar, alphabetPlain);
    }
  }
  return plaintext;
}
