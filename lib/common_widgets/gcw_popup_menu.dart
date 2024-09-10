import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class GCWPopupMenu extends StatefulWidget {
  final List<GCWPopupMenuItem> Function(BuildContext context) menuItemBuilder;
  final IconData? icon;
  final Widget? customIcon;
  final double? rotateDegrees;
  final IconButtonSize? size;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isTextSelectionToolBarButton;
  final EdgeInsets? textSelectionToolBarButtonPadding;
  final String? textSelectionToolBarButtonLabel;
  final bool? buttonNoBorder;

  final Function? onBeforePressed;

  const GCWPopupMenu({
    Key? key,
    required this.menuItemBuilder,
    this.icon,
    this.customIcon,
    this.rotateDegrees,
    this.size = IconButtonSize.NORMAL,
    this.iconColor,
    this.backgroundColor,
    this.onBeforePressed,
    this.isTextSelectionToolBarButton = false,
    this.textSelectionToolBarButtonPadding,
    this.textSelectionToolBarButtonLabel,
    this.buttonNoBorder,
  }) : super(key: key);

  @override
  _GCWPopupMenuState createState() => _GCWPopupMenuState();
}

class _GCWPopupMenuState extends State<GCWPopupMenu> {

  @override
  Widget build(BuildContext context) {
    if (widget.isTextSelectionToolBarButton) {
      return TextSelectionToolbarTextButton(
        padding: widget.textSelectionToolBarButtonPadding!,
        onPressed: _onPressed,
        child: Text(widget.textSelectionToolBarButtonLabel!),
      );
    }

    return GCWIconButton(
        icon: widget.icon,
        customIcon: widget.customIcon,
        rotateDegrees: widget.rotateDegrees,
        size: widget.size,
        iconColor: widget.iconColor,
        backgroundColor: widget.backgroundColor,
        noBorder: widget.buttonNoBorder,
        onPressed: _onPressed);
  }

  void _onPressed() {
    if (widget.onBeforePressed != null) widget.onBeforePressed!();

    onPopupMenuPressed(context, widget.menuItemBuilder);
  }
}

RelativeRect _afterPopupMenuLayout(BuildContext context) {
  //copied from the native PopupMenu code
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  var _menuPosition = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(0, button.size.height - 8.0), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  return _menuPosition;
}

void onPopupMenuPressed(BuildContext context, List<GCWPopupMenuItem> Function(BuildContext context) menuItemBuilder) {
  var items = menuItemBuilder(context).asMap().map((index, GCWPopupMenuItem item) {
    return MapEntry<PopupMenuEntry<int>, void Function(int)>(
        item.isDivider || item.child == null
            // MAL: 07/2024 Ignored warning; otherwise only one divider is possible
            // ignore: prefer_const_constructors
            ? PopupMenuDivider() as PopupMenuEntry<int>
            : PopupMenuItem(value: index, child: item.child),
        item.action);
  });

  var _menuPosition = _afterPopupMenuLayout(context);

  List<PopupMenuEntry<int>> _menuItems = items.keys.toList();
  List<void Function(int)>_menuAction = items.values.toList();

  showMenu<int>(
    context: context,
    position: _menuPosition,
    items: _menuItems,
    elevation: 8.0,
    color: themeColors().secondary(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS),
    ),
  ).then((int? itemSelected) {
    if (itemSelected == null || itemSelected < 0 || itemSelected >= _menuAction.length) return;

    _menuAction[itemSelected](itemSelected);
  });
}

class GCWPopupMenuItem {
  final Widget? child;
  final void Function(int) action;
  final void Function()? onLongPress;
  final bool isDivider;

  GCWPopupMenuItem({this.child, required this.action, this.onLongPress, this.isDivider = false});
}

Row iconedGCWPopupMenuItem(BuildContext context, IconData icon, String title,
    {double rotateDegrees = 0.0, Function? onLongPress, Color? color}) {
  var _color = color ?? themeColors().dialogText();

  return Row(
    children: [
      GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(right: 10),
          child: Transform.rotate(
            angle: degreesToRadian(rotateDegrees),
            child: Icon(icon, color: _color),
          ),
        ),
        onLongPress: () => onLongPress,
      ),
      Text(i18n(context, title, ifTranslationNotExists: title), style: TextStyle(color: themeColors().dialogText()))
    ],
  );
}
