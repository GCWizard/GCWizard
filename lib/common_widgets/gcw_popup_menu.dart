import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class GCWPopupMenu extends StatefulWidget {
  final List<GCWPopupMenuItem> Function(BuildContext context) menuItemBuilder;
  final IconData iconData;
  final Widget customIcon;
  final double rotateDegrees;
  final IconButtonSize size;
  final Color iconColor;
  final Color backgroundColor;
  final bool isTextSelectionToolBarButton;
  final EdgeInsets textSelectionToolBarButtonPadding;
  final String textSelectionToolBarButtonLabel;

  final Function onBeforePressed;

  const GCWPopupMenu({
    Key key,
    this.menuItemBuilder,
    this.iconData,
    this.customIcon,
    this.rotateDegrees,
    this.size: IconButtonSize.NORMAL,
    this.iconColor,
    this.backgroundColor,
    this.onBeforePressed,
    this.isTextSelectionToolBarButton: false,
    this.textSelectionToolBarButtonPadding,
    this.textSelectionToolBarButtonLabel,
  }) : super(key: key);

  @override
  GCWPopupMenuState createState() => GCWPopupMenuState();
}

class GCWPopupMenuState extends State<GCWPopupMenu> {
  List<PopupMenuEntry<dynamic>> _menuItems;
  var _menuAction;

  RelativeRect _menuPosition;

  _afterLayout() {
    //copied from the native PopupMenu code
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    _menuPosition = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height - 8.0), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTextSelectionToolBarButton) {
      return TextSelectionToolbarTextButton(
        padding: widget.textSelectionToolBarButtonPadding,
        onPressed: _onPressed,
        child: Text(widget.textSelectionToolBarButtonLabel),
      );
    }

    return GCWIconButton(
        icon: widget.iconData,
        customIcon: widget.customIcon,
        rotateDegrees: widget.rotateDegrees,
        size: widget.size,
        iconColor: widget.iconColor,
        backgroundColor: widget.backgroundColor,
        onPressed: _onPressed);
  }

  _onPressed() {
    if (widget.onBeforePressed != null) widget.onBeforePressed();

    var items = widget.menuItemBuilder(context).asMap().map((index, GCWPopupMenuItem item) {
      return MapEntry<PopupMenuEntry<dynamic>, Function>(
          item.isDivider ? PopupMenuDivider() : PopupMenuItem(child: item.child, value: index), item.action);
    });

    _afterLayout();

    _menuItems = items.keys.toList();
    _menuAction = items.values.toList();

    showMenu(
      context: context,
      position: _menuPosition,
      items: _menuItems,
      elevation: 8.0,
      color: themeColors().accent(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
      ),
    ).then((itemSelected) {
      if (itemSelected == null || itemSelected < 0 || itemSelected >= _menuAction.length) return;

      if (_menuAction[itemSelected] == null) return;

      _menuAction[itemSelected](itemSelected);
    });
  }
}

class GCWPopupMenuItem {
  final Widget child;
  final Function action;
  final Function onLongPress;
  final bool isDivider;

  GCWPopupMenuItem({this.child, this.action, this.onLongPress, this.isDivider: false});
}

iconedGCWPopupMenuItem(BuildContext context, IconData icon, String title,
    {double rotateDegrees: 0.0, Function onLongPress}) {
  var color = themeColors().dialogText();

  return Row(
    children: [
      GestureDetector(
        child: Container(
          child: Transform.rotate(
            angle: degreesToRadian(rotateDegrees),
            child: Icon(icon, color: color),
          ),
          padding: EdgeInsets.only(right: 10),
        ),
        onLongPress: onLongPress,
      ),
      Text(i18n(context, title) ?? title, style: TextStyle(color: color))
    ],
  );
}
