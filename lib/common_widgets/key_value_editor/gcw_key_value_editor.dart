import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

part "package:gc_wizard/common_widgets/key_value_editor/key_value_input.dart";
part "package:gc_wizard/common_widgets/key_value_editor/key_value_item.dart";

class KeyValueEditorControl {
  KeyValueBase? currentInProgress;
}

class GCWKeyValueEditor extends StatefulWidget {
  final List<KeyValueBase> entries;
  final String? keyHintText;
  final TextEditingController? keyController;
  final List<TextInputFormatter>? keyInputFormatters;
  final List<TextInputFormatter>? addValueInputFormatters;
  final List<TextInputFormatter>? editValueInputFormatters;
  final String valueHintText;
  final int? valueFlex;
  final void Function(KeyValueBase)? onAddEntry;
  final void Function(KeyValueBase)? onNewEntryChanged;
  final GCWKeyValueInput Function(Key? key)? onCreateInput;
  final GCWKeyValueItem Function(KeyValueBase, bool)? onCreateNewItem;
  final Widget? trailing;

  final Widget? middleWidget;

  final bool addOnDispose;
  final String? dividerText;
  final bool editAllowed;
  final void Function(KeyValueBase)? onUpdateEntry;

  final bool Function(String)? validateEditedValue;
  final String? invalidEditedValueMessage;

  const GCWKeyValueEditor(
      {Key? key,
      required this.entries,
      this.keyHintText,
      this.keyController,
      this.keyInputFormatters,
      this.onNewEntryChanged,
      required this.valueHintText,
      this.addValueInputFormatters,
      this.editValueInputFormatters,
      this.valueFlex,
      this.onAddEntry,
      this.middleWidget,
      this.dividerText,
      this.editAllowed = true,
      this.addOnDispose = false,
      this.onUpdateEntry,
      this.onCreateInput,
      this.onCreateNewItem,
      this.trailing,
      this.validateEditedValue,
      this.invalidEditedValueMessage})
      : super(key: key);

  @override
  _GCWKeyValueEditor createState() => _GCWKeyValueEditor();
}

class _GCWKeyValueEditor extends State<GCWKeyValueEditor> {
  final _keyValueEditorControl = KeyValueEditorControl();
  final GlobalKey<GCWKeyValueInputState> _InputState = GlobalKey<GCWKeyValueInputState>();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[_buildInput(), _buildMiddleWidget(), _buildList()]);
  }

  Widget _buildInput() {
    GCWKeyValueInput input;

    if (widget.onCreateInput != null) {
      input = widget.onCreateInput!(_InputState);
    } else {
      input = GCWKeyValueInput(key: _InputState);
    }

    input.keyController = widget.keyController;
    input.onAddEntry = widget.onAddEntry;
    input.onNewEntryChanged = widget.onNewEntryChanged;
    input.onUpdateEntry = widget.onUpdateEntry;
    input.valueFlex = widget.valueFlex;
    input.keyInputFormatters = widget.keyInputFormatters;
    input.valueInputFormatters = widget.addValueInputFormatters;
    input.addOnDispose = widget.addOnDispose;
    input.keyHintText = widget.keyHintText;
    input.valueHintText = widget.valueHintText;
    input.entries = widget.entries;
    input.onSetState = onSetState;

    return input;
  }

  Widget _buildMiddleWidget() {
    return widget.middleWidget ?? Container();
  }

  Widget _buildList() {
    var odd = false;
    List<Widget>? rows;

    rows = widget.entries.map((entry) {
      odd = !odd;
      return _buildEntry(entry, odd);
    }).toList();

    var _trailingChildren = <Widget>[];
    if (widget.trailing != null) {
      _trailingChildren.add(widget.trailing!);
    }
    _trailingChildren.addAll(<Widget>[
      GCWPasteButton(
        iconSize: IconButtonSize.SMALL,
        onSelected: (text) => _InputState.currentState?.pasteClipboard(text),
      ),
      GCWIconButton(
        size: IconButtonSize.SMALL,
        icon: Icons.content_copy,
        onPressed: () {
          var copyText = _toJson();
          if (copyText == null) return;
          insertIntoGCWClipboard(context, copyText);
        },
      )
    ]);

    rows.insert(
      0,
      GCWTextDivider(text: widget.dividerText ?? '', trailing: Row(children: _trailingChildren)),
    );

    return rows.isEmpty ? Container() : Column(children: rows);
  }

  Widget _buildEntry(KeyValueBase entry, bool odd) {
    GCWKeyValueItem item;
    if (widget.onCreateNewItem != null) {
      item = widget.onCreateNewItem!(entry, odd);
    } else {
      item = GCWKeyValueItem(
          keyValueEntry: entry,
          odd: odd,
          validateEditedValue: widget.validateEditedValue,
          invalidEditedValueMessage: widget.invalidEditedValueMessage);
    }

    item.keyValueEditorControl = _keyValueEditorControl;
    item.keyInputFormatters = widget.keyInputFormatters;
    item.valueInputFormatters = widget.editValueInputFormatters;
    item.onUpdateEntry = widget.onUpdateEntry;
    item.editAllowed = widget.editAllowed;
    item.entries = widget.entries;
    item.onSetState = onSetState;

    return item;
  }

  void onSetState() {
    setState(() {});
  }

  String? _toJson() {
    var list = widget.entries.map((e) {
      return jsonEncode({'key': e.key, 'value': e.value});
    }).toList();

    if (list.isEmpty) return null;

    return jsonEncode(list);
  }
}
