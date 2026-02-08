import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/common_linear_algebra.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/common_trilinear_xy.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_classes.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_vector.dart';
part 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle_image.dart';
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

Map<int, String> SIDE_ANGLE_TYPES = {
  0: "triangle_euclidic_sss",
  1: "triangle_euclidic_ssw",
  2: "triangle_euclidic_sws",
  3: "triangle_euclidic_sws",
  4: "triangle_euclidic_wws",
  5: "triangle_euclidic_wsw",
  6: "triangle_euclidic_sww",
};

Map<int, List<String>> triangleSWText = {
  0: ['triangle_euclidic_s', 'triangle_euclidic_s', 'triangle_euclidic_s'],
  1: ['triangle_euclidic_s', 'triangle_euclidic_s', 'triangle_euclidic_w'],
  2: ['triangle_euclidic_s', 'triangle_euclidic_w', 'triangle_euclidic_s'],
  3: ['triangle_euclidic_w', 'triangle_euclidic_s', 'triangle_euclidic_s'],
  4: ['triangle_euclidic_w', 'triangle_euclidic_w', 'triangle_euclidic_s'],
  5: ['triangle_euclidic_w', 'triangle_euclidic_s', 'triangle_euclidic_w'],
  6: ['triangle_euclidic_s', 'triangle_euclidic_w', 'triangle_euclidic_w'],
};
