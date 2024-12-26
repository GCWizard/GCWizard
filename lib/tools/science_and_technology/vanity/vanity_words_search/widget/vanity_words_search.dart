import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity_words.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class VanityWordsTextSearch extends StatefulWidget {
  const VanityWordsTextSearch({Key? key}) : super(key: key);

  @override
  _VanityWordsTextSearchState createState() => _VanityWordsTextSearchState();
}

class _VanityWordsTextSearchState extends State<VanityWordsTextSearch> {
  late TextEditingController _decodeController;

  var _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;

  final Map<NumeralWordsLanguage, String> _languageList = {};

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentDecodeInput);

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
        GCWDropDown<NumeralWordsLanguage>(
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
    var detailedOutput = decodeVanityWords(removeAccents(_currentDecodeInput.toLowerCase()), _currentLanguage);

    String output = buildVanityWordSearchOutputString(detailedOutput, context);

    List<List<String>> columnData = <List<String>>[];

    int ambiguous = 0;
    for (int i = 0; i < detailedOutput.length; i++) {
      if (ambiguous < 2) {
        if (detailedOutput[i].ambiguous) ambiguous++;
        if (ambiguous == 1) columnData.add([i18n(context, 'vanity_words_search_ambigous'), '', '']);
        columnData.add([
          detailedOutput[i].number,
          detailedOutput[i].numWord,
          (detailedOutput[i].digit.toString().startsWith('numeralwords_')
              ? i18n(context, detailedOutput[i].digit) + ' '
              : detailedOutput[i].digit)
        ]);
      }
    }

    return Column(
      children: <Widget>[
        GCWOutputText(
          text: output,
        ),
        output.isEmpty
            ? Container()
            : GCWOutput(
                title: i18n(context, 'common_outputdetail'),
                child: GCWColumnedMultilineOutput(data: columnData, flexValues: const [2, 2, 1], copyColumn: 1),
              ),
      ],
    );
  }
}

String buildVanityWordSearchOutputString(List<VanityWordsDecodeOutput> detailedOutput, BuildContext context) {
  String output = '';
  int ambiguous = 0;
  for (int i = 0; i < detailedOutput.length; i++) {
    if (detailedOutput[i].number.isNotEmpty) {
      if (ambiguous > 0 || detailedOutput[i].ambiguous) {
        if (ambiguous == 0) {
          output = output +
              ' (' +
              (detailedOutput[i].digit.startsWith('numeralwords_')
                  ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                  : detailedOutput[i].digit);
          ambiguous++;
        } else if (ambiguous == 1) {
          output = output +
              '  | ' +
              (detailedOutput[i].digit.startsWith('numeralwords_')
                  ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                  : detailedOutput[i].digit) +
              ') - ' +
              i18n(context, 'vanity_words_search_ambigous');
          ambiguous++;
        }
      } else {
        if (detailedOutput[i].number == '?') {
          output = output + '.';
        } else if (detailedOutput[i].digit.toString() == 'null') {
          output = output + ' ';
        } else {
          output = output +
              (detailedOutput[i].digit.startsWith('numeralwords_')
                  ? ' ' + i18n(context, detailedOutput[i].digit) + ' '
                  : detailedOutput[i].digit);
        }
      }
    }
  }
  return output;
}
