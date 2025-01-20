import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String kToImage(String kString) {
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

class TupperData {
  List<List<bool>> currentBoard = [];

  TupperData({List<List<bool>>? content}) {
    _generateBoard(content);
  }

  void _generateBoard(List<List<bool>>? content) {
    var _newBoard = List<List<bool>>.generate(17, (index) => List<bool>.generate(106, (index) => false));

    if (content != null && content.isNotEmpty) {
      for (int i = 0; i < min(17, content.length); i++) {
        for (int j = 0; j < min(106, content[i].length); j++) {
          _newBoard[i][j] = content[i][j];
        }
      }
    }

    currentBoard = List.from(_newBoard);
  }

  void reset({List<List<bool>>? board}) {
    currentBoard = board!;
  }

  BigInt getK() {
    BigInt k = BigInt.two;
    print(currentBoard);
    return k;
  }
}