import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/combinatorics/combination.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/combinatorics/permutation.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';

class CombinationPermutation extends StatefulWidget {
  @override
  CombinationPermutationState createState() => CombinationPermutationState();
}

class CombinationPermutationState extends State<CombinationPermutation> {
  var _currentInput = '';
  bool _currentShowDuplicates = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          maxLength: PERMUTATION_MAX_LENGTH - 1,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'combinatorics_showduplicates'),
          value: _currentShowDuplicates,
          onChanged: (value) {
            setState(() {
              _currentShowDuplicates = value;
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentInput == null || _currentInput.length == 0) {
      return GCWDefaultOutput();
    }

    List<String> combinations = generateCombinations(_currentInput, avoidDuplicates: !_currentShowDuplicates);

    var count = 0;
    List<List<dynamic>> outputData = combinations.map((combination) {
      var permutations = generatePermutations(combination, avoidDuplicates: !_currentShowDuplicates);
      count += permutations.length;
      return [combination, permutations.join(' ')];
    }).toList();

    var rows = GCWColumnedMultilineOutput(
        data:  outputData,
        flexValues: [1, 3],
        firstRows: [GCWOutputText(
                      text: '${i18n(context, 'common_count')}: $count',
                      copyText: count.toString(),
                    )]
    );

    return Column(children: [GCWTextDivider(text: i18n(context, 'common_output')), rows]);
  }
}
