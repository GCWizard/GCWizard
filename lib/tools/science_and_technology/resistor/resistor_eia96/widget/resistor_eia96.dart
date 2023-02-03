import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/resistor/_common/logic/resistor.dart';
import 'package:gc_wizard/tools/science_and_technology/resistor/resistor_formatter/widget/resistor_formatter.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class ResistorEIA96 extends StatefulWidget {
  @override
  ResistorEIA96State createState() => ResistorEIA96State();
}

class ResistorEIA96State extends State<ResistorEIA96> {
  var _currentCode = 1;
  var _currentMultiplicator = 'A';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
                child: GCWIntegerSpinner(
              value: _currentCode,
              min: 1,
              max: 96,
              onChanged: (value) {
                setState(() {
                  _currentCode = value;
                });
              },
            )),
            Expanded(
                child: GCWDropDown(
              value: _currentMultiplicator,
              items: {
                'Y': _buildSuperscriptedRichText('Y = 10', '-2', ' = 0.01'),
                'X': _buildSuperscriptedRichText('X = 10', '-', ' = 0.1'),
                'A': _buildSuperscriptedRichText('A = 10', '0', ' = 1'),
                'B': _buildSuperscriptedRichText('B = 10', '1', ' = 10'),
                'C': _buildSuperscriptedRichText('C = 10', '2', ' = 100'),
                'D': _buildSuperscriptedRichText('D = 10', '3', ' = 1 000'),
                'E': _buildSuperscriptedRichText('E = 10', '4', ' = 10 000'),
                'F': _buildSuperscriptedRichText('F = 10', '5', ' = 100 000'),
              }.entries.map((entry) {
                return GCWDropDownMenuItem(
                  value: entry.key,
                  child: entry.value,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _currentMultiplicator = value;
                });
              },
            ))
          ],
        ),
        _buildOutput()
      ],
    );
  }

  _buildSuperscriptedRichText(String before, String superscript, String after) {
    return RichText(
        text: TextSpan(
            style: gcwTextStyle(),
            children: [TextSpan(text: before), superscriptedTextForRichText(superscript), TextSpan(text: after)]));
  }

  _buildOutput() {
    var output = formatResistorValue(eia96(_currentCode, multiplicator: _currentMultiplicator));

    return GCWDefaultOutput(child: output, copyText: output.split(' ')[0]);
  }
}
