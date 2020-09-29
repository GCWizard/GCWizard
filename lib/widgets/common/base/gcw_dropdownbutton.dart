import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class GCWDropDownButton extends StatefulWidget {
  final Function onChanged;
  final List<GCWDropDownMenuItem>items;
  final value;
  final DropdownButtonBuilder selectedItemBuilder;

  const GCWDropDownButton({
    Key key,
    this.value,
    this.items,
    this.onChanged,
    this.selectedItemBuilder
  }) : super(key: key);

  @override
  _GCWDropDownButtonState createState() => _GCWDropDownButtonState();
}

class _GCWDropDownButtonState extends State<GCWDropDownButton> {
  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      height: 39,
      margin: EdgeInsets.symmetric(vertical: DEFAULT_MARGIN),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(roundedBorderRadius),
        border: Border.all(
          color: colors.accent(), style: BorderStyle.solid, width: 1.0
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: colors.accent(),
          ),
          value: widget.value ?? widget.items[0].value,
          items: widget.items.map((item) {
            return DropdownMenuItem(
              value: item.value,
              child: item.child is Widget
                ? item.child
                : _buildMenuItemChild(item)
            );
          }).toList(),
          onChanged: widget.onChanged,
          style: TextStyle(fontSize: defaultFontSize()),
          selectedItemBuilder: widget.selectedItemBuilder ?? (context) {
            return widget.items.map((item) {
              return Align(
                child: item.child is Widget
                  ? item.child
                  : Text(
                      item.child.toString(),
                      style: gcwTextStyle(),
                    ),
                alignment: Alignment.centerLeft,
              );
            }).toList();
          },
        )
      )
    );
  }
}

//Note: No GCWText, since GCWText contains SelectableText which suppress clicks,
// and therefore generate non-selectable dropdown items (09/2020)
_buildMenuItemChild(GCWDropDownMenuItem item) {
  if (item.subtitle == null) {
    return item.child is Widget
      ? item.child
      : Text(
          item.child.toString(),
          style: item.style ?? gcwTextStyle(),
        );
  } else {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.child.toString(),
            style: item.style ?? gcwTextStyle(),
          ),
          Container(
            child: Text(
              item.subtitle.toString(),
              style: gcwDescriptionTextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            padding: EdgeInsets.only(left: 10)
          ),
        ]
      ),
      padding: EdgeInsets.only(bottom: 10),
    );
  }
}

class GCWDropDownMenuItem {
  final dynamic value;
  final dynamic child;
  final dynamic subtitle;
  final TextStyle style;

  const GCWDropDownMenuItem({
    this.value,
    this.child,
    this.subtitle,
    this.style
  });
}
