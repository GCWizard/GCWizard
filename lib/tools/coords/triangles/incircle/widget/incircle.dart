import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/logic/incircle.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/utils/constants.dart';

class TriangleIncircle extends StatefulWidget {
  const TriangleIncircle({
    super.key,
  });

  @override
  _TriangleIncircleState createState() => _TriangleIncircleState();
}

class _TriangleIncircleState extends State<TriangleIncircle> {
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
    var inCenterPoint = calculateEllipsoidTriangleInCircle(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!);

    _currentOutput = [buildCoordinate(_currentOutputFormat, inCenterPoint.center) as Object];
    _currentOutput.add(GCWOutputText(
      text: '${i18n(context, 'common_radius')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(inCenterPoint.radius))} ${_currentOutputUnit.symbol}',
      copyText: _currentOutputUnit.fromMeter(inCenterPoint.radius).toString(),
    ) as Object
    );

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
    var mapPointInCenter = GCWMapPoint(
      point: inCenterPoint.center,
      color: COLOR_MAP_CALCULATEDPOINT,
      markerText: i18n(context, 'triangle_output_incenter'),
      coordinateFormat: _currentOutputFormat,
      circle: GCWMapCircle(centerPoint: inCenterPoint.center, radius: inCenterPoint.radius),
      circleColorSameAsPointColor: true,
    );

    _currentMapPoints = [
      mapPointCurrentCoords1,
      mapPointCurrentCoords2,
      mapPointCurrentCoords3,
      mapPointInCenter,
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
