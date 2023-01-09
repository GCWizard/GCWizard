import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/units/length.dart';
import 'package:gc_wizard/logic/common/units/unit.dart';
import 'package:gc_wizard/logic/tools/coords/distance_and_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_button.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/coords/utils/user_location.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:prefs/prefs.dart';

class CoordinateAveraging extends StatefulWidget {
  @override
  CoordinateAveragingState createState() => CoordinateAveragingState();
}

class CoordinateAveragingState extends State<CoordinateAveraging> {
  var _currentLocationPermissionGranted;
  StreamSubscription<LocationData> _locationSubscription;
  Location _currentLocation = Location();

  Length _DEFAULT_LENGTH_UNIT;

  var _isMeasuring = false;

  List<_AveragedLocation> _averagedLocations;
  double averageAccuracy;
  double weightedLatSum;
  double weightedLonSum;
  double invertedAccuracySum;
  double distanceFromAverageCoordsSum;

  @override
  void initState() {
    super.initState();

    _DEFAULT_LENGTH_UNIT = getUnitBySymbol(allLengths(), Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT));
    _clearMeasurements();
  }

  @override
  void dispose() {
    _cancelLocationSubscription();

    super.dispose();
  }

  _clearMeasurements() {
    _averagedLocations = [];

    averageAccuracy = 0.0;
    weightedLatSum = 0.0;
    weightedLonSum = 0.0;
    invertedAccuracySum = 0.0;
    distanceFromAverageCoordsSum = 0.0;
  }

  _cancelLocationSubscription() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
      _locationSubscription = null;

      _isMeasuring = false;
    }
  }

  _formatLength(double value) {
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
            child: GCWColumnedMultilineOutput(
              data: [
                    <dynamic>[
                      null,
                      i18n(context, 'coords_averaging_averagedcoordinate', parameters: [_averagedLocations.length]),
                      i18n(context, 'coords_averaging_calculatedaccuracy')
                    ]
                  ] +
                  _averagedLocations
                      .asMap()
                      .map((index, location) {
                        var coord = formatCoordOutput(location.coord, defaultCoordFormat(), defaultEllipsoid());
                        var accuracy = _formatLength(location.accuracy);

                        return MapEntry(index, [index + 1, coord, accuracy]);
                      })
                      .values
                      .toList()
                      .reversed
                      .toList(),
              flexValues: [1, 6, 4],
              copyColumn: 1,
              hasHeader: true
            ),
        ),
      ],
    );
  }

  _toggleLocationListening() {
    if (_currentLocationPermissionGranted == false) {
      showToast(i18n(context, 'coords_common_location_permissiondenied'));
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

      _locationSubscription.pause();
    }

    setState(() {
      if (_locationSubscription.isPaused) {
        _clearMeasurements();
        _isMeasuring = true;
        _locationSubscription.resume();
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
  _addAveragedLocation(LocationData location) {
    final double invertedAccuracy = 1 / (location.accuracy == 0 ? 1 : location.accuracy);
    weightedLatSum += location.latitude * invertedAccuracy;
    weightedLonSum += location.longitude * invertedAccuracy;
    invertedAccuracySum += invertedAccuracy;

    // calculating average coordinates (weighted by accuracy) and altitude
    var averagedCoord = LatLng(weightedLatSum / invertedAccuracySum, weightedLonSum / invertedAccuracySum);

    // calculating accuracy improved by averaging
    double distance =
        distanceBearing(LatLng(location.latitude, location.longitude), averagedCoord, defaultEllipsoid()).distance;
    if (distance == 0) {
      distance = (location.accuracy == 0 ? 2 : location.accuracy);
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
