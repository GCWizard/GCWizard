import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

Map<int, int> TUPPER_COLOR_NUMBERS = {
  0: 2,
  1: 4,
  2: 8,
  3: 16,
};

const _BLACK = Color(0xff000000);
const _WHITE = Color(0xffffffff);
const _CYAN = Color(0xff00aaaa);
const _MAGENTA = Color(0xffaa00aa);
const _LIGHTGREY = Color(0xffaaaaaa);
const _BLUE = Color(0xff0000aa);
const _GREEN = Color(0xff00aa00);
const _RED = Color(0xffaa0000);
const _YELLOW = Color(0xffaaaa00);
const _DARKGREY = Color(0xff555555);
const _LIGHTBLUE = Color(0xff0000ff);
const _LIGHTGREEN = Color(0xff00ff00);
const _LIGHTCYAN = Color(0xff00ffff);
const _LIGHTRED = Color(0xffff0000);
const _LIGHTMAGENTA = Color(0xffff00ff);
const _LIGHTYELLOW = Color(0xffffff00);
const _ORANGE = Colors.orange;

Map<int, List<Color>> TUPPER_COLORS = {
  2: [_WHITE, _BLACK],
  4: [_WHITE, _CYAN, _MAGENTA, _BLACK, ],
  8: [_WHITE, _LIGHTBLUE, _LIGHTRED, _LIGHTYELLOW, _GREEN, _LIGHTGREY, _ORANGE, _BLACK],
  16: [_WHITE, _BLUE, _GREEN, _CYAN, _RED, _MAGENTA, _YELLOW, _LIGHTGREY,
        _DARKGREY, _LIGHTBLUE, _LIGHTGREEN, _LIGHTCYAN, _LIGHTRED, _LIGHTMAGENTA, _LIGHTYELLOW, _BLACK]
};

String _kToImageOriginal(String kString){
  // 4858450636189713423582095962494202044581400587983244549483093085061934704708809928450644769865524364849997247024915119110411605739177407856919754326571855442057210445735883681829823754139634338225199452191651284348332905131193199953502413758765239264874613394906870130562295813219481113685339535565290850023875092856892694555974281546386510730049106723058933586052544096664351265349363643957125565695936815184334857605266940161251266951421550539554519153785457525756590740540157929001765967965480064427829131488548259914721248506352686630476300
  // 78575456032829913865316725813522748835353880174380103571516816178401271721234265443172075053623985915557527915928364354502801825890797341299230650742932710100506419493535805142393521774971638242313461859429361270289384450049910038671122387458139132519239114477593836773736851906981612969280679011648001420492406619222474419762692178202364414240692952416241071264871743488
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
  // 633521748
  // colors: 3
  // width: 5
  // height: 4
  //
  // 1430579439309431169874125120864656533150313240707517981188795239055383593686139218449399363713936545797504249792103706704323732928013153590483749399854915229085923328913778588781062627985119856387200
  // colors: 6
  // width: 16
  // height: 16
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
      //temp = (k_small ~/ BigInt.from(pow(colors, height * j + i)));
      imageBinary.add(convertBase((temp % c).toString(), 10, 27));
    }
  }

  binary = imageBinary.reversed.join('');
  for (int i = 0; i < height; i++) {
    imageBinaryRotaded.add(binary.substring(0, width));
    binary = binary.substring(width);
  }

  return imageBinaryRotaded.join('\n');
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

    for (int j = 0; j < width; j++) {
      for (int i = 0; i < height; i++) {
        k += BigInt.from(currentBoard[height - i - 1][j]) * BigInt.from(pow(colors, j * height + i) as int);
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