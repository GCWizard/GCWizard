import 'dart:convert';

import 'package:base32/base32.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/ascii85/logic/ascii85.dart';

final Map<String, Function> BASE_FUNCTIONS = {
  'base_base16': decodeBase16,
  'base_base32': decodeBase32,
  'base_base64': decodeBase64,
  'base_base58': decodeBase58,
  'base_base85': decodeBase85,
  'base_base91': decodeBase91,
  'base_base122': decodeBase122,
};

String decodeBase16(String input) {
  if (input == null || input == '') return '';

  return List.generate(input.length, (i) => i % 2 == 0 ? input.substring(i, i + 2) : null)
      .where((b) => b != null && RegExp(r'[0-9A-Fa-f]{2}').hasMatch(b))
      .map((b) => String.fromCharCode(int.parse(b, radix: 16)))
      .toList()
      .join();
}

String encodeBase16(String input) {
  if (input == null || input == '') return '';

  return input.codeUnits.map((codeUnit) => codeUnit.toRadixString(16).padLeft(2, '0')).join();
}

String encodeBase32(String input) {
  if (input == null || input == '') return '';

  return base32.encodeString(input);
}

String decodeBase32(String input) {
  if (input == null || input == '') return '';

  var out = '';

  //if there's no result, try with appended =
  for (int i = 0; i <= 1; i++) {
    try {
      out = base32.decodeAsString(input + '=' * i);

      if (out.length > 0) break;
    } on FormatException {}
  }

  return out;
}

String encodeBase64(String input) {
  if (input == null || input == '') return '';

  return base64.encode(utf8.encode(input));
}

String decodeBase64(String input) {
  if (input == null || input == '') return '';

  var out = '';

  //if there's no result, try with appended = or ==
  for (int i = 0; i <= 2; i++) {
    try {
      out = utf8.decode(base64.decode(input + '=' * i));

      if (out.length > 0) break;
    } on FormatException {}
  }

  return out;
}

String encodeBase85(String input) {
  if (input == null || input == '') return '';

  var encoded = encodeASCII85(utf8.encode(input));

  if (encoded == null) return '';

  return '<~' + encoded + '~>';
}

String decodeBase85(String input) {
  if (input == null || input == '') return '';

  if (input.startsWith('<~')) input = input.substring(2);

  if (input.endsWith('~>')) input = input.substring(0, input.length - 2);

  var decoded = decodeASCII85(input);
  return utf8.decode(decoded == null ? [] : decoded);
}

String decode(String input, Function function) {
  var output = '';
  if (input.length == 0) return output;

  while (input.length > 0) {
    try {
      output = function(input);

      if (output.length == 0 && input.length > 0) throw FormatException();

      break;
    } on FormatException {
      return decode(input.substring(0, input.length - 1), function);
    } on RangeError {
      return decode(input.substring(0, input.length - 1), function);
    }
  }

  return output;
}

// ---------- Base58
//
// https://www.darklaunch.com/base58-encode-and-decode-using-php-with-example-base58-encode-base58-decode.html
//
String encodeBase58(String input) {
  if (input == null || input == '' || int.tryParse(input) == null) return '';

  int num = int.parse(input);
  String alphabet = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
  int base_count = alphabet.length;
  int div = 0;
  int mod = 0;
  String encoded = '';

  while (num >= base_count) {
    div = num ~/ base_count;
    mod = num % base_count;
    encoded = encoded + alphabet[mod];
    num = div;
  }
  if (num > 0) encoded = encoded + alphabet[num];

  return encoded.split('').reversed.join('');
}

final List<String> BASE58_ALPHABET = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
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
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  'M',
  'N',
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
  'Z'
];

String decodeBase58(String input) {
  if (input == null || input == '') return '';

  String alphabet = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
  String num = '';

  for (int i = 0; i < input.length; i++) if (BASE58_ALPHABET.contains(input[i])) num = num + input[i];

  int len = num.length;
  int multi = 1;
  int decoded = 0;

  for (int i = len - 1; i >= 0; i--) {
    decoded = decoded + multi * _strPos(alphabet, num[i]);
    multi = multi * alphabet.length;
  }
  return decoded.toString();
}

int _strPos(String text, String char) {
  for (int i = 0; i < text.length; i++) if (text[i] == char) return i;
}

// ---------- Base91
//
// Copyright (c) 2005-2006 Joachim Henke
// http://base91.sourceforge.net/
//
// nX,<:WRT%yV%!5:maref3+1RrUb64^M  => This is an encoded string

List<String> _b91_enctab = [
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
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '!',
  '#',
  '\$',
  '%',
  '&',
  '(',
  ')',
  '*',
  '+',
  ',',
  '.',
  '/',
  ':',
  ';',
  '<',
  '=',
  '>',
  '?',
  '@',
  '[',
  ']',
  '^',
  '_',
  '`',
  '{',
  '|',
  '}',
  '~',
  '"'
];

String encodeBase91(String d) {
  if (d == null || d == '') return '';

  int l = d.length;
  String o = '';
  int b = 0;
  int n = 0;
  int v = 0;

  for (int i = 0; i < l; ++i) {
    b = b | d.codeUnitAt(i) << n;
    n = n + 8;
    if (n > 13) {
      v = b & 8191;
      if (v > 88) {
        b = b >> 13;
        n = n - 13;
      } else {
        v = b & 16383;
        b = b >> 14;
        n = n - 14;
      }
      o = o + _b91_enctab[v % 91] + _b91_enctab[v ~/ 91];
    }
  }
  if (n > 0) {
    o = o + _b91_enctab[b % 91];
    if (n > 7 || b > 90) o = o + _b91_enctab[b ~/ 91];
  }
  return o;
}

String decodeBase91(String d) {
  if (d == null || d == '') return '';

  Map<int, int> b91_dectab = {};

  for (int i = 0; i < 256; i++) b91_dectab[i] = -1;

  for (int i = 0; i < 91; ++i) b91_dectab[_b91_enctab[i].codeUnitAt(0)] = i;

  int dbq = 0;
  int dn = 0;
  int dv = -1;
  List<int> output = [];

  for (int i = 0; i < d.length; ++i) {
    if (b91_dectab[d[i].codeUnitAt(0)] != -1) {
      if (dv == -1)
        dv = b91_dectab[d[i].codeUnitAt(0)];
      else {
        dv = dv + b91_dectab[d[i].codeUnitAt(0)] * 91;
        dbq |= dv << dn;
        dn += (dv & 8191) > 88 ? 13 : 14;
        do {
          output.add(dbq % 256);
          dbq >>= 8;
          dn -= 8;
        } while (dn > 7);
        dv = -1;
      }
    }
  }

  if (dv != -1) {
    output.add(dbq | dv << dn);
  }

  return String.fromCharCodes(output);
}

// ---------- Base122
//
// Kevin Alberston
// https://github.com/kevinAlbs/Base122/blob/master/base122.js
//
// Patrick Favre-Bulle
// Apache License, Version 2.0
// https://github.com/patrickfav/base122-java/blob/master/src/main/java/at/favre/lib/encoding/Base122.java

List<int> _ILLEGAL_BYTES = [
  0 // null
  ,
  10 // newline
  ,
  13 // carriage return
  ,
  34 // double quote
  ,
  38 // ampersand
  ,
  92 // backslash
];
int _kShortened = 7; // 0b111
int _STOP_BYTE = 128; // (byte) 0b1000_0000

String encodeBase122(String rawData) {
  if (rawData == null || rawData == '') return '';

  int curIndex = 0;
  int curBit = 0;

  int next7Bit() {
    if (curIndex >= rawData.length) {
      return _STOP_BYTE;
    }

    // Shift, mask, unshift to get first part.
    int firstByte = rawData.codeUnitAt(curIndex);
    int firstPart = ((254 >> curBit) & firstByte) << curBit;

    // Align it to a seven bit chunk.
    firstPart >>= 1;

    // Check if we need to go to the next byte for more bits.
    curBit += 7;
    if (curBit < 8) return firstPart; // (byte) firstPart  - Do not need next byte.

    curBit -= 8;
    curIndex++;
    // Now we want bits [0..curBit] of the next byte if it exists.
    if (curIndex >= rawData.length) return firstPart; // (byte) firstPart

    int secondByte = rawData.codeUnitAt(curIndex);
    int secondPart = ((0xFF00 >> curBit) & secondByte) & 0xFF;
    // Align it.
    secondPart >>= 8 - curBit;
    return (firstPart | secondPart); // (byte) (firstPart | secondPart)
  }

  int isIllegalCharacter(sevenBits) {
    for (int i = 0; i < _ILLEGAL_BYTES.length; i++) {
      if (_ILLEGAL_BYTES[i] == sevenBits) {
        return i;
      }
    }
    return -1;
  }

  int sevenBits;
  int illegalIndex;
  List<int> outputStream = [];

  sevenBits = next7Bit();
  while (sevenBits != _STOP_BYTE) {
    illegalIndex = isIllegalCharacter(sevenBits);
    if (illegalIndex != -1) {
      // Since this will be a two-byte character, get the next chunk of seven bits.
      int nextSevenBits = next7Bit();

      int b1 = 194; // (byte) 0b11000010
      int b2 = 128; // (byte) 0b10000000
      if (nextSevenBits == _STOP_BYTE) {
        b1 |= (7 & _kShortened) << 2; // (0b111 & _kShortened) << 2;
        nextSevenBits = sevenBits; // Encode these bits after the shortened signifier.
      } else {
        b1 |= (7 & illegalIndex) << 2; // (0b111 & illegalIndex) << 2;
      }

      // Push first bit onto first byte, remaining 6 onto second.
      int firstBit = ((nextSevenBits & 64) > 0 ? 1 : 0) % 256; // (byte) ((nextSevenBits & 0b01000000) > 0 ? 1 : 0);
      b1 |= firstBit;
      b2 |= nextSevenBits & 63; // nextSevenBits & 0b00111111;
      outputStream.add(b1 % 256);
      outputStream.add(b2 % 256);
    } else {
      outputStream.add(sevenBits % 256);
    }
    sevenBits = next7Bit();
  }
  return utf8.decode(outputStream);
}

String decodeBase122(String base122Data) {
  if (base122Data == null || base122Data == '') return '';

  List<int> outputStream = [];
  int curByte = 0;
  int bitOfByte = 0;

  void pushNext7(int nextElement) {
    nextElement <<= 1;
    // Align this byte to offset for current byte.
    curByte |= (nextElement >> bitOfByte);
    bitOfByte += 7;
    if (bitOfByte >= 8) {
      outputStream.add(curByte % 256);
      bitOfByte -= 8;
      // Now, take the remainder, left shift by what has been taken.
      curByte = ((nextElement << (7 - bitOfByte)) & 255) % 256;
    }
  }

  List<int> utf8Bytes = base122Data.codeUnits;

  for (int i = 0; i < utf8Bytes.length; i++) {
    // Check if this is a two-byte character.
    if (utf8Bytes[i] > 127) {
      // Note, the charCodeAt will give the codePoint, thus
      // 0b110xxxxx 0b10yyyyyy will give => xxxxxyyyyyy
      int illegalIndex = (utf8Bytes[i] >> 8) & 7; // 7 = 0b111.
      // We have to first check if this is a shortened two-byte character, i.e. if it only
      // encodes <= 7 bits.
      if (illegalIndex != _kShortened) pushNext7(_ILLEGAL_BYTES[illegalIndex]);
      // Always push the rest.
      pushNext7(utf8Bytes[i] & 127);
    } else {
      // One byte characters can be pushed directly.
      pushNext7(utf8Bytes[i]);
    }
  }
  return String.fromCharCodes(outputStream);
}
