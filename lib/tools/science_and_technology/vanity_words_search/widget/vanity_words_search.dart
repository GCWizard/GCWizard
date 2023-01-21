import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/logic/numeral_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/logic/vanity_words.dart';
import 'package:gc_wizard/utils/logic_utils/common_utils.dart';

class VanityWordsTextSearch extends StatefulWidget {
  @override
  VanityWordsTextSearchState createState() => VanityWordsTextSearchState();
}

class VanityWordsTextSearchState extends State<VanityWordsTextSearch> {
  TextEditingController _decodeController;

  var _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;

  Map<NumeralWordsLanguage, String> _languageList;

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentDecodeInput);

    _languageList = {};
    _languageList.addAll(VANITYWORDS_LANGUAGES);
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
        GCWDropDown(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: _languageList.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        Column(
          children: <Widget>[
            GCWTextField(
              controller: _decodeController,
              onChanged: (text) {
                setState(() {
                  _currentDecodeInput = text;
                });
              },
            ),
          ],
        ),
        GCWTextDivider(text: i18n(context, 'common_output')),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    List<VanityWordsDecodeOutput> detailedOutput = new List<VanityWordsDecodeOutput>();
    detailedOutput = decodeVanityWords(removeAccents(_currentDecodeInput.toLowerCase()), _currentLanguage);

    String output = '';
    int ambigous = 0;
    for (int i = 0; i < detailedOutput.length; i++) {
      if (detailedOutput[i].number != '') if (ambigous > 0 || detailedOutput[i].ambigous) {
        if (ambigous == 0) {
          output = output +
              ' (' +
              (detailedOutput[i].digit.startsWith('numeralwords_')
                  ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                  : detailedOutput[i].digit);
          ambigous++;
        } else if (ambigous == 1) {
          output = output +
              '  | ' +
              (detailedOutput[i].digit.startsWith('numeralwords_')
                  ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                  : detailedOutput[i].digit) +
              ') - ' +
              i18n(context, 'vanity_words_search_ambigous');
          ambigous++;
        }
      } else if (detailedOutput[i].number == '?')
        output = output + '.';
      else if (detailedOutput[i].digit.toString() == 'null')
        output = output + ' ';
      else
        output = output +
            (detailedOutput[i].digit.startsWith('numeralwords_')
                ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                : detailedOutput[i].digit);
    }

    List<List<String>> columnData = new List<List<String>>();
    var flexData;

    ambigous = 0;
    for (int i = 0; i < detailedOutput.length; i++) {
      if (ambigous < 2) {
        if (detailedOutput[i].ambigous) ambigous++;
        if (ambigous == 1) columnData.add([i18n(context, 'vanity_words_search_ambigous'), '', '']);
        columnData.add([
          detailedOutput[i].number,
          detailedOutput[i].numWord,
          (detailedOutput[i].digit.toString().startsWith('numeralwords_')
              ? i18n(context, detailedOutput[i].digit) + ' '
              : detailedOutput[i].digit)
        ]);
      }
    }
    flexData = [2, 2, 1];

    return Column(
      children: <Widget>[
        GCWOutputText(
          text: output,
        ),
        output.length == 0
            ? Container()
            : GCWOutput(
                title: i18n(context, 'common_outputdetail'),
                child: GCWColumnedMultilineOutput(
                    data: columnData,
                    flexValues: flexData,
                    copyColumn: 1),
              ),
      ],
    );
  }
}