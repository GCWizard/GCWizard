import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity_words.dart';

class VanityWordsList extends StatefulWidget {
  const VanityWordsList({Key? key}) : super(key: key);

  @override
  _VanityWordsListState createState() => _VanityWordsListState();
}

class _VanityWordsListState extends State<VanityWordsList> {
  late TextEditingController _decodeController;

  final _currentDecodeInput = '';
  var _currentLanguage = NumeralWordsLanguage.DEU;

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
        GCWDropDown<NumeralWordsLanguage>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: VANITYWORDS_LANGUAGES.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var vanityWordsOverview = VANITY_WORDS[_currentLanguage];
    if (vanityWordsOverview == null) return Container();

    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
          data: vanityWordsOverview.entries.map((entry) {
            return [
              entry.key,
              entry.value,
              (NUMERAL_WORDS[_currentLanguage]?[(entry.value).toLowerCase()] ?? '').startsWith('numeralwords_')
                  ? i18n(context, NUMERAL_WORDS[_currentLanguage]?[(entry.value).toLowerCase()] ?? '') + ' '
                  : NUMERAL_WORDS[_currentLanguage]?[entry.value.toLowerCase()]
            ];
          }).toList(),
          flexValues: const [2, 2, 1]),
    );
  }
}
