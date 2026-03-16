import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String _kToImageOriginal(String kString){
  List<String> imageBinary = [];
  List<String> imageBinaryRotaded = [];

  String binary = '';
  String pixel = '';
  String line = '';

  BigInt k = BigInt.parse(kString);

  BigInt n17 = BigInt.from(17);

  if (k % n17 == BigInt.zero) {
    k = k ~/ n17;
    binary = convertBase(k.toString(), 10, 2).padLeft(1802, '0');
    for (int i = 0; i < 106; i++) {
      imageBinary.add(binary.substring(i * 17, i * 17 + 17));
    }
  }

  binary = imageBinary.join('');
  for (int i = 0; i < 17; i++) {
    line = '';
    for (int j = 105; j >= 0; j--) {
      pixel = binary[j * 17 + i];
      line = line + pixel;
    }
    imageBinaryRotaded.add(line);
  }
  return imageBinaryRotaded.join('\n');
}

String _kToImageCustom(String kString, int width, int height, int colors){
  List<String> imageBinary = [];
  List<String> imageBinaryRotaded = [];

  String binary = '';

  BigInt k = BigInt.parse(kString);
  BigInt h = BigInt.from(height);
  BigInt c = BigInt.from(colors);

  BigInt k_small = (k ~/ h);
  BigInt temp = BigInt.zero;

  for (int i = 0; i < height; i++){
    for (int j = 0; j < width; j++) {
      temp = (k_small ~/ c.pow(height * j + i));
      imageBinary.add(convertBase((temp % c).toString(), 10, 27));
    }
  }

  binary = imageBinary.join('');
  for (int i = 0; i < height; i++) {
    imageBinaryRotaded.add(binary.substring(0, width));
    binary = binary.substring(width);
  }

  return imageBinaryRotaded.reversed.join('\n');
}

String kToImage(String kString, bool original, int width, int height, int colors) {
  if (original) {
    return _kToImageOriginal(kString);
  } else {
    return _kToImageCustom(kString, width, height, colors);
  }
}

class TupperData {
  List<List<int>> currentBoard = [];
  late int width;
  late int height;

  TupperData({List<List<int>>? content, required int width, required int height}) {
    _generateBoard(content, width, height);
  }

  void _generateBoard(List<List<int>>? content, int width, int height) {
    var _newBoard = List<List<int>>.generate(height, (index) => List<int>.generate(width, (index) => 0));

    if (content != null && content.isNotEmpty) {
      for (int i = 0; i < min(height, content.length); i++) {
        for (int j = 0; j < min(width, content[i].length); j++) {
          _newBoard[i][j] = content[i][j];
        }
      }
    }

    currentBoard = List.from(_newBoard);
  }

  void reset({List<List<int>>? board}) {
    if (board == null) {
      currentBoard = List.from(List<List<int>>.generate(height, (index) => List<int>.generate(width, (index) => 0)));
    } else {
      currentBoard = board;
    }
  }

  int _getColors(List<List<int>> board){
    List<int> palette = [];
    for (List<int> row in board) {
      for (int column in row) {
        if (!palette.contains(column)) {
          palette.add(column);
        }
      }
    }
    return palette.length;
  }

  BigInt _getKCustom() {
    int height = currentBoard.length;
    int width = currentBoard[0].length;
    int colors = _getColors(currentBoard);

    BigInt k = BigInt.zero;
    BigInt c = BigInt.from(colors);

    for (int j = 0; j < width; j++) {
      for (int i = 0; i < height; i++) {
        k += BigInt.from(currentBoard[height - i - 1][j]) * c.pow(j * height + i);
      }
    }

    return k * BigInt.from(height);
  }

  BigInt _getKOriginal() {
    BigInt k = BigInt.zero;

    List<String> boardBinary = [];
    String line = '';
    for (List<int> row in currentBoard) {
      line = '';
      for (int column in row) {
        if (column != 0) {
          line = line + '1';
        } else {
          line = line + '0';
        }
      }
    boardBinary.add(line);
    }

    String binary = boardBinary.join('');
    String pixel = '';
    List<String> boardBinaryRotated = [];
    for (int i = 105; i >= 0; i--) {
      line = '';
      for (int j = 0; j < 17; j++) {
        pixel = binary[i + j * 106];
        line = line + pixel;
      }
      boardBinaryRotated.add(line);
    }
    binary = boardBinaryRotated.join('');

    String decimal = convertBase(binary, 2, 10);

    k = BigInt.parse(decimal);

    k = k * BigInt.from(17);

    return k;
  }

  BigInt getK(bool original) {
    if (original)  {
      return _getKOriginal();
    } else {
      return _getKCustom();
    }
  }
}