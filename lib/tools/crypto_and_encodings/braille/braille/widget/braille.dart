import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/braille_euro_segment_display/widget/braille_euro_segment_display.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/logic/braille.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/widget/braille_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';

class Braille extends StatefulWidget {
  @override
  BrailleState createState() => BrailleState();
}

class BrailleState extends State<Braille> {
  String _currentEncodeInput = '';
  TextEditingController _encodeController;

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right;

  var _currentLanguage = BrailleLanguage.SIMPLE;

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
      GCWDropDown(
        value: _currentLanguage,
        onChanged: (value) {
          setState(() {
            _currentLanguage = value;
          });
        },
        items: BRAILLE_LANGUAGES.entries.map((mode) {
          return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value['title']),
              subtitle: mode.value['subtitle'] != null
                  ? i18n(context, mode.value['subtitle'])
                  : null);
        }).toList(),
      ),
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      if (_currentMode ==
          GCWSwitchPosition.left) // encrypt: input number => output segment
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

  _buildVisualDecryption() {
    Map<String, bool> currentDisplay;

    var displays = _currentDisplays;
    if (displays != null && displays.length > 0)
      currentDisplay = Map<String, bool>.fromIterable(displays.last ?? [],
          key: (e) => e, value: (e) => true);
    else
      currentDisplay = {};

    var onChanged = (Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        newSegments.sort();

        if (_currentDisplays.length == 0) _currentDisplays.add([]);

        _currentDisplays[_currentDisplays.length - 1] = newSegments;
      });
    };

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          height: 200,
          padding: EdgeInsets.only(
              top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              if (_currentLanguage == BrailleLanguage.EUR)
                Expanded(
                  child: BrailleEuroSegmentDisplay(
                    segments: currentDisplay,
                    onChanged: onChanged,
                  ),
                )
              else
                Expanded(
                  child: BrailleSegmentDisplay(
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
                _currentDisplays.add([]);
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                if (_currentDisplays.length > 0) _currentDisplays.removeLast();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = [];
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          if (_currentLanguage == BrailleLanguage.EUR)
            return BrailleEuroSegmentDisplay(
                segments: displayedSegments, readOnly: readOnly);
          else
            return BrailleSegmentDisplay(
                segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      List<List<String>> segments =
          encodeBraille(_currentEncodeInput, _currentLanguage);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWOutput(
              title: i18n(context, 'braille_output_numbers'),
              child: segments.map((segment) => segment.join()).join(' '))
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.map((character) {
        if (character != null) return character.join();
      }).toList();
      var segments = decodeBraille(output, _currentLanguage, false);
      var segmentsBasicDigits =
          decodeBraille(output, BrailleLanguage.BASIC, false);
      var segmentsBasicLetters =
          decodeBraille(output, BrailleLanguage.BASIC, true);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments['displays']),
          if (_currentLanguage == BrailleLanguage.SIMPLE)
            Column(
              children: [
                GCWDefaultOutput(
                    child: _normalizeChars(segments['chars'].join())),
                if (segmentsBasicLetters['chars'].join().toUpperCase() !=
                    segments['chars'].join())
                  GCWOutput(
                    title: i18n(context, 'brailledotnumbers_basic_letters'),
                    child: segmentsBasicLetters['chars'].join().toUpperCase(),
                  ),
                if (segmentsBasicDigits['chars'].join().toUpperCase() !=
                    segments['chars'].join())
                  GCWOutput(
                    title: i18n(context, 'brailledotnumbers_basic_digits'),
                    child: segmentsBasicDigits['chars'].join().toUpperCase(),
                  ),
              ],
            )
          else
            GCWDefaultOutput(child: segments['chars'].join()),
        ],
      );
    }
  }

  String _normalizeChars(String input) {
    if (input.endsWith('NUMBER FOLLOWS>'))
      return input
              .replaceAll('<NUMBER FOLLOWS>', '')
              .replaceAll('<ANTOINE NUMBER FOLLOWS>', '') +
          i18n(context, 'symboltables_braille_de_number_follows');
    else if (input.endsWith('ANTOINE NUMBER FOLLOWS>'))
      return input
              .replaceAll('<NUMBER FOLLOWS>', '')
              .replaceAll('<ANTOINE NUMBER FOLLOWS>', '') +
          i18n(context, 'symboltables_braille_en_mathmatics_follows');
    else
      return input
          .replaceAll('<NUMBER FOLLOWS>', '')
          .replaceAll('<ANTOINE NUMBER FOLLOWS>', '');
  }
}
