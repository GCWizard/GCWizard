part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';

class _PietBlock {
  int _color = 0;

  int get color => _color;
  bool _knownColor = false;
  bool get knownColor => _knownColor;
  var _pixels = Set<Point<int>>();

  _PietBlock(int color, bool knownColor) {
    _color = color;
    _knownColor = knownColor;
  }

  int get blockCount => _pixels.length;

  bool addPixel(Point<int> point) {
    return _pixels.add(point);
  }

  bool containsPixel(Point<int> point) {
    return _pixels.contains(point);
  }

  Point get northLeft => _pixels.reduce(
          (current, next) => ((current.y < next.y) || ((current.y == next.y) && current.x < next.x)) ? current : next);
  Point get northRight => _pixels.reduce(
          (current, next) => ((current.y < next.y) || ((current.y == next.y) && current.x > next.x)) ? current : next);
  Point get eastLeft => _pixels.reduce(
          (current, next) => ((current.x > next.x) || ((current.x == next.x) && current.y < next.y)) ? current : next);
  Point get eastRight => _pixels.reduce(
          (current, next) => ((current.x > next.x) || ((current.x == next.x) && current.y > next.y)) ? current : next);
  Point get southLeft => _pixels.reduce(
          (current, next) => ((current.y > next.y) || ((current.y == next.y) && current.x > next.x)) ? current : next);
  Point get southRight => _pixels.reduce(
          (current, next) => ((current.y > next.y) || ((current.y == next.y) && current.x < next.x)) ? current : next);
  Point get westLeft => _pixels.reduce(
          (current, next) => ((current.x < next.x) || ((current.x == next.x) && current.y > next.y)) ? current : next);
  Point get westRight => _pixels.reduce(
          (current, next) => ((current.x < next.x) || ((current.x == next.x) && current.y < next.y)) ? current : next);
}


