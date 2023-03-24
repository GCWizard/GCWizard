import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
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
import 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/logic/edelcrantz_telegraph.dart';

part 'package:gc_wizard/tools/science_and_technology/telegraphs/edelcrantz/widget/edelcrantz_segment_display.dart';

class EdelcrantzTelegraph extends StatefulWidget {
  const EdelcrantzTelegraph({Key? key}) : super(key: key);

  @override
  EdelcrantzTelegraphState createState() => EdelcrantzTelegraphState();
}

class EdelcrantzTelegraphState extends State<EdelcrantzTelegraph> {
  var _currentEncodeInput = '';
  late TextEditingController _encodeInputController;

  late TextEditingController _decodeInputController;
  var _currentDecodeInput = '';

  var _currentLanguage = EdelcrantzCodebook.YEAR_1795;

  var _currentDisplays = Segments.Empty();
  var _currentMode = GCWSwitchPosition.right; //decode
  var _currentTime = GCWSwitchPosition.left; // daytime
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
      GCWDropDown<EdelcrantzCodebook>(
        value: _currentLanguage,
        onChanged: (value) {
          setState(() {
            _currentLanguage = value;
          });
        },
        items: MURRAY_CODEBOOK.entries.map((mode) {
          return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value.title),
              subtitle: i18n(context, mode.value.subtitle));
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
      GCWTwoOptionsSwitch(
        value: _currentTime,
        leftValue: i18n(context, 'telegraph_edelcrantz_day'),
        rightValue: i18n(context, 'telegraph_edelcrantz_night'),
        onChanged: (value) {
          setState(() {
            _currentTime = value;
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
                FilteringTextInputFormatter.allow(RegExp(r'[aA 0-9]')),
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
                child: _EdelcrantzSegmentDisplay(
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
            resultElement = ['a1', 'a2'];
            break;
          case '4':
            resultElement = ['a3'];
            break;
          case '5':
            resultElement = ['a3', 'a1'];
            break;
          case '6':
            resultElement = ['a3', 'a2'];
            break;
          case '7':
            resultElement = ['a3', 'a2', 'a1'];
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
            resultElement.addAll(['b1', 'b2']);
            break;
          case '4':
            resultElement.addAll(['b3']);
            break;
          case '5':
            resultElement.addAll(['b3', 'b1']);
            break;
          case '6':
            resultElement.addAll(['b3', 'b2']);
            break;
          case '7':
            resultElement.addAll(['b3', 'b2', 'b1']);
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
            resultElement.addAll(['c1', 'c2']);
            break;
          case '4':
            resultElement.addAll(['c3']);
            break;
          case '5':
            resultElement.addAll(['c3', 'c1']);
            break;
          case '6':
            resultElement.addAll(['c3', 'c2']);
            break;
          case '7':
            resultElement.addAll(['c3', 'c2', 'c1']);
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
    return text
        .replaceAll('telegraph_edelcrantz_a_museum_messagereceived',
            i18n(context, 'telegraph_edelcrantz_a_museum_messagereceived'))
        .replaceAll('telegraph_edelcrantz_a_museum_doyoucopy', i18n(context, 'telegraph_edelcrantz_a_museum_doyoucopy'))
        .replaceAll(
            'telegraph_edelcrantz_a_museum_understood', i18n(context, 'telegraph_edelcrantz_a_museum_understood'))
        .replaceAll(
            'telegraph_edelcrantz_a_museum_repeatmessage', i18n(context, 'telegraph_edelcrantz_a_museum_repeatmessage'))
        .replaceAll('telegraph_edelcrantz_a_museum_endcommunication',
            i18n(context, 'telegraph_edelcrantz_a_museum_endcommunication'))
        .replaceAll('telegraph_edelcrantz_a_museum_whoamitalkingto',
            i18n(context, 'telegraph_edelcrantz_a_museum_whoamitalkingto'))
        .replaceAll(
            'telegraph_edelcrantz_a_museum_tellmemore', i18n(context, 'telegraph_edelcrantz_a_museum_tellmemore'))
        .replaceAll('telegraph_edelcrantz_a_museum_yes', i18n(context, 'telegraph_edelcrantz_a_museum_yes'))
        .replaceAll('telegraph_edelcrantz_a_museum_no', i18n(context, 'telegraph_edelcrantz_a_museum_no'))
        .replaceAll('telegraph_edelcrantz_a_museum_maybe', i18n(context, 'telegraph_edelcrantz_a_museum_maybe'))
        .replaceAll('telegraph_edelcrantz_a_museum_who', i18n(context, 'telegraph_edelcrantz_a_museum_who'))
        .replaceAll('telegraph_edelcrantz_a_museum_when', i18n(context, 'telegraph_edelcrantz_a_museum_when'))
        .replaceAll('telegraph_edelcrantz_a_museum_where', i18n(context, 'telegraph_edelcrantz_a_museum_where'))
        .replaceAll('telegraph_edelcrantz_a_museum_why', i18n(context, 'telegraph_edelcrantz_a_museum_why'))
        .replaceAll('telegraph_edelcrantz_a_museum_how', i18n(context, 'telegraph_edelcrantz_a_museum_how'))
        .replaceAll('telegraph_edelcrantz_a_museum_what', i18n(context, 'telegraph_edelcrantz_a_museum_what'))
        .replaceAll('telegraph_edelcrantz_a_museum_first', i18n(context, 'telegraph_edelcrantz_a_museum_first'))
        .replaceAll('telegraph_edelcrantz_a_museum_second', i18n(context, 'telegraph_edelcrantz_a_museum_second'))
        .replaceAll('telegraph_edelcrantz_a_museum_third', i18n(context, 'telegraph_edelcrantz_a_museum_third'))
        .replaceAll('telegraph_edelcrantz_a_museum_former', i18n(context, 'telegraph_edelcrantz_a_museum_former'))
        .replaceAll('telegraph_edelcrantz_a_museum_latter', i18n(context, 'telegraph_edelcrantz_a_museum_latter'));
  }

  Widget _buildDigitalOutput(Segments segments) {
    segments = _buildShutters(segments);
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return _EdelcrantzSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeEdelcrantzTelegraph(
          _currentEncodeInput.toLowerCase(), _currentLanguage, (_currentTime == GCWSwitchPosition.left));
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
        segments = decodeTextEdelcrantzTelegraph(
            _currentDecodeInput.toLowerCase(), _currentLanguage, (_currentTime == GCWSwitchPosition.left));
      } else {
        // visual
        var output = _currentDisplays.buildOutput();
        segments = decodeVisualEdelcrantzTelegraph(output, _currentLanguage, (_currentTime == GCWSwitchPosition.left));
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
