import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class IntersectTwoCircles extends StatefulWidget {
  const IntersectTwoCircles({super.key});

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
  List<Object> _currentOutput = [];
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
        GCWSubmitButton(
          onPressed:() {
            setState(() {
              _calculateOutput();
            });
          }
        ),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints),
      ],
    );
  }

  void _calculateOutput() {
    _currentIntersections = intersectTwoCircles(
      _currentCoords1.toLatLng()!,
      _currentRadius1,
      _currentCoords2.toLatLng()!,
      _currentRadius2,
      defaultEllipsoid
    );

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
        .map((intersection) => buildCoordinate(_currentOutputFormat, intersection))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
