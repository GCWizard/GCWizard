import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/area.dart';
import 'package:gc_wizard/utils/constants.dart';

class EllipsoidTriangleArea extends StatefulWidget {
  const EllipsoidTriangleArea({
    super.key,
  });

  @override
  _EllipsoidTriangleAreaState createState() => _EllipsoidTriangleAreaState();
}

class _EllipsoidTriangleAreaState extends State<EllipsoidTriangleArea> {
  var _currentCoords1 = defaultBaseCoordinate;
  var _currentCoords2 = defaultBaseCoordinate;
  var _currentCoords3 = defaultBaseCoordinate;

  Area _currentOutputUnit = AREA_SQUAREMETER;
  Widget _currentOutput = GCWDefaultOutput();

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
        GCWTextDivider(
          text: i18n(context, 'coords_triangles_area_outputunit'),
        ),
        GCWUnitDropDown<Area>(
          value: _currentOutputUnit,
          unitList: areas,
          onlyShowSymbols: false,
          onChanged: (value) {
            setState(() {
              _currentOutputUnit = value;
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

    var area = ellipsoidTriangleArea(triangle, defaultEllipsoid);

    _currentOutput = GCWDefaultOutput(
      child: doubleFormat.format(_currentOutputUnit.fromSquareMeter(area)) + ' ' + _currentOutputUnit.symbol,
      copyText: _currentOutputUnit.fromSquareMeter(area).toString(),
    );
  }
}
