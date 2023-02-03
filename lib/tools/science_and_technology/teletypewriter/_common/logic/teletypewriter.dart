// Ressources
// 1. US Patent No 388244, 21. August 1888, https://pdfpiw.uspto.gov/.piw?PageNum=0&docid=00388244&IDKey=72154382AC1E%0D%0A&HomeUrl=%2F%2Fpatft.uspto.gov%2Fnetahtml%2FPTO%2Fpatimg.htm
// 2. https://en.wikipedia.org/wiki/Baudot_code
// 3. https://de.wikipedia.org/wiki/Baudot-Code
// 4. https://cryptii.com/pipes/baudot
// 5. https://cryptomuseum.com/ref/ita2/index.htm
// 6. CCITT - ITU
//    6.1 Recommendation S.1 (11/88) International Telegraph Alphabet No. 2 https://www.itu.int/rec/dologin_pub.asp?lang=e&id=T-REC-S.1-195811-S!!PDF-E&type=items
//
// Code Tables
// - CCITT_BAUDOT       according to 1. with Bit-Order 54321
// - CCITT_BAUDOT_MISS  according to 3. ITA1
// - CCITT_ITA1_EU      according to 2.
// - CCITT_ITA1_UK      according to 2.
// - CCITT_ITA2         according to 2., 4., 5.
// - CCITT_MTK2         according to 2.
// - CCITT_USTTY        according to 2., 4.
//

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum TeletypewriterCodebook {
  BAUDOT,
  BAUDOT_54123,
  SIEMENS,
  MURRAY,
  WESTERNUNION,
  CCITT_ITA1_1926,
  CCITT_ITA1_1929,
  CCITT_ITA1_EU,
  CCITT_ITA1_UK,
  CCITT_ITA2_1929,
  CCITT_ITA2_1931,
  CCITT_ITA2_MTK2,
  CCITT_ITA2_USTTY,
  CCITT_ITA3,
  CCITT_ITA4,
  CCITT_IA5,
  CCIR476,
  ZC1,
  Z22,
  TTS,
  ILLIAC,
  ALGOL
}

final List<TeletypewriterCodebook> REVERSE_CODEBOOK = [
  TeletypewriterCodebook.ILLIAC,
];

Map<TeletypewriterCodebook, Map<String, String>> ANCIENT_CODEBOOK = {
  TeletypewriterCodebook.BAUDOT: {'title': 'punchtape_baudot_title', 'subtitle': 'punchtape_baudot_description'},
  TeletypewriterCodebook.BAUDOT_54123: {
    'title': 'punchtape_baudot_54123_title',
    'subtitle': 'punchtape_baudot_54123_description'
  },
  TeletypewriterCodebook.MURRAY: {'title': 'punchtape_murray_title', 'subtitle': 'punchtape_murray_description'},
  TeletypewriterCodebook.SIEMENS: {'title': 'punchtape_siemens_title', 'subtitle': 'punchtape_siemens_description'},
  TeletypewriterCodebook.WESTERNUNION: {
    'title': 'punchtape_westernunion_title',
    'subtitle': 'punchtape_westernunion_description'
  },
};

Map<TeletypewriterCodebook, Map<String, String>> CCITT1_CODEBOOK = {
  TeletypewriterCodebook.CCITT_ITA1_1926: {
    'title': 'punchtape_ccitt_ita1_1926_title',
    'subtitle': 'punchtape_ccitt_ita1_1926_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_1929: {
    'title': 'punchtape_ccitt_ita1_1929_title',
    'subtitle': 'punchtape_ccitt_ita1_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_EU: {
    'title': 'punchtape_ccitt_ita1_eu_title',
    'subtitle': 'punchtape_ccitt_ita1_eu_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_UK: {
    'title': 'punchtape_ccitt_ita1_uk_title',
    'subtitle': 'punchtape_ccitt_ita1_uk_description'
  },
};

Map<TeletypewriterCodebook, Map<String, String>> CCITT2_CODEBOOK = {
  TeletypewriterCodebook.CCITT_ITA2_1929: {
    'title': 'punchtape_ccitt_ita2_1929_title',
    'subtitle': 'punchtape_ccitt_ita2_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_1931: {
    'title': 'punchtape_ccitt_ita2_1931_title',
    'subtitle': 'punchtape_ccitt_ita2_1931_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_MTK2: {
    'title': 'punchtape_ccitt_ita2_mtk2_title',
    'subtitle': 'punchtape_ccitt_ita2_mtk2_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_USTTY: {
    'title': 'punchtape_ccitt_ita2_ustty_title',
    'subtitle': 'punchtape_ccitt_ita2_ustty_description'
  },
};

Map<TeletypewriterCodebook, Map<String, String>> CCITT_CODEBOOK = {
  TeletypewriterCodebook.CCITT_ITA1_1926: {
    'title': 'punchtape_ccitt_ita1_1926_title',
    'subtitle': 'punchtape_ccitt_ita1_1926_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_1929: {
    'title': 'punchtape_ccitt_ita1_1929_title',
    'subtitle': 'punchtape_ccitt_ita1_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_EU: {
    'title': 'punchtape_ccitt_ita1_eu_title',
    'subtitle': 'punchtape_ccitt_ita1_eu_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_UK: {
    'title': 'punchtape_ccitt_ita1_uk_title',
    'subtitle': 'punchtape_ccitt_ita1_uk_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_1929: {
    'title': 'punchtape_ccitt_ita2_1929_title',
    'subtitle': 'punchtape_ccitt_ita2_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_1931: {
    'title': 'punchtape_ccitt_ita2_1931_title',
    'subtitle': 'punchtape_ccitt_ita2_1931_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_MTK2: {
    'title': 'punchtape_ccitt_ita2_mtk2_title',
    'subtitle': 'punchtape_ccitt_ita2_mtk2_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_USTTY: {
    'title': 'punchtape_ccitt_ita2_ustty_title',
    'subtitle': 'punchtape_ccitt_ita2_ustty_description'
  },
  TeletypewriterCodebook.CCITT_ITA3: {
    'title': 'punchtape_ccitt_ita3_title',
    'subtitle': 'punchtape_ccitt_ita3_description'
  },
  TeletypewriterCodebook.CCITT_ITA4: {
    'title': 'punchtape_ccitt_ita4_title',
    'subtitle': 'punchtape_ccitt_ita4_description'
  },
  TeletypewriterCodebook.CCITT_IA5: {
    'title': 'punchtape_ccitt_ia5_title',
    'subtitle': 'punchtape_ccitt_ia5_description'
  },
  TeletypewriterCodebook.CCIR476: {
    'title': 'punchtape_ccitt_ccir476_title',
    'subtitle': 'punchtape_ccitt_ccir476_description'
  },
};

Map<TeletypewriterCodebook, Map<String, String>> OTHER_CODEBOOK = {
  TeletypewriterCodebook.ZC1: {'title': 'punchtape_zc1_title', 'subtitle': 'punchtape_zc1_description'},
  TeletypewriterCodebook.Z22: {'title': 'punchtape_z22_title', 'subtitle': 'punchtape_z22_description'},
  TeletypewriterCodebook.TTS: {'title': 'punchtape_tts_title', 'subtitle': 'punchtape_tts_description'},
  TeletypewriterCodebook.ILLIAC: {'title': 'punchtape_illiac_title', 'subtitle': 'punchtape_illiac_description'},
  TeletypewriterCodebook.ALGOL: {'title': 'punchtape_algol_title', 'subtitle': 'punchtape_algol_description'},
};

Map<TeletypewriterCodebook, Map<String, String>> ALL_CODES_CODEBOOK = {
  TeletypewriterCodebook.BAUDOT: {'title': 'punchtape_baudot_title', 'subtitle': 'punchtape_baudot_description'},
  TeletypewriterCodebook.BAUDOT_54123: {
    'title': 'punchtape_baudot_54123_title',
    'subtitle': 'punchtape_baudot_54123_description'
  },
  TeletypewriterCodebook.MURRAY: {'title': 'punchtape_murray_title', 'subtitle': 'punchtape_murray_description'},
  TeletypewriterCodebook.SIEMENS: {'title': 'punchtape_siemens_title', 'subtitle': 'punchtape_siemens_description'},
  TeletypewriterCodebook.WESTERNUNION: {
    'title': 'punchtape_westernunion_title',
    'subtitle': 'punchtape_westernunion_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_1926: {
    'title': 'punchtape_ccitt_ita1_1926_title',
    'subtitle': 'punchtape_ccitt_ita1_1926_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_1929: {
    'title': 'punchtape_ccitt_ita1_1929_title',
    'subtitle': 'punchtape_ccitt_ita1_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_EU: {
    'title': 'punchtape_ccitt_ita1_eu_title',
    'subtitle': 'punchtape_ccitt_ita1_eu_description'
  },
  TeletypewriterCodebook.CCITT_ITA1_UK: {
    'title': 'punchtape_ccitt_ita1_uk_title',
    'subtitle': 'punchtape_ccitt_ita1_uk_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_1929: {
    'title': 'punchtape_ccitt_ita2_1929_title',
    'subtitle': 'punchtape_ccitt_ita2_1929_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_1931: {
    'title': 'punchtape_ccitt_ita2_1931_title',
    'subtitle': 'punchtape_ccitt_ita2_1931_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_MTK2: {
    'title': 'punchtape_ccitt_ita2_mtk2_title',
    'subtitle': 'punchtape_ccitt_ita2_mtk2_description'
  },
  TeletypewriterCodebook.CCITT_ITA2_USTTY: {
    'title': 'punchtape_ccitt_ita2_ustty_title',
    'subtitle': 'punchtape_ccitt_ita2_ustty_description'
  },
  TeletypewriterCodebook.CCITT_ITA3: {
    'title': 'punchtape_ccitt_ita3_title',
    'subtitle': 'punchtape_ccitt_ita3_description'
  },
  TeletypewriterCodebook.CCITT_ITA4: {
    'title': 'punchtape_ccitt_ita4_title',
    'subtitle': 'punchtape_ccitt_ita4_description'
  },
  TeletypewriterCodebook.CCITT_IA5: {
    'title': 'punchtape_ccitt_ia5_title',
    'subtitle': 'punchtape_ccitt_ia5_description'
  },
  TeletypewriterCodebook.CCIR476: {
    'title': 'punchtape_ccitt_ccir476_title',
    'subtitle': 'punchtape_ccitt_ccir476_description'
  },
  TeletypewriterCodebook.ZC1: {'title': 'punchtape_zc1_title', 'subtitle': 'punchtape_zc1_description'},
  TeletypewriterCodebook.Z22: {'title': 'punchtape_z22_title', 'subtitle': 'punchtape_z22_description'},
  TeletypewriterCodebook.TTS: {'title': 'punchtape_tts_title', 'subtitle': 'punchtape_tts_description'},
  TeletypewriterCodebook.ILLIAC: {'title': 'punchtape_illiac_title', 'subtitle': 'punchtape_illiac_description'},
  TeletypewriterCodebook.ALGOL: {'title': 'punchtape_algol_title', 'subtitle': 'punchtape_algol_description'},
};

Map<TeletypewriterCodebook, Map<String, int>> PUNCHTAPE_DEFINITION = {
  TeletypewriterCodebook.BAUDOT: {'punchHoles': 5, 'sprocketHole': 0},
  TeletypewriterCodebook.BAUDOT_54123: {'punchHoles': 5, 'sprocketHole': 3},
  TeletypewriterCodebook.MURRAY: {'punchHoles': 5, 'sprocketHole': 0},
  TeletypewriterCodebook.SIEMENS: {'punchHoles': 5, 'sprocketHole': 0},
  TeletypewriterCodebook.WESTERNUNION: {'punchHoles': 5, 'sprocketHole': 0},
  TeletypewriterCodebook.CCITT_ITA1_1926: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA1_1929: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA1_EU: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA1_UK: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA2_1929: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA2_1931: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA2_MTK2: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA2_USTTY: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA3: {'punchHoles': 7, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_ITA4: {'punchHoles': 6, 'sprocketHole': 4},
  TeletypewriterCodebook.CCITT_IA5: {'punchHoles': 7, 'sprocketHole': 4},
  TeletypewriterCodebook.CCIR476: {'punchHoles': 7, 'sprocketHole': 4},
  TeletypewriterCodebook.ZC1: {'punchHoles': 8, 'sprocketHole': 4},
  TeletypewriterCodebook.Z22: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.TTS: {'punchHoles': 6, 'sprocketHole': 4},
  TeletypewriterCodebook.ILLIAC: {'punchHoles': 5, 'sprocketHole': 4},
  TeletypewriterCodebook.ALGOL: {'punchHoles': 5, 'sprocketHole': 4},
};

Map<TeletypewriterCodebook, int> BINARY_LENGTH = {
  TeletypewriterCodebook.BAUDOT: 5,
  TeletypewriterCodebook.BAUDOT_54123: 5,
  TeletypewriterCodebook.MURRAY: 5,
  TeletypewriterCodebook.SIEMENS: 5,
  TeletypewriterCodebook.WESTERNUNION: 5,
  TeletypewriterCodebook.CCITT_ITA1_1926: 5,
  TeletypewriterCodebook.CCITT_ITA1_1929: 5,
  TeletypewriterCodebook.CCITT_ITA1_EU: 5,
  TeletypewriterCodebook.CCITT_ITA1_UK: 5,
  TeletypewriterCodebook.CCITT_ITA2_1929: 5,
  TeletypewriterCodebook.CCITT_ITA2_1931: 5,
  TeletypewriterCodebook.CCITT_ITA2_MTK2: 5,
  TeletypewriterCodebook.CCITT_ITA2_USTTY: 5,
  TeletypewriterCodebook.CCITT_ITA3: 7,
  TeletypewriterCodebook.CCITT_ITA4: 6,
  TeletypewriterCodebook.CCITT_IA5: 7,
  TeletypewriterCodebook.CCIR476: 7,
  TeletypewriterCodebook.ZC1: 8,
  TeletypewriterCodebook.Z22: 5,
  TeletypewriterCodebook.TTS: 6,
  TeletypewriterCodebook.ILLIAC: 5,
  TeletypewriterCodebook.ALGOL: 5,
};

final AZToCCITT_BAUDOT = {
// Original code from US Patent in Bit-Order 54321
  'A': 1,
  'B': 12,
  'C': 13,
  'D': 15,
  'E': 2,
  String.fromCharCode(201) /* É */ : 3,
  'F': 14,
  'G': 10,
  'H': 11,
  'I': 6,
  'J': 9,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'O': 7,
  'P': 31,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'U': 5,
  'V': 23,
  'W': 22,
  'X': 18,
  'Y': 4,
  'Z': 19,
  'Ṯ': 17,
  '✲': 24,
};
final CCITT_BAUDOTToAZ = switchMapKeyValue(AZToCCITT_BAUDOT);

// original Baudot according to US Patent has no numbers
final NumbersToCCITT_BAUDOT = {};
final CCITT_BAUDOTToNumbers = switchMapKeyValue(NumbersToCCITT_BAUDOT);

final AZToBaudot_54123 = {
  // Baudot-Code from DEU Wikipedia in Bit-Order 54321
  'A': 4, // 12345 1
  'B': 18, // 12345 11
  'C': 22, // 12345 13
  'D': 30, // 12345 15
  'E': 8, // 12345 2
  'É': 12, // 12345 3
  'F': 26, // 12345 14
  'G': 10, // 12345 10
  'H': 14, // 12345 11
  'I': 24, // 12345 6
  'J': 6, // 12345 9
  'K': 7, // 12345 25
  'L': 15, // 12345 27
  'M': 11, // 12345 26
  'N': 27, // 12345 30
  'O': 28, // 12345 7
  'P': 31, // 12345 31
  'Q': 23, // 12345 29
  'R': 19, // 12345 28
  'S': 17, // 12345 20
  'T': 21, // 12345 13
  'U': 20, // 12345 5
  'V': 29, // 12345 23
  'W': 25, // 12345 22
  'X': 9, // 12345 18
  'Y': 16, // 12345 4
  'Z': 13, // 12345 19
  'Ṯ': 5, // 12345 17
  '✲': 3, // 12345 24
};
final Baudot_54123ToAZ = switchMapKeyValue(AZToBaudot_54123);

final NumbersToBaudot_54123 = {
  '1': 4, // 12345 1
  '8': 18, // 12345 12
  '9': 22, // 12345 13
  '0': 30, // 12345 15
  '2': 8, // 12345 2
  '&': 12, // 12345 3
  '₣': 26, // 12345 14
  '7': 10, // 12345 10
  'Ḫ': 14, // 12345 11
  'Ḏ': 24, // 12345 6
  '6': 6, // 12345 9
  '(': 7, // 12345 25
  '=': 15, // 12345 27
  ')': 11, // 12345 26
  '№': 27, // 12345 30
  '5': 28, // 12345 7
  '%': 31, // 12345 31
  '/': 23, // 12345 29
  '-': 19, // 12345 28
  ';': 17, // 12345 20
  '!': 21, // 12345 13
  '4': 20, // 12345 5
  '\'': 29, // 12345 23
  '?': 25, // 12345 22
  ',': 9, // 12345 18
  '3': 16, // 12345 4
  ':': 13, // 12345 19
  '.': 5, // 12345 17
  '✲': 3, // 12345 24
  String.fromCharCode(163) /* £ */ : 27,
};
final Baudot_54123ToNumbers = switchMapKeyValue(NumbersToBaudot_54123);

final AZToMurray = {
  'A': 3,
  'B': 25,
  'C': 14,
  'D': 9,
  'E': 1,
  'F': 13,
  'G': 26,
  'H': 20,
  'I': 6,
  'J': 11,
  'K': 15,
  'L': 18,
  'M': 28,
  'N': 12,
  'O': 24,
  'P': 22,
  'Q': 23,
  'R': 10,
  'S': 5,
  'T': 16,
  'U': 7,
  'V': 30,
  'W': 19,
  'X': 29,
  'Y': 21,
  'Z': 17,
  '+': 8,
  ' ': 4
};
final MurrayToAZ = switchMapKeyValue(AZToMurray);

final NumbersToMurray = {
//  'A': 3,
  '/': 25,
  '\'': 14,
  '&': 9,
  '3': 1,
  '!': 13,
  '"': 26,
  ';': 20,
  '8': 6,
  '=': 11,
  '§': 15,
//  'L': 18,
  '?': 28,
  '-': 12,
  '9': 24,
  '0': 22,
  '1': 23,
  '4': 10,
  ':': 5,
  '5': 16,
  '7': 7,
  '(': 30,
  ')': 30,
  '2': 19,
  '%': 29,
  '6': 21,
  ',': 17,
  '.': 8,
  ' ': 4
};
final MurrayToNumbers = switchMapKeyValue(NumbersToMurray);

final AZToWesternunion = {
  'A': 3,
  'B': 25,
  'C': 14,
  'D': 9,
  'E': 1,
  'F': 13,
  'G': 26,
  'H': 20,
  'I': 6,
  'J': 11,
  'K': 15,
  'L': 18,
  'M': 28,
  'N': 12,
  'O': 24,
  'P': 22,
  'Q': 23,
  'R': 10,
  'S': 5,
  'T': 16,
  'U': 7,
  'V': 30,
  'W': 19,
  'X': 29,
  'Y': 21,
  'Z': 17,
  ' ': 4,
  '\r': 8,
  '\n': 2,
};
final WesternunionToAZ = switchMapKeyValue(AZToWesternunion);

final NumbersToWesternunion = {
  '-': 3,
  '?': 25,
  ':': 14,
  '\$': 9,
  '3': 1,
  'city': 13,
  '&': 26,
  '£': 20,
  '8': 6,
  '*': 11,
  '(': 15,
  ')': 18,
  '.': 28,
  ',': 12,
  '9': 24,
  '0': 22,
  '1': 23,
  '4': 10,
  'thru': 5,
  '5': 16,
  '7': 7,
  ';': 30,
  '2': 19,
  '/': 29,
  '6': 21,
  '"': 17,
  ' ': 4,
  '\r': 8,
  '\n': 2,
};
final WesternunionToNumbers = switchMapKeyValue(NumbersToWesternunion);

final AZToSiemens = {
  'A': 6,
  'B': 26,
  'C': 23,
  'D': 17,
  'E': 7,
  'F': 13,
  'G': 27,
  'H': 19,
  'I': 1,
  'J': 18,
  'K': 8,
  'L': 15,
  'M': 2,
  'N': 3,
  'O': 25,
  'P': 22,
  'Q': 20,
  'R': 24,
  'S': 12,
  'T': 16,
  'U': 14,
  'V': 29,
  'W': 9,
  'X': 10,
  'Y': 5,
  'Z': 21,
};
final SiemensToAZ = switchMapKeyValue(AZToSiemens);

final NumbersToSiemens = {
  '.': 6,
  '/': 26,
  '\'': 23,
  '&': 17,
  '3': 7,
  '!': 13,
  '"': 27,
  ';': 19,
  '8': 1,
  '=': 18,
  '§': 8,
  '+': 15,
  '?': 2,
  '-': 3,
  '9': 25,
  '0': 22,
  '1': 20,
  '4': 24,
  ':': 12,
  '5': 16,
  '7': 14,
  ')': 29,
  '2': 9,
  '(': 10,
  '6': 5,
  ',': 21,
};
final SiemensToNumbers = switchMapKeyValue(NumbersToSiemens);

final AZToCCITT_ITA1_EU = {
  // Code according to ENG Wikipedia, Bit-Order 54321
  'A': 1,
  String.fromCharCode(201) /* É */ : 3,
  'E': 2,
  'I': 6,
  'O': 7,
  'U': 5,
  'Y': 6,
  'B': 12,
  'C': 13,
  'D': 15,
  'F': 14,
  'G': 10,
  'H': 11,
  'J': 12,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'P': 31,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'V': 23,
  'W': 22,
  'X': 18,
  'Z': 19,
  '-': 17,
};
final CCITT_ITA1_EUToAZ = switchMapKeyValue(AZToCCITT_ITA1_EU);

final NumbersToCCITT_ITA1_EU = {
  // Code according to ENG Wikipedia, Bit-Order 54321
  '1': 1,
  '&': 3,
  '2': 2,
  //'': 6, o with double underscore
  '5': 7,
  '4': 5,
  '3': 6,
  '8': 12,
  '9': 13,
  '0': 15,
  //'': 14, f with double underscore
  '7': 10,
  //'': 11, h with double underscore
  '6': 12,
  '(': 25,
  '=': 27,
  ')': 26,
  'N°': 30,
  '%': 31,
  '/': 29,
  '-': 28,
  ';': 20,
  '!': 21,
  '\'': 23,
  '?': 22,
  ',': 18,
  ':': 19,
  '.': 17,
};
final CCITT_ITA1_EUToNumbers = switchMapKeyValue(NumbersToCCITT_ITA1_EU);

final AZToCCITT_ITA1_UK = {
  // Code according to ENG Wikipedia, Bit-Order 54321
  'A': 1,
  '/': 3,
  'E': 2,
  'I': 6,
  'O': 7,
  'U': 5,
  'Y': 6,
  'B': 12,
  'C': 13,
  'D': 15,
  'F': 14,
  'G': 10,
  'H': 11,
  'J': 12,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'P': 31,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'V': 23,
  'W': 22,
  'X': 18,
  'Z': 19,
  '-': 17,
};
final CCITT_ITA1_UKToAZ = switchMapKeyValue(AZToCCITT_ITA1_UK);

final NumbersToCCITT_ITA1_UK = {
  '1': 1,
  '1/': 3,
  '2': 2,
  '3/': 6,
  '5': 7,
  '4': 5,
  '3': 6,
  '8': 12,
  '9': 13,
  '0': 15,
  '5/': 14,
  '7': 10,
  '¹': 11,
  '6': 12,
  '(': 25,
  '=': 27,
  ')': 26,
  '£': 30,
  '+': 31,
  '/': 29,
  '-': 28,
  '7/': 20,
  '²': 21,
  '¹': 23,
  '?': 22,
  '9/': 18,
  ':': 19,
  '.': 17,
};
final CCITT_ITA1_UKToNumbers = switchMapKeyValue(NumbersToCCITT_ITA1_UK);

final AZToCCITT_ITA2_MTK2 = {
  //according to ENG Wikipedia, Bit-Order 54321
  ' ': 4,
  '\r': 2,
  '\n': 8,
  'E': 1,
  'A': 3,
  'С': 5,
  'И': 6,
  'У': 7,
  'Д': 9,
  'Р': 10,
  'Й': 11,
  'Ч': 12,
  'Ф': 13,
  'Ц': 14,
  'К': 15,
  'Т': 16,
  'З': 17,
  'Л': 18,
  'В': 19,
  'Х': 20,
  'Ы': 21,
  'П': 22,
  'Я': 23,
  'О': 24,
  'Б': 25,
  'Г': 26,
  'М': 28,
  'Ь': 29,
  'Ж': 30
};
final CCITT_ITA2_MTK2ToAZ = switchMapKeyValue(AZToCCITT_ITA2_MTK2);

final NumbersToCCITT_MTK2 = {
  //according to ENG Wikipedia, Bit-Order 54321
  ' ': 4,
  '\r': 2,
  '\n': 8,
  '3': 1,
  '-': 3,
  '\'': 5,
  '8': 6,
  '7': 7,
  'Ч': 9,
  '4': 10,
  'Ю': 11,
  ',': 12,
  'Э': 13,
  ':': 14,
  '(': 15,
  '5': 16,
  '+': 17,
  ')': 18,
  '2': 19,
  'Щ': 20,
  '6': 21,
  '0': 22,
  '1': 23,
  '9': 24,
  '?': 25,
  'Ш': 26,
  '.': 28,
  '/': 29,
  '=': 30
};
final CCITT_MTK2ToNumbers = switchMapKeyValue(NumbersToCCITT_MTK2);

final AZToCCITT_USTTY = {
  //according to ENG Wikipedia, Bit-Order 54321
  ' ': 4,
  '\r': 2,
  '\n': 8,
  'E': 1,
  'A': 3,
  'S': 5,
  'I': 6,
  'U': 7,
  'D': 9,
  'R': 10,
  'J': 11,
  'N': 12,
  'F': 13,
  'C': 14,
  'K': 15,
  'T': 16,
  'Z': 17,
  'L': 18,
  'W': 19,
  'H': 20,
  'Y': 21,
  'P': 22,
  'Q': 23,
  'O': 24,
  'B': 25,
  'G': 26,
  'M': 28,
  'X': 29,
  'V': 30
};
final CCITT_USTTYToAZ = switchMapKeyValue(AZToCCITT_USTTY);

final NumbersToCCITT_ITA2_USTTY = {
  //according to ENG Wikipedia, Bit-Order 54321
  ' ': 4,
  '\r': 2,
  '\n': 8,
  '3': 1,
  '-': 3,
  '@': 5,
  '8': 6,
  '7': 7,
  '4': 10,
  '\'': 11,
  ',': 12,
  ':': 14,
  '(': 15,
  '5': 16,
  '"': 17,
  ')': 18,
  '2': 19,
  '6': 21,
  '0': 22,
  '1': 23,
  '9': 24,
  '?': 25,
  '.': 28,
  '/': 29,
  ';': 30
};
final CCITT_USTTYToNumbers = switchMapKeyValue(NumbersToCCITT_ITA2_USTTY);

final AZToCCITT_ITA1_1926 = {
  'A': 1,
  'B': 12,
  'C': 13,
  'D': 15,
  'E': 2,
  'É': 3,
  'F': 14,
  'G': 10,
  'H': 11,
  'I': 6,
  'J': 9,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'O': 7,
  'P': 31,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'U': 5,
  'V': 23,
  'W': 22,
  'X': 18,
  'Y': 4,
  'Z': 19,
  'Ṯ': 17,
  '✲': 24,
};
final CCITT_ITA1_1926ToAZ = switchMapKeyValue(AZToCCITT_ITA1_1926);

final AZToCCITT_ITA1_1929 = {
  'A': 1,
  'B': 12,
  'C': 13,
  'D': 15,
  'E': 2,
  'F': 14,
  'G': 10,
  'H': 11,
  'I': 6,
  'J': 9,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'O': 7,
  'P': 31,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'U': 5,
  'V': 23,
  'W': 22,
  'X': 18,
  'Y': 4,
  'Z': 19,
  '✲': 24,
  '\n': 3,
  '\r': 17,
};
final CCITT_ITA1_1929ToAZ = switchMapKeyValue(AZToCCITT_ITA1_1929);

final AZToCCITT_ITA2_1929 = {
  'A': 1,
  'B': 12,
  'C': 13,
  'D': 15,
  'E': 2,
  'F': 14,
  'G': 10,
  'H': 11,
  'I': 6,
  'J': 9,
  'K': 25,
  'L': 27,
  'M': 26,
  'N': 30,
  'O': 7,
  'P': 24,
  'Q': 29,
  'R': 28,
  'S': 20,
  'T': 21,
  'U': 5,
  'V': 23,
  'W': 22,
  'X': 18,
  'Y': 4,
  'Z': 19,
  '\n': 3,
  '\r': 17,
};
final CCITT_ITA2_1929ToAZ = switchMapKeyValue(AZToCCITT_ITA2_1929);

final AZToCCITT_ITA2_1931 = {
  'A': 3,
  'B': 25,
  'C': 14,
  'D': 9,
  'E': 1,
  'F': 13,
  'G': 26,
  'H': 20,
  'I': 6,
  'J': 11,
  'K': 15,
  'L': 18,
  'M': 28,
  'N': 12,
  'O': 24,
  'P': 22,
  'Q': 23,
  'R': 10,
  'S': 5,
  'T': 16,
  'U': 7,
  'V': 30,
  'W': 19,
  'X': 29,
  'Y': 21,
  'Z': 17,
  ' ': 4,
  '\r': 2,
  '\n': 8,
};
final CCITT_ITA2_1931ToAZ = switchMapKeyValue(AZToCCITT_ITA2_1931);

final AZToCCITT_ITA3 = {
  'A': 44,
  'B': 76,
  'C': 25,
  'D': 28,
  'E': 14,
  'F': 100,
  'G': 67,
  'H': 37,
  'I': 7,
  'J': 98,
  'K': 104,
  'L': 35,
  'M': 69,
  'N': 21,
  'O': 49,
  'P': 41,
  'Q': 88,
  'R': 19,
  'S': 42,
  'T': 81,
  'U': 38,
  'V': 73,
  'W': 82,
  'X': 52,
  'Y': 84,
  'Z': 70,
  '\n': 97,
  '\r': 13,
  ' ': 11
};
final CCITT_ITA3ToAZ = switchMapKeyValue(AZToCCITT_ITA3);

final AZToCCITT_ITA4 = {
  'A': 6,
  'B': 50,
  'C': 28,
  'D': 18,
  'E': 2,
  'F': 26,
  'G': 52,
  'H': 40,
  'I': 12,
  'J': 22,
  'K': 30,
  'L': 36,
  'M': 56,
  'N': 24,
  'O': 48,
  'P': 44,
  'Q': 46,
  'R': 20,
  'S': 10,
  'T': 32,
  'U': 14,
  'V': 60,
  'W': 38,
  'X': 58,
  'Y': 42,
  'Z': 34,
  '\n': 16,
  '\r': 4,
  ' ': 8
};
final CCITT_ITA4ToAZ = switchMapKeyValue(AZToCCITT_ITA4);

final AZToCCIR476 = {
  // https://en.wikipedia.org/wiki/CCIR_476
  'A': 71,
  'B': 114,
  'C': 29,
  'D': 83,
  'E': 86,
  'F': 27,
  'G': 53,
  'H': 105,
  'I': 77,
  'J': 23,
  'K': 30,
  'L': 101,
  'M': 57,
  'N': 89,
  'O': 113,
  'P': 45,
  'Q': 46,
  'R': 85,
  'S': 75,
  'T': 116,
  'U': 78,
  'V': 60,
  'W': 39,
  'X': 58,
  'Y': 43,
  'Z': 99,
  ' ': 92,
  '\r': 108,
  '\n': 120,
};
final CCIR476ToAZ = switchMapKeyValue(AZToCCIR476);

final AZToALGOL = {
  'A': 3,
  'B': 25,
  'C': 14,
  'D': 9,
  'E': 1,
  'F': 13,
  'G': 26,
  'H': 20,
  'I': 6,
  'J': 11,
  'K': 15,
  'L': 18,
  'M': 28,
  'N': 12,
  'O': 24,
  'P': 22,
  'Q': 23,
  'R': 10,
  'S': 5,
  'T': 16,
  'U': 7,
  'V': 30,
  'W': 19,
  'X': 29,
  'Y': 21,
  'Z': 17,
  ' ': 4,
  '\r': 2,
  '\n': 8,
};
final ALGOLToAZ = switchMapKeyValue(AZToALGOL);

final NumbersToCCITT_ITA1_1926 = {
  '1': 1,
  '8': 12,
  '9': 13,
  '0': 15,
  '2': 2,
  //'national': 3,
  //'national': 14,
  '7': 10,
  //'national': 11,
  //'national': 6,
  '6': 9,
  '(': 25,
  '=': 27,
  ')': 26,
  '№': 30,
  '5': 7,
  '%': 31,
  '/': 29,
  '-': 28,
  ';': 20,
  '!': 21,
  '4': 5,
  '\'': 23,
  '?': 22,
  ',': 18,
  '3': 4,
  ':': 19,
  '.': 17,
  '✲': 24,
};
final CCITT_ITA1_1926ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA1_1926);

final NumbersToCCITT_ITA1_1929 = {
  '1': 1,
  '8': 12,
  '9': 13,
  '0': 15,
  '2': 2,
  //'national': 14,
  '7': 10,
  //'national': 11,
  //'national': 6,
  '6': 9,
  '(': 25,
  '=': 27,
  ')': 26,
  '+': 30,
  '5': 7,
  '%': 31,
  '/': 29,
  '-': 28,
  '.': 20,
  //'national': 21,
  '4': 5,
  '\'': 23,
  '?': 22,
  ',': 18,
  '3': 4,
  ':': 19,
  '✲': 24,
  '\n': 3,
  '\r': 17,
};
final CCITT_ITA1_1929ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA1_1929);

final NumbersToCCITT_ITA2_1929 = {
  ':': 1,
  '?': 12,
  '(': 13,
  ',': 15,
  '3': 2,
  '/': 14,
  // 'national': 10,
  '+': 11,
  '8': 6,
  '🔔': 9,
  // 'national': 25,
  '=': 27,
  '\'': 26,
  '-': 30,
  '9': 7,
  '0': 24,
  '1': 29,
  '4': 28,
  //'national': 20,
  '5': 21,
  '7': 5,
  ')': 23,
  '2': 22,
  // 'national': 18,
  '6': 4,
  '.': 19,
  '\n': 3,
  '\r': 17,
};
final CCITT_ITA2_1929ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA2_1929);

final NumbersToCCITT_ITA2_1931 = {
  '-': 3,
  '?': 25,
  ':': 14,
  // national : 9
  '3': 1,
  // national : 13
  // national : 26
  // national : 20
  '8': 6,
  '🔔': 11, // Bell
  '(': 15,
  ')': 18,
  '.': 28,
  ',': 12,
  '9': 24,
  '0': 22,
  '1': 23,
  '4': 10,
  '\'': 5,
  '5': 16,
  '7': 7,
  '=': 30,
  '2': 19,
  '/': 29,
  '6': 21,
  '+': 17,
  ' ': 4,
  '\r': 2,
  '\n': 8,
};
final CCITT_ITA2_1931ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA2_1931);

final NumbersToCCITT_ITA3 = {
  '-': 44,
  '?': 76,
  ':': 25,
  //'': 28,
  '3': 14,
  //'': 100,
  //'': 67,
  //'': 37,
  '8': 7,
  //'': 98,
  '(': 104,
  ')': 35,
  '.': 69,
  ',': 21,
  '9': 49,
  '0': 41,
  '1': 88,
  '4': 19,
  '\'': 42,
  '5': 81,
  '7': 38,
  '=': 73,
  '2': 82,
  '/': 52,
  '6': 84,
  '+': 70,
  '\n': 97,
  '\r': 13,
  ' ': 11
};
final CCITT_ITA3ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA3);

final NumbersToCCITT_ITA4 = {
  '-': 64,
  '?': 50,
  ':': 28,
  //'': 18,
  '3': 2,
  //'': 26,
  //'': 52,
  //'': 40,
  '8': 12,
  //'': 22,
  '(': 30,
  ')': 36,
  '.': 56,
  ',': 24,
  '9': 48,
  '0': 44,
  '1': 46,
  '4': 20,
  '\'': 10,
  '5': 32,
  '7': 14,
  '=': 60,
  '2': 38,
  '/': 58,
  '6': 42,
  '+': 34,
  '\n': 16,
  '\r': 4,
  ' ': 8
};
final CCITT_ITA4ToNumbers = switchMapKeyValue(NumbersToCCITT_ITA4);

final NumbersToCCIR476 = {
  '-': 71,
  '?': 114,
  ':': 29,
  // 'D': 83, national
  '3': 86,
  //'F': 27,
  //'G': 53,
  //'H': 105,
  '8': 77,
  '🔔': 23, // Bell
  '(': 30,
  ')': 101,
  '.': 57,
  ',': 89,
  '9': 113,
  '0': 45,
  '1': 46,
  '4': 85,
  '\'': 75,
  '5': 116,
  '7': 78,
  '=': 60,
  '2': 39,
  '/': 58,
  '6': 43,
  '+': 99,
  '\r': 108,
  '\n': 120,
};
final CCIR476ToNumbers = switchMapKeyValue(NumbersToCCIR476);

final NumbersToALGOL = {
  '-': 3,
  '*': 25,
  ':': 14,
  // national : 9
  '3': 1,
  '[': 13,
  ']': 26,
  // national : 20
  '8': 6,
  ';': 11, // Bell
  '(': 15,
  ')': 18,
  '.': 28,
  ',': 12,
  '9': 24,
  '0': 22,
  '1': 23,
  '4': 10,
  '\'': 5,
  '5': 16,
  '7': 7,
  '=': 30,
  '2': 19,
  '/': 29,
  '6': 21,
  '+': 17,
  ' ': 4,
  '\r': 2,
  '\n': 8,
};
final ALGOLToNumbers = switchMapKeyValue(NumbersToALGOL);

final AZToZC1 = {
  '"': 96,
  '\'': 97,
  '´': 98,
  '`': 99,
  '^': 101,
  '°': 102,
  '~': 103,
  '\\': 107,
  'ʿ': 108,
  'ʾ': 109,
  '_': 110,
  '¯': 111,
  '%': 112,
  '§': 113,
  '#': 114,
  '\$': 115,
  '¢': 116,
  '@': 118,
  '&': 119,
  '*': 120,
  '⯏': 124,
  'π': 127,
  '∧': 128,
  '∨': 129,
  '¬': 130,
  '↑': 134,
  '|': 139,
  '+': 144,
  '-': 145,
  '/': 147,
  '=': 151,
  '≠': 152,
  '<': 155,
  '>': 156,
  '≤': 157,
  '≥': 158,
  '(': 160,
  ')': 161,
  '[': 162,
  ']': 163,
  '〈': 166,
  '〉': 167,
  '}': 168,
  '.': 169,
  ',': 170,
  ':': 171,
  ';': 172,
  '!': 173,
  '?': 174,
  ' ': 175,
  '0': 176,
  '1': 177,
  '2': 178,
  '3': 179,
  '4': 180,
  '5': 181,
  '6': 182,
  '7': 183,
  '8': 184,
  '9': 185,
  '{': 191,
  'A': 192,
  'B': 193,
  'C': 194,
  'D': 195,
  'E': 196,
  'F': 197,
  'G': 198,
  'H': 199,
  'I': 200,
  'J': 201,
  'K': 202,
  'L': 203,
  'M': 204,
  'N': 205,
  'O': 206,
  'P': 207,
  'Q': 208,
  'R': 209,
  'S': 210,
  'T': 211,
  'U': 212,
  'V': 213,
  'W': 214,
  'X': 215,
  'Y': 216,
  'Z': 217,
  'Ä': 218,
  'Ö': 219,
  'Ü': 220,
  'a': 224,
  'b': 225,
  'c': 226,
  'd': 227,
  'e': 228,
  'f': 229,
  'g': 230,
  'h': 231,
  'i': 232,
  'j': 233,
  'k': 234,
  'l': 235,
  'm': 236,
  'n': 237,
  'o': 238,
  'p': 239,
  'q': 240,
  'r': 241,
  's': 242,
  't': 243,
  'u': 244,
  'v': 245,
  'w': 246,
  'x': 247,
  'y': 248,
  'z': 249,
  'ä': 250,
  'ö': 251,
  'ü': 252,
  'ß': 253,
};
final ZC1ToAZ = switchMapKeyValue(AZToZC1);

final AZToILLIAC = {
  'A': 22,
  'B': 19,
  'C': 29,
  'D': 17,
  'E': 3,
  'F': 14,
  'G': 25,
  'H': 28,
  'I': 8,
  'J': 13,
  'K': 10,
  'L': 15,
  'M': 26,
  'N': 12,
  'O': 9,
  'P': 0,
  'Q': 1,
  'R': 4,
  'S': 11,
  'T': 5,
  'U': 7,
  'V': 21,
  'W': 2,
  'X': 23,
  'Y': 6,
  'Z': 30,
  ' ': 31,
  '\n': 18,
};
final ILLIACToAZ = switchMapKeyValue(AZToILLIAC);

final NumbersToILLIAC = {
  ')': 22,
  '(': 19,
  ':': 29,
  '\$': 17,
  '3': 3,
  'F': 14,
  '=': 25,
  '\'': 28,
  '8': 8,
  'J': 13,
  '+': 10,
  'L': 15,
  '.': 26,
  'N': 12,
  '9': 9,
  '0': 0,
  '1': 1,
  '4': 4,
  '-': 11,
  '5': 5,
  '7': 7,
  ',': 21,
  '2': 2,
  '/': 23,
  '6': 6,
  '*': 30,
  ' ': 31,
  '\n': 18,
};
final ILLIACToNumbers = switchMapKeyValue(NumbersToILLIAC);

final AZToTTS = {
  // https://druck-mediengeschichte.org/2020/08/06/zwischen-morsecode-und-digitaler-fonttechnologie-2/
  // Wilfried Kusterka
  'T': 32,
  'O': 48,
  'N': 24,
  'H': 40,
  'M': 56,
  'I': 12,
  'R': 20,
  'C': 28,
  'L': 36,
  'P': 44,
  'G': 52,
  'V': 60,
  'E': 2,
  'A': 6,
  'S': 10,
  'U': 14,
  'D': 18,
  'J': 22,
  'F': 26,
  'K': 30,
  'Z': 34,
  'W': 38,
  'Y': 42,
  'Q': 46,
  'B': 50,
  'X': 58,
  '-': 13,
  '⅞': 15,
  '½': 21,
  '5/8': 33,
  '(': 35,
  '1/4': 39,
  '3/4': 43,
  '?': 45,
  '&': 49,
};
final TTSToAZ = switchMapKeyValue(AZToTTS);

final NumbersToTTS = {
  't': 32,
  'o': 48,
  'n': 24,
  'h': 40,
  'm': 56,
  'i': 12,
  'r': 20,
  'c': 28,
  'l': 36,
  'p': 44,
  'g': 52,
  'v': 60,
  'e': 2,
  'a': 6,
  's': 10,
  'u': 14,
  'd': 18,
  'j': 22,
  'f': 26,
  'k': 30,
  'z': 34,
  'w': 38,
  'y': 42,
  'q': 46,
  'b': 50,
  'x': 58,
  '8': 13,
  '7': 15,
  '4': 21,
  '5': 33,
  '(': 35,
  '2': 39,
  '6': 43,
  '0': 45,
  '9': 49,
};
final TTSToNumbers = switchMapKeyValue(NumbersToTTS);

final _NUMBERS_FOLLOW = {
  TeletypewriterCodebook.BAUDOT_54123: 2, // 12345 8
  TeletypewriterCodebook.SIEMENS: 30,
  TeletypewriterCodebook.MURRAY: 27,
  TeletypewriterCodebook.WESTERNUNION: 27,
  TeletypewriterCodebook.CCITT_ITA1_1926: 8,
  TeletypewriterCodebook.CCITT_ITA1_1929: 8,
  TeletypewriterCodebook.CCITT_ITA1_EU: 8,
  TeletypewriterCodebook.CCITT_ITA1_UK: 8,
  TeletypewriterCodebook.CCITT_ITA2_1929: 8,
  TeletypewriterCodebook.CCITT_ITA2_1931: 27,
  TeletypewriterCodebook.CCITT_ITA2_MTK2: 27,
  TeletypewriterCodebook.CCITT_ITA2_USTTY: 27,
  TeletypewriterCodebook.CCITT_ITA3: 50,
  TeletypewriterCodebook.CCITT_ITA4: 54,
  TeletypewriterCodebook.CCIR476: 54,
  TeletypewriterCodebook.Z22: 27,
  TeletypewriterCodebook.TTS: 54,
  TeletypewriterCodebook.ILLIAC: 27,
  TeletypewriterCodebook.ALGOL: 62,
};
final _LETTERS_FOLLOW = {
  TeletypewriterCodebook.BAUDOT_54123: 1, //16,
  TeletypewriterCodebook.SIEMENS: 28,
  TeletypewriterCodebook.MURRAY: 31,
  TeletypewriterCodebook.WESTERNUNION: 31,
  TeletypewriterCodebook.CCITT_ITA1_1926: 16,
  TeletypewriterCodebook.CCITT_ITA1_1929: 16,
  TeletypewriterCodebook.CCITT_ITA1_EU: 16,
  TeletypewriterCodebook.CCITT_ITA1_UK: 16,
  TeletypewriterCodebook.CCITT_ITA2_1929: 16,
  TeletypewriterCodebook.CCITT_ITA2_1931: 31,
  TeletypewriterCodebook.CCITT_ITA2_MTK2: 31,
  TeletypewriterCodebook.CCITT_ITA2_USTTY: 31,
  TeletypewriterCodebook.CCITT_ITA3: 56,
  TeletypewriterCodebook.CCITT_ITA4: 62,
  TeletypewriterCodebook.CCIR476: 127,
  TeletypewriterCodebook.Z22: 31,
  TeletypewriterCodebook.TTS: 54,
  TeletypewriterCodebook.ILLIAC: 20,
  TeletypewriterCodebook.ALGOL: 54,
};

int _EncodeAZ(TeletypewriterCodebook language, String text) {
  switch (language) {
    case TeletypewriterCodebook.BAUDOT:
      return AZToCCITT_BAUDOT[text];
      break;
    case TeletypewriterCodebook.MURRAY:
      return AZToMurray[text];
      break;
    case TeletypewriterCodebook.SIEMENS:
      return AZToSiemens[text];
      break;
    case TeletypewriterCodebook.WESTERNUNION:
      return AZToWesternunion[text];
      break;
    case TeletypewriterCodebook.BAUDOT_54123:
      return AZToBaudot_54123[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1926:
      return AZToCCITT_ITA1_1926[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1929:
      return AZToCCITT_ITA1_1929[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_EU:
      return AZToCCITT_ITA1_EU[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      return AZToCCITT_ITA1_UK[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1929:
      return AZToCCITT_ITA2_1929[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.Z22:
      return AZToCCITT_ITA2_1931[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
      return AZToCCITT_ITA2_MTK2[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
      return AZToCCITT_USTTY[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA3:
      return AZToCCITT_ITA3[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA4:
      return AZToCCITT_ITA4[text];
      break;
    case TeletypewriterCodebook.CCIR476:
      return AZToCCIR476[text];
      break;
    case TeletypewriterCodebook.ILLIAC:
      return AZToILLIAC[text];
      break;
    case TeletypewriterCodebook.TTS:
      return AZToTTS[text];
      break;
    case TeletypewriterCodebook.ALGOL:
      return AZToALGOL[text];
      break;
  }
}

int _EncodeNumber(TeletypewriterCodebook language, String text) {
  switch (language) {
    case TeletypewriterCodebook.BAUDOT:
      return NumbersToCCITT_BAUDOT[text];
      break;
    case TeletypewriterCodebook.MURRAY:
      return NumbersToMurray[text];
      break;
    case TeletypewriterCodebook.SIEMENS:
      return NumbersToSiemens[text];
      break;
    case TeletypewriterCodebook.WESTERNUNION:
      return NumbersToWesternunion[text];
      break;
    case TeletypewriterCodebook.BAUDOT_54123:
      return NumbersToBaudot_54123[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1926:
      return NumbersToCCITT_ITA1_1926[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1929:
      return NumbersToCCITT_ITA1_1929[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_EU:
      return NumbersToCCITT_ITA1_EU[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      return NumbersToCCITT_ITA1_UK[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1929:
      return NumbersToCCITT_ITA2_1929[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.Z22:
      return NumbersToCCITT_ITA2_1931[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
      return NumbersToCCITT_MTK2[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
      return NumbersToCCITT_ITA2_USTTY[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA3:
      return NumbersToCCITT_ITA3[text];
      break;
    case TeletypewriterCodebook.CCITT_ITA4:
      return NumbersToCCITT_ITA4[text];
      break;
    case TeletypewriterCodebook.CCIR476:
      return NumbersToCCIR476[text];
      break;
    case TeletypewriterCodebook.ILLIAC:
      return NumbersToILLIAC[text];
      break;
    case TeletypewriterCodebook.TTS:
      return NumbersToTTS[text];
      break;
    case TeletypewriterCodebook.ALGOL:
      return NumbersToALGOL[text];
      break;
  }
}

String _DecodeAZ(TeletypewriterCodebook language, int code) {
  switch (language) {
    case TeletypewriterCodebook.BAUDOT:
      return CCITT_BAUDOTToAZ[code];
      break;
    case TeletypewriterCodebook.MURRAY:
      return MurrayToAZ[code];
      break;
    case TeletypewriterCodebook.SIEMENS:
      return SiemensToAZ[code];
      break;
    case TeletypewriterCodebook.WESTERNUNION:
      return WesternunionToAZ[code];
      break;
    case TeletypewriterCodebook.BAUDOT_54123:
      return Baudot_54123ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1926:
      return CCITT_ITA1_1926ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1929:
      return CCITT_ITA1_1929ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_EU:
      return CCITT_ITA1_EUToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      return CCITT_ITA1_UKToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1929:
      return CCITT_ITA2_1929ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.Z22:
      return CCITT_ITA2_1931ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
      return CCITT_ITA2_MTK2ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
      return CCITT_USTTYToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA3:
      return CCITT_ITA3ToAZ[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA4:
      return CCITT_ITA4ToAZ[code];
      break;
    case TeletypewriterCodebook.CCIR476:
      return CCIR476ToAZ[code];
      break;
    case TeletypewriterCodebook.ILLIAC:
      return ILLIACToAZ[code];
      break;
    case TeletypewriterCodebook.TTS:
      return TTSToAZ[code];
      break;
    case TeletypewriterCodebook.ALGOL:
      return ALGOLToAZ[code];
      break;
  }
}

String _DecodeNumber(TeletypewriterCodebook language, int code) {
  switch (language) {
    case TeletypewriterCodebook.BAUDOT:
      return CCITT_BAUDOTToNumbers[code];
      break;
    case TeletypewriterCodebook.MURRAY:
      return MurrayToNumbers[code];
      break;
    case TeletypewriterCodebook.SIEMENS:
      return SiemensToNumbers[code];
      break;
    case TeletypewriterCodebook.WESTERNUNION:
      return WesternunionToNumbers[code];
      break;
    case TeletypewriterCodebook.BAUDOT_54123:
      return Baudot_54123ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1926:
      return CCITT_ITA1_1926ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_1929:
      return CCITT_ITA1_1929ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_EU:
      return CCITT_ITA1_EUToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      return CCITT_ITA1_UKToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1929:
      return CCITT_ITA2_1929ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.Z22:
      return CCITT_ITA2_1931ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
      return CCITT_MTK2ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
      return CCITT_USTTYToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA3:
      return CCITT_ITA3ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCITT_ITA4:
      return CCITT_ITA4ToNumbers[code];
      break;
    case TeletypewriterCodebook.CCIR476:
      return CCIR476ToNumbers[code];
      break;
    case TeletypewriterCodebook.ILLIAC:
      return ILLIACToNumbers[code];
      break;
    case TeletypewriterCodebook.TTS:
      return TTSToNumbers[code];
      break;
    case TeletypewriterCodebook.ALGOL:
      return ALGOLToNumbers[code];
      break;
  }
}

String encodeTeletypewriter(String input, TeletypewriterCodebook language) {
  if (input == null || input.length == 0) return '';

  var isLetterMode = true;

  List<int> out = [];
  switch (language) {
    // CCITT1
    case TeletypewriterCodebook.BAUDOT:
    case TeletypewriterCodebook.BAUDOT_54123:
    case TeletypewriterCodebook.MURRAY:
    case TeletypewriterCodebook.SIEMENS:
    case TeletypewriterCodebook.WESTERNUNION:
    case TeletypewriterCodebook.CCITT_ITA1_1926:
    case TeletypewriterCodebook.CCITT_ITA1_1929:
    case TeletypewriterCodebook.CCITT_ITA1_EU:
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      input = input.toUpperCase().replaceAll(String.fromCharCode(201), String.fromCharCode(0));
      input =
          removeAccents(input).replaceAll(String.fromCharCode(0), String.fromCharCode(201)); // keep É as only accent

      var cachedSpace = false;
      input.split('').forEach((character) {
        if (character == ' ') {
          cachedSpace = true;
          return;
        }

        if (isLetterMode) {
          var code = _EncodeAZ(language, character);
          if (code != null) {
            if (cachedSpace) {
              out.add(_LETTERS_FOLLOW[language]);
              cachedSpace = false;
            }
            return out.add(code);
          }

          code = _EncodeNumber(language, character);
          if (code != null) {
            out.add(_NUMBERS_FOLLOW[language]);
            out.add(code);
            isLetterMode = false;
            cachedSpace = false;
          }
        } else {
          var code = _EncodeNumber(language, character);
          if (code != null) {
            if (cachedSpace) {
              out.add(_NUMBERS_FOLLOW[language]);
              cachedSpace = false;
            }
            return out.add(code);
          }

          code = _EncodeAZ(language, character);
          if (code != null) {
            out.add(_LETTERS_FOLLOW[language]);
            out.add(code);
            isLetterMode = true;
            cachedSpace = false;
          }
        }
      });
      return out.join(' ');
      break;

    // CCITT 2
    case TeletypewriterCodebook.CCITT_ITA2_1929:
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
    case TeletypewriterCodebook.CCITT_ITA3:
    case TeletypewriterCodebook.CCITT_ITA4:
    case TeletypewriterCodebook.CCIR476:
    case TeletypewriterCodebook.ILLIAC:
    case TeletypewriterCodebook.TTS:
    case TeletypewriterCodebook.Z22:
    case TeletypewriterCodebook.ALGOL:
      removeAccents(input.toUpperCase()).split('').forEach((character) {
        if (isLetterMode) {
          var code = _EncodeAZ(language, character);
          if (code != null) return out.add(code);

          code = _EncodeNumber(language, character);
          if (code != null) {
            out.add(_NUMBERS_FOLLOW[language]);
            out.add(code);
            isLetterMode = false;
          }
        } else {
          var code = _EncodeNumber(language, character);
          if (code != null) return out.add(code);

          code = _EncodeAZ(language, character);
          if (code != null) {
            out.add(_LETTERS_FOLLOW[language]);
            out.add(code);
            isLetterMode = true;
          }
        }
      });

      return out.join(' ');
      break;
    case TeletypewriterCodebook.CCITT_IA5:
      return encodeTeletypewriter_IA5(input);
      break;
    case TeletypewriterCodebook.ZC1:
      return encodeTeletypewriter_ZC1(input);
      break;
  }
}

String encodeTeletypewriter_IA5(String input) {
  if (input == null || input.length == 0) return '';

  List<int> out = [];
  input.split('').forEach((character) {
    if (character.codeUnitAt(0) < 128) return out.add(character.codeUnitAt(0));
  });

  return out.join(' ');
}

String encodeTeletypewriter_ZC1(String input) {
  if (input == null || input.length == 0) return '';

  List<int> out = [];
  input.split('').forEach((character) {
    return out.add(AZToZC1[character]);
  });

  return out.join(' ');
}

String decodeTeletypewriter(
  List<int> values,
  TeletypewriterCodebook language,
) {
  if (values == null || values.length == 0) return '';

  String out = '';
  var isLetterMode = true;

  if (language == TeletypewriterCodebook.BAUDOT_54123)
    values = values.map((decimal) {
      return int.parse(convertBase(
          convertBase(decimal.toString(), 10, 2).padLeft(BINARY_LENGTH[language], '0').split('').reversed.join(''),
          2,
          10));
    }).toList();

  switch (language) {
    // CCITT1
    case TeletypewriterCodebook.BAUDOT:
    case TeletypewriterCodebook.MURRAY:
    case TeletypewriterCodebook.SIEMENS:
    case TeletypewriterCodebook.WESTERNUNION:
    case TeletypewriterCodebook.BAUDOT_54123:
    case TeletypewriterCodebook.CCITT_ITA1_1926:
    case TeletypewriterCodebook.CCITT_ITA1_1929:
    case TeletypewriterCodebook.CCITT_ITA1_EU:
    case TeletypewriterCodebook.CCITT_ITA1_UK:
      values.forEach((value) {
        if (value == _NUMBERS_FOLLOW[language]) {
          if (out.length > 0) out += ' ';
          isLetterMode = false;
          return;
        }

        if (value == _LETTERS_FOLLOW[language]) {
          out += ' ';
          isLetterMode = true;
          return;
        }

        if (isLetterMode) {
          out += _DecodeAZ(language, value) ?? '';
        } else {
          out += _DecodeNumber(language, value) ?? '';
        }
      });

      return out;
      break;

    // CCITT 2
    case TeletypewriterCodebook.CCITT_ITA2_1929:
    case TeletypewriterCodebook.CCITT_ITA2_1931:
    case TeletypewriterCodebook.CCITT_ITA2_MTK2:
    case TeletypewriterCodebook.CCITT_ITA2_USTTY:
    case TeletypewriterCodebook.CCITT_ITA3:
    case TeletypewriterCodebook.CCITT_ITA4:
    case TeletypewriterCodebook.CCIR476:
    case TeletypewriterCodebook.Z22:
    case TeletypewriterCodebook.ILLIAC:
    case TeletypewriterCodebook.TTS:
    case TeletypewriterCodebook.ALGOL:
      values.forEach((value) {
        if (value == _NUMBERS_FOLLOW[language]) {
          isLetterMode = false;
          return;
        }

        if (value == _LETTERS_FOLLOW[language]) {
          isLetterMode = true;
          return;
        }

        if (isLetterMode) {
          out += _DecodeAZ(language, value) ?? '';
        } else {
          out += _DecodeNumber(language, value) ?? '';
        }
      });

      return out;
      break;
    case TeletypewriterCodebook.CCITT_IA5:
      return decodeTeletypewriter_IA5(values);
      break;
    case TeletypewriterCodebook.ZC1:
      return decodeTeletypewriter_ZC1(values);
      break;
  }
}

String decodeTeletypewriter_IA5(List<int> values) {
  if (values == null || values.length == 0) return '';

  String out = '';

  values.forEach((value) {
    if (value < 128) out = out + String.fromCharCode(value);
  });

  return out;
}

String decodeTeletypewriter_ZC1(List<int> values) {
  if (values == null || values.length == 0) return '';

  String out = '';
  values.forEach((value) {
    if (ZC1ToAZ[value] != null) out = out + ZC1ToAZ[value];
  });

  return out;
}
