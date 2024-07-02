import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class EquilateralTriangle extends StatefulWidget {
  const EquilateralTriangle({Key? key}) : super(key: key);

  @override
  _EquilateralTriangleState createState() => _EquilateralTriangleState();
}

class _EquilateralTriangleState extends State<EquilateralTriangle> {
  var _currentIntersections = <LatLng>[];

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_equilateraltriangle_coorda"),
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
          title: i18n(context, "coords_equilateraltriangle_coordb"),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
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
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<List<LatLng>>(
                isolatedFunction: equilateralTriangleAsync,
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

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    return GCWAsyncExecuterParameters(EquilateralTriangleJobData(
        coord1: _currentCoords1.toLatLng()!, coord2: _currentCoords2.toLatLng()!, ells: defaultEllipsoid));
  }

  void _showOutput(List<LatLng> output) {
    _currentIntersections = output;

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1.toLatLng()!,
          markerText: i18n(context, 'coords_equilateraltriangle_coorda'),
          coordinateFormat: _currentCoords1.format),
      GCWMapPoint(
          point: _currentCoords2.toLatLng()!,
          markerText: i18n(context, 'coords_equilateraltriangle_coordb'),
          coordinateFormat: _currentCoords1.format)
    ];

    if (_currentIntersections.isEmpty) {
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

    for (var intersection in intersectionMapPoints) {
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
    }

    _currentOutput = _currentIntersections
        .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
