// Port and slightly changes from Java library com.github.fzakaria.ascii85 (https://github.com/fzakaria/ascii85)

//Copyright [yyyy] [Farid Zakaria]
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'dart:convert';
import 'dart:typed_data';

const _ASCII_SHIFT = 33;

const _BASE85_POW = [1, 85, 85 * 85, 85 * 85 * 85, 85 * 85 * 85 * 85];

/*
 * A very simple method that helps encode for Ascii85 / base85
 * The version that is likely most similar that is implemented here would be the Adobe version.
 * @see <a href="https://en.wikipedia.org/wiki/Ascii85">Ascii85</a>
 */
String? encodeASCII85(Uint8List payload) {
  var out = '';
  //We break the payload into int (4 bytes)
  Uint8List chunk = Uint8List(4);
  int chunkIndex = 0;
  for (int i = 0; i < payload.length; i++) {
    var currByte = payload[i];
    chunk[chunkIndex++] = currByte;

    if (chunkIndex == 4) {
      int value = ByteData.view(chunk.buffer).getInt32(0);
      //Because all-zero data is quite common, an exception is made for the sake of data compression,
      //and an all-zero group is encoded as a single character "z" instead of "!!!!!".
      if (value == 0) {
        out += 'z';
      } else {
        out += _encodeChunk(value);
      }
      chunk = Uint8List(4);
      chunkIndex = 0;
    }
  }

  //If we didn't end on 0, then we need some padding
  if (chunkIndex > 0) {
    int numPadded = chunk.length - chunkIndex;
    int value = ByteData.view(chunk.buffer).getInt32(0);
    var encodedChunk = _encodeChunk(value);
    out += encodedChunk.substring(0, encodedChunk.length - numPadded);
  }

  return out;
}

String _encodeChunk(int value) {
  //transform value to unsigned long
  var longValue = value & 0x00000000ffffffff;
  var encodedChunk = '';

  for (int i = 0; i <= 4; i++) {
    encodedChunk += String.fromCharCode((longValue / _BASE85_POW[4 - i]).floor() + _ASCII_SHIFT);
    longValue = longValue % _BASE85_POW[4 - i];
  }

  return encodedChunk;
}

/*
 * This is a very simple base85 decoder. It respects the 'z' optimization for empty chunks, and
 * strips whitespace between characters to respect line limits.
 * @see <a href="https://en.wikipedia.org/wiki/Ascii85">Ascii85</a>
 * @param chars The input characters that are base85 encoded.
 * @return The binary data decoded from the input
 */
Uint8List? decodeASCII85(String chars) {

  Uint8List bytebuff = Uint8List(chars.length);
  int bufferIndex = 0;
  //1. Whitespace characters may occur anywhere to accommodate line length limitations. So lets strip it.
  chars = chars.replaceAll(RegExp(r'\s+'), '');
  //Since Base85 is an ascii encoder, we don't need to get the bytes as UTF-8.
  Uint8List payload = ascii.encode(chars);
  Uint8List chunk = Uint8List(5);
  int chunkIndex = 0;
  for (int i = 0; i < payload.length; i++) {
    var currByte = payload[i];
    //Because all-zero data is quite common, an exception is made for the sake of data compression,
    //and an all-zero group is encoded as a single character "z" instead of "!!!!!".
    if (currByte == 'z'.codeUnitAt(0)) {
      if (chunkIndex > 0) {
        return null;
      }
      chunk[chunkIndex++] = '!'.codeUnitAt(0);
      chunk[chunkIndex++] = '!'.codeUnitAt(0);
      chunk[chunkIndex++] = '!'.codeUnitAt(0);
      chunk[chunkIndex++] = '!'.codeUnitAt(0);
      chunk[chunkIndex++] = '!'.codeUnitAt(0);
    } else {
      chunk[chunkIndex++] = currByte;
    }

    if (chunkIndex == 5) {
      var decodedChunk = _decodeChunk(chunk);
      if (decodedChunk == null) return null;

      for (int j = 0; j < decodedChunk.length; j++) {
        bytebuff[bufferIndex++] = decodedChunk[j];
      }

      chunk = Uint8List(5);
      chunkIndex = 0;
    }
  }

  //If we didn't end on 0, then we need some padding
  if (chunkIndex > 0) {
    int numPadded = chunk.length - chunkIndex;
    for (int j = chunkIndex; j < chunk.length; j++) {
      chunk[j] = 'u'.codeUnitAt(0);
    }

    var paddedDecode = _decodeChunk(chunk);
    if (paddedDecode == null) return null;
    for (int i = 0; i < paddedDecode.length - numPadded; i++) {
      bytebuff[bufferIndex++] = paddedDecode[i];
    }
  }

  return bytebuff.sublist(0, bufferIndex);
}

Uint8List? _decodeChunk(Uint8List chunk) {
  if (chunk.length != 5) return null;

  int value = 0;
  value += (chunk[0] - _ASCII_SHIFT) * _BASE85_POW[4];
  value += (chunk[1] - _ASCII_SHIFT) * _BASE85_POW[3];
  value += (chunk[2] - _ASCII_SHIFT) * _BASE85_POW[2];
  value += (chunk[3] - _ASCII_SHIFT) * _BASE85_POW[1];
  value += (chunk[4] - _ASCII_SHIFT) * _BASE85_POW[0];

  return _intToByte(value);
}

Uint8List _intToByte(int value) {
  return Uint8List.fromList([(value >> 24), (value >> 16), (value >> 8), (value)]);
}
