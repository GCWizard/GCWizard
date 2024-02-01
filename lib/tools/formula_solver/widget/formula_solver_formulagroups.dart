import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/fixed_colors.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_checkbox.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_formula_list_editor.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/json_provider.dart' as var_coords_provider;
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart' as var_coords_model;
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/formula_solver/logic/formula_painter.dart';
import 'package:gc_wizard/tools/formula_solver/logic/formula_parser.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/json_provider.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';
import 'package:prefs/prefs.dart';

part 'package:gc_wizard/tools/formula_solver/widget/formula_replace_dialog.dart';
part 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulas.dart';
part 'package:gc_wizard/tools/formula_solver/widget/formula_solver_values.dart';
part 'package:gc_wizard/tools/formula_solver/widget/formula_value_type_key_value_input.dart';
part 'package:gc_wizard/tools/formula_solver/widget/formula_value_type_key_value_item.dart';

class FormulaSolverFormulaGroups extends StatefulWidget {
  const FormulaSolverFormulaGroups({Key? key}) : super(key: key);

  @override
  _FormulaSolverFormulaGroupsState createState() => _FormulaSolverFormulaGroupsState();
}

class _FormulaSolverFormulaGroupsState extends State<FormulaSolverFormulaGroups> {
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
            text: i18n(context, 'formulasolver_groups_newgroup'),
            trailing: GCWPasteButton(
                iconSize: IconButtonSize.SMALL,
                onSelected: (String data) {
                  try {
                    setState(() {
                      importFormulaGroupFromJson(context, data);
                    });
                    showSnackBar(i18n(context, 'formulasolver_groups_imported'), context);
                  } catch (e) {
                    showSnackBar(i18n(context, 'formulasolver_groups_importerror'), context);
                  }
                })),
        GCWFormulaListEditor(
          formulaList: formulaGroups,
          buildGCWTool: (id) => _buildNavigateGCWTool(id),
          onAddEntry: (name) => _addNewGroup(name),
          onListChanged: () => updateFormulaGroups(),
          newEntryHintText: i18n(context, 'formulasolver_groups_newgroup_hint'),
          middleWidget: GCWTextDivider(text: i18n(context, 'formulasolver_groups_currentgroups')),
          formulaGroups: true,
        ),
      ],
    );
  }

  void _addNewGroup(String name) {
    if (name.isNotEmpty) {
      var group = FormulaGroup(name);
      insertGroup(group);
    }
  }

  GCWTool? _buildNavigateGCWTool(int id) {
    var entry = formulaGroups.firstWhereOrNull((formula) => formula.id == id);

    if (entry != null) {
      return GCWTool(
        tool: _FormulaSolverFormulas(group: entry),
        toolName: '${entry.name} - ${i18n(context, 'formulasolver_formulas')}',
        helpSearchString: 'formulasolver_formulas',
        defaultLanguageToolName: '${entry.name} - ${i18n(context, 'formulasolver_formulas', useDefaultLanguage: true)}',
        id: '',
      );
    } else {
      return null;
    }
  }
}

String _createImportGroupName(BuildContext context, String currentName) {
  var baseName = '[${i18n(context, 'common_import')}] $currentName';

  var existingNames = formulaGroups.map((f) => f.name).toList();

  int i = 1;
  var name = baseName;
  while (existingNames.contains(name)) {
    name = baseName + ' (${i++})';
  }

  return name;
}

void importFormulaGroupFromJson(BuildContext context, String data) {
  data = normalizeCharacters(data);
  var group = FormulaGroup.fromJson(asJsonMap(jsonDecode(data)));
  group.name = _createImportGroupName(context, group.name);

  insertGroup(group);
}

void openInFormulaGroups(BuildContext context) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(tool: const FormulaSolverFormulaGroups(), id: 'formulasolver')));
}
