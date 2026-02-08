import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/triangles/sidesmidpoint/logic/sidesmidpoint.dart';

class TriangleSideMidPoints extends StatefulWidget {
  const TriangleSideMidPoints({
    super.key,
  });

  @override
  _TriangleSideMidPointsState createState() => _TriangleSideMidPointsState();
}

class _TriangleSideMidPointsState extends State<TriangleSideMidPoints> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
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
            polylines: _currentMapPolylines),
      ],
    );
  }

  void _calculateOutput() {
    var sideMidPoints = calculateEllipsoidTriangleSideMidPoints(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!);

    _currentOutput = [
      buildCoordinate(_currentOutputFormat, sideMidPoints[0]) as Object,
      buildCoordinate(_currentOutputFormat, sideMidPoints[1]) as Object,
      buildCoordinate(_currentOutputFormat, sideMidPoints[2]) as Object,
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
    var mapPointSideMidPoint1 = GCWMapPoint(
      point: sideMidPoints[0],
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' c',
      coordinateFormat: _currentOutputFormat,
      circleColorSameAsPointColor: false,
    );
    var mapPointSideMidPoint2 = GCWMapPoint(
      point: sideMidPoints[1],
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' a',
      coordinateFormat: _currentOutputFormat,
      circleColorSameAsPointColor: false,
    );
    var mapPointSideMidPoint3 = GCWMapPoint(
      point: sideMidPoints[2],
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' b',
      coordinateFormat: _currentOutputFormat,
      circleColorSameAsPointColor: false,
    );

    _currentMapPoints = [
      mapPointCurrentCoords1,
      mapPointCurrentCoords2,
      mapPointCurrentCoords3,
      mapPointSideMidPoint1,
      mapPointSideMidPoint2,
      mapPointSideMidPoint3,
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
