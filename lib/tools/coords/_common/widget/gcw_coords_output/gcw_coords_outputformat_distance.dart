import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_formatselector.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';

class GCWCoordsOutputFormatDistanceValue {
  final CoordinateFormat format;
  final Length lengthUnit;

  GCWCoordsOutputFormatDistanceValue(this.format, this.lengthUnit);
}

class GCWCoordsOutputFormatDistance extends StatefulWidget {
  final CoordinateFormat coordFormat;
  final void Function(GCWCoordsOutputFormatDistanceValue) onChanged;

  const GCWCoordsOutputFormatDistance({Key? key, required this.coordFormat, required this.onChanged}) : super(key: key);

  @override
  _GCWCoordsOutputFormatDistanceState createState() => _GCWCoordsOutputFormatDistanceState();
}

class _GCWCoordsOutputFormatDistanceState extends State<GCWCoordsOutputFormatDistance> {
  var _currentCoordFormat = defaultCoordinateFormat;
  Length _currentLengthUnit = defaultLengthUnit;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTextDivider(text: i18n(context, 'coords_output_format')),
      Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWCoordsFormatSelector(
                    format: widget.coordFormat,
                    input: false,
                    onChanged: (value) {
                      setState(() {
                        _currentCoordFormat = value;
                        _setCurrentValueAndEmitOnChange();
                      });
                    },
                  ))),
          Expanded(
            flex: 1,
            child: GCWUnitDropDown<Length>(
                unitList: allLengths(),
                value: _currentLengthUnit,
                onChanged: (Length value) {
                  setState(() {
                    _currentLengthUnit = value;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          )
        ],
      )
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(GCWCoordsOutputFormatDistanceValue(_currentCoordFormat, _currentLengthUnit));
  }
}
