import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/antipodes/logic/antipodes.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:latlong2/latlong.dart';

class Antipodes extends StatefulWidget {
  const Antipodes({Key? key}) : super(key: key);

  @override
  _AntipodesState createState() => _AntipodesState();
}

class _AntipodesState extends State<Antipodes> {
  var _currentCoords = defaultBaseCoordinate;

  var _currentValues = <LatLng>[];
  var _currentMapPoints = <GCWMapPoint>[];

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = <String>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_antipodes_coorda'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords = ret;
              }
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
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: _currentMapPoints,
        ),
      ],
    );
  }

  void _calculateOutput() {
    _currentValues = [antipodes(_currentCoords.toLatLng()!)];

    _currentMapPoints = [
      GCWMapPoint(
          point: _currentCoords.toLatLng()!,
          markerText: i18n(context, 'coords_antipodes_coorda'),
          coordinateFormat: _currentCoords.format),
      GCWMapPoint(
          point: _currentValues[0],
          color: COLOR_MAP_CALCULATEDPOINT,
          markerText: i18n(context, 'coords_antipodes_coordb'),
          coordinateFormat: _currentOutputFormat),
    ];

    _currentOutput = _currentValues.map((LatLng coord) {
      return formatCoordOutput(coord, _currentOutputFormat, defaultEllipsoid);
    }).toList();
  }
}
