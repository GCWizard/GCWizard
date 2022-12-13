import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/games/catan.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';

class SymbolArithmetic extends StatefulWidget {
  @override
  SymbolArithmeticState createState() => SymbolArithmeticState();
}

class SymbolArithmeticState extends State<SymbolArithmetic> {
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
