import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class IntersectBearings extends StatefulWidget {
  const IntersectBearings({Key? key}) : super(key: key);

  @override
  _IntersectBearingsState createState() => _IntersectBearingsState();
}

class _IntersectBearingsState extends State<IntersectBearings> {
  LatLng? _currentIntersection;

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentBearing1 = defaultDoubleText;

  var _currentCoords2 = defaultBaseCoordinate;
  var _currentBearing2 = defaultDoubleText;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<Object> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_intersectbearings_coord1'),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
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
          title: i18n(context, 'coords_intersectbearings_coord2'),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
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
        // _buildSubmitButton(),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
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

  void _calculateOutput() {
    _currentIntersection = intersectBearings(
      _currentCoords1.toLatLng()!,
      _currentBearing1.value,
      _currentCoords2.toLatLng()!,
      _currentBearing2.value,
      defaultEllipsoid
    );

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords1.toLatLng()!,
          markerText: i18n(context, 'coords_intersectbearings_coord1'),
          coordinateFormat: _currentCoords1.format),
      GCWMapPoint(
          point: _currentCoords2.toLatLng()!,
          markerText: i18n(context, 'coords_intersectbearings_coord2'),
          coordinateFormat: _currentCoords2.format)
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

    _currentMapPolylines = [
      GCWMapPolyline(points: [_currentMapPoints[0], _getEndLine1()]),
      GCWMapPolyline(
          points: [_currentMapPoints[1], _getEndLine2()],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
              .toColor())
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  GCWMapPoint _getEndLine1() {
    final _ells = defaultEllipsoid;

    GCWMapPoint mapPoint;
    if (_currentIntersection == null) {
      var distance1To2 = distanceBearing(_currentCoords1.toLatLng()!, _currentCoords2.toLatLng()!, _ells).distance;
      mapPoint = GCWMapPoint(
          point: projection(_currentCoords1.toLatLng()!, _currentBearing1.value, distance1To2 * 3, _ells),
          isVisible: false);
    } else {
      var distance1ToIntersect = distanceBearing(_currentCoords1.toLatLng()!, _currentIntersection!, _ells).distance;
      mapPoint = GCWMapPoint(
          point: projection(_currentCoords1.toLatLng()!, _currentBearing1.value, distance1ToIntersect, _ells),
          isVisible: false);
    }

    _currentMapPoints.add(mapPoint);
    return mapPoint;
  }

  GCWMapPoint _getEndLine2() {
    final _ells = defaultEllipsoid;

    GCWMapPoint mapPoint;
    if (_currentIntersection == null) {
      var distance2To1 = distanceBearing(_currentCoords2.toLatLng()!, _currentCoords1.toLatLng()!, _ells).distance;
      mapPoint = GCWMapPoint(
          point: projection(_currentCoords2.toLatLng()!, _currentBearing2.value, distance2To1 * 3, _ells),
          isVisible: false);
    } else {
      var distance2ToIntersect = distanceBearing(_currentCoords2.toLatLng()!, _currentIntersection!, _ells).distance;
      mapPoint = GCWMapPoint(
          point: projection(_currentCoords2.toLatLng()!, _currentBearing2.value, distance2ToIntersect, _ells),
          isVisible: false);
    }

    _currentMapPoints.add(mapPoint);
    return mapPoint;
  }
}
