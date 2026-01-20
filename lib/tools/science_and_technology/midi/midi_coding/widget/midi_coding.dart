import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/midi_coding/logic/midi_coding.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';

class MIDICoding extends StatefulWidget {
  const MIDICoding({super.key});

  @override
  MIDICodingState createState() => MIDICodingState();
}

class MIDICodingState extends State<MIDICoding> {
  late TextEditingController _decodeController;
  late TextEditingController _encodeController;

  String _currentEncodeInput = '';
  String _currentDecodeInput = '';

  int _currentType = 0;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  Uint8List _MIDINotesImage = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentEncodeInput);
    _encodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    _encodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _calculateOutput();
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                    _calculateOutput();
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                    _calculateOutput();
                  });
                },
              ),
        GCWDropDown(
          title: i18n(context, 'common_type'),
          items: MIDI_CODING.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
          value: _currentType,
          onChanged: (value) {
            setState(() {
              _currentType = value;
              _calculateOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput()),
        (_currentMode == GCWSwitchPosition.left)
            ? Column(
                children: [
                  GCWButton(
                    onPressed: () {
                      setState(() {
                        MIDINotes2Image(
                          _currentEncodeInput,
                        ).then((value) {
                          setState(() {
                            _MIDINotesImage = value;
                          });
                        });
                      });
                    },
                    text: i18n(context, 'midi_coding_create_graphic'),
                  ),
                  _WidgetGraphicEncodeOutput()
                ],
        )
            : Container()
      ],
    );
  }

  Widget _WidgetGraphicEncodeOutput() {
    if (_MIDINotesImage.isEmpty) {
      return Container();
    }
    else {
      return GCWOutput(
          title: i18n(context, 'midi_coding_graphic'),
          child: GCWImageView(
            imageData: GCWImageViewData(GCWFile(bytes: _MIDINotesImage)),
            suppressOpenInTool: const {GCWImageViewOpenInTools.METADATA, GCWImageViewOpenInTools.HIDDENDATA},
          ));
    }
  }

  String _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return encodeMIDI(_currentEncodeInput, _currentType);
    } else {
      return decodeMIDI(_currentDecodeInput, _currentType);
    }
  }
}
