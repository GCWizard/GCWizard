import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_prefix_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';

class GCWUnitsValue<T extends Unit> {
  final T value;
  final UnitPrefix prefix;

  GCWUnitsValue(this.value, this.prefix);
}

class GCWUnits<T extends Unit> extends StatefulWidget {
  final UnitCategory<T> unitCategory;
  final void Function(GCWUnitsValue<T>) onChanged;
  final bool onlyShowUnitSymbols;
  final bool onlyShowPrefixSymbols;
  final GCWUnitsValue? value;

  const GCWUnits(
      {Key? key,
      required this.unitCategory,
      required this.onChanged,
      this.onlyShowUnitSymbols = false,
      this.onlyShowPrefixSymbols = true,
      this.value})
      : super(key: key);

  @override
  _GCWUnitsState createState() => _GCWUnitsState<T>();
}

class _GCWUnitsState<T extends Unit> extends State<GCWUnits> {
  late UnitPrefix _currentPrefix;
  late T _currentUnit;

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _currentPrefix = widget.value!.prefix;
      _currentUnit = widget.value!.value as T;
    } else {
      _currentPrefix = UNITPREFIX_NONE;
      _currentUnit = widget.unitCategory.defaultUnit as T;
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            widget.unitCategory.usesPrefixes
                ? Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                      child: GCWUnitPrefixDropDown(
                        onlyShowSymbols: widget.onlyShowPrefixSymbols,
                        value: _currentPrefix,
                        onChanged: (value) {
                          setState(() {
                            _currentPrefix = value;
                            _emitOnChange();
                          });
                        },
                      ),
                    ))
                : Container(),
            Expanded(
                flex: widget.unitCategory.usesPrefixes ? 2 : 1,
                child: GCWUnitDropDown<T>(
                  value: _currentUnit,
                  unitList: widget.unitCategory.units as List<T>,
                  onlyShowSymbols: widget.onlyShowUnitSymbols,
                  onChanged: (T value) {
                    setState(() {
                      _currentUnit = value;
                      _emitOnChange();
                    });
                  },
                ))
          ],
        ),
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(GCWUnitsValue<T>(_currentUnit, _currentPrefix));
  }
}
