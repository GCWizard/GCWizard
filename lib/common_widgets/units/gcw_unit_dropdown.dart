import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';

class GCWUnitDropDown<T extends Unit> extends StatefulWidget {
  final void Function(T) onChanged;
  final T value;
  final List<T>? unitList;
  final UnitCategory? unitCategory;
  final bool onlyShowSymbols;

  const GCWUnitDropDown(
      {Key? key, required this.onChanged, required this.value, this.unitList,
        this.onlyShowSymbols = true, this.unitCategory})
      : super(key: key);

  @override
  GCWUnitDropDownState<T> createState() => GCWUnitDropDownState<T>();
}

class GCWUnitDropDownState<T extends Unit> extends State<GCWUnitDropDown<T>> {
  late T _currentUnit;

  @override
  Widget build(BuildContext context) {
    List<T> _currentUnitList = (widget.unitList ?? widget.unitCategory?.units ?? <T>[]) as List<T>;

    return GCWDropDown<T>(
        value: widget.value,
        onChanged: (T newValue) {
          setState(() {
            _currentUnit = newValue;
            widget.onChanged(_currentUnit);
          });
        },
        items: _currentUnitList.map((unit) {
          return GCWDropDownMenuItem<T>(
              value: unit,
              child: widget.onlyShowSymbols
                  ? unit.symbol
                  : (i18n(context, unit.name) + ' (${unit.symbol})'));
        }).toList());
  }
}
