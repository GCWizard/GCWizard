import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_definition.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_COORDINATEFORMATS = 'multidecoder_tool_coordinateformats_title';
const MDT_COORDINATEFORMATS_OPTION_FORMAT = 'multidecoder_tool_coordinateformats_option_format';

class MultiDecoderToolCoordinateFormats extends AbstractMultiDecoderTool {
  MultiDecoderToolCoordinateFormats(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_COORDINATEFORMATS,
            onDecode: (String input, String key) {
              input = input.replaceAll(RegExp(r'\s+'), ' ').toUpperCase();
              BaseCoordinate? coords;
              try {
                var coordinateFormatKey = _getCoordinateFormatDefinition(options, MDT_COORDINATEFORMATS_OPTION_FORMAT);
                coords = coordinateFormatKey.parseCoordinateWholeString(input);

                var latlng = coords?.toLatLng();
                if (latlng == null) return null;

                return formatCoordOutput(latlng, defaultCoordinateFormat, defaultEllipsoid);
              } catch (e) {}
              return null;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolCoordinateFormatsState();
}

class _MultiDecoderToolCoordinateFormatsState extends State<MultiDecoderToolCoordinateFormats> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_COORDINATEFORMATS_OPTION_FORMAT: GCWDropDown<CoordinateFormatKey>(
        value: _getCoordinateFormatDefinition(widget.options, MDT_COORDINATEFORMATS_OPTION_FORMAT).type,
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_COORDINATEFORMATS_OPTION_FORMAT] =
                coordinateFormatDefinitionByKey(newValue).persistenceKey;
          });
        },
        items: allCoordinateWidgetInfos
            .where((widgetInfo) => widgetInfo.type != CoordinateFormatKey.SLIPPY_MAP)
            .map((format) {
          return GCWDropDownMenuItem<CoordinateFormatKey>(
            value: format.type,
            child: i18n(context, format.name, ifTranslationNotExists: format.name),
          );
        }).toList(),
      ),
    });
  }
}

CoordinateFormatDefinition _getCoordinateFormatDefinition(Map<String, Object?> options, String option) {
  var key = checkStringFormatOrDefaultOption(
      MDT_INTERNALNAMES_COORDINATEFORMATS, options, MDT_COORDINATEFORMATS_OPTION_FORMAT);
  var formatKeyDefinition = coordinateFormatDefinitionByPersistenceKey(key);
  if (formatKeyDefinition != null) return formatKeyDefinition;

  key = toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_COORDINATEFORMATS, MDT_COORDINATEFORMATS_OPTION_FORMAT)) ?? '';
  return coordinateFormatDefinitionByPersistenceKey(key) ??
      coordinateFormatDefinitionByKey(defaultCoordinateFormat.type);
}
