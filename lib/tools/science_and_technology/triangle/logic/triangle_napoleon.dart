part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';


/// Multipliziert eine komplexe Zahl (x + i*y) mit ω = e^(2πi/3)
XYPoint multiplyWithOmega(XYPoint p) {
  const double real = -0.5;
  final double imag = sqrt(3) / 2;

  return XYPoint(
    x: real * p.x - imag * p.y,
    y: imag * p.x + real * p.y,
  );
}

/// Multipliziert eine komplexe Zahl (x + i*y) mit ω² = e^(4πi/3)
XYPoint multiplyWithOmega2(XYPoint p) {
  const double real = -0.5;
  double imag = -sqrt(3) / 2;

  return XYPoint(
    x: real * p.x - imag * p.y,
    y: imag * p.x + real * p.y,
  );
}

/// Innerer Napoleonpunkt
XYPoint triangleNapoleonInnerXY(XYPoint a, XYPoint b, XYPoint c) {
  final bOmega = multiplyWithOmega(b);
  final cOmega2 = multiplyWithOmega2(c);

  return (a + bOmega + cOmega2) / 3.0;
}

/// Äußerer Napoleonpunkt
XYPoint triangleNapoleonOuterXY(XYPoint a, XYPoint b, XYPoint c) {
  // ω und ω² werden vertauscht
  final bOmega2 = multiplyWithOmega2(b);
  final cOmega = multiplyWithOmega(c);

  return (a + bOmega2 + cOmega) / 3.0;
}

Map<String, LatLng> _napoleonPoints(LatLng A, LatLng B, LatLng C) {
  List<LatLng> pointsA = equilateralTriangle(B, C, defaultEllipsoid);
  List<LatLng> pointsB = equilateralTriangle(C, A, defaultEllipsoid);
  print(buildCoordinate(CoordinateFormat(CoordinateFormatKey.DMM), pointsA[0], defaultEllipsoid).toString().replaceAll('\n', '   '));
  print(buildCoordinate(CoordinateFormat(CoordinateFormatKey.DMM), pointsA[1], defaultEllipsoid).toString().replaceAll('\n', '   '));
  print(buildCoordinate(CoordinateFormat(CoordinateFormatKey.DMM), pointsB[0], defaultEllipsoid).toString().replaceAll('\n', '   '));
  print(buildCoordinate(CoordinateFormat(CoordinateFormatKey.DMM), pointsB[1], defaultEllipsoid).toString().replaceAll('\n', '   '));


  LatLng NACout;
  LatLng NACin;
  LatLng NBCout;
  LatLng NBCin;

  if (distanceBearing(A, pointsA[0], defaultEllipsoid).distance >
      distanceBearing(A, pointsA[1], defaultEllipsoid).distance) {
    NBCout = centroidCenterOfGravity([B, C, pointsA[0]])!;
    NBCin = centroidCenterOfGravity([B, C, pointsA[1]])!;
  } else {
    NBCout = centroidCenterOfGravity([B, C, pointsA[1]])!;
    NBCin = centroidCenterOfGravity([B, C, pointsA[0]])!;
  }

  if (distanceBearing(B, pointsB[0], defaultEllipsoid).distance >
      distanceBearing(B, pointsB[1], defaultEllipsoid).distance) {
    NACout = centroidCenterOfGravity([A, C, pointsB[0]])!;
    NACin = centroidCenterOfGravity([A, C, pointsB[1]])!;
  } else {
    NACout = centroidCenterOfGravity([A, C, pointsB[1]])!;
    NACin = centroidCenterOfGravity([A, C, pointsB[0]])!;
  }

  return {
    'inner' : intersectFourPoints(NACin, B, NBCin, A, defaultEllipsoid),
    'outer': intersectFourPoints(NACout, B, NBCout, A, defaultEllipsoid),
  };
}


LatLng triangleNapoleonInnerMap(LatLng A, LatLng B, LatLng C) {
  return _napoleonPoints(A, B, C)['inner']!;
}

LatLng triangleNapoleonOuterMap(LatLng A, LatLng B, LatLng C) {
    return _napoleonPoints(A, B, C)["outer"]!;
}

