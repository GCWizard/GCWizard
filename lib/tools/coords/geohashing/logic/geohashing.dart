import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const _VALID_CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const _domain = 'http://geo.crox.net/djia';

enum ErrorCode { Ok, futureDate, invalidDate }

class Geohashing {
  int latitude;
  int longitude;
  DateTime date;
  double dowJonesIndex;
  LatLng? location;
  ErrorCode errorCode = ErrorCode.Ok;

  Geohashing(this.date, this.latitude, this.longitude, {this.dowJonesIndex = 0});

  Future<LatLng?> toLatLng() async {
    location = await geohashingToLatLon(this);
    return location;
  }

  static Geohashing? parse(String input) {
    return parseGeohashing(input);
  }

  @override
  String toString([int? precision]) {
    return DateFormat('yyyy-MM-dd').format(date) + ' ' + latitude.toString() + ' ' + longitude.toString();
  }
}

Future<LatLng?> geohashingToLatLon(Geohashing geohashing) async {
  if (geohashing.dowJonesIndex <= 0) {
    var _date = geohashing.date;
    if (w30RuleNecessary(geohashing)) {
      _date = _date.add(const Duration(days: -1));
    }
    if (_validDate(_date) != ErrorCode.Ok && _date.weekday >= 6) {
      _date = _date.add(Duration(days: (_date.weekday == 6 ? -1 : -2)));
    }
    var dji = await dowJonesIndex(_date);
    geohashing.dowJonesIndex = dji ?? 0;
    if (dji == null) {
      geohashing.errorCode = _validDate(_date) != ErrorCode.Ok ? ErrorCode.futureDate : ErrorCode.invalidDate;
    }
  }
  if (geohashing.dowJonesIndex == 0) return null;

  var date = DateFormat('yyyy-MM-dd').format(geohashing.date);
  var format = NumberFormat('0.00');
  var md5 = md5Digest(date + '-' + format.format(geohashing.dowJonesIndex));

  var lat = _hexToDec(md5.substring(0, 15));
  var lng = _hexToDec(md5.substring(16));

  return LatLng((geohashing.latitude.abs() + lat) * (geohashing.latitude < 0 ? -1 : 1),
      (geohashing.longitude.abs() + lng) * (geohashing.longitude < 0 ? -1 : 1));
}

Geohashing? parseGeohashing(String input) {
  var regExp = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
  if (regExp.hasMatch(input)) {
    var match = regExp.firstMatch(input);
    var decString = input.substring(0, match!.start);
    var dec = DECCoordinate.parse(decString); // test before date

    if (dec == null) {
      decString = input.substring(match.end);
      dec = DECCoordinate.parse(decString); // test after date
    }
    if (dec != null) {
      return Geohashing(DateTime(int.parse(match.group(1)!), int.parse(match.group(2)!), int.parse(match.group(3)!)),
          dec.latitude.truncate(), dec.longitude.truncate());
    }
  }
  return null;
}

ErrorCode _validDate(DateTime date) {
  return (DateTime.now().difference(date).isNegative) ? ErrorCode.invalidDate : ErrorCode.Ok;
}

Future<double?> dowJonesIndex(DateTime date) async {
  if (_validDate(date) != ErrorCode.Ok) return null;

  var uri = Uri.parse(_domain + '/' + DateFormat('yyyy-MM-dd').format(date));
  var encoding = Encoding.getByName('utf-8');

  http.Response response = await http.post(
    uri,
    encoding: encoding,
  );
  if (response.statusCode != 200) return null;

  return double.parse(response.body);
}

/// For every location east of Longitude -30
/// (Europe, Africa, Asia, and Australia), use the Dow opening from
/// the previous day — even if a new one becomes available
bool w30RuleNecessary(Geohashing geohashing) {
  return geohashing.longitude > -30;
}

double _hexToDec(String input) {
  var t = _toValidChars(input)
      .split('')
      .toList()
      .mapIndexed((index, char) => _charToValue(char, index))
      .reduce((memo, element) => memo + element);

  return t;
}

String _toValidChars(String input) {
  return input = input.toUpperCase().replaceAll(RegExp('[^' + _VALID_CHARS + ']'), '');
}

double _charToValue(String char, int index) {
  return _VALID_CHARS.indexOf(char) * pow(16, -(index + 1)).toDouble();
}
