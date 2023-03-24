import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords_formatselector.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_metadata.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class FormatConverter extends StatefulWidget {
  const FormatConverter({Key? key}) : super(key: key);

  @override
  FormatConverterState createState() => FormatConverterState();
}

class FormatConverterState extends State<FormatConverter> {
  var _currentCoords = defaultBaseCoordinate;
  List<BaseCoordinate> _currentOutputs = [];

  var _currentOutputFormat = defaultCoordinateFormat;
  Widget _currentAllOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_formatconverter_coord'),
          coordsFormat: _currentCoords.format,
          onChanged: (BaseCoordinate ret) {
            setState(() {
              if (ret.toLatLng() != null) {
                _currentCoords = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_output_format'),
        ),
        _GCWCoordsFormatSelectorAll(
          format: _currentOutputFormat,
          onChanged: (CoordinateFormat value) {
            setState(() {
              if (value.type == CoordinateFormatKey.ALL) {
                _currentOutputs = [];
                _currentAllOutput = const GCWDefaultOutput();
              }

              _currentOutputFormat = value;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput(context);
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentOutputFormat.type == CoordinateFormatKey.ALL) {
      return _currentAllOutput;
    } else {
      return GCWCoordsOutput(
        outputs: _currentOutputs,
        points: _currentOutputs.map((element) {
          return GCWMapPoint(point: element.toLatLng()!, coordinateFormat: _currentOutputFormat);
        }).toList()
      );
    }
  }

  void _calculateOutput(BuildContext context) {
    if (_currentOutputFormat.type == CoordinateFormatKey.ALL) {
      _currentAllOutput = _calculateAllOutput(context);
    } else {
      _currentOutputs = _currentCoords.toLatLng() != null ? [_currentCoords] : [];
    }
  }

  Widget _calculateAllOutput(BuildContext context) {
    var ellipsoid = defaultEllipsoid;

    List<List<String>> children =_currentCoords.toLatLng() == null
        ? []
        : allCoordinateFormatMetadata.map((CoordinateFormatMetadata coordFormat) {
            var format = CoordinateFormat(coordFormat.type);
            var name = i18n(context, coordFormat.name, ifTranslationNotExists: coordFormat.name);
            if (format.subtype != null) {
              var subtypeMetadata = coordinateFormatMetadataByKey(format.subtype!);
              var subtypeName = i18n(context, subtypeMetadata.name);
              if (subtypeName.isNotEmpty) {
                name += '\n' + subtypeName;
              }
            }

            return [name, formatCoordOutput(_currentCoords.toLatLng()!, format, ellipsoid)];
          }).toList();

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput( data: children));
  }
}

class _GCWCoordsFormatSelectorAll extends GCWCoordsFormatSelector {
  const _GCWCoordsFormatSelectorAll({Key? key, required void Function(CoordinateFormat) onChanged, required CoordinateFormat format})
      : super(key: key, onChanged: onChanged, format: format);

  @override
  List<GCWDropDownMenuItem<CoordinateFormatKey>> getDropDownItems(BuildContext context) {
    var items = super.getDropDownItems(context);
    items.insert(
        0, GCWDropDownMenuItem(value: CoordinateFormatKey.ALL, child: i18n(context, 'coords_formatconverter_all_formats')));
    return items;
  }
}
