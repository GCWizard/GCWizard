import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:prefs/prefs.dart';

class GCWClipboardEditor extends StatefulWidget {
  const GCWClipboardEditor({Key? key}) : super(key: key);

  @override
  GCWClipboardEditorState createState() => GCWClipboardEditorState();
}

class GCWClipboardEditorState extends State<GCWClipboardEditor> {
  late TextEditingController _editController;
  int? _currentEditId;
  String _currentEditText = '';

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: _currentEditText);
  }

  @override
  void dispose() {
    _editController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var entries = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS);

    var children = <Widget>[
      GCWIntegerSpinner(
        title: i18n(context, 'settings_general_clipboard_maxitems'),
        value: Prefs.getInt(PREFERENCE_CLIPBOARD_MAX_ITEMS),
        min: 1,
        max: 100,
        onChanged: (value) {
          setState(() {
            Prefs.setInt(PREFERENCE_CLIPBOARD_MAX_ITEMS, value);
          });
        },
      ),
      GCWIntegerSpinner(
        title: i18n(context, 'settings_general_clipboard_keep.entries.in.days'),
        value: Prefs.getInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS),
        min: 1,
        max: 1000,
        onChanged: (value) {
          setState(() {
            Prefs.setInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS, value);
          });
        },
      ),
      GCWButton(
        text: i18n(context, 'clipboardeditor_clear_title'),
        onPressed: () {
          showGCWAlertDialog(
              context, i18n(context, 'clipboardeditor_clear_title'), i18n(context, 'clipboardeditor_clear_text'), () {
            setState(() {
              Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, []);
            });
          });
        },
      ),
      GCWTextDivider(text: i18n(context, 'clipboardeditor_entries'))
    ];

    children.addAll(entries
        .asMap()
        .map<int, Widget?>((int index, String entry) {
          var item = ClipboardItem.fromJson(entry);
          if (item == null) return MapEntry(index, null);

          Widget child;
          if (_currentEditId != null && _currentEditId == index) {
            child = Row(children: [
              Expanded(
                  child: GCWTextField(
                controller: _editController,
                autofocus: true,
                onChanged: (text) {
                  setState(() {
                    _currentEditText = text;
                  });
                },
              )),
              Container(width: 10),
              GCWIconButton(
                icon: Icons.check,
                onPressed: () {
                  setState(() {
                    if (_currentEditText.isNotEmpty) {
                      item.text = _currentEditText;

                      var newEntries = List<String>.from(entries);
                      newEntries[index] = jsonEncode(item);
                      Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, newEntries);
                    }

                    _currentEditId = null;
                    _editController.clear();
                  });
                },
              ),
            ]);
          } else {
            child = Row(children: [
              Expanded(child: GCWText(text: item.text)),
              Container(width: 10),
              GCWIconButton(
                icon: Icons.edit,
                onPressed: () {
                  setState(() {
                    _currentEditId = index;
                    _editController.text = item.text;
                  });
                },
              ),
              GCWIconButton(
                icon: Icons.remove,
                onPressed: () {
                  var text = item.text;
                  if (text.length > 50) text = item.text.substring(0, 47) + '...';

                  showDeleteAlertDialog(context, text, () {
                    setState(() {
                      var newEntries = List<String>.from(entries);
                      newEntries.removeAt(index);
                      Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, newEntries);
                    });
                  });
                },
              ),
            ]);
          }

          if (index % 2 == 0) {
            child = Container(color: themeColors().outputListOddRows(), child: child);
          } else {
            child = Container(child: child);
          }

          return MapEntry(index, child);
        })
        .values
        .where((Widget? widget) => widget != null)
        .map((Widget? widget) => widget as Widget)
        .toList());

    return Column(children: children);
  }
}
