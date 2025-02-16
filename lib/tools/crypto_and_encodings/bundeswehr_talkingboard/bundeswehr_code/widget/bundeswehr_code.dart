import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/logic/bundeswehr_auth.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_code/logic/bundeswehr_code.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:intl/intl.dart';

class BundeswehrTalkingBoardObfuscation extends StatefulWidget {
  const BundeswehrTalkingBoardObfuscation({Key? key}) : super(key: key);

  @override
  _BundeswehrTalkingBoardObfuscationState createState() =>
      _BundeswehrTalkingBoardObfuscationState();
}

class _BundeswehrTalkingBoardObfuscationState
    extends State<BundeswehrTalkingBoardObfuscation> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;
  late TextEditingController _numeralCodeCustomXaxis;
  late TextEditingController _numeralCodeCustomYaxis;

  String _currentEncode = '';
  String _currentDecode = '';
  String _currentNumeralCodeXaxisCustom = '';
  String _currentNumeralCodeYaxisCustom = '';

  BundeswehrTalkingBoardAuthentificationTable? _tableNumeralCode;

  String _numeralCodeString = '';

  bool _contentToSave = false;
  TABLE_SOURCE _tableSource = TABLE_SOURCE.NONE;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentTableMode = GCWSwitchPosition.left;

  final _cryptedTextMaskFormatter = GCWMaskTextInputFormatter(
      mask: '## ' * 1000 + '##', filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeyXAxisCodeMaskFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeYAxisCodeMaskFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncode);
    _decodeController = TextEditingController(text: _currentDecode);
    _numeralCodeCustomXaxis =
        TextEditingController(text: _currentNumeralCodeXaxisCustom);
    _numeralCodeCustomYaxis =
        TextEditingController(text: _currentNumeralCodeYaxisCustom);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();
    _numeralCodeCustomXaxis.dispose();
    _numeralCodeCustomYaxis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right
            ? GCWTextField(
                controller: _decodeController,
                inputFormatters: [_cryptedTextMaskFormatter],
                hintText: 'AB EF HG IJ MA ...',
                onChanged: (text) {
                  setState(() {
                    _currentDecode = (text.isEmpty)
                        ? ''
                        : _cryptedTextMaskFormatter.getMaskedText();
                  });
                },
              )
            : GCWTextField(
                controller: _encodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentEncode = text;
                  });
                },
              ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTwoOptionsSwitch(
                rightValue: i18n(
                    context, 'bundeswehr_talkingboard_auth_table_mode_random'),
                leftValue: i18n(
                    context, 'bundeswehr_talkingboard_auth_table_mode_custom'),
                value: _currentTableMode,
                onChanged: (value) {
                  setState(() {
                    _currentTableMode = value;
                    _buildNumeralCode(
                        custom: _currentTableMode == GCWSwitchPosition.left,
                        xAxis: _currentNumeralCodeXaxisCustom,
                        yAxis: _currentNumeralCodeYaxisCustom);
                  });
                },
              )
            : Container(),
        GCWTextDivider(
          text:
              i18n(context, 'bundeswehr_talkingboard_auth_table_numeral_code'),
          trailing: Row(
            children: [
              GCWIconButton(
                icon: Icons.create,
                size: IconButtonSize.SMALL,
                iconColor: _currentMode == GCWSwitchPosition.right
                    ? themeColors().checkBoxActiveColor()
                    : _currentTableMode == GCWSwitchPosition.left
                        ? themeColors().inactive()
                        : null,
                onPressed: () {
                  setState(() {
                    _tableSource = TABLE_SOURCE.CUSTOM;
                  });
                },
              ),
              GCWIconButton(
                icon: Icons.auto_fix_high,
                size: IconButtonSize.SMALL,
                iconColor: _currentMode == GCWSwitchPosition.left
                    ? themeColors().inactive()
                    : null,
                onPressed: () {
                  setState(() {
                    if (_currentMode == GCWSwitchPosition.left) {
                      _tableSource = TABLE_SOURCE.RANDOM;
                      _contentToSave = true;
                      _buildNumeralCode(
                          custom: _tableSource == TABLE_SOURCE.CUSTOM,
                          xAxis: _currentNumeralCodeXaxisCustom,
                          yAxis: _currentNumeralCodeYaxisCustom);
                    }
                  });
                },
              ),
              GCWIconButton(
                icon: Icons.file_open,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  setState(() {
                    _tableSource = TABLE_SOURCE.FILE;
                  });
                },
              ),
              GCWIconButton(
                icon: Icons.save,
                size: IconButtonSize.SMALL,
                iconColor:
                    _contentToSave == false ? themeColors().inactive() : null,
                onPressed: () {
                  _contentToSave == false
                      ? null
                      : _exportFile(
                          context,
                          BundeswehrTalkingBoard(
                              xAxisNumeralCode: _tableNumeralCode!.xAxis,
                              yAxisNumeralCode: _tableNumeralCode!.yAxis,
                              AuthentificationCode: []).toByteList(),
                          'BWTalkingBoard',
                          FileType.TXT);
                },
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            (_tableSource == TABLE_SOURCE.FILE)
                ? GCWOpenFile(
                    title: i18n(context, 'common_exportfile_openfile'),
                    onLoaded: (_bundeswehrTalkingBoard) {
                      if (_bundeswehrTalkingBoard == null) {
                        showSnackBar(
                            i18n(
                                context, 'common_loadfile_exception_notloaded'),
                            context);
                        return;
                      }
                      BundeswehrTalkingBoard bwTalkingBoard =
                          BundeswehrTalkingBoard.fromJson(jsonDecode(
                                  String.fromCharCodes(
                                      _bundeswehrTalkingBoard.bytes))
                              as Map<String, dynamic>);

                      _tableNumeralCode =
                          BundeswehrTalkingBoardAuthentificationTable(
                        xAxis: bwTalkingBoard.xAxisNumeralCode,
                        yAxis: bwTalkingBoard.yAxisNumeralCode,
                        Content: BUNDESWEHR_TALKINGBOARD_NUMERALCODE,
                      );
                      setState(() {
                        _currentNumeralCodeXaxisCustom =
                            bwTalkingBoard.xAxisNumeralCode.join('');
                        _currentNumeralCodeYaxisCustom =
                            bwTalkingBoard.yAxisNumeralCode.join('');
                        _numeralCodeCustomXaxis.text =
                            _currentNumeralCodeXaxisCustom;
                        _numeralCodeCustomYaxis.text =
                            _currentNumeralCodeYaxisCustom;
                        _numeralCodeString =
                            BundeswehrTalkingBoardCreateNumeralCodeTableString(
                                bwTalkingBoard.xAxisNumeralCode,
                                bwTalkingBoard.yAxisNumeralCode);
                      });
                      _contentToSave = true;
                    },
                  )
                : Container(),
            _currentTableMode == GCWSwitchPosition.right
                ? GCWOutputText(
                    text: _numeralCodeString,
                    isMonotype: true,
                  )
                : Column(
                    children: <Widget>[
                      GCWTextField(
                        controller: _numeralCodeCustomXaxis,
                        hintText: i18n(context,
                            'bundeswehr_talkingboard_auth_table_numeral_code_x_axis'),
                        inputFormatters: [_numeralCodeyXAxisCodeMaskFormatter],
                        onChanged: (text) {
                          setState(() {
                            _currentNumeralCodeXaxisCustom = (text.isEmpty)
                                ? ''
                                : _numeralCodeyXAxisCodeMaskFormatter
                                    .getMaskedText();
                          });
                        },
                      ),
                      GCWTextField(
                        controller: _numeralCodeCustomYaxis,
                        hintText: i18n(context,
                            'bundeswehr_talkingboard_auth_table_numeral_code_y_axis'),
                        inputFormatters: [_numeralCodeYAxisCodeMaskFormatter],
                        onChanged: (text) {
                          setState(() {
                            _currentNumeralCodeYaxisCustom = (text.isEmpty)
                                ? ''
                                : _numeralCodeYAxisCodeMaskFormatter
                                    .getMaskedText();
                          });
                        },
                      ),
                    ],
                  )
          ],
        ),
        _calculateOutput(context),
      ],
    );
  }

  Widget _calculateOutput(BuildContext context) {
    BundeswehrTalkingBoardCodingOutput output;

    if (_currentTableMode == GCWSwitchPosition.left) {
      // encrypt
      _buildNumeralCode(
          custom: _currentTableMode == GCWSwitchPosition.left,
          xAxis: _currentNumeralCodeXaxisCustom,
          yAxis: _currentNumeralCodeYaxisCustom);
      if (_numeralCodeString.startsWith('bundeswehr_')) {
        return GCWDefaultOutput(
          child: i18n(context, _numeralCodeString),
        );
      }
    }
    if (_tableNumeralCode == null) {
      return const GCWDefaultOutput();
    }

    if (_currentMode == GCWSwitchPosition.right) {
      output = decodeBundeswehr(_currentDecode, _tableNumeralCode!);
    } else {
      output = encodeBundeswehr(_currentEncode, _tableNumeralCode!);
    }
    return GCWDefaultOutput(
        child: output.ResponseCode == BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK
            ? output.Details
            : i18n(context, output.ResponseCode));
  }

  void _buildNumeralCode({bool? custom, String? xAxis, String? yAxis}) {
    List<String> _colTitle;
    List<String> _rowTitle;
    List<String> _numeralCode = [];
    Map<String, List<String>> _tableEncoding = {};
    if (custom == true) {
      if (xAxis == null || xAxis.isEmpty || yAxis == null || yAxis.isEmpty) {
        _numeralCodeString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_NUMERAL_TABLE;
        return;
      }

      if (_invalidSingleAxisTitle(xAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
            yAxis: [], xAxis: [], Content: []);
        _numeralCodeString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_X_AXIS_NUMERAL_TABLE;
        return;
      }

      if (_invalidSingleAxisTitle(yAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
            yAxis: [], xAxis: [], Content: []);
        _numeralCodeString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_Y_AXIS_NUMERAL_TABLE;
        return;
      }

      if (_invalidAxisDescription(xAxis + yAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
            yAxis: [], xAxis: [], Content: []);
        _numeralCodeString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_NUMERAL_TABLE;
        return;
      }

      _colTitle = xAxis.toUpperCase().split('');
      _rowTitle = yAxis.toUpperCase().split('');
    } else {
      List<String> alphabet = [
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
      ];
      var random = Random();
      int rnd = 0;
      String description = '';
      while (alphabet.isNotEmpty) {
        rnd = random.nextInt(alphabet.length);
        description = description + alphabet[rnd];
        alphabet.removeAt(rnd);
      }
      _colTitle = description.substring(0, 13).split('');
      _rowTitle = description.substring(13).split('');
    }

    _numeralCode.addAll('0123456789ABC'.split(''));
    _numeralCode.addAll('D0123456789EF'.split(''));
    _numeralCode.addAll('GH0123456789I'.split(''));
    _numeralCode.addAll('JKL0123456789'.split(''));
    _numeralCode.addAll('9MNO012345678'.split(''));
    _numeralCode.addAll('89PQR01234567'.split(''));
    _numeralCode.addAll('789STU0123456'.split(''));
    _numeralCode.addAll('6789VWX012345'.split(''));
    _numeralCode.addAll('56789YZA01234'.split(''));
    _numeralCode.addAll('456789DEG0123'.split(''));
    _numeralCode.addAll('3456789HIL012'.split(''));
    _numeralCode.addAll('23456789NOR01'.split(''));
    _numeralCode.addAll('123456789STU0'.split(''));

    int i = 0;
    _numeralCodeString =
        '   ' + _colTitle.join(' ') + '\n----------------------------\n ';
    for (var row in _rowTitle) {
      _numeralCodeString = _numeralCodeString + row + ' ';
      for (int j = 0; j < 13; j++) {
        _numeralCodeString =
            _numeralCodeString + _numeralCode[i * 13 + j] + ' ';
      }
      i++;
      _numeralCodeString = _numeralCodeString + '\n ';
    }

    _tableEncoding['0'] = [
      _colTitle[0] + _rowTitle[0],
      _rowTitle[0] + _colTitle[0],
      _colTitle[1] + _rowTitle[1],
      _rowTitle[1] + _colTitle[1],
      _colTitle[2] + _rowTitle[2],
      _rowTitle[2] + _colTitle[2],
      _colTitle[3] + _rowTitle[3],
      _rowTitle[3] + _colTitle[3],
      _colTitle[4] + _rowTitle[4],
      _rowTitle[4] + _colTitle[4],
      _colTitle[5] + _rowTitle[5],
      _rowTitle[5] + _colTitle[5],
      _colTitle[6] + _rowTitle[6],
      _rowTitle[6] + _colTitle[6],
      _colTitle[7] + _rowTitle[7],
      _rowTitle[7] + _colTitle[7],
      _colTitle[8] + _rowTitle[8],
      _rowTitle[8] + _colTitle[8],
      _colTitle[9] + _rowTitle[9],
      _rowTitle[9] + _colTitle[9],
      _colTitle[10] + _rowTitle[10],
      _rowTitle[10] + _colTitle[10],
      _colTitle[11] + _rowTitle[11],
      _rowTitle[11] + _colTitle[11],
      _colTitle[12] + _rowTitle[12],
      _rowTitle[12] + _colTitle[12],
    ];
    _tableEncoding['1'] = [
      _colTitle[1] + _rowTitle[0],
      _rowTitle[0] + _colTitle[1],
      _colTitle[2] + _rowTitle[1],
      _rowTitle[1] + _colTitle[2],
      _colTitle[3] + _rowTitle[2],
      _rowTitle[2] + _colTitle[3],
      _colTitle[4] + _rowTitle[3],
      _rowTitle[3] + _colTitle[4],
      _colTitle[5] + _rowTitle[4],
      _rowTitle[4] + _colTitle[5],
      _colTitle[6] + _rowTitle[5],
      _rowTitle[5] + _colTitle[6],
      _colTitle[7] + _rowTitle[6],
      _rowTitle[6] + _colTitle[7],
      _colTitle[8] + _rowTitle[7],
      _rowTitle[7] + _colTitle[8],
      _colTitle[9] + _rowTitle[8],
      _rowTitle[8] + _colTitle[9],
      _colTitle[10] + _rowTitle[9],
      _rowTitle[9] + _colTitle[10],
      _colTitle[11] + _rowTitle[10],
      _rowTitle[10] + _colTitle[11],
      _colTitle[12] + _rowTitle[11],
      _rowTitle[11] + _colTitle[12],
      _colTitle[0] + _rowTitle[12],
      _rowTitle[12] + _colTitle[0],
    ];
    _tableEncoding['2'] = [
      _colTitle[2] + _rowTitle[0],
      _rowTitle[0] + _colTitle[2],
      _colTitle[3] + _rowTitle[1],
      _rowTitle[1] + _colTitle[3],
      _colTitle[4] + _rowTitle[2],
      _rowTitle[2] + _colTitle[4],
      _colTitle[5] + _rowTitle[3],
      _rowTitle[3] + _colTitle[5],
      _colTitle[6] + _rowTitle[4],
      _rowTitle[4] + _colTitle[6],
      _colTitle[7] + _rowTitle[5],
      _rowTitle[5] + _colTitle[7],
      _colTitle[8] + _rowTitle[6],
      _rowTitle[6] + _colTitle[8],
      _colTitle[9] + _rowTitle[7],
      _rowTitle[7] + _colTitle[9],
      _colTitle[10] + _rowTitle[8],
      _rowTitle[8] + _colTitle[10],
      _colTitle[11] + _rowTitle[9],
      _rowTitle[9] + _colTitle[11],
      _colTitle[12] + _rowTitle[10],
      _rowTitle[10] + _colTitle[12],
      _colTitle[0] + _rowTitle[11],
      _rowTitle[11] + _colTitle[0],
      _colTitle[1] + _rowTitle[12],
      _rowTitle[12] + _colTitle[1],
    ];
    _tableEncoding['3'] = [
      _colTitle[3] + _rowTitle[0],
      _rowTitle[0] + _colTitle[3],
      _colTitle[4] + _rowTitle[1],
      _rowTitle[1] + _colTitle[4],
      _colTitle[5] + _rowTitle[2],
      _rowTitle[2] + _colTitle[5],
      _colTitle[6] + _rowTitle[3],
      _rowTitle[3] + _colTitle[6],
      _colTitle[7] + _rowTitle[4],
      _rowTitle[4] + _colTitle[7],
      _colTitle[8] + _rowTitle[5],
      _rowTitle[5] + _colTitle[8],
      _colTitle[9] + _rowTitle[6],
      _rowTitle[6] + _colTitle[9],
      _colTitle[10] + _rowTitle[7],
      _rowTitle[7] + _colTitle[10],
      _colTitle[11] + _rowTitle[8],
      _rowTitle[8] + _colTitle[11],
      _colTitle[12] + _rowTitle[9],
      _rowTitle[9] + _colTitle[12],
      _colTitle[0] + _rowTitle[10],
      _rowTitle[10] + _colTitle[0],
      _colTitle[1] + _rowTitle[11],
      _rowTitle[11] + _colTitle[1],
      _colTitle[2] + _rowTitle[12],
      _rowTitle[12] + _colTitle[2],
    ];
    _tableEncoding['4'] = [
      _colTitle[4] + _rowTitle[0],
      _rowTitle[0] + _colTitle[4],
      _colTitle[5] + _rowTitle[1],
      _rowTitle[1] + _colTitle[5],
      _colTitle[6] + _rowTitle[2],
      _rowTitle[2] + _colTitle[6],
      _colTitle[7] + _rowTitle[3],
      _rowTitle[3] + _colTitle[7],
      _colTitle[8] + _rowTitle[4],
      _rowTitle[4] + _colTitle[8],
      _colTitle[9] + _rowTitle[5],
      _rowTitle[5] + _colTitle[9],
      _colTitle[10] + _rowTitle[6],
      _rowTitle[6] + _colTitle[10],
      _colTitle[11] + _rowTitle[7],
      _rowTitle[7] + _colTitle[11],
      _colTitle[12] + _rowTitle[8],
      _rowTitle[8] + _colTitle[12],
      _colTitle[0] + _rowTitle[9],
      _rowTitle[9] + _colTitle[0],
      _colTitle[1] + _rowTitle[10],
      _rowTitle[10] + _colTitle[1],
      _colTitle[2] + _rowTitle[11],
      _rowTitle[11] + _colTitle[2],
      _colTitle[3] + _rowTitle[12],
      _rowTitle[12] + _colTitle[3],
    ];
    _tableEncoding['5'] = [
      _colTitle[5] + _rowTitle[0],
      _rowTitle[0] + _colTitle[5],
      _colTitle[6] + _rowTitle[1],
      _rowTitle[1] + _colTitle[6],
      _colTitle[7] + _rowTitle[2],
      _rowTitle[2] + _colTitle[7],
      _colTitle[8] + _rowTitle[3],
      _rowTitle[3] + _colTitle[8],
      _colTitle[9] + _rowTitle[4],
      _rowTitle[4] + _colTitle[9],
      _colTitle[10] + _rowTitle[5],
      _rowTitle[5] + _colTitle[10],
      _colTitle[11] + _rowTitle[6],
      _rowTitle[6] + _colTitle[11],
      _colTitle[12] + _rowTitle[7],
      _rowTitle[7] + _colTitle[12],
      _colTitle[0] + _rowTitle[8],
      _rowTitle[8] + _colTitle[0],
      _colTitle[1] + _rowTitle[9],
      _rowTitle[9] + _colTitle[1],
      _colTitle[2] + _rowTitle[10],
      _rowTitle[10] + _colTitle[2],
      _colTitle[3] + _rowTitle[11],
      _rowTitle[11] + _colTitle[3],
      _colTitle[4] + _rowTitle[12],
      _rowTitle[12] + _colTitle[4],
    ];
    _tableEncoding['6'] = [
      _colTitle[6] + _rowTitle[0],
      _rowTitle[0] + _colTitle[6],
      _colTitle[7] + _rowTitle[1],
      _rowTitle[1] + _colTitle[7],
      _colTitle[8] + _rowTitle[2],
      _rowTitle[2] + _colTitle[8],
      _colTitle[9] + _rowTitle[3],
      _rowTitle[3] + _colTitle[9],
      _colTitle[10] + _rowTitle[4],
      _rowTitle[4] + _colTitle[10],
      _colTitle[11] + _rowTitle[5],
      _rowTitle[5] + _colTitle[11],
      _colTitle[12] + _rowTitle[6],
      _rowTitle[6] + _colTitle[12],
      _colTitle[0] + _rowTitle[7],
      _rowTitle[7] + _colTitle[0],
      _colTitle[1] + _rowTitle[8],
      _rowTitle[8] + _colTitle[1],
      _colTitle[2] + _rowTitle[9],
      _rowTitle[9] + _colTitle[2],
      _colTitle[3] + _rowTitle[10],
      _rowTitle[10] + _colTitle[3],
      _colTitle[4] + _rowTitle[11],
      _rowTitle[11] + _colTitle[4],
      _colTitle[5] + _rowTitle[12],
      _rowTitle[12] + _colTitle[5],
    ];
    _tableEncoding['7'] = [
      _colTitle[7] + _rowTitle[0],
      _rowTitle[0] + _colTitle[7],
      _colTitle[8] + _rowTitle[1],
      _rowTitle[1] + _colTitle[8],
      _colTitle[9] + _rowTitle[2],
      _rowTitle[2] + _colTitle[9],
      _colTitle[10] + _rowTitle[3],
      _rowTitle[3] + _colTitle[10],
      _colTitle[11] + _rowTitle[4],
      _rowTitle[4] + _colTitle[11],
      _colTitle[12] + _rowTitle[5],
      _rowTitle[5] + _colTitle[12],
      _colTitle[0] + _rowTitle[6],
      _rowTitle[6] + _colTitle[0],
      _colTitle[1] + _rowTitle[7],
      _rowTitle[7] + _colTitle[1],
      _colTitle[2] + _rowTitle[8],
      _rowTitle[8] + _colTitle[2],
      _colTitle[3] + _rowTitle[9],
      _rowTitle[9] + _colTitle[3],
      _colTitle[4] + _rowTitle[10],
      _rowTitle[10] + _colTitle[4],
      _colTitle[5] + _rowTitle[11],
      _rowTitle[11] + _colTitle[5],
      _colTitle[6] + _rowTitle[12],
      _rowTitle[12] + _colTitle[6],
    ];
    _tableEncoding['8'] = [
      _colTitle[8] + _rowTitle[0],
      _rowTitle[0] + _colTitle[8],
      _colTitle[9] + _rowTitle[1],
      _rowTitle[1] + _colTitle[9],
      _colTitle[10] + _rowTitle[2],
      _rowTitle[2] + _colTitle[10],
      _colTitle[11] + _rowTitle[3],
      _rowTitle[3] + _colTitle[11],
      _colTitle[12] + _rowTitle[4],
      _rowTitle[4] + _colTitle[12],
      _colTitle[0] + _rowTitle[5],
      _rowTitle[5] + _colTitle[0],
      _colTitle[1] + _rowTitle[6],
      _rowTitle[6] + _colTitle[1],
      _colTitle[2] + _rowTitle[7],
      _rowTitle[7] + _colTitle[2],
      _colTitle[3] + _rowTitle[8],
      _rowTitle[8] + _colTitle[3],
      _colTitle[4] + _rowTitle[9],
      _rowTitle[9] + _colTitle[4],
      _colTitle[5] + _rowTitle[10],
      _rowTitle[10] + _colTitle[5],
      _colTitle[6] + _rowTitle[11],
      _rowTitle[11] + _colTitle[6],
      _colTitle[7] + _rowTitle[12],
      _rowTitle[12] + _colTitle[7],
    ];
    _tableEncoding['9'] = [
      _colTitle[9] + _rowTitle[0],
      _rowTitle[0] + _colTitle[9],
      _colTitle[10] + _rowTitle[1],
      _rowTitle[1] + _colTitle[10],
      _colTitle[11] + _rowTitle[2],
      _rowTitle[2] + _colTitle[11],
      _colTitle[12] + _rowTitle[3],
      _rowTitle[3] + _colTitle[12],
      _colTitle[0] + _rowTitle[4],
      _rowTitle[4] + _colTitle[0],
      _colTitle[1] + _rowTitle[5],
      _rowTitle[5] + _colTitle[1],
      _colTitle[2] + _rowTitle[6],
      _rowTitle[6] + _colTitle[2],
      _colTitle[3] + _rowTitle[7],
      _rowTitle[7] + _colTitle[3],
      _colTitle[4] + _rowTitle[8],
      _rowTitle[8] + _colTitle[4],
      _colTitle[5] + _rowTitle[9],
      _rowTitle[9] + _colTitle[5],
      _colTitle[6] + _rowTitle[10],
      _rowTitle[10] + _colTitle[6],
      _colTitle[7] + _rowTitle[11],
      _rowTitle[11] + _colTitle[7],
      _colTitle[8] + _rowTitle[12],
      _rowTitle[12] + _colTitle[8],
    ];
    _tableEncoding['A'] = [
      _colTitle[10] + _rowTitle[0],
      _rowTitle[0] + _colTitle[10],
      _colTitle[7] + _rowTitle[8],
      _rowTitle[8] + _colTitle[7],
    ];
    _tableEncoding['B'] = [
      _colTitle[11] + _rowTitle[0],
      _rowTitle[0] + _colTitle[11],
    ];
    _tableEncoding['C'] = [
      _colTitle[12] + _rowTitle[0],
      _rowTitle[0] + _colTitle[12],
    ];
    _tableEncoding['D'] = [
      _colTitle[0] + _rowTitle[1],
      _rowTitle[1] + _colTitle[0],
      _colTitle[6] + _rowTitle[9],
      _rowTitle[9] + _colTitle[6],
    ];
    _tableEncoding['E'] = [
      _colTitle[11] + _rowTitle[1],
      _rowTitle[1] + _colTitle[11],
      _colTitle[7] + _rowTitle[9],
      _rowTitle[9] + _colTitle[7],
    ];
    _tableEncoding['F'] = [
      _colTitle[12] + _rowTitle[1],
      _rowTitle[1] + _colTitle[12],
    ];
    _tableEncoding['G'] = [
      _colTitle[0] + _rowTitle[2],
      _rowTitle[2] + _colTitle[0],
      _colTitle[8] + _rowTitle[9],
      _rowTitle[9] + _colTitle[8],
    ];
    _tableEncoding['H'] = [
      _colTitle[1] + _rowTitle[2],
      _rowTitle[2] + _colTitle[1],
      _colTitle[7] + _rowTitle[10],
      _rowTitle[10] + _colTitle[7],
    ];
    _tableEncoding['I'] = [
      _colTitle[12] + _rowTitle[2],
      _rowTitle[2] + _colTitle[12],
      _colTitle[8] + _rowTitle[10],
      _rowTitle[10] + _colTitle[8],
    ];
    _tableEncoding['J'] = [
      _colTitle[0] + _rowTitle[3],
      _rowTitle[3] + _colTitle[0],
    ];
    _tableEncoding['K'] = [
      _colTitle[1] + _rowTitle[3],
      _rowTitle[3] + _colTitle[1],
    ];
    _tableEncoding['L'] = [
      _colTitle[2] + _rowTitle[3],
      _rowTitle[3] + _colTitle[2],
      _colTitle[9] + _rowTitle[10],
      _rowTitle[10] + _colTitle[9],
    ];
    _tableEncoding['M'] = [
      _colTitle[1] + _rowTitle[4],
      _rowTitle[4] + _colTitle[1],
    ];
    _tableEncoding['N'] = [
      _colTitle[2] + _rowTitle[4],
      _rowTitle[4] + _colTitle[2],
      _colTitle[8] + _rowTitle[11],
      _rowTitle[11] + _colTitle[8],
    ];
    _tableEncoding['O'] = [
      _colTitle[3] + _rowTitle[4],
      _rowTitle[4] + _colTitle[3],
      _colTitle[9] + _rowTitle[11],
      _rowTitle[11] + _colTitle[9],
    ];
    _tableEncoding['P'] = [
      _colTitle[2] + _rowTitle[5],
      _rowTitle[5] + _colTitle[2],
    ];
    _tableEncoding['Q'] = [
      _colTitle[3] + _rowTitle[5],
      _rowTitle[5] + _colTitle[3],
    ];
    _tableEncoding['R'] = [
      _colTitle[4] + _rowTitle[5],
      _rowTitle[5] + _colTitle[4],
      _colTitle[10] + _rowTitle[11],
      _rowTitle[11] + _colTitle[10],
    ];
    _tableEncoding['S'] = [
      _colTitle[3] + _rowTitle[6],
      _rowTitle[6] + _colTitle[3],
      _colTitle[9] + _rowTitle[12],
      _rowTitle[12] + _colTitle[9],
    ];
    _tableEncoding['T'] = [
      _colTitle[4] + _rowTitle[6],
      _rowTitle[6] + _colTitle[4],
      _colTitle[10] + _rowTitle[12],
      _rowTitle[12] + _colTitle[10],
    ];
    _tableEncoding['U'] = [
      _colTitle[5] + _rowTitle[6],
      _rowTitle[6] + _colTitle[5],
      _colTitle[11] + _rowTitle[12],
      _rowTitle[12] + _colTitle[11],
    ];
    _tableEncoding['V'] = [
      _colTitle[4] + _rowTitle[7],
      _rowTitle[7] + _colTitle[4],
    ];
    _tableEncoding['W'] = [
      _colTitle[5] + _rowTitle[7],
      _rowTitle[7] + _colTitle[5],
    ];
    _tableEncoding['X'] = [
      _colTitle[6] + _rowTitle[7],
      _rowTitle[7] + _colTitle[6],
    ];
    _tableEncoding['Y'] = [
      _colTitle[5] + _rowTitle[8],
      _rowTitle[8] + _colTitle[5],
    ];
    _tableEncoding['Z'] = [
      _colTitle[6] + _rowTitle[8],
      _rowTitle[8] + _colTitle[6],
    ];

    _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
        yAxis: _rowTitle,
        xAxis: _colTitle,
        Content: _numeralCode,
        Encoding: _tableEncoding);
  }

  bool _invalidSingleAxisTitle(String text) {
    if (text.length != 13) return true;
    List<String> dublicates = [];
    text.split('').forEach((element) {
      if (dublicates.contains(element)) {
        return;
      } else {
        dublicates.add(element);
      }
    });
    return (dublicates.length != text.length);
  }

  bool _invalidAxisDescription(String text) {
    List<String> dublicates = [];
    text.split('').forEach((element) {
      if (dublicates.contains(element)) {
        return;
      } else {
        dublicates.add(element);
      }
    });
    return (dublicates.length != text.length);
  }

  void _exportFile(BuildContext context, Uint8List data, String name,
      FileType fileType) async {
    var value = await saveByteDataToFile(
        context,
        data,
        name +
            DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) +
            '.' +
            fileExtension(fileType));

    if (value) showExportedFileDialog(context);
  }
}
