import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/ohlsen_telegraph/logic/ohlsen_telegraph.dart';

part 'package:gc_wizard/tools/science_and_technology/telegraphs/ohlsen_telegraph/widget/ohlsen_segment_display.dart';

class OhlsenTelegraph extends StatefulWidget {
  @override
  OhlsenTelegraphState createState() => OhlsenTelegraphState();
}

class OhlsenTelegraphState extends State<OhlsenTelegraph> {
  var _currentEncodeInput = '';
  var _dncodeInputController;

  var _decodeInputController;
  var _currentDecodeInput = '';

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right; //decode
  var _currentDecodeMode = GCWSwitchPosition.right; // text - visual

  @override
  void initState() {
    super.initState();

    _dncodeInputController = TextEditingController(text: _currentEncodeInput);
    _decodeInputController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _dncodeInputController.dispose();
    _decodeInputController.dispose();

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
      if (_currentMode == GCWSwitchPosition.left) // encrypt
        GCWTextField(
          controller: _dncodeInputController,
          onChanged: (text) {
            setState(() {
              _currentEncodeInput = text;
            });
          },
        )
      else
        Column(// decryt
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
          if (_currentDecodeMode == GCWSwitchPosition.right) // visual mode
            _buildVisualDecryption()
          else // decode text
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
        ]),
      _buildOutput()
    ]);
  }

  Widget _buildVisualDecryption() {
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
          width: 180,
          padding: EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _OhlsenSegmentDisplay(
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

  String _buildCodelets(List<List<String>> segments) {
    List<String> result = [];
    segments.forEach((codelet) {
      if (codelet != null) result.add(codelet.join(''));
    });
    return result.join(' ');
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return _OhlsenSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      List<List<String>> segments = encodeOhlsenTelegraph(_currentEncodeInput.toLowerCase());
      List<String> code = [];
      segments.forEach((element) {
        code.add(segmentToCode(element));
      });
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWTextDivider(
            text: i18n(context, 'telegraph_codepoints'),
          ),
          GCWOutputText(
            //text: _buildCodelets(segments),
            text: code.join(' '),
          )
        ],
      );
    } else {
      //decode
      var segments;
      if (_currentDecodeMode == GCWSwitchPosition.left) {
        // text
        segments = decodeTextOhlsenTelegraph(_currentDecodeInput.toLowerCase());
      } else {
        // visual
        var output = _currentDisplays.map((character) {
          if (character != null) return character.join();
        }).toList();
        segments = decodeVisualOhlsenTelegraph(output);
      }
      return Column(
        children: <Widget>[
          if (_currentDecodeMode == GCWSwitchPosition.right)
            GCWOutput(title: i18n(context, 'telegraph_codepoints'), child: segments['codepoints']),
          GCWOutput(title: i18n(context, 'telegraph_text'), child: segments['text']),
          _buildDigitalOutput(segments['displays']),
        ],
      );
    }
  }
}
