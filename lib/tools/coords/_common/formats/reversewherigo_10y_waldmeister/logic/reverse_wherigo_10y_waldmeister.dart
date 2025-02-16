import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

const reverseWherigo10YWaldmeisterKey = 'coords_reversewherigo_10y_waldmeister';

final ReverseWherigo10YWaldmeisterFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER,
    reverseWherigo10YWaldmeisterKey,
    reverseWherigo10YWaldmeisterKey,
    ReverseWherigo10YWaldmeisterCoordinate.parse,
    ReverseWherigo10YWaldmeisterCoordinate(0, 0, 0));

class ReverseWherigo10YWaldmeisterCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER);
  int a, b, c;

  ReverseWherigo10YWaldmeisterCoordinate(this.a, this.b, this.c);

  @override
  LatLng? toLatLng() {
    return _wig10YWaldmeisterToWigWaldmeister(this).toLatLng();
  }

  static ReverseWherigo10YWaldmeisterCoordinate fromLatLon(LatLng coord) {
    return _wigWaldmeisterToWig10YWaldmeister(ReverseWherigoWaldmeisterCoordinate.fromLatLon(coord));
  }

  static ReverseWherigo10YWaldmeisterCoordinate? parse(String input) {
    return _parseReverseWherigo10YWaldmeister(input);
  }

  String _leftPadComponent(int x) {
    return x.toString().padLeft(6, '0');
  }

  @override
  String toString([int? precision]) {
    return [a, b, c].map((e) => _leftPadComponent(e)).join('\n');
  }
}

const int _wLength = 6;

ReverseWherigoWaldmeisterCoordinate _wig10YWaldmeisterToWigWaldmeister(ReverseWherigo10YWaldmeisterCoordinate _10Y) {
  var __10Y = _10Y.a.toString().padLeft(_wLength, '0') +
      _10Y.b.toString().padLeft(_wLength, '0') +
      _10Y.c.toString().padLeft(_wLength, '0');
  var _waldmeister = '';
  for (var i = 1; i <= 18; i++) {
    var y = int.tryParse(__10Y.substring(i-1, i));
    var x = modulo(y! - i, 10);
    _waldmeister += x.toString();
  }
  return ReverseWherigoWaldmeisterCoordinate(
      int.tryParse(_waldmeister.substring(0, _wLength))!,
      int.tryParse(_waldmeister.substring(_wLength * 2, _wLength * 3))!,
      int.tryParse(_waldmeister.substring(_wLength, _wLength * 2))!);
}

ReverseWherigo10YWaldmeisterCoordinate _wigWaldmeisterToWig10YWaldmeister(ReverseWherigoWaldmeisterCoordinate waldmeister) {
  var _waldmeister = waldmeister.a.toString().padLeft(_wLength, '0') +
      waldmeister.c.toString().padLeft(_wLength, '0') +
      waldmeister.b.toString().padLeft(_wLength, '0');
  var _10Y = '';

  for (var i = 1; i <= 18; i++) {
    var y = int.tryParse(_waldmeister.substring(i-1, i));
    var x = modulo(y! + i, 10);
    _10Y += x.toString();
  }
  return ReverseWherigo10YWaldmeisterCoordinate(
      int.tryParse(_10Y.substring(0, _wLength))!,
      int.tryParse(_10Y.substring(_wLength, _wLength * 2))!,
      int.tryParse(_10Y.substring(_wLength * 2, _wLength * 3))!);
}

ReverseWherigo10YWaldmeisterCoordinate? _parseReverseWherigo10YWaldmeister(String input) {
  RegExp regExp = RegExp(r'^\s*(\d+)(\s*,\s*|\s+)(\d+)(\s*,\s*|\s+)(\d+)\s*$');
  var matches = regExp.allMatches(input);
  if (matches.isEmpty) return null;

  var match = matches.elementAt(0);

  if (match.group(1) == null || match.group(3) == null || match.group(5) == null) {
    return null;
  }

  var a = int.tryParse(match.group(1)!);
  var b = int.tryParse(match.group(3)!);
  var c = int.tryParse(match.group(5)!);

  if (a == null || b == null || c == null) return null;

  var _10Y = ReverseWherigo10YWaldmeisterCoordinate(a, b, c);

  if (!checkSumTest(_wig10YWaldmeisterToWigWaldmeister(_10Y))) return null;
  return _10Y;
}