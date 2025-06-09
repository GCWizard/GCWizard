import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

class Polybios extends StatefulWidget {
  const Polybios({super.key});

  @override
  _PolybiosState createState() => _PolybiosState();
}

class _PolybiosState extends State<Polybios> {
  late TextEditingController _inputController;
  late TextEditingController _rowLabelController;
  late TextEditingController _colLabelController;
  late TextEditingController _alphabetController;
  late TextEditingController _passwordController;

  String _currentInput = '';
  String _currentRowLabel = '12345';
  String _currentColLabel = '12345';
  String _currentPassword = '';

  PolybiosMode _currentPolybiosMode = PolybiosMode.AZ09;
  String _currentAlphabet = '';

  AlphabetModificationMode _currentModificationMode = AlphabetModificationMode.J_TO_I;

  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _rowLabelController = TextEditingController(text: _currentRowLabel);
    _colLabelController = TextEditingController(text: _currentColLabel);
    _alphabetController = TextEditingController(text: _currentAlphabet);
    _passwordController = TextEditingController(text: _currentPassword);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _rowLabelController.dispose();
    _colLabelController.dispose();
    _alphabetController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var polybiosModeItems = {
      PolybiosMode.AZ09: i18n(context, 'polybios_mode_az09'),
      PolybiosMode.ZA90: i18n(context, 'polybios_mode_za90'),
      PolybiosMode.x09AZ: i18n(context, 'polybios_mode_09az'),
      PolybiosMode.x90ZA: i18n(context, 'polybios_mode_90za'),
      PolybiosMode.CUSTOM: i18n(context, 'common_custom'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOptions(polybiosModeItems),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOptions(Map<PolybiosMode, String> polybiosModeItems) {
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_options'),
      expanded: false,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    GCWTextField(
                      title: i18n(context, 'polybios_row_labels'),
                      maxLength: 6,
                      controller: _rowLabelController,
                      onChanged: (text) {
                        setState(() {
                          _currentRowLabel = text;
                        });
                      },
                    ),
                    GCWTextField(
                      title: i18n(context, 'polybios_column_lables'),
                      hintText: _currentRowLabel,
                      maxLength: 6,
                      controller: _colLabelController,
                      onChanged: (text) {
                        setState(() {
                          _currentColLabel = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _buildSwapButton(),
            ],
          ),
          GCWTextDivider(text: '${i18n(context, 'common_key')} / ${i18n(context, 'common_alphabet')}'),
          GCWTextField(
              hintText: i18n(context, 'polybios_optional_passwort'),
              controller: _passwordController,
              onChanged: (text) {
                setState(() {
                  _currentPassword = text;
                  if (_currentPassword.isNotEmpty) {
                    _currentPolybiosMode = PolybiosMode.CUSTOM;
                    _currentAlphabet = _currentPassword;
                  } else {
                    _currentPolybiosMode = PolybiosMode.AZ09;
                    _currentAlphabet = '';
                  }
                });
              }),
          (_currentPassword.isNotEmpty)
            ? Container()
            : GCWAlphabetDropDown<PolybiosMode>(
              value: _currentPolybiosMode,
              items: polybiosModeItems,
              customModeKey: PolybiosMode.CUSTOM,
              textFieldController: _alphabetController,
              onChanged: (value) {
                setState(() {
                  _currentPolybiosMode = value;
                  if (value != PolybiosMode.CUSTOM) {
                    _currentPassword = '';
                    _passwordController.text = '';
                  } else {
                    if (_passwordController.text.isNotEmpty) {
                      _currentAlphabet = _passwordController.text;
                    } else {
                      _currentAlphabet = _alphabetController.text;
                    }
                  }
                });
              },
              onCustomAlphabetChanged: (text) {
                setState(() {
                  _currentAlphabet = text;
                });
              },
            ),
          _currentRowLabel.length < 6
              ? GCWAlphabetModificationDropDown(
                  value: _currentModificationMode,
                  onChanged: (value) {
                    setState(() {
                      _currentModificationMode = value;
                    });
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildSwapButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GCWIconButton(
          icon: Icons.swap_vert,
          onPressed: () {
            setState(() {
              var tempLabel = _currentRowLabel;
              _currentRowLabel = _currentColLabel;
              _currentColLabel = tempLabel;

              _rowLabelController.text = _currentRowLabel;
              _colLabelController.text = _currentColLabel;
            });
          }),
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput.isEmpty || ![5, 6].contains(_currentRowLabel.length)) {
      return const GCWDefaultOutput(); // TODO: Exception
    }

    PolybiosOutput? _currentOutput;
    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptPolybios(_currentInput, _currentRowLabel,
          colIndexes: _currentColLabel,
          mode: _currentPolybiosMode,
          modificationMode: _currentModificationMode,
          fillAlphabet: _currentAlphabet);
    } else {
      _currentOutput = decryptPolybios(_currentInput, _currentRowLabel,
          colIndexes: _currentColLabel,
          mode: _currentPolybiosMode,
          modificationMode: _currentModificationMode,
          fillAlphabet: _currentAlphabet);
    }

    if (_currentOutput == null || _currentOutput.output.isEmpty) {
      return const GCWDefaultOutput(); // TODO: Exception
    }

    return GCWMultipleOutput(
      children: [
        _currentOutput.output,
        GCWOutput(
          title: i18n(context, 'polybios_usedgrid'),
          child: GCWOutputText(
            text: _currentOutput.grid,
            isMonotype: true,
          ),
        )
      ],
    );
  }
}
