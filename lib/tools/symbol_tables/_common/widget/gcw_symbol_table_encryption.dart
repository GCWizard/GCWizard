import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_text_to_symbols.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_zoom_buttons.dart';

class GCWSymbolTableEncryption extends StatefulWidget {
  final int countColumns;
  final MediaQueryData mediaQueryData;
  final SymbolTableData data;
  final String symbolKey;
  final void Function() onChanged;
  final String Function(String)? onBeforeEncrypt;
  final bool alwaysIgnoreUnknown;

  const GCWSymbolTableEncryption(
      {Key? key,
      required this.data,
      required this.countColumns,
      required this.mediaQueryData,
      required this.symbolKey,
      required this.onChanged,
      required this.onBeforeEncrypt,
      this.alwaysIgnoreUnknown = false})
      : super(key: key);

  @override
  GCWSymbolTableEncryptionState createState() => GCWSymbolTableEncryptionState();
}

class GCWSymbolTableEncryptionState extends State<GCWSymbolTableEncryption> {
  String _currentEncryptionInput = '';
  late TextEditingController _encryptionInputController;

  final _alphabetMap = <String, int>{};

  var _currentIgnoreUnknown = false;
  var _currentSpecialEncryption = GCWSwitchPosition.left;
  var _currentBorderWidth = 0.1;

  late SymbolTableData _data;

  @override
  void initState() {
    super.initState();

    _data = widget.data;
    for (var element in _data.images) {
      _alphabetMap.putIfAbsent(element.keys.first, () => _data.images.indexOf(element));
    }

    _encryptionInputController = TextEditingController(text: _currentEncryptionInput);
  }

  @override
  void dispose() {
    _encryptionInputController.dispose();

    super.dispose();
  }

  bool _hasSpecialEncryption() {
    switch (_data.symbolKey) {
      case 'color_honey':
      case 'color_tokki':
      case 'puzzle':
      case 'stippelcode':
      case 'tenctonese_cursive':
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _encryptionInputController,
          onChanged: (text) {
            setState(() {
              _currentEncryptionInput = text;

              if (widget.onBeforeEncrypt != null) {
                _currentEncryptionInput = widget.onBeforeEncrypt!(_currentEncryptionInput);
              }
            });
          },
        ),
        if (_hasSpecialEncryption())
          Row(
            children: <Widget>[
              Expanded(
                child: GCWTwoOptionsSwitch(
                  value: _currentSpecialEncryption,
                  leftValue: i18n(context, 'symboltables_specialencryptionmode_original'),
                  rightValue: i18n(context, 'symboltables_specialencryptionmode_standard'),
                  onChanged: (value) {
                    setState(() {
                      _currentSpecialEncryption = value;
                    });
                  },
                ),
              ),
              Container(
                width: 2 * 40.0,
              )
            ],
          ),
        if ((widget.alwaysIgnoreUnknown == false) &&
            (!_hasSpecialEncryption() || _currentSpecialEncryption == GCWSwitchPosition.right))
          Row(
            children: <Widget>[
              Expanded(
                child: GCWOnOffSwitch(
                  value: _currentIgnoreUnknown,
                  title: i18n(context, 'symboltables_ignoreunknown'),
                  onChanged: (value) {
                    setState(() {
                      _currentIgnoreUnknown = value;
                    });
                  },
                ),
              ),
              Container(
                width: 2 * 40.0,
              )
            ],
          ),
        GCWTextDivider(
            text: i18n(context, 'common_output'),
            suppressTopSpace: true,
            trailing: Row(
              children: [
                if (!_hasSpecialEncryption() || _currentSpecialEncryption == GCWSwitchPosition.right)
                  Row(
                    children: [
                      GCWIconButton(
                        customIcon: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Icon(Icons.fit_screen, color: themeColors().mainFont()),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.circle, size: 17.0, color: themeColors().primaryBackground()),
                                Icon(Icons.add, size: 14.0, color: themeColors().mainFont())
                              ],
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _currentBorderWidth = max(_currentBorderWidth - 0.1, -0.6);
                          });
                        },
                      ),
                      GCWIconButton(
                        customIcon: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Icon(Icons.fit_screen, color: themeColors().mainFont()),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.circle, size: 17.0, color: themeColors().primaryBackground()),
                                Icon(Icons.remove, size: 14.0, color: themeColors().mainFont())
                              ],
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _currentBorderWidth = min(1.2, _currentBorderWidth + 0.1);
                          });
                        },
                      ),
                      Container(width: 2 * DOUBLE_DEFAULT_MARGIN),
                    ],
                  ),
                GCWSymbolTableZoomButtons(
                  countColumns: widget.countColumns,
                  mediaQueryData: widget.mediaQueryData,
                  onChanged: widget.onChanged,
                ),
              ],
            )),
        Expanded(
            child: GCWSymbolTableTextToSymbols(
                text: _currentEncryptionInput,
                ignoreUnknown: (_hasSpecialEncryption() && _currentSpecialEncryption == GCWSwitchPosition.left) ||
                    _currentIgnoreUnknown,
                countColumns: widget.countColumns,
                borderWidth: _currentBorderWidth,
                specialEncryption: _hasSpecialEncryption() && _currentSpecialEncryption == GCWSwitchPosition.left,
                data: widget.data)),
      ],
    );
  }
}
