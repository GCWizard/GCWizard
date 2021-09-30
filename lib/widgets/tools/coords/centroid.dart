import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/centroid.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/antipodes.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';

class Centroid extends StatefulWidget {
  @override
  CentroidState createState() => CentroidState();
}

class CentroidState extends State<Centroid> {
  var _currentCountCoords = 1;
  var _currentCoords = [defaultCoordinate];

  var _currentValues = [defaultCoordinate];
  var _currentMapPoints = <GCWMapPoint>[];
  var _currentCoordsFormats = [defaultCoordFormat()];

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = <String>[];

  @override
  Widget build(BuildContext context) {
    var coordWidgets = List.generate(
        _currentCountCoords,
        (index) => GCWCoords(
              title: i18n(context, 'coords_common_coordinate') + ' ' + (index + 1).toString(),
              coordsFormat: _currentCoordsFormats[index],
              onChanged: (ret) {
                setState(() {
                  _currentCoordsFormats[index] = ret['coordsFormat'];
                  _currentCoords[index] = ret['value'];
                });
              },
            ));

    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'coords_centroid_count'),
        ),
        GCWIntegerSpinner(
          value: _currentCountCoords,
          min: 1,
          overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
          onChanged: (value) {
            setState(() {
              while (value < _currentCountCoords) {
                _currentCoords.removeLast();
                _currentCoordsFormats.removeLast();
                _currentCountCoords--;
              }

              while (value > _currentCountCoords) {
                _currentCoords.add(defaultCoordinate);
                _currentCoordsFormats.add(defaultCoordFormat());
                _currentCountCoords++;
              }
            });
          },
        ),
        Column(
          children: coordWidgets,
        ),
        GCWCoordsOutputFormat(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value;
            });
          },
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
        ),
      ],
    );
  }

  _calculateOutput() {
    _currentValues = [centroid(_currentCoords)];

    _currentMapPoints = _currentCoords
        .asMap()
        .map((index, coord) {
          return MapEntry(
              index,
              GCWMapPoint(
                  point: _currentCoords[index],
                  markerText: i18n(context, 'coords_common_coordinate') + ' ' + (index + 1).toString(),
                  coordinateFormat: _currentCoordsFormats[index]));
        })
        .values
        .toList();

    _currentMapPoints.add(
      GCWMapPoint(
          point: _currentValues[0],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_centroid_centroid'),
          coordinateFormat: _currentOutputFormat),
    );

    _currentOutput = _currentValues.map((coord) {
      return formatCoordOutput(coord, _currentOutputFormat, defaultEllipsoid());
    }).toList();
  }
}
