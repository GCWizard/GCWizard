import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi.dart' as logic;

class UFI extends StatefulWidget {
  const UFI({Key? key}) : super(key: key);

  @override
  _UFIState createState() => _UFIState();
}

class _UFIState extends State<UFI> {
  var _currentMode = GCWSwitchPosition.right;
  var _currentCountryCode = logic.UFI_COMPANYKEY;

  var _currentVat = '';
  var _currentFormulation = '';
  late TextEditingController _vatController;
  late TextEditingController _formulationController;

  var _currentUFICode = '';
  late TextEditingController _ufiCodeController;

  final _countries = <String, String>{};

  late Widget _outputEncode;
  late Widget _outputDecode;

  final _ufiMaskFormatter =
      GCWMaskTextInputFormatter(mask: '####-' * 3 + '####', filter: {"#": RegExp(r'[A-Za-z0-9]')});

  @override
  void initState() {
    super.initState();

    _vatController = TextEditingController(text: _currentVat);
    _formulationController = TextEditingController(text: _currentFormulation);
    _ufiCodeController = TextEditingController(text: _currentUFICode);

    _outputEncode = const GCWDefaultOutput();
    _outputDecode = const GCWDefaultOutput();
  }

  @override
  void dispose() {
    _vatController.dispose();
    _formulationController.dispose();
    _ufiCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_countries.isEmpty) {
      var names = logic.UFI_DEFINITIONS.where((ufi) => ufi.countryCode != logic.UFI_COMPANYKEY).map((ufi) {
        return i18n(context, ufi.countryName);
      }).toList();

      names.sort();

      _countries.putIfAbsent(logic.UFI_COMPANYKEY, () => i18n(context, logic.UFI_COMPANYKEY));
      for (var name in names) {
        var ufi = logic.UFI_DEFINITIONS.firstWhere((ufi) => i18n(context, ufi.countryName) == name);
        _countries.putIfAbsent(ufi.countryCode, () => name + ' (' + ufi.countryCode + ')');
      }
    }

    return Column(
      children: [
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? Column(
                children: [
                  GCWDropDown(
                      title: i18n(context, 'ufi_country'),
                      value: _currentCountryCode,
                      items: _countries.entries.map((country) {
                        return GCWDropDownMenuItem(value: country.key, child: country.value);
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _currentCountryCode = value;
                        });
                      }),
                  GCWTextField(
                    title: _currentCountryCode == logic.UFI_COMPANYKEY
                        ? i18n(context, 'common_key')
                        : i18n(context, 'ufi_vat'),
                    controller: _vatController,
                    onChanged: (String text) {
                      setState(() {
                        _currentVat = text;
                      });
                    },
                  ),
                  GCWTextField(
                    title: i18n(context, 'ufi_formula'),
                    inputFormatters: [GCWIntegerTextInputFormatter()],
                    controller: _formulationController,
                    onChanged: (String text) {
                      setState(() {
                        _currentFormulation = text;
                      });
                    },
                  ),
                ],
              )
            : Column(
                children: [
                  GCWTextField(
                    title: 'UFI',
                    controller: _ufiCodeController,
                    inputFormatters: [_ufiMaskFormatter],
                    onChanged: (String text) {
                      setState(() {
                        _currentUFICode = text;
                      });
                    },
                  ),
                ],
              ),
        GCWSubmitButton(onPressed: () {
          setState(() {
            if (_currentMode == GCWSwitchPosition.left) {
              _outputEncode = _calculateEncode();
            } else {
              _outputDecode = _calculateDecode();
            }
          });
        }),
        _currentMode == GCWSwitchPosition.left ? _outputEncode : _outputDecode
      ],
    );
  }

  Widget _calculateDecode() {
    var ufiCode = _currentUFICode.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (ufiCode.length != 16) {
      return GCWDefaultOutput(
        child: i18n(context, 'ufi_ufi16length'),
      );
    }

    try {
      var ufi = logic.decodeUFI(ufiCode);
      return GCWDefaultOutput(
          child: GCWColumnedMultilineOutput(data: [
        ufi.countryCode == logic.UFI_COMPANYKEY
            ? [i18n(context, logic.UFI_COMPANYKEY), ufi.vatNumber]
            : [i18n(context, 'ufi_vat'), ufi.countryCode + ufi.vatNumber],
        [i18n(context, 'ufi_formula'), ufi.formulationNumber],
      ]));
    } catch (e) {
      return GCWDefaultOutput(
        child: i18n(context, e.toString().substring(11)),
      );
    }
  }

  Widget _calculateEncode() {
    if (_currentVat.isEmpty || _currentFormulation.isEmpty) {
      return GCWDefaultOutput(child: i18n(context, 'ufi_emptyinput'));
    }

    String out;
    try {
      var vat = _currentVat.toUpperCase();
      if (vat.startsWith(_currentCountryCode)) {
        vat = vat.substring(_currentCountryCode.length);
      }

      out = logic.encodeUFI(
          logic.UFI(countryCode: _currentCountryCode, vatNumber: vat, formulationNumber: _currentFormulation));
    } catch (e) {
      out = i18n(context, e.toString().substring(11));
    }

    return GCWDefaultOutput(child: out);
  }
}
