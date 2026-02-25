import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';

part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/common_linear_algebra.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_classes.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_vector.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_image.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_image_transform.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_napoleon.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_lemoine.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_gergonne.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_nagel.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_spieker.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_mitten.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_feuerbach.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_anglebisectors.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_medians.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_altitudes.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_sides.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_angles.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_area.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_circumference.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_centroid.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_orthocenter.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_sidesmidpoints.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_anglesmidpoints.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_altitudesbasepoints.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_symmedianpoints.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_incircle.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_circumcircle.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_feuerbachcircle.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_excircle.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_ninepointcenter.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_clawson.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_isodynamic.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_isogonic.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_fermat_torricelli.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_conjugatex11.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_exeter.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_schiffler.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_longchamps.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_kinds.dart';

Map<int, String> SIDE_ANGLE_TYPES = {
  0: 'triangle_euclidic_sss',
  1: 'triangle_euclidic_ssw',
  2: 'triangle_euclidic_sws',
  3: 'triangle_euclidic_sws',
  4: 'triangle_euclidic_wws',
  5: 'triangle_euclidic_wsw',
  6: 'triangle_euclidic_sww',
};

Map<int, List<String>> TRIANGLES_SW_TEXT = {
  0: ['triangle_euclidic_s', 'triangle_euclidic_s', 'triangle_euclidic_s'],
  1: ['triangle_euclidic_s', 'triangle_euclidic_s', 'triangle_euclidic_w'],
  2: ['triangle_euclidic_s', 'triangle_euclidic_w', 'triangle_euclidic_s'],
  3: ['triangle_euclidic_w', 'triangle_euclidic_s', 'triangle_euclidic_s'],
  4: ['triangle_euclidic_w', 'triangle_euclidic_w', 'triangle_euclidic_s'],
  5: ['triangle_euclidic_w', 'triangle_euclidic_s', 'triangle_euclidic_w'],
  6: ['triangle_euclidic_s', 'triangle_euclidic_w', 'triangle_euclidic_w'],
};

Map<String, String> TRIANGLE_LABLES = {
  'LEGEND': 'triangle_output_legend',
  'COORDINATES': 'gcwizard_script_help_coordinates',
  'SIDES': 'triangle_output_sides',
  'ANGLES': 'triangle_output_angles',
  'AREA': 'triangle_output_area',
  'TYPE': 'common_type',
  'DESCRIPTION': 'triangle_kind_common',
  'CIRCUMFERENCE': 'triangle_output_circumference',
  'SIDESMIDPOINTS': 'triangle_output_sidesmidpoint',
  'ALTITUDESBASEPOINTS': 'triangle_output_altitudesbasepoint',
  'TOUCHPOINTS': 'triangle_output_touchpoint',
  'EXCIRCLE': 'triangle_output_excircle',
  'X1': 'triangle_output_incenter',
  'X2': 'triangle_output_centroid',
  'X3': 'triangle_output_circumcenter',
  'X4': 'triangle_output_altitude',
  'X5': 'triangle_output_ninepointcenter',
  'X6': 'triangle_output_lemoine',
  'X7': 'triangle_output_gergonne',
  'X8': 'triangle_output_nagel',
  'X9': 'triangle_output_mitten',
  'X10': 'triangle_output_spieker',
  'X11': 'triangle_output_feuerbach',
  'X12': 'triangle_output_harmonic_conjugate_x11',
  'X13': 'triangle_output_fermat_torricelli',
  'X14': 'triangle_output_2ndisogonic',
  'X15': 'triangle_output_1stisodynamic',
  'X16': 'triangle_output_2ndisodynamic',
  'X17': 'triangle_output_napoleon_outer',
  'X18': 'triangle_output_napoleon_inner',
  'X19': 'triangle_output_clawson',
  'X20': 'triangle_output_longchamps',
  'X21': 'triangle_output_schiffler',
  'X22': 'triangle_output_exeter',
  'INCIRCLE': 'triangle_output_incircle',
  'CIRCUMCIRCLE': 'triangle_output_circumscribedcircle',
  'FEUERBACHCIRCLE': 'triangle_output_feuerbachcircle',
  'CIRCLES': 'triangle_output_circles',
};

class Triangle{
  final XYPoint A;
  final XYPoint B;
  final XYPoint C;

  Triangle(this.A, this.B, this.C);

  String get description => triangleDescription(sides.a, sides.b, sides.c);

  double get area {
    final sd = sides;
    final s = (sd.a + sd.b + sd.c) / 2;
    return sqrt(s * (s - sd.a) * (s - sd.b) * (s - sd.c));
  }

  Sides get sides => triangleSidesXY(A, B, C);

  Angles get angles => triangleAnglesXY(A, B, C);

  double get circumference {
    final sd = sides;
    return (sd.a + sd.b + sd.c);
  }

    Sides get altitudes => triangleAltitudesXY(A, B, C);
    Sides get medians => triangleMediansXY(A, B, C);
    Sides get anglebisector => triangleAngleBiSectorsXY(A, B, C);
    List<XYPoint> get sidesMidPoint => triangleSidesMidPointsXY(A, B, C);
    List<XYPoint> get altitudesBasePoint => triangleAltitudesBasePointsXY(A, B, C);
    List<XYCircle> get exCircles => triangleExCirclesXY(A, B, C);
    List<XYPoint> get exCirclesTouchPoints => triangleTouchPointsExcircleXY(A, B, C);
    List<XYPoint> get inCirclesTouchPoints => triangleTouchPointsIncircleXY(A, B, C);
    List<XYPoint> get inFeuerbachCircleTouchPoints => triangleTouchpointsFeuerbachCircleXY(A, B, C);
    XYCircle get inCircle => triangleInCircleXY(A, B, C);
    XYCircle get circumscribedCircle => triangleCircumscribedCircleXY(A, B, C);
    XYCircle get feuerbachCircle => triangleFeuerbachCircleXY(A, B, C);
    XYCircle get X1 => triangleInCircleXY(A, B, C);
    XYPoint get X2 => triangleCentroidXY(A, B, C);
    XYCircle get X3 => triangleCircumscribedCircleXY(A, B, C);
    XYPoint get X4 => triangleOrthocenterXY(A, B, C);
    XYPoint get X5 => triangleNinePointCenterXY(A, B, C);
    XYPoint get X6 => triangleLemoinePointXY(A, B, C);
    XYPoint get X7 => triangleGergonnePointXY(A, B, C);
    XYPoint get X8 => triangleNagelPointXY(A, B, C);
    XYPoint get X9 => triangleMittenPointXY(A, B, C);
    XYPoint get X10 => triangleSpiekerPointXY(A, B, C);
    XYPoint get X11 => triangleFeuerbachPointXY(A, B, C);
    XYPoint get X12 => triangleConjugateX11PointXY(A, B, C);
    XYPoint get X13 => triangleFermatTorricelliPointXY(A, B, C);
    XYPoint get X14 => triangleIsogonicPointXY(A, B, C);
    XYPoint get X15 => triangleIsoDynamic1PointXY(A, B, C);
    XYPoint get X16 => triangleIsoDynamic2PointXY(A, B, C);
    XYPoint get X17 => triangleNapoleonOuterPointXY(A, B, C);
    XYPoint get X18 => triangleNapoleonInnerPointXY(A, B, C);
    XYPoint get X19 => triangleClawsonPointXY(A, B, C);
    XYPoint get X20 => triangleLongchampsPointXY(A, B, C);
    XYPoint get X21 => triangleSchifflerPointXY(A, B, C);
    XYPoint get X22 => triangleExeterPointXY(A, B, C);
  }