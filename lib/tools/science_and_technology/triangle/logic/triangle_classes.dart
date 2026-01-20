part of 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

class TriLinearPoint{
  final double x;
  final double y;
  final double z;

  TriLinearPoint({this.x = 0.0, this.y = 0.0, this.z = 0.0});
}

class PolarPoint{
  final double r;
  final double phi;

  PolarPoint({this.r = 0.0, this.phi = 0.0});

  XYPoint toXYZPoint() {
    // https://mathepedia.de/Kugelkoordinaten.html
    return XYPoint(
      x: r * cos(phi),
      y: r * sin(phi),
    );
  }
}

class XYPoint{
  final double x;
  final double y;

  XYPoint({this.x = 0.0, this.y = 0.0});

  XYPoint operator +(XYPoint other) => XYPoint(x: x + other.x, y: y + other.y);
  XYPoint operator /(double s) => XYPoint(x: x / s, y: y / s);

  PolarPoint toPolarPoint(){
    // https://mathepedia.de/Kugelkoordinaten.html
    return PolarPoint(
      r: sqrt(x* x + y * y),
      phi: (y >= 0) ? acos(x / sqrt(x * x + y * y)) : 2 * pi - acos(x / sqrt(x * x + y * y)),
    );
  }

  XYPoint fromLatLon(LatLng coords){
    return XYPoint(x: coords.latitude, y: coords.longitude);
  }

  LatLng toLatLon(){
    return LatLng(x, y);
  }

}

class Sides{
  final double a;
  final double b;
  final double c;

  Sides({this.a = 0.0, this.b = 0.0, this.c = 0.0});
}

class Angles{
  final double alpha;
  final double beta;
  final double gamma;

  Angles({this.alpha = 0.0, this.beta = 0.0, this.gamma = 0.0});
}

class XYLine{
  double m;
  double a;
  final XYPoint P1;
  final XYPoint P2;

  XYLine({this.m = 0, this.a = 0, required this.P1, required this.P2}){
    m = (P2.y - P1.y) / (P2.x - P1.x);
    a = (P1.y * P2.x - P2.y * P1.x) / (P2.x - P1.x);
  }
}

class XYCircle{
  final double x;
  final double y;
  final double r;

  XYCircle({this.x = 0.0, this.y = 0.0, this.r = 0.0});
}
