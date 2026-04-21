import 'package:latlong2/latlong.dart';

List<Map<String, Object?>> validEllipsoidTrianglesForTests = [
  //Very narrow
  {'inputA': LatLng(70, 0), 'inputB': LatLng(13.56832726660199, 74.33418761525557), 'inputC': LatLng(38.59652460733987, 62.72751487512538)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3)}, // NOT SAME LINE IN GEODETICS!

  //On same meridian/great circle/geodetic
  {'inputA': LatLng(80, 10), 'inputB': LatLng(-80, 10), 'inputC': LatLng(0, -170)},
  {'inputA': LatLng(80, 0), 'inputB': LatLng(-80, 0), 'inputC': LatLng(0, 180)},
  {'inputA': LatLng(80, -180), 'inputB': LatLng(70, 180), 'inputC': LatLng(60, 170)},

  //Poles
  {'inputA': LatLng(90, 0), 'inputB': LatLng(0,0), 'inputC': LatLng(0, 90)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(0,0), 'inputC': LatLng(0, 90)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(0,0), 'inputC': LatLng(0, -90)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(0,0), 'inputC': LatLng(0, -90)},

  //Antipodes
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180), 'inputC': LatLng(1, 1)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(89.9, 90)},
  {'inputA': LatLng(1, 0), 'inputB': LatLng(1, 180),'inputC': LatLng(89.9, 90)},
  {'inputA': LatLng(70, 0), 'inputB': LatLng(70, 180),'inputC': LatLng(89.9, 90)},
  {'inputA': LatLng(88, 0), 'inputB': LatLng(88, 180),'inputC': LatLng(89.9, 90)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(89.9, 89.99)},
  {'inputA': LatLng(70, 0), 'inputB': LatLng(70, 180),'inputC': LatLng(89.9, 89.99)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(89.99, 89.9)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(-89.99, 89.9)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(-89.9, 90)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(-89.9, 89.99)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(-1, -179), 'inputC': LatLng(-1, -1)},
  {'inputA': LatLng(-1, -1), 'inputB': LatLng(1, 179), 'inputC': LatLng(1, 1)},
  {'inputA': LatLng(1, -1), 'inputB': LatLng(-1, 179), 'inputC': LatLng(1, 1)},

  //Around Poles
  {'inputA': LatLng(89.999, 0), 'inputB': LatLng(89.999, 120), 'inputC': LatLng(89.999, -120)},
  {'inputA': LatLng(89.999, 100), 'inputB': LatLng(89.999, 120), 'inputC': LatLng(89.999, 140)},
  {'inputA': LatLng(-89.999, 0), 'inputB': LatLng(-89.999, 120), 'inputC': LatLng(-89.999, -120)},

  //Equator
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 120), 'inputC': LatLng(0, -120)},

  //Around 0/0
  {'inputA': LatLng(-0.01, 0), 'inputB': LatLng(0.01, -0.01), 'inputC': LatLng(0.01, 0.01)},
  {'inputA': LatLng(-0.01, 0), 'inputB': LatLng(0.01, 0.01), 'inputC': LatLng(0.01, -0.01)},
  {'inputA': LatLng(0.01, 0), 'inputB': LatLng(-0.01, -0.01), 'inputC': LatLng(-0.01, 0.01)},
  {'inputA': LatLng(0.01, 0), 'inputB': LatLng(-0.01, 0.01), 'inputC': LatLng(-0.01, -0.01)},

  //Around Lon +-180
  {'inputA': LatLng(-10, 180), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, 179), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, -179), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, -179), 'inputB': LatLng(10, 179.9), 'inputC': LatLng(15, -179.9)},
  {'inputA': LatLng(10, 180), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, 179), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, -179), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, -179), 'inputB': LatLng(-10, 179.9), 'inputC': LatLng(-15, -179.9)},

  //Left and Right from 0 meridian
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, 20), 'inputC': LatLng(40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, -20), 'inputC': LatLng(-40, 30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, 20), 'inputC': LatLng(-40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(-60, 20), 'inputC': LatLng(40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, 10), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, -10), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},

  // Seems concave on Mercator
  {'inputA': LatLng(39, 5), 'inputB': LatLng(43, 85), 'inputC': LatLng(38, 172)},
  {'inputA': LatLng(-39, 5), 'inputB': LatLng(-43, 85), 'inputC': LatLng(-38, 172)},
  {'inputA': LatLng(-39, 5), 'inputB': LatLng(-38, 172), 'inputC': LatLng(-43, 85)},

  //Huge Triangle
  {'inputA': LatLng(49, -156), 'inputB': LatLng(-31, -37), 'inputC': LatLng(67, 5)},
  {'inputA': LatLng(49, -156), 'inputB': LatLng(67, 5), 'inputC': LatLng(-31, -37)},

  //Coordinate Value Overrun
  {'inputA': LatLng(100, -10), 'inputB': LatLng(80, -20), 'inputC': LatLng(105, 30)},
  {'inputA': LatLng(-100, -10), 'inputB': LatLng(-80, -20), 'inputC': LatLng(-105, 30)},
  {'inputA': LatLng(50, -190), 'inputB': LatLng(40, 190), 'inputC': LatLng(45, 180)},
  {'inputA': LatLng(100, -190), 'inputB': LatLng(80, 190), 'inputC': LatLng(105, 180)},

  //Misc
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0)},
  {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8)},
  {'inputA': LatLng(40, 9), 'inputB': LatLng(38, 8), 'inputC': LatLng(42, 9)},
  {'inputA': LatLng(4, -173), 'inputB': LatLng(2, -174), 'inputC': LatLng(0, -9)},
  {'inputA': LatLng(80.0, 170.0), 'inputB': LatLng(80.0, -20.0), 'inputC': LatLng(75.0, -150.0)}
];

List<Map<String, Object?>> invalidEllipsoidTrianglesForTests = [
  //All On Same Point
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1)},
  {'inputA': LatLng(52, 13), 'inputB': LatLng(52, 13), 'inputC': LatLng(52, 13)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(90, 0)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(90, 100)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 0)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 100)},
  {'inputA': LatLng(0,180), 'inputB': LatLng(0, -180), 'inputC': LatLng(0, 180)},

  //Two On Same Point
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(52,13), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 10), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 10), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(52,13), 'inputC': LatLng(-90, 10)},
  {'inputA': LatLng(52,13), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 10)},

  //On same meridian/great circle/geodetic
  {'inputA': LatLng(80, -180), 'inputB': LatLng(70, 180), 'inputC': LatLng(60, 180)},
  {'inputA': LatLng(80, 0), 'inputB': LatLng(70, 0), 'inputC': LatLng(60, 0)},
  {'inputA': LatLng(90, 100), 'inputB': LatLng(0,0), 'inputC': LatLng(-90,50)},

  //Poles
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 1), 'inputC': LatLng(90, -1)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 1), 'inputC': LatLng(-90, -1)},

  //Antipodes
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(-90, 1)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(90, 89.9)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180),'inputC': LatLng(-90, 89.9)},
  {'inputA': LatLng(-1, 1), 'inputB': LatLng(1, -179), 'inputC': LatLng(1, 1)},

  //Equator
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 1), 'inputC': LatLng(0, 2)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, -1), 'inputC': LatLng(0, 1)},
];