import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';

part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java/s2.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java/s2cellid.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java/s2latlng.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java/s2point.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java/s2projections.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/external_libs/google.s2-geometry-library-java/s2-geometry-library-java.dart';

const defaultS2CellsHilbertType = CoordinateFormatKey.S2CELLS_HILBERT_QUADRATIC;
const s2CellsHilbertKey = 'coords_s2cellshilbert';
final _defaultCoordinate = S2CellsHilbertCoordinate('1000000000000001', defaultS2CellsHilbertType);

final S2CellsHilbertFormatDefinition = CoordinateFormatWithSubtypesDefinition(
    CoordinateFormatKey.S2CELLS_HILBERT,
    s2CellsHilbertKey,
    s2CellsHilbertKey,
    [
      CoordinateFormatDefinition(CoordinateFormatKey.S2CELLS_HILBERT_QUADRATIC, 'coords_s2cellshilbert_quadratic', 'coords_s2cellshilbert_quadratic',
          S2CellsHilbertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.S2CELLS_HILBERT_TAN, 'coords_s2cellshilbert_tan', 'coords_s2cellshilbert_tan',
          S2CellsHilbertCoordinate.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.S2CELLS_HILBERT_LINEAR, 'coords_s2cellshilbert_linear', 'coords_s2cellshilbert_linear',
          S2CellsHilbertCoordinate.parse, _defaultCoordinate),
    ],
    S2CellsHilbertCoordinate.parse,
    _defaultCoordinate);

class S2CellsHilbertCoordinate extends BaseCoordinateWithSubtypes {
  late CoordinateFormat _format;
  @override
  CoordinateFormat get format => _format;
  String token;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid S2Cells/Hilbert subtype given.';

  S2CellsHilbertCoordinate(this.token, CoordinateFormatKey subtypeKey) {
    if (subtypeKey != defaultS2CellsHilbertType && !isSubtypeOfCoordinateFormat(CoordinateFormatKey.S2CELLS_HILBERT, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.S2CELLS_HILBERT, subtypeKey);
  }

  @override
  LatLng? toLatLng() {
    return _s2CellsHilbertToLatLng(this);
  }

  static S2CellsHilbertCoordinate fromLatLon(LatLng coord, CoordinateFormatKey subtype) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.S2CELLS_HILBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _latLonToS2CellsHilbert(coord, subtype);
  }

  static S2CellsHilbertCoordinate? parse(String input, {CoordinateFormatKey subtype = defaultS2CellsHilbertType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.S2CELLS_HILBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _parseS2CellsHilbert(input, subtype: subtype);
  }

  @override
  CoordinateFormatKey get defaultSubtype => defaultS2CellsHilbertType;

  @override
  String toString([int? precision]) {
    return token;
  }
}

_S2CellsProjections _subtypeToProjection(CoordinateFormatKey subtype) {
  switch (subtype) {
    case CoordinateFormatKey.S2CELLS_HILBERT_QUADRATIC: return _S2CellsProjections.QUADRATIC;
    case CoordinateFormatKey.S2CELLS_HILBERT_TAN: return _S2CellsProjections.TAN;
    case CoordinateFormatKey.S2CELLS_HILBERT_LINEAR: return _S2CellsProjections.LINEAR;
    default: return _S2CellsProjections.QUADRATIC;
  }
}

S2CellsHilbertCoordinate _latLonToS2CellsHilbert(LatLng coord, CoordinateFormatKey subtype) {
  var token = _latLonToS2Cells(coord, projection: _subtypeToProjection(subtype));
  return S2CellsHilbertCoordinate(token, subtype);
}

LatLng? _s2CellsHilbertToLatLng(S2CellsHilbertCoordinate s2cells) {
  if (s2cells.token.isEmpty) return null;
  return _s2cellsToLatLng(s2cells.token, projection: _subtypeToProjection(s2cells.format.subtype!));
}

S2CellsHilbertCoordinate? _parseS2CellsHilbert(String input, {CoordinateFormatKey subtype = defaultS2CellsHilbertType}) {
  input = input.toLowerCase().replaceAll(RegExp(r'[^0-9a-f]'), '');
  if (!input.startsWith(RegExp(r'[0-5]'))) {
    return null;
  }
  return S2CellsHilbertCoordinate(input, subtype);
}