import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
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
import 'package:gc_wizard/tools/science_and_technology/telegraphs/prussia_telegraph/logic/prussian_telegraph.dart';

part 'package:gc_wizard/tools/science_and_technology/telegraphs/prussia_telegraph/widget/prussia_telegraph_segment_display.dart';

class PrussiaTelegraph extends StatefulWidget {
  const PrussiaTelegraph({Key? key}) : super(key: key);

  @override
  _PrussiaTelegraphState createState() => _PrussiaTelegraphState();
}

class _PrussiaTelegraphState extends State<PrussiaTelegraph> {
  var _currentEncodeInput = '';
  late TextEditingController _encodeInputController;

  late TextEditingController _decodeInputController;
  var _currentDecodeInput = '';

  var _currentDisplays = Segments.Empty();
  var _currentMode = GCWSwitchPosition.right;
  var _currentDecodeMode = GCWSwitchPosition.right; // text - visual

  @override
  void initState() {
    super.initState();

    _encodeInputController = TextEditingController(text: _currentEncodeInput);
    _decodeInputController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeInputController.dispose();
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
          controller: _encodeInputController,
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
                FilteringTextInputFormatter.allow(RegExp(r'[aAbBcC. 0-9]')),
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
          padding: const EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: PrussiaTelegraphSegmentDisplay(
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

  Segments _buildShutters(Segments segments) {
    List<List<String>> result = [];
    for (var element in segments.displays) {
      if (int.tryParse(element.join('')) != null) {
        List<String> resultElement = [];
        switch (element[0]) {
          case '0':
            resultElement = [];
            break;
          case '1':
            resultElement = ['a1'];
            break;
          case '2':
            resultElement = ['a2'];
            break;
          case '3':
            resultElement = ['a3'];
            break;
          case '4':
            resultElement = ['a4'];
            break;
          case '5':
            resultElement = ['a5'];
            break;
          case '6':
            resultElement = ['a6'];
            break;
          case '7':
            resultElement = ['a1', 'a6'];
            break;
          case '8':
            resultElement = ['a2', 'a6'];
            break;
          case '9':
            resultElement = ['a3', 'a6'];
            break;
        }
        switch (element[1]) {
          case '1':
            resultElement.addAll(['b1']);
            break;
          case '2':
            resultElement.addAll(['b2']);
            break;
          case '3':
            resultElement.addAll(['b3']);
            break;
          case '4':
            resultElement.addAll(['b4']);
            break;
          case '5':
            resultElement.addAll(['b5']);
            break;
          case '6':
            resultElement.addAll(['b6']);
            break;
          case '7':
            resultElement.addAll(['b1', 'b6']);
            break;
          case '8':
            resultElement.addAll(['b2', 'b6']);
            break;
          case '9':
            resultElement.addAll(['b3', 'b6']);
            break;
        }
        switch (element[2]) {
          case '1':
            resultElement.addAll(['c1']);
            break;
          case '2':
            resultElement.addAll(['c2']);
            break;
          case '3':
            resultElement.addAll(['c3']);
            break;
          case '4':
            resultElement.addAll(['c4']);
            break;
          case '5':
            resultElement.addAll(['c5']);
            break;
          case '6':
            resultElement.addAll(['c6']);
            break;
          case '7':
            resultElement.addAll(['c1', 'c6']);
            break;
          case '8':
            resultElement.addAll(['c2', 'c6']);
            break;
          case '9':
            resultElement.addAll(['c3', 'c6']);
            break;
        }
        result.add(resultElement);
      } else {
        result.add(element);
      }
    }
    return Segments(displays: result);
  }

  String _buildCodelets(Segments segments) {
    List<String> result = [];
    for (var codelet in segments.displays) {
      result.add(codelet.join(''));
    }
    return result.join(' ');
  }

  String _segmentsToText(String text) {
    return text;
  }

  Widget _buildDigitalOutput(Segments segments) {
    segments = _buildShutters(segments);
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return PrussiaTelegraphSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodePrussianTelegraph(_currentEncodeInput.toUpperCase());
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWTextDivider(
            text: i18n(context, 'telegraph_codepoints'),
          ),
          GCWOutputText(
            text: _buildCodelets(segments),
          )
        ],
      );
    } else {
      //decode
      SegmentsText segments;
      if (_currentDecodeMode == GCWSwitchPosition.left) {
        // text
        segments = decodeTextPrussianTelegraph(_currentDecodeInput.toUpperCase());
      } else {
        // visual
        var output = _currentDisplays.buildOutput();
        segments = decodeVisualPrussianTelegraph(output);
      }
      return Column(
        children: <Widget>[
          GCWOutput(title: i18n(context, 'telegraph_text'), child: _segmentsToText(segments.text)),
          _buildDigitalOutput(segments),
        ],
      );
    }
  }
}
