part of 'package:gc_wizard/common_widgets/units/gcw_units.dart';

class _GCWUnitPrefixDropDown extends StatefulWidget {
  final Function onChanged;
  final UnitPrefix value;
  final bool onlyShowSymbols;

  const _GCWUnitPrefixDropDown({Key key, this.onChanged, this.value, this.onlyShowSymbols}) : super(key: key);

  @override
  _GCWUnitPrefixDropDownState createState() => _GCWUnitPrefixDropDownState();
}

class _GCWUnitPrefixDropDownState extends State<_GCWUnitPrefixDropDown> {
  var _currentPrefix;

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) _currentPrefix = widget.value;

    return GCWDropDown(
        value: _currentPrefix,
        items: unitPrefixes.map((prefix) {
          return GCWDropDownMenuItem(
            value: prefix,
            child: prefix.key == null ? '' : i18n(context, prefix.key) + ' (${prefix.symbol})',
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _currentPrefix = value;
            widget.onChanged(_currentPrefix);
          });
        },
        selectedItemBuilder: (context) {
          return unitPrefixes.map((prefix) {
            return Align(
              child: GCWText(
                  text: widget.onlyShowSymbols
                      ? prefix.symbol ?? ''
                      : ((i18n(context, prefix.key) ?? '') + (prefix.symbol == null ? '' : ' (${prefix.symbol})'))),
              alignment: Alignment.centerLeft,
            );
          }).toList();
        });
  }
}
