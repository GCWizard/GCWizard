import 'package:gc_wizard/utils/collection_utils.dart';

const alphabet_09 = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9};
final alphabet_09Indexes = switchMapKeyValue(alphabet_09);

const Map<String, int> alphabet_AZ = {
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
final Map<int, String> alphabet_AZIndexes = switchMapKeyValue(alphabet_AZ);
final String alphabet_AZString = alphabet_AZ.keys.join();

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
  final String? name;
  final AlphabetType type;
  final Map<String, String> alphabet;

  const Alphabet({required this.key, required this.alphabet, this.name, this.type = AlphabetType.CUSTOM});
}

final Alphabet alphabetAZ = Alphabet(
    key: 'alphabet_name_az',
    type: AlphabetType.STANDARD,
    alphabet: alphabet_AZ.map((key, value) => MapEntry(key, value.toString())));

const Alphabet alphabetGerman1 = Alphabet(key: 'alphabet_name_german1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00C4': '27', // Ä
  '\u00D6': '28', // Ö
  '\u00DC': '29', // Ü
  '\u00DF': '30', // ß
});

const Alphabet alphabetGerman2 = Alphabet(key: 'alphabet_name_german2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00C4': '1,5', // Ä
  '\u00D6': '15,5', // Ö
  '\u00DC': '21,5', // Ü
  '\u00DF': '19,19', // ß
});

const Alphabet alphabetGerman3 = Alphabet(key: 'alphabet_name_german3', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00C4': '6', // Ä
  '\u00D6': '20', // Ö
  '\u00DC': '26', // Ü
  '\u00DF': '38', // ß
});

const Alphabet alphabetDanish = Alphabet(key: 'alphabet_name_danish', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  'Æ': '27', 'Ø': '28', 'Å': '29'
});

const Alphabet alphabetEnglish = Alphabet(key: 'alphabet_name_english', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00CF': '9', // Ï
});

const Alphabet alphabetFrench1 = Alphabet(key: 'alphabet_name_french1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00C0': '1', // À
  '\u00C2': '1', // Â
  '\u00C9': '5', // É
  '\u00C8': '5', // È
  '\u00CA': '5', // Ê
  '\u00CB': '5', // Ë
  '\u00CE': '9', // Î
  '\u00CF': '9', // Ï
  '\u00D4': '15', // Ô
  '\u00D9': '21', // Ù
  '\u00DB': '21', // Û
  '\u00DC': '21', // Ü
  '\u0178': '25', // Ÿ
  '\u00C6': '1,5', // Æ
  '\u0152': '15,5', // Œ
  '\u00C7': '3', // Ç
});

const Alphabet alphabetFrench2 = Alphabet(key: 'alphabet_name_french2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13',
  'N': '14', 'O': '15', 'P': '16', 'Q': '17', 'R': '18', 'S': '19', 'T': '20', 'U': '21', 'V': '22', 'W': '23',
  'X': '24', 'Y': '25', 'Z': '26',
  '\u00C0': '1', // À
  '\u00C2': '1', // Â
  '\u00C9': '5', // É
  '\u00C8': '5', // È
  '\u00CA': '5', // Ê
  '\u00CB': '5', // Ë
  '\u00CE': '9', // Î
  '\u00CF': '9', // Ï
  '\u00D4': '15', // Ô
  '\u00D9': '21', // Ù
  '\u00DB': '21', // Û
  '\u00DC': '21', // Ü
  '\u0178': '25', // Ÿ
  '\u00C6': '6', // Æ
  '\u0152': '20', // Œ
  '\u00C7': '3', // Ç
});

const Alphabet alphabetSpanish1 = Alphabet(key: 'alphabet_name_spanish1', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'CH': '4', 'D': '5', 'E': '6', 'F': '7', 'G': '8', 'H': '9', 'I': '10', 'J': '11',
  'K': '12', 'L': '13',
  'LL': '14', 'M': '15', 'N': '16',
  '\u00D1': '17', // Ñ,
  'O': '18', 'P': '19', 'Q': '20', 'R': '21', 'S': '22', 'T': '23', 'U': '24', 'V': '25', 'W': '26', 'X': '27',
  'Y': '28', 'Z': '29'
});

const Alphabet alphabetSpanish2 = Alphabet(key: 'alphabet_name_spanish2', type: AlphabetType.STANDARD, alphabet: {
  'A': '1', 'B': '2', 'C': '3', 'D': '4', 'E': '5', 'F': '6', 'G': '7', 'H': '8', 'I': '9', 'J': '10', 'K': '11',
  'L': '12', 'M': '13', 'N': '14',
  '\u00D1': '15', // Ñ,
  'O': '16', 'P': '17', 'Q': '18', 'R': '19', 'S': '20', 'T': '21', 'U': '22', 'V': '23', 'W': '24', 'X': '25',
  'Y': '26', 'Z': '27'
});

const Alphabet alphabetPolish1 = Alphabet(key: 'common_language_polish', type: AlphabetType.STANDARD, alphabet: {
  'A': '1',
  '\u0104': '2', // Ą
  'B': '3', 'C': '4',
  '\u0106': '5', // Ć
  'D': '6', 'E': '7',
  '\u0118': '8', // Ę
  'F': '9', 'G': '10', 'H': '11', 'I': '12', 'J': '13', 'K': '14', 'L': '15',
  '\u0141': '16', // Ł
  'M': '17', 'N': '18',
  '\u0143': '19', // Ń
  'O': '20',
  '\u00D3': '21', // Ó
  'P': '22', 'R': '23', 'S': '24',
  '\u015A': '25', // Ś
  'T': '26', 'U': '27', 'W': '28', 'Y': '29', 'Z': '30',
  '\u0179': '31', // Ź
  '\u017B': '32', // Ż
});

const Alphabet alphabetGreek1 = Alphabet(key: 'alphabet_name_greek1', type: AlphabetType.STANDARD, alphabet: {
  '\u0391': '1', // Α
  '\u0392': '2', // Β
  '\u0393': '3', // Γ
  '\u0394': '4', // Δ
  '\u0395': '5', // Ε
  '\u0396': '6', // Ζ
  '\u0397': '7', // Η
  '\u0398': '8', // Θ
  '\u0399': '9', // Ι
  '\u039A': '10', // Κ
  '\u039B': '11', // Λ
  '\u039C': '12', // Μ
  '\u039D': '13', // Ν
  '\u039E': '14', // Ξ
  '\u039F': '15', // Ο
  '\u03A0': '16', // Π
  '\u03A1': '17', // Ρ
  '\u03A2': '18', // Σ
  '\u03A3': '19', // Τ
  '\u03A4': '20', // Υ
  '\u03A5': '21', // Φ
  '\u03A6': '22', // Χ
  '\u03A7': '23', // Ψ
  '\u03A8': '24', // Ω
});

const Alphabet alphabetGreek2 = Alphabet(key: 'alphabet_name_greek2', type: AlphabetType.STANDARD, alphabet: {
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

const Alphabet alphabetRussian1 = Alphabet(key: 'common_language_russian', type: AlphabetType.STANDARD, alphabet: {
  '\u0410': '1', // А
  '\u0411': '2', // Б
  '\u0412': '3', // В
  '\u0413': '4', // Г
  '\u0414': '5', // Д
  '\u0415': '6', // Е
  '\u0401': '7', // Ё
  '\u0416': '8', // Ж
  '\u0417': '9', // З
  '\u0418': '10', // И
  '\u0419': '11', // Й
  '\u041A': '12', // К
  '\u041B': '13', // Л
  '\u041C': '14', // М
  '\u041D': '15', // Н
  '\u041E': '16', // О
  '\u041F': '17', // П
  '\u0420': '18', // Р
  '\u0421': '19', // С
  '\u0422': '20', // Т
  '\u0423': '21', // У
  '\u0424': '22', // Ф
  '\u0425': '23', // Х
  '\u0426': '24', // Ц
  '\u0427': '25', // Ч
  '\u0428': '26', // Ш
  '\u0429': '27', // Щ
  '\u042A': '28', // Ъ
  '\u042B': '29', // Ы
  '\u042C': '30', // Ь
  '\u042D': '31', // Э
  '\u042E': '32', // Ю
  '\u042F': '33', // Я
});

final List<Alphabet> ALL_ALPHABETS = [
  alphabetAZ,
  alphabetGerman1,
  alphabetGerman2,
  alphabetGerman3,
  alphabetDanish,
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

const letterFrequencyAlphabetGerman1 = {
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
const letterFrequencyAlphabetDanish = {
  // https://www.sttmedia.de/buchstabenhaeufigkeit-daenisch
  'A': 6,
  'Å': 1,
  'Æ': 1,
  'B': 2,
  'C': 1,
  'D': 7,
  'E': 16,
  'F': 2,
  'G': 5,
  'H': 2,
  'I': 6,
  'J': 1,
  'K': 3,
  'L': 5,
  'M': 3,
  'N': 7,
  'O': 4,
  'Ø': 1,
  'P': 1,
  'Q': 1,
  'R': 8,
  'S': 5,
  'T': 7,
  'U': 24,
  'V': 3,
  'W': 1,
  'X': 1,
  'Y': 1,
  'Z': 1
};
const letterFrequencyAlphabetEnglish1 = {
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
const letterFrequencyAlphabetSpanish2 = {
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
const letterFrequencyAlphabetRussian1 = {
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
const letterFrequencyAlphabetPolish1 = {
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
const letterFrequencyAlphabetGreek1 = {
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
const letterFrequencyAlphabetGreek2 = {
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
  if (alphabet == alphabetDanish) return letterFrequencyAlphabetDanish;
  if (alphabet == alphabetEnglish) return letterFrequencyAlphabetEnglish1;
  if (alphabet == alphabetSpanish2) return letterFrequencyAlphabetSpanish2;
  if (alphabet == alphabetPolish1) return letterFrequencyAlphabetPolish1;
  if (alphabet == alphabetGreek1) return letterFrequencyAlphabetGreek1;
  if (alphabet == alphabetGreek2) return letterFrequencyAlphabetGreek2;
  if (alphabet == alphabetRussian1) return letterFrequencyAlphabetRussian1;

  throw Exception('No letter frequency found');
}
