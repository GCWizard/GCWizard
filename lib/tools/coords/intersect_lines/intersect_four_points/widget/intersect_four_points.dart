import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class IntersectFourPoints extends StatefulWidget {
  const IntersectFourPoints({Key? key}) : super(key: key);

  @override
  _IntersectFourPointsState createState() => _IntersectFourPointsState();
}

class _IntersectFourPointsState extends State<IntersectFourPoints> {
  LatLng? _currentIntersection;

  var _currentCoords11 = defaultBaseCoordinate;
  var _currentCoords12 = defaultBaseCoordinate;
  var _currentCoords21 = defaultBaseCoordinate;
  var _currentCoords22 = defaultBaseCoordinate;

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];
  var _currentOutputFormat = defaultCoordinateFormat;
  List<Object> _currentOutput = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord11'),
          coordsFormat: _currentCoords11.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords11 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord12'),
          coordsFormat: _currentCoords12.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords12 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord21'),
          coordsFormat: _currentCoords21.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords21 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_intersectfourpoints_coord22'),
          coordsFormat: _currentCoords22.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords22 = ret;
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
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints, polylines: _currentMapPolylines),
      ],
    );
  }

  void _calculateOutput() {
    _currentIntersection = intersectFourPoints(
        _currentCoords11.toLatLng()!,
        _currentCoords12.toLatLng()!,
        _currentCoords21.toLatLng()!,
        _currentCoords22.toLatLng()!,
        defaultEllipsoid
    );

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords11.toLatLng()!,
          markerText: i18n(context, 'coords_intersectfourpoints_coord11'),
          coordinateFormat: _currentCoords11.format),
      GCWMapPoint(
          point: _currentCoords12.toLatLng()!,
          markerText: i18n(context, 'coords_intersectfourpoints_coord12'),
          coordinateFormat: _currentCoords12.format),
      GCWMapPoint(
          point: _currentCoords21.toLatLng()!,
          markerText: i18n(context, 'coords_intersectfourpoints_coord21'),
          coordinateFormat: _currentCoords21.format),
      GCWMapPoint(
          point: _currentCoords22.toLatLng()!,
          markerText: i18n(context, 'coords_intersectfourpoints_coord22'),
          coordinateFormat: _currentCoords22.format)
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
        point: _currentIntersection!,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_intersection'),
        coordinateFormat: _currentOutputFormat));

    _currentOutput = [buildCoordinate(_currentOutputFormat, _currentIntersection!)];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
