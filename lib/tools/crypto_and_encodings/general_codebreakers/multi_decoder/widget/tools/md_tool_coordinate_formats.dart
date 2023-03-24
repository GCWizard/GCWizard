import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_metadata.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:latlong2/latlong.dart';

const MDT_INTERNALNAMES_COORDINATEFORMATS = 'multidecoder_tool_coordinateformats_title';
const MDT_COORDINATEFORMATS_OPTION_FORMAT = 'multidecoder_tool_coordinateformats_option_format';

class MultiDecoderToolCoordinateFormats extends AbstractMultiDecoderTool {
  MultiDecoderToolCoordinateFormats({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_COORDINATEFORMATS,
            onDecode: (String input, String key) {
              input = input.replaceAll(RegExp(r'\s+'), ' ').toUpperCase();
              LatLng? coords;
              try {
                switch (getCoordinateFormatKey(options, MDT_COORDINATEFORMATS_OPTION_FORMAT)) {
                  case CoordinateFormatKey.DEC:
                    coords = DEC.parse(input, wholeString: true)?.toLatLng();
                    break;
                  case CoordinateFormatKey.DMM:
                    coords = DMM.parse(input, wholeString: true)?.toLatLng();
                    break;
                  case CoordinateFormatKey.DMS:
                    coords = DMS.parse(input, wholeString: true)?.toLatLng();
                    break;
                  case CoordinateFormatKey.UTM:
                    coords = UTMREF.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.MGRS:
                    coords = MGRS.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.XYZ:
                    coords = XYZ.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.SWISS_GRID:
                    coords = SwissGrid.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.SWISS_GRID_PLUS:
                    coords = SwissGridPlus.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.GAUSS_KRUEGER:
                    coords = GaussKrueger.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.LAMBERT:
                    coords = Lambert.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.DUTCH_GRID:
                    coords = DutchGrid.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.MAIDENHEAD:
                    coords = Maidenhead.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.MERCATOR:
                    coords = Mercator.parse(input)?.toLatLng(ells: defaultEllipsoid);
                    break;
                  case CoordinateFormatKey.NATURAL_AREA_CODE:
                    coords = NaturalAreaCode.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.GEOHASH:
                    coords = Geohash.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.GEOHEX:
                    coords = GeoHex.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.GEO3X3:
                    coords = Geo3x3.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.OPEN_LOCATION_CODE:
                    coords = OpenLocationCode.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.QUADTREE:
                    coords = Quadtree.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.REVERSE_WIG_WALDMEISTER:
                    coords = ReverseWherigoWaldmeister.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.REVERSE_WIG_DAY1976:
                    coords = ReverseWherigoDay1976.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.SLIPPY_MAP:
                    coords = SlippyMap.parse(input)?.toLatLng();
                    break;
                  case CoordinateFormatKey.MAKANEY:
                    coords = Makaney.parse(input)?.toLatLng();
                    break;
                  default:
                    coords = null;
                }
              } catch (e) {}

              if (coords == null) return null;

              return formatCoordOutput(coords, defaultCoordinateFormat, defaultEllipsoid);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_COORDINATEFORMATS_OPTION_FORMAT: GCWStatefulDropDown<CoordinateFormatKey>(
                value: getCoordinateFormatKey(options, MDT_COORDINATEFORMATS_OPTION_FORMAT),
                onChanged: (newValue) {
                  options[MDT_COORDINATEFORMATS_OPTION_FORMAT] = newValue;
                },
                items: allCoordinateFormatMetadata.where((format) => format.type != CoordinateFormatKey.SLIPPY_MAP).map((format) {
                  return GCWDropDownMenuItem<CoordinateFormatKey>(
                    value: format.type,
                    child: i18n(context, format.name, ifTranslationNotExists: format.name),
                  );
                }).toList(),
              ),
            }));
}

CoordinateFormatKey getCoordinateFormatKey(Map<String, Object?> options, String option) {
  var key = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_COORDINATEFORMATS, options, MDT_COORDINATEFORMATS_OPTION_FORMAT);
  var formatKey = coordinateFormatMetadataByPersistenceKey(key)?.type;
  if (formatKey != null) return formatKey;

  key = toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_COORDINATEFORMATS, MDT_COORDINATEFORMATS_OPTION_FORMAT)) ?? '';
  return coordinateFormatMetadataByPersistenceKey(key)?.type ?? defaultCoordinateFormat.type;
}