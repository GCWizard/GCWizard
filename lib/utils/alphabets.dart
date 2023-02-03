import 'package:gc_wizard/utils/collection_utils.dart';

const alphabet_09 = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9};
final alphabet_09Indexes = switchMapKeyValue(alphabet_09);

const alphabet_AZ = {
  'A': 1,
  'B': 2,
  'C': 3,
  'D': 4,
  'E': 5,
  'F': 6,
  'G': 7,
  'H': 8,
  'I': 9,
  'J': 10,
  'K': 11,
  'L': 12,
  'M': 13,
  'N': 14,
  'O': 15,
  'P': 16,
  'Q': 17,
  'R': 18,
  'S': 19,
  'T': 20,
  'U': 21,
  'V': 22,
  'W': 23,
  'X': 24,
  'Y': 25,
  'Z': 26,
};
final alphabet_AZIndexes = switchMapKeyValue(alphabet_AZ);
final alphabet_AZString = alphabet_AZ.keys.join();

const SUPERSCRIPT_CHARACTERS = {
  '0': '\u2070',
  '1': '\u00B9',
  '2': '\u00B2',
  '3': '\u00B3',
  '4': '\u2074',
  '5': '\u2075',
  '6': '\u2076',
  '7': '\u2077',
  '8': '\u2078',
  '9': '\u2079',
  'a': '\u1d43',
  'b': '\u1d47',
  'c': '\u1d9c',
  'd': '\u1d48',
  'e': '\u1d49',
  'f': '\u1da0',
  'g': '\u1d4d',
  'h': '\u02b0',
  'i': '\u2071',
  'j': '\u02b2',
  'k': '\u1d4f',
  'l': '\u02e1',
  'm': '\u1d50',
  'n': '\u207f',
  'o': '\u1d52',
  'p': '\u1d56',
  //    'q' : missing in Unicode
  'r': '\u02b3',
  's': '\u02e2',
  't': '\u1d57',
  'u': '\u1d58',
  'v': '\u1d5b',
  'w': '\u02b7',
  'x': '\u02e3',
  'y': '\u02b8',
  'z': '\u1dbb',
  'A': '\u1d2c',
  'B': '\u1d2e',
  //    'C' : missing in Unicode
  'D': '\u1d30',
  'E': '\u1d31',
  //    'F' : missing in Unicode
  'G': '\u1d33',
  'H': '\u1d34',
  'I': '\u1d35',
  'J': '\u1d36',
  'K': '\u1d37',
  'L': '\u1d38',
  'M': '\u1d39',
  'N': '\u1d3a',
  'O': '\u1d3c',
  'P': '\u1d3e',
  //    'Q' : missing in Unicode
  'R': '\u1d3f',
  //    'S' : missing in Unicode
  'T': '\u1d40',
  'U': '\u1d41',
  'V': '\u2c7d',
  'W': '\u1d42',
  //    'X' : missing in Unicode
  //    'Y' : missing in Unicode
  //    'Z' : missing in Unicode
  '+': '\u207A',
  '-': '\u207B',
  '=': '\u207C',
  '(': '\u207D',
  ')': '\u207E',
};

enum AlphabetType { STANDARD, CUSTOM }

class Alphabet {
  final String key;
  final String name;
  final AlphabetType type;
  final Map<String, String> alphabet;

  const Alphabet({this.key, this.alphabet, this.name, this.type: AlphabetType.CUSTOM});
}

final Alphabet alphabetAZ = Alphabet(
    key: 'alphabet_name_az',
    type: AlphabetType.STANDARD,
    alphabet: alphabet_AZ.map((key, value) => MapEntry(key, value.toString())));

final Alphabet alphabetGerman1 = Alphabet(key: 'alphabet_name_german1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(196): '27', // Ä
  String.fromCharCode(214): '28', // Ö
  String.fromCharCode(220): '29', // Ü
  String.fromCharCode(223): '30', // ß
});

final Alphabet alphabetGerman2 = Alphabet(key: 'alphabet_name_german2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(196): '1,5', // Ä
  String.fromCharCode(214): '15,5', // Ö
  String.fromCharCode(220): '21,5', // Ü
  String.fromCharCode(223): '19,19', // ß
});

final Alphabet alphabetGerman3 = Alphabet(key: 'alphabet_name_german3', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(196): '6', // Ä
  String.fromCharCode(214): '20', // Ö
  String.fromCharCode(220): '26', // Ü
  String.fromCharCode(223): '38', // ß
});

final Alphabet alphabetEnglish = Alphabet(key: 'alphabet_name_english', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(207): '9', // Ï
});

final Alphabet alphabetFrench1 = Alphabet(key: 'alphabet_name_french1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(192): '1', // À
  String.fromCharCode(194): '1', // Â
  String.fromCharCode(201): '5', // É
  String.fromCharCode(200): '5', // È
  String.fromCharCode(202): '5', // Ê
  String.fromCharCode(203): '5', // Ë
  String.fromCharCode(206): '9', // Î
  String.fromCharCode(207): '9', // Ï
  String.fromCharCode(212): '15', // Ô
  String.fromCharCode(217): '21', // Ù
  String.fromCharCode(219): '21', // Û
  String.fromCharCode(220): '21', // Ü
  String.fromCharCode(376): '25', // Ÿ
  String.fromCharCode(198): '1,5', // Æ
  String.fromCharCode(338): '15,5', // Œ
  String.fromCharCode(199): '3', // Ç
});

final Alphabet alphabetFrench2 = Alphabet(key: 'alphabet_name_french2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  String.fromCharCode(192): '1', // À
  String.fromCharCode(194): '1', // Â
  String.fromCharCode(201): '5', // É
  String.fromCharCode(200): '5', // È
  String.fromCharCode(202): '5', // Ê
  String.fromCharCode(203): '5', // Ë
  String.fromCharCode(206): '9', // Î
  String.fromCharCode(207): '9', // Ï
  String.fromCharCode(212): '15', // Ô
  String.fromCharCode(217): '21', // Ù
  String.fromCharCode(219): '21', // Û
  String.fromCharCode(220): '21', // Ü
  String.fromCharCode(376): '25', // Ÿ
  String.fromCharCode(198): '6', // Æ
  String.fromCharCode(338): '20', // Œ
  String.fromCharCode(199): '3', // Ç
});

final Alphabet alphabetSpanish1 = Alphabet(key: 'alphabet_name_spanish1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'CH': '4', 'D': '5', 'E': '6', 'F': '7', 'G': '8', 'H': '9', 'I': '10', 'J': '11',
  'K': '12', 'L': '13',
  'LL': '14', 'M': '15', 'N': '16',
  String.fromCharCode(209): '17', // Ñ,
  'O': '18', 'P': '19', 'Q': '20', 'R': '21', 'S': '22', 'T': '23', 'U': '24', 'V': '25', 'W': '26', 'X': '27',
  'Y': '28', 'Z': '29'
});

final Alphabet alphabetSpanish2 = Alphabet(key: 'alphabet_name_spanish2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13', 'N': '14',
  String.fromCharCode(209): '15', // Ñ,
  'O': '16', 'P': '17', 'Q': '18', 'R': '19', 'S': '20', 'T': '21', 'U': '22', 'V': '23', 'W': '24', 'X': '25',
  'Y': '26', 'Z': '27'
});

final Alphabet alphabetPolish1 = Alphabet(key: 'common_language_polish', type: AlphabetType.STANDARD, alphabet: {
  'A': '1',
  String.fromCharCode(260): '2', // Ą
  'B': '3', 'C': '4',
  String.fromCharCode(262): '5', // Ć
  'D': '6', 'E': '7',
  String.fromCharCode(280): '8', // Ę
  'F': '9', 'G': '10', 'H': '11', 'I': '12', 'J': '13', 'K': '14', 'L': '15',
  String.fromCharCode(321): '16', // Ł
  'M': '17', 'N': '18',
  String.fromCharCode(323): '19', // Ń
  'O': '20',
  String.fromCharCode(211): '21', // Ó
  'P': '22', 'R': '23', 'S': '24',
  String.fromCharCode(346): '25', // Ś
  'T': '26', 'U': '27', 'W': '28', 'Y': '29', 'Z': '30',
  String.fromCharCode(377): '31', // Ź
  String.fromCharCode(379): '32', // Ż
});

final Alphabet alphabetGreek1 = Alphabet(key: 'alphabet_name_greek1', type: AlphabetType.STANDARD, alphabet: {
  String.fromCharCode(913): '1', // Α
  String.fromCharCode(914): '2', // Β
  String.fromCharCode(915): '3', // Γ
  String.fromCharCode(916): '4', // Δ
  String.fromCharCode(917): '5', // Ε
  String.fromCharCode(918): '6', // Ζ
  String.fromCharCode(919): '7', // Η
  String.fromCharCode(920): '8', // Θ
  String.fromCharCode(921): '9', // Ι
  String.fromCharCode(922): '10', // Κ
  String.fromCharCode(923): '11', // Λ
  String.fromCharCode(924): '12', // Μ
  String.fromCharCode(925): '13', // Ν
  String.fromCharCode(926): '14', // Ξ
  String.fromCharCode(927): '15', // Ο
  String.fromCharCode(928): '16', // Π
  String.fromCharCode(929): '17', // Ρ
  String.fromCharCode(931): '18', // Σ
  String.fromCharCode(932): '19', // Τ
  String.fromCharCode(933): '20', // Υ
  String.fromCharCode(934): '21', // Φ
  String.fromCharCode(935): '22', // Χ
  String.fromCharCode(936): '23', // Ψ
  String.fromCharCode(937): '24', // Ω
});

final Alphabet alphabetGreek2 = Alphabet(key: 'alphabet_name_greek2', type: AlphabetType.STANDARD, alphabet: {
  'Α': '1',
  'Ά': '2',
  'Β': '3',
  'Γ': '4',
  'Δ': '5',
  'Ε': '6',
  'Έ': '7',
  'Ζ': '8',
  'Η': '9',
  'Ή': '10',
  'Θ': '11',
  'Ι': '12',
  'Ί': '13',
  'Κ': '14',
  'Λ': '15',
  'Μ': '16',
  'Ν': '17',
  'Ξ': '18',
  'Ο': '19',
  'Ό': '20',
  'Π': '21',
  'Ρ': '22',
  'Σ': '23',
  'Τ': '24',
  'Υ': '25',
  'Ύ': '26',
  'Φ': '27',
  'Χ': '29',
  'Ψ': '30',
  'Ω': '31',
  'Ώ': '32'
});

final Alphabet alphabetRussian1 = Alphabet(key: 'common_language_russian', type: AlphabetType.STANDARD, alphabet: {
  String.fromCharCode(1040): '1', // А
  String.fromCharCode(1041): '2', // Б
  String.fromCharCode(1042): '3', // В
  String.fromCharCode(1043): '4', // Г
  String.fromCharCode(1044): '5', // Д
  String.fromCharCode(1045): '6', // Е
  String.fromCharCode(1025): '7', // Ё
  String.fromCharCode(1046): '8', // Ж
  String.fromCharCode(1047): '9', // З
  String.fromCharCode(1048): '10', // И
  String.fromCharCode(1049): '11', // Й
  String.fromCharCode(1050): '12', // К
  String.fromCharCode(1051): '13', // Л
  String.fromCharCode(1052): '14', // М
  String.fromCharCode(1053): '15', // Н
  String.fromCharCode(1054): '16', // О
  String.fromCharCode(1055): '17', // П
  String.fromCharCode(1056): '18', // Р
  String.fromCharCode(1057): '19', // С
  String.fromCharCode(1058): '20', // Т
  String.fromCharCode(1059): '21', // У
  String.fromCharCode(1060): '22', // Ф
  String.fromCharCode(1061): '23', // Х
  String.fromCharCode(1062): '24', // Ц
  String.fromCharCode(1063): '25', // Ч
  String.fromCharCode(1064): '26', // Ш
  String.fromCharCode(1065): '27', // Щ
  String.fromCharCode(1066): '28', // Ъ
  String.fromCharCode(1067): '29', // Ы
  String.fromCharCode(1068): '30', // Ь
  String.fromCharCode(1069): '31', // Э
  String.fromCharCode(1070): '32', // Ю
  String.fromCharCode(1071): '33', // Я
});

final List<Alphabet> ALL_ALPHABETS = [
  alphabetAZ,
  alphabetGerman1,
  alphabetGerman2,
  alphabetGerman3,
  alphabetEnglish,
  alphabetFrench1,
  alphabetFrench2,
  alphabetPolish1,
  alphabetSpanish1,
  alphabetSpanish2,
  alphabetGreek1,
  alphabetGreek2,
  alphabetRussian1,
];

final letterFrequencyAlphabetGerman1 = {
  'A': 6,
  'B': 2,
  'C': 2,
  'D': 5,
  'E': 17,
  'F': 2,
  'G': 3,
  'H': 5,
  'I': 8,
  'J': 1,
  'K': 1,
  'L': 3,
  'M': 2,
  'N': 10,
  'O': 2,
  'P': 1,
  'Q': 1,
  'R': 7,
  'S': 7,
  'T': 6,
  'U': 4,
  'V': 1,
  'W': 1,
  'X': 1,
  'Y': 1,
  'Z': 1
};
final letterFrequencyAlphabetEnglish1 = {
  'A': 8,
  'B': 2,
  'C': 3,
  'D': 4,
  'E': 12,
  'F': 2,
  'G': 2,
  'H': 6,
  'I': 6,
  'J': 1,
  'K': 1,
  'L': 4,
  'M': 2,
  'N': 6,
  'O': 7,
  'P': 2,
  'Q': 1,
  'R': 6,
  'S': 6,
  'T': 9,
  'U': 3,
  'V': 1,
  'W': 2,
  'X': 1,
  'Y': 2,
  'Z': 1
};
final letterFrequencyAlphabetSpanish2 = {
  'A': 12,
  'B': 1,
  'C': 4,
  'D': 5,
  'E': 13,
  'F': 1,
  'G': 1,
  'H': 1,
  'I': 6,
  'J': 1,
  'K': 1,
  'L': 5,
  'M': 3,
  'N': 6,
  'Ñ': 1,
  'O': 8,
  'P': 2,
  'Q': 1,
  'R': 7,
  'S': 8,
  'T': 4,
  'U': 4,
  'V': 1,
  'W': 1,
  'X': 1,
  'Y': 1,
  'Z': 1
};
final letterFrequencyAlphabetRussian1 = {
  'А': 7,
  'Б': 2,
  'В': 4,
  'Г': 1,
  'Д': 3,
  'Е': 9,
  'Ё': 1,
  'Ж': 1,
  'З': 1,
  'И': 7,
  'Й': 1,
  'К': 3,
  'Л': 5,
  'М': 3,
  'Н': 7,
  'О': 11,
  'П': 2,
  'Р': 4,
  'С': 5,
  'Т': 6,
  'У': 2,
  'Ф': 1,
  'Х': 1,
  'Ц': 1,
  'Ч': 1,
  'Ш': 1,
  'Щ': 1,
  'Ъ': 1,
  'Ы': 2,
  'Ь': 2,
  'Э': 1,
  'Ю': 1,
  'Я': 2
};
final letterFrequencyAlphabetPolish1 = {
  'A': 8,
  'Ą': 1,
  'B': 2,
  'C': 4,
  'Ć': 1,
  'D': 3,
  'E': 8,
  'Ę': 1,
  'F': 1,
  'G': 1,
  'H': 1,
  'I': 9,
  'J': 2,
  'K': 3,
  'L': 2,
  'Ł': 2,
  'M': 3,
  'N': 6,
  'Ń': 1,
  'O': 7,
  'Ó': 1,
  'P': 3,
  'R': 4,
  'S': 4,
  'Ś': 1,
  'T': 4,
  'U': 2,
  'W': 4,
  'Y': 4,
  'Z': 5,
  'Ź': 1,
  'Ż': 1
};
final letterFrequencyAlphabetGreek1 = {
  'Α': 13,
  'Β': 1,
  'Γ': 2,
  'Δ': 2,
  'Ε': 9,
  'Ζ': 1,
  'Η': 5,
  'Θ': 1,
  'Ι': 9,
  'Κ': 4,
  'Λ': 2,
  'Μ': 3,
  'Ν': 6,
  'Ξ': 1,
  'Ο': 9,
  'Π': 4,
  'Ρ': 4,
  'Σ': 7,
  'Τ': 8,
  'Υ': 4,
  'Φ': 1,
  'Χ': 1,
  'Ψ': 1,
  'Ω': 2
};
final letterFrequencyAlphabetGreek2 = {
  'Α': 11,
  'Ά': 2,
  'Β': 1,
  'Γ': 2,
  'Δ': 2,
  'Ε': 7,
  'Έ': 2,
  'Ζ': 1,
  'Η': 3,
  'Ή': 2,
  'Θ': 1,
  'Ι': 7,
  'Ί': 2,
  'Κ': 4,
  'Λ': 2,
  'Μ': 3,
  'Ν': 6,
  'Ξ': 1,
  'Ο': 7,
  'Ό': 2,
  'Π': 4,
  'Ρ': 4,
  'Σ': 7,
  'Τ': 8,
  'Υ': 3,
  'Ύ': 1,
  'Φ': 1,
  'Χ': 1,
  'Ψ': 1,
  'Ω': 1,
  'Ώ': 1
};

Map<String, int> getLetterFrequenciesFromAlphabet(Alphabet alphabet) {
  if (alphabet == alphabetGerman1) return letterFrequencyAlphabetGerman1;
  if (alphabet == alphabetEnglish) return letterFrequencyAlphabetEnglish1;
  if (alphabet == alphabetSpanish2) return letterFrequencyAlphabetSpanish2;
  if (alphabet == alphabetPolish1) return letterFrequencyAlphabetPolish1;
  if (alphabet == alphabetGreek1) return letterFrequencyAlphabetGreek1;
  if (alphabet == alphabetGreek2) return letterFrequencyAlphabetGreek2;
  if (alphabet == alphabetRussian1) return letterFrequencyAlphabetRussian1;

  return null;
}
