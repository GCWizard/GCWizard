import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class IntersectTwoCircles extends StatefulWidget {
  const IntersectTwoCircles({Key? key}) : super(key: key);

  @override
  _IntersectTwoCirclesState createState() => _IntersectTwoCirclesState();
}

class _IntersectTwoCirclesState extends State<IntersectTwoCircles> {
  var _currentIntersections = <LatLng>[];

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentRadius1 = 0.0;

  var _currentCoords2 = defaultBaseCoordinate;
  var _currentRadius2 = 0.0;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_intersectcircles_centerpoint1"),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
            });
          },
        ),
        GCWDistance(
          hintText: i18n(context, "common_radius"),
          onChanged: (value) {
            setState(() {
              _currentRadius1 = value;
            });
          },
        ),
        GCWCoords(
          title: i18n(context, "coords_intersectcircles_centerpoint2"),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
            });
          },
        ),
        GCWDistance(
          hintText: i18n(context, "common_radius"),
          onChanged: (value) {
            setState(() {
              _currentRadius2 = value;
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
        _buildSubmitButton(),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints),
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
              child: GCWAsyncExecuter<List<LatLng>>(
                isolatedFunction: intersectTwoCirclesAsync,
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
    return GCWAsyncExecuterParameters(IntersectTwoCirclesJobData(
        coord1: _currentCoords1.toLatLng()!,
        radius1: _currentRadius1,
        coord2: _currentCoords2.toLatLng()!,
        radius2: _currentRadius2,
        ells: defaultEllipsoid));
  }

  void _showOutput(List<LatLng> output) {
    _currentIntersections = output;

    _currentMapPoints = [
      GCWMapPoint(
        point: _currentCoords1.toLatLng()!,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint1'),
        coordinateFormat: _currentCoords1.format,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(
            radius: _currentRadius1,
            color: HSLColor.fromColor(COLOR_MAP_CIRCLE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_CIRCLE).lightness - 0.3)
                .toColor(),
            centerPoint: _currentCoords1.toLatLng()!),
      ),
      GCWMapPoint(
        point: _currentCoords2.toLatLng()!,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint2'),
        coordinateFormat: _currentCoords2.format,
        circle: GCWMapCircle(
            radius: _currentRadius2,
            color: HSLColor.fromColor(COLOR_MAP_CIRCLE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_CIRCLE).lightness - 0.3)
                .toColor(),
            centerPoint: _currentCoords2.toLatLng()!),
      )
    ];

    if (_currentIntersections.isEmpty) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentMapPoints.addAll(_currentIntersections
        .map((intersection) => GCWMapPoint(
            point: intersection,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList());

    _currentOutput = _currentIntersections
        .map((intersection) => formatCoordOutput(intersection, _currentOutputFormat, defaultEllipsoid))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
