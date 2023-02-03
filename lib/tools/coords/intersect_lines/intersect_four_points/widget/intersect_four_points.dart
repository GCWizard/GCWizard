import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/logic/intersect_lines.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class IntersectFourPoints extends StatefulWidget {
  @override
  IntersectFourPointsState createState() => IntersectFourPointsState();
}

class IntersectFourPointsState extends State<IntersectFourPoints> {
  LatLng _currentIntersection;

  var _currentCoords11 = defaultCoordinate;
  var _currentCoords12 = defaultCoordinate;
  var _currentCoords21 = defaultCoordinate;
  var _currentCoords22 = defaultCoordinate;

  var _currentCoordsFormat11 = defaultCoordFormat();
  var _currentCoordsFormat12 = defaultCoordFormat();
  var _currentCoordsFormat21 = defaultCoordFormat();
  var _currentCoordsFormat22 = defaultCoordFormat();

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];
  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];

  @override
  void initState() {
    super.initState();

    _currentMapPoints = [
      GCWMapPoint(point: _currentCoords11),
      GCWMapPoint(point: _currentCoords12),
      GCWMapPoint(point: _currentCoords21),
      GCWMapPoint(point: _currentCoords22),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord11'),
          coordsFormat: _currentCoordsFormat11,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat11 = ret['coordsFormat'];
              _currentCoords11 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord12'),
          coordsFormat: _currentCoordsFormat12,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat12 = ret['coordsFormat'];
              _currentCoords12 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord21'),
          coordsFormat: _currentCoordsFormat21,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat21 = ret['coordsFormat'];
              _currentCoords21 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord22'),
          coordsFormat: _currentCoordsFormat22,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat22 = ret['coordsFormat'];
              _currentCoords22 = ret['value'];
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
                isolatedFunction: intersectFourPointsAsync,
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
    return GCWAsyncExecuterParameters(IntersectFourPointsJobData(
        coord11: _currentCoords11,
        coord12: _currentCoords12,
        coord21: _currentCoords21,
        coord22: _currentCoords22,
        ells: defaultEllipsoid()));
  }

  _showOutput(LatLng output) {
    _currentIntersection = output;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords11,
          markerText: i18n(context, 'coords_intersectfourpoints_coord11'),
          coordinateFormat: _currentCoordsFormat11),
      GCWMapPoint(
          point: _currentCoords12,
          markerText: i18n(context, 'coords_intersectfourpoints_coord12'),
          coordinateFormat: _currentCoordsFormat12),
      GCWMapPoint(
          point: _currentCoords21,
          markerText: i18n(context, 'coords_intersectfourpoints_coord21'),
          coordinateFormat: _currentCoordsFormat21),
      GCWMapPoint(
          point: _currentCoords22,
          markerText: i18n(context, 'coords_intersectfourpoints_coord22'),
          coordinateFormat: _currentCoordsFormat22)
    ];

    _currentMapPolylines = [
      GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]]),
      GCWMapPolyline(
          points: [_currentMapPoints[2], _currentMapPoints[3]],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
              .toColor()),
    ];

    if (_currentIntersection == null) {
      _currentOutput = [i18n(context, 'coords_intersect_nointersection')];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentMapPoints.add(GCWMapPoint(
        point: _currentIntersection,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_intersection'),
        coordinateFormat: _currentOutputFormat));

    _currentOutput = [formatCoordOutput(_currentIntersection, _currentOutputFormat, defaultEllipsoid())];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
