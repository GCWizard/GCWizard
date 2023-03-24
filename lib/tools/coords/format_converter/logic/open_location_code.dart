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

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

/// A separator used to break the code into two parts to aid memorability.
const separator = '+'; // 43 Ascii

/// The number of characters to place before the separator.
const separatorPosition = 8;

/// The character used to pad codes.
const padding = '0'; // 48 in Ascii

/// The character set used to encode the values.
const codeAlphabet = '23456789CFGHJMPQRVWX';

/// The base to use to convert numbers to/from.
const encodingBase = codeAlphabet.length;

/// The maximum value for latitude in degrees.
const latitudeMax = 90;

/// The maximum value for longitude in degrees.
const longitudeMax = 180;

// The max number of digits to process in a plus code.
const maxDigitCount = 15;

/// Maximum code length using lat/lng pair encoding. The area of such a
/// code is approximately 13x13 meters (at the equator), and should be suitable
/// for identifying buildings. This excludes prefix and separator characters.
const pairCodeLength = 10;

/// First place value of the pairs (if the last pair value is 1).
final pairFirstPlaceValue = pow(encodingBase, pairCodeLength / 2 - 1).toInt();

/// Inverse of the precision of the pair section of the code.
final pairPrecision = pow(encodingBase, 3).toInt();

/// The resolution values in degrees for each position in the lat/lng pair
/// encoding. These give the place value of each position, and therefore the
/// dimensions of the resulting area.
const pairResolutions = <double>[20.0, 1.0, .05, .0025, .000125];

/// Number of digits in the grid precision part of the code.
const gridCodeLength = maxDigitCount - pairCodeLength;

/// Number of columns in the grid refinement method.
const gridColumns = 4;

/// Number of rows in the grid refinement method.
const gridRows = 5;

/// First place value of the latitude grid (if the last place is 1).
final gridLatFirstPlaceValue = pow(gridRows, gridCodeLength - 1).toInt();

/// First place value of the longitude grid (if the last place is 1).
final gridLngFirstPlaceValue = pow(gridColumns, gridCodeLength - 1).toInt();

/// Multiply latitude by this much to make it a multiple of the finest
/// precision.
final finalLatPrecision = pairPrecision * pow(gridRows, gridCodeLength).toInt();

/// Multiply longitude by this much to make it a multiple of the finest
/// precision.
final finalLngPrecision = pairPrecision * pow(gridColumns, gridCodeLength).toInt();

/// Minimum length of a code that can be shortened.
const minTrimmableCodeLen = 6;

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

  int separatorIndex = code.indexOf(separator);
  // There must be a single separator at an even index and position should be < SEPARATOR_POSITION.
  if (separatorIndex == -1 ||
      separatorIndex != code.lastIndexOf(separator) ||
      separatorIndex > separatorPosition ||
      separatorIndex.isOdd) {
    return false;
  }

  // We can have an even number of padding characters before the separator,
  // but then it must be the final character.
  if (_matchesPattern(code, padding)) {
    // Short codes cannot have padding.
    if (separatorIndex < separatorPosition) {
      return false;
    }
    // Not allowed to start with them!
    if (code.indexOf(padding) == 0) {
      return false;
    }
    // There can only be one group and it must have even length.
    var padMatch = RegExp('($padding+)').allMatches(code).toList();
    if (padMatch.length != 1) {
      return false;
    }
    var matchLength = padMatch.first.group(0)!.length;
    if (matchLength.isOdd || matchLength > separatorPosition - 2) {
      return false;
    }
    // If the code is long enough to end with a separator, make sure it does.
    if (!code.endsWith(separator)) {
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
  if (_matchesPattern(code, separator) && code.indexOf(separator) < separatorPosition) {
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
  var firstLatValue = _decode[code.codeUnitAt(0)] * encodingBase;
  if (firstLatValue >= latitudeMax * 2) {
    // The code would decode to a latitude of >= 90 degrees.
    return false;
  }
  if (code.length > 1) {
    // Work out what the first longitude character indicates for longitude.
    var firstLngValue = _decode[code.codeUnitAt(1)] * encodingBase;
    if (firstLngValue >= longitudeMax * 2) {
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
OpenLocationCode latLonToOpenLocationCode(LatLng coords, {int codeLength = pairCodeLength}) {
  if (codeLength % 2 == 1) codeLength--;

  var code = '';

  // Compute the code.
  // This approach converts each value to an integer after multiplying it by
  // the final precision. This allows us to use only integer operations, so
  // avoiding any accumulation of floating point representation errors.

  // Multiply values by their precision and convert to positive.
  // Force to integers so the division operations will have integer results.
  // Note: Dart requires rounding before truncating to ensure precision!
  int latVal = ((coords.latitude + latitudeMax) * finalLatPrecision * 1e6).round() ~/ 1e6;
  int lngVal = ((coords.longitude + longitudeMax) * finalLngPrecision * 1e6).round() ~/ 1e6;

  // Compute the grid part of the code if necessary.
  if (codeLength > pairCodeLength) {
    for (var i = 0; i < maxDigitCount - pairCodeLength; i++) {
      int lat_digit = latVal % gridRows;
      int lng_digit = lngVal % gridColumns;
      int ndx = lat_digit * gridColumns + lng_digit;
      code = codeAlphabet[ndx] + code;
      // Note! Integer division.
      latVal ~/= gridRows;
      lngVal ~/= gridColumns;
    }
  } else {
    latVal ~/= pow(gridRows, gridCodeLength);
    lngVal ~/= pow(gridColumns, gridCodeLength);
  }
  // Compute the pair section of the code.
  for (var i = 0; i < pairCodeLength / 2; i++) {
    code = codeAlphabet[lngVal % encodingBase] + code;
    code = codeAlphabet[latVal % encodingBase] + code;
    latVal ~/= encodingBase;
    lngVal ~/= encodingBase;
  }

  // Add the separator character.
  code = code.substring(0, separatorPosition) + separator + code.substring(separatorPosition);

  // If we don't need to pad the code, return the requested section.
  if (codeLength >= separatorPosition) {
    return OpenLocationCode(code.substring(0, codeLength + 1));
  }

  // Pad and return the code.
  return OpenLocationCode(code.substring(0, codeLength) + (padding * (separatorPosition - codeLength)) + separator);
}

OpenLocationCode? parseOpenLocationCode(String input) {
  var openLocationCode = OpenLocationCode(input);
  return openLocationCodeToLatLon(openLocationCode) == null ? null : openLocationCode;
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
LatLng? openLocationCodeToLatLon(OpenLocationCode openLocationCode) {
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
    code = code.replaceAll(separator, '');
    code = code.replaceAll(RegExp('$padding+'), '');
    code = code.toUpperCase();
    // Initialise the values for each section. We work them out as integers and
    // convert them to floats at the end.
    var normalLat = -latitudeMax * pairPrecision;
    var normalLng = -longitudeMax * pairPrecision;
    var gridLat = 0;
    var gridLng = 0;
    // How many digits do we have to process?
    var digits = min(code.length, pairCodeLength);
    // Define the place value for the most significant pair.
    var pv = pairFirstPlaceValue;
    // Decode the paired digits.
    for (var i = 0; i < digits; i += 2) {
      normalLat += codeAlphabet.indexOf(code[i]) * pv;
      normalLng += codeAlphabet.indexOf(code[i + 1]) * pv;
      if (i < digits - 2) {
        pv = pv ~/ encodingBase;
      }
    }
    // Convert the place value to a float in degrees.
    var latPrecision = pv / pairPrecision;
    var lngPrecision = pv / pairPrecision;
    // Process any extra precision digits.
    if (code.length > pairCodeLength) {
      // Initialise the place values for the grid.
      var rowpv = gridLatFirstPlaceValue;
      var colpv = gridLngFirstPlaceValue;
      // How many digits do we have to process?
      digits = min(code.length, maxDigitCount);
      for (var i = pairCodeLength; i < digits; i++) {
        var digitVal = codeAlphabet.indexOf(code[i]);
        var row = digitVal ~/ gridColumns;
        var col = digitVal % gridColumns;
        gridLat += row * rowpv;
        gridLng += col * colpv;
        if (i < digits - 1) {
          rowpv = rowpv ~/ gridRows;
          colpv = colpv ~/ gridColumns;
        }
      }
      // Adjust the precisions from the integer values to degrees.
      latPrecision = rowpv / finalLatPrecision;
      lngPrecision = colpv / finalLngPrecision;
    }
    // Merge the values from the normal and extra precision parts of the code.
    var lat = normalLat / pairPrecision + gridLat / finalLatPrecision;
    var lng = normalLng / pairPrecision + gridLng / finalLngPrecision;

    // Return center of code area
    return LatLng((2 * lat + latPrecision) / 2, (2 * lng + lngPrecision) / 2);
  } catch (e) {}

  return null;
}
