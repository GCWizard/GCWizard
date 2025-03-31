import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/fakoo/logic/fakoo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/fakoo/widget/fakoo_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';

class Fakoo extends StatefulWidget {
  const Fakoo({super.key});

  @override
  _FakooState createState() => _FakooState();
}

class _FakooState extends State<Fakoo> {
  String _currentEncodeInput = '';
  late TextEditingController _encodeController;

  Segments _currentDisplays = Segments.Empty();
  var _currentMode = GCWSwitchPosition.right;


  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      if (_currentMode == GCWSwitchPosition.left) // encrypt: input number => output segment
        GCWTextField(
          controller: _encodeController,
          onChanged: (text) {
            setState(() {
              _currentEncodeInput = text;
            });
          },
        )
      else
        Column(
          // decrpyt: input segment => output number
          children: <Widget>[_buildVisualDecryption()],
        ),
      _buildOutput()
    ]);
  }

  Widget _buildVisualDecryption() {
    var currentDisplay = buildSegmentMap(_currentDisplays);

    onChanged(Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        _currentDisplays.replaceLastSegment(newSegments);
      });
    }

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          height: 200,
          padding: const EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FakooSegmentDisplay(
                  segments: currentDisplay,
                  onChanged: onChanged,
                ),
              )
            ],
          ),
        ),
        GCWToolBar(children: [
          GCWIconButton(
            icon: Icons.space_bar,
            onPressed: () {
              setState(() {
                _currentDisplays.addEmptySegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                _currentDisplays.removeLastSegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = Segments.Empty();
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(Segments segments) {
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return FakooSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeBraille(_currentEncodeInput, _currentLanguage);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWOutput(title: i18n(context, 'braille_output_numbers'), child: segments.buildOutput().join(' '))
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.buildOutput();
      var segments = decodeFakoo(output);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
            Column(
              children: [
                GCWDefaultOutput(child: _normalizeChars(segments.chars.join())),
                if (segmentsBasicLetters.chars.join().toUpperCase() != segments.chars.join())
                  GCWOutput(
                    title: i18n(context, 'brailledotnumbers_basic_letters'),
                    child: segmentsBasicLetters.chars.join().toUpperCase(),
                  ),
                if (segmentsBasicDigits.chars.join().toUpperCase() != segments.chars.join())
                  GCWOutput(
                    title: i18n(context, 'brailledotnumbers_basic_digits'),
                    child: segmentsBasicDigits.chars.join().toUpperCase(),
                  ),
              ],
            )
        ],
      );
    }
  }

  String _normalizeChars(String input) {
    if (input.endsWith('NUMBER FOLLOWS>')) {
      return input.replaceAll('<NUMBER FOLLOWS>', '').replaceAll('<ANTOINE NUMBER FOLLOWS>', '') +
          i18n(context, 'symboltables_braille_de_number_follows');
    } else if (input.endsWith('ANTOINE NUMBER FOLLOWS>')) {
      return input.replaceAll('<NUMBER FOLLOWS>', '').replaceAll('<ANTOINE NUMBER FOLLOWS>', '') +
          i18n(context, 'symboltables_braille_en_mathmatics_follows');
    } else {
      return input.replaceAll('<NUMBER FOLLOWS>', '').replaceAll('<ANTOINE NUMBER FOLLOWS>', '');
    }
  }
}
