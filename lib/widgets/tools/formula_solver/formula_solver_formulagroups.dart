import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/persistence/formula_solver/json_provider.dart';
import 'package:gc_wizard/persistence/formula_solver/model.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/widgets/common/gcw_paste_button.dart';
import 'package:gc_wizard/widgets/common/gcw_popup_menu.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_text_export.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/tools/formula_solver/formula_solver_formulas.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:gc_wizard/utils/common_utils.dart';

class FormulaSolverFormulaGroups extends StatefulWidget {
  @override
  FormulaSolverFormulaGroupsState createState() => FormulaSolverFormulaGroupsState();
}

class FormulaSolverFormulaGroupsState extends State<FormulaSolverFormulaGroups> {
  var _newGroupController;
  var _editGroupController;
  var _currentNewName = '';
  var _currentEditedName = '';
  var _currentEditId;

  ThemeColors _themeColors;

  @override
  void initState() {
    super.initState();
    _newGroupController = TextEditingController(text: _currentNewName);
    _editGroupController = TextEditingController(text: _currentEditedName);

    refreshFormulas();
  }

  @override
  void dispose() {
    _newGroupController.dispose();
    _editGroupController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _themeColors = themeColors();

    return Column(
      children: <Widget>[
        GCWTextDivider(
            text: i18n(context, 'formulasolver_groups_newgroup'),
            trailing: GCWPasteButton(iconSize: IconButtonSize.SMALL, onSelected: _importFromClipboard)),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                child: GCWTextField(
                  hintText: i18n(context, 'formulasolver_groups_newgroup_hint'),
                  controller: _newGroupController,
                  onChanged: (text) {
                    setState(() {
                      _currentNewName = text;
                    });
                  },
                ),
                padding: EdgeInsets.only(
                  right: 2,
                ),
              ),
            ),
            GCWIconButton(
              icon: Icons.add,
              onPressed: () {
                _addNewGroup();
                setState(() {});
              },
            )
          ],
        ),
        _buildGroupList(context)
      ],
    );
  }

  String _createImportGroupName(String currentName) {
    var baseName = '[${i18n(context, 'common_import')}] $currentName';

    var existingNames = formulaGroups.map((f) => f.name).toList();

    int i = 1;
    var name = baseName;
    while (existingNames.contains(name)) name = baseName + ' (${i++})';

    return name;
  }

  _importFromClipboard(String data) {
    try {
      data = normalizeCharacters(data);
      var group = FormulaGroup.fromJson(jsonDecode(data));
      group.name = _createImportGroupName(group.name);

      setState(() {
        insertGroup(group);
      });
      showToast(i18n(context, 'formulasolver_groups_imported'));
    } catch (e) {
      showToast(i18n(context, 'formulasolver_groups_importerror'));
    }
  }

  _addNewGroup() {
    if (_currentNewName.length > 0) {
      var group = FormulaGroup(_currentNewName);
      insertGroup(group);

      _newGroupController.clear();
      _currentNewName = '';
    }
  }

  _updateGroup() {
    updateFormulaGroups();
  }

  _removeGroup(FormulaGroup group) {
    deleteGroup(group.id);
  }

  _exportGroup(FormulaGroup group) {
    var mode = TextExportMode.QR;
    String text = jsonEncode(group.toMap()).toString();
    text = normalizeCharacters(text);
    var contentWidget = GCWTextExport(
      text: text,
      onModeChanged: (value) {
        mode = value;
      },
    );
    showGCWDialog(
        context,
        i18n(context, 'formulasolver_groups_exportgroup'),
        contentWidget,
        [
          GCWDialogButton(
            text: i18n(context, 'common_exportfile_saveoutput'),
            onPressed: () {
              exportFile(text, mode, context);
            },
          ),
          GCWDialogButton(
            text: 'OK',
          )
        ],
        cancelButton: false);
  }

  _buildGroupList(BuildContext context) {
    var odd = true;
    var rows = formulaGroups.map((group) {
      var formulaTool = GCWTool(
          tool: FormulaSolverFormulas(group: group),
          toolName: '${group.name} - ${i18n(context, 'formulasolver_formulas')}',
          helpSearchString: 'formulasolver_formulas',
          defaultLanguageToolName:
              '${group.name} - ${i18n(context, 'formulasolver_formulas', useDefaultLanguage: true)}');

      Future _navigateToSubPage(context) async {
        Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => formulaTool)).whenComplete(() {
          setState(() {});
        });
      }

      Widget output;

      var row = InkWell(
          child: Row(
            children: <Widget>[
              Expanded(
                child: _currentEditId == group.id
                    ? Padding(
                        child: GCWTextField(
                          controller: _editGroupController,
                          autofocus: true,
                          onChanged: (text) {
                            setState(() {
                              _currentEditedName = text;
                            });
                          },
                        ),
                        padding: EdgeInsets.only(
                          right: 2,
                        ),
                      )
                    : IgnorePointer(
                        child: Column(
                        children: <Widget>[
                          GCWText(text: '${group.name}'),
                          Container(
                            child: GCWText(
                              text: '${group.formulas.length} ' +
                                  i18n(context,
                                      group.formulas.length == 1 ? 'formulasolver_formula' : 'formulasolver_formulas'),
                              style: gcwDescriptionTextStyle(),
                            ),
                            padding: EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                          )
                        ],
                      )),
                flex: 1,
              ),
              _currentEditId == group.id
                  ? GCWIconButton(
                      icon: Icons.check,
                      onPressed: () {
                        group.name = _currentEditedName;
                        _updateGroup();

                        setState(() {
                          _currentEditId = null;
                          _editGroupController.clear();
                        });
                      },
                    )
                  : Container(),
              GCWPopupMenu(
                  iconData: Icons.settings,
                  menuItemBuilder: (context) => [
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(context, Icons.edit, 'formulasolver_groups_editgroup'),
                            action: (index) => setState(() {
                                  _currentEditId = group.id;
                                  _currentEditedName = group.name;
                                  _editGroupController.text = group.name;
                                })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(context, Icons.delete, 'formulasolver_groups_removegroup'),
                            action: (index) => showDeleteAlertDialog(context, group.name, () {
                                  _removeGroup(group);
                                  setState(() {});
                                })),
                        GCWPopupMenuItem(
                            child: iconedGCWPopupMenuItem(context, Icons.forward, 'formulasolver_groups_exportgroup'),
                            action: (index) => _exportGroup(group)),
                      ])
            ],
          ),
          onTap: () {
            _navigateToSubPage(context);
          });

      if (odd) {
        output = Container(color: _themeColors.outputListOddRows(), child: row);
      } else {
        output = Container(child: row);
      }
      odd = !odd;

      return output;
    }).toList();

    if (rows.length > 0) {
      rows.insert(0, GCWTextDivider(text: i18n(context, 'formulasolver_groups_currentgroups')));
    }

    return Column(children: rows);
  }
}
