import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:latlong2/latlong.dart';

class OrthogonalProjectionTwoPoints extends StatefulWidget {
  const OrthogonalProjectionTwoPoints({super.key});

  @override
  _OrthogonalProjectionTwoPointsState createState() => _OrthogonalProjectionTwoPointsState();
}

class _OrthogonalProjectionTwoPointsState extends State<OrthogonalProjectionTwoPoints> {
  var _currentCoord = defaultBaseCoordinate;
  var _currentA = defaultBaseCoordinate;
  var _currentB = defaultBaseCoordinate;

  var _currentValues = <LatLng>[];
  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  var _currentOutputFormat = defaultCoordinateFormat;
  var _currentOutput = <BaseCoordinate>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_orthogonalprojection_point'),
          coordsFormat: _currentCoord.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoord = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_orthogonalprojection_start'),
          coordsFormat: _currentA.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentA = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_orthogonalprojection_end'),
          coordsFormat: _currentB.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentB = ret;
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
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
      ],
    );
  }

  void _calculateOutput() {
    _currentValues = [orthogonalProjectionTwoPoints(_currentCoord.toLatLng()!, _currentA.toLatLng()!, _currentB.toLatLng()!, defaultEllipsoid)];

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoord.toLatLng()!,
          markerText: i18n(context, 'coords_orthogonalprojection_point'),
          coordinateFormat: _currentCoord.format),
      GCWMapPoint(
          point: _currentA.toLatLng()!,
          markerText: i18n(context, 'coords_orthogonalprojection_start'),
          coordinateFormat: _currentCoord.format),
      GCWMapPoint(
          point: _currentB.toLatLng()!,
          markerText: i18n(context, 'coords_orthogonalprojection_end'),
          coordinateFormat: _currentCoord.format),
      GCWMapPoint(
          point: _currentValues[0],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_orthogonalprojection_projected'),
          coordinateFormat: _currentOutputFormat),
    ];

    var distBearCalc = distanceBearing(_currentA.toLatLng()!, _currentValues.first, defaultEllipsoid);
    var distBearAB = distanceBearing(_currentA.toLatLng()!, _currentB.toLatLng()!, defaultEllipsoid);

    _currentMapPolylines = [GCWMapPolyline(points: [_currentMapPoints[1], _currentMapPoints[2]])];

    if (doubleEquals(distBearAB.bearingAToB, distBearCalc.bearingAToB, tolerance: 5)) {
      if (distBearAB.distance < distBearCalc.distance) {
        var length = distBearAB.distance + 2 * (distBearCalc.distance - distBearAB.distance);
        var endPoint2 = projection(_currentA.toLatLng()!, distBearCalc.bearingAToB, length, defaultEllipsoid);
        _currentMapPoints.add(GCWMapPoint(point: endPoint2, isVisible: false));
        _currentMapPolylines.add(GCWMapPolyline(points: [_currentMapPoints[1], _currentMapPoints[4]]));
      }
    } else {
      var length = distBearAB.distance + 2 * distBearCalc.distance;
      var endPoint2 = projection(_currentB.toLatLng()!, distBearAB.bearingBToA, length, defaultEllipsoid);
      _currentMapPoints.add(GCWMapPoint(point: endPoint2, isVisible: false));
      _currentMapPolylines.add(GCWMapPolyline(points: [_currentMapPoints[2], _currentMapPoints[4]]));
    }

    _currentOutput = _currentValues.map((LatLng coord) {
      return buildCoordinate(_currentOutputFormat, coord);
    }).toList();
  }
}
