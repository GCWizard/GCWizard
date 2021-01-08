import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/resection.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_angle.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';

class Resection extends StatefulWidget {
  @override
  ResectionState createState() => ResectionState();
}

class ResectionState extends State<Resection> {
  var _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;

  var _currentAngle12 = {'text': '','value': 0.0};

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;

  var _currentAngle23 = {'text': '','value': 0.0};

  var _currentCoordsFormat3 = defaultCoordFormat();
  var _currentCoords3 = defaultCoordinate;

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];
  var _currentMapPoints;
  List<GCWMapPolyline> _currentMapPolylines = [];

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
          title: i18n(context, "coords_resection_coorda"),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWAngle(
          hintText: i18n(context, "coords_resection_angle12"),
          onChanged: (value) {
            setState(() {
              _currentAngle12 = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, "coords_resection_coordb"),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
            });
          },
        ),
        GCWAngle(
          hintText: i18n(context, "coords_resection_angle23"),
          onChanged: (value) {
            setState(() {
              _currentAngle23 = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, "coords_resection_coordc"),
          coordsFormat: _currentCoordsFormat3,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat3 = ret['coordsFormat'];
              _currentCoords3 = ret['value'];
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
          polylines: _currentMapPolylines
        ),
      ],
    );
  }

  _calculateOutput() {
    _currentMapPoints = <GCWMapPoint>[];
    _currentMapPolylines = <GCWMapPolyline>[];

    if (_currentCoords1 == _currentCoords2
      || _currentCoords2 == _currentCoords3
      || _currentCoords1 == _currentCoords3) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return;
    }

    var ells = defaultEllipsoid();

    _currentIntersections = resection(_currentCoords1, _currentAngle12['value'], _currentCoords2, _currentAngle23['value'], _currentCoords3, ells);

    _currentMapPoints = [
      GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, 'coords_resection_coorda'),
        coordinateFormat: _currentCoordsFormat1
      ),
      GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, 'coords_resection_coordb'),
        coordinateFormat: _currentCoordsFormat2
      ),
      GCWMapPoint(
        point: _currentCoords3,
        markerText: i18n(context, 'coords_resection_coordc'),
        coordinateFormat: _currentCoordsFormat3
      ),
    ];

    if (_currentIntersections[0] == null && _currentIntersections[1] == null) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return;
    }

    //TODO:    LatLng center = centerPointThreePoints(_currentCoords1, _currentCoords2, _currentCoords3, ells)[0]['centerPoint'];
    //TODO: coord2 -> center
    _currentIntersections.sort((a, b) {
      return distanceBearing(a, _currentCoords2, ells).distance.compareTo(distanceBearing(b, _currentCoords2, ells).distance);
    });

    //show max. 2 solutions; if there are more -> special cases at the end of the world -> advanced mode
    _currentIntersections = _currentIntersections.sublist(0, min(_currentIntersections.length, 2));
    var intersectionMapPoints = _currentIntersections
      .map((intersection) => GCWMapPoint(
        point: intersection,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_intersection'),
        coordinateFormat: _currentOutputFormat
      ))
      .toList();

    _currentMapPoints.addAll(intersectionMapPoints);

    intersectionMapPoints.forEach((intersection) {
      _currentMapPolylines.addAll(
        [
          GCWMapPolyline(
            points: [intersection, _currentMapPoints[0]]
          ),
          GCWMapPolyline(
            points: [intersection, _currentMapPoints[1]]
          ),
          GCWMapPolyline(
            points: [intersection, _currentMapPoints[2]]
          ),
        ]
      );
    });

    _currentOutput = _currentIntersections
      .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid()))
      .toList();
  }
}