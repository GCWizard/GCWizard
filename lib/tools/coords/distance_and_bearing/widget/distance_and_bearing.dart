import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:intl/intl.dart';

class DistanceBearing extends StatefulWidget {
  const DistanceBearing({Key? key}) : super(key: key);

  @override
  _DistanceBearingState createState() => _DistanceBearingState();
}

class _DistanceBearingState extends State<DistanceBearing> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;

  Length _currentOutputUnit = defaultLengthUnit;

  DistanceBearingData _currentValue = DistanceBearingData();
  List<GCWOutputText> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  void initState() {
    super.initState();

    _currentOutputUnit = defaultLengthUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_distancebearing_coorda'),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_distancebearing_coordb'),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_distancebearing_outputunit'),
        ),
        GCWUnitDropDown(
            unitList: allLengths(),
            value: _currentOutputUnit,
            onlyShowSymbols: false,
            onChanged: (Length value) {
              setState(() {
                _currentOutputUnit = value;
              });
            }),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput(context);
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
      ],
    );
  }

  void _calculateOutput(BuildContext context) {
    final doubleFormatCopy = NumberFormat('0.0#######');

    _currentValue = distanceBearing(_currentCoords1.toLatLng()!, _currentCoords2.toLatLng()!, defaultEllipsoid);

    _currentOutput = [];
    _currentOutput.add(GCWOutputText(
      text:
          '${i18n(context, 'coords_distancebearing_distance')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(_currentValue.distance))} ${_currentOutputUnit.symbol}',
      copyText: doubleFormatCopy.format(_currentOutputUnit.fromMeter(_currentValue.distance)),
    ));
    _currentOutput.add(GCWOutputText(
      text:
          '${i18n(context, 'coords_distancebearing_bearingatob')}: ${doubleFormat.format(_currentValue.bearingAToB)}°',
      copyText: doubleFormatCopy.format(_currentValue.bearingAToB),
    ));
    _currentOutput.add(GCWOutputText(
      text:
          '${i18n(context, 'coords_distancebearing_bearingbtoa')}: ${doubleFormat.format(_currentValue.bearingBToA)}°',
      copyText: doubleFormatCopy.format(_currentValue.bearingBToA),
    ));

    var mapPoint1 = GCWMapPoint(
        point: _currentCoords1.toLatLng()!,
        markerText: i18n(context, 'coords_distancebearing_coorda'),
        coordinateFormat: _currentCoords1.format);
    var mapPoint2 = GCWMapPoint(
        point: _currentCoords2.toLatLng()!,
        markerText: i18n(context, 'coords_distancebearing_coordb'),
        coordinateFormat: _currentCoords2.format);

    _currentMapPoints = [mapPoint1, mapPoint2];

    _currentMapPolylines = [
      GCWMapPolyline(points: [mapPoint1, mapPoint2])
    ];
  }
}
