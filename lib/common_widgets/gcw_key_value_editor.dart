import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

/*
  TODO: TECHNICAL DEBT:
  - Violation of SoC (https://en.wikipedia.org/wiki/Separation_of_concerns)
  - Violation of OCP (https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle)
  - General library/class contains consumer specific logic (e.g. alphabet values, formula values)
  - Changing the specific consumer effects the global class and therefore indirectly may effect independent other consumer
  - Even worse: Formula Values requires value type menu, whereas VarCoords uses Formula Values as well, but without value type menu, so additional flag to remove the menu again... ôO

  - Proposal:
  - One base class, several inherited classes for specific requirements
  - Main Class contains:
    - General logic for add/delete/update an entry
    - Copy/Paste Buttons for key/value pairs
    - UI, especially the odd/even colors
    - Basic text fields for key/value
    - Hooks for onDeleted, onInserted, onUpdated
    - Possibility to override simple key/value widget
    - Possibility to override simple copy/paste function
*/

/* TODO: Entire Widget is painful
   - Because of the many special cases, like the direct case for formulas, etc.
   - You can only work with Object? which makes it less typesafe.

   --> Refactor completely, maybe as GCWKeyValueEditor<T>, whereas T is the specific type?

 */

class GCWKeyValueEditor extends StatefulWidget {
  final void Function(String, String, BuildContext)? onNewEntryChanged;
  final String? keyHintText;
  final TextEditingController? keyController;
  final List<TextInputFormatter>? keyInputFormatters;
  final List<TextInputFormatter>? valueInputFormatters;
  final String valueHintText;
  final int? valueFlex;
  final void Function(String, String, FormulaValueType, BuildContext)? onAddEntry;
  final void Function(String, String, BuildContext)? onAddEntry2;
  final void Function(String, String, BuildContext)? onDispose;
  final String? alphabetInstertButtonLabel;
  final String? alphabetAddAndAdjustLetterButtonLabel;

  final Widget? middleWidget;

  final Map<int, Map<String, String>>? keyKeyValueMap;
  final Map<String, String>? keyValueMap;
  final List<FormulaValue>? formulaValueList;
  final bool varcoords;
  final String? dividerText;
  final bool editAllowed;
  final void Function(Object, String, String, FormulaValueType)? onUpdateEntry;
  final void Function(Object, BuildContext)? onRemoveEntry;

  const GCWKeyValueEditor({
    Key? key,
    this.keyHintText,
    this.keyController,
    this.keyInputFormatters,
    this.onNewEntryChanged,
    required this.valueHintText,
    this.valueInputFormatters,
    this.valueFlex,
    this.onAddEntry,
    this.onAddEntry2,
    this.onDispose,
    this.alphabetInstertButtonLabel,
    this.alphabetAddAndAdjustLetterButtonLabel,
    this.middleWidget,
    this.keyKeyValueMap,
    this.keyValueMap,
    this.formulaValueList,
    this.varcoords = false,
    this.dividerText,
    this.editAllowed = true,
    this.onUpdateEntry,
    this.onRemoveEntry,
  }) : super(key: key);

  @override
  _GCWKeyValueEditor createState() => _GCWKeyValueEditor();
}

class _GCWKeyValueEditor extends State<GCWKeyValueEditor> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;
  late TextEditingController _valueController;

  late TextEditingController _editKeyController;
  late TextEditingController _editValueController;

  final _currentInput = '';
  var _currentKeyInput = '';
  var _currentValueInput = '';
  var _currentFormulaValueTypeInput = FormulaValueType.FIXED;

  var _currentEditedKey = '';
  var _currentEditedValue = '';
  var _currentEditedFormulaValueTypeInput = FormulaValueType.FIXED;
  Object? _currentEditId;

  late FocusNode _focusNodeEditValue;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    if (widget.keyController == null) {
      _keyController = TextEditingController(text: _currentKeyInput);
    } else {
      _keyController = widget.keyController!;
      _currentKeyInput = _keyController.text;
    }
    _valueController = TextEditingController(text: _currentValueInput);

    _editKeyController = TextEditingController(text: _currentEditedKey);
    _editValueController = TextEditingController(text: _currentEditedValue);

    _focusNodeEditValue = FocusNode();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose!(_currentKeyInput, _currentValueInput, context);

    _inputController.dispose();
    if (widget.keyController == null) _keyController.dispose();
    _valueController.dispose();

    _editKeyController.dispose();
    _editValueController.dispose();

    _focusNodeEditValue.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[_buildInput(), _buildMiddleWidget(), _buildList()]);
  }

  Widget _buildInput() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: GCWTextField(
                  hintText: widget.keyHintText,
                  controller: _keyController,
                  inputFormatters: widget.keyInputFormatters,
                  onChanged: (text) {
                    setState(() {
                      _currentKeyInput = text;
                      _onNewEntryChanged(false);
                    });
                  },
                )),
            Icon(
              Icons.arrow_forward,
              color: themeColors().mainFont(),
            ),
            Expanded(
              flex: widget.valueFlex ?? 2,
              child: GCWTextField(
                hintText: widget.valueHintText,
                controller: _valueController,
                inputFormatters: widget.valueInputFormatters,
                onChanged: (text) {
                  setState(() {
                    _currentValueInput = text;
                    _onNewEntryChanged(false);
                  });
                },
              ),
            ),
            widget.formulaValueList != null && !widget.varcoords
                ? Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                    child: GCWPopupMenu(
                      iconData: _formulaValueTypeIcon(_currentFormulaValueTypeInput),
                      rotateDegrees: _currentFormulaValueTypeInput == FormulaValueType.TEXT ? 0.0 : 90.0,
                      menuItemBuilder: (context) => [
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(context, Icons.vertical_align_center_outlined,
                                i18n(context, 'formulasolver_values_type_fixed'),
                                rotateDegrees: 90.0),
                            action: (index) => setState(() {
                              _currentFormulaValueTypeInput = FormulaValueType.FIXED;
                            })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(
                                context, Icons.expand, i18n(context, 'formulasolver_values_type_interpolated'),
                                rotateDegrees: 90.0),
                            action: (index) => setState(() {
                              _currentFormulaValueTypeInput = FormulaValueType.INTERPOLATED;
                            })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(
                                context, Icons.text_fields, i18n(context, 'formulasolver_values_type_text')),
                            action: (index) => setState(() {
                              _currentFormulaValueTypeInput = FormulaValueType.TEXT;
                            })),
                      ],
                    )))
                : Container(),
            widget.alphabetInstertButtonLabel != null
                ? _alphabetAddLetterButton()
                : GCWIconButton(
                icon: Icons.add,
                onPressed: () {
                  if (_currentFormulaValueTypeInput == FormulaValueType.INTERPOLATED) {
                    if (!VARIABLESTRING.hasMatch(_currentValueInput.toLowerCase())) {
                      showToast(i18n(context, 'formulasolver_values_novalidinterpolated'));
                      return;
                    }
                  }

                  setState(() {
                    _addEntry(_currentKeyInput, _currentValueInput, formulaType: _currentFormulaValueTypeInput);
                  });
                }),
            widget.alphabetAddAndAdjustLetterButtonLabel != null ? _alphabetAddAndAdjustLetterButton() : Container()
          ],
        ),
      ],
    );
  }

  Widget _alphabetAddLetterButton() {
    return Container(
        padding: const EdgeInsets.only(left: 4, right: 2),
        child: GCWButton(
          text: widget.alphabetInstertButtonLabel ?? '',
          onPressed: () {
            setState(() {
              _addEntry(_currentKeyInput, _currentValueInput);
            });
          },
        ));
  }

  Widget _alphabetAddAndAdjustLetterButton() {
    return Container(
        padding: const EdgeInsets.only(left: 4, right: 2),
        child: GCWButton(
          text: widget.alphabetAddAndAdjustLetterButtonLabel ?? '',
          onPressed: () => _isAddAndAdjustEnabled()
              ? () {
            setState(() {
              if (widget.onAddEntry2 != null) widget.onAddEntry2!(_currentKeyInput, _currentValueInput, context);

              _onNewEntryChanged(true);
            });
          }
              : null,
        ));
  }

  void _addEntry(String key, String value, {bool clearInput = true, FormulaValueType formulaType = FormulaValueType.FIXED}) {
    if (widget.onAddEntry != null) {
      widget.onAddEntry!(key, value, formulaType, context);
    }

    if (clearInput) _onNewEntryChanged(true);
  }

  void _onNewEntryChanged(bool resetInput) {
    if (resetInput) {
      if (widget.keyController == null) {
        _keyController.clear();
        _currentKeyInput = '';
      } else {
        _currentKeyInput = _keyController.text;
      }

      _valueController.clear();

      _currentValueInput = '';

      _currentFormulaValueTypeInput = FormulaValueType.FIXED;
    }
    if (widget.onNewEntryChanged != null) widget.onNewEntryChanged!(_currentKeyInput, _currentValueInput, context);
  }

  bool _isAddAndAdjustEnabled() {
    if (widget.keyValueMap == null || widget.keyValueMap!.containsKey(_currentKeyInput.toUpperCase())) return false;

    if (_currentValueInput.contains(',')) return false;

    return true;
  }

  Widget _buildMiddleWidget() {
    return widget.middleWidget ?? Container();
  }

  Widget _buildList() {
    var odd = false;
    List<Widget>? rows;
    if (widget.formulaValueList != null) {
      rows = widget.formulaValueList?.map((entry) {
        odd = !odd;
        return _buildRow(entry, odd);
      }).toList();
    } else {
      rows = (widget.keyKeyValueMap?.entries ?? widget.keyValueMap?.entries)?.map((entry) {
        odd = !odd;
        return _buildRow(entry, odd);
      }).toList();
    }

    if (rows != null) {
      rows.insert(
        0,
        GCWTextDivider(
            text: widget.dividerText ?? '',
            trailing: Row(children: <Widget>[
              GCWPasteButton(
                iconSize: IconButtonSize.SMALL,
                onSelected: _pasteClipboard,
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
            ])),
      );
    }

    return rows == null ? Container() : Column(children: rows);
  }

  Widget _buildRow(Object entry, bool odd) {
    Widget output;

    var row = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            child: _currentEditId == _getEntryId(entry)
                ? GCWTextField(
              controller: _editKeyController,
              inputFormatters: widget.keyInputFormatters,
              onChanged: (text) {
                setState(() {
                  _currentEditedKey = text;
                });
              },
            )
                : GCWText(text: (_getEntryKey(entry)).toString()),
          ),
        ),
        Icon(
          Icons.arrow_forward,
          color: themeColors().mainFont(),
        ),
        Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: _currentEditId == _getEntryId(entry)
                  ? GCWTextField(
                controller: _editValueController,
                focusNode: _focusNodeEditValue,
                inputFormatters: widget.valueInputFormatters,
                onChanged: (text) {
                  setState(() {
                    _currentEditedValue = text;
                  });
                },
              )
                  : GCWText(text: _getEntryValue(entry).toString()),
            )),
        widget.formulaValueList != null && !widget.varcoords
            ? Expanded(
            child: Container(
                child: _currentEditId == _getEntryId(entry)
                    ? Container(
                    padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                    child: GCWPopupMenu(
                      iconData: _formulaValueTypeIcon(_currentEditedFormulaValueTypeInput),
                      rotateDegrees: _currentEditedFormulaValueTypeInput == FormulaValueType.TEXT ? 0.0 : 90.0,
                      menuItemBuilder: (context) => [
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(context, Icons.vertical_align_center_outlined,
                                i18n(context, 'formulasolver_values_type_fixed'),
                                rotateDegrees: 90.0),
                            action: (index) => setState(() {
                              _currentEditedFormulaValueTypeInput = FormulaValueType.FIXED;
                            })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(
                                context, Icons.expand, i18n(context, 'formulasolver_values_type_interpolated'),
                                rotateDegrees: 90.0),
                            action: (index) => setState(() {
                              _currentEditedFormulaValueTypeInput = FormulaValueType.INTERPOLATED;
                            })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(
                                context, Icons.text_fields, i18n(context, 'formulasolver_values_type_text')),
                            action: (index) => setState(() {
                              _currentEditedFormulaValueTypeInput = FormulaValueType.TEXT;
                            })),
                      ],
                    ))
                    : Transform.rotate(
                  // TODO Mike Check that entry is really of type FormulaValue and type is really not NULL
                  angle: degreesToRadian((entry as FormulaValue).type == FormulaValueType.TEXT ? 0.0 : 90.0),
                  // TODO Mike Check that entry is really of type FormulaValue and type is really not NULL
                  child: Icon(_formulaValueTypeIcon((entry).type!), color: themeColors().mainFont()),
                )))
            : Container(),
        _editButton(entry),
        GCWIconButton(
          icon: Icons.remove,
          onPressed: () {
            setState(() {
              var entryId = _getEntryId(entry);
              if (widget.onRemoveEntry != null) widget.onRemoveEntry!(entryId, context);
            });
          },
        )
      ],
    );

    if (odd) {
      output = Container(color: themeColors().outputListOddRows(), child: row);
    } else {
      output = Container(child: row);
    }

    return output;
  }

  IconData _formulaValueTypeIcon(FormulaValueType formulaValueType) {
    switch (formulaValueType) {
      case FormulaValueType.TEXT:
        return Icons.text_fields;
      case FormulaValueType.INTERPOLATED:
        return Icons.expand;
      case FormulaValueType.FIXED:
        return Icons.vertical_align_center_outlined;
    }
  }

  Widget _editButton(Object entry) {
    if (!widget.editAllowed) return Container();

    return _currentEditId == _getEntryId(entry)
        ? GCWIconButton(
      icon: Icons.check,
      onPressed: () {
        if (widget.onUpdateEntry != null) {
          if (widget.formulaValueList == null && _currentEditId != null) {
            widget.onUpdateEntry!(_currentEditId!, _currentEditedKey, _currentEditedValue, _currentEditedFormulaValueTypeInput);
          } else {
            if (_currentEditedFormulaValueTypeInput == FormulaValueType.INTERPOLATED) {
              if (!VARIABLESTRING.hasMatch(_currentEditedValue.toLowerCase())) {
                showToast(i18n(context, 'formulasolver_values_novalidinterpolated'));
                return;
              }
            }
            if (_currentEditId != null) {
              widget.onUpdateEntry!(
                _currentEditId!, _currentEditedKey, _currentEditedValue, _currentEditedFormulaValueTypeInput);
            }
          }
        }

        setState(() {
          _currentEditId = null;
          _editKeyController.clear();
          _editValueController.clear();
        });
      },
    )
        : GCWIconButton(
      icon: Icons.edit,
      onPressed: () {
        setState(() {
          FocusScope.of(context).requestFocus(_focusNodeEditValue);

          _currentEditId = _getEntryId(entry);
          _editKeyController.text = _getEntryKey(entry);
          _editValueController.text = _getEntryValue(entry);
          _currentEditedKey = _getEntryKey(entry);
          _currentEditedValue = _getEntryValue(entry);

          if (widget.formulaValueList != null) {
            _currentEditedFormulaValueTypeInput =
                widget.formulaValueList!.firstWhere((element) => element.id == _currentEditId).type ?? FormulaValueType.FIXED;
          }
        });
      },
    );
  }

  Object _getEntryId(Object entry) {
    if (entry is FormulaValue && entry.id != null) {
      return entry.id!;
    } else if (entry is MapEntry<String, String>) {
      return entry.key;
    } else if (entry is MapEntry<int, Map<String, String>>) {
      return entry.key;
    }

    throw Exception('Wrong entry id type');
  }

  String _getEntryKey(Object entry) {
    if (entry is FormulaValue) {
      return entry.key;
    } else if (entry is MapEntry<String, String>) {
      return entry.key;
    } else if (entry is MapEntry<int, Map<String, String>>) {
      return entry.value.keys.first;
    }

    throw Exception('Wrong entry key type');
  }

  String _getEntryValue(Object entry) {
    if (entry is FormulaValue) {
      return (entry).value;
    } else if (entry is MapEntry<String, String>) {
      return (entry).value;
    } else if (entry is MapEntry<int, Map<String, String>>) {
      return (entry).value.values.first;
    }

    throw Exception('Wrong entry value type');
  }

  String? _toJson() {
    List<MapEntry<String, String>>? json = [];
    if (widget.formulaValueList != null) {
      json = widget.formulaValueList?.map((entry) {
        return MapEntry<String, String>(entry.key, entry.value);
      }).toList();
    } else if (widget.keyKeyValueMap != null) {
      for (var entry in widget.keyKeyValueMap!.entries) {
        json.addAll(entry.value.entries);
      }
    } else if (widget.keyValueMap != null) {
      json = widget.keyValueMap?.entries.toList();
    }

    var list = json?.map((e) {
      return jsonEncode({'key': e.key, 'value': e.value});
    }).toList();

    if (list == null || list.isEmpty) return null;

    return jsonEncode(list);
  }

  void _pasteClipboard(String text) {
    Object? json = jsonDecode(text);
    List<MapEntry<String, String>>? list;
    if (isJsonArray(json)) {
      list = _fromJson(json as List<Object?>);
    } else {
      list = _parseClipboardText(text);
    }

    if (list != null) {
      for (var mapEntry in list) {
        _addEntry(mapEntry.key, mapEntry.value, clearInput: false);
      }
      setState(() {});
    }
  }

  List<MapEntry<String, String>>? _fromJson(List<Object?> json) {
    var list = <MapEntry<String, String>>[];
    String? key;
    String? value;

    for (var jsonEntry in json) {
      if (jsonEntry == null || jsonEntry is! String) {
        continue;
      }

      var json = jsonDecode(jsonEntry);
      key = toStringOrNull(json['key']);
      value = toStringOrNull(json['value']);

      if (key != null && value != null) list.add(MapEntry(key, value));
    }

    return list.isEmpty ? null : list;
  }

  List<MapEntry<String, String>>? _parseClipboardText(String? text) {
    var list = <MapEntry<String, String>>[];
    if (text == null) return null;

    List<String> lines = const LineSplitter().convert(text);

    for (var line in lines) {
      var regExp = RegExp(r"^([\s]*)([\S])([\s]*)([=]?)([\s]*)([\s*\S+]+)([\s]*)");
      var match = regExp.firstMatch(line);
      if (match != null && match.group(2) != null && match.group(6) != null) {
        list.add(MapEntry(match.group(2)!, match.group(6)!));
      }
    }

    return list.isEmpty ? null : list;
  }
}
