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
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.BLACK: Colors.black,
  },
  4: {
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.CYAN: Color(0xff00aaaa),
    _GridPaintColor.MAGENTA: Color(0xffaa00aa),
  },
  8: {
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.CYAN: Color(0xff00aaaa),
    _GridPaintColor.MAGENTA: Color(0xffaa00aa),
    _GridPaintColor.LIGHTYELLOW: Color(0xffffff00),
    _GridPaintColor.LIGHTGREEN: Color(0xff00ff00),
    _GridPaintColor.ORANGE: Colors.orange,
    _GridPaintColor.LIGHTBLUE: Color(0xff0000ff),
  },
  16: {
    _GridPaintColor.WHITE: Colors.white,
    _GridPaintColor.BLACK: Colors.black,
    _GridPaintColor.CYAN: Color(0xff00aaaa),
    _GridPaintColor.MAGENTA: Color(0xffaa00aa),
    _GridPaintColor.YELLOW: Colors.yellow,
    _GridPaintColor.GREEN: Color(0xff00aa00),
    _GridPaintColor.ORANGE: Colors.orange,
    _GridPaintColor.LIGHTBLUE: Color(0xff0000ff),
    _GridPaintColor.LIGHTGREY: Color(0xffaaaaaa),
    _GridPaintColor.DARKGREY: Color(0xff555555),
    _GridPaintColor.RED: Color(0xffaa0000),
    _GridPaintColor.LIGHTRED: Color(0xffff0000),
    _GridPaintColor.LIGHTYELLOW: Color(0xffffff00),
    _GridPaintColor.BLUE: Color(0xff0000aa),
    _GridPaintColor.LIGHTGREEN: Color(0xff00ff00),
    _GridPaintColor.LIGHTCYAN: Color(0xff00ffff),
  }
};

const Map<String, int> _colorMapTupper = {
  '0': 0xFFFFFFFF, //Colors.white
  '1': 0xFF000000, //Colors.black
  '2': 0xff00aaaa, //Colors.cyan
  '3': 0xffaa00aa, //Colors.magenta
  '4': 0xFFFFEB3B, //Colors.yellow,
  '5': 0xff00aa00, //Colors.green
  '6': 0xffffe0b2, //Colors.orange
  '7': 0xff0000ff, //Colors.lightBlue
  '8': 0xffaaaaaa, //Colors.lightGrey
  '9': 0xff555555, //Colors.darkGrey
  'A': 0xffaa0000, //Colors.red
  'B': 0xffff0000, //Colors.lightRed
  'C': 0xffffff00, //Colors.lightYellow
  'D': 0xff0000aa, //Colors.blue
  'E': 0xff00ff00, //Colors.lightGreen
  'F': 0xff00ffff, //Colors.lightCyan
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
const _RED = Color(0xffaa0000);
const _DARKGREY = Color(0xff555555);
const _LIGHTBLUE = Color(0xff0000ff);
const _LIGHTGREEN = Color(0xff00ff00);
const _LIGHTCYAN = Color(0xff00ffff);
const _LIGHTRED = Color(0xffff0000);
const _LIGHTYELLOW = Color(0xffffff00);
const _ORANGE = Colors.orange;

const Map<int, List<Color>> TUPPER_COLORS = {
  2: [_WHITE, _BLACK],
  4: [
    _WHITE,
    _BLACK,
    _CYAN,
    _MAGENTA,
  ],
  8: [
    _WHITE,
    _BLACK,
    _CYAN,
    _MAGENTA,
    _LIGHTYELLOW,
    _LIGHTGREEN,
    _ORANGE,
    _LIGHTBLUE,
  ],
  16: [
    _WHITE,
    _BLACK,
    _CYAN,
    _MAGENTA,
    _LIGHTYELLOW,
    _LIGHTGREEN,
    _ORANGE,
    _LIGHTBLUE,
    _LIGHTGREY,
    _DARKGREY,
    _RED,
    _LIGHTRED,
    _LIGHTYELLOW,
    _BLUE,
    _LIGHTGREEN,
    _LIGHTCYAN,
  ]
};
