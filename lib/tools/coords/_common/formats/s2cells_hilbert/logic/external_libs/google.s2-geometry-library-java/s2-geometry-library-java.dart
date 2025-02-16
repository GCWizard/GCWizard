part of 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/s2cells_hilbert.dart';

enum _S2CellsProjections{LINEAR, TAN, QUADRATIC}

_S2Projections _getProjection(_S2CellsProjections projection) {
  switch (projection) {
    case _S2CellsProjections.LINEAR: return _S2_LINEAR_PROJECTION();
    case _S2CellsProjections.TAN: return _S2_TAN_PROJECTION();
    case _S2CellsProjections.QUADRATIC: return _S2_QUADRATIC_PROJECTION();
  }
}

LatLng _s2cellsToLatLng(String s2CellsToken, {_S2CellsProjections projection = _S2CellsProjections.QUADRATIC}) {
  _setS2Projection(_getProjection(projection));

  _S2CellId s2cellId;

  try {
    s2cellId = _S2CellId.fromToken(s2CellsToken);
  } catch(e) {
    s2cellId = _S2CellId.NONE;
  }

  var s2LatLng = s2cellId.toLatLng();
  var latitude = radianToDeg(s2LatLng.latRadians);
  var longitude = radianToDeg(s2LatLng.lngRadians);

  return LatLng(latitude, longitude);
}

String _latLonToS2Cells(LatLng coords, {_S2CellsProjections projection = _S2CellsProjections.QUADRATIC}) {
  _setS2Projection(_getProjection(projection));

  var s2LatLng = _S2LatLng(coords.latitudeInRad, coords.longitudeInRad);
  var s2Cells = _S2CellId.fromLatLng(s2LatLng);

  return s2Cells.toToken().toLowerCase();
}