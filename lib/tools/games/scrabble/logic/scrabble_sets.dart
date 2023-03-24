const scrabbleID_EN = "EN";
const scrabbleID_ENSuperScrabble = "EN SuperScrabble";
const scrabbleID_D = "D";
const scrabbleID_D_Gender = "D (Gender)";
const scrabbleID_D1955 = "D 1955";
const scrabbleID_D55_87 = "D 1955-1987";
const scrabbleID_DNorthAmerica = "D North America";
const scrabbleID_NL = "NL";
const scrabbleID_F = "F";
const scrabbleID_E = "E";
const scrabbleID_E_NorthAmerica = "E North America";
const scrabbleID_I = "I";
const scrabbleID_CZ = "CZ";
const scrabbleID_SK = "SK";
const scrabbleID_SKUntil2013 = "SK until 2013";
const scrabbleID_IRL = "IRL";
const scrabbleID_PL = "PL";
const scrabbleID_PLUntil2000 = "PL until 2000";
const scrabbleID_P = "P";
const scrabbleID_FIN = "FIN";
const scrabbleID_SWE = "SWE";
const scrabbleID_KLINGON = "Klingon";

class _LetterAttribute {
  final int value;
  final int frequency;

  const _LetterAttribute(this.value, this.frequency);
}

class ScrabbleSet {
  final String key;
  final String i18nNameId;
  final Map<String, _LetterAttribute> letters;
  final bool caseSensitive;

  const ScrabbleSet(this.key, this.i18nNameId, this.letters, {this.caseSensitive = false});

  int letterValue(String letter) {
    if (!caseSensitive) letter = letter.toUpperCase();

    var l = letters[letter];

    if (l == null) return 0;

    return l.value;
  }

  int letterFrequency(String letter) {
    if (!caseSensitive) letter = letter.toUpperCase();

    var l = letters[letter];

    if (l == null) return 0;

    return l.frequency;
  }

  bool existLetter(String letter) {
    if (!caseSensitive) letter = letter.toUpperCase();

    return letters[letter] != null;
  }
}

// TODO Better as class type?
const Map<String, ScrabbleSet> scrabbleSets = {
  scrabbleID_EN: ScrabbleSet(scrabbleID_EN, 'common_language_english', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 9),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(3, 2),
    'D': _LetterAttribute(2, 4),
    'E': _LetterAttribute(1, 12),
    'F': _LetterAttribute(4, 4),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 9),
    'J': _LetterAttribute(8, 1),
    'K': _LetterAttribute(5, 1),
    'L': _LetterAttribute(1, 4),
    'M': _LetterAttribute(3, 2),
    'N': _LetterAttribute(1, 6),
    'O': _LetterAttribute(1, 8),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 4),
    'T': _LetterAttribute(1, 6),
    'U': _LetterAttribute(1, 4),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(4, 2),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(4, 2),
    'Z': _LetterAttribute(10, 1),
  }),
  scrabbleID_ENSuperScrabble: ScrabbleSet(scrabbleID_ENSuperScrabble, 'scrabble_version_en_superscrabble', {
    ' ': _LetterAttribute(0, 4),
    'A': _LetterAttribute(1, 16),
    'B': _LetterAttribute(3, 4),
    'C': _LetterAttribute(3, 6),
    'D': _LetterAttribute(2, 8),
    'E': _LetterAttribute(1, 24),
    'F': _LetterAttribute(4, 4),
    'G': _LetterAttribute(2, 5),
    'H': _LetterAttribute(4, 5),
    'I': _LetterAttribute(1, 13),
    'J': _LetterAttribute(8, 2),
    'K': _LetterAttribute(5, 2),
    'L': _LetterAttribute(1, 7),
    'M': _LetterAttribute(3, 6),
    'N': _LetterAttribute(1, 13),
    'O': _LetterAttribute(1, 15),
    'P': _LetterAttribute(3, 4),
    'Q': _LetterAttribute(10, 2),
    'R': _LetterAttribute(1, 13),
    'S': _LetterAttribute(1, 10),
    'T': _LetterAttribute(1, 15),
    'U': _LetterAttribute(1, 7),
    'V': _LetterAttribute(4, 3),
    'W': _LetterAttribute(4, 4),
    'X': _LetterAttribute(8, 2),
    'Y': _LetterAttribute(4, 4),
    'Z': _LetterAttribute(10, 2),
  }),
  scrabbleID_D: ScrabbleSet(scrabbleID_D, 'common_language_german', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 5),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(4, 2),
    'D': _LetterAttribute(1, 4),
    'E': _LetterAttribute(1, 15),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(2, 4),
    'I': _LetterAttribute(1, 6),
    'J': _LetterAttribute(6, 1),
    'K': _LetterAttribute(4, 2),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(3, 4),
    'N': _LetterAttribute(1, 9),
    'O': _LetterAttribute(2, 3),
    'P': _LetterAttribute(4, 1),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 7),
    'T': _LetterAttribute(1, 6),
    'U': _LetterAttribute(1, 6),
    'V': _LetterAttribute(6, 1),
    'W': _LetterAttribute(3, 1),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(10, 1),
    'Z': _LetterAttribute(3, 1),
    '\u00C4': _LetterAttribute(6, 1), //Ä
    '\u00D6': _LetterAttribute(8, 1), //Ö
    '\u00DC': _LetterAttribute(6, 1), //Ü
  }),
  scrabbleID_D_Gender: ScrabbleSet(scrabbleID_D_Gender, 'scrabble_version_d_gendered_2022', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 5),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(4, 2),
    'D': _LetterAttribute(1, 4),
    'E': _LetterAttribute(1, 15),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(2, 4),
    'I': _LetterAttribute(1, 6),
    'J': _LetterAttribute(6, 1),
    'K': _LetterAttribute(4, 2),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(3, 4),
    'N': _LetterAttribute(1, 9),
    'O': _LetterAttribute(2, 3),
    'P': _LetterAttribute(4, 1),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 7),
    'T': _LetterAttribute(1, 6),
    'U': _LetterAttribute(1, 6),
    'V': _LetterAttribute(6, 1),
    'W': _LetterAttribute(3, 1),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(10, 1),
    'Z': _LetterAttribute(3, 1),
    '\u00C4': _LetterAttribute(6, 1), //Ä
    '\u00D6': _LetterAttribute(8, 1), //Ö
    '\u00DC': _LetterAttribute(6, 1), //Ü
    '*IN': _LetterAttribute(10, 1),
  }),
  scrabbleID_D1955: ScrabbleSet(scrabbleID_D1955, 'scrabble_version_d_1955', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 6),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(3, 2),
    'D': _LetterAttribute(2, 4),
    'E': _LetterAttribute(1, 14),
    'F': _LetterAttribute(3, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(3, 3),
    'I': _LetterAttribute(1, 8),
    'J': _LetterAttribute(8, 1),
    'K': _LetterAttribute(3, 2),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(3, 3),
    'N': _LetterAttribute(1, 8),
    'O': _LetterAttribute(1, 3),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 6),
    'T': _LetterAttribute(1, 6),
    'U': _LetterAttribute(1, 3),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(4, 2),
    'X': _LetterAttribute(10, 1),
    'Y': _LetterAttribute(8, 1),
    'Z': _LetterAttribute(8, 1),
    '\u00C4': _LetterAttribute(2, 1), //Ä
    '\u00D6': _LetterAttribute(2, 1), //Ö
    '\u00DC': _LetterAttribute(2, 1), //Ü
  }),
  scrabbleID_D55_87: ScrabbleSet(scrabbleID_D55_87, 'scrabble_version_d_19551987', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 6),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(2, 4),
    'D': _LetterAttribute(1, 6),
    'E': _LetterAttribute(1, 16),
    'F': _LetterAttribute(3, 3),
    'G': _LetterAttribute(1, 3),
    'H': _LetterAttribute(2, 5),
    'I': _LetterAttribute(1, 9),
    'J': _LetterAttribute(6, 1),
    'K': _LetterAttribute(3, 2),
    'L': _LetterAttribute(2, 4),
    'M': _LetterAttribute(3, 4),
    'N': _LetterAttribute(1, 10),
    'O': _LetterAttribute(2, 4),
    'P': _LetterAttribute(4, 1),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 7),
    'S': _LetterAttribute(1, 8),
    'T': _LetterAttribute(2, 5),
    'U': _LetterAttribute(1, 6),
    'V': _LetterAttribute(4, 1),
    'W': _LetterAttribute(2, 2),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(10, 1),
    'Z': _LetterAttribute(3, 2),
    '\u00C4': _LetterAttribute(6, 1), //Ä
    '\u00D6': _LetterAttribute(8, 1), //Ö
    '\u00DC': _LetterAttribute(5, 1), //Ü
  }),
  scrabbleID_DNorthAmerica: ScrabbleSet(scrabbleID_DNorthAmerica, 'scrabble_version_d_northamerica', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 6),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(2, 4),
    'D': _LetterAttribute(2, 4),
    'E': _LetterAttribute(1, 12),
    'F': _LetterAttribute(3, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(2, 4),
    'I': _LetterAttribute(1, 8),
    'J': _LetterAttribute(8, 1),
    'K': _LetterAttribute(3, 2),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(3, 3),
    'N': _LetterAttribute(1, 7),
    'O': _LetterAttribute(1, 3),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 5),
    'S': _LetterAttribute(1, 6),
    'T': _LetterAttribute(1, 5),
    'U': _LetterAttribute(1, 3),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(4, 2),
    'X': _LetterAttribute(10, 1),
    'Y': _LetterAttribute(10, 1),
    'Z': _LetterAttribute(4, 3),
    '\u00C4': _LetterAttribute(2, 1), //Ä
    '\u00D6': _LetterAttribute(2, 1), //Ö
    '\u00DC': _LetterAttribute(2, 1), //Ü
  }),
  scrabbleID_NL: ScrabbleSet(scrabbleID_NL, 'common_language_dutch', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 6),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(5, 2),
    'D': _LetterAttribute(2, 5),
    'E': _LetterAttribute(1, 18),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(3, 3),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 4),
    'J': _LetterAttribute(4, 2),
    'K': _LetterAttribute(3, 3),
    'L': _LetterAttribute(3, 3),
    'M': _LetterAttribute(3, 3),
    'N': _LetterAttribute(1, 10),
    'O': _LetterAttribute(1, 6),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(2, 5),
    'S': _LetterAttribute(2, 5),
    'T': _LetterAttribute(2, 5),
    'U': _LetterAttribute(4, 3),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(5, 2),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(8, 1),
    'Z': _LetterAttribute(4, 2),
  }),
  scrabbleID_F: ScrabbleSet(scrabbleID_F, 'common_language_french', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 9),
    'B': _LetterAttribute(2, 2),
    'C': _LetterAttribute(2, 2),
    'D': _LetterAttribute(2, 3),
    'E': _LetterAttribute(1, 15),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(2, 2),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 8),
    'J': _LetterAttribute(8, 1),
    'K': _LetterAttribute(10, 1),
    'L': _LetterAttribute(1, 5),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 6),
    'O': _LetterAttribute(1, 6),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(8, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 6),
    'T': _LetterAttribute(1, 6),
    'U': _LetterAttribute(1, 6),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(10, 1),
    'X': _LetterAttribute(10, 1),
    'Y': _LetterAttribute(10, 1),
    'Z': _LetterAttribute(10, 1),
  }),
  scrabbleID_E: ScrabbleSet(scrabbleID_E, 'common_language_spanish', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 12),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(3, 4),
    'D': _LetterAttribute(2, 5),
    'E': _LetterAttribute(1, 12),
    'F': _LetterAttribute(4, 1),
    'G': _LetterAttribute(2, 2),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 6),
    'J': _LetterAttribute(8, 1),
    'L': _LetterAttribute(1, 4),
    'M': _LetterAttribute(3, 2),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 9),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(5, 1),
    'R': _LetterAttribute(1, 5),
    'S': _LetterAttribute(1, 6),
    'T': _LetterAttribute(1, 4),
    'U': _LetterAttribute(1, 5),
    'V': _LetterAttribute(4, 1),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(4, 1),
    'Z': _LetterAttribute(10, 1),
    'CH': _LetterAttribute(5, 1),
    'LL': _LetterAttribute(8, 1),
    'RR': _LetterAttribute(8, 1),
    '\u00D1': _LetterAttribute(8, 1), //Ñ
  }),
  scrabbleID_E_NorthAmerica: ScrabbleSet(scrabbleID_E_NorthAmerica, 'scrabble_version_e_northamerica', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 11),
    'B': _LetterAttribute(3, 3),
    'C': _LetterAttribute(2, 4),
    'D': _LetterAttribute(2, 4),
    'E': _LetterAttribute(1, 11),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(2, 2),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 6),
    'J': _LetterAttribute(6, 2),
    'K': _LetterAttribute(8, 1),
    'L': _LetterAttribute(1, 4),
    'M': _LetterAttribute(3, 3),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 8),
    'P': _LetterAttribute(3, 2),
    'Q': _LetterAttribute(8, 1),
    'R': _LetterAttribute(1, 4),
    'S': _LetterAttribute(1, 7),
    'T': _LetterAttribute(1, 4),
    'U': _LetterAttribute(1, 6),
    'V': _LetterAttribute(4, 2),
    'W': _LetterAttribute(8, 1),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(4, 1),
    'Z': _LetterAttribute(10, 1),
    'LL': _LetterAttribute(8, 1),
    'RR': _LetterAttribute(8, 1),
    '\u00D1': _LetterAttribute(8, 1), //Ñ
  }),
  scrabbleID_I: ScrabbleSet(scrabbleID_I, 'common_language_italian', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 14),
    'B': _LetterAttribute(5, 3),
    'C': _LetterAttribute(2, 6),
    'D': _LetterAttribute(5, 3),
    'E': _LetterAttribute(1, 11),
    'F': _LetterAttribute(5, 3),
    'G': _LetterAttribute(8, 2),
    'H': _LetterAttribute(8, 2),
    'I': _LetterAttribute(1, 12),
    'L': _LetterAttribute(3, 5),
    'M': _LetterAttribute(3, 5),
    'N': _LetterAttribute(3, 5),
    'O': _LetterAttribute(1, 15),
    'P': _LetterAttribute(5, 3),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(2, 6),
    'S': _LetterAttribute(2, 6),
    'T': _LetterAttribute(2, 6),
    'U': _LetterAttribute(3, 5),
    'V': _LetterAttribute(5, 3),
    'Z': _LetterAttribute(8, 2),
  }),
  scrabbleID_CZ: ScrabbleSet(scrabbleID_CZ, 'common_language_czech', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 5),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(2, 3),
    'D': _LetterAttribute(1, 3),
    'E': _LetterAttribute(1, 5),
    'F': _LetterAttribute(5, 1),
    'G': _LetterAttribute(5, 1),
    'H': _LetterAttribute(2, 3),
    'I': _LetterAttribute(1, 4),
    'J': _LetterAttribute(2, 2),
    'K': _LetterAttribute(1, 3),
    'L': _LetterAttribute(1, 3),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 6),
    'P': _LetterAttribute(1, 3),
    'R': _LetterAttribute(1, 3),
    'S': _LetterAttribute(1, 4),
    'T': _LetterAttribute(1, 4),
    'U': _LetterAttribute(2, 3),
    'V': _LetterAttribute(1, 4),
    'X': _LetterAttribute(10, 1),
    'Y': _LetterAttribute(2, 2),
    'Z': _LetterAttribute(2, 2),
    '\u00CD': _LetterAttribute(2, 3), //Í
    '\u00C1': _LetterAttribute(2, 2), //Á
    '\u00C9': _LetterAttribute(3, 2), //É
    '\u011A': _LetterAttribute(3, 2), //Ě
    '\u0158': _LetterAttribute(4, 2), //Ř
    '\u0160': _LetterAttribute(4, 2), //Š
    '\u00DD': _LetterAttribute(4, 2), //Ý
    '\u010C': _LetterAttribute(4, 1), //Č
    '\u016E': _LetterAttribute(4, 1), //Ů
    '\u017D': _LetterAttribute(4, 1), //Ž
    '\u00DA': _LetterAttribute(5, 1), //Ú
    '\u0147': _LetterAttribute(6, 1), //Ň
    '\u00D3': _LetterAttribute(7, 1), //Ó
    '\u0164': _LetterAttribute(7, 1), //Ť
    '\u010E': _LetterAttribute(8, 1), //Ď
  }),
  scrabbleID_SK: ScrabbleSet(scrabbleID_SK, 'common_language_slovak', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 9),
    'B': _LetterAttribute(2, 2),
    'C': _LetterAttribute(3, 1),
    'D': _LetterAttribute(2, 3),
    'E': _LetterAttribute(1, 8),
    'F': _LetterAttribute(6, 1),
    'G': _LetterAttribute(6, 1),
    'H': _LetterAttribute(3, 1),
    'I': _LetterAttribute(1, 6),
    'J': _LetterAttribute(2, 2),
    'K': _LetterAttribute(2, 4),
    'L': _LetterAttribute(2, 4),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 10),
    'P': _LetterAttribute(2, 3),
    'Q': _LetterAttribute(10, 1),
    'R': _LetterAttribute(2, 5),
    'S': _LetterAttribute(1, 5),
    'T': _LetterAttribute(1, 4),
    'U': _LetterAttribute(2, 3),
    'V': _LetterAttribute(1, 5),
    'W': _LetterAttribute(10, 1),
    'X': _LetterAttribute(9, 1),
    'Y': _LetterAttribute(2, 2),
    'Z': _LetterAttribute(2, 2),
    '\u00C1': _LetterAttribute(2, 2), //Á
    '\u010C': _LetterAttribute(3, 1), //Č
    '\u017D': _LetterAttribute(3, 1), //Ž
    '\u0160': _LetterAttribute(3, 1), //Š
    '\u00CD': _LetterAttribute(3, 1), //Í
    '\u00DD': _LetterAttribute(3, 1), //Ý
    '\u013D': _LetterAttribute(5, 1), //Ľ
    '\u0164': _LetterAttribute(4, 1), //Ť
    '\u00C9': _LetterAttribute(3, 1), //É
    '\u00DA': _LetterAttribute(3, 1), //Ú
    '\u010E': _LetterAttribute(8, 1), //Ď
    '\u0147': _LetterAttribute(7, 1), //Ň
    '\u00D4': _LetterAttribute(7, 1), //Ô
    '\u0139': _LetterAttribute(9, 1), //Ĺ
    '\u0154': _LetterAttribute(9, 1), //Ŕ
    '\u00C4': _LetterAttribute(8, 1), //Ä
    '\u00D3': _LetterAttribute(8, 1), //Ó
  }),
  scrabbleID_SKUntil2013: ScrabbleSet(scrabbleID_SKUntil2013, 'scrabble_version_sk_until2013', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 9),
    'B': _LetterAttribute(4, 2),
    'C': _LetterAttribute(4, 1),
    'D': _LetterAttribute(2, 3),
    'E': _LetterAttribute(1, 8),
    'F': _LetterAttribute(8, 1),
    'G': _LetterAttribute(8, 1),
    'H': _LetterAttribute(4, 1),
    'I': _LetterAttribute(1, 5),
    'J': _LetterAttribute(3, 2),
    'K': _LetterAttribute(2, 3),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(2, 4),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 9),
    'P': _LetterAttribute(2, 3),
    'R': _LetterAttribute(1, 4),
    'S': _LetterAttribute(1, 4),
    'T': _LetterAttribute(1, 4),
    'U': _LetterAttribute(3, 2),
    'V': _LetterAttribute(1, 4),
    'X': _LetterAttribute(10, 1),
    'Y': _LetterAttribute(4, 1),
    'Z': _LetterAttribute(4, 1),
    '\u00C1': _LetterAttribute(4, 1), //Á
    '\u010C': _LetterAttribute(5, 1), //Č
    '\u017D': _LetterAttribute(5, 1), //Ž
    '\u0160': _LetterAttribute(5, 1), //Š
    '\u00CD': _LetterAttribute(5, 1), //Í
    '\u00DD': _LetterAttribute(5, 1), //Ý
    '\u013D': _LetterAttribute(7, 1), //Ľ
    '\u0164': _LetterAttribute(7, 1), //Ť
    '\u00C9': _LetterAttribute(7, 1), //É
    '\u00DA': _LetterAttribute(7, 1), //Ú
    '\u010E': _LetterAttribute(8, 1), //Ď
    '\u0147': _LetterAttribute(8, 1), //Ň
    '\u00D4': _LetterAttribute(8, 1), //Ô
    '\u0139': _LetterAttribute(10, 1), //Ĺ
    '\u0154': _LetterAttribute(10, 1), //Ŕ
    '\u00C4': _LetterAttribute(10, 1), //Ä
    '\u00D3': _LetterAttribute(10, 1), //Ó
  }),
  scrabbleID_IRL: ScrabbleSet(scrabbleID_IRL, 'common_language_irish', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 13),
    'B': _LetterAttribute(10, 1),
    'C': _LetterAttribute(2, 4),
    'D': _LetterAttribute(2, 4),
    'E': _LetterAttribute(1, 6),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(1, 10),
    'I': _LetterAttribute(1, 10),
    'L': _LetterAttribute(2, 4),
    'M': _LetterAttribute(4, 2),
    'N': _LetterAttribute(1, 7),
    'O': _LetterAttribute(2, 4),
    'P': _LetterAttribute(10, 1),
    'R': _LetterAttribute(1, 7),
    'S': _LetterAttribute(1, 6),
    'T': _LetterAttribute(2, 4),
    'U': _LetterAttribute(2, 3),
    '\u00C1': _LetterAttribute(4, 2), //Á
    '\u00CD': _LetterAttribute(4, 2), //Í
    '\u00C9': _LetterAttribute(8, 1), //É
    '\u00D3': _LetterAttribute(8, 1), //Ó
    '\u00DA': _LetterAttribute(8, 1), //Ú
  }),
  scrabbleID_PL: ScrabbleSet(scrabbleID_PL, 'common_language_polish', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 9),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(2, 3),
    'D': _LetterAttribute(2, 3),
    'E': _LetterAttribute(1, 7),
    'F': _LetterAttribute(5, 1),
    'G': _LetterAttribute(3, 2),
    'H': _LetterAttribute(3, 2),
    'I': _LetterAttribute(1, 8),
    'J': _LetterAttribute(3, 2),
    'K': _LetterAttribute(2, 3),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 6),
    'P': _LetterAttribute(2, 3),
    'R': _LetterAttribute(1, 4),
    'S': _LetterAttribute(1, 4),
    'T': _LetterAttribute(2, 3),
    'U': _LetterAttribute(3, 2),
    'W': _LetterAttribute(1, 4),
    'Y': _LetterAttribute(2, 4),
    'Z': _LetterAttribute(1, 5),
    '\u0141': _LetterAttribute(3, 2), //Ł
    '\u0104': _LetterAttribute(5, 1), //Ą
    '\u0118': _LetterAttribute(5, 1), //Ę
    '\u00D3': _LetterAttribute(5, 1), //Ó
    '\u015A': _LetterAttribute(5, 1), //Ś
    '\u017B': _LetterAttribute(5, 1), //Ż
    '\u0106': _LetterAttribute(6, 1), //Ć
    '\u0143': _LetterAttribute(7, 1), //Ń
    '\u0179': _LetterAttribute(9, 1), //Ź
  }),
  scrabbleID_PLUntil2000: ScrabbleSet(scrabbleID_PLUntil2000, 'scrabble_version_pl_until2000', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 8),
    'B': _LetterAttribute(3, 2),
    'C': _LetterAttribute(2, 3),
    'D': _LetterAttribute(2, 3),
    'E': _LetterAttribute(1, 7),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(3, 2),
    'H': _LetterAttribute(3, 2),
    'I': _LetterAttribute(1, 8),
    'J': _LetterAttribute(3, 2),
    'K': _LetterAttribute(2, 3),
    'L': _LetterAttribute(2, 3),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 5),
    'O': _LetterAttribute(1, 6),
    'P': _LetterAttribute(2, 3),
    'R': _LetterAttribute(1, 4),
    'S': _LetterAttribute(1, 4),
    'T': _LetterAttribute(2, 3),
    'U': _LetterAttribute(3, 2),
    'W': _LetterAttribute(1, 4),
    'Y': _LetterAttribute(2, 4),
    'Z': _LetterAttribute(1, 5),
    '\u0141': _LetterAttribute(3, 2), //Ł
    '\u0104': _LetterAttribute(5, 1), //Ą
    '\u0118': _LetterAttribute(5, 1), //Ę
    '\u00D3': _LetterAttribute(5, 1), //Ó
    '\u015A': _LetterAttribute(5, 1), //Ś
    '\u017B': _LetterAttribute(5, 1), //Ż
    '\u0106': _LetterAttribute(6, 1), //Ć
    '\u0143': _LetterAttribute(7, 1), //Ń
    '\u0179': _LetterAttribute(7, 1), //Ź
  }),
  scrabbleID_P: ScrabbleSet(scrabbleID_P, 'common_language_portuguese', {
    ' ': _LetterAttribute(0, 3),
    'A': _LetterAttribute(1, 14),
    'B': _LetterAttribute(3, 3),
    'C': _LetterAttribute(2, 4),
    'D': _LetterAttribute(2, 5),
    'E': _LetterAttribute(1, 11),
    'F': _LetterAttribute(4, 2),
    'G': _LetterAttribute(4, 2),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 10),
    'J': _LetterAttribute(5, 2),
    'L': _LetterAttribute(2, 5),
    'M': _LetterAttribute(1, 6),
    'N': _LetterAttribute(3, 4),
    'O': _LetterAttribute(1, 10),
    'P': _LetterAttribute(2, 4),
    'Q': _LetterAttribute(6, 1),
    'R': _LetterAttribute(1, 6),
    'S': _LetterAttribute(1, 8),
    'T': _LetterAttribute(1, 5),
    'U': _LetterAttribute(1, 7),
    'V': _LetterAttribute(4, 2),
    'X': _LetterAttribute(8, 1),
    'Z': _LetterAttribute(8, 1),
    '\u00C7': _LetterAttribute(3, 2), //Ç
  }),
  scrabbleID_FIN: ScrabbleSet(scrabbleID_FIN, 'common_language_finnish', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 10),
    'B': _LetterAttribute(8, 1),
    'C': _LetterAttribute(10, 1),
    'D': _LetterAttribute(7, 1),
    'E': _LetterAttribute(1, 8),
    'F': _LetterAttribute(8, 1),
    'G': _LetterAttribute(8, 1),
    'H': _LetterAttribute(4, 2),
    'I': _LetterAttribute(1, 10),
    'J': _LetterAttribute(4, 2),
    'K': _LetterAttribute(2, 5),
    'L': _LetterAttribute(2, 5),
    'M': _LetterAttribute(3, 3),
    'N': _LetterAttribute(1, 9),
    'O': _LetterAttribute(2, 5),
    'P': _LetterAttribute(4, 2),
    'R': _LetterAttribute(4, 2),
    'S': _LetterAttribute(1, 7),
    'T': _LetterAttribute(1, 9),
    'U': _LetterAttribute(3, 4),
    'V': _LetterAttribute(4, 2),
    'Y': _LetterAttribute(4, 2),
    '\u00C4': _LetterAttribute(2, 5), //Ä
    '\u00D6': _LetterAttribute(7, 1), //Ö
  }),
  scrabbleID_SWE: ScrabbleSet(scrabbleID_SWE, 'common_language_swedish', {
    ' ': _LetterAttribute(0, 2),
    'A': _LetterAttribute(1, 8),
    'B': _LetterAttribute(4, 2),
    'C': _LetterAttribute(8, 1),
    'D': _LetterAttribute(1, 5),
    'E': _LetterAttribute(1, 7),
    'F': _LetterAttribute(3, 2),
    'G': _LetterAttribute(2, 3),
    'H': _LetterAttribute(2, 2),
    'I': _LetterAttribute(1, 5),
    'J': _LetterAttribute(7, 1),
    'K': _LetterAttribute(2, 3),
    'L': _LetterAttribute(1, 5),
    'M': _LetterAttribute(2, 3),
    'N': _LetterAttribute(1, 6),
    'O': _LetterAttribute(2, 5),
    'P': _LetterAttribute(4, 2),
    'R': _LetterAttribute(1, 8),
    'S': _LetterAttribute(1, 8),
    'T': _LetterAttribute(1, 8),
    'U': _LetterAttribute(4, 3),
    'V': _LetterAttribute(3, 2),
    'X': _LetterAttribute(8, 1),
    'Y': _LetterAttribute(7, 1),
    'Z': _LetterAttribute(10, 1),
    '\u00C4': _LetterAttribute(2, 2), //Ä
    '\u00D6': _LetterAttribute(7, 2), //Ö
    '\u00DC': _LetterAttribute(0, 0), //Ü //There's no real letter but the rules allow them as blanko
    '\u00C5': _LetterAttribute(4, 2), //Å
    '\u00C6': _LetterAttribute(0, 0), //There's no real letter but the rules allow them as blanko
    'Q': _LetterAttribute(0, 0), //There's no real letter but the rules allow them as blanko
    'W': _LetterAttribute(0, 0), //There's no real letter but the rules allow them as blanko
  }),
  scrabbleID_KLINGON: ScrabbleSet(scrabbleID_KLINGON, 'common_language_klingon', {
        ' ': _LetterAttribute(0, 2),
        'a': _LetterAttribute(1, 10),
        'e': _LetterAttribute(1, 8),
        'o': _LetterAttribute(1, 6),
        'u': _LetterAttribute(1, 6),
        'H': _LetterAttribute(1, 5),
        'j': _LetterAttribute(2, 5),
        'm': _LetterAttribute(2, 5),
        'D': _LetterAttribute(2, 4),
        'v': _LetterAttribute(2, 4),
        'l': _LetterAttribute(3, 3),
        'b': _LetterAttribute(3, 2),
        'ch': _LetterAttribute(3, 2),
        'gh': _LetterAttribute(3, 2),
        'n': _LetterAttribute(3, 2),
        'q': _LetterAttribute(3, 2),
        'S': _LetterAttribute(3, 2),
        'p': _LetterAttribute(4, 2),
        't': _LetterAttribute(4, 2),
        'w': _LetterAttribute(5, 2),
        'y': _LetterAttribute(5, 2),
        'Q': _LetterAttribute(6, 1),
        'r': _LetterAttribute(6, 1),
        'tlh': _LetterAttribute(8, 1),
        'ng': _LetterAttribute(10, 1),
        '\'': _LetterAttribute(1, 10),
        '\u026A': _LetterAttribute(1, 8), //ɪ --> Same as I, so both variants are included here
        'I': _LetterAttribute(1, 8) //It's not really in the game, but simulates the 618 character... for less frustrations on input ;)
      },
      caseSensitive: true),
};
