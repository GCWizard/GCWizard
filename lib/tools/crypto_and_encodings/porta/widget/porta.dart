import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/porta/logic/porta.dart';


class Porta extends StatefulWidget {
  const Porta({Key? key}) : super(key: key);

  @override
  _PortaState createState() => _PortaState();
}

class _PortaState extends State<Porta> {
  late TextEditingController _inputController;
  late TextEditingController _keyController;

  var _currentInput = '';
  var _currentKey = '';
  var _currentTableVersion = GCWSwitchPosition.left;
  var _classicMode = GCWSwitchPosition.right;

  String _output = '';

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _keyController = TextEditingController(text: _currentKey);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          hintText: i18n(context,'common_input'),
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextField(
          hintText: i18n(context,'common_key'),
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context,'common_original') + " - " + i18n(context, 'porta_without'),
          rightValue: '26 ' + i18n(context, 'common_letters'),
          value: _classicMode,
          onChanged: (value) {
            setState(() {
              _classicMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context,'common_original'),
          rightValue: i18n(context,'porta_reverse'),
          value: _currentTableVersion,
          onChanged: (value) {
            setState(() {
              _currentTableVersion = value;
            });
          },
        ),
        
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    bool classic = _classicMode == GCWSwitchPosition.left;
    PortaTableVersion version = (_currentTableVersion == GCWSwitchPosition.left)  ? PortaTableVersion.ORIGINAL  : PortaTableVersion.REVERSE;
    _output = togglePorta(_currentInput, _currentKey, version: version, classic: classic);

    return GCWDefaultOutput(child: _output);
  }
}
