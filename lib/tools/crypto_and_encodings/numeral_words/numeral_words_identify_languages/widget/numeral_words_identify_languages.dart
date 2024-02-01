import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

class NumeralWordsIdentifyLanguages extends StatefulWidget {
  const NumeralWordsIdentifyLanguages({Key? key}) : super(key: key);

  @override
  _NumeralWordsIdentifyLanguagesState createState() => _NumeralWordsIdentifyLanguagesState();
}

class _NumeralWordsIdentifyLanguagesState extends State<NumeralWordsIdentifyLanguages> {
  late TextEditingController _decodeController;

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
      input: _currentDecodeInput,
      language: NumeralWordsLanguage.ALL,
      decodeModeWholeWords: _currentDecodeMode == GCWSwitchPosition.left,
    );
    for (int i = 0; i < detailedOutput.length; i++) {
      if (detailedOutput[i].number.isNotEmpty) {
        if (detailedOutput[i].number.startsWith('numeralwords_')) {
          output = output + ' ' + i18n(context, detailedOutput[i].number);
        } else {
          output = output + detailedOutput[i].number;
        }
      }
    }

    List<List<String>> columnData = [];
    String columnDataRowNumber;
    String columnDataRowNumWord;
    String columnDataRowLanguage;

    for (int i = 0; i < detailedOutput.length; i++) {
      if (detailedOutput[i].number.startsWith('numeralwords_')) {
        columnDataRowNumber = i18n(context, detailedOutput[i].number);
      } else {
        columnDataRowNumber = detailedOutput[i].number;
      }
      if (detailedOutput[i].numWord.startsWith('numeralwords_')) {
        columnDataRowNumWord = i18n(context, detailedOutput[i].numWord);
      } else {
        columnDataRowNumWord = detailedOutput[i].numWord;
      }
      columnDataRowLanguage = i18n(context, detailedOutput[i].language);
      int j = i + 1;
      while (j < detailedOutput.length && detailedOutput[j].number.isEmpty) {
        columnDataRowNumber = columnDataRowNumber + '\n' + '';
        columnDataRowNumWord = columnDataRowNumWord + '\n' + detailedOutput[j].numWord;
        columnDataRowLanguage = columnDataRowLanguage + '\n' + i18n(context, detailedOutput[j].language);
        j++;
      }
      i = j - 1;
      columnData.add([columnDataRowNumber, columnDataRowNumWord, columnDataRowLanguage]);
    }

    return Column(
      children: <Widget>[
        GCWOutputText(
          text: output,
        ),
        output.isEmpty
            ? Container()
            : GCWExpandableTextDivider(
                text: i18n(context, 'common_outputdetail'),
                suppressTopSpace: false,
                expanded: false,
                child: GCWColumnedMultilineOutput(data: columnData, flexValues: const [1, 3, 1], copyColumn: 1)),
      ],
    );
  }
}
