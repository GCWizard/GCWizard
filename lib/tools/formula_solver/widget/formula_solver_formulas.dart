part of 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulagroups.dart';

class _FormulaSolverFormulas extends StatefulWidget {
  final FormulaGroup group;

  const _FormulaSolverFormulas({Key? key, required this.group}) : super(key: key);

  @override
  _FormulaSolverFormulasState createState() => _FormulaSolverFormulasState();
}

enum _FormulaSolverResultType { INTERPOLATED, FIXED }

class _FormulaSolverFormulasState extends State<_FormulaSolverFormulas> {
  var formulaParser = FormulaParser();
  var formulaPainter = FormulaPainter();

  late TextEditingController _newFormulaController;
  late TextEditingController _editFormulaController;
  late TextEditingController _editNameController;
  var _currentNewFormula = '';
  var _currentEditedFormula = '';
  int? _currentEditId;
  String? _currentEditedName = '';
  int? _currentEditNameId;

  Map<int, Map<int, _ParsedCoordinate>> _foundCoordinates = {};

  ThemeColors _themeColors = themeColors();
  final _editFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _newFormulaController = TextEditingController(text: _currentNewFormula);
    _editFormulaController = TextEditingController(text: _currentEditedFormula);
    _editNameController = TextEditingController(text: _currentEditedName);

    refreshFormulas();
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
        tool: _FormulaSolverFormulaValues(group: widget.group),
        toolName: '${widget.group.name} - ${i18n(context, 'formulasolver_values')}',
        helpSearchString: 'formulasolver_values',
        defaultLanguageToolName:
            '${widget.group.name} - ${i18n(context, 'formulasolver_values', useDefaultLanguage: true)}', id: '',);

    Future<void> _navigateToSubPage(BuildContext context) async {
      Navigator.push(context, NoAnimationMaterialPageRoute<GCWTool>(builder: (context) => formulaTool)).whenComplete(() {
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
                padding: const EdgeInsets.only(
                  right: 2,
                ),
                child: GCWTextField(
                  hintText: i18n(context, 'formulasolver_formulas_newformula_hint'),
                  controller: _newFormulaController,
                  onChanged: (text) {
                    setState(() {
                      _currentNewFormula = text;
                    });
                  },
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

  Future<void> _addNewFormula() async {
    if (_currentNewFormula.isNotEmpty) {
      var newFormula = Formula(_currentNewFormula);
      insertFormula(newFormula, widget.group);

      _newFormulaController.clear();
      _currentNewFormula = '';
    }
  }

  void _updateFormula(Formula formula) {
    updateFormula(formula, widget.group);
  }

  void _removeFormula(Formula formula) {
    deleteFormula(formula.id!, widget.group);
  }

  String _createVariableCoordinateName() {
    var baseName = '[${i18n(context, 'formulasolver_title')}] ${widget.group.name}';

    var existingNames = var_coords_model.formulas.map((f) => f.name).toList();

    int i = 1;
    var name = baseName;
    while (existingNames.contains(name)) {
      name = baseName + ' (${i++})';
    }

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

  void _openInVariableCoordinate(var_coords_model.Formula formula) {
    Navigator.push(
        context,
        NoAnimationMaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: VariableCoordinate(formula: formula),
                toolName: '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title')}',
                helpSearchString: 'coords_variablecoordinate_title',
                id:
                    '${formula.name} - ${i18n(context, 'coords_variablecoordinate_title', useDefaultLanguage: true)}')));
  }

  String _removeOuterSquareBrackets(String formula) {
    formula = formula.trim();
    if (formula.startsWith('[') && formula.endsWith(']')) {
      formula = formula.substring(1, formula.length - 1);
    }

    return formula;
  }

  Column _buildGroupList(BuildContext context) {
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

          Map<int, _ParsedCoordinate> _foundFormulaCoordinates = {};
          calculated.results.asMap().forEach((idx, result) {
            BaseCoordinate? _foundFormulaCoordinate = parseStandardFormats(result.result, wholeString: true);
            if (_foundFormulaCoordinate != null && _foundFormulaCoordinate.toLatLng() != null) {
              _foundFormulaCoordinates.putIfAbsent(
                  idx + 1,
                  () => _ParsedCoordinate(
                        _foundFormulaCoordinate,
                        resultType,
                        '${formula.id}' + (calculated.results.length > 1 ? '.${idx + 1}' : '')
                  )
              );
            }
          });
          if (_foundFormulaCoordinates.isNotEmpty) {
            _foundCoordinates.putIfAbsent(index + 1, () => _foundFormulaCoordinates);
          }

          var hasName = formula.name != null && formula.name!.isNotEmpty;

          Widget row = Container(
            padding: const EdgeInsets.only(top: DEFAULT_MARGIN),
            child: Row(
              children: <Widget>[
                _currentEditId == formula.id
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(
                          right: 2,
                        ),
                        child: GCWTextField(
                          controller: _editFormulaController,
                          focusNode: _editFocusNode,
                          onChanged: (text) {
                            setState(() {
                              _currentEditedFormula = text;
                            });
                          },
                        ),
                      ))
                    : Container(),
                _currentEditNameId == formula.id
                    ? Expanded(
                        child: Padding(
                        padding: const EdgeInsets.only(
                          right: 2,
                        ),
                        child: GCWTextField(
                          controller: _editNameController,
                          focusNode: _editFocusNode,
                          onChanged: (text) {
                            setState(() {
                              _currentEditedName = text;
                            });
                          },
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
                                        text: formula.name ?? '',
                                        suppressTopSpace: true,
                                      ),
                                    ],
                                  ))
                                ],
                              )
                            : Container(),
                        Row(
                          children: [
                            SizedBox(width: 35, child: GCWText(text: (index + 1).toString() + '.')),
                            Flexible(
                              child: _buildFormulaText(formula.formula, widget.group.values, index + 1),
                            )
                          ],
                        ),
                        IntrinsicHeight(
                            child: Row(
                          children: <Widget>[
                            Container(
                              width: 35,
                              alignment: Alignment.topLeft,
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
                                        _showFormulaReplaceDialog(context, [formula], onOkPressed: (List<Formula> value) {
                                          if (formula.formula == value.first.formula) return;

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
                                        _editNameController.text = formula.name ?? '';
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
                                          .map((int index, _ParsedCoordinate coordinate) {
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

    if (rows.isNotEmpty) {
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
                                    _showFormulaReplaceDialog(context, widget.group.formulas, onOkPressed: (List<Formula> value) {
                                      for (int i = 0; i < widget.group.formulas.length; i++) {
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
                                      var formulasToRemove = List<Formula>.from(widget.group.formulas);
                                      for (var formula in formulasToRemove) {
                                        _removeFormula(formula);
                                      }
                                      setState(() {});
                                    },
                                  )),
                          if (_foundCoordinates.isNotEmpty)
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

  Widget _buildFormulaOutput(int formulaIndex, FormulaSolverOutput output, Map<int, _ParsedCoordinate> coordinates) {
    switch (output.state) {
      case FormulaState.STATE_SINGLE_OK:
      case FormulaState.STATE_SINGLE_ERROR:
        return GCWText(text: output.results.first.result);
      case FormulaState.STATE_EXPANDED_ERROR_EXCEEDEDRANGE:
        return GCWText(text: i18n(context, 'formulasolver_values_type_interpolated_exceeded'));
      case FormulaState.STATE_EXPANDED_ERROR:
      case FormulaState.STATE_EXPANDED_OK:
        return Container(
            padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
            child: GCWExpandableTextDivider(
                expanded: false,
                text: '${output.results.length} ' + i18n(context, 'formulasolver_values_type_interpolated_result'),
                child: Column(
                    children: output.results
                        .asMap()
                        .map((int index, FormulaSolverSingleResult result) {
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
                                          text: result.variables == null ? '' : result.variables!
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
                                                      if (index + 1 >= coordinates.length) return;

                                                      _showFormulaResultOnMap(
                                                          [_createMapPoint(coordinates[index + 1]!)]);
                                                    })
                                            ]),
                                  ],
                                ),
                                if (index < output.results.length - 1) const GCWDivider()
                              ]));

                          //return GCWText(text: result.result);
                        })
                        .values
                        .toList())));
    }
  }

  GCWMapPoint _createMapPoint(_ParsedCoordinate coordinate) {
    var coord = coordinate.coords;
    var resultType = coordinate.resultType;
    var name = coordinate.name;

    return GCWMapPoint(
        point: coord.toLatLng()!,
        markerText: i18n(context, 'formulasolver_formulas_showonmap_coordinatetext') + ' $name',
        coordinateFormat: CoordinateFormat(coord.format.type),
        color: resultType == _FormulaSolverResultType.FIXED
            ? COLOR_MAP_POINT
            : COLOR_FORMULASOLVER_INTERPOLATED_MAP_POINT);
  }

  void _showFormulaResultOnMap(List<GCWMapPoint> coordinates) {
    Navigator.push(
        context,
        MaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: GCWMapView(
                  points: coordinates,
                ),
                id: 'coords_map_view',
                autoScroll: false,
                suppressToolMargin: true)));
  }

  Widget _buildFormulaText(String formula, List<FormulaValue> values, int formulaIndex) {
    Map<String, String> vals = {};
    for (var value in values) {
      vals.putIfAbsent(value.key, () => value.value);
    }

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
            textStyle = const TextStyle();
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

class _ParsedCoordinate {
  final BaseCoordinate coords;
  final String name;
  final _FormulaSolverResultType resultType;

  _ParsedCoordinate(this.coords, this.resultType, this.name);
}
