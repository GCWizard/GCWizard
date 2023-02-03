import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/json_provider.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/widget/variable_coordinate.dart';

class VariableCoordinateFormulas extends StatefulWidget {
  @override
  VariableCoordinateFormulasState createState() => VariableCoordinateFormulasState();
}

class VariableCoordinateFormulasState extends State<VariableCoordinateFormulas> {
  var _newFormulaController;
  var _editFormulaController;
  var _currentNewName = '';
  var _currentEditedName = '';
  var _currentEditId;

  @override
  void initState() {
    super.initState();
    _newFormulaController = TextEditingController(text: _currentNewName);
    _editFormulaController = TextEditingController(text: _currentEditedName);

    refreshFormulas();
  }

  @override
  void dispose() {
    _newFormulaController.dispose();
    _editFormulaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'coords_variablecoordinate_newformula')),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                child: GCWTextField(
                  hintText: i18n(context, 'coords_variablecoordinate_newformula_hint'),
                  controller: _newFormulaController,
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
                _addNewFormula();
                setState(() {});
              },
            )
          ],
        ),
        _buildFormulaList(context)
      ],
    );
  }

  _addNewFormula() {
    if (_currentNewName.length > 0) {
      var formula = Formula(_currentNewName);
      insertFormula(formula);

      _newFormulaController.clear();
      _currentNewName = '';
    }
  }

  _updateFormula() {
    updateFormulas();
  }

  _removeFormula(Formula formula) {
    deleteFormula(formula.id);
  }

  _buildFormulaList(BuildContext context) {
    var odd = true;
    var rows = formulas.map((formula) {
      var formulaTool = GCWTool(
          tool: VariableCoordinate(formula: formula),
          toolName: '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title')}',
          helpSearchString: 'coords_variablecoordinate_title',
          defaultLanguageToolName:
              '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title', useDefaultLanguage: true)}');

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
                child: _currentEditId == formula.id
                    ? Padding(
                        child: GCWTextField(
                          controller: _editFormulaController,
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
                    : IgnorePointer(child: GCWText(text: '${formula.name}')),
                flex: 1,
              ),
              _currentEditId == formula.id
                  ? GCWIconButton(
                      icon: Icons.check,
                      onPressed: () {
                        formula.name = _currentEditedName;
                        _updateFormula();

                        setState(() {
                          _currentEditId = null;
                          _editFormulaController.clear();
                        });
                      },
                    )
                  : GCWIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        setState(() {
                          _currentEditId = formula.id;
                          _currentEditedName = formula.name;
                          _editFormulaController.text = formula.name;
                        });
                      },
                    ),
              GCWIconButton(
                icon: Icons.remove,
                onPressed: () {
                  showDeleteAlertDialog(context, formula.name, () {
                    _removeFormula(formula);
                    setState(() {});
                  });
                },
              )
            ],
          ),
          onTap: () {
            _navigateToSubPage(context);
          });

      if (odd) {
        output = Container(color: themeColors().outputListOddRows(), child: row);
      } else {
        output = Container(child: row);
      }
      odd = !odd;

      return output;
    }).toList();

    if (rows.length > 0) {
      rows.insert(0, GCWTextDivider(text: i18n(context, 'coords_variablecoordinate_currentformulas')));
    }

    return Column(children: rows);
  }
}
