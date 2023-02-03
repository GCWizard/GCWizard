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
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class FormatConverter extends StatefulWidget {
  @override
  FormatConverterState createState() => FormatConverterState();
}

class FormatConverterState extends State<FormatConverter> {
  var _currentCoords = defaultCoordinate;

  var _currentCoordsFormat = defaultCoordFormat();

  Map<String, String> _currentOutputFormat = {'format': keyCoordsDEC};
  List<String> _currentOutput = [];
  Widget _currentAllOutput = GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_formatconverter_coord'),
          coordsFormat: _currentCoordsFormat,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat = ret['coordsFormat'];
              _currentCoords = ret['value'];
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_output_format'),
        ),
        _GCWCoordsFormatSelectorAll(
          format: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              if ((_currentCoordsFormat['format'] != keyCoordsALL && value['format'] == keyCoordsALL) ||
                  (_currentCoordsFormat['format'] == keyCoordsALL && value['format'] != keyCoordsALL)) {
                _currentOutput = [];
                _currentAllOutput = GCWDefaultOutput();
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
    if (_currentOutputFormat['format'] == keyCoordsALL)
      return _currentAllOutput;
    else
      return GCWCoordsOutput(
        outputs: _currentOutput,
        points: [
          GCWMapPoint(point: _currentCoords, coordinateFormat: _currentOutputFormat),
        ],
      );
  }

  _calculateOutput(BuildContext context) {
    if (_currentOutputFormat['format'] == keyCoordsALL)
      _currentAllOutput = _calculateAllOutput(context);
    else
      _currentOutput = [formatCoordOutput(_currentCoords, _currentOutputFormat, defaultEllipsoid())];
  }

  Widget _calculateAllOutput(BuildContext context) {
    var children = <List<String>>[];
    var ellipsoid = defaultEllipsoid();

    allCoordFormats.forEach((coordFormat) {
      try {
        // exception, when we have a type with a undefinied subtype
        var outputFormat = Map<String, String>();
        String name = coordFormat.name;
        outputFormat.addAll({'format': coordFormat.key});

        switch (coordFormat.key) {
          case keyCoordsLambert:
            outputFormat.addAll({'subtype': getLambertKey()});
            name = i18n(context, coordFormat.name);
            name +=
                '\n' + i18n(context, coordFormat.subtypes.firstWhere((element) => element.key == getLambertKey()).name);
            break;
          case keyCoordsGaussKrueger:
            outputFormat.addAll({'subtype': getGaussKruegerTypKey()});
            name = i18n(context, coordFormat.name);
            name += '\n' +
                i18n(
                    context, coordFormat.subtypes.firstWhere((element) => element.key == getGaussKruegerTypKey()).name);
            break;
          case keyCoordsSlippyMap:
            outputFormat.addAll({'subtype': DefaultSlippyZoom.toString()});
            break;
        }

        children.add([name, formatCoordOutput(_currentCoords, outputFormat, ellipsoid)]);
      } catch (e) {}
    });

    return GCWDefaultOutput(child: GCWColumnedMultilineOutput( data: children));
  }
}

class _GCWCoordsFormatSelectorAll extends GCWCoordsFormatSelector {
  const _GCWCoordsFormatSelectorAll({Key key, onChanged, format})
      : super(key: key, onChanged: onChanged, format: format);

  @override
  List<GCWDropDownMenuItem> getDropDownItems(BuildContext context) {
    var items = super.getDropDownItems(context);
    items.insert(
        0, GCWDropDownMenuItem(value: keyCoordsALL, child: i18n(context, 'coords_formatconverter_all_formats')));
    return items;
  }
}
