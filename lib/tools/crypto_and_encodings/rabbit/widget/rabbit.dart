import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rabbit/logic/rabbit.dart';

class Rabbit extends StatefulWidget {
  @override
  RabbitState createState() => RabbitState();
}

class RabbitState extends State<Rabbit> {
  String _currentInput = '';
  String _currentKey = '';
  String _currentInitializationVector = '';
  bool _currentExpanded = false;

  var _currentInputFormat = InputFormat.AUTO;
  var _currentKeyFormat = InputFormat.AUTO;
  var _currentIvFormat = InputFormat.AUTO;
  var _currentOutputFormat = OutputFormat.TEXT;

  @override
  Widget build(BuildContext context) {
    var rabbitInputFormatItems = {
      InputFormat.AUTO: i18n(context, 'rc4_format_auto'),
      InputFormat.TEXT: i18n(context, 'rc4_format_text'),
      InputFormat.HEX: i18n(context, 'common_numeralbase_hexadecimal'),
      InputFormat.BINARY: i18n(context, 'common_numeralbase_binary'),
      InputFormat.ASCIIVALUES: i18n(context, 'rc4_format_asciivalues'),
    };

    var rabbitOutputFormatItems = {
      OutputFormat.TEXT: i18n(context, 'rc4_format_text'),
      OutputFormat.HEX: i18n(context, 'common_numeralbase_hexadecimal'),
      OutputFormat.BINARY: i18n(context, 'common_numeralbase_binary'),
      OutputFormat.ASCIIVALUES: i18n(context, 'rc4_format_asciivalues'),
    };

    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        Row(children: <Widget>[
          Expanded(child: GCWText(text: i18n(context, 'rc4_format') + ':'), flex: 1),
          Expanded(
              child: GCWDropDown(
                value: _currentInputFormat,
                onChanged: (value) {
                  setState(() {
                    _currentInputFormat = value;
                  });
                },
                items: rabbitInputFormatItems.entries.map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: mode.value,
                  );
                }).toList(),
              ),
              flex: 2),
        ]),
        GCWTextDivider(text: i18n(context, 'common_key')),
        GCWTextField(
          hintText: i18n(context, 'common_key'),
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        Row(children: <Widget>[
          Expanded(child: GCWText(text: i18n(context, 'rc4_format') + ':'), flex: 1),
          Expanded(
              child: GCWDropDown(
                value: _currentKeyFormat,
                onChanged: (value) {
                  setState(() {
                    _currentKeyFormat = value;
                  });
                },
                items: rabbitInputFormatItems.entries.map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: mode.value,
                  );
                }).toList(),
              ),
              flex: 2),
        ]),
        GCWExpandableTextDivider(
            text: i18n(context, 'rabbit_initialization_vector'),
            expanded: _currentExpanded,
            onChanged: (value) {
              setState(() {
                _currentExpanded = value;
              });
            },
            child: Column(children: [
              GCWTextField(
                hintText: i18n(context, 'rabbit_initialization_vector'),
                onChanged: (text) {
                  setState(() {
                    _currentInitializationVector = text;
                  });
                },
              ),
              Row(children: <Widget>[
                Expanded(child: GCWText(text: i18n(context, 'rc4_format') + ':'), flex: 1),
                Expanded(
                    child: GCWDropDown(
                      value: _currentIvFormat,
                      onChanged: (value) {
                        setState(() {
                          _currentIvFormat = value;
                        });
                      },
                      items: rabbitInputFormatItems.entries.map((mode) {
                        return GCWDropDownMenuItem(
                          value: mode.key,
                          child: mode.value,
                        );
                      }).toList(),
                    ),
                    flex: 2),
              ]),
            ])),
        GCWTextDivider(text: i18n(context, 'common_output') + ' ' + i18n(context, 'rc4_format')),
        Row(children: <Widget>[
          Expanded(child: GCWText(text: i18n(context, 'rc4_format') + ':'), flex: 1),
          Expanded(
              child: GCWDropDown(
                value: _currentOutputFormat,
                onChanged: (value) {
                  setState(() {
                    _currentOutputFormat = value;
                  });
                },
                items: rabbitOutputFormatItems.entries.map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: mode.value,
                  );
                }).toList(),
              ),
              flex: 2),
        ]),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput == null || _currentInput.length == 0) {
      return GCWDefaultOutput();
    }

    var _currentOutput = cryptRabbit(_currentInput, _currentInputFormat, _currentKey, _currentKeyFormat,
        _currentInitializationVector, _currentIvFormat, _currentOutputFormat);

    if (_currentOutput == null) {
      return GCWDefaultOutput();
    } else if (_currentOutput.errorCode != ErrorCode.OK) {
      switch (_currentOutput.errorCode) {
        case ErrorCode.MISSING_KEY:
          return GCWDefaultOutput(child: i18n(context, 'rc4_error_missing_key'));
          break;
        case ErrorCode.KEY_FORMAT:
          showToast(i18n(context, 'rc4_error_key_format'));
          break;
        case ErrorCode.INPUT_FORMAT:
          showToast(i18n(context, 'rc4_error_input_format'));
          break;
        case ErrorCode.IV_FORMAT:
          showToast(i18n(context, 'rabbit_error_iv_format'));
          break;
      }
      return GCWDefaultOutput();
    }

    return GCWDefaultOutput(
      child: _currentOutput.output,
    );
  }
}
