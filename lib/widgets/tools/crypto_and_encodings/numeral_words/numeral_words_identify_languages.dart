import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/numeral_words.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';

class NumeralWordsIdentifyLanguages extends StatefulWidget {
  @override
  NumeralWordsIdentifyLanguagesState createState() => NumeralWordsIdentifyLanguagesState();
}

class NumeralWordsIdentifyLanguagesState extends State<NumeralWordsIdentifyLanguages> {
  TextEditingController _decodeController;

  var _currentDecodeInput = '';
  GCWSwitchPosition _currentDecodeMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _decodeController,
          onChanged: (text) {
            setState(() {
              _currentDecodeInput = text;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentDecodeMode,
          leftValue: i18n(context, 'numeralwords_decodemode_left'),
          rightValue: i18n(context, 'numeralwords_decodemode_right'),
          onChanged: (value) {
            setState(() {
              _currentDecodeMode = value;
            });
          },
        ),
        GCWDefaultOutput(
          child: _buildOutput(context),
        )
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    List<NumeralWordsDecodeOutput> detailedOutput;
    String output = '';
    detailedOutput = decodeNumeralwords(
      input: removeAccents(_currentDecodeInput.toLowerCase()),
      language: NumeralWordsLanguage.ALL,
      decodeModeWholeWords: _currentDecodeMode == GCWSwitchPosition.left,
    );
    for (int i = 0; i < detailedOutput.length; i++) {
      if (detailedOutput[i].number != '') if (detailedOutput[i].number.startsWith('numeralwords_'))
        output = output + ' ' + i18n(context, detailedOutput[i].number);
      else
        output = output + detailedOutput[i].number;
    }

    List<List<String>> columnData = [];
    var flexData;
    String columnDataRowNumber;
    String columnDataRowNumWord;
    String columnDataRowLanguage;

    for (int i = 0; i < detailedOutput.length; i++) {
      if (detailedOutput[i].number.startsWith('numeralwords_'))
        columnDataRowNumber = i18n(context, detailedOutput[i].number);
      else
        columnDataRowNumber = detailedOutput[i].number;
      if (detailedOutput[i].numWord.startsWith('numeralwords_'))
        columnDataRowNumWord = i18n(context, detailedOutput[i].numWord);
      else
        columnDataRowNumWord = detailedOutput[i].numWord;
      columnDataRowLanguage = i18n(context, detailedOutput[i].language);
      int j = i + 1;
      while (j < detailedOutput.length && detailedOutput[j].number == '') {
        columnDataRowNumber = columnDataRowNumber + '\n' + '';
        columnDataRowNumWord = columnDataRowNumWord + '\n' + detailedOutput[j].numWord;
        columnDataRowLanguage = columnDataRowLanguage + '\n' + i18n(context, detailedOutput[j].language);
        j++;
      }
      i = j - 1;
      columnData.add([columnDataRowNumber, columnDataRowNumWord, columnDataRowLanguage]);
    }
    flexData = [1, 3, 1];

    return Column(
      children: <Widget>[
        GCWOutputText(
          text: output,
        ),
        output.length == 0
            ? Container()
            : GCWExpandableTextDivider(
                text: i18n(context, 'common_outputdetail'),
                suppressTopSpace: false,
                expanded: false,
                child: GCWColumnedMultilineOutput(
                    data: columnData,
                    flexValues: flexData,
                    copyColumn: 1
                )
            ),
      ],
    );
  }
}
