import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:prefs/prefs.dart';

class SegmentLine extends StatefulWidget {
  @override
  SegmentLineState createState() => SegmentLineState();
}

class SegmentLineState extends State<SegmentLine> {
  var _currentCoords1 = defaultCoordinate;
  var _currentCoords2 = defaultCoordinate;

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoordsFormat2 = defaultCoordFormat();

  var _currentSegmentCount = 2;

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  Length _currentOutputUnit = UNITCATEGORY_LENGTH.defaultUnit;
  var _currentOutputFormat = defaultCoordFormat();

  List<String> _currentOutputs = [];
  Widget _currentDistanceOutput = Container();

  @override
  void initState() {
    super.initState();

    _currentOutputUnit = getUnitBySymbol(allLengths(), Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_segmentline_start'),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_segmentline_end'),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'coords_segmentline_numbersegments')),
        GCWIntegerSpinner(
          value: _currentSegmentCount,
          min: 2,
          overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
          onChanged: (value) {
            setState(() {
              _currentSegmentCount = value;
            });
          },
        ),
        GCWCoordsOutputFormat(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value;
            });
          },
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
              _calculateOutput();
            });
          },
        ),
        _currentDistanceOutput,
        GCWCoordsOutput(
          outputs: _currentOutputs,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
      ],
    );
  }

  _calculateOutput() {
    var segments = segmentLine(_currentCoords1, _currentCoords2, _currentSegmentCount, defaultEllipsoid());

    var startMapPoint = GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, 'coords_segmentline_start'),
        coordinateFormat: _currentCoordsFormat1);
    var endMapPoint = GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, 'coords_segmentline_end'),
        coordinateFormat: _currentCoordsFormat2);

    _currentMapPoints = [startMapPoint];
    segments['points'].asMap().forEach((index, point) {
      _currentMapPoints.add(GCWMapPoint(
        point: point,
        markerText: i18n(context, 'coords_segmentline_segmentdivider') + ' ' + (index + 1).toString(),
        coordinateFormat: _currentOutputFormat,
        color: COLOR_MAP_CALCULATEDPOINT,
      ));
    });
    _currentMapPoints.add(endMapPoint);

    _currentMapPolylines = [GCWMapPolyline(points: List<GCWMapPoint>.from(_currentMapPoints))];

    _currentOutputs = List<String>.from(segments['points'].map((point) {
      return formatCoordOutput(point, _currentOutputFormat, defaultEllipsoid());
    }).toList());

    var distanceOutput = doubleFormat.format(_currentOutputUnit.fromMeter(segments['segmentDistance']));
    _currentDistanceOutput = GCWDefaultOutput(
      child:
          i18n(context, 'coords_segmentline_segmentdistance') + ': ' + distanceOutput + ' ' + _currentOutputUnit.symbol,
      copyText: distanceOutput,
    );
  }
}
