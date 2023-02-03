part of 'package:gc_wizard/tools/formula_solver/widget/formula_solver_formulas.dart';

List<String> _newFormulas;

_showFormulaReplaceDialog(BuildContext context, List<Formula> formulas,
    {Widget contentWidget, int dialogHeight, Function onOkPressed}) {
  var _output = formulas.map((formula) => Formula.fromFormula(formula)).toList();
  // var _output = formulas.map((formula) => Formula.fromJson(formula.toMap())).toList();

  showGCWDialog(
      context,
      i18n(context, 'formulasolver_formulas_modifyformula'),
      _FormulaReplace(formulas: List<Formula>.from(formulas)),
      [
        GCWDialogButton(
            text: i18n(context, 'common_ok'),
            onPressed: () {
              if (onOkPressed != null) {
                for (int i = 0; i < formulas.length; i++) {
                  _output[i].formula = _newFormulas[i];
                }

                onOkPressed(_output);
              }
            })
      ],
      cancelButton: true);
}

class _FormulaReplace extends StatefulWidget {
  final List<Formula> formulas;

  const _FormulaReplace({Key key, this.formulas}) : super(key: key);

  @override
  _FormulaReplaceState createState() => _FormulaReplaceState();
}

class _FormulaReplaceState extends State<_FormulaReplace> {
  bool _currentValueBracket = false;
  bool _currentValueBraces = false;
  bool _currentValueMultiply = false;

  var textStyle = gcwTextStyle().copyWith(color: themeColors().dialogText());

  var _currentFormulaIndex = 0;

  @override
  void initState() {
    super.initState();
    _newFormulas = List.from(widget.formulas.map((formula) => formula.formula).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GCWTextDivider(
            text: i18n(context, 'formulasolver_formulas_modifiedformula') +
                ' ' +
                i18n(context, 'formulasolver_formula') +
                ' ${widget.formulas[_currentFormulaIndex].id}',
            style: textStyle,
            suppressTopSpace: true,
            trailing: widget.formulas == null || widget.formulas.length <= 1
                ? Container()
                : Row(
                    children: [
                      GCWIconButton(
                        icon: Icons.arrow_back_ios,
                        size: IconButtonSize.SMALL,
                        iconColor: gcwDialogTextStyle().color,
                        onPressed: () {
                          setState(() {
                            _currentFormulaIndex = modulo(_currentFormulaIndex - 1, widget.formulas.length);
                          });
                        },
                      ),
                      GCWIconButton(
                        icon: Icons.arrow_forward_ios,
                        size: IconButtonSize.SMALL,
                        iconColor: gcwDialogTextStyle().color,
                        onPressed: () {
                          setState(() {
                            _currentFormulaIndex = modulo(_currentFormulaIndex + 1, widget.formulas.length);
                          });
                        },
                      )
                    ],
                  )),
        GCWText(
          text: _newFormulas[_currentFormulaIndex],
          style: textStyle,
        ),
        Container(
          child: GCWDivider(color: textStyle.color),
          padding: EdgeInsets.only(top: 6 * DEFAULT_MARGIN),
        ),
        GCWCheckBox(
          value: _currentValueBracket,
          title: i18n(context, 'formulasolver_formulas_outerbrackets') + ' ( ) ➔ [ ]',
          textStyle: textStyle,
          onChanged: (value) {
            setState(() {
              _currentValueBracket = value;
              _buildNewFormulas();
            });
          },
          fillColor: MaterialStateColor.resolveWith(getFillColor),
          checkColor: themeColors().dialog(),
          hoverColor: themeColors().dialog(),
          overlayColor: MaterialStateColor.resolveWith(getOverlayColor),
        ),
        GCWCheckBox(
          value: _currentValueBraces,
          title: i18n(context, 'formulasolver_formulas_outerbrackets') + ' { } ➔ [ ]',
          textStyle: textStyle,
          onChanged: (value) {
            setState(() {
              _currentValueBraces = value;
              _buildNewFormulas();
            });
          },
          fillColor: MaterialStateColor.resolveWith(getFillColor),
          checkColor: themeColors().dialog(),
          hoverColor: themeColors().dialog(),
          overlayColor: MaterialStateColor.resolveWith(getOverlayColor),
        ),
        GCWCheckBox(
          value: _currentValueMultiply,
          title: 'x ➔ *',
          textStyle: textStyle,
          onChanged: (value) {
            setState(() {
              _currentValueMultiply = value;
              _buildNewFormulas();
            });
          },
          fillColor: MaterialStateColor.resolveWith(getFillColor),
          checkColor: themeColors().dialog(),
          hoverColor: themeColors().dialog(),
          overlayColor: MaterialStateColor.resolveWith(getOverlayColor),
        )
      ],
    );
  }

  Color getOverlayColor(Set<MaterialState> states) {
    return themeColors().dialog();
  }

  Color getFillColor(Set<MaterialState> states) {
    return Colors.black;
  }

  List<String> _buildNewFormulas() {
    if (widget.formulas == null || widget.formulas.isEmpty) {
      return <String>[];
    }

    _newFormulas = List.from(widget.formulas.map((formula) => formula.formula).toList());

    if (_currentValueBracket) _newFormulas = _replaceBrackets(_newFormulas, '(', ')');

    if (_currentValueBraces) _newFormulas = _replaceBrackets(_newFormulas, '{', '}');

    if (_currentValueMultiply) {
      _newFormulas = _newFormulas.map((formula) => formula.replaceAll(RegExp(r'[xX]'), '*')).toList();
    }

    return _newFormulas;
  }

  List<String> _replaceBrackets(List<String> formulas, String openBracket, String closeBracket) {
    formulas = formulas.map((formula) {
      int ignoreBracket = 0;
      if (formula == null || formula.isEmpty) {
        return null;
      }

      return formula.split('').map((e) {
        if ((e == openBracket) || (e == '[')) {
          e = (ignoreBracket == 0) ? '[' : e;
          ignoreBracket += 1;
        } else if ((e == closeBracket) || (e == ']')) {
          ignoreBracket -= 1;
          e = (ignoreBracket == 0) ? ']' : e;
        }
        return e;
      }).join();
    }).toList();

    return formulas;
  }
}
