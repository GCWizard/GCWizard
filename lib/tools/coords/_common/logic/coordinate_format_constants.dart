import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dutchgrid/logic/dutchgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/geo3x3.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohash/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohex/logic/geohex.dart';
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/formats/maidenhead/logic/maidenhead.dart';
import 'package:gc_wizard/tools/coords/_common/formats/makaney/logic/makaney.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mercator/logic/mercator.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/openlocationcode/logic/open_location_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/quadtree/logic/quadtree.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/formats/slippymap/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgridplus/logic/swissgridplus.dart';
import 'package:gc_wizard/tools/coords/_common/formats/utm/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/xyz/logic/xyz.dart';

enum CoordinateFormatKey {
  ALL,
  DEC,
  DMM,
  DMS,
  UTM,
  MGRS,
  XYZ,
  SWISS_GRID,
  SWISS_GRID_PLUS,
  DUTCH_GRID,
  GAUSS_KRUEGER,
  LAMBERT,
  MAIDENHEAD,
  MERCATOR,
  NATURAL_AREA_CODE,
  SLIPPY_MAP,
  GEOHASH,
  GEO3X3,
  GEOHEX,
  OPEN_LOCATION_CODE,
  MAKANEY,
  QUADTREE,
  REVERSE_WIG_WALDMEISTER,
  REVERSE_WIG_DAY1976,
  //GaussKrueger Subtypes
  GAUSS_KRUEGER_GK1,
  GAUSS_KRUEGER_GK2,
  GAUSS_KRUEGER_GK3,
  GAUSS_KRUEGER_GK4,
  GAUSS_KRUEGER_GK5,
  //Lambert Subtypes
  LAMBERT93,
  LAMBERT2008,
  ETRS89LCC,
  LAMBERT72,
  LAMBERT93_CC42,
  LAMBERT93_CC43,
  LAMBERT93_CC44,
  LAMBERT93_CC45,
  LAMBERT93_CC46,
  LAMBERT93_CC47,
  LAMBERT93_CC48,
  LAMBERT93_CC49,
  LAMBERT93_CC50,
  //SlippyMap Subtypes
  SLIPPYMAP_0,
  SLIPPYMAP_1,
  SLIPPYMAP_2,
  SLIPPYMAP_3,
  SLIPPYMAP_4,
  SLIPPYMAP_5,
  SLIPPYMAP_6,
  SLIPPYMAP_7,
  SLIPPYMAP_8,
  SLIPPYMAP_9,
  SLIPPYMAP_10,
  SLIPPYMAP_11,
  SLIPPYMAP_12,
  SLIPPYMAP_13,
  SLIPPYMAP_14,
  SLIPPYMAP_15,
  SLIPPYMAP_16,
  SLIPPYMAP_17,
  SLIPPYMAP_18,
  SLIPPYMAP_19,
  SLIPPYMAP_20,
  SLIPPYMAP_21,
  SLIPPYMAP_22,
  SLIPPYMAP_23,
  SLIPPYMAP_24,
  SLIPPYMAP_25,
  SLIPPYMAP_26,
  SLIPPYMAP_27,
  SLIPPYMAP_28,
  SLIPPYMAP_29,
  SLIPPYMAP_30
}

/// sorted by priority (parse coordinates)
final allCoordinateFormatDefinitions = [
  DMSFormatDefinition,
  DMMFormatDefinition,
  DECFormatDefinition,
  UTMREFFormatDefinition,
  MGRSFormatDefinition,
  ReverseWherigoWaldmeisterFormatDefinition,
  ReverseWherigoDay1976FormatDefinition,
  XYZFormatDefinition,
  SwissGridFormatDefinition,
  SwissGridPlusFormatDefinition,
  GaussKruegerFormatDefinition,
  LambertFormatDefinition,
  DutchGridFormatDefinition,
  MaidenheadFormatDefinition,
  MercatorFormatDefinition,
  NaturalAreaCodeFormatDefinition,
  GeohashFormatDefinition,
  GeoHexFormatDefinition,
  Geo3x3FormatDefinition,
  OpenLocationCodeFormatDefinition,
  MakaneyFormatDefinition,
  QuadtreeFormatDefinition,
  SlippyMapFormatDefinition,
];



