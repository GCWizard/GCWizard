import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/map_geometries.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/ellipsoidtriangle_circles.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/utils/constants.dart';

class EllipsoidTriangleIncircle extends StatefulWidget {
  const EllipsoidTriangleIncircle({
    super.key,
  });

  @override
  _EllipsoidTriangleIncircleState createState() => _EllipsoidTriangleIncircleState();
}

class _EllipsoidTriangleIncircleState extends State<EllipsoidTriangleIncircle> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  var _currentOutputUnit = defaultLengthUnit;

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  Widget _currentOutput = GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coorda'),
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
          title: i18n(context, 'coords_centerthreepoints_coordb'),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coordc'),
          coordsFormat: _currentCoords3.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords3 = ret;
              }
            });
          },
        ),
        GCWCoordsOutputFormatDistance(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value.format;
              _currentOutputUnit = value.lengthUnit;
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
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {

    var triangle = EllipsoidTriangle(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!,
        defaultEllipsoid
    );

    if (!triangle.isValid) {
      _currentOutput = GCWDefaultOutput(
        child: i18n(context, 'coords_triangles_invalidtriangle'),
      );
      return;
    }

    var incircle = calculateEllipsoidTriangleIncircle(triangle, defaultEllipsoid);

    if (incircle == null) {
      _currentOutput = GCWDefaultOutput(
        child: i18n(context, 'coords_triangles_noresult'),
      );
      return;
    }

    var _mapPointA = GCWMapPoint(
      point: _currentCoords1.toLatLng()!,
      markerText: i18n(context, 'coords_centerthreepoints_coorda'),
    );

    var _mapPointB = GCWMapPoint(
      point: _currentCoords2.toLatLng()!,
      markerText: i18n(context, 'coords_centerthreepoints_coordb'),
    );

    var _mapPointC = GCWMapPoint(
      point: _currentCoords3.toLatLng()!,
      markerText: i18n(context, 'coords_centerthreepoints_coordc'),
    );

    _currentMapPoints = [
      _mapPointA, _mapPointB, _mapPointC,
      GCWMapPoint(
        point: incircle.circle.center,
        circle: GCWMapCircle(
          centerPoint: incircle.circle.center,
          radius: incircle.circle.radius,
          color: COLOR_MAP_CALCULATEDPOINT
        ),
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_triangles_incircle_center')
      )
    ];

    _currentMapPolylines = [
      GCWMapPolyline(points: [_mapPointA, _mapPointB], color: COLOR_MAP_POLYLINE_TRIANGLE),
      GCWMapPolyline(points: [_mapPointB, _mapPointC], color: COLOR_MAP_POLYLINE_TRIANGLE),
      GCWMapPolyline(points: [_mapPointC, _mapPointA], color: COLOR_MAP_POLYLINE_TRIANGLE),
    ];

    for (int i = 0; i < incircle.touchpoints.length; i++) {
      _currentMapPoints.add(
        GCWMapPoint(
          point: incircle.touchpoints[i],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_triangles_touchpoint')
        )
      );
    }

    _currentOutput = GCWCoordsOutput(
      outputs: [
        GCWTextDivider(text: i18n(context, 'coords_triangles_incircle_center')),
        buildCoordinate(_currentOutputFormat, incircle.circle.center),
        GCWOutput(
          child: '${i18n(context, 'common_radius')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(incircle.circle.radius))} ${_currentOutputUnit.symbol}',
          copyText: _currentOutputUnit.fromMeter(incircle.circle.radius).toString(),
        ),
        GCWTextDivider(text: i18n(context, 'coords_triangles_touchpoints')),
        buildCoordinate(_currentOutputFormat, incircle.touchpoints[0]),
        buildCoordinate(_currentOutputFormat, incircle.touchpoints[1]),
        buildCoordinate(_currentOutputFormat, incircle.touchpoints[2]),
      ],
      points: _currentMapPoints,
      polylines: _currentMapPolylines,
    );
  }
}
