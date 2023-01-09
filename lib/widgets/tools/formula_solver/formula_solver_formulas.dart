import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/parser/latlon.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/logic/tools/formula_solver/formula_parser.dart';
import 'package:gc_wizard/persistence/formula_solver/json_provider.dart';
import 'package:gc_wizard/persistence/formula_solver/model.dart';
import 'package:gc_wizard/persistence/variable_coordinate/json_provider.dart' as var_coords_provider;
import 'package:gc_wizard/persistence/variable_coordinate/model.dart' as var_coords_model;
import 'package:gc_wizard/theme/fixed_colors.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_button.dart';
import 'package:gc_wizard/widgets/common/base/gcw_divider.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_delete_alertdialog.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';
import 'package:gc_wizard/widgets/common/gcw_popup_menu.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_mapview.dart';
import 'package:gc_wizard/widgets/tools/coords/variable_coordinate/variable_coordinate.dart';
import 'package:gc_wizard/widgets/tools/formula_solver/formula_painter.dart';
import 'package:gc_wizard/widgets/tools/formula_solver/formula_solver_values.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:prefs/prefs.dart';

import 'gcw_formula_replace_dialog.dart';

class FormulaSolverFormulas extends StatefulWidget {
  final FormulaGroup group;

  const FormulaSolverFormulas({Key key, this.group}) : super(key: key);

  @override
  FormulaSolverFormulasState createState() => FormulaSolverFormulasState();
}

enum _FormulaSolverResultType { INTERPOLATED, FIXED }

class FormulaSolverFormulasState extends State<FormulaSolverFormulas> {
  var formulaParser = FormulaParser();
  var formulaPainter = FormulaPainter();

  var _newFormulaController;
  var _editFormulaController;
  var _editNameController;
  var _currentNewFormula = '';
  var _currentEditedFormula = '';
  var _currentEditId;
  var _currentEditedName = '';
  var _currentEditNameId;

  Map<int, Map<int, Map<String, dynamic>>> _foundCoordinates = {};

  ThemeColors _themeColors;
  var _editFocusNode;

  @override
  void initState() {
    super.initState();
    _newFormulaController = TextEditingController(text: _currentNewFormula);
    _editFormulaController = TextEditingController(text: _currentEditedFormula);
    _editNameController = TextEditingController(text: _currentEditedName);

    refreshFormulas();

    _editFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _newFormulaController.dispose();
    _editFormulaController.dispose();
    _editNameController.dispose();
    _editFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _themeColors = themeColors();
    _foundCoordinates = {};

    var formulaTool = GCWTool(
        tool: FormulaSolverFormulaValues(group: widget.group),
        toolName: '${widget.group.name} - ${i18n(context, 'formulasolver_values')}',
        helpSearchString: 'formulasolver_values',
        defaultLanguageToolName:
            '${widget.group.name} - ${i18n(context, 'formulasolver_values', useDefaultLanguage: true)}');

    Future _navigateToSubPage(context) async {
      Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => formulaTool)).whenComplete(() {
        setState(() {});
      });
    }

    return Column(
      children: <Widget>[
        GCWButton(
          text: i18n(context, 'formulasolver_formulas_values'),
          onPressed: () {
            _navigateToSubPage(context);
          },
        ),
        GCWTextDivider(text: i18n(context, 'formulasolver_formulas_newformula')),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                child: GCWTextField(
                  hintText: i18n(context, 'formulasolver_formulas_newformula_hint'),
                  controller: _newFormulaController,
                  onChanged: (text) {
                    setState(() {
                      _currentNewFormula = text;
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
                _addNewFormula().whenComplete(() => setState(() {}));
              },
            )
          ],
        ),
        _buildGroupList(context)
      ],
    );
  }

  _addNewFormula() async {
    if (_currentNewFormula.length > 0) {
      var newFormula = Formula(_currentNewFormula);
      insertFormula(newFormula, widget.group);

      _newFormulaController.clear();
      _currentNewFormula = '';
    }
  }

  _updateFormula(Formula formula) {
    updateFormula(formula, widget.group);
  }

  _removeFormula(Formula formula) {
    deleteFormula(formula.id, widget.group);
  }

  _createVariableCoordinateName() {
    var baseName = '[${i18n(context, 'formulasolver_title')}] ${widget.group.name}';

    var existingNames = var_coords_model.formulas.map((f) => f.name).toList();

    int i = 1;
    var name = baseName;
    while (existingNames.contains(name)) name = baseName + ' (${i++})';

    return name;
  }

  var_coords_model.Formula _exportToVariableCoordinate(Formula formula) {
    var_coords_provider.refreshFormulas();

    var_coords_model.Formula varCoordsFormula = var_coords_model.Formula(_createVariableCoordinateName());
    varCoordsFormula.formula = formula.formula;
    var_coords_provider.insertFormula(varCoordsFormula);

    for (var value in widget.group.values) {
      var formulaValue = FormulaValue(value.key, value.value);
      var_coords_provider.insertFormulaValue(formulaValue, varCoordsFormula);
    }

    return varCoordsFormula;
  }

  _openInVariableCoordinate(var_coords_model.Formula formula) {
    Navigator.push(
        context,
        NoAnimationMaterialPageRoute(
            builder: (context) => GCWTool(
                tool: VariableCoordinate(formula: formula),
                toolName: '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title')}',
                helpSearchString: 'coords_variablecoordinate_title',
                i18nPrefix:
                    '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title', useDefaultLanguage: true)}')));
  }

  String _removeOuterSquareBrackets(String formula) {
    formula = formula.trim();
    if (formula.startsWith('[') && formula.endsWith(']')) {
      formula = formula.substring(1, formula.length - 1);
    }

    return formula;
  }

  _buildGroupList(BuildContext context) {
    var odd = true;

    var formulaReferences = <String, String>{};

    var rows = widget.group.formulas
        .asMap()
        .map((index, formula) {
          /*
              TODO: TECHNICAL DEBT:
              - Violation of layer separation principle (https://en.wikipedia.org/wiki/Separation_of_concerns)
              - Logic should be completely separated from UI (
                  In fact, this is for the recursive/referenced formulas... And therefore, this is part of
                  the logic. It needs to be moved from the frontend part
                )
           */
          var formulaToParse = substitution(formula.formula, formulaReferences, caseSensitive: false);
          FormulaSolverOutput calculated = formulaParser.parse(formulaToParse, widget.group.values);

          var resultType =
              calculated.results.length > 1 ? _FormulaSolverResultType.INTERPOLATED : _FormulaSolverResultType.FIXED;

          String firstFormulaResult;
          switch (calculated.state) {
            case FormulaState.STATE_SINGLE_OK:
              firstFormulaResult = calculated.results.first.result;
              break;
            case FormulaState.STATE_SINGLE_ERROR:
              firstFormulaResult = '(${_removeOuterSquareBrackets(calculated.results.first.result)})';
              break;
            default:
              firstFormulaResult = '(${_removeOuterSquareBrackets(formula.formula)})';
              break;
          }

          formulaReferences.putIfAbsent('{${index + 1}}',
              () => RECURSIVE_FORMULA_REPLACEMENT_START + firstFormulaResult + RECURSIVE_FORMULA_REPLACEMENT_END);

          Widget output;

          Map<int, Map<String, dynamic>> _foundFormulaCoordinates = {};
          calculated.results.asMap().forEach((idx, result) {
            var _foundFormulaCoordinate = parseStandardFormats(result.result, wholeString: true);
            if (_foundFormulaCoordinate != null && _foundFormulaCoordinate.length > 0) {
              _foundFormulaCoordinates.putIfAbsent(
                  idx + 1,
                  () => {
                        'coordinate': _foundFormulaCoordinate,
                        'resultType': resultType,
                        'name': '${formula.id}' + (calculated.results.length > 1 ? '.${idx + 1}' : '')
                      });
            }
          });
          if (_foundFormulaCoordinates.isNotEmpty)
            _foundCoordinates.putIfAbsent(index + 1, () => _foundFormulaCoordinates);

          var hasName = formula.name != null && formula.name.isNotEmpty;

          Widget row = Container(
            padding: EdgeInsets.only(top: DEFAULT_MARGIN),
            child: Row(
              children: <Widget>[
                _currentEditId == formula.id
                    ? Expanded(
                        child: Padding(
                        child: GCWTextField(
                          controller: _editFormulaController,
                          focusNode: _editFocusNode,
                          onChanged: (text) {
                            setState(() {
                              _currentEditedFormula = text;
                            });
                          },
                        ),
                        padding: EdgeInsets.only(
                          right: 2,
                        ),
                      ))
                    : Container(),
                _currentEditNameId == formula.id
                    ? Expanded(
                        child: Padding(
                        child: GCWTextField(
                          controller: _editNameController,
                          focusNode: _editFocusNode,
                          onChanged: (text) {
                            setState(() {
                              _currentEditedName = text;
                            });
                          },
                        ),
                        padding: EdgeInsets.only(
                          right: 2,
                        ),
                      ))
                    : Container(),
                _currentEditId != formula.id && _currentEditNameId != formula.id
                    ? Expanded(
                        child: Column(children: <Widget>[
                        hasName
                            ? Row(
                                children: [
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Container(height: 2 * DOUBLE_DEFAULT_MARGIN),
                                      GCWTextDivider(
                                        text: formula.name,
                                        suppressTopSpace: true,
                                      ),
                                    ],
                                  ))
                                ],
                              )
                            : Container(),
                        Row(
                          children: [
                            Container(child: GCWText(text: (index + 1).toString() + '.'), width: 35),
                            Flexible(
                              child: _buildFormulaText(formula.formula, widget.group.values, index + 1),
                            )
                          ],
                        ),
                        IntrinsicHeight(
                            child: Row(
                          children: <Widget>[
                            Container(
                              child: [FormulaState.STATE_SINGLE_OK, FormulaState.STATE_EXPANDED_OK]
                                      .contains(calculated.state)
                                  ? Icon(
                                      Icons.check,
                                      color: _themeColors.mainFont(),
                                    )
                                  : Icon(
                                      Icons.priority_high,
                                      color: themeColors().formulaError(),
                                    ),
                              width: 35,
                              alignment: Alignment.topLeft,
                            ),
                            Flexible(child: _buildFormulaOutput(index, calculated, _foundFormulaCoordinates))
                          ],
                        ))
                      ]))
                    : Container(),
                _currentEditId == formula.id || _currentEditNameId == formula.id
                    ? GCWIconButton(
                        icon: Icons.check,
                        onPressed: () {
                          if (_currentEditId == formula.id) {
                            formula.formula = _currentEditedFormula;
                            _updateFormula(formula);
                            setState(() {
                              _currentEditId = null;
                              _editFormulaController.clear();
                            });
                          } else if (_currentEditNameId == formula.id) {
                            formula.name = _currentEditedName;
                            _updateFormula(formula);
                            setState(() {
                              _currentEditNameId = null;
                              _editNameController.clear();
                            });
                          }
                        },
                      )
                    : Container(),
                Container(
                    alignment: Alignment.topRight,
                    child: GCWPopupMenu(
                        iconData: Icons.more_vert,
                        menuItemBuilder: (context) => [
                              GCWPopupMenuItem(
                                  child:
                                      iconedGCWPopupMenuItem(context, Icons.edit, 'formulasolver_formulas_editformula'),
                                  action: (index) => setState(() {
                                        _currentEditId = formula.id;
                                        _currentEditedFormula = formula.formula;
                                        _editFormulaController.text = formula.formula;
                                        FocusScope.of(context).requestFocus(_editFocusNode);
                                      })),
                              GCWPopupMenuItem(
                                  child: iconedGCWPopupMenuItem(
                                      context, Icons.edit, 'formulasolver_formulas_modifyformula'),
                                  action: (index) => setState(() {
                                        showFormulaReplaceDialog(context, [formula], onOkPressed: (value) {
                                          if (value.first == null ||
                                              value.first.formula == null ||
                                              formula.formula == value.first.formula) return;

                                          formula.formula = value.first.formula;
                                          _updateFormula(formula);
                                          setState(() {});
                                        });
                                      })),
                              GCWPopupMenuItem(
                                  child: iconedGCWPopupMenuItem(
                                      context, Icons.text_fields, 'formulasolver_formulas_nameformula'),
                                  action: (index) => setState(() {
                                        _currentEditNameId = formula.id;
                                        _currentEditedName = formula.name;
                                        _editNameController.text = formula.name;
                                        FocusScope.of(context).requestFocus(_editFocusNode);
                                      })),
                              GCWPopupMenuItem(
                                  child: iconedGCWPopupMenuItem(
                                      context, Icons.delete, 'formulasolver_formulas_removeformula'),
                                  action: (index) => showDeleteAlertDialog(
                                        context,
                                        formula.formula,
                                        () {
                                          _removeFormula(formula);
                                          setState(() {});
                                        },
                                      )),
                              GCWPopupMenuItem(
                                child: iconedGCWPopupMenuItem(
                                    context, Icons.content_copy, 'formulasolver_formulas_copyformula'),
                                action: (index) => insertIntoGCWClipboard(context, formula.formula),
                              ),
                              GCWPopupMenuItem(
                                  child: iconedGCWPopupMenuItem(
                                      context,
                                      Icons.content_copy,
                                      calculated.results.length > 1
                                          ? 'formulasolver_formulas_copyresults'
                                          : 'formulasolver_formulas_copyresult'),
                                  action: (index) => insertIntoGCWClipboard(
                                      context, calculated.results.map((result) => result.result).join('\n'))),
                              GCWPopupMenuItem(
                                  child: iconedGCWPopupMenuItem(
                                    context,
                                    Icons.forward,
                                    'formulasolver_formulas_openinvarcoords',
                                  ),
                                  action: (index) {
                                    var varCoordsFormula = _exportToVariableCoordinate(formula);
                                    _openInVariableCoordinate(varCoordsFormula);
                                  }),
                              if (_foundFormulaCoordinates.isNotEmpty)
                                GCWPopupMenuItem(
                                    child: iconedGCWPopupMenuItem(
                                      context,
                                      Icons.my_location,
                                      'formulasolver_formulas_showonmap',
                                    ),
                                    action: (index) {
                                      if (_foundFormulaCoordinates.isEmpty) return;

                                      _showFormulaResultOnMap(_foundFormulaCoordinates
                                          .map((index, coordinate) {
                                            return MapEntry(index, _createMapPoint(coordinate));
                                          })
                                          .values
                                          .toList());
                                    })
                            ]))
              ],
            ),
          );

          if (_currentEditId != formula.id && _currentEditNameId != formula.id) {
            row = IntrinsicHeight(child: row);
          }

          if (odd) {
            output = Container(color: _themeColors.outputListOddRows(), child: row);
          } else {
            output = Container(child: row);
          }
          odd = !odd;

          return MapEntry(index, output);
        })
        .values
        .toList();

    if (rows.length > 0) {
      rows.insert(
          0,
          GCWTextDivider(
              text: i18n(context, 'formulasolver_formulas_currentformulas'),
              trailing: Row(children: [
                GCWIconButton(
                  icon: Icons.color_lens,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    setState(() {
                      Prefs.setBool(PREFERENCE_FORMULASOLVER_COLOREDFORMULAS,
                          !Prefs.getBool(PREFERENCE_FORMULASOLVER_COLOREDFORMULAS));
                    });
                  },
                ),
                GCWPopupMenu(
                    iconData: Icons.more_vert,
                    size: IconButtonSize.SMALL,
                    menuItemBuilder: (context) => [
                          GCWPopupMenuItem(
                              child:
                                  iconedGCWPopupMenuItem(context, Icons.edit, 'formulasolver_formulas_modifyformulas'),
                              action: (index) => setState(() {
                                    showFormulaReplaceDialog(context, widget.group.formulas, onOkPressed: (value) {
                                      if (value == null) return;

                                      for (int i = 0; i < widget.group.formulas.length; i++) {
                                        if (value[i] == null) continue;
                                        if (value[i].formula == null) continue;

                                        if (widget.group.formulas[i].formula != value[i].formula) {
                                          var formula = widget.group.formulas[i];
                                          formula.formula = value[i].formula;
                                          _updateFormula(formula);
                                        }
                                      }
                                      setState(() {});
                                    });
                                  })),
                          GCWPopupMenuItem(
                              child: iconedGCWPopupMenuItem(
                                  context, Icons.delete, 'formulasolver_formulas_removeformulas'),
                              action: (index) => showDeleteAlertDialog(
                                    context,
                                    i18n(context, 'formulasolver_formulas_allformulas'),
                                    () {
                                      var formulasToRemove = List.from(widget.group.formulas);
                                      formulasToRemove.forEach((formula) => _removeFormula(formula));
                                      setState(() {});
                                    },
                                  )),
                          if (_foundCoordinates.length > 0)
                            GCWPopupMenuItem(
                                child: iconedGCWPopupMenuItem(
                                  context,
                                  Icons.my_location,
                                  'formulasolver_formulas_showonmap',
                                ),
                                action: (index) {
                                  List<GCWMapPoint> mapPoints = [];

                                  _foundCoordinates.forEach((index, coordinates) {
                                    mapPoints.addAll(coordinates
                                        .map((idx, coordinate) {
                                          return MapEntry(idx, _createMapPoint(coordinate));
                                        })
                                        .values
                                        .toList());
                                  });

                                  if (mapPoints.isNotEmpty) {
                                    _showFormulaResultOnMap(mapPoints);
                                  }
                                })
                        ])
              ])));
    }

    return Column(children: rows);
  }

  _buildFormulaOutput(int formulaIndex, FormulaSolverOutput output, Map<int, Map<String, dynamic>> coordinates) {
    switch (output.state) {
      case FormulaState.STATE_SINGLE_OK:
      case FormulaState.STATE_SINGLE_ERROR:
        return GCWText(text: output.results.first.result);
      case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE:
        return GCWText(text: i18n(context, 'formulasolver_values_type_interpolated_exceeded'));
      case FormulaState.STATE_EXPANDED_ERROR:
      case FormulaState.STATE_EXPANDED_OK:
        return Container(
            padding: EdgeInsets.only(right: DEFAULT_MARGIN),
            child: GCWExpandableTextDivider(
                expanded: false,
                text: '${output.results.length} ' + i18n(context, 'formulasolver_values_type_interpolated_result'),
                child: Column(
                    children: output.results
                        .asMap()
                        .map((index, result) {
                          return MapEntry(
                              index,
                              Column(children: [
                                Row(
                                  children: [
                                    Flexible(
                                        child: Column(
                                      children: [
                                        GCWText(text: result.result),
                                        Container(height: DOUBLE_DEFAULT_MARGIN),
                                        GCWText(
                                          text: result.variables
                                              .map((key, value) {
                                                return MapEntry(key, '$key: $value');
                                              })
                                              .values
                                              .join(', '),
                                          style: gcwTextStyle().copyWith(fontSize: fontSizeSmall()),
                                        )
                                      ],
                                    )),
                                    GCWPopupMenu(
                                        iconData: Icons.more_vert,
                                        size: IconButtonSize.SMALL,
                                        menuItemBuilder: (context) => [
                                              GCWPopupMenuItem(
                                                  child: iconedGCWPopupMenuItem(
                                                      context, Icons.content_copy, 'formulasolver_formulas_copyresult'),
                                                  action: (index) => insertIntoGCWClipboard(context, result.result)),
                                              if (coordinates[index + 1] != null)
                                                GCWPopupMenuItem(
                                                    child: iconedGCWPopupMenuItem(
                                                      context,
                                                      Icons.my_location,
                                                      'formulasolver_formulas_showonmap',
                                                    ),
                                                    action: (idx) {
                                                      _showFormulaResultOnMap(
                                                          [_createMapPoint(coordinates[index + 1])]);
                                                    })
                                            ]),
                                  ],
                                ),
                                if (index < output.results.length - 1) GCWDivider()
                              ]));

                          //return GCWText(text: result.result);
                        })
                        .values
                        .toList())));
    }
  }

  GCWMapPoint _createMapPoint(Map<String, dynamic> coordinate) {
    var coord = coordinate['coordinate'];
    var resultType = coordinate['resultType'];
    var name = coordinate['name'];

    return GCWMapPoint(
        point: coord['coordinate'],
        markerText: i18n(context, 'formulasolver_formulas_showonmap_coordinatetext') + ' $name',
        coordinateFormat: {'format': coord['format']},
        color: resultType == _FormulaSolverResultType.FIXED
            ? COLOR_MAP_POINT
            : COLOR_FORMULASOLVER_INTERPOLATED_MAP_POINT);
  }

  _showFormulaResultOnMap(coordinates) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GCWTool(
                tool: GCWMapView(
                  points: coordinates,
                ),
                i18nPrefix: 'coords_map_view',
                autoScroll: false,
                suppressToolMargin: true)));
  }

  Widget _buildFormulaText(String formula, List<FormulaValue> values, int formulaIndex) {
    Map<String, String> vals = {};
    values.forEach((value) {
      vals.putIfAbsent(value.key, () => value.value);
    });

    return SelectableText.rich(TextSpan(
        children: _buildTextSpans(
            formula,
            formulaPainter.paintFormula(
                formula, vals, formulaIndex, Prefs.getBool(PREFERENCE_FORMULASOLVER_COLOREDFORMULAS)))));
  }

  List<InlineSpan> _buildTextSpans(String formula, String formulaColors) {
    var list = <TextSpan>[];
    var startIndex = 0;
    var gcwStyle = gcwTextStyle();

    for (int i = 0; i < formula.length; i++) {
      if ((i == formula.length - 1) || (formulaColors[i + 1] != formulaColors[i])) {
        TextStyle textStyle;
        switch (formulaColors[i]) {
          case 'g':
            textStyle = TextStyle(color: themeColors().formulaNumber());
            break;
          case 'r':
            textStyle = TextStyle(color: themeColors().formulaVariable());
            break;
          case 'b':
            textStyle = TextStyle(color: themeColors().formulaMath());
            break;
          case 'R':
          case 'G':
          case 'B':
            textStyle = TextStyle(color: themeColors().formulaError(), fontWeight: FontWeight.bold);
            break;
          default:
            textStyle = TextStyle();
        }
        var text = formula.substring(startIndex, i + 1);
        var textSpan = TextSpan(
            text: text,
            style: TextStyle(
              fontSize: gcwStyle.fontSize,
              fontFamily: gcwStyle.fontFamily,
              color: (textStyle.color == null) ? gcwStyle.color : textStyle.color,
              fontWeight: (textStyle.fontWeight == null) ? gcwStyle.fontWeight : textStyle.fontWeight,
            ));
        list.add(textSpan);

        startIndex = i + 1;
      }
    }
    return list;
  }
}
