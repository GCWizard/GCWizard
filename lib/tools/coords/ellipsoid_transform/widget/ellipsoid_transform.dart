import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/tools/coords/ellipsoid_transform/logic/ellipsoid_transform.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class EllipsoidTransform extends StatefulWidget {
  const EllipsoidTransform({Key? key}) : super(key: key);

  @override
  _EllipsoidTransformState createState() => _EllipsoidTransformState();
}

class _EllipsoidTransformState extends State<EllipsoidTransform> {
  var _currentCoords = defaultBaseCoordinate;

  var _currentOutputFormat = defaultCoordinateFormat;
  List<String> _currentOutput = [];

  var _currentFromDate = transformableDates[0];
  var _currentToDate = transformableDates[1];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'coords_ellipsoidtransform_coord'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_ellipsoidtransform_fromellipsoiddate'),
        ),
        GCWDropDown<TransformableDate>(
          value: _currentFromDate,
          onChanged: (newValue) {
            setState(() {
              _currentFromDate = newValue;
            });
          },
          items: transformableDates.map((date) {
            return GCWDropDownMenuItem(
              value: date,
              child: date.name,
            );
          }).toList(),
        ),
        GCWTextDivider(
          text: i18n(context, 'coords_ellipsoidtransform_toellipsoiddate'),
        ),
        GCWDropDown<TransformableDate>(
          value: _currentToDate,
          onChanged: (newValue) {
            setState(() {
              _currentToDate = newValue;
            });
          },
          items: transformableDates.map((date) {
            return GCWDropDownMenuItem(
              value: date,
              child: date.name,
            );
          }).toList(),
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
              _calculateOutput(context);
            });
          },
        ),
        GCWCoordsOutput(
          outputs: _currentOutput,
          points: [
            GCWMapPoint(
              point: _currentCoords.toLatLng()!,
            ),
          ],
        ),
      ],
    );
  }

  void _calculateOutput(BuildContext context) {
    var newCoords = _currentCoords.toLatLng()!;

    if (_currentFromDate.transformationIndex != null) {
      newCoords = ellipsoidTransformLatLng(newCoords, _currentFromDate.transformationIndex!, false, false);
    }

    if (_currentToDate.transformationIndex != null) {
      newCoords = ellipsoidTransformLatLng(newCoords, _currentToDate.transformationIndex!, true, false);
    }

    _currentOutput = [formatCoordOutput(newCoords, _currentOutputFormat, _currentToDate.ellipsoid)];
  }
}
