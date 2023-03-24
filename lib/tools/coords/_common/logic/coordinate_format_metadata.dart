import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:collection/collection.dart';

class CoordinateFormatMetadata {
  final CoordinateFormatKey type;
  String persistenceKey;
  String name;
  List<CoordinateFormatMetadata>? subtypes;
  String example;

  CoordinateFormatMetadata(this.type, this.persistenceKey, this.name, this.example, {this.subtypes});
}

List<CoordinateFormatMetadata> allCoordinateFormatMetadata = [
  CoordinateFormatMetadata(CoordinateFormatKey.DEC, 'coords_dec', 'DEC: DD.DDD°', '45.29100, -122.41333'),
  CoordinateFormatMetadata(CoordinateFormatKey.DMM, 'coords_dmm', 'DMM: DD° MM.MMM\'', 'N 45° 17.460\' W 122° 24.800\''),
  CoordinateFormatMetadata(CoordinateFormatKey.DMS, 'coords_dms', 'DMS: DD° MM\' SS.SSS"', 'N 45° 17\' 27.60" W 122° 24\' 48.00"'),
  CoordinateFormatMetadata(CoordinateFormatKey.UTM, 'coords_utm', 'UTM', '10 N 546003.6 5015445.0'),
  CoordinateFormatMetadata(CoordinateFormatKey.MGRS, 'coords_mgrs', 'MGRS', '10T ER 46003.6 15445.0'),
  CoordinateFormatMetadata(CoordinateFormatKey.XYZ, 'coords_xyz', 'XYZ (ECEF)', 'X: -2409244, Y: -3794410, Z: 4510158'),
  CoordinateFormatMetadata(CoordinateFormatKey.SWISS_GRID, 'coords_swissgrid', 'SwissGrid (CH1903/LV03)', 'Y: 720660.2, X: 167765.3'),
  CoordinateFormatMetadata(CoordinateFormatKey.SWISS_GRID_PLUS, 'coords_swissgridplus', 'SwissGrid (CH1903+/LV95)', 'Y: 2720660.2, X: 1167765.3'),
  CoordinateFormatMetadata(CoordinateFormatKey.GAUSS_KRUEGER, 'coords_gausskrueger', 'coords_formatconverter_gausskrueger', 'R: 8837763.4, H: 5978799.1',
      subtypes: [
        CoordinateFormatMetadata(
            CoordinateFormatKey.GAUSS_KRUEGER_GK1, 'coords_gausskrueger_gk1', 'coords_formatconverter_gausskrueger_gk1', 'R: 8837763.4, H: 5978799.1'),
        CoordinateFormatMetadata(
            CoordinateFormatKey.GAUSS_KRUEGER_GK2, 'coords_gausskrueger_gk2', 'coords_formatconverter_gausskrueger_gk2', 'R: 8837739.4, H: 5978774.5'),
        CoordinateFormatMetadata(
            CoordinateFormatKey.GAUSS_KRUEGER_GK3, 'coords_gausskrueger_gk3', 'coords_formatconverter_gausskrueger_gk3', 'R: 8837734.7, H: 5978798.2'),
        CoordinateFormatMetadata(
            CoordinateFormatKey.GAUSS_KRUEGER_GK4, 'coords_gausskrueger_gk4', 'coords_formatconverter_gausskrueger_gk4', 'R: 8837790.8, H: 5978787.4'),
        CoordinateFormatMetadata(
            CoordinateFormatKey.GAUSS_KRUEGER_GK5, 'coords_gausskrueger_gk5', 'coords_formatconverter_gausskrueger_gk5', 'R: 8837696.4, H: 5978779.5'),
      ]),
  CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT, 'coords_lambert', 'coords_formatconverter_lambert', 'X: 8837763.4, Y: 5978799.1', subtypes: [
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93, 'coords_lambert_93', 'coords_formatconverter_lambert_93', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT2008, 'coords_lambert_2008', 'coords_formatconverter_lambert_2008', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.ETRS89LCC, 'coords_lambert_etrs89lcc', 'coords_formatconverter_lambert_etrs89lcc', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT72, 'coords_lambert_72', 'coords_formatconverter_lambert_72', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC42, 'coords_lambert_93_cc42', 'coords_formatconverter_lambert_l93cc42', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC43, 'coords_lambert_93_cc43', 'coords_formatconverter_lambert_l93cc43', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC44, 'coords_lambert_93_cc44', 'coords_formatconverter_lambert_l93cc44', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC45, 'coords_lambert_93_cc45', 'coords_formatconverter_lambert_l93cc45', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC46, 'coords_lambert_93_cc46', 'coords_formatconverter_lambert_l93cc46', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC47, 'coords_lambert_93_cc47', 'coords_formatconverter_lambert_l93cc47', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC48, 'coords_lambert_93_cc48', 'coords_formatconverter_lambert_l93cc48', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC49, 'coords_lambert_93_cc49', 'coords_formatconverter_lambert_l93cc49', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormatMetadata(CoordinateFormatKey.LAMBERT93_CC50, 'coords_lambert_93_cc50', 'coords_formatconverter_lambert_l93cc50', 'X: 8837763.4, Y: 5978799.1'),
  ]),
  CoordinateFormatMetadata(CoordinateFormatKey.DUTCH_GRID, 'coords_dutchgrid', 'RD (Rijksdriehoeks, DutchGrid)', 'X: 221216.7, Y: 550826.2'),
  CoordinateFormatMetadata(CoordinateFormatKey.MAIDENHEAD, 'coords_maidenhead', 'Maidenhead Locator (QTH)', 'CN85TG09JU'),
  CoordinateFormatMetadata(CoordinateFormatKey.MERCATOR, 'coords_mercator', 'Mercator', 'Y: 5667450.4, X: -13626989.9'),
  CoordinateFormatMetadata(CoordinateFormatKey.NATURAL_AREA_CODE, 'coords_naturalareacode', 'Natural Area Code (NAC)', 'X: 4RZ000, Y: QJFMGZ'),
  CoordinateFormatMetadata(CoordinateFormatKey.OPEN_LOCATION_CODE, 'coords_openlocationcode', 'OpenLocationCode (OLC, PlusCode)', '84QV7HRP+CM3'),
  CoordinateFormatMetadata(CoordinateFormatKey.SLIPPY_MAP, 'coords_slippymap', 'Slippy Map Tiles', 'Z: 15, X: 5241, Y: 11749', subtypes: [
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_0, '', '0', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_1, '', '1', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_2, '', '2', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_3, '', '3', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_4, '', '4', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_5, '', '5', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_6, '', '6', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_7, '', '7', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_8, '', '8', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_9, '', '9', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_10, '', '10', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_11, '', '11', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_12, '', '12', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_13, '', '13', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_14, '', '14', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_15, '', '15', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_16, '', '16', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_17, '', '17', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_18, '', '18', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_19, '', '19', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_20, '', '20', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_21, '', '21', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_22, '', '22', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_23, '', '23', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_24, '', '24', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_25, '', '25', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_26, '', '26', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_27, '', '27', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_28, '', '28', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_29, '', '29', ''),
    CoordinateFormatMetadata(CoordinateFormatKey.SLIPPYMAP_30, '', '30', ''),
  ]),
  CoordinateFormatMetadata(CoordinateFormatKey.REVERSE_WIG_WALDMEISTER, 'coords_reversewhereigo_waldmeister' /* typo known. DO NOT change!*/, 'Reverse Wherigo (Waldmeister)', '042325, 436113, 935102'),
  CoordinateFormatMetadata(CoordinateFormatKey.REVERSE_WIG_DAY1976, 'coords_reversewhereigo_day1976', 'Reverse Wherigo (Day1976)', '3f8f1, z4ee4'),
  CoordinateFormatMetadata(CoordinateFormatKey.GEOHASH, 'coords_geohash', 'Geohash', 'c20cwkvr4'),
  CoordinateFormatMetadata(CoordinateFormatKey.QUADTREE, 'coords_quadtree', 'Quadtree', '021230223311203323'),
  CoordinateFormatMetadata(CoordinateFormatKey.MAKANEY, 'coords_makaney', 'Makaney (MKC)', 'M97F-BBOOI'),
  CoordinateFormatMetadata(CoordinateFormatKey.GEOHEX, 'coords_geohex', 'GeoHex', 'RU568425483853568'),
  CoordinateFormatMetadata(CoordinateFormatKey.GEO3X3, 'coords_geo3x3', 'Geo3x3', 'W7392967941169'),
];

CoordinateFormatMetadata? coordinateFormatMetadataByPersistenceKey(String key) {
  return allCoordinateFormatMetadata.firstWhereOrNull((format) => format.persistenceKey == key);
}

CoordinateFormatMetadata? coordinateFormatMetadataSubtypeByPersistenceKey(String key) {
  return _getAllSubtypeCoordinateFormats().firstWhereOrNull((format) => format.persistenceKey == key);
}

List<CoordinateFormatMetadata> _getAllSubtypeCoordinateFormats() {
  var subtypeFormats = allCoordinateFormatMetadata.where((format) => format.subtypes != null && format.subtypes!.isNotEmpty).toList();

  return subtypeFormats
      .fold(<CoordinateFormatMetadata>[], (List<CoordinateFormatMetadata> value, CoordinateFormatMetadata element) {
    value.addAll(element.subtypes!);
    return value;
  });
}

CoordinateFormatMetadata coordinateFormatMetadataByKey(CoordinateFormatKey key) {
  var allFormats = allCoordinateFormatMetadata;
  allFormats.addAll(_getAllSubtypeCoordinateFormats());

  return allFormats.firstWhere((format) => format.type == key);
}

String persistenceKeyByCoordinateFormatKey(CoordinateFormatKey key) {
  return coordinateFormatMetadataByKey(key).persistenceKey;
}