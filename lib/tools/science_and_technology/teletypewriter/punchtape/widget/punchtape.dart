import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/logic/punchtape.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output.dart';

class TeletypewriterPunchTape extends StatefulWidget {
  @override
  TeletypewriterPunchTapeState createState() => TeletypewriterPunchTapeState();
}

class TeletypewriterPunchTapeState extends State<TeletypewriterPunchTape> {
  String _currentEncodeInput = '';
  TextEditingController _encodeController;

  var _decodeInputController;
  var _currentDecodeInput = '';

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right; // encrypt - decrypt
  var _currentOrderMode = GCWSwitchPosition.right; // 54321 - 12345
  var _currentDecodeMode = GCWSwitchPosition.right; // text - visual
  var _currentDecodeTextMode = GCWSwitchPosition.right; // decimal - binary

  var _currentCode = TeletypewriterCodebook.BAUDOT;

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
        value: _currentCode,
        onChanged: (value) {
          setState(() {
            _currentCode = value;
          });
        },
        items: ALL_CODES_CODEBOOK.entries.map((mode) {
          return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value['title']),
              subtitle: mode.value['subtitle'] != null ? i18n(context, mode.value['subtitle']) : null);
        }).toList(),
      ),
      if (!(_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5))
        GCWTwoOptionsSwitch(
          // 54321 - 12345
          value: _currentOrderMode,
          leftValue: i18n(context, 'punchtape_mode_binary'),
          rightValue: i18n(context, 'punchtape_mode_original'),
          onChanged: (value) {
            setState(() {
              _currentOrderMode = value;
            });
          },
        ),
      GCWTwoOptionsSwitch(
        // encrypt - decrypt
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
            if (_currentDecodeMode == GCWSwitchPosition.right) // visual mode
              _buildVisualDecryption()
            else // decode text
              Column(children: <Widget>[
                GCWTwoOptionsSwitch(
                  value: _currentDecodeTextMode,
                  leftValue: i18n(context, 'telegraph_decode_textmodedecimal'),
                  rightValue: i18n(context, 'telegraph_decode_textmodebinary'),
                  onChanged: (value) {
                    setState(() {
                      _currentDecodeTextMode = value;
                    });
                  },
                ),
                if (_currentDecodeTextMode == GCWSwitchPosition.right)
                  GCWTextField(
                    controller: _decodeInputController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[ 01]')),
                    ],
                    onChanged: (text) {
                      setState(() {
                        _currentDecodeInput = text;
                      });
                    },
                  )
                else
                  GCWTextField(
                    controller: _decodeInputController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[ 0123456789]')),
                    ],
                    onChanged: (text) {
                      setState(() {
                        _currentDecodeInput = text;
                      });
                    },
                  )
              ]),
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
          width: 340,
          height: 70,
          padding: EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: PUNCHTAPESegmentDisplay(
                  _currentCode,
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
    return PunchtapeSegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly, codeBook) {
          return PUNCHTAPESegmentDisplay(
            _currentCode,
            segments: displayedSegments,
            readOnly: readOnly,
          );
        },
        segments: segments,
        readOnly: true,
        codeBook: _currentCode);
  }

  String _decimalToBinary(String decimal, TeletypewriterCodebook language) {
    List<String> result = [];
    decimal.split(' ').forEach((decimalNumber) {
      result.add(convertBase(decimalNumber, 10, 2).padLeft(BINARY_LENGTH[language], '0'));
    });
    return result.join(' ');
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      List<List<String>> segments = encodePunchtape(
          _currentEncodeInput,
          _currentCode,
          (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
              ? false
              : (_currentOrderMode == GCWSwitchPosition.left));
      List<String> binaryList = [];
      List<String> decimalList = [];
      segments.forEach((segment) {
        binaryList.add(segments2binary(
            segment,
            _currentCode,
            (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
                ? false
                : (_currentOrderMode == GCWSwitchPosition.left)));
        decimalList.add(convertBase(
            segments2binary(
                segment,
                _currentCode,
                (_currentCode == TeletypewriterCodebook.BAUDOT_54123 ||
                        _currentCode == TeletypewriterCodebook.CCITT_IA5)
                    ? false
                    : (_currentOrderMode == GCWSwitchPosition.left)),
            2,
            10));
      });
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWOutput(
            title: i18n(context, 'telegraph_decode_textmodedecimal'),
            child: REVERSE_CODEBOOK.contains(_currentCode)
                ? _mirrorListOfBinaryToDecimal(binaryList)
                : decimalList.join(' '),
          ),
          GCWOutput(
            title: i18n(context, 'telegraph_decode_textmodebinary'),
            child: (_currentCode == TeletypewriterCodebook.BAUDOT_54123 ||
                    _currentCode == TeletypewriterCodebook.CCITT_IA5)
                ? binaryList.join(' ')
                : (_currentOrderMode == GCWSwitchPosition.left)
                    ? binaryList.join(' ')
                    : _mirrorListOfBinary(binaryList),
          )
        ],
      );
    } else {
      //decode
      var segments;
      if (_currentDecodeMode == GCWSwitchPosition.left) {
        // decode text mode
        if (_currentDecodeTextMode == GCWSwitchPosition.left) {
          // input decimal
          segments = decodeTextPunchtape(
              _decimalToBinary(_currentDecodeInput, _currentCode),
              _currentCode,
              (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
                  ? false
                  : (_currentOrderMode == GCWSwitchPosition.left));
        } else {
          // input binary
          segments = decodeTextPunchtape(
              _mirrorListOfBinary(_currentDecodeInput.split(' ')),
              _currentCode,
              (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
                  ? false
                  : (_currentOrderMode == GCWSwitchPosition.left));
        }
      } else {
        // decode visual mode
        var output = _currentDisplays.map((character) {
          if (character != null) return character.join('');
        }).toList();
        segments = decodeVisualPunchtape(
            output,
            _currentCode,
            (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
                ? false
                : (_currentOrderMode == GCWSwitchPosition.right));
      }
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments['displays']),
          GCWDefaultOutput(child: segments['text']),
        ],
      );
    }
  }
}

String _mirrorListOfBinaryToDecimal(List<String> binaryList) {
  List<String> result = [];
  binaryList.forEach((element) {
    result.add(convertBase(element.split('').reversed.join(''), 2, 10));
  });
  return result.join(' ');
}

String _mirrorListOfBinary(List<String> binaryList) {
  List<String> result = [];
  binaryList.forEach((element) {
    result.add(element.split('').reversed.join(''));
  });
  return result.join(' ');
}
