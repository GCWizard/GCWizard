import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/widget/uic_wagoncode.dart';
import 'package:prefs/prefs.dart';

class CheckDigitsCheckNumber extends StatefulWidget {
  final CheckDigitsMode mode;

  const CheckDigitsCheckNumber({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  CheckDigitsCheckNumberState createState() => CheckDigitsCheckNumberState();
}

class CheckDigitsCheckNumberState extends State<CheckDigitsCheckNumber> {
  String _currentInputNumberString = '';
  String _currentGTINOutput = '';
  BINIINDetail _currentBINIINOutput = BINIINDetail(
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  );
  Widget _outputBINIINDetailWidget = Container();

  late TextEditingController currentInputController;
  late TextEditingController currentInputControllerID;
  late TextEditingController currentInputControllerDateBirth;
  late TextEditingController currentInputControllerDateValid;
  late TextEditingController currentInputControllerCheckDigit;

  @override
  void initState() {
    super.initState();
    currentInputController = TextEditingController(text: _currentInputNumberString);
  }

  @override
  void dispose() {
    currentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        (widget.mode == CheckDigitsMode.ISBN ||
                widget.mode == CheckDigitsMode.IBAN ||
                widget.mode == CheckDigitsMode.EURO ||
                widget.mode == CheckDigitsMode.EAN_GTIN ||
                widget.mode == CheckDigitsMode.UIC ||
                widget.mode == CheckDigitsMode.DETAXID ||
                widget.mode == CheckDigitsMode.CREDITCARD ||
                widget.mode == CheckDigitsMode.IMEI)
            ? GCWTextField(
                controller: currentInputController,
                inputFormatters: [INPUTFORMATTERS[widget.mode]!],
                onChanged: (text) {
                  setState(() {
                    _currentInputNumberString = checkDigitsNormalizeNumber(text);
                  });
                },
              )
            : Container(),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    CheckDigitOutput checked =
        checkDigitsCheckNumber(widget.mode, checkDigitsNormalizeNumber(_currentInputNumberString));

    bool deBankAccountDoesNotExist = checkDigitsIBANDEBankNumberDoesNotExist(_currentInputNumberString);

    if (checked.correct) {
      return Column(
        children: <Widget>[
          GCWDefaultOutput(
            child: i18n(context, 'checkdigits_checknumber_correct_yes'),
          ),
          _detailsWidget(),
          if (_currentInputNumberString.toUpperCase().substring(0, 2) == 'DE' && deBankAccountDoesNotExist)
            Column(
              children: <Widget>[
                GCWOutput(
                  title: i18n(context, 'checkdigits_hint'),
                  suppressCopyButton: true,
                  child: i18n(context, 'checkdigits_iban_hint_iban_de_invalid_banknumber'),
                ),
                GCWOutput(
                  title: i18n(context, 'checkdigits_hint'),
                  suppressCopyButton: true,
                  child: i18n(context, 'checkdigits_iban_hint_iban_single'),
                ),
              ],
            ),
          if (_currentInputNumberString.toUpperCase().substring(0, 2) == 'DE' && deBankAccountDoesNotExist)
            _detailsBankData(),
        ],
      );
    }

    if (checked.correctDigit.startsWith('check')) {
      return GCWDefaultOutput(
        child: i18n(context, checked.correctDigit),
      );
    }

    Map<String, String> output = {};
    for (int i = 0; i < checked.correctNumbers.length; i++) {
      output[(i + 1).toString() + '.'] = checked.correctNumbers[i];
    }

    String title = i18n(context, 'checkdigits_checknumber_correct_assume_check');

    if (output.isEmpty) {
      title = title + '\n' + i18n(context, 'checkdigits_checknumber_correct_no_number');
    } else {
      title = title + '\n' + i18n(context, 'checkdigits_checknumber_correct_number');
    }
    return Column(children: [
      GCWDefaultOutput(
        child: i18n(context, 'checkdigits_checknumber_correct_no'),
        suppressCopyButton: true,
      ),
      GCWOutput(
        title: i18n(context, 'checkdigits_checknumber_correct_assume_number') +
            '\n' +
            i18n(context, 'checkdigits_checknumber_correct_check'),
        child: checked.correctDigit,
      ),
      GCWOutput(
        title: title,
        child: GCWColumnedMultilineOutput(
            data: output.entries.map((entry) {
              return [entry.key, entry.value];
            }).toList(),
            flexValues: const [1, 5]),
      ),
      (widget.mode == CheckDigitsMode.IBAN && checkDigitsIBANDEBankNumberDoesNotExist(_currentInputNumberString))
          ? GCWOutput(
              title: i18n(context, 'checkdigits_hint'),
              suppressCopyButton: true,
              child: i18n(context, 'checkdigits_iban_hint_iban_single'),
            )
          : Container(),
    ]);
  }

  Widget _detailsBankData() {
    Widget result = Container();
    List<String> bankData = [];
    if (_currentInputNumberString.length > 12) {
      if (CHECKDIGITS_IBAN_DE_BANK_ACCOUNT_DATA[int.parse(_currentInputNumberString.substring(4, 12))] != null) {
        bankData = CHECKDIGITS_IBAN_DE_BANK_ACCOUNT_DATA[int.parse(_currentInputNumberString.substring(4, 12))]!;
        result = GCWOutput(
          title: i18n(context, 'checkdigits_iban_data_details'),
          suppressCopyButton: true,
          child: GCWColumnedMultilineOutput(
            copyColumn: 1,
            data: [
              [i18n(context, 'checkdigits_iban_data_details_name'), bankData[0]],
              [i18n(context, 'checkdigits_iban_data_details_city'), bankData[1] + ' ' + bankData[2]],
              [i18n(context, 'checkdigits_iban_data_details_bic'), bankData[3]],
            ],
            flexValues: const [2, 4],
          ),
        );
      }
    }
    return result;
  }

  Widget _detailsWidget() {
    switch (widget.mode) {
      case CheckDigitsMode.EAN_GTIN:
        return _detailsEANWidget();
      case CheckDigitsMode.EURO:
        return _detailsEUROWidget();
      case CheckDigitsMode.UIC:
        return _detailsUICWidget();
      case CheckDigitsMode.IMEI:
        return _detailsIMEIWidget();
      case CheckDigitsMode.ISBN:
        return _detailsISBNWidget();
      case CheckDigitsMode.IBAN:
        return _detailsIBANWidget();
      case CheckDigitsMode.CREDITCARD:
        return _detailsCreditCardBINIINWidget();
      default:
        return Container();
    }
  }

  Widget _detailsEANWidget() {
    return Column(children: <Widget>[
      GCWButton(
        text: i18n(context, 'checkdigits_ean_get_details'),
        onPressed: () {
          showGCWDialog(context, i18n(context, 'checkdigits_ean_get_details'),
              SizedBox(width: 300, height: 130, child: Text(i18n(context, 'checkdigits_ean_get_details_allow'))), [
            GCWDialogButton(
              text: i18n(context, 'common_ok'),
              onPressed: () {
                setState(() {
                  _getOpenGTINDBtask();
                });
              },
            )
          ]);

          setState(() {});
        },
      ),
      _outputBINIINDetailWidget
    ]);
  }

  Widget _detailsCreditCardBINIINWidget() {
    return Column(children: <Widget>[
      _detailsCreditCardNumbersWidget(),
      GCWButton(
        text: i18n(context, 'checkdigits_creditcard_get_details'),
        onPressed: () {
          showGCWDialog(
              context,
              i18n(context, 'checkdigits_creditcard_get_details'),
              SizedBox(width: 300, height: 130, child: Text(i18n(context, 'checkdigits_creditcard_get_details_allow'))),
              [
                GCWDialogButton(
                  text: i18n(context, 'common_ok'),
                  onPressed: () {
                    setState(() {
                      _getOpenBINIINDBtask();
                    });
                  },
                )
              ]);
          setState(() {});
        },
      ),
      _outputBINIINDetailWidget,
    ]);
  }

  Widget _detailsUICWidget() {
    return GCWButton(
        text: i18n(context, 'checkdigits_uic_openinuicwagoncode'),
        onPressed: () {
          openInUICWagonCode(context, _currentInputNumberString);
        });
  }

  Widget _detailsEUROWidget() {
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        copyColumn: 1,
        data: _EUROData(checkDigitsNormalizeNumber(_currentInputNumberString)),
        flexValues: const [3, 1, 5],
      ),
    );
  }

  Widget _detailsIMEIWidget() {
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        copyColumn: 1,
        data: _IMEIData(checkDigitsNormalizeNumber(_currentInputNumberString)),
        flexValues: const [4, 2, 4],
      ),
    );
  }

  Widget _detailsISBNWidget() {
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        copyColumn: 1,
        data: _ISBNData(checkDigitsNormalizeNumber(_currentInputNumberString)),
        flexValues: const [4, 2, 4],
      ),
    );
  }

  Widget _detailsIBANWidget() {
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        copyColumn: 0,
        data: _IBANData(checkDigitsNormalizeNumber(_currentInputNumberString.toUpperCase())),
        flexValues: const [4, 4],
      ),
    );
  }

  Widget _detailsCreditCardNumbersWidget() {
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        copyColumn: 1,
        data: _CreditCardData(checkDigitsNormalizeNumber(_currentInputNumberString.toUpperCase())),
        flexValues: const [5, 3, 4],
      ),
    );
  }

  void _getOpenGTINDBtask() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 150,
            child: GCWAsyncExecuter<OpenGTINDBOutput>(
              isolatedFunction: OpenGTINDBrunTaskAsync,
              parameter: _buildGTINDBgetJobData,
              onReady: (data) => _showOpenGTINDBOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters> _buildGTINDBgetJobData() async {
    return GCWAsyncExecuterParameters(OpenGTINDBgetJobData(
      ean: checkDigitsNormalizeNumber(_currentInputNumberString),
      apikey: Prefs.get(PREFERENCE_EAN_DEFAULT_OPENGTIN_APIKEY).toString(),
    ));
  }

  void _showOpenGTINDBOutput(OpenGTINDBOutput output) {
    List<List<String>> data = [];
    if (output.status == OPENGTINDB_STATUS.OK) {
      _currentGTINOutput = output.eanData;
      List<String> lineElements = [];
      for (String line in _currentGTINOutput.split('\n')) {
        if (!line.startsWith('---')) {
          lineElements = line.split('=');
          if (lineElements.length == 2) {
            if (lineElements[0] == 'content') {
              data.add([lineElements[0], OPENGTINDB_CONTENTS[lineElements[1]].toString()]);
            } else if (lineElements[0] == 'packs') {
              data.add([lineElements[0], OPENGTINDB_PACKS[lineElements[1]].toString()]);
            } else {
              data.add([lineElements[0], lineElements[1]]);
            }
          }
        }
      }
    } else {
      data.add([i18n(context, 'checkdigits_ean_server_error_code'), output.httpCode]);
      data.add([i18n(context, 'checkdigits_ean_server_error_message'), output.httpMessage]);
      data.add([i18n(context, 'checkdigits_ean_error_error'), i18n(context, output.eanData)]);
    }
    _outputBINIINDetailWidget = GCWColumnedMultilineOutput(
      data: data,
      flexValues: const [2, 4],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //     _currentGTINOutput = output.eanData;
      //     _outputDetailWidget = GCWDefaultOutput(child: _currentGTINOutput);
      setState(() {});
    });
  }

  void _getOpenBINIINDBtask() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 150,
            child: GCWAsyncExecuter<OpenBINIINDBOutput>(
              isolatedFunction: OpenBINIINDBrunTaskAsync,
              parameter: _buildBINIINDBgetJobData,
              onReady: (data) => _showOpenBINIINDBOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters> _buildBINIINDBgetJobData() async {
    return GCWAsyncExecuterParameters(OpenBINIINDBgetJobData(
      biniin: checkDigitsNormalizeNumber(_currentInputNumberString),
    ));
  }

  void _showOpenBINIINDBOutput(OpenBINIINDBOutput output) {
    List<List<String>> data = [];
    if (output.status == OPENBINIINDB_STATUS.OK) {
      _currentBINIINOutput = output.BINIINData;
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_number_length'),
        _showBINIINData(_currentBINIINOutput.number_length)
      ]);
      data.add(
          [i18n(context, 'checkdigits_creditcard_get_details_scheme'), _showBINIINData(_currentBINIINOutput.scheme)]);
      data.add([i18n(context, 'checkdigits_creditcard_get_details_type'), _showBINIINData(_currentBINIINOutput.type)]);
      data.add(
          [i18n(context, 'checkdigits_creditcard_get_details_brand'), _showBINIINData(_currentBINIINOutput.brand)]);
      data.add(
          [i18n(context, 'checkdigits_creditcard_get_details_prepaid'), _showBINIINData(_currentBINIINOutput.prepaid)]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_country_numeric'),
        _showBINIINData(_currentBINIINOutput.country_numeric)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_country_alpha2'),
        _showBINIINData(_currentBINIINOutput.country_alpha2)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_country_name'),
        _showBINIINData(_currentBINIINOutput.country_name)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_bank_name'),
        _showBINIINData(_currentBINIINOutput.bank_name)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_bank_url'),
        _showBINIINData(_currentBINIINOutput.bank_url)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_bank_phone'),
        _showBINIINData(_currentBINIINOutput.bank_phone)
      ]);
      data.add([
        i18n(context, 'checkdigits_creditcard_get_details_bank_city'),
        _showBINIINData(_currentBINIINOutput.bank_city)
      ]);
    } else {
      data.add([i18n(context, 'checkdigits_creditcard_server_error_code'), output.httpCode]);
      data.add([i18n(context, 'checkdigits_creditcard_server_error_message'), output.httpMessage]);
    }
    _outputBINIINDetailWidget = GCWColumnedMultilineOutput(
      data: data,
      flexValues: const [2, 4],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  String _showBINIINData(String data) {
    if (data == 'null') {
      return i18n(context, 'checkdigits_creditcard_get_details_unknown');
    }
    return data;
  }

  List<List<String>> _EUROData(String number) {
    var checkedNumber = checkEuroSeries(number);

    return [
      [i18n(context, 'checkdigits_euro_countrycode'), number[0] + (checkedNumber != 1 ? number[1] : '')],
      [
        i18n(context, 'checkdigits_euro_country'),
        i18n(
            context,
            checkedNumber == 1
                ? EUROBANKNOTEDATA[1]![number[0]]!['country']!
                : EUROBANKNOTEDATA[2]![number[0]]!['country']!)
      ],
      if (checkedNumber != 1)
        [i18n(context, 'checkdigits_euro_institute'), EUROBANKNOTEDATA[2]![number[0]]!['institute']!]
    ];
  }

  List<List<String>> _IMEIData(String number) {
    return [
      [i18n(context, 'checkdigits_imei_reporting_body_identifier'), number.substring(0, 2), ''],
      [i18n(context, 'checkdigits_imei_type_allocation_code'), number.substring(2, 8), ''],
      [i18n(context, 'uic_runningnumber'), number.substring(8, 14), ''],
      [i18n(context, 'uic_checkdigit'), number.substring(14), ''],
    ];
  }

  List<List<String>> _CreditCardData(String number) {
    List<List<String>> result = [];
    result.add([
      i18n(context, 'checkdigits_creditcard_major_industry_identifier'),
      number.substring(0, 1),
      i18n(context, CHECKDIGITS_CREDITCARD_MMI[number.substring(0, 1)]!)
    ]);
    result.add([i18n(context, 'checkdigits_creditcard_issuer_identification_number'), number.substring(0, 6), '']);
    List<String> binData = _CreditCardSchemeData(number);
    if (binData.isNotEmpty) {
      result.add(binData);
    }
    if (binData.isEmpty) {
      result.add([
        i18n(context, 'checkdigits_creditcard_issuer'),
        number.substring(0, 2),
        (CHECKDIGITS_CREDITCARD_PREFIX[number.substring(0, 2)]) != null
            ? CHECKDIGITS_CREDITCARD_PREFIX[number.substring(0, 2)]!
            : i18n(context, 'checkdigits_creditcard_issuer_unknown'),
      ]);
    }
    result.add([i18n(context, 'checkdigits_creditcard_type_of_card_i'), number.substring(4, 5), '']);
    result.add([i18n(context, 'checkdigits_creditcard_type_of_card_ii'), number.substring(5, 6), '']);
    result.add([i18n(context, 'checkdigits_creditcard_account_number'), number.substring(6, number.length - 1), '']);
    result.add([i18n(context, 'checkdigits_checkdigit'), number.substring(number.length - 1), '']);
    return result;
  }

  List<String> _CreditCardSchemeData(String number) {
    int bin = int.parse(number.substring(0, 6));
    List<String> result = [];
    CHECKDIGITS_CREDITCARD_CARDSCHEMES.forEach((key, value) {
      if (bin >= key) {
        if (bin <= (value[0] as int)) {
          result = ['', (value[1].toString()), ''];
        }
      }
    });
    return result;
  }

  List<List<String>> _ISBNData(String number) {
    String prefix = '';
    String group = '';
    String publisher = '';
    String checkdigit = '';
    if (number.length == 13) {
      prefix = number.substring(0, 3);
      number = number.substring(3);
    }
    if (number[0] == '0' ||
        number[0] == '1' ||
        number[0] == '2' ||
        number[0] == '3' ||
        number[0] == '4' ||
        number[0] == '5' ||
        number[0] == '7') {
      group = number[0];
      publisher = number.substring(2, 9);
    } else if (number[0] == '8' ||
        (number[0] == '9' &&
            (number[1] == '0' || number[1] == '1' || number[1] == '2' || number[1] == '3' || number[1] == '4'))) {
      group = number.substring(0, 2);
      publisher = number.substring(2, 9);
    } else {
      int groupNumber = int.parse(number.substring(0, 3));
      if ((600 <= groupNumber && groupNumber <= 649) || (950 <= groupNumber && groupNumber <= 989)) {
        group = number.substring(0, 3);
        publisher = number.substring(3, 9);
      } else {
        int groupNumber = int.parse(number.substring(0, 4));
        if ((9900 <= groupNumber && groupNumber <= 9989)) {
          group = number.substring(0, 4);
          publisher = number.substring(4, 9);
        } else {
          int groupNumber = int.parse(number.substring(0, 5));
          if ((99900 <= groupNumber && groupNumber <= 99999)) {
            group = number.substring(0, 5);
            publisher = number.substring(5, 9);
          }
        }
      }
    }

    checkdigit = number.substring(9);
    return [
      [i18n(context, 'checkdigits_isbn_prefix'), prefix, ''],
      [i18n(context, 'checkdigits_isbn_group'), group, ''],
      [i18n(context, 'checkdigits_isbn_publisher'), publisher, ''],
      [i18n(context, 'checkdigits_isbn_check_digit'), checkdigit, ''],
    ];
  }

  List<List<String>> _IBANData(String number) {
    List<List<String>> result = [];
    if (IBAN_DATA[number.substring(0, 2)] == null) {
      result.add([
        i18n(context, 'checkdigits_country'),
        number.substring(0, 2) + ' ' + '(' + i18n(context, 'checkdigits_iban_country_code_unknown') + ')'
      ]);
      result.add([i18n(context, 'checkdigits_checkdigit'), number.substring(2, 4)]);
      result.add([
        '',
        number.substring(
          4,
        )
      ]);
    } else {
      List<Map<String, Object>> countryData = IBAN_DATA[number.substring(0, 2)]!;
      result.add([
        i18n(context, 'checkdigits_country'),
        number.substring(0, 2) + ' ' + '(' + i18n(context, countryData[0]['country'] as String) + ')'
      ]);
      result.add([i18n(context, 'checkdigits_checkdigit'), number.substring(2, 4)]);
      int index = 4;
      int digits = 0;
      for (var country in countryData) {
        for (var element in country.entries) {
          if (element.key == 'b' ||
              element.key == 's' ||
              element.key == 'k' ||
              element.key == 'K' ||
              element.key == 'd' ||
              element.key == 'X' ||
              element.key == 'r') {
            digits = element.value as int;
            result.add([i18n(context, IBAN_DATA_MEANING[element.key]!), number.substring(index, index + digits)]);
            index = index + digits;
          }
        }
      }
    }
    return result;
  }
}
