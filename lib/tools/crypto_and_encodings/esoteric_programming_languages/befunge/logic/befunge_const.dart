part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge.dart';

const _BEFUNGE_ERROR_INVALID_PROGRAM = 'befunge_error_syntax_invalidprogram';
const _BEFUNGE_ERROR_NO_INPUT = 'befunge_error_no_input';
const _BEFUNGE_ERROR_INVALID_INPUT = 'befunge_error_invalid_input';
const _BEFUNGE_ERROR_INFINITE_LOOP = 'befunge_error_infinite_loop';
const _BEFUNGE_ERROR_NULL_COMMAND = 'befunge_error_null_command';
const _BEFUNGE_ERROR_OUT_OF_BOUNDS_ACCESS = 'befunge_error_access_out_of_bounds';
const _BEFUNGE_ERROR_INVALID_COMMAND = 'befunge_error_invalid_command';

const _BEFUNGE_EMPTY_LINE = '                                                                                ';

const _SCREENWIDTH = 80;
const _SCREENHEIGHT = 25;

const BEFUNGE_MAX_LENGTH_PROGRAM = _SCREENWIDTH * _SCREENHEIGHT;

const _MAX_ITERATIONS = 9999;
const _MAX_OUTPUT_LENGTH = 160;

final Map<String, TextStyle> BEFUNGE_SYNTAX = {
  // https://en.wikipedia.org/wiki/Befunge
  "+": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  "-": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  "*": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  "/": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  "%": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  "!": const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
  ">": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  "<": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  "v": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  "^": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  "?": const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  "|": const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
  "_": const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
  ":": const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
  "\\": const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
  "\$": const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
  "&": const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
  "~": const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
  ".": const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
  ",": const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
};
