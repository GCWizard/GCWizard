import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';

class GCWUnitPrefixDropDown extends StatefulWidget {
  final void Function(UnitPrefix) onChanged;
  final UnitPrefix value;
  final bool onlyShowSymbols;

  const GCWUnitPrefixDropDown({Key? key, required this.onChanged, required this.value, required this.onlyShowSymbols})
      : super(key: key);

  @override
  _GCWUnitPrefixDropDownState createState() => _GCWUnitPrefixDropDownState();
}

class _GCWUnitPrefixDropDownState extends State<GCWUnitPrefixDropDown> {
  late UnitPrefix _currentPrefix;

  @override
  Widget build(BuildContext context) {
    _currentPrefix = widget.value;

    return GCWDropDown<UnitPrefix>(
        value: _currentPrefix,
        items: unitPrefixes.map((prefix) {
          return GCWDropDownMenuItem(
            value: prefix,
            child: _longText(prefix),
          );
        }).toList(),
        onChanged: (UnitPrefix value) {
          setState(() {
            _currentPrefix = value;
            widget.onChanged(_currentPrefix);
          });
        },
        selectedItemBuilder: (context) {
          return unitPrefixes.map((UnitPrefix prefix) {
            return Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.onlyShowSymbols ? prefix.symbol : _longText(prefix), style: gcwTextStyle()));
          }).toList();
        });
  }

  String _longText(UnitPrefix prefix) {
    var longText = i18n(context, prefix.key, ifTranslationNotExists: '') + ' (${prefix.symbol})';
    if (prefix == UNITPREFIX_NONE) {
      longText = i18n(context, 'common_unit_prefix_none');
    }

    return longText;
  }
}
