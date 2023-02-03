import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class CenterThreePoints extends StatefulWidget {
  @override
  CenterThreePointsState createState() => CenterThreePointsState();
}

class CenterThreePointsState extends State<CenterThreePoints> {
  LatLng _currentCenter = defaultCoordinate;
  double _currentDistance = 0.0;

  var _currentCoords1 = defaultCoordinate;
  var _currentCoords2 = defaultCoordinate;
  var _currentCoords3 = defaultCoordinate;

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoordsFormat3 = defaultCoordFormat();

  var _currentOutputFormat = defaultCoordFormat();
  Length _currentOutputUnit = UNITCATEGORY_LENGTH.defaultUnit;
  List<String> _currentOutput = [];

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coorda'),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coordb'),
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coordc'),
          coordsFormat: _currentCoordsFormat3,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat3 = ret['coordsFormat'];
              _currentCoords3 = ret['value'];
            });
          },
        ),
        GCWCoordsOutputFormatDistance(
          coordFormat: _currentOutputFormat,
          onChanged: (value) {
            setState(() {
              _currentOutputFormat = value['coordFormat'];
              _currentOutputUnit = value['unit'];
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
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              child: GCWAsyncExecuter(
                isolatedFunction: centerPointThreePointsAsync,
                parameter: _buildJobData(),
                onReady: (data) => _showOutput(data),
                isOverlay: true,
              ),
              height: 220,
              width: 150,
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    return GCWAsyncExecuterParameters(CenterPointJobData(
        coord1: _currentCoords1, coord2: _currentCoords2, coord3: _currentCoords3, ells: defaultEllipsoid()));
  }

  _showOutput(List<Map<String, dynamic>> output) {
    if (output == null) {
      _currentOutput = [];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentCenter = output[0]['centerPoint'];
    _currentDistance = output[0]['distance'];

    _currentOutput = output.map((coord) {
      return '${formatCoordOutput(coord['centerPoint'], _currentOutputFormat, defaultEllipsoid())}';
    }).toList();
    _currentOutput.add(
        '${i18n(context, 'coords_center_distance')}: ${doubleFormat.format(_currentOutputUnit.fromMeter(_currentDistance))} ${_currentOutputUnit.symbol}');

    var mapPointCurrentCoords1 = GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, 'coords_centerthreepoints_coorda'),
        coordinateFormat: _currentCoordsFormat1);
    var mapPointCurrentCoords2 = GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, 'coords_centerthreepoints_coordb'),
        coordinateFormat: _currentCoordsFormat2);
    var mapPointCurrentCoords3 = GCWMapPoint(
        point: _currentCoords3,
        markerText: i18n(context, 'coords_centerthreepoints_coordc'),
        coordinateFormat: _currentCoordsFormat3);
    var mapPointCenter = GCWMapPoint(
        point: _currentCenter,
        color: COLOR_MAP_CALCULATEDPOINT,
        markerText: i18n(context, 'coords_common_centerpoint'),
        coordinateFormat: _currentOutputFormat,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(radius: _currentDistance));

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
