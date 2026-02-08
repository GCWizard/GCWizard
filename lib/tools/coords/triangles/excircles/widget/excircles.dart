import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/triangles/excircles/logic/excircles.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/utils/constants.dart';

class TriangleExcircles extends StatefulWidget {
  const TriangleExcircles({
    super.key,
  });

  @override
  _TriangleExcirclesState createState() => _TriangleExcirclesState();
}

class _TriangleExcirclesState extends State<TriangleExcircles> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  var _currentOutputUnit = defaultLengthUnit;

  List<Object> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

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
        GCWCoordsOutput(
            outputs: _currentOutput,
            points: _currentMapPoints,
            polylines: _currentMapPolylines),
      ],
    );
  }

  void _calculateOutput() {
    var excircles = calculateEllipsoidTriangleExCircles(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!
    );
    var touchPoints = calculateEllipsoidTriangleExCirclesTouchPoints(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!
    );

    _currentOutput = [
      [
        buildCoordinate(_currentOutputFormat, excircles[0].center).toString().replaceAll('\n', '   ') as Object,
        '${i18n(context, 'common_radius')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(excircles[0].radius))} ${_currentOutputUnit.symbol}' as Object
      ].join('   '),
      [
        buildCoordinate(_currentOutputFormat, excircles[1].center).toString().replaceAll('\n', '   ') as Object,
        '${i18n(context, 'common_radius')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(excircles[1].radius))} ${_currentOutputUnit.symbol}' as Object
      ].join('   '),
      [
        buildCoordinate(_currentOutputFormat, excircles[2].center).toString().replaceAll('\n', '   ') as Object,
        '${i18n(context, 'common_radius')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(excircles[2].radius))} ${_currentOutputUnit.symbol}' as Object
      ].join('   '),
      buildCoordinate(_currentOutputFormat, touchPoints[0]).toString().replaceAll('\n', '   ') as Object,
      buildCoordinate(_currentOutputFormat, touchPoints[1]).toString().replaceAll('\n', '   ') as Object,
      buildCoordinate(_currentOutputFormat, touchPoints[2]).toString().replaceAll('\n', '   ') as Object,

    ];

    var mapPointCurrentCoords1 = GCWMapPoint(
        point: _currentCoords1.toLatLng()!,
        markerText: i18n(context, 'coords_centerthreepoints_coorda'),
        coordinateFormat: _currentCoords1.format);
    var mapPointCurrentCoords2 = GCWMapPoint(
        point: _currentCoords2.toLatLng()!,
        markerText: i18n(context, 'coords_centerthreepoints_coordb'),
        coordinateFormat: _currentCoords2.format);
    var mapPointCurrentCoords3 = GCWMapPoint(
        point: _currentCoords3.toLatLng()!,
        markerText: i18n(context, 'coords_centerthreepoints_coordc'),
        coordinateFormat: _currentCoords3.format);
    var mapPointExcircleA = GCWMapPoint(
      point: excircles[0].center,
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_excircle'),
      coordinateFormat: _currentOutputFormat,
      circle: GCWMapCircle(
          centerPoint: excircles[0].center, radius: excircles[0].radius),
      circleColorSameAsPointColor: true,
    );
    var mapPointExcircleB = GCWMapPoint(
      point: excircles[1].center,
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_excircle'),
      coordinateFormat: _currentOutputFormat,
      circle: GCWMapCircle(
          centerPoint: excircles[1].center, radius: excircles[1].radius),
      circleColorSameAsPointColor: true,
    );
    var mapPointExcircleC = GCWMapPoint(
      point: excircles[2].center,
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_excircle'),
      coordinateFormat: _currentOutputFormat,
      circle: GCWMapCircle(
          centerPoint: excircles[2].center, radius: excircles[2].radius),
      circleColorSameAsPointColor: true,
    );
    var mapTouchpointA = GCWMapPoint(
        point: touchPoints[0],
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'triangle_output_touchpoint') + ' a',
        coordinateFormat: _currentCoords3.format);
    var mapTouchpointB = GCWMapPoint(
        point: touchPoints[1],
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'triangle_output_touchpoint') + ' b',
        coordinateFormat: _currentCoords3.format);
    var mapTouchpointC = GCWMapPoint(
        point: touchPoints[2],
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'triangle_output_touchpoint') + ' c',
        coordinateFormat: _currentCoords3.format);

    _currentMapPoints = [
      mapPointCurrentCoords1,
      mapPointCurrentCoords2,
      mapPointCurrentCoords3,
      mapPointExcircleA,
      mapPointExcircleB,
      mapPointExcircleC,
      mapTouchpointA,
      mapTouchpointB,
      mapTouchpointC,
    ];

    _currentMapPolylines = [
      GCWMapPolyline(
          points: [mapPointCurrentCoords1, mapPointCurrentCoords2],
          color: Colors.black),
      GCWMapPolyline(
          points: [mapPointCurrentCoords2, mapPointCurrentCoords3],
          color: Colors.black),
      GCWMapPolyline(
          points: [mapPointCurrentCoords3, mapPointCurrentCoords1],
          color: Colors.black),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
