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

class GCWKeyValueEditor extends StatefulWidget {
  final Function onNewEntryChanged;
  final String keyHintText;
  final TextEditingController keyController;
  final List<TextInputFormatter> keyInputFormatters;
  final List<TextInputFormatter> valueInputFormatters;
  final String valueHintText;
  final int valueFlex;
  final Function onAddEntry;
  final Function onAddEntry2;
  final Function onDispose;
  final String alphabetInstertButtonLabel;
  final String alphabetAddAndAdjustLetterButtonLabel;

  final Widget middleWidget;

  final Map<int, Map<String, String>> keyKeyValueMap;
  final Map<String, String> keyValueMap;
  final List<FormulaValue> formulaValueList;
  final bool varcoords;
  final String dividerText;
  final bool editAllowed;
  final Function onUpdateEntry;
  final Function onRemoveEntry;

  const GCWKeyValueEditor({
    Key key,
    this.keyHintText,
    this.keyController,
    this.keyInputFormatters,
    this.onNewEntryChanged,
    this.valueHintText,
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
  TextEditingController _inputController;
  TextEditingController _keyController;
  TextEditingController _valueController;

  TextEditingController _editKeyController;
  TextEditingController _editValueController;

  var _currentInput = '';
  var _currentKeyInput = '';
  var _currentValueInput = '';
  var _currentFormulaValueTypeInput = FormulaValueType.FIXED;

  var _currentEditedKey = '';
  var _currentEditedValue = '';
  var _currentEditedFormulaValueTypeInput = FormulaValueType.FIXED;
  var _currentEditId;

  FocusNode _focusNodeEditValue;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    if (widget.keyController == null)
      _keyController = TextEditingController(text: _currentKeyInput);
    else {
      _keyController = widget.keyController;
      _currentKeyInput = _keyController.text;
    }
    _valueController = TextEditingController(text: _currentValueInput);

    _editKeyController = TextEditingController(text: _currentEditedKey);
    _editValueController = TextEditingController(text: _currentEditedValue);

    _focusNodeEditValue = FocusNode();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose(_currentKeyInput, _currentValueInput, context);

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
                ),
                flex: 2),
            Icon(
              Icons.arrow_forward,
              color: themeColors().mainFont(),
            ),
            Expanded(
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
              flex: widget.valueFlex ?? 2,
            ),
            widget.formulaValueList != null && !widget.varcoords
                ? Expanded(
                    child: Container(
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
                        ),
                        padding: EdgeInsets.only(left: DEFAULT_MARGIN)),
                    flex: 1)
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
        child: GCWButton(
          text: widget.alphabetInstertButtonLabel,
          onPressed: () {
            setState(() {
              _addEntry(_currentKeyInput, _currentValueInput);
            });
          },
        ),
        padding: EdgeInsets.only(left: 4, right: 2));
  }

  Widget _alphabetAddAndAdjustLetterButton() {
    return Container(
        child: GCWButton(
          text: widget.alphabetAddAndAdjustLetterButtonLabel,
          onPressed: _isAddAndAdjustEnabled()
              ? () {
                  setState(() {
                    if (widget.onAddEntry2 != null) widget.onAddEntry2(_currentKeyInput, _currentValueInput, context);

                    _onNewEntryChanged(true);
                  });
                }
              : null,
        ),
        padding: EdgeInsets.only(left: 4, right: 2));
  }

  void _addEntry(String key, String value, {bool clearInput: true, formulaType: FormulaValueType.FIXED}) {
    if (widget.onAddEntry != null) {
      if (widget.formulaValueList == null)
        widget.onAddEntry(key, value, context);
      else
        widget.onAddEntry(key, value, formulaType, context);
    }

    if (clearInput) _onNewEntryChanged(true);
  }

  _onNewEntryChanged(bool resetInput) {
    if (resetInput) {
      if (widget.keyController == null) {
        _keyController.clear();
        _currentKeyInput = '';
      } else
        _currentKeyInput = _keyController.text;

      _valueController.clear();

      _currentValueInput = '';

      _currentFormulaValueTypeInput = FormulaValueType.FIXED;
    }
    if (widget.onNewEntryChanged != null) widget.onNewEntryChanged(_currentKeyInput, _currentValueInput, context);
  }

  _isAddAndAdjustEnabled() {
    if (widget.keyValueMap.containsKey(_currentKeyInput.toUpperCase())) return false;

    if (_currentValueInput.contains(',')) return false;

    return true;
  }

  Widget _buildMiddleWidget() {
    return widget.middleWidget ?? Container();
  }

  Widget _buildList() {
    var odd = false;
    List<Widget> rows;
    if (widget.formulaValueList != null) {
      rows = widget.formulaValueList.map((entry) {
        odd = !odd;
        return _buildRow(entry, odd);
      }).toList();
    } else {
      rows = (widget.keyKeyValueMap?.entries ?? widget.keyValueMap?.entries).map((entry) {
        odd = !odd;
        return _buildRow(entry, odd);
      }).toList();
    }

    rows.insert(
      0,
      GCWTextDivider(
          text: widget.dividerText == null ? "" : widget.dividerText,
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

    return Column(children: rows);
  }

  Widget _buildRow(dynamic entry, bool odd) {
    Widget output;

    var row = Container(
        child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
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
                : GCWText(text: _getEntryKey(entry)),
            margin: EdgeInsets.only(left: 10),
          ),
          flex: 1,
        ),
        Icon(
          Icons.arrow_forward,
          color: themeColors().mainFont(),
        ),
        Expanded(
            child: Container(
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
                  : GCWText(text: _getEntryValue(entry)),
              margin: EdgeInsets.only(left: 10),
            ),
            flex: 3),
        widget.formulaValueList != null && !widget.varcoords
            ? Expanded(
                child: Container(
                    child: _currentEditId == _getEntryId(entry)
                        ? Container(
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
                            ),
                            padding: EdgeInsets.only(left: DEFAULT_MARGIN))
                        : Transform.rotate(
                            child: Icon(_formulaValueTypeIcon(entry.type), color: themeColors().mainFont()),
                            angle: degreesToRadian(entry.type == FormulaValueType.TEXT ? 0.0 : 90.0),
                          )))
            : Container(),
        _editButton(entry),
        GCWIconButton(
          icon: Icons.remove,
          onPressed: () {
            setState(() {
              if (widget.onRemoveEntry != null) widget.onRemoveEntry(_getEntryId(entry), context);
            });
          },
        )
      ],
    ));

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

  Widget _editButton(dynamic entry) {
    if (!widget.editAllowed) return Container();

    return _currentEditId == _getEntryId(entry)
        ? GCWIconButton(
            icon: Icons.check,
            onPressed: () {
              if (widget.onUpdateEntry != null) {
                if (widget.formulaValueList == null) {
                  widget.onUpdateEntry(_currentEditId, _currentEditedKey, _currentEditedValue);
                } else {
                  if (_currentEditedFormulaValueTypeInput == FormulaValueType.INTERPOLATED) {
                    if (!VARIABLESTRING.hasMatch(_currentEditedValue.toLowerCase())) {
                      showToast(i18n(context, 'formulasolver_values_novalidinterpolated'));
                      return;
                    }
                  }
                  widget.onUpdateEntry(
                      _currentEditId, _currentEditedKey, _currentEditedValue, _currentEditedFormulaValueTypeInput);
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

                if (widget.formulaValueList != null)
                  _currentEditedFormulaValueTypeInput =
                      widget.formulaValueList.firstWhere((element) => element.id == _currentEditId).type;
              });
            },
          );
  }

  _getEntryId(dynamic entry) {
    if (widget.formulaValueList != null)
      return entry.id;
    else
      return entry.key;
  }

  _getEntryKey(dynamic entry) {
    if (widget.keyKeyValueMap != null)
      return entry.value.keys.first;
    else
      return entry.key;
  }

  _getEntryValue(dynamic entry) {
    if (widget.keyKeyValueMap != null)
      return entry.value.matrix.first;
    else
      return entry.value;
  }

  String _toJson() {
    List<MapEntry> json;
    if (widget.formulaValueList != null) {
      json = widget.formulaValueList.map((entry) {
        return MapEntry(entry.key, entry.value);
      }).toList();
    } else if (widget.keyKeyValueMap != null) {
      json = <MapEntry>[];
      widget.keyKeyValueMap.entries.forEach((entry) {
        json.addAll(entry.value.entries);
      });
    } else if (widget.keyValueMap != null) json = widget.keyValueMap.entries.toList();

    var list = json.map((e) {
      return jsonEncode({'key': e.key, 'value': e.value});
    }).toList();

    if (list.isEmpty) return null;

    return jsonEncode(list);
  }

  void _pasteClipboard(String text) {
    var json = jsonDecode(text);
    List<MapEntry> list;
    if (json is List<dynamic>)
      list = _fromJson(json);
    else
      list = _parseClipboardText(text);

    if (list != null) {
      list.forEach((mapEntry) {
        _addEntry(mapEntry.key, mapEntry.value, clearInput: false);
      });
      setState(() {});
    }
  }

  List<MapEntry> _fromJson(List<dynamic> json) {
    var list = <MapEntry>[];
    if (json == null) return null;
    String key;
    String value;

    json.forEach((jsonEntry) {
      var json = jsonDecode(jsonEntry);
      key = json['key'];
      value = json['value'];
      if (key != null && value != null) list.add(MapEntry(key, value));
    });

    return list.length == 0 ? null : list;
  }

  List<MapEntry> _parseClipboardText(String text) {
    var list = <MapEntry>[];
    if (text == null) return null;

    List<String> lines = new LineSplitter().convert(text);
    if (lines == null) return null;

    lines.forEach((line) {
      var regExp = RegExp(r"^([\s]*)([\S])([\s]*)([=]?)([\s]*)([\s*\S+]+)([\s]*)");
      var match = regExp.firstMatch(line);
      if (match != null) list.add(MapEntry(match.group(2), match.group(6)));
    });

    return list.length == 0 ? null : list;
  }
}
