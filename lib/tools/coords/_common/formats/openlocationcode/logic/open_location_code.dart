// forked and adjusted from
// https://github.com/google/open-location-code/blob/master/dart/lib/src/open_location_code.dart

/*
 Copyright 2015 Google Inc. All rights reserved.
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const openLocationCodeKey = 'coords_openlocationcode';

final OpenLocationCodeFormatDefinition = CoordinateFormatDefinition(CoordinateFormatKey.OPEN_LOCATION_CODE,
    openLocationCodeKey, openLocationCodeKey, OpenLocationCodeCoordinate.parse, OpenLocationCodeCoordinate(''));

class OpenLocationCodeCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.OPEN_LOCATION_CODE);
  String text;

  OpenLocationCodeCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _openLocationCodeToLatLon(this);
  }

  static OpenLocationCodeCoordinate fromLatLon(LatLng coord, [int codeLength = 14]) {
    return _latLonToOpenLocationCode(coord, codeLength: codeLength);
  }

  static OpenLocationCodeCoordinate? parse(String input) {
    return _parseOpenLocationCode(input);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

/// A separator used to break the code into two parts to aid memorability.
const _separator = '+'; // 43 Ascii

/// The number of characters to place before the separator.
const _separatorPosition = 8;

/// The character used to pad codes.
const _padding = '0'; // 48 in Ascii

/// The character set used to encode the values.
const _codeAlphabet = '23456789CFGHJMPQRVWX';

/// The base to use to convert numbers to/from.
const _encodingBase = _codeAlphabet.length;

/// The maximum value for latitude in degrees.
const _latitudeMax = 90;

/// The maximum value for longitude in degrees.
const _longitudeMax = 180;

// The max number of digits to process in a plus code.
const _maxDigitCount = 15;

/// Maximum code length using lat/lng pair encoding. The area of such a
/// code is approximately 13x13 meters (at the equator), and should be suitable
/// for identifying buildings. This excludes prefix and separator characters.
const _pairCodeLength = 10;

/// First place value of the pairs (if the last pair value is 1).
final _pairFirstPlaceValue = pow(_encodingBase, _pairCodeLength / 2 - 1).toInt();

/// Inverse of the precision of the pair section of the code.
final _pairPrecision = pow(_encodingBase, 3).toInt();

/// The resolution values in degrees for each position in the lat/lng pair
/// encoding. These give the place value of each position, and therefore the
/// dimensions of the resulting area.
//const _pairResolutions = <double>[20.0, 1.0, .05, .0025, .000125];

/// Number of digits in the grid precision part of the code.
const _gridCodeLength = _maxDigitCount - _pairCodeLength;

/// Number of columns in the grid refinement method.
const _gridColumns = 4;

/// Number of rows in the grid refinement method.
const _gridRows = 5;

/// First place value of the latitude grid (if the last place is 1).
final _gridLatFirstPlaceValue = pow(_gridRows, _gridCodeLength - 1).toInt();

/// First place value of the longitude grid (if the last place is 1).
final _gridLngFirstPlaceValue = pow(_gridColumns, _gridCodeLength - 1).toInt();

/// Multiply latitude by this much to make it a multiple of the finest
/// precision.
final _finalLatPrecision = _pairPrecision * pow(_gridRows, _gridCodeLength).toInt();

/// Multiply longitude by this much to make it a multiple of the finest
/// precision.
final _finalLngPrecision = _pairPrecision * pow(_gridColumns, _gridCodeLength).toInt();

/// Minimum length of a code that can be shortened.
//const _minTrimmableCodeLen = 6;

/// Decoder lookup table.
/// Position is ASCII character value, value is:
/// * -2: illegal.
/// * -1: Padding or Separator
/// * >= 0: index in the alphabet.
const _decode = <int>[
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -2, -2, -2, -2, //
  -1, -2, 0, 1, 2, 3, 4, 5, 6, 7, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, 8, -2, -2, 9, 10, 11, -2, 12, -2, -2, 13, -2, -2, //
  14, 15, 16, -2, -2, -2, 17, 18, 19, -2, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, 8, -2, -2, 9, 10, 11, -2, 12, -2, -2, 13, -2, -2, //
  14, 15, 16, -2, -2, -2, 17, 18, 19, -2, -2, -2, -2, -2, -2, -2,
]; //

bool _matchesPattern(String string, Pattern pattern) => string.contains(pattern);

bool _isValid(String code) {
  if (code.length == 1) {
    return false;
  }

  int separatorIndex = code.indexOf(_separator);
  // There must be a single separator at an even index and position should be < SEPARATOR_POSITION.
  if (separatorIndex == -1 ||
      separatorIndex != code.lastIndexOf(_separator) ||
      separatorIndex > _separatorPosition ||
      separatorIndex.isOdd) {
    return false;
  }

  // We can have an even number of padding characters before the separator,
  // but then it must be the final character.
  if (_matchesPattern(code, _padding)) {
    // Short codes cannot have padding.
    if (separatorIndex < _separatorPosition) {
      return false;
    }
    // Not allowed to start with them!
    if (code.indexOf(_padding) == 0) {
      return false;
    }
    // There can only be one group and it must have even length.
    var padMatch = RegExp('($_padding+)').allMatches(code).toList();
    if (padMatch.length != 1) {
      return false;
    }
    var matchLength = padMatch.first.group(0)!.length;
    if (matchLength.isOdd || matchLength > _separatorPosition - 2) {
      return false;
    }
    // If the code is long enough to end with a separator, make sure it does.
    if (!code.endsWith(_separator)) {
      return false;
    }
  }
  // If there are characters after the separator, make sure there isn't just
  // one of them (not legal).
  if (code.length - separatorIndex - 1 == 1) {
    return false;
  }

  // Check code contains only valid characters.
  filterCallback(int ch) => !(ch > _decode.length || _decode[ch] < -1);
  return code.codeUnits.every(filterCallback);
}

// ignore: unused_element
num _clipLatitude(num latitude) => latitude.clamp(-90.0, 90.0);

/// Compute the latitude precision value for a given code length.
///
/// Lengths <= 10 have the same precision for latitude and longitude, but
/// lengths > 10 have different precisions due to the grid method having fewer
/// columns than rows.
// num _computeLatitudePrecision(int codeLength) {
//   if (codeLength <= 10) {
//     return pow(encodingBase, (codeLength ~/ -2) + 2);
//   }
//   return 1 / (pow(encodingBase, 3) * pow(gridRows, codeLength - 10));
// }

/// Determines if a [code] is a valid short code.
///
/// A short Open Location Code is a sequence created by removing four or more
/// digits from an Open Location Code. It must include a separator character.
bool _isShort(String code) {
  // Check it's valid.
  if (!_isValid(code)) {
    return false;
  }
  // If there are less characters than expected before the SEPARATOR.
  if (_matchesPattern(code, _separator) && code.indexOf(_separator) < _separatorPosition) {
    return true;
  }
  return false;
}

/// Determines if a [code] is a valid full Open Location Code.
///
/// Not all possible combinations of Open Location Code characters decode to
/// valid latitude and longitude values. This checks that a code is valid
/// and also that the latitude and longitude values are legal. If the prefix
/// character is present, it must be the first character. If the separator
/// character is present, it must be after four characters.
bool _isFull(String code) {
  if (!_isValid(code)) {
    return false;
  }
  // If it's short, it's not full.
  if (_isShort(code)) {
    return false;
  }
  // Work out what the first latitude character indicates for latitude.
  var firstLatValue = _decode[code.codeUnitAt(0)] * _encodingBase;
  if (firstLatValue >= _latitudeMax * 2) {
    // The code would decode to a latitude of >= 90 degrees.
    return false;
  }
  if (code.length > 1) {
    // Work out what the first longitude character indicates for longitude.
    var firstLngValue = _decode[code.codeUnitAt(1)] * _encodingBase;
    if (firstLngValue >= _longitudeMax * 2) {
      // The code would decode to a longitude of >= 180 degrees.
      return false;
    }
  }
  return true;
}

/// Encode a location into an Open Location Code.
///
/// Produces a code of the specified length, or the default length if no
/// length is provided.
/// The length determines the accuracy of the code. The default length is
/// 10 characters, returning a code of approximately 13.5x13.5 meters. Longer
/// codes represent smaller areas, but lengths > 14 are sub-centimetre and so
/// 11 or 12 are probably the limit of useful codes.
///
/// Args:
///
/// * [latitude]: A latitude in signed decimal degrees. Will be clipped to the
/// range -90 to 90.
/// * [longitude]: A longitude in signed decimal degrees. Will be normalised
/// to the range -180 to 180.
/// * [codeLength]: The number of significant digits in the output code, not
/// including any separator characters.
OpenLocationCodeCoordinate _latLonToOpenLocationCode(LatLng coords, {int codeLength = _pairCodeLength}) {
  if (codeLength % 2 == 1) codeLength--;

  var code = '';

  // Compute the code.
  // This approach converts each value to an integer after multiplying it by
  // the final precision. This allows us to use only integer operations, so
  // avoiding any accumulation of floating point representation errors.

  // Multiply values by their precision and convert to positive.
  // Force to integers so the division operations will have integer results.
  // Note: Dart requires rounding before truncating to ensure precision!
  int latVal = ((coords.latitude + _latitudeMax) * _finalLatPrecision * 1e6).round() ~/ 1e6;
  int lngVal = ((coords.longitude + _longitudeMax) * _finalLngPrecision * 1e6).round() ~/ 1e6;

  // Compute the grid part of the code if necessary.
  if (codeLength > _pairCodeLength) {
    for (var i = 0; i < _maxDigitCount - _pairCodeLength; i++) {
      int lat_digit = latVal % _gridRows;
      int lng_digit = lngVal % _gridColumns;
      int ndx = lat_digit * _gridColumns + lng_digit;
      code = _codeAlphabet[ndx] + code;
      // Note! Integer division.
      latVal ~/= _gridRows;
      lngVal ~/= _gridColumns;
    }
  } else {
    latVal ~/= pow(_gridRows, _gridCodeLength);
    lngVal ~/= pow(_gridColumns, _gridCodeLength);
  }
  // Compute the pair section of the code.
  for (var i = 0; i < _pairCodeLength / 2; i++) {
    code = _codeAlphabet[lngVal % _encodingBase] + code;
    code = _codeAlphabet[latVal % _encodingBase] + code;
    latVal ~/= _encodingBase;
    lngVal ~/= _encodingBase;
  }

  // Add the separator character.
  code = code.substring(0, _separatorPosition) + _separator + code.substring(_separatorPosition);

  // If we don't need to pad the code, return the requested section.
  if (codeLength >= _separatorPosition) {
    return OpenLocationCodeCoordinate(code.substring(0, codeLength + 1));
  }

  // Pad and return the code.
  return OpenLocationCodeCoordinate(
      code.substring(0, codeLength) + (_padding * (_separatorPosition - codeLength)) + _separator);
}

OpenLocationCodeCoordinate? _parseOpenLocationCode(String input) {
  var openLocationCode = OpenLocationCodeCoordinate(input);
  return _openLocationCodeToLatLon(openLocationCode) == null ? null : openLocationCode;
}

String _sanitizeOLCode(String olc) {
  var olcParts = olc.split('+');
  var prefix = olcParts[0].padRight(8, '0');

  var suffix = '';
  if (prefix.length > 8) suffix = prefix.substring(8);

  prefix = prefix.substring(0, 8) + '+';

  if (olcParts.length > 1) suffix += olcParts[1];

  if (suffix.length < 2) suffix = '';

  return prefix + suffix;
}

/// Decodes an Open Location Code into the location coordinates.
LatLng? _openLocationCodeToLatLon(OpenLocationCodeCoordinate openLocationCode) {
  if (openLocationCode.text.isEmpty) return null;

  var len = openLocationCode.text.replaceAll('+', '').length;
  if (len <= 10 && len.isOdd) return null;

  try {
    var code = _sanitizeOLCode(openLocationCode.text);
    if (!_isFull(code)) {
      return null;
    }
    // Strip out separator character (we've already established the code is
    // valid so the maximum is one), padding characters and convert to upper
    // case.
    code = code.replaceAll(_separator, '');
    code = code.replaceAll(RegExp('$_padding+'), '');
    code = code.toUpperCase();
    // Initialise the values for each section. We work them out as integers and
    // convert them to floats at the end.
    var normalLat = -_latitudeMax * _pairPrecision;
    var normalLng = -_longitudeMax * _pairPrecision;
    var gridLat = 0;
    var gridLng = 0;
    // How many digits do we have to process?
    var digits = min(code.length, _pairCodeLength);
    // Define the place value for the most significant pair.
    var pv = _pairFirstPlaceValue;
    // Decode the paired digits.
    for (var i = 0; i < digits; i += 2) {
      normalLat += _codeAlphabet.indexOf(code[i]) * pv;
      normalLng += _codeAlphabet.indexOf(code[i + 1]) * pv;
      if (i < digits - 2) {
        pv = pv ~/ _encodingBase;
      }
    }
    // Convert the place value to a float in degrees.
    var latPrecision = pv / _pairPrecision;
    var lngPrecision = pv / _pairPrecision;
    // Process any extra precision digits.
    if (code.length > _pairCodeLength) {
      // Initialise the place values for the grid.
      var rowpv = _gridLatFirstPlaceValue;
      var colpv = _gridLngFirstPlaceValue;
      // How many digits do we have to process?
      digits = min(code.length, _maxDigitCount);
      for (var i = _pairCodeLength; i < digits; i++) {
        var digitVal = _codeAlphabet.indexOf(code[i]);
        var row = digitVal ~/ _gridColumns;
        var col = digitVal % _gridColumns;
        gridLat += row * rowpv;
        gridLng += col * colpv;
        if (i < digits - 1) {
          rowpv = rowpv ~/ _gridRows;
          colpv = colpv ~/ _gridColumns;
        }
      }
      // Adjust the precisions from the integer values to degrees.
      latPrecision = rowpv / _finalLatPrecision;
      lngPrecision = colpv / _finalLngPrecision;
    }
    // Merge the values from the normal and extra precision parts of the code.
    var lat = normalLat / _pairPrecision + gridLat / _finalLatPrecision;
    var lng = normalLng / _pairPrecision + gridLng / _finalLngPrecision;

    // Return center of code area
    return LatLng((2 * lat + latPrecision) / 2, (2 * lng + lngPrecision) / 2);
  } catch (e) {}

  return null;
}
