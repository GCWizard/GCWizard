import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class GeneralCharsetValues extends StatefulWidget {
  final Function encode;
  final Function decode;
  final String charsetName;

  GeneralCharsetValues({Key key, this.encode, this.decode, this.charsetName}) : super(key: key);

  @override
  GeneralCharsetValuesState createState() => GeneralCharsetValuesState();
}

class GeneralCharsetValuesState extends State<GeneralCharsetValues> {
  var _encodeController;
  var _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  GCWSwitchPosition _currentSimpleMode = GCWSwitchPosition.left;
  int _currentRadix = 10;
  GCWSwitchPosition _currentBlockSizeMode = GCWSwitchPosition.left;
  int _currentBlockSize = 8;
  Map<String, dynamic> _currentDecoded;

  @override
  void initState() {
    super.initState();

    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentDecoded = null;

    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (value) {
                  setState(() {
                    _currentDecodeInput = value;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: 'A-Z → ' + (i18n(context, widget.charsetName) ?? '123'),
          rightValue: (i18n(context, widget.charsetName) ?? '123') + ' → A-Z',
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_mode_simple'),
          rightValue: i18n(context, 'common_mode_advanced'),
          value: _currentSimpleMode,
          onChanged: (value) {
            setState(() {
              _currentSimpleMode = value;
            });
          },
        ),
        if (_currentSimpleMode == GCWSwitchPosition.right) _buildAdvancedWidgets(),
        GCWDefaultOutput(child: _calculateOutput()),
        _buildCrossTotals()
      ],
    );
  }

  _buildAdvancedWidgets() {
    return Column(children: [
      GCWDropDown(
        title: i18n(context, 'charsets_coding'),
        value: _currentRadix,
        items: <int, String>{
          10: 'common_numeralbase_denary',
          2: 'common_numeralbase_binary',
          16: 'common_numeralbase_hexadecimal'
        }
            .map((key, value) {
              return MapEntry(key, GCWDropDownMenuItem(value: key, child: i18n(context, value)));
            })
            .values
            .toList(),
        onChanged: (value) {
          setState(() {
            _currentRadix = value;
          });
        },
      ),
      GCWTwoOptionsSwitch(
        title: i18n(context, 'charsets_blocksize'),
        leftValue: i18n(context, 'charsets_blocksize_variable'),
        rightValue: i18n(context, 'charsets_blocksize_fixed'),
        value: _currentBlockSizeMode,
        onChanged: (value) {
          setState(() {
            _currentBlockSizeMode = value;
          });
        },
      ),
      if (_currentBlockSizeMode == GCWSwitchPosition.right)
        GCWIntegerSpinner(
          min: 1,
          max: 32,
          value: _currentBlockSize,
          onChanged: (value) {
            setState(() {
              _currentBlockSize = value;
            });
          },
        )
    ]);
  }

  _buildCrossTotals() {
    if (_currentMode == GCWSwitchPosition.left) {
      return CrosstotalOutput(text: _currentEncodeInput, values: widget.encode(_currentEncodeInput));
    } else {
      var _decoded = _calculateDecoded();
      return CrosstotalOutput(text: _decoded['text'], values: _decoded['values']);
    }
  }

  _getRadix() {
    if (_currentSimpleMode == GCWSwitchPosition.left) {
      return 10;
    } else {
      return _currentRadix;
    }
  }

  _getBlockSize() {
    if (_currentSimpleMode == GCWSwitchPosition.right) {
      if (_currentBlockSizeMode == GCWSwitchPosition.right) {
        return _currentBlockSize;
      }
    }
    return null;
  }

  _calculateDecoded() {
    if (_currentDecoded != null) return _currentDecoded;

    int radix = _getRadix();
    int blockSize = _getBlockSize();

    var decodeInput = _currentDecodeInput;
    switch (radix) {
      case 2:
        decodeInput = decodeInput.replaceAll(RegExp(r'[^01]+'), ' ');
        break;
      case 10:
        decodeInput = decodeInput.replaceAll(RegExp(r'[^0-9]+'), ' ');
        break;
      case 16:
        decodeInput = decodeInput.toUpperCase().replaceAll(RegExp(r'[^0-9A-F]+'), ' ');
        break;
      default:
        return {'text': '', 'values': []};
    }

    if (blockSize != null) {
      decodeInput = insertSpaceEveryNthCharacter(decodeInput.replaceAll(RegExp(r'[\s]+'), ''), blockSize);
    }
    List<int> decodeInputList = decodeInput.split(' ').map((block) {
      var blockValue = block;
      try {
        if (radix != 10) {
          blockValue = convertBase(blockValue, radix, 10);
        }
        return int.tryParse(blockValue);
      } catch (e) {
        return null;
      }
    }).toList();

    _currentDecoded = {'text': widget.decode(decodeInputList), 'values': decodeInputList};
    return _currentDecoded;
  }

  _calculateOutput() {
    int radix = _getRadix();
    int blockSize = _getBlockSize();

    String output;

    if (_currentMode == GCWSwitchPosition.left) {
      List<int> encodeOutput = widget.encode(_currentEncodeInput);
      output = encodeOutput.map((value) {
        var valueStr = value.toString();
        if (radix != 10) {
          try {
            valueStr = convertBase(valueStr, 10, radix);
          } catch (e) {
            return '';
          }
        }
        if (blockSize != null) {
          valueStr = valueStr.padLeft(blockSize, '0');
        }
        return valueStr;
      }).join(' ');
    } else {
      output = _calculateDecoded()['text'];
    }

    return output;
  }
}
