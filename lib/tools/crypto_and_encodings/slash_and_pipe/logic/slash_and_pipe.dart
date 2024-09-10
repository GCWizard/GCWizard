import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum SLASHANDPIPE_TYPES {COMMON, UNDERLAND, CODEOFCLAW}
// https://en.wikipedia.org/wiki/Gregor_and_the_Code_of_Claw

class CodebookConfig {
  final String title;
  final String subtitle;

  const CodebookConfig({
    required this.title,
    required this.subtitle,
  });
}

const Map<SLASHANDPIPE_TYPES, CodebookConfig> SLASHANDPIPE_CODEBOOKS = {
  SLASHANDPIPE_TYPES.COMMON:
  CodebookConfig(title: 'slash_and_pipe_common_title', subtitle: 'slash_and_pipe_common_description'),
  SLASHANDPIPE_TYPES.UNDERLAND:
  CodebookConfig(title: 'slash_and_pipe_underland_title', subtitle: 'slash_and_pipe_underland_description'),
  SLASHANDPIPE_TYPES.CODEOFCLAW:
  CodebookConfig(title: 'slash_and_pipe_codeofclaw_title', subtitle: 'slash_and_pipe_codeofclaw_description'),
  };

const Map<SLASHANDPIPE_TYPES, Map<String, String>> SLASHANDPIPE_CODES  = {
  SLASHANDPIPE_TYPES.COMMON: _AZToSlashAndPipeCommon,
  SLASHANDPIPE_TYPES.UNDERLAND: _AZToSlashAndPipeUnderland,
  SLASHANDPIPE_TYPES.CODEOFCLAW: _AZToSlashAndPipeCodeOfClaw,
};

const Map<String, String> _AZToSlashAndPipeCommon = {
  'A': '|',
  'B': '|\\',
  'C': '||',
  'D': '|/',
  'E': '\\',
  'F': '||\\',
  'G': '|||',
  'H': '\\\\',
  'I': '/',
  'J': '|\\',
  'K': '||//',
  'L': '|\\/',
  'M': '|\\|',
  'N': '|/|',
  'O': '||/|',
  'P': '|\\|\\',
  'Q': '/\\',
  'R': '\\/',
  'S': '/|',
  'T': '|//',
  'U': '//',
  'V': '||\\\\',
  'W': '\\/||',
  'X': '||/',
  'Y': '|||\\',
  'Z': '||||',
  ' ': ' ',
};
const Map<String, String> _AZToSlashAndPipeUnderland = {
  'A': '|',
  'B': '|\\',
  'C': '||',
  'D': '|/',
  'E': '\\',
  'F': '||\\',
  'G': '|||',
  'H': '||/',
  'I': '/',
  'J': '|\\',
  'K': '|\\|',
  'L': '|\\/',
  'M': '|/\\',
  'N': '|/|',
  'O': '|//',
  'P': '\\',
  'Q': '\\|',
  'R': '\\/',
  'S': '/\\',
  'T': '/|',
  'U': '//',
  'V': '||\\\\',
  'W': '||//',
  'X': '|||\\',
  'Y': '|||/',
  'Z': '||||',
  ' ': ' ',
};
const Map<String, String> _AZToSlashAndPipeCodeOfClaw = {
  // The Code of Claw was the secret code the Gnawers transmitted in Gregor and the Code of Claw.
  // The code is arranged by keeping the letters G, O, R, and E in their spot in the alphabet,
  // and moving every other letter ahead by one
  'B': '|',   // A
  'C': '|\\', // B
  'D': '||',  // C
  'F': '|/',  // D
  'E': '\\',  // E
  'H': '||\\',// F
  'G': '|||', // G
  'I': '||/', // H
  'J': '/',   // I
  'K': '|\\', // J
  'L': '|\\|',// K
  'M': '|\\/',// L
  'N': '|/\\',// M
  'P': '|/|', // N
  'O': '|//', // O
  'Q': '\\',  // P
  'S': '\\|', // Q
  'R': '\\/', // R
  'T': '/\\', // S
  'U': '/|',  // T
  'V': '//',  // U
  'W': '||\\\\', // V
  'X': '||//', // W
  'Y': '|||\\', // X
  'Z': '|||/', // Y
  'A': '||||', // Z
  ' ': ' ',
};

String encryptSlashAndPipe(String input, SLASHANDPIPE_TYPES codetype, Map<String, String>? replaceCharacters) {
  if (input.isEmpty) return '';

  var slashandpipe = normalizeUmlauts(input)
      .toUpperCase()
      .split('')
      .where((character) => SLASHANDPIPE_CODES[codetype]?[character] != null)
      .map((character) => substitution(character, SLASHANDPIPE_CODES[codetype]!))
      .join(' ');

  if (replaceCharacters != null) slashandpipe = substitution(slashandpipe, replaceCharacters);

  return slashandpipe;
}

String decryptSlashAndPipe(String input, SLASHANDPIPE_TYPES codetype, Map<String, String>? replaceCharacters) {
  if (input.isEmpty) return '';

  if (replaceCharacters != null) input = substitution(input, switchMapKeyValue(replaceCharacters));

  final SlashAndPipeToAZ = switchMapKeyValue(SLASHANDPIPE_CODES[codetype]!);

  return input
      .split(RegExp(r'[^|/\\]'))
      .where((character) => SlashAndPipeToAZ[character] != null)
      .map((pattern) => SlashAndPipeToAZ[pattern])
      .join();
}
