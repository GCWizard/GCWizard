import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/widget/substitution.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/logic/letter_frequency.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/logic/text_analysis.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';
import 'package:intl/intl.dart';

enum _SORT_TYPES {ALPHABET, COUNT_ALIGNED, COUNT_INDEPENDENT}

class TextAnalysisLetterFrequencies extends StatefulWidget {
  const TextAnalysisLetterFrequencies({super.key});

  @override
  _TextAnalysisLetterFrequenciesState createState() => _TextAnalysisLetterFrequenciesState();
}

class _TextAnalysisLetterFrequenciesState extends State<TextAnalysisLetterFrequencies> {

  late TextEditingController _inputController;
  String _currentInput = '';
  final Map<String, String> _languageMap = {};
  late String _currentCompareLanguage;
  List<String> _compareLanguageItems = [];

  var _currentSort = _SORT_TYPES.COUNT_INDEPENDENT;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_compareLanguageItems.isEmpty) {
      _compareLanguageItems = LETTER_FREQUENCIES_LANG_MAP.keys.toList();
      for (var _lang in _compareLanguageItems) {
        _languageMap.putIfAbsent(_lang, () => languageISOCodeToI18nLanguageName(context, _lang) ?? _lang);
      }

      _currentCompareLanguage = _compareLanguageItems.first;
    }

    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWDropDown<String>(
          title: i18n(context, 'textanalysis_letterfrequencies_compare'),
          value: _currentCompareLanguage,
          items: _compareLanguageItems.map((String lang) {
            return GCWDropDownMenuItem<String>(
              value: lang,
              child: _languageMap[lang]!,
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentCompareLanguage = value;
            });
          },
        ),
        GCWDropDown<_SORT_TYPES>(
          title: i18n(context, 'common_sortby'),
          value: _currentSort,
          items: _SORT_TYPES.values.map((_SORT_TYPES type) {
            String child;
            String subtitle;
            switch (type) {
              case _SORT_TYPES.ALPHABET:
                child = i18n(context, 'common_alphabet');
                subtitle = i18n(context, 'textanalysis_letterfrequencies_sort_alphabet_subtitle');
                break;
              case _SORT_TYPES.COUNT_ALIGNED:
                child = i18n(context, 'common_count') + ' (' + i18n(context, 'textanalysis_letterfrequencies_sort_countaligned_aligned') + ')';
                subtitle = i18n(context, 'textanalysis_letterfrequencies_sort_countaligned_aligned_subtitle');
                break;
              case _SORT_TYPES.COUNT_INDEPENDENT:
                child = i18n(context, 'common_count') + ' (' + i18n(context, 'textanalysis_letterfrequencies_sort_countaligned_independent') + ')';
                subtitle = i18n(context, 'textanalysis_letterfrequencies_sort_countaligned_independent_subtitle');
                break;
            }

            return GCWDropDownMenuItem<_SORT_TYPES>(
              value: type,
              child: child,
              subtitle: subtitle,
              maxSubtitleLines: 3
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentSort = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  int _totalCount(Map<String, int> map) {
    return map.isEmpty ? 0 : map.values.reduce((value, element) => value + element);
  }

  String getCompareLetterFrequency(String letter) {
    var compareLetter = LETTER_FREQUENCIES[letter.toLowerCase()];
    if (compareLetter == null) {
      return '?';
    }

    var value = compareLetter[LETTER_FREQUENCIES_LANG_MAP[_currentCompareLanguage]!];
    return value >= 0 ? NumberFormat('0.000').format(value) : '?';
  }

  Widget _buildOutput() {
    var letters = analyzeText(_currentInput, caseSensitive: false).letters;
    var totalCount = _totalCount(letters);

    var entries = letters.entries.toList();
    if (_currentSort == _SORT_TYPES.ALPHABET) {
      entries.sort((a, b) => a.key.compareTo(b.key));
    } else {
      entries.sort((a, b) => b.value.compareTo(a.value));
    }

    var numFormat = NumberFormat('0.000');

    List<List<String>> comparisonData = [];
    if (_currentSort == _SORT_TYPES.COUNT_INDEPENDENT) {
      var langData = <String, double>{};
      var langIdx = LETTER_FREQUENCIES_LANG_MAP[_currentCompareLanguage]!;
      for (var entry in LETTER_FREQUENCIES.entries) {
        langData.putIfAbsent(entry.key, () => entry.value[langIdx]);
      }

      var compEntries = langData.entries.toList();
      compEntries.sort((a, b) => b.value.compareTo(a.value));

      comparisonData = compEntries
          .map((MapEntry<String, double> e) => [e.key.toUpperCase(), numFormat.format(e.value)])
          .toList();
    }

    var compLetterCount = comparisonData.length;
    var substitutionMap = <String, String>{};

    var i = 0;
    var detailed = entries.map((e) {
      var data = [
        e.key.toUpperCase(),
        e.value,
        numFormat.format(e.value / totalCount * 100),
      ];

      if (_currentSort != _SORT_TYPES.COUNT_INDEPENDENT) {
        data.add(getCompareLetterFrequency(e.key));
      } else {
        if (i < compLetterCount) {
          data.addAll(comparisonData[i]);
          substitutionMap.putIfAbsent(e.key.toUpperCase(), () => comparisonData[i][0]);
        } else {
          data.addAll(['', '']);
        }
      }
      i++;

      return data;
    }).toList();

    if (_currentSort == _SORT_TYPES.COUNT_INDEPENDENT) {
      for (i; i < compLetterCount; i++) {
        detailed.add(['', '', '', comparisonData[i][0], comparisonData[i][1]]);
      }
    }

    var header = <String>[];
    if (_currentInput.isNotEmpty) {
      header = [
        i18n(context, 'common_letter'),
        i18n(context, 'common_count'),
        '%'
      ];
    }

    if (_currentSort == _SORT_TYPES.COUNT_INDEPENDENT) {
      header.add(i18n(context, 'common_letter'));
    }

    header.add(_languageMap[_currentCompareLanguage]! + '\n%');

    detailed.insert(0, header);
    comparisonData.insert(0, header);

    return GCWDefaultOutput(
      child: Column (
        children: [
          (_currentInput.isNotEmpty && _currentSort == _SORT_TYPES.COUNT_INDEPENDENT)
              ? GCWButton(
              text: i18n(context, 'substitutionbreaker_exporttosubstition'),
              onPressed: () {
                Navigator.push(
                    context,
                    NoAnimationMaterialPageRoute<GCWTool>(
                        builder: (context) => GCWTool(
                            tool: Substitution(input: _currentInput, substitutions: substitutionMap),
                            id: 'substitution')));
              }
          ) : Container(),
          Row(
            children: [
              (_currentInput.isNotEmpty)
                  ? Expanded(
                  child: GCWColumnedMultilineOutput(
                    data: detailed,
                    hasHeader: true,
                  )
              ) : Container(),
              (_currentInput.isEmpty && _currentSort == _SORT_TYPES.COUNT_INDEPENDENT)
                  ? Expanded(
                  child: GCWColumnedMultilineOutput(
                    data: comparisonData,
                    hasHeader: true,
                  )
              ) : Container(),
            ],
          )
        ],
      )
    );
  }
}
