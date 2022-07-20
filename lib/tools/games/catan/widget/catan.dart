import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';
import 'package:gc_wizard/tools/games/catan/logic/catan.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class Catan extends StatefulWidget {
  @override
  CatanState createState() => CatanState();
}

class CatanState extends State<Catan> {
  String _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          leftValue: i18n(context, 'catan_mode_basegame'),
          rightValue: i18n(context, 'catan_mode_expansion'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(
            child: encodeCatan(
                    _currentInput, _currentMode == GCWSwitchPosition.left ? CatanMode.BASE : CatanMode.EXPANSION)
                .join(' '))
      ],
    );
  }
}
