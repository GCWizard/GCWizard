import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_outputformat_distance.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/tools/coords/intersect_three_circles/logic/intersect_three_circles.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/utils/constants.dart';

class IntersectThreeCircles extends StatefulWidget {
  @override
  IntersectThreeCirclesState createState() => IntersectThreeCirclesState();
}

class IntersectThreeCirclesState extends State<IntersectThreeCircles> {
  List<Intersect> _currentIntersections = [];

  var _currentCoordsFormat1 = defaultCoordFormat();
  var _currentCoords1 = defaultCoordinate;
  var _currentRadius1 = 0.0;

  var _currentCoordsFormat2 = defaultCoordFormat();
  var _currentCoords2 = defaultCoordinate;
  var _currentRadius2 = 0.0;

  var _currentCoordsFormat3 = defaultCoordFormat();
  var _currentCoords3 = defaultCoordinate;
  var _currentRadius3 = 0.0;

  var _currentOutputFormat = defaultCoordFormat();
  Length _currentOutputUnit = UNITCATEGORY_LENGTH.defaultUnit;
  List<String> _currentOutput = [];
  List<String> _currentCopyableOutput = [];
  var _currentMapPoints = <GCWMapPoint>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, "coords_intersectcircles_centerpoint1"),
          coordsFormat: _currentCoordsFormat1,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat1 = ret['coordsFormat'];
              _currentCoords1 = ret['value'];
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
          coordsFormat: _currentCoordsFormat2,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat2 = ret['coordsFormat'];
              _currentCoords2 = ret['value'];
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
          coordsFormat: _currentCoordsFormat3,
          onChanged: (ret) {
            setState(() {
              _currentCoordsFormat3 = ret['coordsFormat'];
              _currentCoords3 = ret['value'];
            });
          },
        ),
        new GCWDistance(
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
              _currentOutputFormat = value['coordFormat'];
              _currentOutputUnit = value['unit'];
            });
          },
        ),
        _buildSubmitButton(),
        GCWCoordsOutput(outputs: _currentOutput, copyTexts: _currentCopyableOutput, points: _currentMapPoints),
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
                isolatedFunction: intersectThreeCirclesAsync,
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
    return GCWAsyncExecuterParameters(IntersectThreeCirclesJobData(
        coord1: _currentCoords1,
        dist14: _currentRadius1,
        coord2: _currentCoords2,
        dist24: _currentRadius2,
        coord3: _currentCoords3,
        dist34: _currentRadius3,
        accuracy: 10,
        ells: defaultEllipsoid()));
  }

  _showOutput(List<Intersect> output) {
    if (output == null) {
      _currentIntersections = [];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      return;
    }

    _currentIntersections = output;

    _currentMapPoints = [
      GCWMapPoint(
        point: _currentCoords1,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint1'),
        coordinateFormat: _currentCoordsFormat1,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(
            radius: _currentRadius1,
            color: HSLColor.fromColor(COLOR_MAP_CIRCLE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_CIRCLE).lightness - 0.3)
                .toColor()),
      ),
      GCWMapPoint(
        point: _currentCoords2,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint2'),
        coordinateFormat: _currentCoordsFormat2,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(radius: _currentRadius2),
      ),
      GCWMapPoint(
        point: _currentCoords3,
        markerText: i18n(context, 'coords_intersectcircles_centerpoint3'),
        coordinateFormat: _currentCoordsFormat3,
        circleColorSameAsPointColor: false,
        circle: GCWMapCircle(
            radius: _currentRadius3,
            color: HSLColor.fromColor(COLOR_MAP_CIRCLE)
                .withLightness(HSLColor.fromColor(COLOR_MAP_CIRCLE).lightness + 0.2)
                .toColor()),
      )
    ];

    if (_currentIntersections == null || _currentIntersections.isEmpty) {
      _currentOutput = [i18n(context, "coords_intersect_nointersection")];
      _currentCopyableOutput = _currentOutput;
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
      return '${formatCoordOutput(intersection.coords, _currentOutputFormat, defaultEllipsoid())} '
          '(${i18n(context, "coords_intersectthreecircles_accuracy")}: '
          '${doubleFormat.format(_currentOutputUnit.fromMeter(intersection.accuracy))} ${_currentOutputUnit.symbol})';
    }).toList();

    _currentCopyableOutput = _currentIntersections.map((intersection) {
      return formatCoordOutput(intersection.coords, _currentOutputFormat, defaultEllipsoid());
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
