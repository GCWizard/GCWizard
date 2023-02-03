/*
 * Dart port from
 * http://www.makaney.net/mkc_standard.html
 */

// www.makaney.net
// Sept. 9 2011 version 0.2 (Beta)
// Copyright (C) 2011 Makaney Code by Ziyad S. Al-Salloum <zss@zss.net>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of Makaney Code,
// to deal in Makaney Code without restriction, including without limitation the rights to use,
// copy, publish, distribute, sublicense, and/or sell copies, and to permit persons
// to whom Makaney Code is furnished to do so, subject to the following condition:
//
// In your application you refer to the code as 'Makaney Code' or 'MKC'
//---------------------------------------------------------------------------------------
//
//
// Description (JavaScript):
// decimalToBase33(Math.round([latitude or longitude]*10000)) return Makaney Code of the coordinate.
// Example:
// Convert Latitude and longitude (24.4973, 44.38599999999997) to Makaney Code:
// 	decimalToBase33(Math.round(24.4973*10000)); // gives THUN
// 	decimalToBase33(Math.round(44.38599999999997*10000)); // gives MW9K
// 	so Latitude and longitude (24.4973, 44.38599999999997) becomes THUN+MW9K
// Convert Makaney Code to Latitude and longitude:
//	makaneyToLatLon(Makaney Code) returns Latitude and longitude up to X digits.
//	makaneyToLatLon('THUN+MW9K') // gives 24.4973, 44.3860

part of 'package:gc_wizard/tools/coords/format_converter/logic/makaney.dart';

var _zbase33 = 'abo2zptscjkwmgnxqfd984ery3h5l76ui';
var _mbase = 33;

double _base33ToDecimal(String str) {
  var sign = 1;
  if (str[0] == '-') {
    sign = -1;
    str = str.substring(1);
  } else if (str[0] == '+') str = str.substring(1);
  str = str.toLowerCase();
  var sum = 0.0;
  for (var i = 0; i < str.length; i++) sum += _zbase33.indexOf(str[(str.length - 1) - i]) * pow(_mbase, i);
  return sign * sum;
}

String _decimalToBase33(int n) {
  if (n == 0) {
    return 'A';
  }
  var x = n.abs();
  var code = '';
  while (x > 0) {
    code = _zbase33[x % _mbase] + code;
    x = (x / _mbase).floor();
  }
  return ((n < 0) ? '-' + code : code);
}

List<double> _makaneyToLatLon(String str) {
  var pos = str.indexOf('+');

  var lon;
  if (pos != -1)
    lon = _base33ToDecimal(str.substring(pos)) / 10000;
  else {
    pos = str.lastIndexOf('-');
    lon = _base33ToDecimal(str.substring(pos)) / 10000;
  }

  var lat = _base33ToDecimal(str.substring(0, pos)) / 10000;

  return [lat, lon];
}

String _latLonToMakaney(double lat, double lon) {
  var _lat = _decimalToBase33((lat * 10000).floor());
  var _lon = _decimalToBase33((lon * 10000).floor());

  if (_lon.startsWith('-'))
    return _lat + _lon;
  else
    return _lat + '+' + _lon;
}
