import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_arithmetic_mean/logic/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class CentroidArithmeticMean extends StatefulWidget {
  const CentroidArithmeticMean({Key? key}) : super(key: key);

  @override
  _CentroidArithmeticMeanState createState() => _CentroidArithmeticMeanState();
}

class _CentroidArithmeticMeanState extends State<CentroidArithmeticMean> {
  var _currentCountCoords = 1;
  final _currentCoords = [defaultBaseCoordinate];

  var _currentValues = [defaultCoordinate];
  var _currentMapPoints = <GCWMapPoint>[];

  var _currentOutputFormat = defaultCoordinateFormat;
  var _currentOutput = <BaseCoordinate>[];

  @override
  Widget build(BuildContext context) {
    var coordWidgets = List.generate(
        _currentCountCoords,
        (index) => GCWCoords(
              title: i18n(context, 'coords_common_coordinate') + ' ' + (index + 1).toString(),
              coordsFormat: _currentCoords[index].format,
              onChanged: (ret) {
                setState(() {
                  if (ret != null) {
                    _currentCoords[index] = ret;
                  }
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
                _currentCountCoords--;
              }

              while (value > _currentCountCoords) {
                _currentCoords.add(defaultBaseCoordinate);
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

  void _calculateOutput() {
    if (_currentCoords.isEmpty) {
      return;
    }

    var latLons = _currentCoords.map((e) => e.toLatLng()!).toList();

    var centerOfGravity = centroidCenterOfGravity(latLons)!;
    _currentValues = [centroidArithmeticMean(latLons, centerOfGravity)!];

    _currentMapPoints = _currentCoords
        .asMap()
        .map((index, coord) {
          return MapEntry(
              index,
              GCWMapPoint(
                  point: _currentCoords[index].toLatLng()!,
                  markerText: i18n(context, 'coords_common_coordinate') + ' ' + (index + 1).toString(),
                  coordinateFormat: _currentCoords[index].format));
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
      return buildCoordinate(_currentOutputFormat, coord);
    }).toList();
  }
}
