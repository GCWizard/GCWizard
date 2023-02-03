import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class EquilateralTriangle extends StatefulWidget {
  @override
  EquilateralTriangleState createState() => EquilateralTriangleState();
}

class EquilateralTriangleState extends State<EquilateralTriangle> {
  var _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;

  var _currentOutputFormat = defaultCoordFormat();
  List<String> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_equilateraltriangle_coorda"),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, "coords_equilateraltriangle_coordb"),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
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
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
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
                isolatedFunction: equilateralTriangleAsync,
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
    return GCWAsyncExecuterParameters(
        EquilateralTriangleJobData(coord1: _currentCoords1, coord2: _currentCoords2, ells: defaultEllipsoid()));
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

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1,
          markerText: i18n(context, 'coords_equilateraltriangle_coorda'),
          coordinateFormat: _currentCoordsFormat1),
      GCWMapPoint(
          point: _currentCoords2,
          markerText: i18n(context, 'coords_equilateraltriangle_coordb'),
          coordinateFormat: _currentCoordsFormat2)
    ];

    if (_currentIntersections == null || _currentIntersections.isEmpty) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    var intersectionMapPoints = _currentIntersections
        .map((intersection) => GCWMapPoint(
            point: intersection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList();

    _currentMapPoints.addAll(intersectionMapPoints);

    _currentMapPolylines = [
      GCWMapPolyline(points: [_currentMapPoints[0], _currentMapPoints[1]]),
    ];

    intersectionMapPoints.forEach((intersection) {
      _currentMapPolylines.addAll([
        GCWMapPolyline(
            points: [_currentMapPoints[0], intersection],
            color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
                .toColor()),
        GCWMapPolyline(
            points: [_currentMapPoints[1], intersection],
            color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
                .toColor())
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
