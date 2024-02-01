import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/_common/logic/irrational_numbers.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class IrrationalNumbersSearch extends StatefulWidget {
  final IrrationalNumber irrationalNumber;

  const IrrationalNumbersSearch({Key? key, required this.irrationalNumber}) : super(key: key);

  @override
  _IrrationalNumbersSearchState createState() => _IrrationalNumbersSearchState();
}

class _IrrationalNumbersSearchState extends State<IrrationalNumbersSearch> {
  var _currentInput = '';
  late IrrationalNumberCalculator _calculator;
  var _hasWildCards = false;

  var _totalCurrentSolutions = 0;
  var _currentSolution = 0;
  late TextEditingController _controller;

  String? _errorMessage;

  List<IrrationalNumberDecimalOccurence> _solutions = [];

  @override
  void initState() {
    super.initState();
    _calculator = IrrationalNumberCalculator(irrationalNumber: widget.irrationalNumber);
    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (ret) {
            setState(() {
              _currentInput = ret;
              try {
                _solutions = _calculator.decimalOccurences(_currentInput);
                _errorMessage = null;
              } on FormatException catch (e) {
                _errorMessage = e.message;
              }
              _hasWildCards = !isOnlyNumerals(_currentInput);
              _currentSolution = 0;
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  Object _calculateOutput() {
    if (_errorMessage != null) return i18n(context, _errorMessage!);

    if (_currentInput.isEmpty) return '';

    _totalCurrentSolutions = _solutions.length;

    if (_solutions.isEmpty) return '';

    var selector = (_totalCurrentSolutions > 1)
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 5 * DOUBLE_DEFAULT_MARGIN),
            child: Row(
              children: [
                GCWIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () {
                    setState(() {
                      _currentSolution = (_currentSolution - 1 + _totalCurrentSolutions) % _totalCurrentSolutions;
                    });
                  },
                ),
                Expanded(
                  child: GCWText(
                      align: Alignment.center,
                      text:
                          '${_currentSolution + 1}/$_totalCurrentSolutions' // + (_currentSolutions.length >= _MAX_SOLUTIONS ? ' *' : ''),
                      ),
                ),
                GCWIconButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    setState(() {
                      _currentSolution = (_currentSolution + 1) % _totalCurrentSolutions;
                    });
                  },
                ),
              ],
            ))
        : Container();

    var _solution = _solutions[_currentSolution];

    var output = [
      if (_hasWildCards) [i18n(context, 'common_value'), _solution.value],
      [i18n(context, 'common_start'), _solution.start],
      [i18n(context, 'common_end'), _solution.end]
    ];

    return Column(children: [
      selector,
      GCWColumnedMultilineOutput(data: output, flexValues: const [2, 3])
    ]);
  }
}
