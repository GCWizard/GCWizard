import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_formatselector.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:latlong2/latlong.dart';

class RandomizerCoordinates extends StatefulWidget {
  const RandomizerCoordinates({Key? key}) : super(key: key);

  @override
  _RandomizerCoordinatesState createState() => _RandomizerCoordinatesState();
}

class _RandomizerCoordinatesState extends State<RandomizerCoordinates> {
  var _currentCount = 1;

  var _currentMode = GCWSwitchPosition.left;

  var _currentCoordsNW = buildCoordinate(defaultCoordinateFormat, const LatLng(90, -179.99999), defaultEllipsoid);
  var _currentCoordsSE = buildCoordinate(defaultCoordinateFormat, const LatLng(-90, 179.99999), defaultEllipsoid);

  var _currentCoordsCenter = defaultBaseCoordinate;
  var _currentDistance = 0.0;
  final Length _currentInputLength = defaultLengthUnit;

  CoordinateFormat _currentOutputFormat = defaultCoordinateFormat;
  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: 1000,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'randomizer_coords_inbounds'),
          rightValue: i18n(context, 'randomizer_coords_aroundpoint'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
          ? Column(
              children: [
                GCWCoords(
                  title: i18n(context, 'randomizer_coords_nwcorner'),
                  coordinates: _currentCoordsNW.toLatLng(),
                  coordsFormat: _currentCoordsNW.format,
                  onChanged: (ret) {
                    setState(() {
                      if (ret != null) {
                        _currentCoordsNW = ret;
                      }
                    });
                  },
                ),
                GCWCoords(
                  title: i18n(context, 'randomizer_coords_secorner'),
                  coordinates: _currentCoordsSE.toLatLng(),
                  coordsFormat: _currentCoordsSE.format,
                  onChanged: (ret) {
                    setState(() {
                      if (ret != null) {
                        _currentCoordsSE = ret;
                      }
                    });
                  },
                ),
              ],
            )
          : Column(
              children: [
                GCWCoords(
                  title: i18n(context, 'coords_common_centerpoint'),
                  coordsFormat: _currentCoordsCenter.format,
                  onChanged: (ret) {
                    setState(() {
                      if (ret != null) {
                        _currentCoordsCenter = ret;
                      }
                    });
                  },
                ),
                GCWDistance(
                  value: _currentDistance,
                  unit: _currentInputLength,
                  onChanged: (value) {
                    setState(() {
                      _currentDistance = value;
                    });
                  },
                ),
              ],
            ),
        GCWCoordsFormatSelector(
          format: _currentOutputFormat,
          input: false,
          onChanged: (newValue) {
            setState(() {
              _currentOutputFormat = newValue;
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
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {
    var out = <LatLng>[];

    if (_currentMode == GCWSwitchPosition.left) {
      for (int i = 0; i < _currentCount; i++) {
        out.add(randomCoordinateInsideBounds(_currentCoordsNW.toLatLng()!, _currentCoordsSE.toLatLng()!));
      }
    } else {
      for (int i = 0; i < _currentCount; i++) {
        out.add(randomCoordinateAroundPoint(_currentCoordsCenter.toLatLng()!, _currentDistance, defaultEllipsoid));
      }
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var widgets = out.map((LatLng coord) {
      var formattedCoordinate = formatCoordOutput(coord, _currentOutputFormat, defaultEllipsoid);
      var copyformattedCoordinate = formatCoordOutput(coord, _currentOutputFormat, defaultEllipsoid, false);

      return GCWOutputText(text: formattedCoordinate, copyText: copyformattedCoordinate);
    }).toList();

    var mapPoints = out.map((LatLng coord) {
      return GCWMapPoint(
          point: coord,
          coordinateFormat: _currentOutputFormat);
    }).toList();

    _currentOutput = GCWCoordsOutput(
      mapButtonTop: true,
      outputs: widgets,
      points: mapPoints,
    );
  }
}
