import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gade/logic/gade.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';
import 'package:gc_wizard/tools/games/verbal_arithmetic/logic/helper.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class Gade extends StatefulWidget {
  const Gade({super.key});

  @override
  _GadeState createState() => _GadeState();
}

class _GadeState extends State<Gade> {
  late TextEditingController _GadeInputController;
  late TextEditingController _advancedOutputInputController;

  String _currentGadeInput = '';
  String _advancedOutputInput = '';

  GADE_TYPES _currentType = GADE_TYPES.GADE;

  bool _currentParseLetters = true;

  @override
  void initState() {
    super.initState();
    _GadeInputController = TextEditingController(text: _currentGadeInput);
    _advancedOutputInputController = TextEditingController(text: _advancedOutputInput);
  }

  @override
  void dispose() {
    _GadeInputController.dispose();
    _advancedOutputInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildWidgetInputText(),
        _buildWidgetInputGadeType(),
        _buildWidgetInputOptions(),
        _buildWidgetOutput()
      ],
    );
  }

  Widget _buildWidgetOutput() {
    String _input;
    if (_currentParseLetters) {
      _input = AlphabetValues(alphabet: alphabetAZ.alphabet)
          .textToValues(_currentGadeInput, keepNumbers: true)
          .where((e) => e != null)
          .join(' ');
    } else {
      _input = _currentGadeInput.replaceAll(RegExp(r'\D'), '');
    }

    var gade = calculateGade(_currentType, _input);

    var sortedStr = gade.values.toList().join('');

    return Column(
      children: [
        GCWOutput(
            title: i18n(context, 'common_input'),
            child: GCWColumnedMultilineOutput(data: [
              [i18n(context, 'gade_parsed'), _input],
              [i18n(context, 'gade_sorted'), sortedStr]
            ])),
        GCWDefaultOutput(
          child: Column(
            children: [
              _buildWidgetOutputAdvancedOutput(gade),
              _advancedOutputInput != ''
                  ? GCWTextDivider(
                      suppressTopSpace: false,
                      text: i18n(context, 'common_details') + ':')
                  : Container(),
              _buildWidgetOutputGade(gade),
            ],
          ),
        ),
        _buildWidgetExportToCgeo(gade),
      ],
    );
  }

  Widget _buildWidgetExportToCgeo(Map<String, String> gade){
    return GCWButton(
        text: i18n(context, 'gade_exporttoformulasolver'),
        onPressed: () {
          var formulaGroup = FormulaGroup('Gade Export');

          for (var entry in gade.entries) {
            formulaGroup.values.add(FormulaValue(entry.key, entry.value));
          }

          try {
            setState(() {
              importFormulaGroupFromJson(context, jsonEncode(formulaGroup.toMap()));
            });

            openInFormulaGroups(context);
          } catch (e) {
            showSnackBar(i18n(context, 'formulasolver_groups_importerror'), context);
          }
        });
  }

  Widget _buildWidgetOutputGade(Map<String, String> gade){
    return GCWColumnedMultilineOutput(
        data: gade.entries.map((entry) {
          return [entry.key, entry.value];
        }).toList());
  }

  Widget _buildWidgetOutputAdvancedOutput(Map<String, String> gade) {
    // getAdvancedOutput(HashMap<String, int> result, String advancedOutputInput)
    // from VerbalArithmetic helper
    if (_advancedOutputInput == '') {
      return Container();
    } else {
      HashMap<String, int> gadeHashMap = HashMap.fromEntries(
        gade.entries.map(
              (entry) => MapEntry(entry.key, int.parse(entry.value)),
        ),
      );
      return GCWText(
        text: getAdvancedOutput(gadeHashMap, _advancedOutputInput),
      );
    }
  }

  Widget _buildWidgetInputText() {
    return GCWTextField(
      controller: _GadeInputController,
      onChanged: (text) {
        setState(() {
          _currentGadeInput = text;
        });
      },
    );
  }

  Widget _buildWidgetInputGadeType() {
    return GCWDropDown<GADE_TYPES>(
      value: _currentType,
      items: gadeTypes.entries.map((entry) {
        return GCWDropDownMenuItem(
          value: entry.key,
          child: entry.value,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _currentType = value;
        });
      },);
  }

  Widget _buildWidgetInputOptions(){
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_mode_advanced'),
      suppressTopSpace: false,
      child: Column(
        children: [
          GCWOnOffSwitch(
            value: _currentParseLetters,
            title: i18n(context, 'gade_parselettervalues'),
            onChanged: (mode) {
              setState(() {
                _currentParseLetters = mode;
              });
            },
          ),
          GCWText(text: i18n(context, 'common_advanced_output') + ':'),
          GCWTextField(
              hintText: 'N [EM] [MD-O].[RSY] E [R] [YS.NOR]',
              controller: _advancedOutputInputController,
              onChanged: (String text) {
                setState(() {
                  _advancedOutputInput = text;
                });
              }
          ),
        ],
      ),
    );
  }
}
