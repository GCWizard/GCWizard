import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/navigation_service.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:prefs/prefs.dart';

class GCWPasteButton extends StatefulWidget {
  final void Function(String) onSelected;
  final void Function()? onBeforePressed;
  final IconButtonSize? iconSize;
  final Widget? customIcon;
  final Color? backgroundColor;
  final bool? isTextSelectionToolBarButton;
  final EdgeInsets? textSelectionToolBarButtonPadding;
  final String? textSelectionToolBarButtonLabel;

  const GCWPasteButton(
      {Key? key,
      required this.onSelected,
      this.onBeforePressed,
      this.iconSize,
      this.customIcon,
      this.backgroundColor,
      this.isTextSelectionToolBarButton = false,
      this.textSelectionToolBarButtonPadding,
      this.textSelectionToolBarButtonLabel})
      : super(key: key);

  @override
  _GCWPasteButtonState createState() => _GCWPasteButtonState();
}

class _GCWPasteButtonState extends State<GCWPasteButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: GCWPopupMenu(
      size: widget.iconSize,
      customIcon: widget.customIcon,
      iconData: Icons.content_paste,
      backgroundColor: widget.backgroundColor,
      menuItemBuilder: (context) => _buildMenuItems(context),
      onBeforePressed: widget.onBeforePressed,
      isTextSelectionToolBarButton: widget.isTextSelectionToolBarButton ?? false,
      textSelectionToolBarButtonLabel: widget.textSelectionToolBarButtonLabel,
      textSelectionToolBarButtonPadding: widget.textSelectionToolBarButtonPadding,
    ));
  }

  List<GCWPopupMenuItem> _buildMenuItems(BuildContext context) {
    var menuItems = [
      GCWPopupMenuItem(
        child: Text(i18n(context, 'common_clipboard_fromdeviceclipboard'), style: gcwDialogTextStyle()),
        action: (index) {
          try {
            Clipboard.getData('text/plain').then((ClipboardData? data) {
              if (data == null || data.text == null || data.text!.isEmpty) {
                showSnackBar(i18n(context, 'common_clipboard_notextdatafound'), context);
                return;
              }

              widget.onSelected(data.text!);
              insertIntoGCWClipboard(context, data.text!, useGlobalClipboard: false);
            });
          } catch (e) {}
        },
      ),
      GCWPopupMenuItem(
          child: GCWTextDivider(
            style: gcwTextStyle().copyWith(color: themeColors().dialogText()),
            suppressTopSpace: true,
            trailing: GCWIconButton(
              icon: Icons.settings,
              size: IconButtonSize.SMALL,
              iconColor: themeColors().dialogText(),
              onPressed: () => _openClipboardEditor(),
            ),
            text:
                '', // TODO: A GCWTextDivider without any text is a simple GCWDivider, but the GCWDivider currently does not support 'suppressTopSpace' and 'trailing'; Move both attributes to GCWDivider
          ),
          action: (index) {
            _openClipboardEditor();
          })
    ];

    var gcwClipboard = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS)
        .map((String clipboardItem) {
          return ClipboardItem.fromJson(clipboardItem);
        })
        .where((ClipboardItem? item) => item != null)
        .map((ClipboardItem? item) => item as ClipboardItem)
        .map((ClipboardItem item) {
          var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());
          var timeFormat = DateFormat('Hms', Localizations.localeOf(context).toString());

          return GCWPopupMenuItem(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dateFormat.format(item.datetime) + ' ' + timeFormat.format(item.datetime),
                          style: gcwDialogTextStyle().copyWith(fontSize: max(fontSizeSmall(), 10)),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.text,
                          style: gcwDialogTextStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
              action: (int index) {
                if (index < 2) {
                  return;
                }

                var list = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS);
                if (list.isEmpty) {
                  return;
                }

                var item = ClipboardItem.fromJson(list[index - 2]);
                if (item == null) {
                  return;
                }

                widget.onSelected(item.text);
                insertIntoGCWClipboard(context, item.text, useGlobalClipboard: false);
              });
        })
        .toList();

    menuItems.addAll(gcwClipboard);
    return menuItems;
  }

  void _openClipboardEditor() {
    NavigationService.instance.navigateTo(clipboard_editor);
  }
}
