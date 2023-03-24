import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/logic/shadoks_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/shadoks_numbers/widget/shadoks_numbers_segment_display.dart';

class ShadoksNumbers extends StatefulWidget {
  const ShadoksNumbers({Key? key}) : super(key: key);

  @override
  ShadoksNumbersState createState() => ShadoksNumbersState();
}

class ShadoksNumbersState extends State<ShadoksNumbers> {
  static const Map<String, String> _segmentToWord = {
    'a': 'GA',
    'b': 'BU',
    'bc': 'ZO',
    'bcd': 'MEU',
  };

  var _currentEncodeInput = 0;

  var _currentDisplays = Segments.Empty();
  var _currentMode = GCWSwitchPosition.right;

  Map<String, bool> _currentDisplay = {};

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
      _currentMode == GCWSwitchPosition.left // encrypt: input number => output segment
          ? GCWIntegerSpinner(
              min: 0,
              value: _currentEncodeInput,
              onChanged: (value) {
                setState(() {
                  _currentEncodeInput = value;
                });
              },
            )
          : Column(
              // decrpyt: input segment => output number
              children: <Widget>[_buildVisualDecryption()],
            ),
      _buildOutput()
    ]);
  }

  Widget _buildVisualDecryption() {
    onChanged(Map<String, bool> d) {
      setState(() {
        _currentDisplay = d;

        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });
        newSegments.remove('a');
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
                child: _ShadoksNumbersSegmentDisplay(
                  segments: _currentDisplay,
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
                _currentDisplays.displays.add(['a']);
                _currentDisplay = {'a': true};
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                _currentDisplays.removeLastSegment();

                if (_currentDisplays.displays.isNotEmpty) {
                  _currentDisplay = {};
                  for (var element in _currentDisplays.displays.last) {
                    _currentDisplay.putIfAbsent(element, () => true);
                  }
                  _currentDisplay.putIfAbsent('a', () => false);
                } else {
                  _currentDisplays = Segments(displays: [['a']]);
                  _currentDisplay = {'a': true};
                }
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = Segments(displays: [['a']]);
                _currentDisplay = {'a': true};
              });
            },
          )
        ])
      ],
    );
  }

  String _segmentsToShadoks(Segments segments) {
    String result = '';
    for (var element in segments.displays) {
      result = result + (_segmentToWord[element.join('')] ?? '');
    }
    return result;
  }

  NSegmentDisplay _SanatizedShadoksNumbersSegmentDisplay({required Map<String, bool> segments, required bool readOnly}) {
    segments.putIfAbsent('a', () => false);
    return _ShadoksNumbersSegmentDisplay(segments: segments, readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeShadoksNumbers(_currentEncodeInput);

      return Column(
        children: <Widget>[
          SegmentDisplayOutput(
              segmentFunction: (displayedSegments, readOnly) {
                return _SanatizedShadoksNumbersSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
              },
              segments: segments,
              readOnly: true),
          GCWOutput(
              title: i18n(context, 'shadoksnumbers_single_numbers'),
              child: _segmentsToShadoks(segments)
                  .replaceAll('GA', '0')
                  .replaceAll('BU', '1')
                  .replaceAll('ZO', '2')
                  .replaceAll('MEU', '3')),
          GCWOutput(title: i18n(context, 'shadoksnumbers_shadoks'), child: _segmentsToShadoks(segments))
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.buildOutput();

      var segments = decodeShadoksNumbers(output);

      return Column(
        children: <Widget>[
          SegmentDisplayOutput(
              segmentFunction: (displayedSegments, readOnly) {
                return _SanatizedShadoksNumbersSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
              },
              segments: segments,
              readOnly: true),
          GCWOutput(title: i18n(context, 'shadoksnumbers_single_numbers'), child: segments.numbers.join(' ')),
          GCWOutput(title: i18n(context, 'shadoksnumbers_quaternary'), child: segments.quaternary),
          GCWOutput(title: i18n(context, 'shadoksnumbers_shadoks'), child: segments.shadoks)
        ],
      );
    }
  }
}
