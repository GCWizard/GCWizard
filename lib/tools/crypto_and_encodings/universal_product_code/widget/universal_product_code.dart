import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/logic/universal_product_code.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/widget/binary2image.dart';

class UniversalProductCode extends StatefulWidget {
  const UniversalProductCode({Key? key}) : super(key: key);

  @override
  _UniversalProductCodeState createState() => _UniversalProductCodeState();
}

class _UniversalProductCodeState extends State<UniversalProductCode> {
  String _currentInput = '';
  late TextEditingController _inputController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.right) {
      var out = '';
      try {
        out = decodeUPC_A(_currentInput);
      } catch (e) {
        out = i18n(context, 'universalproductcode_error_invalid');
      }

      return GCWDefaultOutput(child: out);
    } else {
      var out = encodeUPC_A(_currentInput);

      var data = <List<Object?>>[];
      if (out.pureNumbers.isNotEmpty) {
        data.add([i18n(context, 'universalproductcode_pure'), out.pureNumbers]);
      }
      if (out.correctEncoding.isNotEmpty) {
        data.add([i18n(context, 'universalproductcode_correct'), out.correctEncoding]);
      }
      if (out.barcodeBinaryCorrectEncoding.isNotEmpty) {
        data.add( [
          Column(
            children: [
              GCWText(text: i18n(context, 'universalproductcode_correct_bin')),
              Row(
                children: [
                  Container(width: 2 * DOUBLE_DEFAULT_MARGIN),
                  Expanded(child:
                  GCWButton(text: i18n(context, 'universalproductcode_openinbarcodetool'), onPressed: () {
                    openInBinary2Image(context, out.barcodeBinaryCorrectEncoding);
                  })),
                  Container(width: 2 * DOUBLE_DEFAULT_MARGIN),
                ],
              )
            ],
          ),
          out.barcodeBinaryCorrectEncoding
        ]);
      }

      return GCWDefaultOutput(
        child: Column(
          children: [
            GCWColumnedMultilineOutput(data: data),
          ],
        )
      );
    }


  }
}
