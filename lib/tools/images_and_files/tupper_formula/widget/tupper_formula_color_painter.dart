part of 'package:gc_wizard/tools/images_and_files/tupper_formula/widget/tupper_formula.dart';

enum _GridPaintColor {
  BLACK,
  WHITE,
  CYAN,
  MAGENTA,
  LIGHTGREY,
  BLUE,
  GREEN,
  RED,
  YELLOW,
  DARKGREY,
  LIGHTBLUE,
  LIGHTGREEN,
  LIGHTCYAN,
  LIGHTRED,
  LIGHTMAGENTA,
  LIGHTYELLOW,
  ORANGE
}

Map<int, Map<_GridPaintColor, Color>> _GRID_COLORS = {
  2: {
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.WHITE: Colors.white,
  },
  4: {
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.CYAN: Color(0xff00aaaa),
    _GridPaintColor.MAGENTA: Color(0xffaa00aa),
    _GridPaintColor.WHITE: Colors.white,
  },
  8: {
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.LIGHTGREY: Color(0xffaaaaaa),
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.LIGHTRED: Color(0xffff0000),
    _GridPaintColor.LIGHTYELLOW: Color(0xffffff00),
    _GridPaintColor.LIGHTBLUE: Color(0xff0000ff),
    _GridPaintColor.GREEN: Color(0xff00aa00),
    _GridPaintColor.ORANGE: Colors.orange,
  },
  16: {
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.DARKGREY: Color(0xff555555),
    _GridPaintColor.LIGHTGREY: Color(0xffaaaaaa),
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.RED: Color(0xffaa0000),
    _GridPaintColor.LIGHTRED: Color(0xffff0000),
    _GridPaintColor.YELLOW: Colors.yellow,
    _GridPaintColor.LIGHTYELLOW: Color(0xffffff00),
    _GridPaintColor.BLUE: Color(0xff0000aa),
    _GridPaintColor.LIGHTBLUE: Color(0xff0000ff),
    _GridPaintColor.GREEN: Color(0xff00aa00),
    _GridPaintColor.LIGHTGREEN: Color(0xff00ff00),
    _GridPaintColor.CYAN: Color(0xff00aaaa),
    _GridPaintColor.LIGHTCYAN: Color(0xff00ffff),
    _GridPaintColor.MAGENTA: Color(0xffaa00aa),
    _GridPaintColor.LIGHTMAGENTA: Color(0xffff00ff),
  }
};

const Map<int, int> TUPPER_COLOR_NUMBERS = {
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

const Map<int, List<Color>> TUPPER_COLORS = {
  2: [_WHITE, _BLACK],
  4: [
    _WHITE,
    _CYAN,
    _MAGENTA,
    _BLACK,
  ],
  8: [_WHITE, _LIGHTBLUE, _LIGHTRED, _LIGHTYELLOW, _GREEN, _LIGHTGREY, _ORANGE, _BLACK],
  16: [
    _WHITE,
    _BLUE,
    _GREEN,
    _CYAN,
    _RED,
    _MAGENTA,
    _YELLOW,
    _LIGHTGREY,
    _DARKGREY,
    _LIGHTBLUE,
    _LIGHTGREEN,
    _LIGHTCYAN,
    _LIGHTRED,
    _LIGHTMAGENTA,
    _LIGHTYELLOW,
    _BLACK
  ]
};
