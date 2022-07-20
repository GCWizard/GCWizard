import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enclosed_areas/logic/enclosed_areas.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_onoff_switch/widget/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class EnclosedAreas extends StatefulWidget {
  @override
  EnclosedAreasState createState() => EnclosedAreasState();
}

class EnclosedAreasState extends State<EnclosedAreas> {
  var _currentInput = '';
  var _with4On = GCWSwitchPosition.left;
  var _currentSimpleMode = GCWSwitchPosition.left;
  var _onlyNumbers = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        }),
        GCWTwoOptionsSwitch(
          value: _currentSimpleMode,
          leftValue: i18n(context, 'common_mode_simple'),
          rightValue: i18n(context, 'common_mode_advanced'),
          onChanged: (value) {
            setState(() {
              _currentSimpleMode = value;
            });
          },
        ),
        _currentSimpleMode == GCWSwitchPosition.left ? Container() : _buildAdvancedModeControl(context),
        GCWDefaultOutput(
            child: decodeEnclosedAreas(_currentInput,
                with4: _with4On == GCWSwitchPosition.left, onlyNumbers: _onlyNumbers))
      ],
    );
  }

  Widget _buildAdvancedModeControl(BuildContext context) {
    return Column(children: <Widget>[
      GCWOnOffSwitch(
          title: i18n(context, 'enclosedareas_only_numbers'),
          value: _onlyNumbers,
          onChanged: (value) {
            setState(() {
              _onlyNumbers = value;
            });
          }),
      Row(children: [
        Expanded(child: Container(), flex: 1),
        Expanded(
            child: GCWTwoOptionsSwitch(
              notitle: true,
              leftValue: i18n(context, 'enclosedareas_with4'),
              rightValue: i18n(context, 'enclosedareas_without4'),
              value: _with4On,
              onChanged: (value) {
                setState(() {
                  _with4On = value;
                });
              },
            ),
            flex: 3)
      ]),
    ]);
  }
}
