import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_text_export.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/logic/bundeswehr_auth.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';

class BundeswehrTalkingBoardAuthentification extends StatefulWidget {
  const BundeswehrTalkingBoardAuthentification({super.key});

  @override
  _BundeswehrTalkingBoardAuthentificationState createState() =>
      _BundeswehrTalkingBoardAuthentificationState();
}

class _BundeswehrTalkingBoardAuthentificationState
    extends State<BundeswehrTalkingBoardAuthentification> {
  late TextEditingController _inputAuthController;
  late TextEditingController _callSignController;
  late TextEditingController _letterControllerAuth;
  late TextEditingController _letterControllerCallSign;
  late TextEditingController _authTableCustom;
  late TextEditingController _numeralCodeCustomXaxis;
  late TextEditingController _numeralCodeCustomYaxis;

  String _currentAuthInput = '';
  String _currentCallSign = '';
  String _currentLetterAuth = 'V';
  int _currentLetterAuthIndex = 0;
  String _currentLetterCallSign = '';
  String _currentNumeralCodeXaxisCustom = '';
  String _currentNumeralCodeYaxisCustom = '';
  String _currentAuthTableCustom = '';

  BundeswehrTalkingBoardAuthentificationTable _tableNumeralCode =
      BundeswehrTalkingBoardAuthentificationTable(
          yAxis: [], xAxis: [], Content: []);
  BundeswehrTalkingBoardAuthentificationTable _tableAuthentificationCode =
      BundeswehrTalkingBoardAuthentificationTable(
          yAxis: [], xAxis: [], Content: []);

  String _authTableString = '';
  String _numeralCodeString = '';

  bool _contentToSave = false;
  TABLE_SOURCE _tableSource = TABLE_SOURCE.NONE;

  final _authTableMaskFormatter = GCWMaskTextInputFormatter(
      mask: '## ' * 64 + '##', filter: {"#": RegExp(r'\d')});

  final _authCodeMaskFormatter = GCWMaskTextInputFormatter(
      mask: '## ' * 2 + '##', filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeXAxisCodeMaskFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeYAxisCodeMaskFormatter = GCWMaskTextInputFormatter(
      mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  final _callsignLetterMaskFormatter =
      GCWMaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[a-zA-Z]')});

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  String _currentAuthCode1 = '';
  String _currentAuthCode2 = '';
  String _currentAuthCode3 = '';
  String _currentCopyText = '';

  BundeswehrTalkingBoardAuthentificationOutput _currentOutput =
      BundeswehrTalkingBoardAuthentificationOutput(
          ResponseCode: [BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_NOT_OK]);

  @override
  void initState() {
    super.initState();
    _inputAuthController = TextEditingController(text: _currentAuthInput);
    _callSignController = TextEditingController(text: _currentCallSign);
    _letterControllerAuth = TextEditingController(text: _currentLetterAuth);
    _letterControllerCallSign =
        TextEditingController(text: _currentLetterCallSign);
    _authTableCustom = TextEditingController(text: _currentAuthTableCustom);
    _numeralCodeCustomXaxis =
        TextEditingController(text: _currentNumeralCodeXaxisCustom);
    _numeralCodeCustomYaxis =
        TextEditingController(text: _currentNumeralCodeYaxisCustom);
  }

  @override
  void dispose() {
    _inputAuthController.dispose();
    _callSignController.dispose();
    _letterControllerAuth.dispose();
    _letterControllerCallSign.dispose();
    _authTableCustom.dispose();
    _numeralCodeCustomXaxis.dispose();
    _numeralCodeCustomYaxis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetInputMode(context),
        _widgetInputCallsign(context),
        _widgetInputAuthentificationLetter(context),
        _currentMode == GCWSwitchPosition.right // Check Auth
            ? _widgetInputAuthentificationCodeToCheck(context)
            : _widgetInputLetterToCreateAuthentificationCode(context),
        (_tableSource == TABLE_SOURCE.FILE)
            ? _widgetOpenFile(context)
            : Container(),
        GCWExpandableTextDivider(
            text: i18n(context, 'bundeswehr_talkingboard_tables'),
            expanded: false,
            suppressTopSpace: false,
            trailing: Row(
              children: [
                _widgetIconButtonRandom(),
                _widgetIconButtonOpen(),
                _widgetIconButtonQR(context),
              ],
            ),
            child: Column(children: <Widget>[
              GCWTextDivider(
                text: i18n(
                    context, 'bundeswehr_talkingboard_auth_table_numeral_code'),
              ),
              _widgetInputXaxis(context),
              _widgetInputYaxis(context),
              GCWTextDivider(
                text: i18n(context,
                    'bundeswehr_talkingboard_auth_table_authentification_code'),
              ),
              _widgetInputAuthentificationTable(),
              GCWExpandableTextDivider(
                suppressTopSpace: false,
                text: i18n(context, 'bundeswehr_talkingboard_auth_table_mode'),
                child: Column(
                  children: <Widget>[
                    GCWOutputText(
                      text: _numeralCodeString.startsWith('bundeswehr_')
                          ? i18n(context, _numeralCodeString)
                          : _numeralCodeString,
                      isMonotype: true,
                    ),
                    GCWOutputText(
                      text: _authTableString.startsWith('bundeswehr_')
                          ? i18n(context, _authTableString)
                          : _authTableString,
                      isMonotype: true,
                    )
                  ],
                ),
              ),
            ])),
        _buildOutputWidget(context),
      ],
    );
  }

  GCWTextField _widgetInputAuthentificationTable() {
    return GCWTextField(
      controller: _authTableCustom,
      hintText: '38 24 44 34  61 38...',
      inputFormatters: [_authTableMaskFormatter],
      onChanged: (text) {
        setState(() {
          _currentAuthTableCustom = _authTableMaskFormatter.getMaskedText();
          _calculateOutput();
        });
      },
    );
  }

  GCWTextField _widgetInputXaxis(BuildContext context) {
    return GCWTextField(
      controller: _numeralCodeCustomXaxis,
      hintText: i18n(
          context, 'bundeswehr_talkingboard_auth_table_numeral_code_x_axis'),
      inputFormatters: [_numeralCodeXAxisCodeMaskFormatter],
      onChanged: (text) {
        setState(() {
          _currentNumeralCodeXaxisCustom =
              _numeralCodeXAxisCodeMaskFormatter.getMaskedText();
          _calculateOutput();
        });
      },
    );
  }

  GCWTextField _widgetInputYaxis(BuildContext context) {
    return GCWTextField(
      controller: _numeralCodeCustomYaxis,
      hintText: i18n(
          context, 'bundeswehr_talkingboard_auth_table_numeral_code_y_axis'),
      inputFormatters: [_numeralCodeYAxisCodeMaskFormatter],
      onChanged: (text) {
        setState(() {
          _currentNumeralCodeYaxisCustom =
              _numeralCodeYAxisCodeMaskFormatter.getMaskedText();
          _calculateOutput();
        });
      },
    );
  }

  GCWIconButton _widgetIconButtonRandom() {
    return GCWIconButton(
      icon: Icons.auto_fix_high,
      size: IconButtonSize.SMALL,
      onPressed: () {
        setState(() {
          _tableSource = TABLE_SOURCE.RANDOM;
          _contentToSave = true;
          _buildAuthTable(custom: false, authTable: '');
          _buildNumeralCode(custom: false, xAxis: '', yAxis: '');

          _numeralCodeCustomXaxis.text = _currentNumeralCodeXaxisCustom;
          _numeralCodeCustomYaxis.text = _currentNumeralCodeYaxisCustom;
          _authTableCustom.text = _currentAuthTableCustom;

          _calculateOutput();
        });
      },
    );
  }

  Widget _widgetIconButtonQR(BuildContext context){
    return GCWIconButton(
      icon: Icons.qr_code,
      size: IconButtonSize.SMALL,
      iconColor:
      _contentToSave == false ? themeColors().inactive() : null,
      onPressed: () {
        showGCWDialog(
            context,
            i18n(context, 'bundeswehr_talkingboard_export_tables'),
            GCWTextExport(
              text: BundeswehrTalkingBoard(
                  xAxisNumeralCode: _tableNumeralCode.xAxis,
                  yAxisNumeralCode: _tableNumeralCode.yAxis,
                  AuthentificationCode: []).toString(),
              saveFileTypeText: FileType.JSON,
              saveFilenamePrefix: 'BWTalkingBoard',
            ),
            [
              GCWDialogButton(
                text: i18n(context, 'common_cancel'),
              )
            ],
            cancelButton: false);
        setState(() {

        });
      },
    );
  }

  GCWIconButton _widgetIconButtonOpen() {
    return GCWIconButton(
      icon: Icons.file_open,
      size: IconButtonSize.SMALL,
      onPressed: () {
        setState(() {
          _tableSource = TABLE_SOURCE.FILE;
        });
      },
    );
  }

  GCWOpenFile _widgetOpenFile(BuildContext context) {
    return GCWOpenFile(
      title: i18n(context, 'common_exportfile_openfile'),
      onLoaded: (_bundeswehrTalkingBoard) {
        if (_bundeswehrTalkingBoard == null) {
          showSnackBar(
              i18n(context, 'common_loadfile_exception_notloaded'), context);
          return;
        }
        BundeswehrTalkingBoard bwTalkingBoard = BundeswehrTalkingBoard.fromJson(
            jsonDecode(String.fromCharCodes(_bundeswehrTalkingBoard.bytes))
                as Map<String, dynamic>);

        setState(() {
          _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
            xAxis: bwTalkingBoard.xAxisNumeralCode,
            yAxis: bwTalkingBoard.yAxisNumeralCode,
            Content: BUNDESWEHR_TALKINGBOARD_NUMERALCODE,
          );
          _tableAuthentificationCode =
              BundeswehrTalkingBoardAuthentificationTable(
            xAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS,
            yAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_Y_AXIS,
            Content: bwTalkingBoard.AuthentificationCode,
          );
          _authTableString = BundeswehrTalkingBoardCreateAuthTableString(
              bwTalkingBoard.AuthentificationCode);
          _numeralCodeString =
              BundeswehrTalkingBoardCreateNumeralCodeTableString(
                  bwTalkingBoard.xAxisNumeralCode,
                  bwTalkingBoard.yAxisNumeralCode);

          _currentNumeralCodeXaxisCustom =
              bwTalkingBoard.xAxisNumeralCode.join('');
          _currentNumeralCodeYaxisCustom =
              bwTalkingBoard.yAxisNumeralCode.join('');
          _currentAuthTableCustom =
              bwTalkingBoard.AuthentificationCode.join(' ');

          _numeralCodeCustomXaxis.text = _currentNumeralCodeXaxisCustom;
          _numeralCodeCustomYaxis.text = _currentNumeralCodeYaxisCustom;
          _authTableCustom.text = _currentAuthTableCustom;

          _calculateOutput();
        });
        _contentToSave = true;
      },
    );
  }

  GCWTextField _widgetInputLetterToCreateAuthentificationCode(
      BuildContext context) {
    return GCWTextField(
      title: i18n(context, 'bundeswehr_talkingboard_auth_letter_callsign'),
      controller: _letterControllerCallSign,
      inputFormatters: [_callsignLetterMaskFormatter],
      onChanged: (text) {
        setState(() {
          _currentLetterCallSign = (text.isEmpty)
              ? ''
              : _callsignLetterMaskFormatter.getMaskedText();
          _calculateOutput();
        });
      },
    );
  }

  GCWTextField _widgetInputAuthentificationCodeToCheck(BuildContext context) {
    return GCWTextField(
        title:
            i18n(context, 'bundeswehr_talkingboard_auth_authentification_code'),
        controller: _inputAuthController,
        hintText: 'FW ST CD',
        inputFormatters: [_authCodeMaskFormatter],
        onChanged: (text) {
          setState(() {
            _currentAuthInput =
                (text.isEmpty) ? '' : _authCodeMaskFormatter.getMaskedText();
            _calculateOutput();
          });
        });
  }

  GCWDropDownSpinner _widgetInputAuthentificationLetter(BuildContext context) {
    return GCWDropDownSpinner(
      title: i18n(context, 'bundeswehr_talkingboard_auth_letter_auth'),
      index: _currentLetterAuthIndex,
      items: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS
          .map((item) => Text(item.toString(), style: gcwTextStyle()))
          .toList(),
      onChanged: (value) {
        setState(() {
          _currentLetterAuthIndex = value;
          _currentLetterAuth = BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS[value];
          _calculateOutput();
        });
      },
    );
  }

  GCWTextField _widgetInputCallsign(BuildContext context) {
    return GCWTextField(
      title: i18n(context, 'bundeswehr_talkingboard_auth_call_sign'),
      controller: _callSignController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      ],
      onChanged: (text) {
        setState(() {
          _currentCallSign = text;
          _calculateOutput();
        });
      },
    );
  }

  GCWTwoOptionsSwitch _widgetInputMode(BuildContext context) {
    return GCWTwoOptionsSwitch(
      rightValue: i18n(context, 'bundeswehr_talkingboard_auth_mode_auth_check'),
      leftValue: i18n(context, 'bundeswehr_talkingboard_auth_mode_auth'),
      value: _currentMode,
      onChanged: (value) {
        setState(() {
          _currentMode = value;
        });
      },
    );
  }

  Widget _buildOutputWidget(BuildContext context) {
    Widget resultWidget = Container();

    if (_currentMode == GCWSwitchPosition.right) {
      // check auth

      if (_currentOutput.ResponseCode.join('') ==
          BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_OK) {
        resultWidget = Column(
          children: <Widget>[
            GCWText(
                text:
                    i18n(context, 'bundeswehr_talkingboard_auth_response_ok')),
            GCWExpandableTextDivider(
              text: i18n(context, 'bundeswehr_talkingboard_auth_details'),
              expanded: false,
              child: GCWText(text: _currentOutput.Details ?? ''),
            )
          ],
        );
      } else {
        resultWidget = GCWText(
          text: _buildResponse(_currentOutput.ResponseCode),
        );
      }
    } else {
      // build auth
      if (_currentOutput.ResponseCode.join('') ==
          BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_OK) {
        resultWidget = Row(children: <Widget>[
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      _currentLetterCallSign.toUpperCase(),
                    )),
                    GCWDropDown<String>(
                      value: _currentAuthCode1,
                      onChanged: (value) {
                        setState(() {
                          _currentAuthCode1 = value;
                        });
                      },
                      items: (_currentOutput.Tupel1!).map((code) {
                        return GCWDropDownMenuItem(
                          value: code,
                          child: code,
                        );
                      }).toList(),
                    )
                  ],
                )),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      _currentOutput.Number![0],
                    )),
                    GCWDropDown<String>(
                      value: _currentAuthCode2,
                      onChanged: (value) {
                        setState(() {
                          _currentAuthCode2 = value;
                        });
                      },
                      items: (_currentOutput.Tupel2!).map((code) {
                        return GCWDropDownMenuItem(
                          value: code,
                          child: code,
                        );
                      }).toList(),
                    )
                  ],
                )),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      _currentOutput.Number![1],
                    )),
                    GCWDropDown<String>(
                      value: _currentAuthCode3,
                      onChanged: (value) {
                        setState(() {
                          _currentAuthCode3 = value;
                        });
                      },
                      items: (_currentOutput.Tupel3!).map((code) {
                        return GCWDropDownMenuItem(
                          value: code,
                          child: code,
                        );
                      }).toList(),
                    )
                  ],
                )),
          ),
        ]);
      } else {
        resultWidget = GCWText(
          text: _buildResponse(_currentOutput.ResponseCode),
        );
      }
    }
    return Column(
      children: [
        GCWTextDivider(
          text: i18n(context, 'common_output'),
          trailing: Row(
            children: [
              GCWIconButton(
                icon: Icons.copy,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  _currentCopyText = _currentAuthCode1 +
                      ' ' +
                      _currentAuthCode2 +
                      ' ' +
                      _currentAuthCode3;
                  insertIntoGCWClipboard(context, _currentCopyText);
                },
              )
            ],
          ),
        ),
        resultWidget,
      ],
    );
  }

  String _buildResponse(List<String> responseCodes) {
    return responseCodes.map((response) {
      return response.startsWith('bundeswehr_talkingboard')
          ? i18n(context, response)
          : response;
    }).join('\n');
  }

  void _buildAuthTable({required bool custom, required String authTable}) {
    List<String> authCode = [];
    Map<String, Map<String, String>> _authTable = {};

    if (custom) {
      if (authTable.isEmpty) {
        _authTableString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_AUTH_TABLE;
        return;
      }

      if (authTable.trim().split(' ').length != 65) {
        _tableAuthentificationCode =
            BundeswehrTalkingBoardAuthentificationTable(
                yAxis: [], xAxis: [], Content: []);
        _authTableString =
            BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_AUTH_TABLE;
        return;
      }
      authTable.trim().split(' ').forEach((element) {
        if (element.length > 2) {
          _tableAuthentificationCode =
              BundeswehrTalkingBoardAuthentificationTable(
                  yAxis: [], xAxis: [], Content: []);
          _authTableString =
              BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_AUTH_TABLE;
          return;
        } else if (element.length == 1) {
          authCode.add('0' + element);
        } else {
          authCode.add(element);
        }
      });
    } else {
      var random = Random();
      int rnd = 0;
      while (authCode.length != 65) {
        rnd = random.nextInt(100);
        if (authCode.contains(rnd.toString().padLeft(2, '0'))) {
        } else {
          authCode.add(rnd.toString().padLeft(2, '0'));
        }
      }
    }

    int i = 0;
    for (var row in BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_Y_AXIS) {
      Map<String, String> authTableRow = {};
      for (var col in BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS) {
        authTableRow[col] = authCode[i];
        i++;
      }
      _authTable[row] = authTableRow;
    }

    i = 0;
    _authTableString = '     V   W   X   Y   Z \n-----------------------\n';
    for (var element in BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_Y_AXIS) {
      _authTableString = _authTableString +
          ' ' +
          element +
          '   ' +
          authCode[i].toString().padLeft(2, '0') +
          '  ' +
          authCode[i + 1].toString().padLeft(2, '0') +
          '  ' +
          authCode[i + 2].toString().padLeft(2, '0') +
          '  ' +
          authCode[i + 3].toString().padLeft(2, '0') +
          '  ' +
          authCode[i + 4].toString().padLeft(2, '0') +
          '\n';
      i += 5;
    }

    List<String> authCodeList = [];
    for (int i = 0; i < 65; i++) {
      authCodeList.add(authCode[i].toString().padLeft(2, '0'));
    }
    _currentAuthTableCustom = authCodeList.join(' ');

    _tableAuthentificationCode = BundeswehrTalkingBoardAuthentificationTable(
        yAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_Y_AXIS,
        xAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS,
        Content: authCode);
  }

  void _buildNumeralCode(
      {required bool custom, required String xAxis, required String yAxis}) {
    List<String> _yAxisTitle;
    List<String> _xAxisTitle;
    List<String> _numeralCode = [];

    if (custom) {
      if (xAxis.isEmpty || yAxis.isEmpty) {
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

      _yAxisTitle = yAxis.toUpperCase().split('');
      _xAxisTitle = xAxis.toUpperCase().split('');
    } else {
      // random
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

      _xAxisTitle = description.substring(0, 13).split('');
      _yAxisTitle = description.substring(13).split('');
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
        '   ' + _xAxisTitle.join(' ') + '\n----------------------------\n ';
    for (var row in _yAxisTitle) {
      _numeralCodeString = _numeralCodeString + row + ' ';
      for (int j = 0; j < 13; j++) {
        _numeralCodeString =
            _numeralCodeString + _numeralCode[i * 13 + j] + ' ';
      }
      i++;
      _numeralCodeString = _numeralCodeString + '\n ';
    }

    _currentNumeralCodeXaxisCustom = _xAxisTitle.join('');
    _currentNumeralCodeYaxisCustom = _yAxisTitle.join('');

    _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(
        xAxis: _xAxisTitle, yAxis: _yAxisTitle, Content: _numeralCode);
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

  void _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.right) {
      // check auth
      _currentOutput = checkAuthBundeswehr(
          _currentCallSign.toUpperCase(),
          _currentAuthInput.toUpperCase(),
          _currentLetterAuth.toUpperCase(),
          _tableNumeralCode,
          _tableAuthentificationCode);
    } else {
      // build auth
      _currentOutput = buildAuthBundeswehr(
          _currentCallSign.toUpperCase(),
          _currentLetterAuth.toUpperCase(),
          _currentLetterCallSign.toUpperCase(),
          _tableNumeralCode,
          _tableAuthentificationCode);
      if (_currentOutput.ResponseCode.contains(BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_OK)) {
        _currentAuthCode1 = _currentOutput.Tupel1![0];
        _currentAuthCode2 = _currentOutput.Tupel2![0];
        _currentAuthCode3 = _currentOutput.Tupel3![0];
        _currentCopyText = _currentAuthCode1 +
            ' ' +
            _currentAuthCode2 +
            ' ' +
            _currentAuthCode3;
      }
    }
  }
}
