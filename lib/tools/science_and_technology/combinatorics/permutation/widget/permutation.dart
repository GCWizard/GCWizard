import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/combinatorics/permutation/logic/permutation.dart';

class Permutation extends StatefulWidget {
  const Permutation({Key? key}) : super(key: key);

  @override
  _PermutationState createState() => _PermutationState();
}

class _PermutationState extends State<Permutation> {
  var _currentInput = '';
  bool _currentShowDuplicates = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          maxLength: PERMUTATION_MAX_LENGTH,
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
    if (_currentInput.isEmpty) {
      return const GCWDefaultOutput();
    }

    var out = generatePermutations(_currentInput, avoidDuplicates: !_currentShowDuplicates);

    return GCWMultipleOutput(
      children: [
        GCWOutputText(
          text: '${i18n(context, 'common_count')}: ${out.length}',
          copyText: out.length.toString(),
        ),
        out.join(' ')
      ],
    );
  }
}
