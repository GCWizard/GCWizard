import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape/logic/punchtape.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output.dart';

class TeletypewriterPunchTape extends StatefulWidget {
  const TeletypewriterPunchTape({Key? key}) : super(key: key);

  @override
  _TeletypewriterPunchTapeState createState() => _TeletypewriterPunchTapeState();
}

class _TeletypewriterPunchTapeState extends State<TeletypewriterPunchTape> {
  String _currentEncodeInput = '';
  late TextEditingController _encodeController;

  late TextEditingController _decodeInputController;
  var _currentDecodeInput = '';

  var _currentDisplays = Segments.Empty();
  var _currentMode = GCWSwitchPosition.right; // encrypt - decrypt
  var _currentNumberMode = GCWSwitchPosition.right; // Letters & Numbers - Numbers only
  var _currentDecodeMode = GCWSwitchPosition.right; // text - visual
  var _currentDecodeTextMode = GCWSwitchPosition.right; // decimal - binary

  var _currentCode = TeletypewriterCodebook.BAUDOT_12345;

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
      GCWDropDown<TeletypewriterCodebook>(
        value: _currentCode,
        onChanged: (value) {
          setState(() {
            _currentCode = value;
          });
        },
        items: ALL_CODES_CODEBOOK.entries.map((mode) {
          return GCWDropDownMenuItem(
              value: mode.key, child: i18n(context, mode.value.title), subtitle: i18n(context, mode.value.subtitle));
        }).toList(),
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
              value: _currentNumberMode,
              leftValue: i18n(context, 'punchtape_mode_lettersandnumbers'),
              rightValue: i18n(context, 'punchtape_mode_numberonly'),
              onChanged: (value) {
                setState(() {
                  _currentNumberMode = value;
                });
              },
            ),
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
          width: 340,
          height: 70,
          padding: const EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
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

  Widget _buildOutputEncrypt() {
    var segments = encodePunchtape(
        _currentEncodeInput,
        _currentCode,
        (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
            ? false
            : true);
    List<String> binaryList = [];
    List<String?> decimalList = [];
    for (var segment in segments.displays) {
      binaryList.add(_segments2binary(
          segment,
          _currentCode,
          (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
              ? false
              : true));
      decimalList.add(convertBase(
          _segments2binary(
              segment,
              _currentCode,
              (_currentCode == TeletypewriterCodebook.BAUDOT_54123 || _currentCode == TeletypewriterCodebook.CCITT_IA5)
                  ? false
                  : true),
          2,
          10));
    }
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
          child: binaryList.join(' '),
        )
      ],
    );
  }

  Widget _buildOutputDecrypt() {
    PunchtapeOutput outputDecodePunchtape;

    String DecodeInput = _currentDecodeInput;

    if (_currentDecodeMode == GCWSwitchPosition.left) {
      // decode text mode
      if (_currentDecodeTextMode == GCWSwitchPosition.left) {
        // input decimal
        DecodeInput = _decimalToBinary(_currentDecodeInput, _currentCode);
      }
      outputDecodePunchtape = decodeTextPunchtape(
        DecodeInput,
        _currentCode,
        (_currentNumberMode == GCWSwitchPosition.right),
      );
    } else {
      // decode visual mode
      outputDecodePunchtape = decodeVisualPunchtape(
        _currentDisplays.displays,
        _currentCode,
        (_currentNumberMode == GCWSwitchPosition.right),
      );
    }

    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'common_output')),
        if (!(_currentCode == TeletypewriterCodebook.BAUDOT_54123))
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN * 2),
                      child: Column(
                        children: [
                          GCWTextDivider(
                              text: i18n(context, 'punchtape_mode_bitorder') +
                                  '\n' +
                                  i18n(context, CODEBOOK_BITS_54321[PUNCHTAPE_DEFINITION[_currentCode]?.punchHoles]!)),
                          GCWOutputText(text: outputDecodePunchtape.text54321),
                        ],
                      ))),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.only(left: DEFAULT_MARGIN * 2),
                      child: Column(children: [
                        GCWTextDivider(
                            text: i18n(context, 'punchtape_mode_bitorder') +
                                '\n' +
                                i18n(context, CODEBOOK_BITS_12345[PUNCHTAPE_DEFINITION[_currentCode]?.punchHoles]!)),
                        GCWOutputText(text: outputDecodePunchtape.text12345),
                      ]))),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(right: DEFAULT_MARGIN * 2),
                    child: Column(
                      children: [
                        GCWTextDivider(
                            text: i18n(context, 'punchtape_mode_baudot') +
                                '\n' +
                                i18n(context, 'punchtape_mode_bitorder_54123')),
                        GCWOutputText(text: outputDecodePunchtape.text54123),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.only(left: DEFAULT_MARGIN * 2, right: DEFAULT_MARGIN * 2),
                      child: Column(
                        children: [
                          GCWTextDivider(
                              text: i18n(context, 'punchtape_mode_bitorder') +
                                  '\n' +
                                  i18n(context, CODEBOOK_BITS_12345[5]!)),
                          GCWOutputText(text: outputDecodePunchtape.text12345),
                        ],
                      ))),
              Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.only(left: DEFAULT_MARGIN * 2),
                      child: Column(children: [
                        GCWTextDivider(
                            text: i18n(context, 'punchtape_mode_bitorder') +
                                '\n' +
                                i18n(context, CODEBOOK_BITS_54321[5]!)),
                        GCWOutputText(text: outputDecodePunchtape.text54321),
                      ]))),
            ],
          ),
        _buildDigitalOutput(Segments(displays: outputDecodePunchtape.displays)),
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      return _buildOutputEncrypt();
    } else {
      //decode
      return _buildOutputDecrypt();
    }
  }
}

String _mirrorListOfBinaryToDecimal(List<String> binaryList) {
  List<String?> result = [];
  for (var element in binaryList) {
    result.add(convertBase(element.split('').reversed.join(''), 2, 10));
  }
  return result.join(' ');
}

String _segments2binary(List<String> segments2convert, TeletypewriterCodebook language, bool order12345) {
  // [1,2,3,4,5] => 00000 ... 11111
  List<String> segments = [];
  if (order12345) {
    segments.addAll(segments2convert);
  } else {
    for (int i = 1; i < 9; i++) {
      if (segments2convert.contains(i.toString())) {
        segments.add(i.toString());
      }
    }
  }
  String result = '';
  for (int i = 1; i < 9; i++) {
    if (segments.contains(i.toString())) {
      result = result + '1';
    } else {
      result = result + '0';
    }
  }
  result = result.substring(0, BINARY_LENGTH[language]);

  return result;
}

String _decimalToBinary(String decimal, TeletypewriterCodebook language) {
  List<String?> result = [];
  decimal.split(' ').forEach((decimalNumber) {
    result.add(convertBase(decimalNumber, 10, 2).padLeft(BINARY_LENGTH[language]!, '0'));
  });
  return result.join(' ');
}
