part of 'package:gc_wizard/common_widgets/units/gcw_units.dart';

class _GCWUnitPrefixDropDown extends StatefulWidget {
  final void Function(UnitPrefix) onChanged;
  final UnitPrefix value;
  final bool onlyShowSymbols;

  const _GCWUnitPrefixDropDown({Key? key, required this.onChanged, required this.value, required this.onlyShowSymbols})
      : super(key: key);

  @override
  _GCWUnitPrefixDropDownState createState() => _GCWUnitPrefixDropDownState();
}

class _GCWUnitPrefixDropDownState extends State<_GCWUnitPrefixDropDown> {
  late UnitPrefix _currentPrefix;

  @override
  Widget build(BuildContext context) {
    _currentPrefix = widget.value;

    return GCWDropDown<UnitPrefix>(
        value: _currentPrefix,
        items: unitPrefixes.map((prefix) {
          return GCWDropDownMenuItem(
            value: prefix,
            child: i18n(context, prefix.key) + ' (${prefix.symbol})',
          );
        }).toList(),
        onChanged: (UnitPrefix value) {
          setState(() {
            _currentPrefix = value;
            widget.onChanged(_currentPrefix);
          });
        },
        selectedItemBuilder: (context) {
          return unitPrefixes.map((prefix) {
            return Align(
              alignment: Alignment.centerLeft,
              child: GCWText(
                  text: widget.onlyShowSymbols
                      ? prefix.symbol
                      : (i18n(context, prefix.key, ifTranslationNotExists: '')) + ' (${prefix.symbol})'),
            );
          }).toList();
        });
  }
}
