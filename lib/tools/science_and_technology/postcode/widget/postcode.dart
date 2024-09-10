import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/postcode/logic/postcode.dart';

class Postcode extends StatefulWidget {
  const Postcode({Key? key}) : super(key: key);

  @override
  PostcodeState createState() => PostcodeState();
}

class PostcodeState extends State<Postcode> {
  late CodeController _decodeGraphicController;
  late TextEditingController _decodeController;
  late TextEditingController _encodePostalCodeController;

  String _currentDecodeInput = '';
  String _currentEncodePostalCode = '';
  int _currentEncodeStreetCode = 0;
  int _currentEncodeHouseNumber = 0;
  int _currentEncodeFeeProtectionCode = 0;
  var _currentEncodeFormat = PostcodeFormat.Linear80;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _decodeGraphicController = CodeController();
    _decodeController = TextEditingController(text: _currentDecodeInput);
    _encodePostalCodeController = TextEditingController(text: _currentEncodePostalCode);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    _encodePostalCodeController.dispose();
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
              _buildOutput();
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? buildEncodeWidget(context)
            : buildDecodeWidget(context),
        _buildOutput()
      ],
    );
  }

  Widget buildDecodeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _decodeController,
          hintText: i18n(context, 'postcode_valid_character') + ' (0 => 0.-_  1 => 1Il|)',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[/./-_ 01Il/|]')),
          ],
          onChanged: (text) {
            setState(() {
              _currentDecodeInput = text;
              _buildOutput();
            });
          },
        )
      ],
    );
  }

  Widget buildEncodeWidget(BuildContext context) {
    const flexValues =[1, 1];
    return Column(
      children: <Widget>[
        GCWDropDown<PostcodeFormat>(
          flexValues: const [2, 3],
          title: i18n(context, 'common_outputformat'),
          value: _currentEncodeFormat,
          onChanged: (value) {
            setState(() {
              _currentEncodeFormat = value;
              _buildOutput();
            });
           },
          items: _buildFormatList(),
        ),
        Row(
          children: <Widget>[
            Expanded(
                flex: flexValues[0],
                child: GCWText(
                  text:  i18n(context, 'postcode_postalcode')+ ':',
                )),
            Expanded(
              flex: flexValues[1],
              child: GCWTextField(
                controller: _encodePostalCodeController,
                maxLength: _currentEncodeFormat == PostcodeFormat.Linear30 ? 4: 5,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentEncodePostalCode = text;
                    _buildOutput();
                  });
                },
              ),
            )
        ]),
        _currentEncodeFormat == PostcodeFormat.Linear69 || _currentEncodeFormat == PostcodeFormat.Linear80
            ? GCWIntegerSpinner(
                title: i18n(context, 'postcode_streetcode'),
                value: _currentEncodeStreetCode,
                min: 0,
                max: 999,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeStreetCode = value;
                    _buildOutput();
                  });
                },
                flexValues: flexValues,
              )
            : Container(),
        _currentEncodeFormat == PostcodeFormat.Linear69 || _currentEncodeFormat == PostcodeFormat.Linear80
            ? GCWIntegerSpinner(
                title: i18n(context, 'postcode_housenumber'),
                value: _currentEncodeHouseNumber,
                min: 0,
                max: 999,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeHouseNumber = value;
                    _buildOutput();
                  });
                },
                flexValues: flexValues,
              )
            : Container(),
          _currentEncodeFormat == PostcodeFormat.Linear80
            ? GCWIntegerSpinner(
                title: i18n(context, 'postcode_feeprotectioncode'),
                value: _currentEncodeFeeProtectionCode,
                min: 0,
                max: 99,
                onChanged: (value) {
                  setState(() {
                    _currentEncodeFeeProtectionCode = value;
                    _buildOutput();
                  });
                },
                flexValues: flexValues,
              )
            : Container(),
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      var result = encodePostcode(_currentEncodePostalCode, _currentEncodeStreetCode, _currentEncodeHouseNumber,
          _currentEncodeFeeProtectionCode, _currentEncodeFormat);
      switch (result) {
        case 'postalCodeLength':
          result = i18n(context, 'common_invalid') + ' (' + i18n(context, 'postcode_postalcode') +
             ', ' + i18n(context, 'common_length') + ')';
        case 'postalCodeData':
          result = i18n(context, 'common_invalid') + ' (' + i18n(context, 'postcode_postalcode') + ')';
        case 'streetCodeLength':
          result = i18n(context, 'common_invalid') + ' (' + i18n(context, 'postcode_streetcode') +
              ', ' + i18n(context, 'common_length') + ')';
        case 'houseNumberLength':
          result = i18n(context, 'common_invalid') + ' (' + i18n(context, 'postcode_housenumber') +
              ', ' + i18n(context, 'common_length') + ')';
        case 'feeProtectionCodeLength':
          result = i18n(context, 'common_invalid') + ' (' + i18n(context, 'postcode_feeprotectioncode') +
              ', ' + i18n(context, 'common_length') + ')';
      }
      return GCWDefaultOutput(child: result);
    } else {
      var result = decodePostcode(_currentDecodeInput);
      switch (result.errorCode) {
        case  ErrorCode.Ok:
        case  ErrorCode.Invalid:
          List<List<Object>> output = [];

          var linearCodeString = i18n(context, 'postcode_linearcode') + '-';
          switch (result.format) {
            case PostcodeFormat.Linear30:
              linearCodeString += '30';
              break;
            case PostcodeFormat.Linear36:
              linearCodeString += '36';
              break;
            case PostcodeFormat.Linear69:
              linearCodeString += '69';
              break;
            default:
              linearCodeString += '80';
              break;
          }
          output.add([i18n(context, 'common_type'), linearCodeString]);

          output.add([i18n(context, 'postcode_postalcode'), result.postalCode]);
          var checkDigit = result.postalCodeCheckDigit;
          checkDigit += ' (' + i18n(context, (result.postalCodeCheckDigitOk ? 'common_valid': 'common_invalid')) + ')';
          output.add([i18n(context, 'postcode_postalcode_checkdigit'), checkDigit]);

          if (result.streetCode.isNotEmpty) {
            output.add([i18n(context, 'postcode_streetcode'), result.streetCode]);
          }
          if (result.houseNumber.isNotEmpty) {
            output.add([i18n(context, 'postcode_housenumber'), result.houseNumber]);
          }
          if (result.feeProtectionCode.isNotEmpty) {
            output.add([i18n(context, 'postcode_feeprotectioncode'), result.feeProtectionCode]);
          }
          if (result.errorCode == ErrorCode.Invalid) {
            output.add([i18n(context, 'postcode_invalid_data'), '']);
          }
          var extendedOutput = result.extendedOutput(
              i18n(context, 'postcode_postalcode'),
              'CS',
              i18n(context, 'postcode_streetcode'),
              i18n(context, 'postcode_housenumber'),
              i18n(context, 'postcode_feeprotectioncode'));
          _decodeGraphicController.text = extendedOutput;

          return Column(children: [
            GCWDefaultOutput(child:
              GCWColumnedMultilineOutput(data: output, flexValues: const [3, 2]),
            ),
            GCWTextDivider(text: i18n(context, 'common_details')),
            extendedOutput.isEmpty
              ? Container()
              : CodeField(
                  controller: _decodeGraphicController,
                  textStyle: gcwMonotypeTextStyle(),
                  lineNumbers: false,
                  lineNumberStyle: const LineNumberStyle(
                    width: 0.0,
                    margin: 0.0,
                    textStyle: TextStyle(fontSize: 0.0))
                ),
          ]);

        case ErrorCode.Length:
          if (_currentDecodeInput.isNotEmpty) {
            return GCWDefaultOutput(child: i18n(context, 'postcode_invalid_length') + ' (30, 36, 69, 80)');
          } else {
            return const GCWDefaultOutput(child: '');
          }
        case ErrorCode.Character:
          return GCWDefaultOutput(child: i18n(context, 'postcode_invalid_character'));
        default:
          return GCWDefaultOutput(child: i18n(context, 'postcode_invalid_data'));
      }
    }
  }

  List<GCWDropDownMenuItem<PostcodeFormat>> _buildFormatList() {
    var linearCodeString = i18n(context, 'postcode_linearcode') + '-';
    return [
      GCWDropDownMenuItem(value: PostcodeFormat.Linear80, child: linearCodeString + '80'),
      GCWDropDownMenuItem(value: PostcodeFormat.Linear69, child: linearCodeString + '69'),
      GCWDropDownMenuItem(value: PostcodeFormat.Linear36, child: linearCodeString + '36'),
      GCWDropDownMenuItem(value: PostcodeFormat.Linear30, child: linearCodeString + '30'),
    ];
  }
}
