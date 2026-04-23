import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/widget/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/napoleon/logic/napoleon.dart';

class TriangleNapoleonPoints extends StatefulWidget {
  const TriangleNapoleonPoints({
    super.key,
  });

  @override
  _TriangleNapoleonPointsState createState() => _TriangleNapoleonPointsState();
}

class _TriangleNapoleonPointsState extends State<TriangleNapoleonPoints> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  Widget _currentOutput = GCWDefaultOutput();

  var _currentNapoleonPoint = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coorda'),
          coordsFormat: _currentCoords1.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords1 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coordb'),
          coordsFormat: _currentCoords2.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords2 = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: i18n(context, 'coords_centerthreepoints_coordc'),
          coordsFormat: _currentCoords3.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords3 = ret;
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
        GCWTwoOptionsSwitch(
          value: _currentNapoleonPoint,
          notitle: true,
          leftValue: i18n(context, 'coords_triangles_specialpoints_first'),
          rightValue: i18n(context, 'coords_triangles_specialpoints_second'),
          onChanged: (value) {
            setState(() {
              _currentNapoleonPoint = value;
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
    var triangle = EllipsoidTriangle(
        _currentCoords1.toLatLng()!,
        _currentCoords2.toLatLng()!,
        _currentCoords3.toLatLng()!,
        defaultEllipsoid
    );

    if (!triangle.isValid) {
      _currentOutput = GCWDefaultOutput(
        child: i18n(context, 'coords_triangles_invalidtriangle'),
      );
      return;
    }

    var _specialPoints = calculateEllipsoidTriangleNapoleonPoints(triangle, defaultEllipsoid);
    var specialPoint = _specialPoints.first;
    if (_currentNapoleonPoint == GCWSwitchPosition.right) {
      specialPoint = _specialPoints.last;
    }

    _currentOutput = ellipsoidTriangleSpecialPointOutput(context, _currentOutputFormat, triangle, specialPoint);
  }
}
