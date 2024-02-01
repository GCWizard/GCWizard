import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class CoordinateAveraging extends StatefulWidget {
  const CoordinateAveraging({Key? key}) : super(key: key);

  @override
  _CoordinateAveragingState createState() => _CoordinateAveragingState();
}

class _CoordinateAveragingState extends State<CoordinateAveraging> {
  bool? _currentLocationPermissionGranted;
  StreamSubscription<LocationData>? _locationSubscription;
  final Location _currentLocation = Location();

  final Length _DEFAULT_LENGTH_UNIT = defaultLengthUnit;

  var _isMeasuring = false;

  late List<_AveragedLocation> _averagedLocations;
  late List<_MeasuredLocation> _measuredValues;
  late double averageAccuracy;
  late double weightedLatSum;
  late double weightedLonSum;
  late double invertedAccuracySum;
  late double distanceFromAverageCoordsSum;

  @override
  void initState() {
    super.initState();

    _clearMeasurements();
  }

  @override
  void dispose() {
    _cancelLocationSubscription();

    super.dispose();
  }

  void _clearMeasurements() {
    _averagedLocations = [];
    _measuredValues = [];

    averageAccuracy = 0.0;
    weightedLatSum = 0.0;
    weightedLonSum = 0.0;
    invertedAccuracySum = 0.0;
    distanceFromAverageCoordsSum = 0.0;
  }

  void _cancelLocationSubscription() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
      _locationSubscription = null;

      _isMeasuring = false;
    }
  }

  String _formatLength(double value) {
    return NumberFormat('0.00').format(_DEFAULT_LENGTH_UNIT.fromMeter(value)) + ' ' + _DEFAULT_LENGTH_UNIT.symbol;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWButton(
          text: _isMeasuring ? i18n(context, 'coords_averaging_stop') : i18n(context, 'coords_averaging_start'),
          onPressed: () {
            setState(() {
              if (_currentLocationPermissionGranted == null) {
                checkLocationPermission(_currentLocation).then((value) {
                  _currentLocationPermissionGranted = value;
                  _toggleLocationListening();
                });
              } else {
                _toggleLocationListening();
              }
            });
          },
        ),
        GCWDefaultOutput(
          trailing: _averagedLocations.isNotEmpty
              ? GCWIconButton(
                  icon: Icons.my_location,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    var mapPoints = _measuredValues.map((measured) {
                      return GCWMapPoint(
                          point: measured.coord,
                          color: COLOR_MAP_POINT,
                          isEditable: false,
                          isVisible: true,
                          markerText: i18n(context, 'coords_averaging_measurepoint'),
                          circle: GCWMapCircle(
                              centerPoint: measured.coord, radius: measured.accuracy, color: COLOR_MAP_POINT));
                    }).toList();

                    mapPoints.add(GCWMapPoint(
                        point: _averagedLocations.first.coord,
                        color: COLOR_MAP_CALCULATEDPOINT,
                        isEditable: false,
                        isVisible: true,
                        markerText: i18n(context, 'coords_averaging_averaged'),
                        circle: GCWMapCircle(
                            centerPoint: _averagedLocations.first.coord,
                            radius: _averagedLocations.first.accuracy,
                            color: COLOR_MAP_CALCULATEDPOINT)));

                    openInMap(context, mapPoints);
                  })
              : Container(),
          child: GCWColumnedMultilineOutput(
            data: [
                  <Object?>[
                    null,
                    i18n(context, 'coords_averaging_averagedcoordinate', parameters: [_averagedLocations.length]),
                    i18n(context, 'coords_averaging_calculatedaccuracy')
                  ]
                ] +
                _averagedLocations
                    .asMap()
                    .map((index, location) {
                      var coord = formatCoordOutput(location.coord, defaultCoordinateFormat, defaultEllipsoid);
                      var accuracy = _formatLength(location.accuracy);

                      return MapEntry(index, [index + 1, coord, accuracy]);
                    })
                    .values
                    .toList()
                    .reversed
                    .toList(),
            flexValues: const [1, 6, 4],
            copyColumn: 1,
            hasHeader: true,
          ),
        ),
      ],
    );
  }

  void _toggleLocationListening() {
    if (_currentLocationPermissionGranted == false) {
      showSnackBar(i18n(context, 'coords_common_location_permissiondenied'), context);
      return;
    }

    if (_locationSubscription == null) {
      _locationSubscription = _currentLocation.onLocationChanged.handleError((error) {
        _cancelLocationSubscription();
      }).listen((LocationData currentLocation) {
        setState(() {
          _addAveragedLocation(currentLocation);
        });
      });

      _locationSubscription!.pause();
    }

    setState(() {
      if (_locationSubscription!.isPaused) {
        _clearMeasurements();
        _isMeasuring = true;
        _locationSubscription!.resume();
      } else {
        _cancelLocationSubscription();
      }
    });
  }

  /*
   * Ported from:
   * https://github.com/davidvavra/GPS-Averaging/blob/master/app/src/main/java/org/destil/gpsaveraging/measure/Measurements.java
   * *
   * Copyright 2015 David Vávra
   *
   * Licensed under the Apache License, Version 2.0 (the "License");
   * you may not use this file except in compliance with the License.
   * You may obtain a copy of the License at
   *
   *     http://www.apache.org/licenses/LICENSE-2.0
   *
   * Unless required by applicable law or agreed to in writing, software
   * distributed under the License is distributed on an "AS IS" BASIS,
   * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   * See the License for the specific language governing permissions and
   * limitations under the License.
   */
  //TODO Extract logic from widget
  void _addAveragedLocation(LocationData location) {
    if (location.accuracy == null || location.latitude == null || location.longitude == null) return;

    _measuredValues.add(_MeasuredLocation(LatLng(location.latitude!, location.longitude!), location.accuracy!));

    final double invertedAccuracy = 1 / (location.accuracy! == 0 ? 1 : location.accuracy!);
    weightedLatSum += location.latitude! * invertedAccuracy;
    weightedLonSum += location.longitude! * invertedAccuracy;
    invertedAccuracySum += invertedAccuracy;

    // calculating average coordinates (weighted by accuracy) and altitude
    var averagedCoord = LatLng(weightedLatSum / invertedAccuracySum, weightedLonSum / invertedAccuracySum);

    // calculating accuracy improved by averaging
    double distance =
        distanceBearing(LatLng(location.latitude!, location.longitude!), averagedCoord, defaultEllipsoid).distance;
    if (distance == 0) {
      distance = (location.accuracy! == 0 ? 2 : location.accuracy!);
    }

    distanceFromAverageCoordsSum += distance;
    averageAccuracy = distanceFromAverageCoordsSum / (_averagedLocations.length + 1);

    _averagedLocations.add(_AveragedLocation(averagedCoord, averageAccuracy));
  }
}

class _AveragedLocation {
  LatLng coord;
  double accuracy;

  _AveragedLocation(this.coord, this.accuracy);
}

class _MeasuredLocation {
  LatLng coord;
  double accuracy;

  _MeasuredLocation(this.coord, this.accuracy);
}
