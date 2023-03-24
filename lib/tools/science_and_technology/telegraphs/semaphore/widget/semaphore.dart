import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/semaphore/logic/semaphore.dart';

part 'package:gc_wizard/tools/science_and_technology/telegraphs/semaphore/widget/semaphore_segment_display.dart';

class SemaphoreTelegraph extends StatefulWidget {
  const SemaphoreTelegraph({Key? key}) : super(key: key);

  @override
  SemaphoreTelegraphState createState() => SemaphoreTelegraphState();
}

class SemaphoreTelegraphState extends State<SemaphoreTelegraph> {
  String _currentEncodeInput = '';
  late TextEditingController _encodeController;

  var _currentDisplays = Segments.Empty();
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
                child: _SemaphoreSegmentDisplay(
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
          return _SemaphoreSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeSemaphore(_currentEncodeInput);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.buildOutput();
      var segments = decodeSemaphore(output);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWDefaultOutput(child: _normalize(segments.chars.join(''))),
        ],
      );
    }
  }

  String _normalize(String input) {
    return input
        .replaceAll('symboltables_semaphore_cancel', ' ' + i18n(context, 'symboltables_semaphore_cancel') + ' ')
        .replaceAll('symboltables_semaphore_correct', ' ' + i18n(context, 'symboltables_semaphore_correct') + ' ')
        .replaceAll('symboltables_semaphore_error', ' ' + i18n(context, 'symboltables_semaphore_error') + ' ')
        .replaceAll('symboltables_semaphore_attention', ' ' + i18n(context, 'symboltables_semaphore_attention') + ' ')
        .replaceAll('symboltables_semaphore_letters_following',
            ' ' + i18n(context, 'symboltables_semaphore_letters_following') + ' ')
        .replaceAll('symboltables_semaphore_numerals_following',
            ' ' + i18n(context, 'symboltables_semaphore_numerals_following') + ' ')
        .replaceAll('symboltables_semaphore_rest', ' ' + i18n(context, 'symboltables_semaphore_rest') + ' ')
        .trim();
  }
}
