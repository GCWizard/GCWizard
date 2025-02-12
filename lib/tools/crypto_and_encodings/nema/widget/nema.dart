import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_abc_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enigma/logic/enigma.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tuple/tuple.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/nema/widget/nema_rotor_dropdown.dart';

class NEMA extends StatefulWidget {
  const NEMA({Key? key}) : super(key: key);

  @override
  _NEMAState createState() => _NEMAState();
}

class _NEMAState extends State<NEMA> {
  late TextEditingController _inputController;
  late TextEditingController _innerKeyExerController;
  late TextEditingController _innerKeyOperController;
  late TextEditingController _outerKeyController;

  String _currentInput = '';
  String _currentInnerKey = '';
  String _currentInnerKeyExer = '20-B 19-A 21-C 16-D';
  String _currentInnerKeyOper = '12-B 13-A 14-C 15-D 17-E 18-F';
  String _currentOuterKey = 'DISTELFINK';

  final MaskTextInputFormatter _MASKINPUTFORMATTER_innerKey_exer =
  MaskTextInputFormatter(mask: "@@-# @@-# @@-# @@-#", filter: {"@": RegExp(r'[0-9]'), "#": RegExp(r'[A-Za-z]')});
  final MaskTextInputFormatter _MASKINPUTFORMATTER_innerKey_oper =
  MaskTextInputFormatter(mask: "@@-# @@-# @@-# @@-# @@-# @@-#", filter: {"@": RegExp(r'[0-9]'), "#": RegExp(r'[A-Za-z]')});
  final MaskTextInputFormatter _MASKINPUTFORMATTER_outerKey =
  MaskTextInputFormatter(mask: "##########", filter: {"#": RegExp(r'[A-Za-z]')});

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  NEMA_TYPE _currentType = NEMA_TYPE.EXER;

    @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _innerKeyExerController = TextEditingController(text: _currentInnerKeyExer);
    _innerKeyOperController = TextEditingController(text: _currentInnerKeyOper);
    _outerKeyController = TextEditingController(text: _currentOuterKey);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _innerKeyExerController.dispose();
    _innerKeyOperController.dispose();
    _outerKeyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
            rightValue: i18n(context, 'nema_type_exer'),
            leftValue: i18n(context, 'nema_type_oper'),
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
                _currentType = _currentMode == GCWSwitchPosition.right ? NEMA_TYPE.EXER : NEMA_TYPE.OPER;
              });
            }),
        GCWTextDivider(
          text: i18n(context, 'nema_input'),
          suppressTopSpace: true,
        ),
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWExpandableTextDivider(
          suppressTopSpace: false,
          text: i18n(context, 'nema_keys'),
          child: Column(
            children: [
              GCWTextDivider(
                text: i18n(context, 'nema_inner_key'),
                suppressTopSpace: true,
              ),
              _currentMode == GCWSwitchPosition.right
                  ? GCWTextField(
                controller: _innerKeyExerController,
                hintText: '16-A 19-B 20-C 21-D',
                inputFormatters: [_MASKINPUTFORMATTER_innerKey_exer],
                onChanged: (text) {
                  setState(() {
                    _currentInnerKeyExer = text;
                    _currentInnerKey = _currentInnerKeyExer;
                  });
                },
              )
                  : GCWTextField(
                controller: _innerKeyOperController,
                hintText: '12-A 13-B 14-C 15-D 17-E 18-F',
                inputFormatters: [_MASKINPUTFORMATTER_innerKey_oper],
                onChanged: (text) {
                  setState(() {
                    _currentInnerKeyOper = text;
                    _currentInnerKey = _currentInnerKeyOper;
                  });
                },
              ),
              GCWTextDivider(
                text: i18n(context, 'nema_outer_key'),
                suppressTopSpace: false,
              ),
              GCWTextField(
                hintText: 'DISTELFINK',
                controller: _outerKeyController,
                inputFormatters: [_MASKINPUTFORMATTER_outerKey],
                onChanged: (text) {
                  setState(() {
                    _currentOuterKey = text;
                    nema_init(_currentType);
                  });
                },
              ),
            ],
          ),
        ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
      print(_currentInnerKey);
    if (nema_valid_key(_currentInnerKey, _currentType)) {
      return GCWDefaultOutput(
        child: nema(_currentInput, _currentType, _currentInnerKey, _currentOuterKey),
      );
    } else {
      return GCWDefaultOutput(
        child: i18n(context, 'nema_error_invalid_inner_key')
      );
    }
  }

}
