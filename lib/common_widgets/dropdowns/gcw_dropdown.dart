import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWDropDown<T> extends StatefulWidget {
  final void Function(T) onChanged;
  final List<GCWDropDownMenuItem<T>> items;
  final T value;
  final DropdownButtonBuilder? selectedItemBuilder;
  final String? title;
  final bool alternativeColor;

  const GCWDropDown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.selectedItemBuilder,
      this.title,
      this.alternativeColor = false})
      : super(key: key);

  @override
  _GCWDropDownState<T> createState() => _GCWDropDownState<T>();
}

class _GCWDropDownState<T> extends State<GCWDropDown<T>> {
  T? _currentValue;

  @override
  Widget build(BuildContext context) {
    _currentValue = widget.value;

    ThemeColors colors = themeColors();

    var textStyle = gcwTextStyle();
    if (widget.alternativeColor) textStyle = textStyle.copyWith(color: colors.dialogText());

    return Row(
      children: [
        if (widget.title != null && widget.title!.isNotEmpty)
          Expanded(
              flex: 1,
              child: GCWText(
                text: widget.title! + ':',
              )),
        Expanded(
            flex: 3,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                height: 39,
                margin: const EdgeInsets.symmetric(vertical: DEFAULT_MARGIN),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
                  border: Border.all(
                      color: widget.alternativeColor ? colors.dialogText() : colors.secondary(),
                      style: BorderStyle.solid,
                      width: 1.0),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<T?>(
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: widget.alternativeColor ? colors.dialogText() : colors.secondary(),
                  ),
                  value: _currentValue,// ?? widget.items[0].value,
                  items: widget.items.map((item) {
                    return DropdownMenuItem<T>(
                        value: item._internalValue, child: item.child is Widget ? item.child as Widget : _buildMenuItemChild<T>(item));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      widget.onChanged(value);
                    }
                  },
                  style: textStyle,
                  selectedItemBuilder: widget.selectedItemBuilder ??
                      (context) {
                        return widget.items.map((item) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: item.child is Widget
                                ? item.child as Widget
                                : Text(
                                    item.child.toString(),
                                    style: textStyle,
                                  ),
                          );
                        }).toList();
                      },
                ))))
      ],
    );
  }
}

//Note: No GCWText, since GCWText contains SelectableText which suppress clicks,
// and therefore generate non-selectable dropdown items (09/2020)
Widget _buildMenuItemChild<T>(GCWDropDownMenuItem<T> item) {
  if (item.subtitle == null || item.subtitle!.isEmpty) {
    return item.child is Widget
        ? item.child as Widget
        : Text(
            item.child.toString(),
            style: item.style ?? gcwTextStyle(),
          );
  } else {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          item.child.toString(),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: item.style ?? gcwTextStyle(),
        ),
        Container(
            padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
            child: Text(
              item.subtitle.toString(),
              style: gcwDescriptionTextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
      ]),
    );
  }
}

class GCWDropDownMenuItem<T> {
  final T value;
  final Object child;
  final String? subtitle;
  final TextStyle? style;

  late T? _internalValue;

  GCWDropDownMenuItem({required this.value, required this.child, this.subtitle, this.style}) {
    _internalValue = this.value;
  }
}
