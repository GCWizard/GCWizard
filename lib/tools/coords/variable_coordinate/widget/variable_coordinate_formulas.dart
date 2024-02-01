import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_formula_list_editor.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/json_provider.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class VariableCoordinateFormulas extends StatefulWidget {
  const VariableCoordinateFormulas({Key? key}) : super(key: key);

  @override
  _VariableCoordinateFormulasState createState() => _VariableCoordinateFormulasState();
}

class _VariableCoordinateFormulasState extends State<VariableCoordinateFormulas> {
  @override
  void initState() {
    super.initState();

    refreshFormulas();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
            text: i18n(context, 'coords_variablecoordinate_newformula'),
            trailing: GCWPasteButton(iconSize: IconButtonSize.SMALL, onSelected: _importFromClipboard)),
        GCWFormulaListEditor(
          formulaList: formulas,
          buildGCWTool: (id) => _buildNavigateGCWTool(id),
          onAddEntry: (name) => _addNewFormula(name),
          onListChanged: () => updateFormulas(),
          newEntryHintText: i18n(context, 'coords_variablecoordinate_newformula_hint'),
          middleWidget: GCWTextDivider(text: i18n(context, 'coords_variablecoordinate_currentformulas')),
        ),
      ],
    );
  }

  String _createImportName(String currentName) {
    var baseName = '[${i18n(context, 'common_import')}] $currentName';

    var existingNames = formulas.map((f) => f.name).toList();

    int i = 1;
    var name = baseName;
    while (existingNames.contains(name)) {
      name = baseName + ' (${i++})';
    }

    return name;
  }

  void _importFromClipboard(String data) {
    try {
      data = normalizeCharacters(data);
      var formula = VariableCoordinateFormula.fromJson(asJsonMap(jsonDecode(data)));
      formula.name = _createImportName(formula.name);

      setState(() {
        insertFormula(formula);
      });
      showSnackBar(i18n(context, 'formulasolver_groups_imported'), context);
    } catch (e) {
      showSnackBar(i18n(context, 'formulasolver_groups_importerror'), context);
    }
  }

  void _addNewFormula(String name) {
    if (name.isNotEmpty) {
      var formula = VariableCoordinateFormula(name);
      insertFormula(formula);
    }
  }

  GCWTool? _buildNavigateGCWTool(int id) {
    var entry = formulas.firstWhereOrNull((formula) => formula.id == id);

    if (entry != null) {
      return GCWTool(
          tool: VariableCoordinate(formula: entry),
          toolName: '${entry.name} - ${i18n(context, 'coords_variablecoordinate_title')}',
          helpSearchString: 'coords_variablecoordinate_title',
          defaultLanguageToolName:
              '${entry.name} - ${i18n(context, 'coords_variablecoordinate_title', useDefaultLanguage: true)}',
          id: 'coords_variablecoordinate');
    } else {
      return null;
    }
  }
}
