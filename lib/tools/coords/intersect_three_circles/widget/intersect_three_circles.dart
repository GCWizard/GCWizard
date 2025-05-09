import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/tools/coords/intersect_three_circles/logic/intersect_three_circles.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/constants.dart';

class IntersectThreeCircles extends StatefulWidget {
  const IntersectThreeCircles({super.key});

  @override
  _IntersectThreeCirclesState createState() => _IntersectThreeCirclesState();
}

class _IntersectThreeCirclesState extends State<IntersectThreeCircles> {
  List<CircleIntersection> _currentIntersections = [];

  var _currentCoords1 = defaultBaseCoordinate;
  var _currentRadius1 = 0.0;

  var _currentCoords2 = defaultBaseCoordinate;
  var _currentRadius2 = 0.0;

  var _currentCoords3 = defaultBaseCoordinate;
  var _currentRadius3 = 0.0;

  var _currentOutputFormat = defaultCoordinateFormat;
  Length _currentOutputUnit = defaultLengthUnit;
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
        GCWCoords(
          title: i18n(context, "coords_intersectcircles_centerpoint3"),
          coordsFormat: _currentCoords3.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords3 = ret;
              }
            });
          },
        ),
        GCWDistance(
          hintText: i18n(context, "common_radius"),
          onChanged: (value) {
            setState(() {
              _currentRadius3 = value;
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
        GCWSubmitButton(onPressed: () {
          setState(() {
            calculateOutput();
          });
        }),
        GCWCoordsOutput(outputs: _currentOutput, points: _currentMapPoints),
      ],
    );
  }

  void calculateOutput() {
    _currentIntersections = intersectThreeCircles(
        _currentCoords1.toLatLng()!,
        _currentRadius1,
        _currentCoords2.toLatLng()!,
        _currentRadius2,
        _currentCoords3.toLatLng()!,
        _currentRadius3,
        10,
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
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(radius: _currentRadius2, centerPoint: _currentCoords2.toLatLng()!),
      ),
      GCWMapPoint(
        point: _currentCoords3.toLatLng()!,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint3'),
        coordinateFormat: _currentCoords3.format,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(
            radius: _currentRadius3,
            color: HSLColor.fromColor(COLOR_MAP_CIRCLE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_CIRCLE).lightness + 0.2)
                .toColor(),
            centerPoint: _currentCoords3.toLatLng()!),
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
            point: intersection.coords,
            color: COLOR_MAP_CALCULATEDPOINT,
            markerText: i18n(context, 'coords_common_intersection'),
            coordinateFormat: _currentOutputFormat))
        .toList());

    _currentOutput = _currentIntersections.map((intersection) {
      var outputText = '${formatCoordOutput(intersection.coords, _currentOutputFormat, defaultEllipsoid)} '
          '(${i18n(context, "coords_intersectthreecircles_accuracy")}: '
          '${doubleFormat.format(_currentOutputUnit.fromMeter(intersection.accuracy))} ${_currentOutputUnit.symbol})';
      var copyText = formatCoordOutput(intersection.coords, _currentOutputFormat, defaultEllipsoid, false);

      return GCWOutputText(
        text: outputText,
        copyText: copyText
      );
    }).toList();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
