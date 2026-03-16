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
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:latlong2/latlong.dart';

class OrthogonalProjection extends StatefulWidget {
  const OrthogonalProjection({super.key});

  @override
  _OrthogonalProjectionState createState() => _OrthogonalProjectionState();
}

class _OrthogonalProjectionState extends State<OrthogonalProjection> {
  var _currentCoord = defaultBaseCoordinate;
  var _currentStart = defaultBaseCoordinate;
  var _currentBearing = defaultDoubleText;

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
          coordsFormat: _currentStart.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentStart = ret;
              }
            });
          },
        ),
        GCWBearing(
          hintText: i18n(context, 'coords_orthogonalprojection_bearing'),
          onChanged: (value) {
            setState(() {
              _currentBearing = value;
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
    _currentValues = [orthogonalProjection(_currentCoord.toLatLng()!, _currentStart.toLatLng()!, _currentBearing.value, defaultEllipsoid)];

    var distBear = distanceBearing(_currentStart.toLatLng()!, _currentValues.first, defaultEllipsoid);

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoord.toLatLng()!,
          markerText: i18n(context, 'coords_orthogonalprojection_point'),
          coordinateFormat: _currentCoord.format),
      GCWMapPoint(
          point: _currentStart.toLatLng()!,
          markerText: i18n(context, 'coords_orthogonalprojection_start'),
          coordinateFormat: _currentCoord.format),
      GCWMapPoint(
          point: _currentValues[0],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_orthogonalprojection_projected'),
          coordinateFormat: _currentOutputFormat),
    ];


    var endPoint = projection(_currentStart.toLatLng()!, distBear.bearingAToB, distBear.distance * 1.5, defaultEllipsoid);
    _currentMapPoints.add(GCWMapPoint(point: endPoint, isVisible: false));
    _currentMapPolylines = [GCWMapPolyline(points: [_currentMapPoints[1], _currentMapPoints[3]])];

    if (!doubleEquals(_currentBearing.value, distBear.bearingAToB, tolerance: 5)) {
      var endPoint2 = projection(_currentStart.toLatLng()!, _currentBearing.value, distBear.distance * 0.5, defaultEllipsoid);
      _currentMapPoints.add(GCWMapPoint(point: endPoint2, isVisible: false));
      _currentMapPolylines.add(GCWMapPolyline(points: [_currentMapPoints[1], _currentMapPoints[4]]));
    }

    _currentOutput = _currentValues.map((LatLng coord) {
      return buildCoordinate(_currentOutputFormat, coord);
    }).toList();
  }
}
