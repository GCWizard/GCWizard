import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';

part 'package:gc_wizard/common_widgets/units/gcw_unit_prefix_dropdown.dart';

class GCWUnits extends StatefulWidget {
  final UnitCategory unitCategory;
  final Function onChanged;
  final bool onlyShowUnitSymbols;
  final bool onlyShowPrefixSymbols;
  final Map<String, dynamic> value;

  GCWUnits(
      {Key key,
      this.unitCategory,
      this.onChanged,
      this.onlyShowUnitSymbols: false,
      this.onlyShowPrefixSymbols: true,
      this.value})
      : super(key: key);

  @override
  _GCWUnitsState createState() => _GCWUnitsState();
}

class _GCWUnitsState extends State<GCWUnits> {
  UnitPrefix _currentPrefix;
  Unit _currentUnit;

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _currentPrefix = widget.value['prefix'];
      _currentUnit = widget.value['unit'];
    } else {
      _currentPrefix = UNITPREFIX_NONE;
      _currentUnit = widget.unitCategory.defaultUnit;
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            widget.unitCategory.usesPrefixes
                ? Expanded(
                    child: Container(
                      child: _GCWUnitPrefixDropDown(
                        onlyShowSymbols: widget.onlyShowPrefixSymbols,
                        value: _currentPrefix,
                        onChanged: (value) {
                          setState(() {
                            _currentPrefix = value;
                            _emitOnChange();
                          });
                        },
                      ),
                      padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                    ),
                    flex: 1)
                : Container(),
            Expanded(
                child: GCWUnitDropDown(
                  value: _currentUnit,
                  unitList: widget.unitCategory.units,
                  onlyShowSymbols: widget.onlyShowUnitSymbols,
                  onChanged: (value) {
                    setState(() {
                      _currentUnit = value;
                      _emitOnChange();
                    });
                  },
                ),
                flex: widget.unitCategory.usesPrefixes ? 2 : 1)
          ],
        ),
      ],
    );
  }

  _emitOnChange() {
    widget.onChanged({'prefix': _currentPrefix, 'unit': _currentUnit});
  }
}
