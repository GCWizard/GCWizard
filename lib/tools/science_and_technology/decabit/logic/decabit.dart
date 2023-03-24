import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const Map<int, String> _AZToDecabit = {
  0: '--+-+++-+-',
  1: '+--+++--+-',
  2: '+--++-+-+-',
  3: '+--+-++-+-',
  4: '----+++-++',
  5: '++--+++---',
  6: '++--++--+-',
  7: '++--+-+-+-',
  8: '++---++-+-',
  9: '---++++-+-',
  10: '+-+-+++---',
  11: '+-+-+-+-+-',
  12: '+-+--++-+-',
  13: '+---++-++-',
  14: '+---++--++',
  15: '--+++-++--',
  16: '---++-+++-',
  17: '+---+-++-+',
  18: '+--++--+-+',
  19: '+--++-+--+',
  20: '+-+++--+--',
  21: '+--+++-+--',
  22: '++--+-++--',
  23: '-+-++-++--',
  24: '+--++--++-',
  25: '+-+++-+---',
  26: '++-+--++--',
  27: '+-+-+-++--',
  28: '+--+-+++--',
  29: '+--+--++-+',
  30: '+-++-++---',
  31: '+-++-+-+--',
  32: '+-+-++-+--',
  33: '+---++++--',
  34: '+-+--+-++-',
  35: '+++--++---',
  36: '+++--+-+--',
  37: '+++---++--',
  38: '++---+++--',
  39: '--+-++++--',
  40: '++--++-+--',
  41: '-+-+-+-++-',
  42: '++----+++-',
  43: '+----+-+++',
  44: '++---+-+-+',
  45: '++-+-+-+--',
  46: '++-+-+--+-',
  47: '+++----++-',
  48: '++--+--++-',
  49: '+--+-+-++-',
  50: '++++----+-',
  51: '++-++---+-',
  52: '+-+++---+-',
  53: '-++++---+-',
  54: '+-+-+---++',
  55: '+++-++----',
  56: '+++-+-+---',
  57: '+-+-+--++-',
  58: '-++-+--++-',
  59: '+++-+----+',
  60: '++++-+----',
  61: '-+++-++---',
  62: '-+-+-++-+-',
  63: '++---++--+',
  64: '++-+--+--+',
  65: '++-+++----',
  66: '++++--+---',
  67: '+--++++---',
  68: '-+-++++---',
  69: '++-+--+-+-',
  70: '-++---+++-',
  71: '+---+-+++-',
  72: '--+-+-+++-',
  73: '+----++++-',
  74: '--+--++++-',
  75: '+++---+-+-',
  76: '+-++---++-',
  77: '+--+--+++-',
  78: '--++--+++-',
  79: '+-+---+-++',
  80: '-+++--+-+-',
  81: '-+-++-+-+-',
  82: '-+++---++-',
  83: '-+-++--++-',
  84: '-+---++++-',
  85: '-++++--+--',
  86: '-++-++-+--',
  87: '--++++-+--',
  88: '--++-+++--',
  89: '--++-+-++-',
  90: '+-++++----',
  91: '--++++--+-',
  92: '--++-++-+-',
  93: '+--+-+--++',
  94: '+-++----++',
  95: '-+-+++--+-',
  96: '-++-+-+-+-',
  97: '-+--++-++-',
  98: '---+++-++-',
  99: '-+--+-+++-',
  100: '+---+++-+-',
  101: '-+--+++-+-',
  102: '+-+-++--+-',
  103: '+--++-++--',
  104: '++-++--+--',
  105: '+-++--++--',
  106: '+-+--+++--',
  107: '-++--+++--',
  108: '++---+-++-',
  109: '++-+---++-',
  110: '+++-+---+-',
  111: '+++-+--+--',
  112: '++-+-++---',
  113: '++-++-+---',
  114: '+-+---+++-',
  115: '+-++--+-+-',
  116: '-+-+--+++-',
  117: '-+++-+-+--',
  118: '+-++-+--+-',
  119: '-++-+++---',
  120: '+++--+--+-',
  121: '+++++-----',
  122: '-+++++----',
  123: '--+++++---',
  124: '---+++++--',
  125: '----+++++-',
  126: '++++++++++'
};
final _AZToDecabitInt = _AZToDecabit.map((k, v) => MapEntry(k.toString(), v));
final _AZToDecabitStr = _AZToDecabit.map((k, v) => MapEntry(String.fromCharCode(k), v));
final _DecabitToAZInt = _AZToDecabit.map((k, v) => MapEntry(v, k.toString()));
final _DecabitToAZStr = _AZToDecabit.map((k, v) => MapEntry(v, String.fromCharCode(k)));

String encryptDecabit(String input, Map<String, String> replaceCharacters, bool numericMode) {
  if (input.isEmpty) return '';

  String decabit;

  if (numericMode) {
    decabit = normalizeUmlauts(input)
        .split(RegExp(r'\D'))
        .where((character) => _AZToDecabit[int.tryParse(character)] != null)
        // Parse string and convert back to eliminate leading zeros
        .map((character) => substitution(int.tryParse(character).toString(), _AZToDecabitInt))
        .join(' ');
  } else {
    decabit = normalizeUmlauts(input)
        .split('')
        .where((character) => _AZToDecabitStr[character] != null)
        .map((character) => substitution(character, _AZToDecabitStr))
        .join(' ');
  }

  decabit = substitution(decabit, replaceCharacters);

  return decabit;
}

String decryptDecabit(String input, Map<String, String>? replaceCharacters, bool numericMode) {
  if (input.isEmpty) return '';

  if (replaceCharacters != null) input = substitution(input, switchMapKeyValue(replaceCharacters));

  input = input.replaceAll(RegExp(r'[^+\-]'), '');

  var out = '';
  int i = 0;
  while (i <= input.length - 10) {
    var chunk = input.substring(i, i + 10);
    String? character;

    if (numericMode) {
      if (_DecabitToAZInt[chunk] != null) character = _DecabitToAZInt[chunk]! + ' ';
    } else {
      if (_DecabitToAZStr[chunk] != null) character = _DecabitToAZStr[chunk];
    }

    if (character != null) {
      out += character;
      i += 10;
    } else {
      i += 1;
    }
  }

  if (numericMode) out = out.trim();

  return out;
}
