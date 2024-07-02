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
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class CenterThreePoints extends StatefulWidget {
  const CenterThreePoints({Key? key}) : super(key: key);

  @override
  _CenterThreePointsState createState() => _CenterThreePointsState();
}

class _CenterThreePointsState extends State<CenterThreePoints> {
  LatLng _currentCenter = defaultCoordinate;
  double _currentDistance = 0.0;

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  Length _currentOutputUnit = defaultLengthUnit;
  List<String> _currentOutput = [];

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
          onChanged: (GCWCoordsOutputFormatDistanceValue value) {
            setState(() {
              _currentOutputFormat = value.format;
              _currentOutputUnit = value.lengthUnit;
            });
          },
        ),
        _buildSubmitButton(),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints, polylines: _currentMapPolylines),
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
              child: GCWAsyncExecuter<List<CenterPointDistance>?>(
                isolatedFunction: centerPointThreePointsAsync,
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
    return GCWAsyncExecuterParameters(CenterPointJobData(
        coord1: _currentCoords1.toLatLng()!,
        coord2: _currentCoords2.toLatLng()!,
        coord3: _currentCoords3.toLatLng()!,
        ellipsoid: defaultEllipsoid));
  }

  void _showOutput(List<CenterPointDistance>? output) {
    if (output == null) {
      _currentOutput = [];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentCenter = output.first.centerPoint;
    _currentDistance = output.first.distance;

    _currentOutput = output.map((coord) {
      return formatCoordOutput(coord.centerPoint, _currentOutputFormat, defaultEllipsoid);
    }).toList();
    _currentOutput.add(
        '${i18n(context, 'coords_center_distance')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(_currentDistance))} ${_currentOutputUnit.symbol}');

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
    var mapPointCenter = GCWMapPoint(
        point: _currentCenter,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_centerpoint'),
        coordinateFormat: _currentOutputFormat,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(radius: _currentDistance, centerPoint: _currentCenter));

    _currentMapPoints = [mapPointCurrentCoords1, mapPointCurrentCoords2, mapPointCurrentCoords3, mapPointCenter];

    _currentMapPolylines = [
      GCWMapPolyline(points: [mapPointCurrentCoords1, mapPointCenter]),
      GCWMapPolyline(
          points: [mapPointCurrentCoords2, mapPointCenter],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
              .toColor()),
      GCWMapPolyline(
          points: [mapPointCurrentCoords3, mapPointCenter],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
              .toColor())
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
