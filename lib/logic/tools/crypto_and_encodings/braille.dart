import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
// https://www.pharmabraille.com/wp-content/uploads/2014/11/World-Braille-Usage-Third-Edition-1.pdf
// - English   p. 175 ff
// - French    p. 180 ff
// - German    p. 182 ff

// https://de.wikipedia.org/wiki/Brailleschrift
// https://www.pharmabraille.com/wp-content/uploads/2015/01/system_d_blindenschrift_7620.pdf

// https://en.wikipedia.org/wiki/Braille
// https://en.wikipedia.org/wiki/English_Braille
// http://www.acb.org/tennessee/braille.html
// https://www.pharmabraille.com/wp-content/uploads/2015/11/Rules-of-Unified-English-Braille-2013.pdf

// https://fr.wikipedia.org/wiki/Braille
// https://www.pharmabraille.com/wp-content/uploads/2015/01/CBFU_edition_internationale.pdf
// https://www.rnib.org.uk/sites/default/files/using_the_braille_french_code_2007_tc20909.pdf
// https://chezdom.net/wp-content/uploads/2008/07/notation_mathematique_braille2.pdf

// http://www.braille.ch/index.html#computer

// Examples
// DEU GC1WPAE Braille https://www.geocaching.com/geocache/GC1WPAE_braille
// DEU GC1N24V Code Braille https://www.geocaching.com/geocache/GC1N24V_code-braille
// NLD GC5PZ8Z Braille https://www.geocaching.com/geocache/GC5PZ8Z_braille
// USA GC5X6C8 Braille Numbers https://www.geocaching.com/geocache/GC5X6C8_braille-numbers
// USA GC7QK85 (Braille Cube)³ https://www.geocaching.com/geocache/GC7QK85_braille-cube
// DEU GC73VZK Den findet man auch blind (reloaded) https://www.geocaching.com/geocache/GC73VZK_den-findet-man-auch-blind-reloaded
// BEL GC1AGDX Braille https://www.geocaching.com/geocache/GC1AGDX_braille#
// FRA GC4QBNA Bonus Braille 4 https://www.geocaching.com/geocache/GC4QBNA_bonus-braille-4
// FRA GC4QBHW Bonus Braille 3 https://www.geocaching.com/geocache/GC4QBHW
// FRA GC4QBHK Bonus Braille 2 https://www.geocaching.com/geocache/GC4QBHK
// FRA GC4QBHC Bonus Braille 1 https://www.geocaching.com/geocache/GC4QBHC

enum BrailleLanguage { BASIC, SIMPLE, STD, DEU, ENG, FRA, EUR }

Map<BrailleLanguage, Map<String, String>> BRAILLE_LANGUAGES = {
  BrailleLanguage.SIMPLE: {'title': 'braille_language_simple', 'subtitle': 'braille_language_simple_description'},
  BrailleLanguage.DEU: {'title': 'common_language_german', 'subtitle': 'braille_language_german_description'},
  BrailleLanguage.ENG: {'title': 'common_language_english', 'subtitle': 'braille_language_english_description'},
  BrailleLanguage.FRA: {'title': 'common_language_french', 'subtitle': 'braille_language_french_description'},
  BrailleLanguage.EUR: {'title': 'braille_language_euro'},
};

final Map<BrailleLanguage, Map<String, List<String>>> _CharsToSegmentsLetters = {
  BrailleLanguage.STD: {
    ' ': [],
    'a': ['1'],
    'b': ['1', '2'],
    'c': ['1', '4'],
    'd': ['1', '4', '5'],
    'e': ['1', '5'],
    'f': ['1', '2', '4'],
    'g': ['1', '2', '4', '5'],
    'h': ['1', '2', '5'],
    'i': ['2', '4'],
    'j': ['2', '4', '5'],
    'k': ['1', '3'],
    'l': ['1', '2', '3'],
    'm': ['1', '3', '4'],
    'n': ['1', '3', '4', '5'],
    'o': ['1', '3', '5'],
    'p': ['1', '2', '3', '4'],
    'q': ['1', '2', '3', '4', '5'],
    'r': ['1', '2', '3', '5'],
    's': ['2', '3', '4'],
    't': ['2', '3', '4', '5'],
    'u': ['1', '3', '6'],
    'v': ['1', '2', '3', '6'],
    'w': ['2', '4', '5', '6'],
    'x': ['1', '3', '4', '6'],
    'y': ['1', '3', '4', '5', '6'],
    'z': ['1', '3', '5', '6'],
  },
  BrailleLanguage.DEU: {
    'ä': ['3', '4', '5'],
    'ö': ['2', '4', '6'],
    'ü': ['1', '2', '5', '6'],
    'ß': ['2', '3', '4', '6'],
    'au': ['1', '6'],
    'eu': ['1', '2', '6'],
    'ei': ['1', '4', '6'],
    'ch': ['1', '4', '5', '6'],
    'sch': ['1', '5', '6'],
    'st': ['2', '3', '4', '5', '6'],
    'äu': ['3', '4'],
    'ie': ['3', '4', '6'],
  },
  BrailleLanguage.ENG: {
    // strong contractions - 10.3
    'and': ['1', '2', '3', '4', '6'],
    'for': ['1', '2', '3', '4', '5', '6'],
    'of': ['1', '2', '3', '5', '6'],
    'the': ['2', '3', '4', '6'],
    'with': ['2', '3', '4', '5', '6'],
    // strong groupsigns - 10.4
    'ch': ['1', '6'],
    'gh': ['1', '2', '6'],
    'sh': ['1', '4', '6'],
    'th': ['1', '4', '5', '6'],
    'wh': ['1', '5', '6'],
    'ed': ['1', '2', '4', '6'],
    'er': ['1', '2', '4', '5', '6'],
    'ou': ['1', '2', '5', '6'],
    'ow': ['2', '4', '6'],
    'st': ['3', '4'], //    or /
    'ing': ['3', '4', '6'],
    'ar': ['3', '4', '5'],
    // lower groupsigns
    'ea': ['2'],
    'bb': ['2', '3'],
    'cc': ['2', '5'],
    'ff': ['2', '3', '5'],
    'gg': ['2', '3', '5', '6'],
    'en': ['2', '6'],
    'in': ['3', '5'],
  },
  BrailleLanguage.FRA: {
    'à': ['1', '2', '3', '5', '6'],
    'â': ['1', '6'],
    'ç': ['1', '2', '3', '4', '6'],
    'è': ['2', '3', '4', '6'],
    'é': ['1', '2', '3', '4', '5', '6'],
    'ê': ['1', '2', '6'],
    'ë': ['1', '2', '4', '6'],
    'î': ['1', '4', '6'],
    'ï': ['1', '2', '4', '5', '6'],
    'ô': ['1', '4', '5', '6'],
    'œ': ['2', '4', '6'],
    'ù': ['2', '3', '4', '5', '6'],
    'û': ['1', '5', '6'],
    'ü': ['1', '2', '5', '6'],
  }
};

final Map<BrailleLanguage, Map<String, List<String>>> _CharsToSegmentsSymbols = {
  BrailleLanguage.STD: {
    ',': ['2'],
    ';': ['2', '3'],
    ':': ['2', '5'],
    '-': ['3', '6'],
  },
  BrailleLanguage.DEU: {
    '?': ['2', '6'],
    '!': ['2', '3', '5'],
    '(': ['2', '3', '5', '6'],
    ')': ['2', '3', '5', '6'],
    '„': ['2', '3', '6'],
    '“': ['3', '5', '6'],
    '.': ['3'],
    "'": ['6'],
    '§': ['3', '4', '6'],
  },
  BrailleLanguage.ENG: {
    '.': ['2', '5', '6'],
    '?': ['2', '3', '6'],
    '!': ['2', '3', '5'],
    "'": ['3'],
  },
  BrailleLanguage.FRA: {
    '.': ['2', '5', '6'],
    '?': ['2', '6'],
    '!': ['2', '3', '5'],
    '(': ['2', '3', '6'],
    ')': ['3', '5', '6'],
    '"': ['2', '3', '5', '6'],
    '«': ['2', '3', '5', '6'],
    '»': ['2', '3', '5', '6'],
    '“': ['2', '3', '5', '6'],
    '”': ['2', '3', '5', '6'],
    '‘': ['2', '3', '5', '6'],
    '’': ['2', '3', '5', '6'],
    "'": ['3'],
    '/': ['3', '4'],
    '@': ['3', '4', '5'],
  }
};

final _MODIFIER_4 = ['4'];
final _MODIFIER_5 = ['5'];
final _MODIFIER_6 = ['6'];
final _MODIFIER_45 = ['4', '5'];
final _MODIFIER_46 = ['4', '6'];
final _MODIFIER_56 = ['5', '6'];
final _MODIFIER_345 = ['3', '4', '5'];
final _MODIFIER_356 = ['3', '5', '6'];
final _MODIFIER_456 = ['4', '5', '6'];
final _MODIFIER_3456 = ['3', '4', '5', '6']; // Number follows

final Map<BrailleLanguage, List<String>> _Modifier = {
  BrailleLanguage.DEU: [
    _MODIFIER_4.join(''),
    _MODIFIER_5.join(''),
    _MODIFIER_6.join(''),
    _MODIFIER_456.join(''),
    _MODIFIER_3456.join('')
  ],
  BrailleLanguage.ENG: [
    _MODIFIER_4.join(''),
    _MODIFIER_5.join(''),
    _MODIFIER_6.join(''),
    _MODIFIER_45.join(''),
    _MODIFIER_46.join(''),
    _MODIFIER_345.join(''),
    _MODIFIER_456.join(''),
  ],
  BrailleLanguage.FRA: [
    _MODIFIER_5.join(''),
    _MODIFIER_6.join(''),
    _MODIFIER_45.join(''),
    _MODIFIER_56.join(''),
    _MODIFIER_356.join(''),
  ]
};

final Map<BrailleLanguage, Map<String, List<String>>> _CharsToSegmentsModifier = {
  BrailleLanguage.DEU: {
    _MODIFIER_4.join(''): ['4'],
    _MODIFIER_5.join(''): ['5'],
    _MODIFIER_6.join(''): ['6'],
    _MODIFIER_456.join(''): ['4', '5', '6'],
    _MODIFIER_3456.join(''): ['3', '4', '5', '6']
  },
  BrailleLanguage.ENG: {
    _MODIFIER_4.join(''): ['4'],
    _MODIFIER_5.join(''): ['5'],
    _MODIFIER_6.join(''): ['6'],
    _MODIFIER_45.join(''): ['4', '5'],
    _MODIFIER_46.join(''): ['4', '6'],
    _MODIFIER_345.join(''): ['3', '4', '5'],
    _MODIFIER_456.join(''): ['4', '5', '6'],
  },
  BrailleLanguage.FRA: {
    _MODIFIER_5.join(''): ['5'],
    _MODIFIER_6.join(''): ['6'],
    _MODIFIER_45.join(''): ['4', '5'],
    _MODIFIER_356.join(''): ['3', '5', '6'],
  },
};
final Map<BrailleLanguage, Map<String, List<List<String>>>> _CharsToSegmentsSymbolsComposed = {
  BrailleLanguage.DEU: {
    '[': [
      _MODIFIER_6,
      ['2', '3', '5', '6']
    ],
    ']': [
      _MODIFIER_6,
      ['2', '3', '5', '6']
    ],
    '@': [
      _MODIFIER_4,
      ['3', '4', '5']
    ],
    '°': [
      _MODIFIER_4,
      ['3', '5', '6']
    ],
    '_': [
      _MODIFIER_4,
      ['4', '5', '6']
    ],
    '"': [
      _MODIFIER_4,
      ['3', '5'],
      ['3', '5']
    ],
    '&': [
      _MODIFIER_5,
      ['1', '3', '6']
    ],
    '/': [
      _MODIFIER_5,
      ['2']
    ],
    '|': [
      _MODIFIER_456,
      ['1', '2', '3']
    ],
    '\\': [
      _MODIFIER_4,
      ['3', '4']
    ],
    '%': [
      _MODIFIER_3456,
      ['2', '4', '5'],
      ['3', '5', '6']
    ],
    '+': [
      _MODIFIER_4,
      ['2', '3', '5']
    ],
    '=': [
      _MODIFIER_4,
      ['2', '3', '5', '6']
    ],
    '<': [
      _MODIFIER_4,
      ['2', '4', '6'],
      ['3']
    ],
    '>': [
      _MODIFIER_4,
      ['1', '3', '5'],
      ['2']
    ],
    '^': [
      _MODIFIER_4,
      ['3', '4', '6']
    ],
    '*': [
      _MODIFIER_4,
      ['3', '4', '6']
    ],
    '÷': [
      _MODIFIER_4,
      ['3', '5']
    ],
    '×': [
      _MODIFIER_4,
      ['2', '5'],
      ['2', '5']
    ],
    '‰': [
      _MODIFIER_3456,
      ['2', '4', '5'],
      ['3', '5', '6'],
      ['3', '5', '6']
    ],
  },
  BrailleLanguage.ENG: {
    '§': [
      _MODIFIER_45,
      ['2', '3', '4']
    ],
    '@': [
      _MODIFIER_4,
      ['1']
    ],
    '°': [
      _MODIFIER_45,
      ['2', '4', '5']
    ],
    '&': [
      _MODIFIER_4,
      ['1', '2', '3', '4', '6']
    ],
    '/': [
      _MODIFIER_456,
      ['3', '4']
    ],
    '|': [
      _MODIFIER_456,
      ['1', '2', '5', '6']
    ],
    '"': [
      _MODIFIER_6,
      ['2', '3', '5', '6']
    ],
    '%': [
      _MODIFIER_46,
      ['3', '5', '6']
    ],
    '_': [
      _MODIFIER_46,
      ['3', '6']
    ],
    '\\': [
      _MODIFIER_345,
      ['1', '6']
    ],
    '#': [
      _MODIFIER_456,
      ['1', '4', '5', '6']
    ],
    '~': [
      _MODIFIER_4,
      ['3', '5']
    ],
    '[': [
      _MODIFIER_46,
      ['1', '2', '6']
    ],
    ']': [
      _MODIFIER_46,
      ['3', '4', '5']
    ],
    '{': [
      _MODIFIER_46,
      ['1', '2', '6']
    ],
    '}': [
      _MODIFIER_456,
      ['3', '4', '5']
    ],
    '(': [
      _MODIFIER_5,
      ['1', '2', '6']
    ],
    ')': [
      _MODIFIER_5,
      ['3', '4', '5']
    ],
    '„': [
      _MODIFIER_45,
      ['2', '3', '6']
    ],
    '“': [
      _MODIFIER_45,
      ['3', '5', '6']
    ],
    '«': [
      _MODIFIER_456,
      ['3', '5', '6']
    ],
    '»': [
      _MODIFIER_456,
      ['2', '3', '6']
    ],
    '‘': [
      _MODIFIER_6,
      ['2', '3', '6']
    ],
    '’': [
      _MODIFIER_6,
      ['3', '5', '6']
    ],
    '+': [
      _MODIFIER_5,
      ['2', '3', '5']
    ],
    '=': [
      _MODIFIER_5,
      ['2', '3', '5', '6']
    ],
    '<': [
      _MODIFIER_4,
      ['1', '2', '6']
    ],
    '>': [
      _MODIFIER_4,
      ['3', '4', '5']
    ],
    '^': [
      _MODIFIER_4,
      ['2', '6']
    ],
    '*': [
      _MODIFIER_5,
      ['3', '5']
    ],
    '÷': [
      _MODIFIER_5,
      ['3', '4']
    ],
    '×': [
      _MODIFIER_5,
      ['2', '3', '6']
    ],
  },
  BrailleLanguage.FRA: {
    '[': [
      _MODIFIER_45,
      ['2', '3', '6']
    ],
    ']': [
      _MODIFIER_356,
      ['1', '2']
    ],
    '{': [
      _MODIFIER_6,
      ['6'],
      ['2', '3', '6']
    ],
    '}': [
      _MODIFIER_356,
      ['3'],
      ['3']
    ],
    '§': [
      _MODIFIER_5,
      ['1', '2', '3', '4', '5', '6']
    ],
    '°': [
      _MODIFIER_5,
      ['1', '3', '5']
    ],
    '%': [
      _MODIFIER_5,
      ['3', '4', '6']
    ],
    '_': [
      _MODIFIER_5,
      ['3', '6']
    ],
    '\\': [
      _MODIFIER_5,
      ['3', '4']
    ],
    '#': [
      _MODIFIER_5,
      ['3', '4', '5', '6']
    ],
    '~': [
      _MODIFIER_5,
      ['2', '6']
    ],
    '+': [
      _MODIFIER_6,
      ['2', '3', '5']
    ],
    '=': [
      _MODIFIER_6,
      ['2', '3', '5', '6']
    ],
    '<': [
      _MODIFIER_5,
      ['1', '2', '6']
    ],
    '>': [
      _MODIFIER_5,
      ['3', '4', '5']
    ],
    '*': [
      _MODIFIER_5,
      ['3', '5']
    ],
    '÷': [
      _MODIFIER_6,
      ['2', '5']
    ],
    '×': [
      _MODIFIER_6,
      ['3', '5']
    ],
    '‰': [
      _MODIFIER_5,
      ['3', '4', '6'],
      ['3', '4', '6']
    ],
  },
};

final Map<BrailleLanguage, List<String>> _CharsetSymbolsComposed = {
  BrailleLanguage.DEU: [
    '[',
    ']',
    '@',
    '°',
    '&',
    '/',
    '|',
    '\\',
    '_',
    '%',
    '"',
    '+',
    '=',
    '<',
    '>',
    '^',
    '*',
    '÷',
    '×',
    '‰'
  ],
  BrailleLanguage.ENG: [
    '(',
    ')',
    '[',
    ']',
    '{',
    '}',
    '„',
    '“',
    '«',
    '»',
    '‘',
    '’',
    '§',
    '@',
    '°',
    '&',
    '/',
    '|',
    '"',
    '%',
    '_',
    '\\',
    '#',
    '~',
    '+',
    '=',
    '<',
    '>',
    '^',
    '*',
    '÷',
    '×'
  ],
  BrailleLanguage.FRA: ['[', ']', '{', '}', '§', '°', '%', '_', '\\', '#', '~', '+', '=', '<', '>', '*', '÷', '×', '‰'],
};

final Map<String, List<String>> _charsToSegmentsDigits = {
  '1': ['1'],
  '2': ['1', '2'],
  '3': ['1', '4'],
  '4': ['1', '4', '5'],
  '5': ['1', '5'],
  '6': ['1', '2', '4'],
  '7': ['1', '2', '4', '5'],
  '8': ['1', '2', '5'],
  '9': ['2', '4'],
  '0': ['2', '4', '5'],
};

final Map<String, List<String>> _charsToSegmentsAntoine = {
  '1': ['1', '6'],
  '2': ['1', '2', '6'],
  '3': ['1', '4', '6'],
  '4': ['1', '4', '5', '6'],
  '5': ['1', '5', '6'],
  '6': ['1', '2', '4', '6'],
  '7': ['1', '2', '4', '5', '6'],
  '8': ['1', '2', '5', '6'],
  '9': ['2', '4', '6'],
  '0': ['3', '4', '5', '6'],
};

final SWITCH_NUMBERFOLLOWS = ['3', '4', '5', '6'];
final SWITCH_ANTOINE = ['6'];
final SWITCH_LETTERFOLLOWS = ['6'];

final Map<BrailleLanguage, List<String>> _Switches = {
  BrailleLanguage.DEU: [
    'ONECAPITALFOLLOWS',
    'CAPITALFOLLOWS',
    'SMALLLETTERFOLLOWS',
    'NUMBERFOLLOWS',
  ],
  BrailleLanguage.ENG: [
    'CAPITALS',
    'NUMBERFOLLOWS',
  ],
  BrailleLanguage.FRA: ['CAPITALS', 'NUMBERFOLLOWS', 'ANTOINENUMBERFOLLOWS', 'BASE'],
};

final Map<BrailleLanguage, Map<String, List<String>>> _CharsToSegmentsSwitches = {
  BrailleLanguage.DEU: {
    'ONECAPITALFOLLOWS': ['4', '6'],
    'CAPITALFOLLOWS': ['4', '5'],
    'SMALLLETTERFOLLOWS': ['6'],
    'NUMBERFOLLOWS': ['3', '4', '5', '6'],
  },
  BrailleLanguage.ENG: {
    'CAPITALS': ['6'],
    'NUMBERFOLLOWS': ['3', '4', '5', '6'],
  },
  BrailleLanguage.FRA: {
    'CAPITALS': ['4', '6'],
    'NUMBERFOLLOWS': ['3', '4', '5', '6'],
    'ANTOINENUMBERFOLLOWS': ['6'],
    'BASE': ['5', '6']
  },
};

final Map<String, List<String>> _charsToSegmentsLettersAntoine = {
  'â': ['1', '6'], // 1
  'ê': ['1', '2', '6'], // 2
  'î': ['1', '4', '6'], // 3
  'ô': ['1', '4', '5', '6'], // 4
  'û': ['1', '5', '6'], // 5
  'ë': ['1', '2', '4', '6'], // 6
  'ï': ['1', '2', '4', '5', '6'], // 7
  'ü': ['1', '2', '5', '6'], // 8
  'œ': ['2', '4', '6'], // 9
  'NUMBERFOLLOWS': ['3', '4', '5', '6'], // 0
};

final Map<String, List<String>> _charsToSegmentsEUR = {
  // http://fakoo.de/braille/computerbraille-text.html
  'NUL': ['3', '4', '5', '7', '8'],
  'SOH': ['1', '7', '8'],
  'STX': ['1', '2', '7', '8'],
  'ETX': ['1', '4', '7', '8'],
  'EOT': ['1', '4', '5', '7', '8'],
  'ENQ': ['1', '5', '7', '8'],
  'ACK': ['1', '2', '4', '7', '8'],
  'BEL': ['1', '2', '4', '5', '7', '8'],
  'BS': ['1', '2', '5', '7', '8'],
  'HT': ['2', '4', '7', '8'],
  'LF': ['2', '4', '5', '7', '8'],
  'VT': ['1', '3', '7', '8'],
  'FF': ['1', '2', '3', '7', '8'],
  'CR': ['1', '3', '4', '7', '8'],
  'SO': ['1', '3', '4', '5', '7', '8'],
  'SI': ['1', '3', '5', '7', '8'],
  'DLE': ['1', '2', '3', '4', '7', '8'],
  'DC1': ['1', '2', '3', '4', '5', '7', '8'],
  'DC2': ['1', '2', '3', '5', '7', '8'],
  'DC3': ['2', '3', '4', '7', '8'],
  'DC4': ['2', '3', '4', '5', '7', '8'],
  'NAK': ['1', '3', '6', '7', '8'],
  'SYN': ['1', '2', '3', '6', '7', '8'],
  'ETB': ['2', '4', '5', '6', '7', '8'],
  'CAN': ['1', '3', '4', '6', '7', '8'],
  'EM': ['1', '3', '4', '5', '6', '7', '8'],
  'SUB': ['1', '3', '5', '6', '7', '8'],
  'ESC': ['1', '2', '3', '5', '6', '7', '8'],
  'FS': ['3', '4', '7', '8'],
  'GS': ['2', '3', '4', '5', '6', '7', '8'],
  'RS': ['2', '3', '4', '6', '7', '8'],
  'US': ['4', '5', '6', '7', '8'],
  ' ': [],
  '!': ['5'],
  '"': ['4'],
  '#': ['3', '4', '5', '6'],
  '\$': ['4', '6'],
  '%': ['1', '2', '3', '4', '5', '6'],
  '&': ['1', '2', '3', '4', '6'],
  "'": ['6'],
  '(': ['2', '3', '6'],
  ')': ['3', '5', '6'],
  '*': ['3', '5'],
  '+': ['2', '3', '5'],
  ',': ['2'],
  '-': ['3', '6'],
  '.': ['3'],
  '/': ['2', '5', '6'],
  '0': ['3', '4', '6'],
  '1': ['1', '6'],
  '2': ['1', '2', '6'],
  '3': ['1', '4', '6'],
  '4': ['1', '4', '5', '6'],
  '5': ['1', '5', '6'],
  '6': ['1', '2', '4', '6'],
  '7': ['1', '2', '4', '5', '6'],
  '8': ['1', '2', '5', '6'],
  '9': ['2', '4', '6'],
  ':': ['2', '5'],
  ';': ['2', '3'],
  '<': ['5', '6'],
  '=': ['2', '3', '5', '6'],
  '>': ['4', '5'],
  '?': ['2', '6'],
  '@': ['3', '4', '5', '7'],
  'A': ['1', '7'],
  'B': ['1', '2', '7'],
  'C': ['1', '4', '7'],
  'D': ['1', '4', '5', '7'],
  'E': ['1', '5', '7'],
  'F': ['1', '4', '2', '7'],
  'G': ['1', '4', '2', '5', '7'],
  'H': ['1', '2', '5', '7'],
  'I': ['4', '2', '7'],
  'J': ['4', '2', '5', '7'],
  'K': ['1', '3', '7'],
  'L': ['1', '2', '3', '7'],
  'M': ['1', '4', '3', '7'],
  'N': ['1', '4', '5', '3', '7'],
  'O': ['1', '5', '3', '7'],
  'P': ['1', '4', '2', '3', '7'],
  'Q': ['1', '4', '2', '5', '3', '7'],
  'R': ['1', '2', '5', '3', '7'],
  'S': ['4', '2', '3', '7'],
  'T': ['4', '2', '5', '3', '7'],
  'U': ['1', '3', '6', '7'],
  'V': ['1', '2', '3', '3', '7'],
  'W': ['4', '2', '5', '6', '7'],
  'X': ['1', '4', '3', '6', '7'],
  'Y': ['1', '4', '5', '3', '6', '7'],
  'Z': ['1', '5', '3', '6', '7'],
  '[': ['1', '2', '3', '5', '6', '7'],
  '\\': ['3', '4', '7'],
  ']': ['2', '3', '4', '5', '6', '7'],
  '^': ['2', '3', '4', '6', '7'],
  '_': ['4', '5', '6', '7'],
  '`': ['3', '4', '5'],
  'a': ['1'],
  'b': ['1', '2'],
  'c': ['1', '4'],
  'd': ['1', '4', '5'],
  'e': ['1', '5'],
  'f': ['1', '2', '4'],
  'g': ['1', '2', '4', '5'],
  'h': ['1', '2', '5'],
  'i': ['2', '4'],
  'j': ['2', '4', '5'],
  'k': ['1', '3'],
  'l': ['1', '2', '3'],
  'm': ['1', '3', '4'],
  'n': ['1', '3', '4', '5'],
  'o': ['1', '3', '5'],
  'p': ['1', '2', '3', '4'],
  'q': ['1', '2', '3', '4', '5'],
  'r': ['1', '2', '3', '5'],
  's': ['2', '3', '4'],
  't': ['2', '3', '4', '5'],
  'u': ['1', '3', '6'],
  'v': ['1', '2', '3', '3'],
  'w': ['2', '4', '5', '6'],
  'x': ['1', '3', '4', '6'],
  'y': ['1', '3', '4', '5', '6'],
  'z': ['1', '3', '5', '6'],
  '{': ['1', '2', '3', '5', '6'],
  '|': ['3', '4'],
  '}': ['2', '3', '4', '5', '6'],
  '~': ['2', '3', '4', '6'],
  'DEL': ['4', '5', '6'],
  '€': ['4', '5', '7'],
  'HOP': ['8'],
  '‚': ['3', '6', '7', '8'],
  'ƒ': ['7', '8'],
  '„': ['1', '2', '3', '4', '5', '6', '7'],
  '…': ['1', '2', '3', '4', '5', '6', '8'],
  '†': ['1', '2', '4', '8'],
  '‡': ['1', '2', '4', '5', '8'],
  'ˆ': ['3', '7', '8'],
  '‰': ['2', '4', '8'],
  'Š': ['6', '7', '8'],
  '‹': ['2', '7'],
  'Œ': ['2', '3', '7'],
  'RI': ['2', '5', '7'],
  'Ž': ['1', '2', '5', '6', '7'],
  'SS3': ['1', '2', '4', '6', '7'],
  'DCS': ['1', '2', '4', '6', '7', '8'],
  '‘': ['2', '3', '5', '6', '7'],
  '’': ['2', '3', '6', '7'],
  '“': ['1', '3', '8'],
  '”': ['1', '2', '3', '8'],
  '•': ['2', '7', '8'],
  '–': ['2', '3', '7', '8'],
  '—': ['1', '3', '5', '6', '8'],
  'SOS': ['2', '5', '7', '8'],
  '™': ['1', '2', '4', '5', '6', '7', '8'],
  'š': ['2', '6', '7', '8'],
  '›': ['1', '2', '3', '4', '5', '8'],
  'œ': ['6', '7'],
  'OSC': ['1', '2', '4', '5', '6', '7'],
  'ž': ['2', '3', '5', '6', '7', '8'],
  'Ÿ': ['1', '2', '3', '4', '5', '6', '7', '8'],
  ' ': ['7'],
  '¡': ['3', '6', '7'],
  '¢': ['5', '8'],
  '£': ['4', '6', '7'],
  '¤': ['4', '6', '7', '8'],
  '¥': ['4', '6', '8'],
  '¦': ['1', '5', '8'],
  '§': ['3', '5', '7'],
  '¨': ['4', '8'],
  '©': ['1', '2', '3', '4', '6', '8'],
  'ª': ['1', '2', '5', '8'],
  '«': ['5', '6', '7', '8'],
  '¬': ['2', '5', '6', '7', '8'],
  //'': [],
  '®': ['1', '2', '3', '5', '8'],
  '¯': ['4', '5', '8'],
  '°': ['4', '5', '6', '8'],
  '±': ['2', '3', '5', '7', '8'],
  '²': ['1', '2', '8'],
  '³': ['1', '4', '8'],
  '´': ['5', '6', '8'],
  'µ': ['1', '3', '4', '8'],
  '¶': ['1', '4', '5', '8'],
  '·': ['3', '7'],
  '¸': ['6', '8'],
  '¹': ['1', '8'],
  'º': ['2', '4', '5', '8'],
  '»': ['4', '5', '7', '8'],
  '¼': ['1', '3', '6', '8'],
  '½': ['1', '2', '3', '6', '8'],
  '¾': ['1', '3', '4', '6', '8'],
  '¿': ['3', '8'],
  'À': ['2', '3', '6', '7', '8'],
  'Á': ['2', '8'],
  'Â': ['1', '6', '7'],
  'Ã': ['3', '4', '6', '7'],
  'Ä': ['5', '6', '7'],
  'Å': ['3', '4', '5', '6', '7'],
  'Æ': ['4', '7'],
  'Ç': ['1', '2', '3', '4', '6', '7'],
  'È': ['3', '5', '7', '8'],
  'É': ['2', '3', '8'],
  'Ê': ['1', '2', '6', '7'],
  'Ë': ['2', '3', '5', '8'],
  'Ì': ['5', '7'],
  'Í': ['2', '5', '8'],
  'Î': ['1', '4', '6', '7'],
  'Ï': ['2', '3', '5', '6', '8'],
  'Ð': ['3', '5', '6', '7'],
  'Ñ': ['2', '5', '6', '7'],
  'Ò': ['5', '7', '8'],
  'Ó': ['2', '5', '6', '8'],
  'Ô': ['1', '4', '5', '6', '7'],
  'Õ': ['2', '6', '7'],
  'Ö': ['3', '5', '8'],
  '×': ['2', '3', '4', '8'],
  'Ø': ['2', '4', '6', '7'],
  'Ù': ['3', '5', '6', '7', '8'],
  'Ú': ['2', '6', '8'],
  'Û': ['1', '5', '6', '7'],
  'Ü': ['2', '3', '6', '8'],
  'Ý': ['3', '5', '6', '8'],
  'Þ': ['2', '3', '5', '7'],
  'ß': ['3', '4', '5', '6', '8'],
  'à': ['1', '2', '3', '5', '6', '8'],
  'á': ['1', '6', '8'],
  'â': ['1', '6', '7', '8'],
  'ã': ['3', '4', '6', '7', '8'],
  'ä': ['3', '4', '5', '8'],
  'å': ['3', '4', '5', '6', '7', '8'],
  'æ': ['4', '7', '8'],
  'ç': ['1', '2', '3', '4', '6', '7', '8'],
  'è': ['2', '3', '4', '6', '8'],
  'é': ['1', '2', '6', '8'],
  'ê': ['1', '2', '6', '7', '8'],
  'ë': ['1', '2', '4', '6', '8'],
  'ì': ['3', '4', '8'],
  'í': ['1', '4', '6', '8'],
  'î': ['1', '4', '6', '7', '8'],
  'ï': ['1', '2', '4', '5', '6', '8'],
  'ð': ['2', '3', '4', '5', '8'],
  'ñ': ['1', '3', '4', '5', '8'],
  'ò': ['3', '4', '6', '8'],
  'ó': ['1', '4', '5', '6', '8'],
  'ô': ['1', '4', '5', '6', '7', '8'],
  'õ': ['1', '3', '5', '8'],
  'ö': ['2', '4', '6', '8'],
  '÷': ['1', '2', '5', '6', '7', '8'],
  'ø': ['2', '4', '6', '7', '8'],
  'ù': ['2', '3', '4', '5', '6', '8'],
  'ú': ['1', '5', '6', '8'],
  'û': ['1', '5', '6', '7', '8'],
  'ü': ['1', '2', '5', '6', '8'],
  'ý': ['2', '4', '5', '6', '8'],
  'þ': ['1', '2', '3', '4', '8'],
  'ÿ': ['1', '3', '4', '5', '6', '8'],
};

final _Numbers = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

final _NumberLetters = {'j', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'};

final _SmallLetters = {
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'ä',
  'ö',
  'ü',
  'ß',
  'á',
  'à',
  'â',
  'ç',
  'è',
  'é',
  'ê',
  'ë',
  'î',
  'ï',
  'ô',
  'œ',
  'ù',
  'û',
};

final _CapitalLetters = {
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  'Ä',
  'Ö',
  'Ü',
  'Á',
  'À',
  'Â',
  'Ç',
  'È',
  'É',
  'Ê',
  'Ë',
  'Î',
  'Ï',
  'Ô',
  'Œ',
  'Ù',
  'Û',
};

final _AntoineLetters = {'â', 'ê', 'î', 'ô', 'û', 'ë', 'ï', 'ü', 'œ', 'NUMBERFOLLOWS'};

final Map _LetterToDigit = {
  'a': '1',
  'b': '2',
  'c': '3',
  'd': '4',
  'e': '5',
  'f': '6',
  'g': '7',
  'h': '8',
  'i': '9',
  'j': '0',
};

final Map _AntoineToDigit = {
  'â': '1',
  'ê': '2',
  'î': '3',
  'ô': '4',
  'û': '5',
  'ë': '6',
  'ï': '7',
  'ü': '8',
  'œ': '9',
  'NUMBERFOLLOWS': '0',
};

bool _isSmallLetter(String s) {
  return _SmallLetters.contains(s);
}

bool _isCapital(String s) {
  return _CapitalLetters.contains(s);
}

bool _isNumber(String s) {
  return _Numbers.contains(s);
}

bool _isNumberLetter(String s) {
  return _NumberLetters.contains(s);
}

bool _isLetter(String s) {
  return (_isCapital(s) || _isSmallLetter(s));
}

List<List<String>> _encodeBrailleSIMPLE(String input) {
  List<String> inputs = input.split('');
  List<List<String>> result = [];

  bool numberFollows = false;

  Map<String, List<String>> _charsToSegments = new Map<String, List<String>>();
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.STD]);
  _charsToSegments.addAll(_charsToSegmentsDigits);

  for (int i = 0; i < inputs.length; i++) {
    if (_isNumber(inputs[i])) {
      if (!numberFollows) {
        result.add(SWITCH_NUMBERFOLLOWS);
        numberFollows = true;
      }
    } else {
      if (_isNumberLetter(inputs[i]) && numberFollows) result.add(SWITCH_LETTERFOLLOWS);
      numberFollows = false;
    }
    if (_charsToSegments[inputs[i].toLowerCase()] != null) result.add(_charsToSegments[inputs[i].toLowerCase()]);
  }
  return result;
}

List<List<String>> _encodeBrailleDEU(String input) {
  bool stateNumberFollows = false;
  bool stateCapitals = false;

  List<String> inputs = input.split('');
  List<List<String>> result = [];

  Map<String, List<String>> _charsToSegments = new Map<String, List<String>>();
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.STD]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.STD]);
  _charsToSegments.addAll(_charsToSegmentsDigits);
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.DEU]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.DEU]);

  for (int i = 0; i < inputs.length; i++) {
    // identify composed characters
    if (_CharsetSymbolsComposed[BrailleLanguage.DEU].contains(inputs[i]))
      result.addAll(_CharsToSegmentsSymbolsComposed[BrailleLanguage.DEU][inputs[i]]);
    else if (_isNumber(inputs[i])) {
      if (!stateNumberFollows) {
        result.add(_CharsToSegmentsSwitches[BrailleLanguage.DEU]['NUMBERFOLLOWS']);
        stateNumberFollows = true;
      }
      result.add(_charsToSegments[inputs[i]]);
    } else {
      if (_isNumberLetter(inputs[i]) && stateNumberFollows) result.add(SWITCH_LETTERFOLLOWS);
      if (_isSmallLetter(inputs[i])) {
        if (stateCapitals) stateCapitals = false;
      }
      if (_isCapital(inputs[i])) {
        // check following letter
        if (i < inputs.length - 1 && _isSmallLetter(inputs[i + 1]))
          result.add(_CharsToSegmentsSwitches[BrailleLanguage.DEU]['ONECAPITALFOLLOWS']);
        else {
          result.add(_CharsToSegmentsSwitches[BrailleLanguage.DEU]['CAPITALFOLLOWS']);
          stateCapitals = true;
        }
        inputs[i] = inputs[i].toLowerCase();
      }
      if (inputs[i] == 's' && i < inputs.length - 1 && inputs[i + 1] == 't') {
        result.add(_charsToSegments['st']);
        i++;
      } else if (inputs[i] == 'a' && i < inputs.length - 1 && inputs[i + 1] == 'u') {
        result.add(_charsToSegments['au']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'u') {
        result.add(_charsToSegments['eu']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'i') {
        result.add(_charsToSegments['ei']);
        i++;
      } else if (inputs[i] == 'ä' && i < inputs.length - 1 && inputs[i + 1] == 'U') {
        result.add(_charsToSegments['äu']);
        i++;
      } else if (inputs[i] == 'i' && i < inputs.length - 1 && inputs[i + 1] == 'e') {
        result.add(_charsToSegments['ie']);
        i++;
      } else if (inputs[i] == 'c' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['ch']);
        i++;
      } else if (inputs[i] == 's' && i < inputs.length - 2 && inputs[i + 1] == 'c' && inputs[i + 2] == 'h') {
        result.add(_charsToSegments['sch']);
        i = i + 2;
      } else if (_charsToSegments[inputs[i]] != null) result.add(_charsToSegments[inputs[i]]);
    }
  }
  return result;
}

List<List<String>> _encodeBrailleENG(String input) {
  bool stateNumberFollows = false;
  bool stateCapitals = false;

  List<String> inputs = input.split('');
  List<List<String>> result = [];

  Map<String, List<String>> _charsToSegments = new Map<String, List<String>>();
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.STD]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.STD]);
  _charsToSegments.addAll(_charsToSegmentsDigits);
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.ENG]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.ENG]);

  for (int i = 0; i < inputs.length; i++) {
    // identify composed characters
    if (_CharsetSymbolsComposed[BrailleLanguage.ENG].contains(inputs[i]))
      result.addAll(_CharsToSegmentsSymbolsComposed[BrailleLanguage.ENG][inputs[i]]);
    else if (_isNumber(inputs[i])) {
      if (!stateNumberFollows) {
        result.add(SWITCH_NUMBERFOLLOWS);
        stateNumberFollows = true;
      }
      result.add(_charsToSegments[inputs[i]]);
    } else {
      if (_isSmallLetter(inputs[i])) {
        if (stateCapitals) stateCapitals = false;
      }
      if (_isCapital(inputs[i])) {
        result.add(_CharsToSegmentsSwitches[BrailleLanguage.ENG]['CAPITALS']);
        inputs[i] = inputs[i].toLowerCase();
      }
      if (inputs[i] == 'w' &&
          i < inputs.length - 3 &&
          inputs[i + 1] == 'i' &&
          inputs[i + 2] == 't' &&
          inputs[i + 3] == 'h') {
        result.add(_charsToSegments['with']);
        i = i + 3;
      } else if (inputs[i] == 't' && i < inputs.length - 2 && inputs[i + 1] == 'h' && inputs[i + 2] == 'e') {
        result.add(_charsToSegments['the']);
        i = i + 2;
      } else if (inputs[i] == 'i' && i < inputs.length - 2 && inputs[i + 1] == 'n' && inputs[i + 2] == 'g') {
        result.add(_charsToSegments['ing']);
        i = i + 2;
      } else if (inputs[i] == 's' && i < inputs.length - 2 && inputs[i + 1] == 'c' && inputs[i + 2] == 'h') {
        result.add(_charsToSegments['sch']);
        i = i + 2;
      } else if (inputs[i] == 'a' && i < inputs.length - 2 && inputs[i + 1] == 'n' && inputs[i + 2] == 'd') {
        result.add(_charsToSegments['and']);
        i = i + 2;
      } else if (inputs[i] == 'f' && i < inputs.length - 2 && inputs[i + 1] == 'o' && inputs[i + 2] == 'r') {
        result.add(_charsToSegments['for']);
        i = i + 2;
      } else if (inputs[i] == 'c' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['ch']);
        i++;
      } else if (inputs[i] == 'g' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['gh']);
        i++;
      } else if (inputs[i] == 's' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['sh']);
        i++;
      } else if (inputs[i] == 't' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['th']);
        i++;
      } else if (inputs[i] == 'w' && i < inputs.length - 1 && inputs[i + 1] == 'h') {
        result.add(_charsToSegments['wh']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'd') {
        result.add(_charsToSegments['ed']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'r') {
        result.add(_charsToSegments['er']);
        i++;
      } else if (inputs[i] == 'o' && i < inputs.length - 1 && inputs[i + 1] == 'u') {
        result.add(_charsToSegments['ou']);
        i++;
      } else if (inputs[i] == 'o' && i < inputs.length - 1 && inputs[i + 1] == 'w') {
        result.add(_charsToSegments['ow']);
        i++;
      } else if (inputs[i] == 'i' && i < inputs.length - 1 && inputs[i + 1] == 'n') {
        result.add(_charsToSegments['in']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'a') {
        result.add(_charsToSegments['ea']);
        i++;
      } else if (inputs[i] == 'b' && i < inputs.length - 1 && inputs[i + 1] == 'b') {
        result.add(_charsToSegments['bb']);
        i++;
      } else if (inputs[i] == 'c' && i < inputs.length - 1 && inputs[i + 1] == 'c') {
        result.add(_charsToSegments['cc']);
        i++;
      } else if (inputs[i] == 'd' && i < inputs.length - 1 && inputs[i + 1] == 'd') {
        result.add(_charsToSegments['dd']);
        i++;
      } else if (inputs[i] == 'e' && i < inputs.length - 1 && inputs[i + 1] == 'n') {
        result.add(_charsToSegments['en']);
        i++;
      } else if (inputs[i] == 'f' && i < inputs.length - 1 && inputs[i + 1] == 'f') {
        result.add(_charsToSegments['ff']);
        i++;
      } else if (inputs[i] == 'g' && i < inputs.length - 1 && inputs[i + 1] == 'g') {
        result.add(_charsToSegments['gg']);
        i++;
      } else if (inputs[i] == 's' && i < inputs.length - 1 && inputs[i + 1] == 't') {
        result.add(_charsToSegments['st']);
        i++;
      } else if (inputs[i] == 'a' && i < inputs.length - 1 && inputs[i + 1] == 'r') {
        result.add(_charsToSegments['ar']);
        i++;
      } else if (inputs[i] == 'o' && i < inputs.length - 1 && inputs[i + 1] == 'f') {
        result.add(_charsToSegments['of']);
        i++;
      } else if (_charsToSegments[inputs[i]] != null) result.add(_charsToSegments[inputs[i]]);
    }
  }
  return result;
}

List<List<String>> _encodeBrailleFRA(String input) {
  bool stateNumberFollows = false;
  bool stateCapitals = false;

  Map<String, List<String>> _charsToSegments = new Map<String, List<String>>();
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.STD]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.STD]);
  _charsToSegments.addAll(_charsToSegmentsDigits);
  _charsToSegments.addAll(_CharsToSegmentsLetters[BrailleLanguage.FRA]);
  _charsToSegments.addAll(_CharsToSegmentsSymbols[BrailleLanguage.FRA]);

  List<String> inputs = input.split('');
  List<List<String>> result = [];
  for (int i = 0; i < inputs.length; i++) {
    // identify composed characters
    if (_CharsetSymbolsComposed[BrailleLanguage.FRA].contains(inputs[i]))
      result.addAll(_CharsToSegmentsSymbolsComposed[BrailleLanguage.FRA][inputs[i]]);
    else if (_isNumber(inputs[i])) {
      if (!stateNumberFollows) {
        result.add(SWITCH_NUMBERFOLLOWS);
        stateNumberFollows = true;
      }
      result.add(_charsToSegments[inputs[i]]);
    } else {
      if (_isSmallLetter(inputs[i])) {
        if (stateCapitals) stateCapitals = false;
      }
      if (_isCapital(inputs[i])) {
        result.add(_CharsToSegmentsSwitches[BrailleLanguage.FRA]['CAPITALS']);
        inputs[i] = inputs[i].toLowerCase();
      }
      if (_charsToSegments[inputs[i]] != null) result.add(_charsToSegments[inputs[i]]);
    }
  }
  return result;
}

List<List<String>> _encodeBrailleEUR(String input) {
  List<String> inputs = input.split('');
  List<List<String>> result = [];

  for (int i = 0; i < inputs.length; i++) {
    result.add(_charsToSegmentsEUR[inputs[i]]);
  }
  return result;
}

List<List<String>> encodeBraille(String input, BrailleLanguage language) {
  if (input == null) return [];

  switch (language) {
    case BrailleLanguage.SIMPLE:
      return _encodeBrailleSIMPLE(input);
      break;
    case BrailleLanguage.DEU:
      return _encodeBrailleDEU(input);
      break;
    case BrailleLanguage.ENG:
      return _encodeBrailleENG(input);
      break;
    case BrailleLanguage.FRA:
      return _encodeBrailleFRA(input);
      break;
    case BrailleLanguage.EUR:
      return _encodeBrailleEUR(input);
      break;
  }
}

Map<String, dynamic> _decodeBrailleBASIC(List<String> inputs, bool letters) {
  var displays = <List<String>>[];

  var antoineMap = Map<String, List<String>>.from(_charsToSegmentsLettersAntoine);
  antoineMap.remove('NUMBERFOLLOWS');

  var _segmentsToCharsBASICBraille = switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]);
  _segmentsToCharsBASICBraille.addAll(switchMapKeyValue(antoineMap));

  List<String> text = inputs.where((input) => input != null).map((input) {
    var char = '';
    var charH = '';
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });

    if (_segmentsToCharsBASICBraille
            .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ==
        null) {
      char = char + UNKNOWN_ELEMENT;
    } else {
      charH = _segmentsToCharsBASICBraille
          .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()];
      if (letters)
        char = char + charH;
      else // digits
      if ((_LetterToDigit[charH] == null) && (_AntoineToDigit[charH] == null))
        char = char + UNKNOWN_ELEMENT;
      else if (_LetterToDigit[charH] == null)
        char = char + _AntoineToDigit[charH];
      else
        char = char + _LetterToDigit[charH];
    }

    displays.add(display);

    return char;
  }).toList();

  return {'displays': displays, 'chars': text};
}

Map<String, dynamic> _decodeBrailleSIMPLE(List<String> inputs) {
  var displays = <List<String>>[];

  Map<List<String>, String> _segmentsToCharsSIMPLEBraille = new Map<List<String>, String>();
  _segmentsToCharsSIMPLEBraille.addAll(switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]));
  _segmentsToCharsSIMPLEBraille.addAll({SWITCH_NUMBERFOLLOWS: 'NUMBERFOLLOWS'});

  Map<List<String>, String> _segmentsToCharsSIMPLEBrailleFrench = new Map<List<String>, String>();
  _segmentsToCharsSIMPLEBrailleFrench.addAll(switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]));
  _segmentsToCharsSIMPLEBrailleFrench.addAll({SWITCH_NUMBERFOLLOWS: 'NUMBERFOLLOWS'});
  _segmentsToCharsSIMPLEBrailleFrench.addAll({SWITCH_ANTOINE: 'ANTOINENUMBERFOLLOWS'});
  _segmentsToCharsSIMPLEBrailleFrench.addAll(switchMapKeyValue(_charsToSegmentsLettersAntoine));

  bool _numberFollows = false;
  bool _antoinenumberFollows = false;

  List<String> text = [];

  // decode including french chiffre antoine
  _numberFollows = false;
  _antoinenumberFollows = false;
  text = inputs.where((input) => input != null).map((input) {
    var char = '';
    var charH = '';
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });

    if (_segmentsToCharsSIMPLEBrailleFrench
            .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ==
        null)
      char = char + UNKNOWN_ELEMENT;
    else {
      charH = _segmentsToCharsSIMPLEBrailleFrench
          .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()];
      if (charH == 'NUMBERFOLLOWS') {
        char = char + '<NUMBER FOLLOWS>';
        _numberFollows = true;
      } else if (charH == 'ANTOINENUMBERFOLLOWS') {
        char = char + '<ANTOINE NUMBER FOLLOWS>';
        _antoinenumberFollows = true;
        _numberFollows = false;
      } else if (charH == ' ') {
        _numberFollows = false;
        _antoinenumberFollows = false;
        char = char + charH;
      } else {
        // no switch but char to analyze
        if (_numberFollows) {
          if (_LetterToDigit[charH] == null) {
            _numberFollows = false;
          } else {
            charH = _LetterToDigit[charH];
          }
        } else if (_antoinenumberFollows) {
          if (_AntoineToDigit[charH] == null)
            _numberFollows = false;
          else {
            charH = _AntoineToDigit[charH];
          }
        } else if (_AntoineLetters.contains(charH)) charH = UNKNOWN_ELEMENT;

        char = char + charH;
      }
    }
    displays.add(display);

    return char;
  }).toList();
  return {'displays': displays, 'chars': text};
}

Map<String, dynamic> _decodeBrailleDEU(List<String> inputs) {
  var displays = <List<String>>[];

  bool numberFollows = false;
  bool capitalFollows = false;
  bool oneCapitalFollows = false;

  String input = '';
  String charH = '';
  List<String> text = [];
  int maxLength = inputs.length;

  // Build Map for decoding
  Map<String, String> BrailleToChar = new Map<String, String>();
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.DEU]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.DEU]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSwitches[BrailleLanguage.DEU]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsModifier[BrailleLanguage.DEU]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });

  for (int i = 0; i < maxLength; i++) {
    input = inputs[i];

    // Build displays
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });
    displays.add(display);

    // Build text
    if (BrailleToChar[input] == null) {
      text.add(UNKNOWN_ELEMENT);
    } else {
      charH = BrailleToChar[input];
      if (_Modifier[BrailleLanguage.DEU].contains(input)) {
        switch (input) {
          case '4':
            if (i + 2 < maxLength) {
              if (inputs[i + 1] == '35' && inputs[i + 2] == '35') text.add('"');
              if (inputs[i + 1] == '25' && inputs[i + 2] == '25') text.add('÷');
              if (inputs[i + 1] == '246' && inputs[i + 2] == '3') text.add('<');
              if (inputs[i + 1] == '135' && inputs[i + 2] == '2') text.add('>');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;

            } else if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '235':
                  text.add('+');
                  break;
                case '2356':
                  text.add('=');
                  break;
                case '345':
                  text.add('@');
                  break;
                case '346':
                  text.add('^');
                  break;
                case '356':
                  text.add('°');
                  break;
                case '456':
                  text.add('_');
                  break;
                case '34':
                  text.add('\\');
                  break;
                case '35':
                  text.add('*');
                  break;
                case '236':
                  text.add('×');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '5':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '2':
                  text.add('/');
                  break;
                case '136':
                  text.add('&');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '6':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '2356':
                  text.add('[]');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            } else {}
            break;
          case '456':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '123':
                  text.add('|');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            if (i + 2 < maxLength && inputs[i + 1] == '3' && inputs[i + 2] == '3') {
              text.add('}');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;
            }
            break;
          case '3456':
            if (i + 3 < maxLength && inputs[i + 1] == '245' && inputs[i + 2] == '356' && inputs[i + 3] == '356') {
              text.add('‰');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 3;
            } else if (i + 2 < maxLength && inputs[i + 1] == '245' && inputs[i + 2] == '356') {
              text.add('%');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;
            } else
              numberFollows = true;
            break;
        }
      } else if (_Switches[BrailleLanguage.DEU].contains(charH)) {
        if (charH == 'ONECAPITALFOLLOWS') {
          oneCapitalFollows = true;
        } else if (charH == "CAPITALFOLLOWS") {
          capitalFollows = true;
        } else if ((charH == 'NUMBERFOLLOWS') && !numberFollows) {
          numberFollows = true;
        }
      } else if (charH == ' ') {
        numberFollows = false;
        capitalFollows = false;
        oneCapitalFollows = false;
        text.add(charH);
      } else {
        // no switch
        if (numberFollows) {
          if (charH != '.' && _LetterToDigit[charH] == null)
            numberFollows = false;
          else if (charH != '.') charH = _LetterToDigit[charH];
        } else if (oneCapitalFollows) {
          charH = charH.toUpperCase();
          oneCapitalFollows = false;
        } else if (capitalFollows) {
          charH = charH.toUpperCase();
        }
        text.add(charH);
      }
    }
  }

  return {'displays': displays, 'chars': text};
}

Map<String, dynamic> _decodeBrailleENG(List<String> inputs) {
// TO DO
  var displays = <List<String>>[];

  bool numberFollows = false;
  bool capitalFollows = false;
  bool oneCapitalFollows = false;

  String input = '';
  String charH = '';
  List<String> text = [];
  int maxLength = inputs.length;

  // Build Map for decoding
  Map<String, String> BrailleToChar = new Map<String, String>();
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.ENG]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.ENG]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSwitches[BrailleLanguage.ENG]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsModifier[BrailleLanguage.ENG]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });

  for (int i = 0; i < maxLength; i++) {
    input = inputs[i];

    // Build displays
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });
    displays.add(display);

    // Build text
    if (BrailleToChar[input] == null) {
      text.add(UNKNOWN_ELEMENT);
    } else {
      charH = BrailleToChar[input];
      if (_Modifier[BrailleLanguage.ENG].contains(input)) {
        switch (input) {
          case '4':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '1':
                  text.add('@');
                  break;
                case '35':
                  text.add('~');
                  break;
                case '12346':
                  text.add('&');
                  break;
                case '126':
                  text.add('<');
                  break;
                case '345':
                  text.add('>');
                  break;
                case '26':
                  text.add('^');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '5':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '35':
                  text.add('*');
                  break;
                case '34':
                  text.add('÷');
                  break;
                case '236':
                  text.add('×');
                  break;
                case '126':
                  text.add('(');
                  break;
                case '345':
                  text.add(')');
                  break;
                case '235':
                  text.add('+');
                  break;
                case '2356':
                  text.add('=');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '6':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '236':
                  text.add('‘');
                  break;
                case '356':
                  text.add('’');
                  break;
                case '2356':
                  text.add('"');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '45':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '236':
                  text.add('„');
                  break;
                case '356':
                  text.add('“');
                  break;
                case '234':
                  text.add('&');
                  break;
                case '245':
                  text.add('°');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '46':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '126':
                  text.add('[');
                  break;
                case '345':
                  text.add(']');
                  break;
                case '356':
                  text.add('%');
                  break;
                case '36':
                  text.add('_');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '345':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '16':
                  text.add('\\');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '456':
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '126':
                  text.add('{');
                  break;
                case '345':
                  text.add('}');
                  break;
                case '236':
                  text.add('«');
                  break;
                case '356':
                  text.add('»');
                  break;
                case '34':
                  text.add('/');
                  break;
                case '1256':
                  text.add('|');
                  break;
                case '356':
                  text.add('%');
                  break;
                case '1456':
                  text.add('#');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
        }
      } else if (_Switches[BrailleLanguage.ENG].contains(charH)) {
        if (charH == 'CAPITALS') {
          if (i + 1 < maxLength)
            switch (inputs[i + 1]) {
              case '6':
                capitalFollows = true;
                break;
              case '3':
                capitalFollows = false;
                break;
              default:
                oneCapitalFollows = true;
            }
        } else if ((charH == 'NUMBERFOLLOWS') && !numberFollows) {
          numberFollows = true;
        }
      } else if (charH == ' ') {
        numberFollows = false;
        capitalFollows = false;
        oneCapitalFollows = false;
        text.add(charH);
      } else {
        // no switch
        if (numberFollows) {
          if (_LetterToDigit[charH] == null)
            numberFollows = false;
          else
            charH = _LetterToDigit[charH];
        } else if (oneCapitalFollows) {
          charH = charH.toUpperCase();
          oneCapitalFollows = false;
        } else if (capitalFollows) {
          charH = charH.toUpperCase();
        }
        text.add(charH);
      }
    }
  }
  return {'displays': displays, 'chars': text};
}

Map<String, dynamic> _decodeBrailleFRA(List<String> inputs) {
// TO DO
  var displays = <List<String>>[];

  bool numberFollows = false;
  bool capitalFollows = false;
  bool oneCapitalFollows = false;
  bool antoineNumberFollows = false;

  String input = '';
  String charH = '';
  List<String> text = [];
  int maxLength = inputs.length;

  // Build Map for decoding
  Map<String, String> BrailleToChar = new Map<String, String>();
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.FRA]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.FRA]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSwitches[BrailleLanguage.FRA]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsModifier[BrailleLanguage.FRA]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsLetters[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });
  switchMapKeyValue(_CharsToSegmentsSymbols[BrailleLanguage.STD]).forEach((key, value) {
    BrailleToChar[key.join()] = value;
  });

  for (int i = 0; i < maxLength; i++) {
    input = inputs[i];

    // Build displays
    var display = <String>[];
    input.split('').forEach((element) {
      display.add(element);
    });
    displays.add(display);

    // Build text
    if (BrailleToChar[input] == null) {
      text.add(UNKNOWN_ELEMENT);
    } else {
      charH = BrailleToChar[input];
      if (_Modifier[BrailleLanguage.FRA].contains(input)) {
        switch (input) {
          case '5':
            if (i + 2 < maxLength && inputs[i + 1] == '346' && inputs[i + 2] == '346') {
              text.add('‰');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;
            }
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '123456':
                  text.add('§');
                  break;
                case '135':
                  text.add('°');
                  break;
                case '346':
                  text.add('%');
                  break;
                case '36':
                  text.add('_');
                  break;
                case '34':
                  text.add('\\');
                  break;
                case '3456':
                  text.add('#');
                  break;
                case '26':
                  text.add('~');
                  break;
                case '126':
                  text.add('>');
                  break;
                case '345':
                  text.add('<');
                  break;
                case '35':
                  text.add('*');
                  break;
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '6':
            if (i + 2 < maxLength && inputs[i + 1] == '6' && inputs[i + 2] == '236') {
              text.add('{');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;
            }
            if (i + 1 < maxLength) {
              switch (inputs[i + 1]) {
                case '25':
                  text.add('÷');
                  break;
                case '35':
                  text.add('+');
                  break;
                case '235':
                  text.add('×');
                  break;
                case '2356':
                  text.add('=');
                  break;
                default:
                  if (_AntoineLetters.contains(BrailleToChar[inputs[i + 1]]))
                    text.add(_AntoineToDigit[BrailleToChar[inputs[i + 1]]]);
              }
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            antoineNumberFollows = true;
            break;
          case '45':
            if (i + 1 < maxLength && inputs[i + 1] == '236') {
              text.add('[');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            break;
          case '56':
            antoineNumberFollows = false;
            break;
          case '356':
            if (i + 1 < maxLength && inputs[i + 1] == '12') {
              text.add(']');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 1;
            }
            if (i + 2 < maxLength && inputs[i + 1] == '3' && inputs[i + 2] == '3') {
              text.add('}');
              var display = <String>[];
              inputs[i + 1].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              display = <String>[];
              inputs[i + 2].split('').forEach((element) {
                display.add(element);
              });
              displays.add(display);
              i = i + 2;
            }
            break;
        }
      } else if (_Switches[BrailleLanguage.FRA].contains(charH)) {
        if (charH == 'CAPITALS') {
          if (i + 1 < maxLength)
            switch (inputs[i + 1]) {
              case '46':
                capitalFollows = true;
                break;
              default:
                oneCapitalFollows = true;
            }
        } else if ((charH == 'NUMBERFOLLOWS') && antoineNumberFollows) {
          numberFollows = false;
          text.add('0');
        } else if ((charH == 'NUMBERFOLLOWS') && !numberFollows) {
          numberFollows = true;
        } else if ((charH == 'ANTOINENUMBERFOLLOWS')) {
          antoineNumberFollows = true;
        }
      } else if (charH == ' ') {
        numberFollows = false;
        capitalFollows = false;
        oneCapitalFollows = false;
        antoineNumberFollows = false;
        text.add(charH);
      } else {
        // no switch
        if (numberFollows) {
          if (_LetterToDigit[charH] == null)
            numberFollows = false;
          else
            charH = _LetterToDigit[charH];
        }
        if (antoineNumberFollows) {
          if (_AntoineToDigit[charH] != null) charH = _AntoineToDigit[charH];
        } else if (oneCapitalFollows) {
          charH = charH.toUpperCase();
          oneCapitalFollows = false;
        } else if (capitalFollows) {
          charH = charH.toUpperCase();
        }
        text.add(charH);
      }
    }
  }
  return {'displays': displays, 'chars': text};
}

Map<String, dynamic> _decodeBrailleEUR(List<String> inputs) {
  var displays = <List<String>>[];

  List<String> text = inputs.where((input) => input != null).map((input) {
    var display = <String>[];
    var char = '';

    input.split('').forEach((element) {
      display.add(element);
    });

    if (switchMapKeyValue(_charsToSegmentsEUR)
            .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()] ==
        null)
      char = char + UNKNOWN_ELEMENT;
    else {
      char = char +
          switchMapKeyValue(_charsToSegmentsEUR)
              .map((key, value) => MapEntry(key.join(), value.toString()))[input.split('').join()];
    }
    displays.add(display);

    return char;
  }).toList();

  return {'displays': displays, 'chars': text};
}

List<String> _sanitizeDecodeInput(List<String> input, BrailleLanguage language) {
  var pattern = language == BrailleLanguage.EUR ? RegExp(r'[^1-8]') : RegExp(r'[^1-6]');

  return input.map((code) {
    var chars = code.replaceAll(pattern, '').split('').toList();
    chars.sort();
    return chars.join();
  }).toList();
}

Map<String, dynamic> decodeBraille(List<String> input, BrailleLanguage language, bool letters) {
  if (input == null || input.length == 0)
    return {
      'displays': <List<String>>[],
      'chars': [0]
    };

  input = _sanitizeDecodeInput(input, language);

  switch (language) {
    case BrailleLanguage.BASIC:
      return _decodeBrailleBASIC(input, letters);
      break;
    case BrailleLanguage.SIMPLE:
      return _decodeBrailleSIMPLE(input);
      break;
    case BrailleLanguage.DEU:
      return _decodeBrailleDEU(input);
      break;
    case BrailleLanguage.ENG:
      return _decodeBrailleENG(input);
      break;
    case BrailleLanguage.FRA:
      return _decodeBrailleFRA(input);
      break;
    case BrailleLanguage.EUR:
      return _decodeBrailleEUR(input);
      break;
  }
}
