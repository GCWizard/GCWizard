import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_angle.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/resection/logic/resection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class Resection extends StatefulWidget {
  const Resection({Key? key}) : super(key: key);

  @override
  _ResectionState createState() => _ResectionState();
}

class _ResectionState extends State<Resection> {
  var _currentIntersections = <LatLng>[];

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentAngle12 = defaultDoubleText;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentAngle23 = defaultDoubleText;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];
  final List<GCWMapPolyline> _currentMapPolylines = [];
  final _ellipsoid = defaultEllipsoid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_resection_coorda"),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
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
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
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
          coordsFormat: _currentCoords3.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords3 = ret;
              }
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
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<List<LatLng>>(
                isolatedFunction: resectionAsync,
                parameter: _buildJobData,
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    if (_currentCoords1 == _currentCoords2 ||
        _currentCoords2 == _currentCoords3 ||
        _currentCoords1 == _currentCoords3) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      return null;
    }

    return GCWAsyncExecuterParameters(ResectionJobData(
        coord1: _currentCoords1.toLatLng()!,
        angle12: _currentAngle12.value,
        coord2: _currentCoords2.toLatLng()!,
        angle23: _currentAngle23.value,
        coord3: _currentCoords3.toLatLng()!,
        ells: _ellipsoid));
  }

  void _showOutput(List<LatLng> output) {
    _currentIntersections = output;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1.toLatLng()!,
          markerText: i18n(context, 'coords_resection_coorda'),
          coordinateFormat: _currentCoords1.format),
      GCWMapPoint(
          point: _currentCoords2.toLatLng()!,
          markerText: i18n(context, 'coords_resection_coordb'),
          coordinateFormat: _currentCoords2.format),
      GCWMapPoint(
          point: _currentCoords3.toLatLng()!,
          markerText: i18n(context, 'coords_resection_coordc'),
          coordinateFormat: _currentCoords3.format),
    ];

    if (_currentIntersections.isEmpty) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    //TODO:    LatLng center = centerPointThreePoints(_currentCoords1, _currentCoords2, _currentCoords3, ells)[0]['centerPoint'];
    //TODO: coord2 -> center
    _currentIntersections.sort((a, b) {
      return distanceBearing(a, _currentCoords2.toLatLng()!, _ellipsoid)
          .distance
          .compareTo(distanceBearing(b, _currentCoords2.toLatLng()!, _ellipsoid).distance);
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

    for (var intersection in intersectionMapPoints) {
      _currentMapPolylines.addAll([
        GCWMapPolyline(points: [intersection, _currentMapPoints[0]]),
        GCWMapPolyline(points: [intersection, _currentMapPoints[1]]),
        GCWMapPolyline(points: [intersection, _currentMapPoints[2]]),
      ]);
    }

    _currentOutput = _currentIntersections
        .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
