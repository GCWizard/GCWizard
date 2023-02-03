import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_angle.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/resection/logic/resection.dart';
import 'package:latlong2/latlong.dart';

class Resection extends StatefulWidget {
  @override
  ResectionState createState() => ResectionState();
}

class ResectionState extends State<Resection> {
  var _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;

  var _currentAngle12 = {'text': '', 'value': 0.0};

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;

  var _currentAngle23 = {'text': '', 'value': 0.0};

  var _currentCoordsFormat3 = defaultCoordFormat();
  var _currentCoords3 = defaultCoordinate;

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];
  List<GCWMapPolyline> _currentMapPolylines = [];
  dynamic _ells;

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
        _buildSubmitButton(),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints, polylines: _currentMapPolylines),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              child: GCWAsyncExecuter(
                isolatedFunction: resectionAsync,
                parameter: _buildJobData(),
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
              height: 220,
              width: 150,
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    if (_currentCoords1 == _currentCoords2 ||
        _currentCoords2 == _currentCoords3 ||
        _currentCoords1 == _currentCoords3) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return null;
    }
    _ells = defaultEllipsoid();
    return GCWAsyncExecuterParameters(ResectionJobData(
        coord1: _currentCoords1,
        angle12: _currentAngle12['value'],
        coord2: _currentCoords2,
        angle23: _currentAngle23['value'],
        coord3: _currentCoords3,
        ells: _ells));
  }

  _showOutput(List<LatLng> output) {
    if (output == null) {
      _currentOutput = [];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentIntersections = output;

    var ells = _ells;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1,
          markerText: i18n(context, 'coords_resection_coorda'),
          coordinateFormat: _currentCoordsFormat1),
      GCWMapPoint(
          point: _currentCoords2,
          markerText: i18n(context, 'coords_resection_coordb'),
          coordinateFormat: _currentCoordsFormat2),
      GCWMapPoint(
          point: _currentCoords3,
          markerText: i18n(context, 'coords_resection_coordc'),
          coordinateFormat: _currentCoordsFormat3),
    ];

    if (_currentIntersections.length == 0 || (_currentIntersections[0] == null && _currentIntersections[1] == null)) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    //TODO:    LatLng center = centerPointThreePoints(_currentCoords1, _currentCoords2, _currentCoords3, ells)[0]['centerPoint'];
    //TODO: coord2 -> center
    _currentIntersections.sort((a, b) {
      return distanceBearing(a, _currentCoords2, ells)
          .distance
          .compareTo(distanceBearing(b, _currentCoords2, ells).distance);
    });

    //show max. 2 solutions; if there are more -> special cases at the end of the world -> advanced mode
    _currentIntersections = _currentIntersections.sublist(0, min(_currentIntersections.length, 2));
    var intersectionMapPoints = _currentIntersections
        .map((intersection) => GCWMapPoint(
            point: intersection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList();

    _currentMapPoints.addAll(intersectionMapPoints);

    intersectionMapPoints.forEach((intersection) {
      _currentMapPolylines.addAll([
        GCWMapPolyline(points: [intersection, _currentMapPoints[0]]),
        GCWMapPolyline(points: [intersection, _currentMapPoints[1]]),
        GCWMapPolyline(points: [intersection, _currentMapPoints[2]]),
      ]);
    });

    _currentOutput = _currentIntersections
        .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid()))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
