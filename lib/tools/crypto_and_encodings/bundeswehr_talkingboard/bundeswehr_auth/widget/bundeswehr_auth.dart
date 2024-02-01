import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/logic/bundeswehr_auth.dart';

class BundeswehrTalkingBoardAuthentification extends StatefulWidget {
  const BundeswehrTalkingBoardAuthentification({Key? key}) : super(key: key);

  @override
  _BundeswehrTalkingBoardAuthentificationState createState() => _BundeswehrTalkingBoardAuthentificationState();
}

class _BundeswehrTalkingBoardAuthentificationState extends State<BundeswehrTalkingBoardAuthentification> {
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
      BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
  BundeswehrTalkingBoardAuthentificationTable _tableAuthentificationCode =
      BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);

  String _authTableString = '';
  String _numeralCodeString = '';

  final _authTableMaskFormatter = GCWMaskTextInputFormatter(mask: '## ' * 64 + '##', filter: {"#": RegExp(r'\d')});

  final _authCodeMaskFormatter = GCWMaskTextInputFormatter(mask: '## ' * 2 + '##', filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeXAxisCodeMaskFormatter =
      GCWMaskTextInputFormatter(mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  final _numeralCodeYAxisCodeMaskFormatter =
      GCWMaskTextInputFormatter(mask: '#' * 13, filter: {"#": RegExp(r'[a-zA-Z]')});

  final _callsignLetterMaskFormatter = GCWMaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[a-zA-Z]')});

  var _currentMode = GCWSwitchPosition.right;
  var _currentTableMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _inputAuthController = TextEditingController(text: _currentAuthInput);
    _callSignController = TextEditingController(text: _currentCallSign);
    _letterControllerAuth = TextEditingController(text: _currentLetterAuth);
    _letterControllerCallSign = TextEditingController(text: _currentLetterCallSign);
    _authTableCustom = TextEditingController(text: _currentAuthTableCustom);
    _numeralCodeCustomXaxis = TextEditingController(text: _currentNumeralCodeXaxisCustom);
    _numeralCodeCustomYaxis = TextEditingController(text: _currentNumeralCodeYaxisCustom);
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
        GCWTwoOptionsSwitch(
          rightValue: i18n(context, 'bundeswehr_talkingboard_auth_mode_auth_check'),
          leftValue: i18n(context, 'bundeswehr_talkingboard_auth_mode_auth'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextField(
          title: i18n(context, 'bundeswehr_talkingboard_auth_call_sign'),
          controller: _callSignController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          ],
          onChanged: (text) {
            setState(() {
              _currentCallSign = text;
            });
          },
        ),
        GCWDropDownSpinner(
          title: i18n(context, 'bundeswehr_talkingboard_auth_letter_auth'),
          index: _currentLetterAuthIndex,
          items: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS
              .map((item) => Text(item.toString(), style: gcwTextStyle()))
              .toList(),
          onChanged: (value) {
            setState(() {
              _currentLetterAuthIndex = value;
              _currentLetterAuth = BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS[value];
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right // Check Auth
            ? GCWTextField(
                title: i18n(context, 'bundeswehr_talkingboard_auth_authentification_code'),
                controller: _inputAuthController,
                hintText: 'FW ST CD',
                inputFormatters: [_authCodeMaskFormatter],
                onChanged: (text) {
                  setState(() {
                    _currentAuthInput = (text.isEmpty) ? '' : _authCodeMaskFormatter.getMaskedText();
                  });
                })
            : GCWTextField(
                title: i18n(context, 'bundeswehr_talkingboard_auth_letter_callsign'),
                controller: _letterControllerCallSign,
                inputFormatters: [_callsignLetterMaskFormatter],
                onChanged: (text) {
                  setState(() {
                    _currentLetterCallSign = (text.isEmpty) ? '' : _callsignLetterMaskFormatter.getMaskedText();
                  });
                },
              ),
        _currentMode == GCWSwitchPosition.left // Build Auth
            ? GCWTwoOptionsSwitch(
                title: i18n(context, 'bundeswehr_talkingboard_auth_table_mode'),
                rightValue: i18n(context, 'bundeswehr_talkingboard_auth_table_mode_random'),
                leftValue: i18n(context, 'bundeswehr_talkingboard_auth_table_mode_custom'),
                value: _currentTableMode,
                onChanged: (value) {
                  setState(() {
                    _currentTableMode = value;
                    if (_currentTableMode == GCWSwitchPosition.right) {
                      _buildNumeralCode(custom: false, xAxis: '', yAxis: '');
                      _buildAuthTable(custom: false, authTable: '');
                    } else {
                      if (_currentNumeralCodeXaxisCustom.isEmpty) {
                        _tableNumeralCode =
                            BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
                      }
                      if (_currentNumeralCodeYaxisCustom.isEmpty) {
                        _tableNumeralCode =
                            BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
                      }
                      if (_currentAuthTableCustom.isEmpty) {
                        _tableAuthentificationCode =
                            BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
                      }
                    }
                  });
                },
              )
            : Container(),
        GCWTextDivider(
          text: i18n(context, 'bundeswehr_talkingboard_auth_table_numeral_code'),
        ),
        Column(
          children: <Widget>[
            _currentTableMode == GCWSwitchPosition.right // Random
                ? GCWOutputText(
                    text: _numeralCodeString,
                    isMonotype: true,
                  )
                : Column(
                    children: <Widget>[
                      GCWTextField(
                        controller: _numeralCodeCustomXaxis,
                        hintText: i18n(context, 'bundeswehr_talkingboard_auth_table_numeral_code_x_axis'),
                        inputFormatters: [_numeralCodeXAxisCodeMaskFormatter],
                        onChanged: (text) {
                          setState(() {
                            _currentNumeralCodeXaxisCustom =
                                text.isEmpty ? '' : _numeralCodeXAxisCodeMaskFormatter.getMaskedText();
                          });
                        },
                      ),
                      GCWTextField(
                        controller: _numeralCodeCustomYaxis,
                        hintText: i18n(context, 'bundeswehr_talkingboard_auth_table_numeral_code_y_axis'),
                        inputFormatters: [_numeralCodeYAxisCodeMaskFormatter],
                        onChanged: (text) {
                          setState(() {
                            _currentNumeralCodeYaxisCustom =
                                text.isEmpty ? '' : _numeralCodeYAxisCodeMaskFormatter.getMaskedText();
                          });
                        },
                      ),
                    ],
                  ),
          ],
        ),
        GCWTextDivider(
          text: i18n(context, 'bundeswehr_talkingboard_auth_table_authentification_code'),
        ),
        Column(children: <Widget>[
          _currentTableMode == GCWSwitchPosition.right // random
              ? GCWOutputText(
                  text: _authTableString,
                  isMonotype: true,
                )
              : GCWTextField(
                  controller: _authTableCustom,
                  hintText: '38 24 44 34  61 38...',
                  inputFormatters: [_authTableMaskFormatter],
                  onChanged: (text) {
                    setState(() {
                      _currentAuthTableCustom = (text.isEmpty) ? '' : _authTableMaskFormatter.getMaskedText();
                    });
                  },
                ),
        ]),
        GCWTextDivider(
          text: i18n(context, 'common_output'),
        ),
        _calculateOutput(context),
      ],
    );
  }

  Widget _calculateOutput(BuildContext context) {
    BundeswehrTalkingBoardAuthentificationOutput output;

    _buildNumeralCode(
        custom: _currentTableMode == GCWSwitchPosition.left,
        xAxis: _currentNumeralCodeXaxisCustom,
        yAxis: _currentNumeralCodeYaxisCustom);

    _buildAuthTable(custom: _currentTableMode == GCWSwitchPosition.left, authTable: _currentAuthTableCustom);

    if (_currentMode == GCWSwitchPosition.right) {
      // check auth
      output = checkAuthBundeswehr(_currentCallSign.toUpperCase(), _currentAuthInput.toUpperCase(),
          _currentLetterAuth.toUpperCase(), _tableNumeralCode, _tableAuthentificationCode);
      if (output.ResponseCode.join('') == BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_OK) {
        return Column(
          children: <Widget>[
            GCWText(text: i18n(context, 'bundeswehr_talkingboard_auth_response_ok')),
            GCWExpandableTextDivider(
              text: i18n(context, 'bundeswehr_talkingboard_auth_details'),
              expanded: false,
              child: GCWText(text: output.Details ?? ''),
            )
          ],
        );
      } else {
        return GCWText(
          text: _buildResponse(output.ResponseCode),
        );
      }
    } else {
      // build auth
      output = buildAuthBundeswehr(_currentCallSign.toUpperCase(), _currentLetterAuth.toUpperCase(),
          _currentLetterCallSign.toUpperCase(), _tableNumeralCode, _tableAuthentificationCode);
      if (output.ResponseCode.join('') == BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_OK) {
        return Row(children: <Widget>[
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
                      value: '',
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: (output.Tupel1 ?? []).map((mode) {
                        return GCWDropDownMenuItem(
                          value: mode,
                          child: mode,
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
                      output.Number?[0] ?? '',
                    )),
                    GCWDropDown<String>(
                      value: '',
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: (output.Tupel2 ?? []).map((mode) {
                        return GCWDropDownMenuItem(
                          value: mode,
                          child: mode,
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
                      output.Number?[1] ?? '',
                    )),
                    GCWDropDown<String>(
                      value: '',
                      onChanged: (value) {
                        setState(() {});
                      },
                      items: (output.Tupel3 ?? []).map((mode) {
                        return GCWDropDownMenuItem(
                          value: mode,
                          child: mode,
                        );
                      }).toList(),
                    )
                  ],
                )),
          ),
        ]);
      } else {
        return GCWText(
          text: _buildResponse(output.ResponseCode),
        );
      }
    }
  }

  String _buildResponse(List<String> responseCodes) {
    return responseCodes.map((response) {
      return response.startsWith('bundeswehr_talkingboard') ? i18n(context, response) : response;
    }).join('\n');
  }

  void _buildAuthTable({required bool custom, required String authTable}) {
    List<String> authCode = [];
    Map<String, Map<String, String>> _authTable = {};

    if (custom) {
      if (authTable.isEmpty) {
        _authTableString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_AUTH_TABLE;
        return;
      }

      if (authTable.trim().split(' ').length != 65) {
        _tableAuthentificationCode = BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
        _authTableString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_AUTH_TABLE;
        return;
      }
      authTable.trim().split(' ').forEach((element) {
        if (element.length > 2) {
          _tableAuthentificationCode = BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
          _authTableString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_AUTH_TABLE;
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
      i = i + 5;
    }

    _tableAuthentificationCode = BundeswehrTalkingBoardAuthentificationTable(
        yAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_Y_AXIS,
        xAxis: BUNDESWEHR_TALKINGBOARD_AUTH_TABLE_X_AXIS,
        Content: authCode);
  }

  void _buildNumeralCode({required bool custom, required String xAxis, required String yAxis}) {
    List<String> _yAxisTitle;
    List<String> _xAxisTitle;
    List<String> _numeralCode = [];

    if (custom) {
      if (xAxis.isEmpty || yAxis.isEmpty) {
        _numeralCodeString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_NUMERAL_TABLE;
        return;
      }

      if (_invalidSingleAxisTitle(xAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
        _numeralCodeString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_X_AXIS_NUMERAL_TABLE;
        return;
      }

      if (_invalidSingleAxisTitle(yAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
        _numeralCodeString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_Y_AXIS_NUMERAL_TABLE;
        return;
      }

      if (_invalidAxisDescription(xAxis + yAxis)) {
        _tableNumeralCode = BundeswehrTalkingBoardAuthentificationTable(yAxis: [], xAxis: [], Content: []);
        _numeralCodeString = BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_INVALID_NUMERAL_TABLE;
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
    _numeralCodeString = '   ' + _xAxisTitle.join(' ') + '\n----------------------------\n ';
    for (var row in _yAxisTitle) {
      _numeralCodeString = _numeralCodeString + row + ' ';
      for (int j = 0; j < 13; j++) {
        _numeralCodeString = _numeralCodeString + _numeralCode[i * 13 + j] + ' ';
      }
      i++;
      _numeralCodeString = _numeralCodeString + '\n ';
    }

    _tableNumeralCode =
        BundeswehrTalkingBoardAuthentificationTable(xAxis: _xAxisTitle, yAxis: _yAxisTitle, Content: _numeralCode);
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
}
