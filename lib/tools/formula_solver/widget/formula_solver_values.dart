part of 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';

class _FormulaSolverFormulaValues extends StatefulWidget {
  final FormulaGroup group;

  const _FormulaSolverFormulaValues({Key? key, required this.group}) : super(key: key);

  @override
  _FormulaSolverFormulaValuesState createState() => _FormulaSolverFormulaValuesState();
}

class _FormulaSolverFormulaValuesState extends State<_FormulaSolverFormulaValues> {
  late TextEditingController _newKeyController;

  @override
  void initState() {
    super.initState();
    _newKeyController = TextEditingController(text: _maxLetter());
  }

  @override
  void dispose() {
    _newKeyController.dispose();

    super.dispose();
  }

  String _maxLetter() {
    int maxLetterIndex = 0;
    for (var value in widget.group.values) {
      if (value.key.length != 1) continue;
      var alphabetIndex = alphabet_AZ[value.key.toUpperCase()];
      if (alphabetIndex == null) continue;

      maxLetterIndex = max(maxLetterIndex, alphabetIndex);
    }

    if (alphabet_AZIndexes.keys.contains(maxLetterIndex + 1)) {
      return alphabet_AZIndexes[maxLetterIndex + 1]!;
    }

    return '';
  }

  void _addEntry(KeyValueBase entry) {
    if (entry.key.isNotEmpty) {
      if (int.tryParse(entry.key) != null) {
        showGCWAlertDialog(context, i18n(context, 'formulasolver_values_alerts_keynumbers_title'),
            i18n(context, 'formulasolver_values_alerts_keynumbers_text'), () {});
        return;
      }

      if (entry is FormulaValue) {
        insertFormulaValue(entry, widget.group);
      }
      _newKeyController.text = _maxLetter();
    }
  }

  void _updateEntry(KeyValueBase entry) {
    updateAndSave(widget.group);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'formulasolver_values_newvalue')),
        GCWKeyValueEditor(
            keyHintText: i18n(context, 'formulasolver_values_key'),
            keyController: _newKeyController,
            valueHintText: i18n(context, 'formulasolver_values_value'),
            dividerText: i18n(context, 'formulasolver_values_currentvalues'),
            entries: widget.group.values,
            onAddEntry: (entry) => _addEntry(entry),
            onUpdateEntry: (entry) => _updateEntry(entry),
            onCreateInput: (Key? key) => _FormulaValueTypeKeyInput(key: key),
            onCreateNewItem: (entry, odd) => _createNewItem(entry, odd),
            trailing: GCWIconButton(
              customIcon: Image.asset('lib/application/_common/assets/img/cgeo_logo.png'),
              size: IconButtonSize.SMALL,
              onPressed: () {
                var cgeoFormattedValues = widget.group.values.map((value) {
                  return '\$' + value.key + '=' + value.value;
                }).join(' | ');

                insertIntoGCWClipboard(context, cgeoFormattedValues);
              },
            )),
      ],
    );
  }

  GCWKeyValueItem _createNewItem(KeyValueBase entry, bool odd) {
    return _FormulaValueTypeKeyValueItem(
      keyValueEntry: entry,
      odd: odd,
    );
  }
}
