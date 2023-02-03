import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_list_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/7_segment_display/widget/7_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/utils/constants.dart';

class Beghilos extends StatefulWidget {
  @override
  BeghilosState createState() => BeghilosState();
}

class BeghilosState extends State<Beghilos> {
  var _inputControllerDecode;
  var _inputControllerEncode;

  var _currentInputEncode = defaultIntegerListText;
  var _currentInputDecode = '';
  var _currentMode = GCWSwitchPosition.right;
  var _currentDisplays = <List<String>>[];

  @override
  void initState() {
    super.initState();
    _inputControllerDecode = TextEditingController(text: _currentInputDecode);
    _inputControllerEncode = TextEditingController(text: _currentInputEncode['text']);
  }

  @override
  void dispose() {
    _inputControllerDecode.dispose();
    _inputControllerEncode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _inputControllerDecode,
                onChanged: (text) {
                  setState(() {
                    _currentInputDecode = text;
                  });
                })
            : GCWIntegerListTextField(
                controller: _inputControllerEncode,
                hintText: i18n(context, 'beghilos_encode_hint'),
                onChanged: (text) {
                  setState(() {
                    _currentInputEncode = text;
                  });
                }),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    var rows = <Widget>[];
    var textOutput = _currentMode == GCWSwitchPosition.left
        ? decodeBeghilos(_currentInputDecode)
        : encodeBeghilos(_currentInputEncode['text']);

    if (textOutput == null || textOutput.isEmpty) return GCWDefaultOutput();

    _currentDisplays = encodeSegment(
        _currentMode == GCWSwitchPosition.left ? textOutput : _currentInputEncode['text'], SegmentDisplayType.SEVEN);

    rows.add(SegmentDisplayOutput(
        upsideDownButton: true,
        segmentFunction: (displayedSegments, readOnly) {
          return SevenSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: _currentDisplays,
        readOnly: true));

    rows.add(GCWDefaultOutput(child: textOutput));

    return Column(
      children: rows,
    );
  }
}
