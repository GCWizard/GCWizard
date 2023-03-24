/*
 *  Dart port of https://github.com/djvanderlaan/rijksdriehoek/blob/master/js/rijksdriehoek.js
 *  MIT license
 *
 *  which is implementation of
 *  https://web.archive.org/web/20041206052853/http://www.dekoepel.nl/pdf/Transformatieformules.pdf
 *
 */

part of 'package:gc_wizard/tools/coords/format_converter/logic/dutchgrid.dart';

// Coordinates of origin (Amersfoort)
const _X0 = 155000.0;
const _Y0 = 463000.0;
const _LAT0 = 52.15517440;
const _LON0 = 5.38720621;

List<double> _rijksdriehoek(double lon, double lat) {
  final R = [
    {"p": 0, "q": 1, "R": 190094.945},
    {"p": 1, "q": 1, "R": -11832.228},
    {"p": 2, "q": 1, "R": -114.221},
    {"p": 0, "q": 3, "R": -32.391},
    {"p": 1, "q": 0, "R": -0.705},
    {"p": 3, "q": 1, "R": -2.340},
    {"p": 1, "q": 3, "R": -0.608},
    {"p": 0, "q": 2, "R": -0.008},
    {"p": 2, "q": 3, "R": 0.148}
  ];

  final S = [
    {"p": 1, "q": 0, "S": 309056.544},
    {"p": 0, "q": 2, "S": 3638.893},
    {"p": 2, "q": 0, "S": 73.077},
    {"p": 1, "q": 2, "S": -157.984},
    {"p": 3, "q": 0, "S": 59.788},
    {"p": 0, "q": 1, "S": 0.433},
    {"p": 2, "q": 2, "S": -6.439},
    {"p": 1, "q": 1, "S": -0.032},
    {"p": 0, "q": 4, "S": 0.092},
    {"p": 1, "q": 4, "S": -0.054}
  ];

  var dLat = 0.36 * (lat - _LAT0);
  var dLon = 0.36 * (lon - _LON0);
  var x = _X0;

  for (var i = 0; i < R.length; ++i) {
    var p = R[i]['p'];
    var q = R[i]['q'];
    var r = R[i]['R'];
    x += r! * pow(dLat, p!) * pow(dLon, q!);
  }

  var y = _Y0;
  for (var i = 0; i < S.length; ++i) {
    var p = S[i]['p'];
    var q = S[i]['q'];
    var s = S[i]['S'];
    y += s! * pow(dLat, p!) * pow(dLon, q!);
  }

  return [x, y];
}

List<double> _rijksdriehoekInverse(double x, double y) {
  final K = [
    {"p": 0, "q": 1, "K": 3235.65389},
    {"p": 2, "q": 0, "K": -32.58297},
    {"p": 0, "q": 2, "K": -0.24750},
    {"p": 2, "q": 1, "K": -0.84978},
    {"p": 0, "q": 3, "K": -0.06550},
    {"p": 2, "q": 2, "K": -0.01709},
    {"p": 1, "q": 0, "K": -0.00738},
    {"p": 4, "q": 0, "K": 0.00530},
    {"p": 2, "q": 3, "K": -0.00039},
    {"p": 4, "q": 1, "K": 0.00033},
    {"p": 1, "q": 1, "K": -0.00012}
  ];

  final L = [
    {"p": 1, "q": 0, "L": 5260.52916},
    {"p": 1, "q": 1, "L": 105.94684},
    {"p": 1, "q": 2, "L": 2.45656},
    {"p": 3, "q": 0, "L": -0.81885},
    {"p": 1, "q": 3, "L": 0.05594},
    {"p": 3, "q": 1, "L": -0.05607},
    {"p": 0, "q": 1, "L": 0.01199},
    {"p": 3, "q": 2, "L": -0.00256},
    {"p": 1, "q": 4, "L": 0.00128}
  ];

  var dx = (x - _X0) / 1E5;
  var dy = (y - _Y0) / 1E5;
  var lat = _LAT0;

  for (var i = 0; i < K.length; ++i) {
    var p = K[i]['p'];
    var q = K[i]['q'];
    var k = K[i]['K'];
    lat += k! * pow(dx, p!) * pow(dy, q!) / 3600.0;
  }

  var lon = _LON0;
  for (var i = 0; i < L.length; ++i) {
    var p = L[i]['p'];
    var q = L[i]['q'];
    var l = L[i]['L'];
    lon += l! * pow(dx, p!) * pow(dy, q!) / 3600.0;
  }

  return [lon, lat];
}
