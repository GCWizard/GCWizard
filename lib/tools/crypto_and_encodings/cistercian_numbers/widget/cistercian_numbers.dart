// https://rosettacode.org/wiki/Cistercian_numerals
// https://www.unicode.org/L2/L2020/20290-cistercian-digits.pdf

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cistercian_numbers/logic/cistercian_numbers.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/tools/common/base/gcw_iconbutton/widget/gcw_iconbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_segmentdisplay_output/widget/gcw_segmentdisplay_output.dart';
import 'package:gc_wizard/tools/common/gcw_toolbar/widget/gcw_toolbar.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/cistercian_numbers_segment_display/widget/cistercian_numbers_segment_display.dart';

class CistercianNumbers extends StatefulWidget {
  @override
  CistercianNumbersState createState() => CistercianNumbersState();
}

class CistercianNumbersState extends State<CistercianNumbers> {
  final _DEFAULT_SEGMENT = ['k'];

  var _inputEncodeController;
  var _currentEncodeInput = '';
  List<List<String>> _currentDisplays;
  var _currentMode = GCWSwitchPosition.right; //encrypt decrypt

  @override
  void initState() {
    super.initState();

    _inputEncodeController = TextEditingController(text: _currentEncodeInput);
    _currentDisplays = [_DEFAULT_SEGMENT];
  }

  @override
  void dispose() {
    _inputEncodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_currentEncryptMode == GCWSwitchPosition.left;
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
          ? GCWTextField(
              controller: _inputEncodeController,
              onChanged: (text) {
                setState(() {
                  _currentEncodeInput = text;
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

  _buildVisualDecryption() {
    Map<String, bool> currentDisplay;

    var displays = _currentDisplays; //<List<String>>[];
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
                child: CistercianNumbersSegmentDisplay(
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
                _currentDisplays.add(_DEFAULT_SEGMENT);
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
                _currentDisplays = [_DEFAULT_SEGMENT];
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    return GCWSegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return CistercianNumbersSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeCistercian(_currentEncodeInput);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.map((character) {
        if (character != null) return character.join();
      }).join(' ');
      var segments = decodeCistercian(output);
      return Column(
        children: <Widget>[_buildDigitalOutput(segments['displays']), GCWDefaultOutput(child: segments['text'])],
      );
    }
  }
}
