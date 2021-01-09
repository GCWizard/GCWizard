import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/intersect_lines.dart';
import 'package:gc_wizard/logic/tools/coords/projection.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_bearing.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:latlong/latlong.dart';

class CrossBearing extends StatefulWidget {
  @override
  CrossBearingState createState() => CrossBearingState();
}

class CrossBearingState extends State<CrossBearing> {
  LatLng _currentIntersection;

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;
  var _currentBearing1 = {'text': '','value': 0.0};

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;
  var _currentBearing2 = {'text': '','value': 0.0};

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];
  var _currentMapPoints;

  @override
  void initState() {
    super.initState();

    _currentMapPoints = [
      GCWMapPoint(point: _currentCoords1),
      GCWMapPoint(point: _currentCoords2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_crossbearing_coord1'),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWBearing(
          onChanged: (value) {
            setState(() {
              _currentBearing1 = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_crossbearing_coord2'),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
            });
          },
        ),
        GCWBearing(
          onChanged: (value) {
            setState(() {
              _currentBearing2 = value;
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
        GCWSubmitFlatButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: [
            GCWMapPolyline(
              points: [_getStartLine1(), _getEndLine1()]
            ),
            GCWMapPolyline(
              points: [_getStartLine2(), _getEndLine2()],
              color: HSLColor
                .fromColor(COLOR_MAP_POLYLINE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
                .toColor()
            ),
          ]
        ),
      ],
    );
  }

  GCWMapPoint _getStartLine1() {
    if (_currentIntersection != null)
      return _currentMapPoints[2];

    return _currentMapPoints[0];
  }

  GCWMapPoint _getStartLine2() {
    if (_currentIntersection != null)
      return _currentMapPoints[2];

    return _currentMapPoints[1];
  }

  GCWMapPoint _getEndLine1() {
     final _ells = defaultEllipsoid();

     if (_currentIntersection == null) {
       var distance1To2 = distanceBearing(_currentCoords1, _currentCoords2, _ells).distance;
       return GCWMapPoint(
         point: projection(_currentCoords1, _currentBearing1['value'], distance1To2 / 2.0, _ells),
         isVisible: false
       );
     }

     var distance1ToIntersect = distanceBearing(_currentIntersection, _currentCoords1, _ells).distance;
     return GCWMapPoint(
       point: projection(_currentIntersection, _currentBearing1['value'], distance1ToIntersect * 1.5, _ells),
       isVisible: false
     );
  }

  GCWMapPoint _getEndLine2() {
    final _ells = defaultEllipsoid();

    if (_currentIntersection == null) {
      var distance2To1 = distanceBearing(_currentCoords2, _currentCoords1, _ells).distance;
      return GCWMapPoint(
        point: projection(_currentCoords2, _currentBearing2['value'], distance2To1 / 2.0, _ells),
        isVisible: false
      );
    }

    var distance2ToIntersect = distanceBearing(_currentIntersection, _currentCoords2, _ells).distance;
    return GCWMapPoint(
      point: projection(_currentIntersection, _currentBearing2['value'], distance2ToIntersect * 1.5, _ells),
      isVisible: false
    );
  }

  _calculateOutput() {
    _currentIntersection = intersectBearings(_currentCoords1, _currentBearing1['value'], _currentCoords2, _currentBearing2['value'], defaultEllipsoid(), true);

    _currentMapPoints = [
      GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, "coords_crossbearing_coord1"),
        coordinateFormat: _currentCoordsFormat1
      ),
      GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, "coords_crossbearing_coord2"),
        coordinateFormat: _currentCoordsFormat2
      )
    ];

    if (_currentIntersection == null) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return;
    }

    _currentMapPoints.add(
      GCWMapPoint(
        point: _currentIntersection,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, "coords_common_intersection"),
        coordinateFormat: _currentOutputFormat
      )
    );

    _currentOutput = [formatCoordOutput(_currentIntersection, _currentOutputFormat, defaultEllipsoid())];
  }
}