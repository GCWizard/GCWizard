import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/constants.dart';

const ELLIPSOID_NAME_WGS84 = 'WGS84';
const ELLIPSOID_NAME_AIRY1830 = 'Airy 1830';
const ELLIPSOID_NAME_AIRYMODIFIED = 'Airy Modified';
const ELLIPSOID_NAME_BESSEL1841 = 'Bessel 1841';
const ELLIPSOID_NAME_CLARKE1866 = 'Clarke 1866';
const ELLIPSOID_NAME_HAYFORD1924 = 'Hayford 1924';
const ELLIPSOID_NAME_KRASOVSKY1940 = 'Krasovsky 1940';

enum EllipsoidType { STANDARD, USER_DEFINED }

class Ellipsoid {
  final String? name;
  final double a;
  final double invf;
  final EllipsoidType type;

  const Ellipsoid(this.name, this.a, this.invf, {this.type = EllipsoidType.STANDARD});

  double get b {
    return a * (1 - 1 / (invf == 0.0 ? practical_epsilon : invf));
  }

  double get sphereRadius {
    return sqrt(a * b);
  }

  double get f {
    return 1.0 / (invf == 0.0 ? practical_epsilon : invf);
  }

  double get e {
    return sqrt(a * a - b * b) / (a == 0.0 ? practical_epsilon : a);
  }

  double get e2 {
    return e * e;
  }

  static Ellipsoid get WGS84 {
    return getEllipsoidByName(ELLIPSOID_NAME_WGS84)!;
  }

  @override
  String toString() {
    return 'name: $name, a: $a, invf: $invf, type: $type';
  }
}

const List<Ellipsoid> allEllipsoids = [
  Ellipsoid(ELLIPSOID_NAME_WGS84, 6378137.0, 298.257223563),
  Ellipsoid('coords_ellipsoid_earthsphere', 6371000.0, 100000000000.0),
  Ellipsoid('coords_ellipsoid_sun', 696342000.0, 111111.11111111111111111111),
  Ellipsoid('coords_ellipsoid_moon', 1737400.0, 833.333333333333333333333333),
  Ellipsoid('coords_ellipsoid_mercury', 2439700.0, 1000000000.0),
  Ellipsoid('coords_ellipsoid_venus', 6051800.0, 1000000000.0),
  Ellipsoid('coords_ellipsoid_mars', 3389500.0, 169.77928692699490662139219015),
  Ellipsoid('coords_ellipsoid_jupiter', 69911000.0, 15.41544627716972406351163866),
  Ellipsoid('coords_ellipsoid_saturn', 58232000.0, 10.208248264597795018374846876),
  Ellipsoid('coords_ellipsoid_uranus', 25362000.0, 43.66812227074235807860262),
  Ellipsoid('coords_ellipsoid_neptune', 24622000.0, 58.47953216374269),
  Ellipsoid('coords_ellipsoid_pluto', 1188300.0, 1000000000.0),
  Ellipsoid(ELLIPSOID_NAME_AIRY1830, 6377563.396, 299.32496126649505),
  Ellipsoid(ELLIPSOID_NAME_AIRYMODIFIED, 6377340.189, 299.32496546352854),
  Ellipsoid('ATS77', 6378135.0, 298.257),
  Ellipsoid('Australien Nat.', 6377340.189, 299.32496546352854),
  Ellipsoid(ELLIPSOID_NAME_BESSEL1841, 6377397.155, 299.15281285),
  Ellipsoid('Bessel 1841 NAM', 6377483.865, 299.15281285),
  Ellipsoid('Bessel Modified', 6377492.018, 299.15281285),
  Ellipsoid('Clarke1858', 6378293.645, 294.26068),
  Ellipsoid(ELLIPSOID_NAME_CLARKE1866, 6378206.4, 294.9786982139),
  Ellipsoid('Clarke 1866 Michigan', 6378450.24, 294.97870),
  Ellipsoid('Clarke 1880', 6378249.145, 293.465),
  Ellipsoid('Clarke 1880 Arc', 6378249.145, 293.4663077),
  Ellipsoid('Clarke 1880 Benoit', 6378300.789, 293.466316),
  Ellipsoid('Clarke 1880 IGN', 6378249.2, 293.466021),
  Ellipsoid('Clarke 1880 RGS', 6378249.145, 293.4650060791153),
  Ellipsoid('Clarke 1880 SGA 1922', 6378249.2, 293.46598),
  Ellipsoid('Danish 1876', 6377019.27, 300.0),
  Ellipsoid('Delambre 1810', 6376985.0, 308.6465),
  Ellipsoid('Earth-90', 6378136.0, 298.257839303),
  Ellipsoid('ED50', 6378388.0, 297.0),
  Ellipsoid('Everest India 1830', 6377276.345, 300.8017),
  Ellipsoid('Everest Malaysia 1830', 6377298.556, 300.8017),
  Ellipsoid('Everest Sabah Sarawak 1830', 6377298.556, 300.8017),
  Ellipsoid('Everest Modified 1830', 6377304.063, 300.8017),
  Ellipsoid('Everest India 1956', 6377301.243, 300.8017),
  Ellipsoid('Everest 1830, 62 Def', 6377299.151, 300.8017255),
  Ellipsoid('Everest 1830, 75 Def', 6377301.243, 300.8017255),
  Ellipsoid('Everest Malaysia Singapore 1964', 6377304.063, 300.8017),
  Ellipsoid('Everest Malaysia 1969', 6377295.664, 300.8017),
  Ellipsoid('Everest RSO 1969', 6377295.664, 300.8017),
  Ellipsoid('Everest Pakistan', 6377309.613, 300.81589522323446),
  Ellipsoid('Fischer (Mercury) 1960', 6378166.0, 298.3),
  Ellipsoid('Fischer (Modified) 1960', 6378155.0, 298.3),
  Ellipsoid('Fischer 1968', 6378150.0, 298.3),
  Ellipsoid('GEM 10C', 6378137.0, 298.257223563),
  Ellipsoid('GRS67', 6378160.0, 298.247167427),
  Ellipsoid('GRS80', 6378137.0, 298.257222101),
  Ellipsoid(ELLIPSOID_NAME_HAYFORD1924, 6378388.0, 297.0),
  Ellipsoid('Helmert 1906', 6378200.0, 298.3),
  Ellipsoid('Hough 1960', 6378270.0, 297.0),
  Ellipsoid('Hughes 1980', 6378273.0, 298.279411),
  Ellipsoid('IAU76', 6378140.0, 268.2569978029),
  Ellipsoid('Indonesian 1974', 6378160.0, 298.247),
  Ellipsoid('International 1924', 6378388.0, 297.0),
  Ellipsoid(ELLIPSOID_NAME_KRASOVSKY1940, 6378245.0, 298.3),
  Ellipsoid('NAD27', 6378206.4, 294.9786982139),
  Ellipsoid('NAD83', 6378137.0, 298.257222101),
  Ellipsoid('NTF', 6378249.145, 293.4650060791),
  Ellipsoid('NWL 9D', 6378145.0, 298.25),
  Ellipsoid('OSU86F', 6378136.2, 298.257223563),
  Ellipsoid('OSU91A', 6378136.3, 298.257223563),
  Ellipsoid('Plessis 1817', 6376523.0, 308.64),
  Ellipsoid('PUK', 6378245.0, 298.3000031662),
  Ellipsoid('SAD69', 6377340.189, 299.32496546352854),
  Ellipsoid('Schmidt 1828', 6376804.37, 302.02),
  Ellipsoid('Soviet-1985', 6378136.0, 298.2570060143),
  Ellipsoid('Struve 1860', 6378298.3, 294.73),
  Ellipsoid('War Office', 6378300.0, 296.0),
  Ellipsoid('WGS60', 6378165.0, 298.3),
  Ellipsoid('WGS66', 6378145.0, 298.25),
  Ellipsoid('WGS72', 6378135.0, 298.26),
  Ellipsoid('Xian 1980', 6378140.0, 298.257),
];

Ellipsoid? getEllipsoidByName(String name) {
  return allEllipsoids.firstWhereOrNull((ells) => ells.name == name);
}
