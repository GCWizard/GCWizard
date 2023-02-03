import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/burrows_wheeler/logic/burrows_wheeler.dart';

class BurrowsWheeler extends StatefulWidget {
  @override
  BurrowsWheelerState createState() => BurrowsWheelerState();
}

class BurrowsWheelerState extends State<BurrowsWheeler> {
  var plainController;
  var cipherController;
  var indexNumberController;
  var indexCharacterController;

  var currentMode = GCWSwitchPosition.right;
  var currentIndexType = GCWSwitchPosition.left;

  String currentInputPlain = '';
  String currentInputCipher = '';
  String currentIndexSymbol = '#';
  int currentIndexPosition = 1;
  int currentInputLen = 0;

  var _maskInputFormatter = WrapperForMaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'.')});

  @override
  void initState() {
    super.initState();
    plainController = TextEditingController(text: currentInputPlain);
    cipherController = TextEditingController(text: currentInputCipher);
    indexCharacterController = TextEditingController(text: currentIndexSymbol);
  }

  @override
  void dispose() {
    plainController.dispose();
    cipherController.dispose();
    indexCharacterController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      currentMode == GCWSwitchPosition.left // encrypt
          ? GCWTextField(
              controller: plainController,
              hintText: i18n(context, 'burrowswheeler_inputplain'),
              onChanged: (text) {
                setState(() {
                  currentInputPlain = text;
                  if (currentInputPlain == '' || currentInputPlain == null)
                    currentInputLen = 0;
                  else
                    currentInputLen = currentInputPlain.length;
                });
              },
            )
          : GCWTextField(
              controller: cipherController,
              hintText: i18n(context, 'burrowswheeler_inputcipher'),
              onChanged: (text) {
                setState(() {
                  currentInputCipher = text;
                  if (currentInputCipher == '' || currentInputCipher == null)
                    currentInputLen = 0;
                  else
                    currentInputLen = currentInputCipher.length;
                });
              },
            ),
      GCWTwoOptionsSwitch(
        value: currentMode,
        onChanged: (value) {
          setState(() {
            currentMode = value;
          });
        },
      ),
      GCWTextDivider(
        text: i18n(context, 'burrowswheeler_index'),
      ),
      GCWTwoOptionsSwitch(
        title: i18n(context, 'burrowswheeler_index_type'),
        leftValue: currentMode == GCWSwitchPosition.left
            ? i18n(context, 'burrowswheeler_index_type_number_automated')
            : i18n(context, 'burrowswheeler_index_type_number'),
        rightValue: i18n(context, 'burrowswheeler_index_type_symbol'),
        value: currentIndexType,
        onChanged: (value) {
          setState(() {
            currentIndexType = value;
          });
        },
      ),
      currentIndexType == GCWSwitchPosition.right
          ? GCWTextField(
              controller: indexCharacterController,
              inputFormatters: [_maskInputFormatter],
              hintText: i18n(context, 'burrowswheeler_index_symbol'),
              onChanged: (text) {
                setState(() {
                  currentIndexSymbol = text;
                });
              })
          : currentMode == GCWSwitchPosition.right
              ? GCWIntegerSpinner(
                  controller: indexNumberController,
                  min: 1,
                  max: currentInputLen,
                  value: currentIndexPosition,
                  onChanged: (value) {
                    setState(() {
                      currentIndexPosition = value;
                    });
                  },
                )
              : Container(),
      _buildOutput()
    ]);
  }

  _buildOutput() {
    BWTOutput currentOutput;

    if (currentMode == GCWSwitchPosition.left) {
      // encrypt
      if (currentIndexType == GCWSwitchPosition.right) {
        // encoded index - symbol
        if (currentIndexSymbol == '' || currentIndexSymbol == null)
          currentOutput = BWTOutput(i18n(context, 'burrowswheeler_error_no_index'), '');
        else if (currentInputPlain.contains(currentIndexSymbol))
          currentOutput = BWTOutput(i18n(context, 'burrowswheeler_error_char_index'), '');
        else
          currentOutput = encryptBurrowsWheeler(currentInputPlain, currentIndexSymbol);
      } else {
        currentOutput = encryptBurrowsWheeler(currentInputPlain, '0');
      }
    } else {
      // decrypt
      if (currentIndexType == GCWSwitchPosition.right) {
        // encoded index - symbol
        if (currentIndexSymbol == '' || currentIndexSymbol == null)
          currentOutput = BWTOutput(i18n(context, 'burrowswheeler_error_no_index'), '');
        else
          currentOutput = decryptBurrowsWheeler(currentInputCipher, currentIndexSymbol);
      } else {
        currentOutput = decryptBurrowsWheeler(currentInputCipher, currentIndexPosition.toString());
      }
    }

    if (currentOutput == null || currentOutput.text == null || currentOutput.text == '') return GCWDefaultOutput();

    if (currentMode == GCWSwitchPosition.left && currentIndexType == GCWSwitchPosition.left) {
      return GCWMultipleOutput(
        children: [
          currentOutput.text,
          GCWOutput(
              title: i18n(context, 'burrowswheeler_index'),
              child: GCWOutputText(
                text: currentOutput.index,
              )),
        ],
      );
    }

    return GCWDefaultOutput(
      child: currentOutput.text,
    );
  }
}
