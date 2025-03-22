import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_formatselector.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:latlong2/latlong.dart';

class FormatConverter extends StatefulWidget {
  const FormatConverter({Key? key}) : super(key: key);

  @override
  _FormatConverterState createState() => _FormatConverterState();
}

class _FormatConverterState extends State<FormatConverter> {
  var _currentCoords = defaultBaseCoordinate;
  Object _currentOutput = '';

  var _currentMapPoint = GCWMapPoint(point: defaultCoordinate);
  var _currentOutputFormat = defaultCoordinateFormat;
  Widget _currentAllOutput = const GCWDefaultOutput();

  @override
  void initState() {
    super.initState();

    if (_currentCoords.format.type == _currentOutputFormat.type) {
      if (_currentOutputFormat.type == CoordinateFormatKey.DMM) {
        _currentCoords = DECCoordinate.fromLatLon(defaultCoordinate);
      } else {
        _currentOutputFormat = CoordinateFormat(CoordinateFormatKey.DMM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_formatconverter_coord'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
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
                _currentOutput = '';
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
      return GCWCoordsOutput(outputs: [_currentOutput], points: [_currentMapPoint]);
    }
  }

  void _calculateOutput(BuildContext context) {
    var outputLatLng = _currentCoords.toLatLng();
    _currentOutput = _buildCoordOutput(outputLatLng, _currentCoords, _currentOutputFormat);
    if (outputLatLng != null) {
      _currentMapPoint = GCWMapPoint(point: outputLatLng);
    } else {
      _currentMapPoint = GCWMapPoint(point: defaultCoordinate);
      _currentAllOutput = GCWCoordsOutput(outputs: [_currentOutput], points: [_currentMapPoint]);
      return;
    }

    if (_currentOutputFormat.type == CoordinateFormatKey.ALL) {
      _currentAllOutput = _calculateAllOutput(context);
    }
  }

  Object _buildCoordOutput(LatLng? latLng, BaseCoordinate coord, CoordinateFormat format) {
    if (latLng != null) {
      var baseCoords = buildCoordinate(format, latLng);
      return _supplementOutput(latLng, baseCoords, format);
    } else {
      return _coordErrorOutput(_currentCoords);
    }
  }

  Object _supplementOutput(LatLng latLng, BaseCoordinate coords, CoordinateFormat format) {
    if (coords.stateCode != StateCode.OK) {
      var output = formatCoordOutput(latLng, format);
      if (output.isNotEmpty) output += '\n';
      return output + _coordErrorOutput(coords);
    }
    return coords;
  }

  String _coordErrorOutput(BaseCoordinate coords) {
    var output =
      i18n(context, 'coords_formatconverter_' + enumName(StateCode.Invalid_Coordinate.toString()).toLowerCase());
    if (coords.stateCode != StateCode.OK && coords.stateCode != StateCode.Invalid_Coordinate) {
      output += '\n' +
          i18n(context, 'coords_formatconverter_' + enumName(coords.stateCode.toString()).toLowerCase());
    }
    return output;
  }

  Widget _calculateAllOutput(BuildContext context) {
    var outputLatLng = _currentCoords.toLatLng();

    List<List<String>> children = outputLatLng == null
        ? []
        : allCoordinateWidgetInfos.map((coordFormat) {
            var format = CoordinateFormat(coordFormat.type);
            var name = i18n(context, coordFormat.name, ifTranslationNotExists: coordFormat.name);
            if (coordFormat is GCWCoordWidgetWithSubtypeInfo) {
              format = CoordinateFormat(coordFormat.type, coordFormat.subtype);
              var subtypeWidgetInfo = coordinateWidgetSubtypeInfoByType(coordFormat, coordFormat.subtype);
              var subtypeName = i18n(context, subtypeWidgetInfo!.name);
              if (subtypeName.isNotEmpty) {
                name += '\n' + subtypeName;
              }
            }
            var output = _buildCoordOutput(outputLatLng, _currentCoords, format);
            if (output is BaseCoordinate) {
              output = formatCoordOutput(outputLatLng, format);
            }

            return [name, output.toString()];
          }).toList();

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: children));
  }
}

class _GCWCoordsFormatSelectorAll extends GCWCoordsFormatSelector {
  const _GCWCoordsFormatSelectorAll(
      {Key? key, required void Function(CoordinateFormat) onChanged, required CoordinateFormat format})
      : super(key: key, input: false, onChanged: onChanged, format: format);

  @override
  List<GCWDropDownMenuItem<CoordinateFormatKey>> getDropDownItems(BuildContext context) {
    var items = super.getDropDownItems(context);
    items.insert(
        0,
        GCWDropDownMenuItem(
            value: CoordinateFormatKey.ALL, child: i18n(context, 'coords_formatconverter_all_formats')));
    return items;
  }
}
