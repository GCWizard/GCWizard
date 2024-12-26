import 'dart:math';

import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/science_and_technology/colors/logic/colors_rgb.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:latlong2/latlong.dart';

String randomLetter(Alphabet alphabet, bool caseSensitive) {
  var length = alphabet.alphabet.length;
  var random = Random();
  var randomIndex = random.nextInt(length);
  var randomLetter = alphabet.alphabet.keys.toList()[randomIndex];

  if (!caseSensitive) {
    var randomCase = random.nextInt(2);
    randomLetter = randomCase == 0 ? randomLetter.toUpperCase() : randomLetter.toLowerCase();
  }
  return randomLetter;
}

int randomInteger(int start, int end) {
  if (start > end) {
    var temp = end;
    end = start;
    start = temp;
  }

  return Random().nextInt(end + 1 - start) + start;
}

double randomDouble(double start, double end) {
  if (start > end) {
    var temp = end;
    end = start;
    start = temp;
  }

  return Random().nextDouble() * (end - start) + start;
}

RGB randomColor() {
  var random = Random();
  var r = random.nextInt(256);
  var g = random.nextInt(256);
  var b = random.nextInt(256);

  return RGB(r.toDouble(), g.toDouble(), b.toDouble());
}

String passwordGenerator(String characters, int length) {
  var out = '';
  if (characters.isEmpty || length <= 0) {
    return out;
  }

  var random = Random();
  for (int i = 0; i < length; i++) {
    var index = random.nextInt(characters.length);
    out += characters[index];
  }

  return out;
}

DateTime randomDateTime(DateTime from, DateTime to) {
  var seconds = to.difference(from).inSeconds;
  var randomSeconds = randomInteger(0, seconds);
  return from.add(Duration(seconds: randomSeconds));
}

LatLng randomCoordinateAroundPoint(LatLng center, double maxDistance, Ellipsoid ellipsoid) {
  var bearing = randomDouble(0.0, 360.0);
  var distance = randomDouble(0.0, maxDistance);

  return projection(center, bearing, distance, ellipsoid);
}

LatLng randomCoordinateInsideBounds(LatLng northWest, LatLng southEast) {
  var north = northWest.latitude;
  var west = northWest.longitude;
  var south = southEast.latitude;
  var east = southEast.longitude;

  if (west > east) {
    east += 360.0;
  }

  var lat = randomDouble(south, north);
  var lon = randomDouble(west, east);

  if (lon > 180.0) {
    lon -= 360.0;
  }

  return LatLng(lat, lon);
}