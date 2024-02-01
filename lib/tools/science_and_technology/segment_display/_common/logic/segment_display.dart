import 'dart:core';

import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:tuple/tuple.dart';
import 'package:utility/utility.dart';

enum SegmentDisplayType {
  SEVEN,
  FOURTEEN,
  SIXTEEN,
  CUSTOM,
  SEVENAUTO,
  SEVEN12345678,
  FOURTEENAUTO,
  FOURTEEN_HIJ_G1G2_MLK,
  FOURTEEN_PGH_NJ_MLK,
  FOURTEEN_KMN_G1G2_RST,
  FOURTEEN_GHJ_PK_NMI,
  FOURTEEN_HJK_G1G2_NML,
  FOURTEEN_HJK_GM_QPN,
  SIXTEENAUTO,
  SIXTEEN_KMN_UP_TSR
}

const Variants7Segment = {SegmentDisplayType.SEVEN, SegmentDisplayType.SEVENAUTO, SegmentDisplayType.SEVEN12345678};
const Variants14Segment = {
  SegmentDisplayType.FOURTEEN,
  SegmentDisplayType.FOURTEENAUTO,
  SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK,
  SegmentDisplayType.FOURTEEN_PGH_NJ_MLK,
  SegmentDisplayType.FOURTEEN_KMN_G1G2_RST,
  SegmentDisplayType.FOURTEEN_GHJ_PK_NMI,
  SegmentDisplayType.FOURTEEN_HJK_G1G2_NML,
  SegmentDisplayType.FOURTEEN_HJK_GM_QPN
};
const Variants16Segment = {
  SegmentDisplayType.SIXTEEN,
  SegmentDisplayType.SIXTEENAUTO,
  SegmentDisplayType.SIXTEEN_KMN_UP_TSR
};

const _baseSegments7Segment = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'dp'];
const _baseSegments14Segment = ['a', 'b', 'c', 'd', 'e', 'f', 'g1', 'g2', 'h', 'i', 'j', 'k', 'l', 'm', 'dp'];
const _baseSegments16Segment = [
  'a1',
  'a2',
  'b',
  'c',
  'd1',
  'd2',
  'e',
  'f',
  'g1',
  'g2',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'dp'
];

//variants
const _7SegmentTo12345678 = {'1': 'a', '2': 'b', '3': 'c', '4': 'd', '5': 'e', '6': 'f', '7': 'g', '8': 'dp'};

const _14SegmentTo_hij_g1g2_mlk = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'g1': 'g1',
  'g2': 'g2',
  'h': 'h',
  'i': 'i',
  'j': 'j',
  'k': 'm',
  'l': 'l',
  'm': 'k',
  'dp': 'dp'
};
const _14SegmentTo_pgh_nj_mlk = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'n': 'g1',
  'j': 'g2',
  'p': 'h',
  'g': 'i',
  'h': 'j',
  'm': 'k',
  'l': 'l',
  'k': 'm',
  'dp1': 'dp'
};
const _14SegmentTo_kmn_g1g2_rst = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'g1': 'g1',
  'g2': 'g2',
  'k': 'h',
  'm': 'i',
  'n': 'j',
  't': 'm',
  's': 'l',
  'r': 'k',
  'dp': 'dp'
};
const _14SegmentTo_ghj_pk_nmi = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'p': 'g1',
  'k': 'g2',
  'g': 'h',
  'h': 'i',
  'j': 'j',
  'i': 'm',
  'm': 'l',
  'n': 'k',
  'dp': 'dp'
};
const _14SegmentTo_hjk_g1g2_nml = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'g1': 'g1',
  'g2': 'g2',
  'h': 'h',
  'j': 'i',
  'k': 'j',
  'l': 'm',
  'm': 'l',
  'n': 'k',
  'dp': 'dp'
};
const _14SegmentTo_hjk_gm_qpn = {
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'g': 'g1',
  'm': 'g2',
  'h': 'h',
  'j': 'i',
  'k': 'j',
  'n': 'm',
  'p': 'l',
  'q': 'k',
  'dp': 'dp'
};

const _16SegmentTo_kmn_up_tsr = {
  'a': 'a1',
  'b': 'a2',
  'c': 'b',
  'd': 'c',
  'e': 'd1',
  'f': 'd2',
  'g': 'e',
  'h': 'f',
  'u': 'g1',
  'p': 'g2',
  'k': 'h',
  'm': 'i',
  'n': 'j',
  't': 'k',
  's': 'l',
  'r': 'm',
  'dp': 'dp'
};

final _7SegmentVariants = {
  SegmentDisplayType.SEVEN: _createBaseVariant(_baseSegments7Segment),
  SegmentDisplayType.SEVEN12345678: _7SegmentTo12345678
};

final _14SegmentVariants = {
  SegmentDisplayType.FOURTEEN: _createBaseVariant(_baseSegments14Segment),
  SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK: _14SegmentTo_hij_g1g2_mlk,
  SegmentDisplayType.FOURTEEN_PGH_NJ_MLK: _14SegmentTo_pgh_nj_mlk,
  SegmentDisplayType.FOURTEEN_KMN_G1G2_RST: _14SegmentTo_kmn_g1g2_rst,
  SegmentDisplayType.FOURTEEN_GHJ_PK_NMI: _14SegmentTo_ghj_pk_nmi,
  SegmentDisplayType.FOURTEEN_HJK_G1G2_NML: _14SegmentTo_hjk_g1g2_nml,
  SegmentDisplayType.FOURTEEN_HJK_GM_QPN: _14SegmentTo_hjk_gm_qpn
};

final _16SegmentVariants = {
  SegmentDisplayType.SIXTEEN: _createBaseVariant(_baseSegments16Segment),
  SegmentDisplayType.SIXTEEN_KMN_UP_TSR: _16SegmentTo_kmn_up_tsr
};

const Map<String, List<String>> _AZTo16Segment = {
  '1': ['b', 'c', 'j'],
  '2': ['a1', 'a2', 'b', 'd1', 'd2', 'e', 'g1', 'g2'],
  '3': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g1', 'g2'],
  '4': ['b', 'c', 'f', 'g1', 'g2'],
  '5': ['a1', 'a2', 'c', 'd1', 'd2', 'f', 'g1', 'g2'],
  '6': ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2'],
  '7': ['a1', 'a2', 'j', 'k'],
  '8': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2'],
  '9': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'f', 'g1', 'g2'],
  '0': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'j', 'k'],
  'A': ['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2'],
  'B': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2', 'i', 'l'],
  'C': ['a1', 'a2', 'd1', 'd2', 'e', 'f'],
  'D': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'i', 'l'],
  'E': ['a1', 'a2', 'd1', 'd2', 'e', 'f', 'g1'],
  'F': ['a1', 'a2', 'e', 'f', 'g1'],
  'G': ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f', 'g2'],
  'H': ['b', 'c', 'e', 'f', 'g1', 'g2'],
  'I': ['a1', 'a2', 'd1', 'd2', 'i', 'l'],
  'J': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e'],
  'K': ['e', 'f', 'g1', 'j', 'm'],
  'L': ['d1', 'd2', 'e', 'f'],
  'M': ['b', 'c', 'e', 'f', 'h', 'j'],
  'N': ['b', 'c', 'e', 'f', 'h', 'm'],
  'O': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f'],
  'P': ['a1', 'a2', 'b', 'e', 'f', 'g1', 'g2'],
  'Q': ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'm'],
  'R': ['a1', 'a2', 'b', 'e', 'f', 'g1', 'g2', 'm'],
  'S': ['a1', 'a2', 'c', 'd1', 'd2', 'g2', 'h'],
  'T': ['a1', 'a2', 'i', 'l'],
  'U': ['b', 'c', 'd1', 'd2', 'e', 'f'],
  'V': ['e', 'f', 'j', 'k'],
  'W': ['b', 'c', 'e', 'f', 'k', 'm'],
  'X': ['h', 'j', 'k', 'm'],
  'Y': ['h', 'j', 'l'],
  'Z': ['a1', 'a2', 'd1', 'd2', 'j', 'k'],
  '_': ['d1', 'd2'],
  '-': ['g1', 'g2'],
  '=': ['d1', 'd2', 'g1', 'g2'],
  '°': ['a1', 'f', 'g1', 'i'],
  '"': ['f', 'j'],
  '\'': ['j'],
  '(': ['j', 'm'],
  '<': ['j', 'm'],
  '[': ['a2', 'd2', 'i', 'l'],
  ')': ['h', 'k'],
  '>': ['h', 'k'],
  ']': ['a1', 'd1', 'i', 'l'],
  '?': ['a1', 'a2', 'b', 'f', 'g2', 'k'],
  '\$': ['a1', 'a2', 'c', 'd1', 'd2', 'f', 'g1', 'g2', 'i', 'l'],
  '/': ['j', 'k'],
  '\\': ['h', 'm'],
  '+': ['g1', 'g2', 'i', 'l'],
  '*': ['g1', 'g2', 'h', 'i', 'j', 'k', 'l', 'm'],
  '%': ['a1', 'c', 'd2', 'f', 'g1', 'g2', 'i', 'j', 'k', 'l'],
  ' ': [],
  ',': ['k'],
  'ß': ['a1', 'a2', 'c', 'e', 'f', 'g2', 'j'],
  '&': ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'g1', 'h', 'j', 'm']
};

const Map<String, List<String>> _AZTo14Segment = {
  '1': ['b', 'c', 'j'],
  '2': ['a', 'b', 'd', 'e', 'g1', 'g2'],
  '3': ['a', 'b', 'c', 'd', 'g1', 'g2'],
  '4': ['b', 'c', 'f', 'g1', 'g2'],
  '5': ['a', 'c', 'd', 'f', 'g1', 'g2'],
  '6': ['a', 'c', 'd', 'e', 'f', 'g1', 'g2'],
  '7': ['a', 'j', 'k'],
  '8': ['a', 'b', 'c', 'd', 'e', 'f', 'g1', 'g2'],
  '9': ['a', 'b', 'c', 'd', 'f', 'g1', 'g2'],
  '0': ['a', 'b', 'c', 'd', 'e', 'f', 'j', 'k'],
  'A': ['a', 'b', 'c', 'e', 'f', 'g1', 'g2'],
  'B': ['a', 'b', 'c', 'd', 'g2', 'i', 'l'],
  'C': ['a', 'd', 'e', 'f'],
  'D': ['a', 'b', 'c', 'd', 'i', 'l'],
  'E': ['a', 'd', 'e', 'f', 'g1'],
  'F': ['a', 'e', 'f', 'g1'],
  'G': ['a', 'c', 'd', 'e', 'f', 'g2'],
  'H': ['b', 'c', 'e', 'f', 'g1', 'g2'],
  'I': ['a', 'd', 'i', 'l'],
  'J': ['a', 'b', 'c', 'd', 'e'],
  'K': ['e', 'f', 'g1', 'j', 'm'],
  'L': ['d', 'e', 'f'],
  'M': ['b', 'c', 'e', 'f', 'h', 'j'],
  'N': ['b', 'c', 'e', 'f', 'h', 'm'],
  'O': ['a', 'b', 'c', 'd', 'e', 'f'],
  'P': ['a', 'b', 'e', 'f', 'g1', 'g2'],
  'Q': ['a', 'b', 'c', 'd', 'e', 'f', 'm'],
  'R': ['a', 'b', 'e', 'f', 'g1', 'g2', 'm'],
  'S': ['a', 'c', 'd', 'g2', 'h'],
  'T': ['a', 'i', 'l'],
  'U': ['b', 'c', 'd', 'e', 'f'],
  'V': ['e', 'f', 'j', 'k'],
  'W': ['b', 'c', 'e', 'f', 'k', 'm'],
  'X': ['h', 'j', 'k', 'm'],
  'Y': ['h', 'j', 'l'],
  'Z': ['a', 'd', 'j', 'k'],
  '_': ['d'],
  '-': ['g1', 'g2'],
  '=': ['d', 'g1', 'g2'],
  '°': ['a', 'f', 'g1', 'g2', 'i'],
  '"': ['f', 'j'],
  '\'': ['j'],
  '(': ['j', 'm'],
  '<': ['j', 'm'],
  ')': ['h', 'k'],
  '>': ['h', 'k'],
  '[': ['a', 'd', 'e', 'f'],
  ']': ['a', 'b', 'c', 'd'],
  '?': ['a', 'b', 'f', 'g2', 'k'],
  '/': ['j', 'k'],
  '\\': ['h', 'm'],
  '+': ['g1', 'g2', 'i', 'l'],
  '*': ['g1', 'g2', 'h', 'i', 'j', 'k', 'l', 'm'],
  '\$': ['a', 'c', 'd', 'f', 'g1', 'g2', 'i', 'l'],
  ' ': [],
  ',': ['k'],
  'ß': ['a', 'c', 'e', 'f', 'g2', 'j'],
  '&': ['a', 'c', 'd', 'e', 'g1', 'h', 'j', 'm']
};

const Map<String, List<String>> _AZTo7Segment = {
  // https://www.wikizero.com/en/Seven-segment_display
  '1': ['b', 'c'], //'1' : ['a','e'],
  '2': ['a', 'b', 'd', 'e', 'g'],
  '3': ['a', 'b', 'c', 'd', 'g'],
  '4': ['b', 'c', 'f', 'g'],
  '5': ['a', 'c', 'd', 'f', 'g'],
  '6': ['a', 'c', 'd', 'e', 'f', 'g'], //'6' : ['c','d','e','f','g'],
  '7': ['a', 'b', 'c'], //'7' : ['a','b','c','f'],
  '8': ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
  '9': ['a', 'b', 'c', 'd', 'f', 'g'], //'9' : ['a','b','c','f','g'],
  '0': ['a', 'b', 'c', 'd', 'e', 'f'],
  'A': ['a', 'b', 'c', 'e', 'f', 'g'],
  'B': ['c', 'd', 'e', 'f', 'g'],
  'C': ['a', 'd', 'e', 'f'], //'C' : ['d','e','g'],
  'D': ['b', 'c', 'd', 'e', 'g'],
  'E': ['a', 'd', 'e', 'f', 'g'],
  'F': ['a', 'e', 'f', 'g'],
  'G': ['a', 'c', 'd', 'e', 'f'],
  'H': ['b', 'c', 'e', 'f', 'g'], //'H' : ['c','e','f','g']
  'I': ['e', 'f'],
  'J': ['a', 'b', 'c', 'd', 'e'],
  'L': ['d', 'e', 'f'],
  'N': ['a', 'b', 'c', 'e', 'f'],
  'O': ['c', 'd', 'e', 'g'],
  'P': ['a', 'b', 'e', 'f', 'g'],
  'Q': ['a', 'b', 'c', 'f', 'g'],
  'R': ['e', 'g'],
  'S': ['a', 'c', 'd', 'f', 'g'],
  'T': ['d', 'e', 'f', 'g'],
  'U': ['b', 'c', 'd', 'e', 'f'], //'U'  : ['c','d','e'],
  'Y': ['b', 'c', 'd', 'f', 'g'],
  '_': ['d'],
  '-': ['g'],
  '=': ['d', 'g'],
  '°': ['a', 'b', 'f', 'g'],
  '"': ['b', 'f'],
  '\'': ['f'], //'\'' : ['b'],
  '(': ['a', 'd', 'e', 'f'],
  '[': ['a', 'd', 'e', 'f'],
  ')': ['a', 'b', 'c', 'd'],
  ']': ['a', 'b', 'c', 'd'],
  '?': ['a', 'b', 'e', 'g'],
  ' ': []
};

const Map<List<String>, String> _Segment7ToAZ = {
  ['b', 'c']: '1',
  ['a', 'b', 'd', 'e', 'g']: '2',
  ['a', 'b', 'c', 'd', 'g']: '3',
  ['b', 'c', 'f', 'g']: '4',
  ['a', 'c', 'd', 'f', 'g']: '5',
  ['a', 'c', 'd', 'e', 'f', 'g']: '6',
  ['a', 'b', 'c']: '7',
  ['a', 'b', 'c', 'f']: '7',
  ['a', 'b', 'c', 'd', 'e', 'f', 'g']: '8',
  ['a', 'b', 'c', 'd', 'f', 'g']: '9',
  ['a', 'b', 'c', 'd', 'e', 'f']: '0',
  ['a', 'b', 'c', 'e', 'f', 'g']: 'A',
  ['c', 'd', 'e', 'f', 'g']: 'B',
  ['a', 'd', 'e', 'f']: 'C',
  ['d', 'e', 'g']: 'C',
  ['b', 'c', 'd', 'e', 'g']: 'D',
  ['a', 'd', 'e', 'f', 'g']: 'E',
  ['a', 'e', 'f', 'g']: 'F',
  ['a', 'c', 'd', 'e', 'f']: 'G',
  ['b', 'c', 'e', 'f', 'g']: 'H',
  ['c', 'e', 'f', 'g']: 'H',
  ['e', 'f']: 'I',
  ['c']: 'I',
  ['e']: 'I',
  ['a', 'b', 'c', 'd', 'e']: 'J',
  ['b', 'c', 'd', 'e']: 'J',
  ['d', 'e', 'f']: 'L',
  ['c', 'e', 'g']: 'N',
  ['a', 'b', 'c', 'e', 'f']: 'N',
  ['c', 'd', 'e', 'g']: 'O',
  ['a', 'b', 'e', 'f', 'g']: 'P',
  ['a', 'b', 'c', 'f', 'g']: 'Q',
  ['e', 'g']: 'R',
  //['a', 'c', 'd', 'f', 'g'] : 'S',
  ['d', 'e', 'f', 'g']: 'T',
  ['b', 'c', 'd', 'e', 'f']: 'U',
  ['c', 'd', 'e']: 'U',
  ['b', 'c', 'd', 'f', 'g']: 'Y',
  ['d']: '_',
  ['g']: '-',
  ['d', 'g']: '=',
  ['a', 'g']: '=',
  ['a', 'b', 'f', 'g']: '°',
  ['b', 'f']: '"',
  ['f']: '\'',
  ['b']: '\'',
  //['a', 'd', 'e', 'f'] : '(',
  ['a', 'b', 'c', 'd']: ')',
  // ['a', 'b', 'c', 'd'] : ']',
  //['a', 'd', 'e', 'f'] : 'C',
  ['a', 'b', 'e', 'g']: '?',
  []: ' '
};

const Map<List<String>, String> _Segment14ToAZ = {
  ['b', 'c', 'j']: '1',
  ['b', 'c']: '1',
  ['a', 'b', 'd', 'e', 'g1', 'g2']: '2',
  ['a', 'd', 'e', 'g1', 'j']: '2',
  ['a', 'b', 'c', 'd', 'g1', 'g2']: '3',
  ['a', 'b', 'c', 'd', 'g2']: '3',
  ['a', 'c', 'd', 'g2', 'j']: '3',
  ['b', 'c', 'f', 'g1', 'g2']: '4',
  ['f', 'g1', 'g2', 'i', 'l']: '4',
  ['a', 'c', 'd', 'f', 'g1', 'g2']: '5',
  ['a', 'c', 'd', 'e', 'f', 'g1', 'g2']: '6',
  ['a', 'j', 'k']: '7',
  ['a', 'j', 'l']: '7',
  ['a', 'b', 'c']: '7',
  ['a', 'b', 'c', 'f']: '7',
  ['a', 'g1', 'g2', 'j', 'k']: '7',
  ['a', 'b', 'c', 'd', 'e', 'f', 'g1', 'g2']: '8',
  ['a', 'b', 'c', 'd', 'f', 'g1', 'g2']: '9',
  ['a', 'b', 'c', 'd', 'e', 'f', 'j', 'k']: '0',
  ['a', 'b', 'c', 'e', 'f', 'g1', 'g2']: 'A',
  ['a', 'b', 'c', 'd', 'e', 'g1', 'g2']: 'A',
  ['a', 'b', 'c', 'd', 'g2', 'i', 'l']: 'B',
  ['c', 'd', 'e', 'f', 'g1', 'g2']: 'B',
  ['a', 'c', 'd', 'e', 'f', 'g1', 'g2', 'j']: 'B',
  ['a', 'd', 'e', 'f']: 'C',
  ['d', 'e', 'g1', 'g2']: 'C',
  ['a', 'b', 'c', 'd', 'i', 'l']: 'D',
  ['b', 'c', 'd', 'e', 'g1', 'g2']: 'D',
  ['b', 'c', 'd2', 'g2', 'l']: 'D',
  ['a', 'd', 'e', 'f', 'g1', 'g2']: 'E',
  ['a', 'd', 'e', 'f', 'g1']: 'E',
  ['a', 'b', 'd', 'e', 'f', 'g1', 'g2']: 'E',
  ['a', 'e', 'f', 'g1']: 'F',
  ['a', 'e', 'f', 'g1', 'g2']: 'F',
  ['a', 'c', 'd', 'e', 'f', 'g2']: 'G',
  ['a', 'c', 'd', 'e', 'f']: 'G',
  ['b', 'c', 'e', 'f', 'g1', 'g2']: 'H',
  ['c', 'e', 'f', 'g1', 'g2']: 'H',
  ['e', 'f', 'g1', 'i', 'l']: 'H',
  ['e', 'f', 'g1', 'i']: 'H',
  ['a', 'd', 'i', 'l']: 'I',
  ['a', 'b', 'c', 'd', 'e']: 'J',
  ['b', 'c', 'd', 'e']: 'J',
  ['e', 'f', 'g1', 'j', 'm']: 'K',
  ['e', 'f', 'g1', 'g2', 'm']: 'K',
  ['d', 'e', 'f']: 'L',
  ['b', 'c', 'e', 'f', 'h', 'j']: 'M',
  ['b', 'c', 'e', 'f', 'h', 'j', 'l']: 'M',
  ['c', 'e', 'g1', 'g2', 'l']: 'M',
  ['b', 'c', 'e', 'f', 'h', 'm']: 'N',
  ['c', 'e', 'g1', 'g2']: 'N',
  ['e', 'g1', 'l']: 'N',
  ['c', 'd', 'e', 'g1', 'g2']: 'O',
  ['a', 'b', 'c', 'd', 'e', 'f']: 'O',
  ['a', 'b', 'e', 'f', 'g1', 'g2']: 'P',
  ['a', 'e', 'f', 'g1', 'j']: 'P',
  ['a', 'b', 'c', 'd', 'e', 'f', 'm']: 'Q',
  ['a', 'b', 'c', 'g2', 'h']: 'Q',
  ['a', 'b', 'e', 'f', 'g1', 'g2', 'm']: 'R',
  ['e', 'g1', 'g2']: 'R',
  ['e', 'g1']: 'R',
  ['a', 'c', 'd', 'g2', 'h']: 'S',
  ['d', 'g2', 'm']: 'S',
  ['a', 'i', 'l']: 'T',
  ['d', 'e', 'f', 'g1', 'g2']: 'T',
  ['b', 'c', 'd', 'e', 'f']: 'U',
  ['c', 'd', 'e']: 'U',
  ['e', 'f', 'j', 'k']: 'V',
  ['e', 'k']: 'V',
  ['c', 'm']: 'V',
  ['b', 'c', 'h', 'm']: 'V',
  ['b', 'c', 'e', 'f', 'k', 'm']: 'W',
  ['b', 'c', 'd', 'e', 'f', 'i', 'l']: 'W',
  ['b', 'c', 'e', 'f', 'i', 'k', 'm']: 'W',
  ['c', 'e', 'k', 'm']: 'W',
  ['c', 'd', 'e', 'l']: 'W',
  ['h', 'j', 'k', 'm']: 'X',
  ['h', 'j', 'l']: 'Y',
  ['b', 'c', 'd', 'f', 'g1', 'g2']: 'Y',
  ['b', 'c', 'd', 'g2', 'h']: 'Y',
  ['b', 'f', 'g1', 'g2', 'l']: 'Y',
  ['a', 'd', 'j', 'k']: 'Z',
  ['a', 'd', 'g1', 'g2', 'j', 'k']: 'Z',
  ['d', 'g1', 'k']: 'Z',
  ['d']: '_',
  ['g1', 'g2']: '-',
  ['g1']: '-',
  ['g2']: '-',
  ['d', 'g1', 'g2']: '=',
  ['a', 'g1', 'g2']: '=',
  ['a', 'f', 'g1', 'g2', 'i']: '°',
  ['f', 'i']: '"',
  ['f', 'j']: '"',
  ['b', 'i']: '"',
  ['b', 'f']: '"',
  ['f']: '\'',
  ['i']: '\'',
  ['j']: '\'',
  ['b']: '\'',
  ['j', 'm']: '(',
  ['h', 'k']: ')',
  ['j', 'k']: '/',
  ['h', 'm']: '\\',
  ['g1', 'g2', 'i', 'l']: '+',
  ['g1', 'g2', 'h', 'i', 'j', 'k', 'l', 'm']: '*',
  ['a', 'c', 'd', 'f', 'g1', 'g2', 'i', 'l']: '\$',
  ['a', 'b', 'g2', 'l']: '?',
  ['a', 'b', 'f', 'g2', 'l']: '?',
  ['a', 'b', 'g2', 'k']: '?',
  ['a', 'b', 'f', 'g2', 'k']: '?',
  ['a', 'b', 'e', 'g1', 'g2']: '?',
  ['a', 'b', 'c', 'd']: ']',
  []: ' ',
  ['a', 'c', 'e', 'f', 'g2', 'j']: 'ß',
  ['a', 'c', 'd', 'e', 'g1', 'h', 'j', 'm']: '&',
  ['c', 'f', 'g1', 'g2', 'h', 'j', 'k', 'm']: '%',
  ['k']: ',',
  ['l']: ',',
  ['m']: '.', //acc. to Kenwood Car Hifi Display
};

const Map<List<String>, String> _Segment16ToAZ = {
  ['a1', 'i', 'l']: '1',
  ['a1', 'd1', 'd2', 'i', 'l']: '1',
  ['b', 'c', 'j']: '1',
  ['b', 'c']: '1',
  ['a1', 'a2', 'b', 'd1', 'd2', 'e', 'g1', 'g2']: '2',
  ['a1', 'a2', 'd1', 'd2', 'e', 'g1', 'j']: '2',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g1', 'g2']: '3',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2']: '3',
  ['a1', 'a2', 'c', 'd1', 'd2', 'g2', 'j']: '3',
  ['b', 'c', 'f', 'g1', 'g2']: '4',
  ['f', 'g1', 'g2', 'i', 'l']: '4',
  ['a1', 'a2', 'c', 'd1', 'd2', 'f', 'g1', 'g2']: '5',
  ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2']: '6',
  ['a1', 'a2', 'j', 'k']: '7',
  ['a1', 'a2', 'j', 'l']: '7',
  ['a1', 'a2', 'b', 'c']: '7',
  ['a1', 'a2', 'b', 'c', 'f']: '7',
  ['a1', 'a2', 'g1', 'g2', 'j', 'k']: '7',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2']: '8',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'f', 'g1', 'g2']: '9',
  ['a1', 'a2', 'b', 'c', 'f', 'g1', 'g2']: '9',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'j', 'k']: '0',
  ['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2']: 'A',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'g1', 'g2']: 'A',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2', 'i', 'l']: 'B',
  ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2', 'j']: 'B',
  ['a1', 'c', 'd1', 'd2', 'e', 'f', 'g1', 'g2', 'i']: 'B',
  ['c', 'd1', 'd2', 'e', 'f', 'g1', 'g2']: 'B',
  ['d1', 'e', 'f', 'g1', 'l']: 'B',
  ['a1', 'a2', 'd1', 'd2', 'e', 'f']: 'C',
  ['d1', 'd2', 'e', 'g1', 'g2']: 'C',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'i', 'l']: 'D',
  ['b', 'c', 'd1', 'd2', 'e', 'g1', 'g2']: 'D',
  ['b', 'c', 'd2', 'g2', 'l']: 'D',
  ['a1', 'a2', 'd1', 'd2', 'e', 'f', 'g1', 'g2']: 'E',
  ['a1', 'a2', 'd1', 'd2', 'e', 'f', 'g1']: 'E',
  ['a1', 'd1', 'e', 'f', 'g1']: 'E',
  ['a1', 'a2', 'b', 'd1', 'd2', 'e', 'f', 'g1', 'g2']: 'E',
  ['a1', 'a2', 'e', 'f', 'g1']: 'F',
  ['a1', 'a2', 'e', 'f', 'g1', 'g2']: 'F',
  ['a2', 'g1', 'g2', 'i', 'l']: 'F',
  ['a1', 'e', 'f', 'g1']: 'F',
  ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f', 'g2']: 'G',
  ['a1', 'a2', 'b', 'c', 'd2', 'f', 'g1', 'g2']: 'G',
  ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'f']: 'G',
  ['b', 'c', 'e', 'f', 'g1', 'g2']: 'H',
  ['c', 'e', 'f', 'g1', 'g2']: 'H',
  ['e', 'f', 'g1', 'i', 'l']: 'H',
  ['e', 'f', 'g1', 'i']: 'H',
  ['a1', 'a2', 'd1', 'd2', 'i', 'l']: 'I',
  ['a1', 'l']: 'I',
  ['a2', 'l']: 'I',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e']: 'J',
  ['a2', 'b', 'c', 'd1', 'd2', 'e']: 'J',
  ['b', 'c', 'd2']: 'J',
  ['b', 'c', 'd1', 'd2', 'e']: 'J',
  ['e', 'f', 'g1', 'j', 'm']: 'K',
  ['e', 'f', 'g1', 'g2', 'm']: 'K',
  ['d1', 'd2', 'e', 'f']: 'L',
  ['d2', 'i', 'l']: 'L',
  ['d1', 'e', 'f']: 'L',
  ['b', 'c', 'e', 'f', 'h', 'j']: 'M',
  ['c', 'e', 'g1', 'g2', 'l']: 'M',
  ['b', 'c', 'e', 'f', 'h', 'j', 'l']: 'M',
  ['b', 'c', 'e', 'f', 'h', 'm']: 'N',
  ['c', 'e', 'g1', 'g2']: 'N',
  ['e', 'g1', 'l']: 'N',
  ['c', 'g2', 'l']: 'N',
  ['c', 'd1', 'd2', 'e', 'g1', 'g2']: 'O',
  ['d1', 'e', 'g1', 'l']: 'O',
  ['c', 'd2', 'g2', 'l']: 'O',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f']: 'O',
  ['a1', 'a2', 'b', 'e', 'f', 'g1', 'g2']: 'P',
  ['a1', 'a2', 'e', 'f', 'g1', 'j']: 'P',
  ['a1', 'a2', 'b', 'c', 'd1', 'd2', 'e', 'f', 'm']: 'Q',
  ['a1', 'a2', 'b', 'c', 'g2', 'h']: 'Q',
  ['a1', 'a2', 'b', 'e', 'f', 'g1', 'g2', 'm']: 'R',
  ['e', 'g1', 'g2']: 'R',
  ['e', 'g1']: 'R',
  ['a1', 'a2', 'c', 'd1', 'd2', 'g2', 'h']: 'S',
  ['d1', 'd2', 'g2', 'm']: 'S',
  ['d2', 'g2', 'm']: 'S',
  ['a1', 'a2', 'i', 'l']: 'T',
  ['d1', 'd2', 'e', 'f', 'g1', 'g2']: 'T',
  ['d2', 'g1', 'g2', 'i', 'l']: 'T',
  ['d1', 'e', 'f', 'g1']: 'T',
  ['b', 'c', 'd1', 'd2', 'e', 'f']: 'U',
  ['c', 'd1', 'd2', 'e']: 'U',
  ['d1', 'e', 'l']: 'U',
  ['c', 'd2', 'l']: 'U',
  ['e', 'f', 'j', 'k']: 'V',
  ['e', 'k']: 'V',
  ['c', 'm']: 'V',
  ['b', 'c', 'h', 'm']: 'V',
  ['b', 'c', 'e', 'f', 'k', 'm']: 'W',
  ['b', 'c', 'd1', 'd2', 'e', 'f', 'i', 'l']: 'W',
  ['b', 'c', 'e', 'f', 'i', 'k', 'm']: 'W',
  ['c', 'd1', 'd2', 'e', 'l']: 'W',
  ['c', 'e', 'k', 'm']: 'W',
  ['h', 'j', 'k', 'm']: 'X',
  ['h', 'j', 'l']: 'Y',
  ['b', 'c', 'd1', 'd2', 'f', 'g1', 'g2']: 'Y',
  ['b', 'c', 'd1', 'd2', 'g2', 'h']: 'Y',
  ['b', 'f', 'g1', 'g2', 'l']: 'Y',
  ['b', 'c', 'd2', 'g2', 'h']: 'Y',
  ['a1', 'a2', 'd1', 'd2', 'j', 'k']: 'Z',
  ['a1', 'a2', 'd1', 'd2', 'g1', 'g2', 'j', 'k']: 'Z',
  ['d1', 'd2', 'g1', 'k']: 'Z',
  ['d1', 'g1', 'k']: 'Z',
  ['d1', 'd2']: '_',
  ['g1', 'g2']: '-',
  ['g1']: '-',
  ['g2']: '-',
  ['d1', 'd2', 'g1', 'g2']: '=',
  ['a1', 'a2', 'g1', 'g2']: '=',
  ['a1', 'a2', 'b', 'f', 'g1', 'g2']: '°',
  ['a1', 'f', 'g1', 'i']: '°',
  ['a2', 'b', 'g2', 'i']: '°',
  ['f', 'i']: '"',
  ['f', 'j']: '"',
  ['b', 'i']: '"',
  ['b', 'f']: '"',
  ['f']: '\'',
  ['i']: '\'',
  ['j']: '\'',
  ['b']: '\'',
  ['a2', 'd2', 'i', 'l']: '[',
  ['a1', 'd1', 'i', 'l']: ']',
  ['j', 'm']: '(',
  ['h', 'k']: ')',
  ['j', 'k']: '/',
  ['h', 'm']: '\\',
  ['g1', 'g2', 'i', 'l']: '+',
  ['g1', 'g2', 'h', 'i', 'j', 'k', 'l', 'm']: '*',
  ['a1', 'a2', 'c', 'd1', 'd2', 'f', 'g1', 'g2', 'i', 'l']: '\$',
  ['a1', 'a2', 'b', 'g2', 'l']: '?',
  ['a1', 'a2', 'b', 'f', 'g2', 'l']: '?',
  ['a1', 'a2', 'b', 'g2', 'k']: '?',
  ['a1', 'a2', 'b', 'f', 'g2', 'k']: '?',
  ['a1', 'a2', 'b', 'e', 'g1', 'g2']: '?',
  ['a1', 'c', 'd2', 'f', 'g1', 'g2', 'i', 'j', 'k', 'l']: '%',
  ['c', 'f', 'g1', 'g2', 'h', 'j', 'k', 'm']: '%',
  []: ' ',
  ['a1', 'a2', 'c', 'e', 'f', 'g2', 'j']: 'ß',
  ['a1', 'a2', 'c', 'd1', 'd2', 'e', 'g1', 'h', 'j', 'm']: '&',
  ['d1', 'e', 'f', 'g1', 'g2', 'i', 'l']: '&',
  ['k']: ',',
  ['l']: ',',
  ['m']: '.', //acc. to Kenwood Car Hifi Display
};

class Segments {
  final List<List<String>> displays;

  Segments({required this.displays});

  void addEmptySegment() {
    displays.add([]);
  }

  void addSegment(List<String>? segment) {
    if (segment != null) displays.add(segment);
  }

  void addSegments(List<List<String>>? segments) {
    if (segments != null) displays.addAll(segments);
  }

  void removeLastSegment() {
    if (displays.isNotEmpty) displays.removeLast();
  }

  void replaceLastSegment(List<String> newSegments, {String? trailingDisplay}) {
    newSegments.sort();
    if (trailingDisplay != null) newSegments.add(trailingDisplay);

    if (displays.isEmpty) displays.add([]);
    displays[displays.length - 1] = newSegments;
  }

  List<String> buildOutput() {
    return displays.map((character) {
      return character.join();
    }).toList();
  }

  static Segments Empty() {
    return Segments(displays: []);
  }
}

class SegmentsText extends Segments {
  final String text;

  SegmentsText({required List<List<String>> displays, required this.text}) : super(displays: displays);
}

class SegmentsCodpoints extends SegmentsText {
  final String codepoints;

  SegmentsCodpoints({required List<List<String>> displays, required String text, required this.codepoints})
      : super(displays: displays, text: text);
}

class SegmentsChars extends Segments {
  final List<String> chars;

  SegmentsChars({required List<List<String>> displays, required this.chars}) : super(displays: displays);
}

class SegmentsVigesimal extends Segments {
  final List<int> numbers;
  final BigInt vigesimal;

  SegmentsVigesimal({required List<List<String>> displays, required this.numbers, required this.vigesimal})
      : super(displays: displays);
}

class SegmentsSexagesimal extends Segments {
  final List<int> numbers;
  final BigInt sexagesimal;

  SegmentsSexagesimal({required List<List<String>> displays, required this.numbers, required this.sexagesimal})
      : super(displays: displays);
}

Segments encodeSegment(String input, SegmentDisplayType segmentType) {
  if (input.isEmpty) return Segments.Empty();

  Map<String, List<String>> AZToSegment = {};
  switch (segmentType) {
    case SegmentDisplayType.SEVEN:
      AZToSegment = _AZTo7Segment;
      break;
    case SegmentDisplayType.SEVEN12345678:
      AZToSegment = _convertCharacterMap(_AZTo7Segment, _7SegmentVariants[SegmentDisplayType.SEVEN12345678]!);
      break;
    case SegmentDisplayType.FOURTEEN:
      AZToSegment = _AZTo14Segment;
      break;
    case SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK]!);
      break;
    case SegmentDisplayType.FOURTEEN_PGH_NJ_MLK:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_PGH_NJ_MLK]!);
      break;
    case SegmentDisplayType.FOURTEEN_KMN_G1G2_RST:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_KMN_G1G2_RST]!);
      break;
    case SegmentDisplayType.FOURTEEN_GHJ_PK_NMI:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_GHJ_PK_NMI]!);
      break;
    case SegmentDisplayType.FOURTEEN_HJK_G1G2_NML:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_HJK_G1G2_NML]!);
      break;
    case SegmentDisplayType.FOURTEEN_HJK_GM_QPN:
      AZToSegment = _convertCharacterMap(_AZTo14Segment, _14SegmentVariants[SegmentDisplayType.FOURTEEN_HJK_GM_QPN]!);
      break;
    case SegmentDisplayType.SIXTEEN:
      AZToSegment = _AZTo16Segment;
      break;
    case SegmentDisplayType.SIXTEEN_KMN_UP_TSR:
      AZToSegment = _convertCharacterMap(_AZTo16Segment, _16SegmentVariants[SegmentDisplayType.SIXTEEN_KMN_UP_TSR]!);
      break;
    default:
  }

  var inputCharacters = input.toUpperCase().split('').toList();
  List<List<String>> output = [];

  for (String character in inputCharacters) {
    if (['.', ','].contains(character)) {
      if (output.isEmpty || output.last.contains('dp')) {
        output.add(['dp']);
      } else {
        var prevCharacter = List<String>.from(output.removeLast());
        prevCharacter.add('dp');
        output.add(prevCharacter);
      }
    } else {
      var display = AZToSegment[character];
      if (display != null) output.add(display);
    }
  }

  return Segments(displays: output);
}

SegmentsText decodeSegment(String input, SegmentDisplayType segmentType) {
  if (input.isEmpty) return SegmentsText(displays: [], text: '');
  Map<String, String> baseSegments = {};

  switch (segmentType) {
    case SegmentDisplayType.SEVEN:
      baseSegments = _createBaseVariant(_baseSegments7Segment);
      break;
    case SegmentDisplayType.SEVENAUTO:
      baseSegments = _detectVariant(input, _7SegmentVariants.values);
      break;
    case SegmentDisplayType.SEVEN12345678:
      baseSegments = _7SegmentVariants[SegmentDisplayType.SEVEN12345678]!;
      break;
    case SegmentDisplayType.FOURTEEN:
      baseSegments = _createBaseVariant(_baseSegments14Segment);
      break;
    case SegmentDisplayType.FOURTEENAUTO:
      baseSegments = _detectVariant(input, _14SegmentVariants.values);
      break;
    case SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK]!;
      break;
    case SegmentDisplayType.FOURTEEN_PGH_NJ_MLK:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_PGH_NJ_MLK]!;
      break;
    case SegmentDisplayType.FOURTEEN_KMN_G1G2_RST:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_KMN_G1G2_RST]!;
      break;
    case SegmentDisplayType.FOURTEEN_GHJ_PK_NMI:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_GHJ_PK_NMI]!;
      break;
    case SegmentDisplayType.FOURTEEN_HJK_G1G2_NML:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_HJK_G1G2_NML]!;
      break;
    case SegmentDisplayType.FOURTEEN_HJK_GM_QPN:
      baseSegments = _14SegmentVariants[SegmentDisplayType.FOURTEEN_HJK_GM_QPN]!;
      break;
    case SegmentDisplayType.SIXTEEN:
      baseSegments = _createBaseVariant(_baseSegments16Segment);
      break;
    case SegmentDisplayType.SIXTEEN_KMN_UP_TSR:
      baseSegments = _16SegmentVariants[SegmentDisplayType.SIXTEEN_KMN_UP_TSR]!;
      break;
    case SegmentDisplayType.SIXTEENAUTO:
      baseSegments = _detectVariant(input, _16SegmentVariants.values);
      break;
    default:
  }

  input = input.toLowerCase();
  var displays = <List<String>>[];
  List<String>? currentDisplay;

  for (int i = 0; i < input.length; i++) {
    var splitResult = _splitSegment(input, i, baseSegments);
    i = splitResult.item2;

    if (!baseSegments.containsValue(splitResult.item1)) {
      if (currentDisplay != null) {
        currentDisplay.sort();
        displays.add(currentDisplay.toSet().toList());
      }

      currentDisplay = null;
      continue;
    }

    currentDisplay ??= [];

    currentDisplay.add(splitResult.item1);
  }

  if (currentDisplay != null) {
    currentDisplay.sort();
    displays.add(currentDisplay.toSet().toList());
  }

  var out = displays.map((display) {
    if (display.length == 1 && display[0] == 'dp') {
      return '.';
    }

    var containsDot = display.contains('dp');
    var segments = List<String>.from(display);
    if (containsDot) segments.remove('dp');

    var character = _characterFromSegmentList(baseSegmentType(segmentType), segments); //segmentType
    if (character == null) {
      return UNKNOWN_ELEMENT;
    }

    return character + (containsDot ? '.' : '');
  }).join();

  return SegmentsText(displays: displays, text: out);
}

String? _characterFromSegmentList(SegmentDisplayType type, List<String> segments) {
  Map<List<String>, String> segmentToAZ;

  switch (type) {
    case SegmentDisplayType.SEVEN:
      segmentToAZ = _Segment7ToAZ;
      break;
    case SegmentDisplayType.FOURTEEN:
      segmentToAZ = _Segment14ToAZ;
      break;
    case SegmentDisplayType.SIXTEEN:
      segmentToAZ = _Segment16ToAZ;
      break;
    default:
      return null;
  }
  return segmentToAZ.map((key, value) => MapEntry(key.join(), value.toString()))[segments.join()];
}

bool segmentActive(Map<String, bool> segments, String segment) {
  return segments[segment] ?? false;
}

Segments mapToVariant(Segments segments, SegmentDisplayType segmentType) {
  var baseType = baseSegmentType(segmentType);
  Map<String, String> mapList = {};
  var mappedSegment = Segments(displays: []);

  if (baseType == segmentType) return segments;

  switch (baseType) {
    case SegmentDisplayType.SIXTEEN:
      if (segmentType == SegmentDisplayType.SIXTEENAUTO) return segments;
      mapList = _16SegmentVariants[segmentType]!;
      break;
    case SegmentDisplayType.FOURTEEN:
      if (segmentType == SegmentDisplayType.FOURTEENAUTO) return segments;
      mapList = _14SegmentVariants[segmentType]!;
      break;
    case SegmentDisplayType.SEVEN:
      if (segmentType == SegmentDisplayType.SEVENAUTO) return segments;
      mapList = _7SegmentVariants[segmentType]!;
      break;
    default:
  }
  mapList = switchMapKeyValue(mapList);

  for (var segment in segments.displays) {
    List<String> newSegment = [];
    for (var segment in segment) {
      newSegment.add(mapList[segment] ?? '');
    }
    mappedSegment.addSegment(newSegment);
  }
  return mappedSegment;
}

SegmentDisplayType baseSegmentType(SegmentDisplayType segmentType) {
  if (Variants14Segment.contains(segmentType)) return SegmentDisplayType.FOURTEEN;
  if (Variants16Segment.contains(segmentType)) return SegmentDisplayType.SIXTEEN;
  return SegmentDisplayType.SEVEN;
}

Map<String, List<String>> _convertCharacterMap(Map<String, List<String>> characterMap, Map<String, String> variant) {
  Map<String, List<String>> _characterMap = {};
  var variantMap = switchMapKeyValue(variant);

  characterMap.forEach((character, segments) {
    _characterMap.addAll({character: segments.map((segment) => variantMap[segment]!).toList()});
  });
  return _characterMap;
}

Map<String, String> _createBaseVariant(List<String> baseSegments) {
  return Map<String, String>.fromIterables(baseSegments, baseSegments);
}

Map<String, String> _detectVariant(String input, Iterable<Map<String, String>> variants) {
  if (variants.length == 1) return variants.first;
  var countSegments = 0;
  var maxCountSegments = 0;
  var variant = variants.first;

  for (var baseSegments in variants) {
    countSegments = 0;
    for (int i = 0; i < input.length; i++) {
      var splitResult = _splitSegment(input, i, baseSegments);
      i = splitResult.item2;
      if (baseSegments.containsValue(splitResult.item1)) countSegments++;
    }
    if (countSegments > maxCountSegments) {
      maxCountSegments = countSegments;
      variant = baseSegments;
    }
  }
  return variant;
}

Tuple2<String, int> _splitSegment(String input, int i, Map<String, String> baseSegments) {
  var segment = input[i];

  if (i + 2 < input.length && segment + input[i + 1] + input[i + 2] == 'dp1' && baseSegments.containsKey('dp1')) {
    segment += input[i + 1] + input[i + 2];
    i += 2;
  } else if (i + 1 < input.length && segment + input[i + 1] == 'dp' && baseSegments.containsKey('dp')) {
    segment += input[i + 1];
    i++;
  } else if (!input[i].isNumber && segment != ' ' && i + 1 < input.length && ['1', '2'].contains(input[i + 1])) {
    segment += input[i + 1];
    i++;
  }

  if (baseSegments.containsKey(segment)) {
    return Tuple2<String, int>(baseSegments[segment]!, i);
  } else {
    return Tuple2<String, int>('', i);
  }
}
