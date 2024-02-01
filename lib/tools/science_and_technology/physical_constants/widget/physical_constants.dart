import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/logic/physical_constants.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class PhysicalConstants extends StatefulWidget {
  const PhysicalConstants({Key? key}) : super(key: key);

  @override
  _PhysicalConstantsState createState() => _PhysicalConstantsState();
}

class _PhysicalConstantsState extends State<PhysicalConstants> {
  var _currentConstant = PHYSICAL_CONSTANTS.entries.first.key;

  final List<String> _constants = [];

  @override
  Widget build(BuildContext context) {
    if (_constants.isEmpty) {
      List<String> _temp = PHYSICAL_CONSTANTS.keys.map((constant) => i18n(context, constant)).toList();
      _temp.sort();

      for (String constant in _temp) {
        _constants.add(PHYSICAL_CONSTANTS.keys.firstWhere((c) => i18n(context, c) == constant));
      }

      _currentConstant = _constants.first;
    }

    return Column(
      children: <Widget>[
        GCWDropDown<String>(
          value: _currentConstant,
          onChanged: (value) {
            setState(() {
              _currentConstant = value;
            });
          },
          items: _constants.map((constant) {
            return GCWDropDownMenuItem(value: constant, child: i18n(context, constant));
          }).toList(),
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildOutput() {
    PhysicalConstant? constantData = PHYSICAL_CONSTANTS[_currentConstant];
    if (constantData == null) return Container();

    var data = [
      [i18n(context, 'physical_constants_symbol'), buildSubOrSuperscriptedRichTextIfNecessary(constantData.symbol)],
      [i18n(context, 'physical_constants_value'), constantData.value, _buildExponent(constantData.exponent)],
      constantData.standard_uncertainty != null
          ? [
              i18n(context, 'physical_constants_standard_uncertainty'),
              constantData.standard_uncertainty,
              _buildExponent(constantData.exponent)
            ]
          : null,
      constantData.unit != null
          ? [i18n(context, 'physical_constants_unit'), buildSubOrSuperscriptedRichTextIfNecessary(constantData.unit!)]
          : null
    ];

    return GCWColumnedMultilineOutput(
      data: data.whereType<List<Object?>>().toList(),
      flexValues: const [2, 3, 2],
      copyColumn: 1,
    );
  }

  Widget _buildExponent(int? exponent) {
    if (exponent == null) return Container();

    return RichText(
        text: TextSpan(
            style: gcwTextStyle(),
            children: [const TextSpan(text: ' × 10'), superscriptedTextForRichText(exponent.toString())]));
  }
}
