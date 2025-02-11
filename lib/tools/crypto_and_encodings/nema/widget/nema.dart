import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_abc_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enigma/logic/enigma.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema.dart';
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
  String _currentInnerKeyExer = '20B 19A 21C 16D';
  String _currentInnerKeyOper = '20B 19A 21C 16D';
  String _currentOuterKey = 'DISTELFINK';

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
        GCWTextDivider(
          text: i18n(context, 'nema_inner_key'),
          suppressTopSpace: true,
        ),
        _currentMode == GCWSwitchPosition.right
        ? GCWTextField(
          controller: _innerKeyExerController,
          onChanged: (text) {
            setState(() {
              _currentInnerKeyExer = text;
              _currentInnerKey = text;
              nema_init(_currentType);
            });
          },
          )
        : GCWTextField(
          controller: _innerKeyOperController,
          onChanged: (text) {
            setState(() {
              _currentInnerKeyOper = text;
              _currentInnerKey = text;
              nema_init(_currentType);
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'nema_outer_key'),
          suppressTopSpace: true,
        ),
        GCWTextField(
          controller: _outerKeyController,
          onChanged: (text) {
            setState(() {
              _currentOuterKey = text;
              nema_init(_currentType);
            });
          },
        ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    if (nema_valid_key(_currentInnerKey, _currentType)) {
      return GCWDefaultOutput(
        child: nema(_currentInput),
      );
    } else {
      return GCWDefaultOutput(
        child: i18n(context, 'nema_error_invalid_inner_key')
      );
    }
  }

}
