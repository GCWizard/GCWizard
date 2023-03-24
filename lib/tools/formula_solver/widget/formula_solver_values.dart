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

    refreshFormulas();
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

    if (alphabet_AZIndexes.keys.contains(maxLetterIndex)) {
      return alphabet_AZIndexes[maxLetterIndex + 1]!;
    }

    return '';
  }

  void _updateValue(FormulaValue value) {
    updateFormulaValue(value, widget.group);
  }

  void _addEntry(String currentFromInput, String currentToInput, FormulaValueType type, BuildContext context) {
    if (currentFromInput.isNotEmpty) {
      var newValue = FormulaValue(currentFromInput, currentToInput, type: type);
      insertFormulaValue(newValue, widget.group);

      _newKeyController.text = _maxLetter();
    }
  }

  void _updateEntry(Object id, String key, String value, FormulaValueType type) {
    var entry = widget.group.values.firstWhere((element) => element.id == id);
    entry.key = key;
    entry.value = value;
    entry.type = type;
    setState(() {
      _updateValue(entry);
    });
  }

  void _removeEntry(Object id, BuildContext context) {
    deleteFormulaValue(id as int, widget.group);
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
          onAddEntry: _addEntry,
          dividerText: i18n(context, 'formulasolver_values_currentvalues'),
          formulaValueList: widget.group.values,
          onUpdateEntry: _updateEntry,
          onRemoveEntry: _removeEntry,
        ),
      ],
    );
  }
}
