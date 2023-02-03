import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/navigation_service.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:intl/intl.dart';
import 'package:prefs/prefs.dart';

class GCWPasteButton extends StatefulWidget {
  final Function onSelected;
  final Function onBeforePressed;
  final IconButtonSize iconSize;
  final Widget customIcon;
  final Color backgroundColor;
  final bool isTextSelectionToolBarButton;
  final EdgeInsets textSelectionToolBarButtonPadding;
  final String textSelectionToolBarButtonLabel;

  const GCWPasteButton(
      {Key key,
      this.onSelected,
      this.onBeforePressed,
      this.iconSize,
      this.customIcon,
      this.backgroundColor,
      this.isTextSelectionToolBarButton: false,
      this.textSelectionToolBarButtonPadding,
      this.textSelectionToolBarButtonLabel})
      : super(key: key);

  @override
  GCWPasteButtonState createState() => GCWPasteButtonState();
}

class GCWPasteButtonState extends State<GCWPasteButton> {
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
      isTextSelectionToolBarButton: widget.isTextSelectionToolBarButton,
      textSelectionToolBarButtonLabel: widget.textSelectionToolBarButtonLabel,
      textSelectionToolBarButtonPadding: widget.textSelectionToolBarButtonPadding,
    ));
  }

  _buildMenuItems(BuildContext context) {
    var menuItems = [
      GCWPopupMenuItem(
        child: Text(i18n(context, 'common_clipboard_fromdeviceclipboard'), style: gcwDialogTextStyle()),
        action: (index) {
          try {
            Clipboard.getData('text/plain').then((data) {
              if (data.text.length == 0) {
                showToast(i18n(context, 'common_clipboard_notextdatafound'));
                return;
              }

              widget.onSelected(data.text);
              insertIntoGCWClipboard(context, data.text, useGlobalClipboard: false);
            });
          } catch (e) {}
        },
      ),
      GCWPopupMenuItem(
          child: GCWTextDivider(
            suppressTopSpace: true,
            style: gcwDialogTextStyle(),
            trailing: GCWIconButton(
              icon: Icons.settings,
              size: IconButtonSize.SMALL,
              iconColor: themeColors().dialogText(),
            ),
          ),
          action: (index) {
            NavigationService.instance.navigateTo('clipboard_editor');
          })
    ];

    var gcwClipboard = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS).map((clipboardItem) {
      var item = jsonDecode(clipboardItem);

      var datetime = DateTime.fromMillisecondsSinceEpoch(int.tryParse(item['created']));
      var dateFormat = DateFormat('yMd', Localizations.localeOf(context).toString());
      var timeFormat = DateFormat('Hms', Localizations.localeOf(context).toString());

      return GCWPopupMenuItem(
          child: Container(
            child: Column(
              children: [
                Align(
                    child: Text(
                      dateFormat.format(datetime) + ' ' + timeFormat.format(datetime),
                      style: gcwDialogTextStyle().copyWith(fontSize: max(fontSizeSmall(), 10)),
                    ),
                    alignment: Alignment.centerLeft),
                Align(
                    child: Text(
                      item['text'],
                      style: gcwDialogTextStyle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    alignment: Alignment.centerLeft),
              ],
            ),
            padding: EdgeInsets.only(bottom: 15),
          ),
          action: (index) {
            var pasteData = jsonDecode(Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS)[index - 2])['text'];
            widget.onSelected(pasteData);
            insertIntoGCWClipboard(context, pasteData, useGlobalClipboard: false);
          });
    }).toList();

    menuItems.addAll(gcwClipboard);
    return menuItems;
  }
}
