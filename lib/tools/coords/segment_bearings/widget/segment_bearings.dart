import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

class SegmentBearings extends StatefulWidget {
  const SegmentBearings({Key? key}) : super(key: key);

  @override
  _SegmentBearingsState createState() => _SegmentBearingsState();
}

class _SegmentBearingsState extends State<SegmentBearings> {
  var _currentCoordsStart = defaultBaseCoordinate;
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;

  var _currentInput1Mode = GCWSwitchPosition.left;
  var _currentInput2Mode = GCWSwitchPosition.left;
  var _currentBearing1 = 0.0;
  var _currentBearing2 = 0.0;

  var _currentSegmentCount = 2;
  var _currentDistance = 1000.0;

  var _currentMapPoints = <GCWMapPoint>[];
  var _currentMapPolylines = <GCWMapPolyline>[];

  var _currentOutputFormat = defaultCoordinateFormat;

  List<String> _currentOutputs = [];
  Widget _currentBearingOutput = Container();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_segmentbearings_start'),
          coordsFormat: _currentCoordsStart.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsStart = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_segmentbearings_bearing1'),
        ),
        GCWTwoOptionsSwitch(
          value: _currentInput1Mode,
          leftValue: i18n(context, 'coords_segmentbearings_bearing_mode_bearing'),
          rightValue: i18n(context, 'coords_segmentbearings_bearing_mode_coordinate'),
          onChanged: (value) {
            setState(() {
              _currentInput1Mode = value;
            });
          },
        ),
        _currentInput1Mode == GCWSwitchPosition.left
            ? GCWDoubleSpinner(
                value: _currentBearing1,
                onChanged: (value) {
                  setState(() {
                    _currentBearing1 = value;
                  });
                },
              )
            : GCWCoords(
                notitle: true,
                coordsFormat: _currentCoords1.format,
                onChanged: (ret) {
                  setState(() {
                    if (ret != null) {
                      _currentCoords1 = ret;
                    }
                  });
                },
              ),
        GCWTextDivider(
          text: i18n(context, 'coords_segmentbearings_bearing2'),
        ),
        GCWTwoOptionsSwitch(
          value: _currentInput2Mode,
          leftValue: i18n(context, 'coords_segmentbearings_bearing_mode_bearing'),
          rightValue: i18n(context, 'coords_segmentbearings_bearing_mode_coordinate'),
          onChanged: (value) {
            setState(() {
              _currentInput2Mode = value;
            });
          },
        ),
        _currentInput2Mode == GCWSwitchPosition.left
            ? GCWDoubleSpinner(
                value: _currentBearing2,
                onChanged: (value) {
                  setState(() {
                    _currentBearing2 = value;
                  });
                },
              )
            : GCWCoords(
                notitle: true,
                coordsFormat: _currentCoords2.format,
                onChanged: (ret) {
                  setState(() {
                    if (ret != null) {
                      _currentCoords2 = ret;
                    }
                  });
                },
              ),
        GCWTextDivider(text: i18n(context, 'coords_segmentbearings_numbersegments')),
        GCWIntegerSpinner(
          value: _currentSegmentCount,
          min: 2,
          overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
          onChanged: (value) {
            setState(() {
              _currentSegmentCount = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'coords_segmentbearings_distance')),
        GCWDistance(
          value: _currentDistance,
          onChanged: (value) {
            setState(() {
              _currentDistance = value;
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
        _currentBearingOutput,
        GCWCoordsOutput(
          outputs: _currentOutputs,
          points: _currentMapPoints,
          polylines: _currentMapPolylines,
        ),
      ],
    );
  }

  void _calculateOutput() {
    var ells = defaultEllipsoid;

    var startMapPoint = GCWMapPoint(
        point: _currentCoordsStart.toLatLng()!,
        markerText: i18n(context, 'coords_segmentbearings_start'),
        coordinateFormat: _currentCoordsStart.format);

    LatLng endPoint1;
    double bearing1;
    CoordinateFormat format1;
    if (_currentInput1Mode == GCWSwitchPosition.left) {
      endPoint1 = projection(_currentCoordsStart.toLatLng()!, _currentBearing1, _currentDistance, ells);
      bearing1 = _currentBearing1;
      format1 = defaultCoordinateFormat;
    } else {
      endPoint1 = _currentCoords1.toLatLng()!;
      bearing1 = distanceBearing(_currentCoordsStart.toLatLng()!, _currentCoords1.toLatLng()!, ells).bearingAToB;
      format1 = _currentCoords1.format;
    }

    var endMapPoint1 = GCWMapPoint(
        point: endPoint1, markerText: i18n(context, 'coords_segmentbearings_end1'), coordinateFormat: format1);

    LatLng endPoint2;
    double bearing2;
    CoordinateFormat format2;
    if (_currentInput2Mode == GCWSwitchPosition.left) {
      endPoint2 = projection(_currentCoordsStart.toLatLng()!, _currentBearing2, _currentDistance, ells);
      bearing2 = _currentBearing2;
      format2 = defaultCoordinateFormat;
    } else {
      endPoint2 = _currentCoords2.toLatLng()!;
      bearing2 = distanceBearing(_currentCoordsStart.toLatLng()!, _currentCoords2.toLatLng()!, ells).bearingAToB;
      format2 = _currentCoords2.format;
    }

    var endMapPoint2 = GCWMapPoint(
        point: endPoint2, markerText: i18n(context, 'coords_segmentbearings_end2'), coordinateFormat: format2);

    var segments = segmentBearings(
        _currentCoordsStart.toLatLng()!, bearing1, bearing2, _currentDistance, _currentSegmentCount, ells);

    _currentMapPoints = [startMapPoint, endMapPoint1];
    _currentMapPolylines = [
      GCWMapPolyline(
          points: [startMapPoint, endMapPoint1],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness + 0.2)
              .toColor())
    ];

    segments.points.asMap().forEach((index, point) {
      var mapPoint = GCWMapPoint(
        point: point,
        markerText: i18n(context, 'coords_segmentbearings_end') + ' ' + (index + 1).toString(),
        coordinateFormat: _currentOutputFormat,
        color: COLOR_MAP_CALCULATEDPOINT,
      );
      _currentMapPoints.add(mapPoint);

      _currentMapPolylines.add(GCWMapPolyline(
          points: [startMapPoint, mapPoint],
          color: HSLColor.fromColor(COLOR_MAP_POLYLINE)
              .withLightness(HSLColor.fromColor(COLOR_MAP_POLYLINE).lightness - 0.3)
              .toColor()));
    });

    _currentMapPoints.add(endMapPoint2);
    _currentMapPolylines.add(GCWMapPolyline(points: [startMapPoint, endMapPoint2]));

    _currentOutputs = List<String>.from(segments.points.map((point) {
      return formatCoordOutput(point, _currentOutputFormat, defaultEllipsoid);
    }).toList());

    var bearingOutput = doubleFormat.format(segments.segmentAngle);
    _currentBearingOutput = GCWDefaultOutput(
      child: i18n(context, 'coords_segmentbearings_segmentangle') + ': ' + bearingOutput,
      copyText: bearingOutput,
    );
  }
}
