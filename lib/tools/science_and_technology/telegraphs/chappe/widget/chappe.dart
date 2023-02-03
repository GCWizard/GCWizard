import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/logic/chappe.dart';

part 'package:gc_wizard/tools/science_and_technology/telegraphs/chappe/widget/chappe_segment_display.dart';

class ChappeTelegraph extends StatefulWidget {
  @override
  ChappeTelegraphState createState() => ChappeTelegraphState();
}

class ChappeTelegraphState extends State<ChappeTelegraph> {
  String _currentEncodeInput = '';
  TextEditingController _encodeController;

  TextEditingController _decodeInputController;
  String _currentDecodeInput = '';

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right;
  var _currentDecodeMode = GCWSwitchPosition.right; // text - visual

  var _currentLanguage = ChappeCodebook.ALPHABET;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeInputController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeInputController.dispose();

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
        items: CHAPPE_CODEBOOK.entries.map((mode) {
          return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value['title']),
              subtitle: mode.value['subtitle'] != null ? i18n(context, mode.value['subtitle']) : null);
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
          children: <Widget>[
            GCWTwoOptionsSwitch(
              value: _currentDecodeMode,
              leftValue: i18n(context, 'telegraph_decode_textmode'),
              rightValue: i18n(context, 'telegraph_decode_visualmode'),
              onChanged: (value) {
                setState(() {
                  _currentDecodeMode = value;
                });
              },
            ),
            if (_currentDecodeMode == GCWSwitchPosition.right) // decode visual mode
              _buildVisualDecryption()
            else // decode text mode
              GCWTextField(
                controller: _decodeInputController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[ 0-9]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              )
          ],
        ),
      _buildOutput()
    ]);
  }

  _buildVisualDecryption() {
    Map<String, bool> currentDisplay;

    var displays = _currentDisplays;
    if (displays != null && displays.length > 0)
      currentDisplay = Map<String, bool>.fromIterable(displays.last ?? [], key: (e) => e, value: (e) => true);
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
          width: 300,
          //height: 200,
          padding: EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _ChappeTelegraphSegmentDisplay(
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
          return _ChappeTelegraphSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      List<List<String>> segments = encodeChappe(_currentEncodeInput, _currentLanguage);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
        ],
      );
    } else {
      //decode
      var segments;
      if (_currentDecodeMode == GCWSwitchPosition.left) {
        // decode text mode
        segments = decodeTextChappeTelegraph(_currentDecodeInput.toUpperCase(), _currentLanguage);
      } else {
        // decode visual mode
        var output = _currentDisplays.map((character) {
          if (character != null) return character.join();
        }).toList();
        segments = decodeVisualChappe(output, _currentLanguage);
      }
      return Column(
        children: <Widget>[
          GCWOutput(title: i18n(context, 'telegraph_text'), child: segments['chars']),
          _buildDigitalOutput(segments['displays']),
        ],
      );
    }
  }
}
