import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';
import 'package:intl/intl.dart';

enum CROSSTOTAL_INPUT_TYPE { LETTERS, NUMBERS }

class CrosstotalOutput extends StatefulWidget {
  final List<int?> values;
  final String text;
  final bool suppressSums;
  final CROSSTOTAL_INPUT_TYPE inputType;
  final bool suppressWordMode;
  final String textValidCharacters;

  const CrosstotalOutput(
      {super.key,
      required this.text,
      required this.values,
      this.suppressSums = false,
      this.suppressWordMode = false,
      this.inputType = CROSSTOTAL_INPUT_TYPE.LETTERS,
      this.textValidCharacters = 'A-Za-z0-9'});

  @override
  _CrosstotalOutputState createState() => _CrosstotalOutputState();
}

class _CrosstotalOutputState extends State<CrosstotalOutput> {
  var _currentMode = GCWSwitchPosition.left;
  var _currentZeroValueBreakMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[Container(height: 30), _buildCrosstotalContent(context)]);
  }

  String _doCalc(List<int?> values, dynamic Function(List<int>) function) {
    String _format(dynamic value) {
      if (value == null) {
        return i18n(context, 'common_notdefined');
      }

      if (value is double) {
        return NumberFormat('0.######').format(value);
      }

      return value.toString();
    }

    String _calc(List<int> vals) {
      var result = function(vals);
      return _format(result);
    }

    if (_currentMode == GCWSwitchPosition.left) { // Letter Mode
      var vals = values.whereType<int>().toList();
      return _calc(vals);
    } else {
      var out = <String>[];

      var vals = <int>[];
      for (int i = 0; i < values.length; i++) {
        if (values[i] == null
            || (_currentZeroValueBreakMode == GCWSwitchPosition.right && values[i] == 0)) {
          if (vals.isNotEmpty) {
            out.add(_calc(vals));
          }
          vals = [];
          continue;
        }
        vals.add(values[i]!);
      }

      if (vals.isNotEmpty) {
        out.add(_calc(vals));
      }

      return out.join(' ');
    }
  }

  String _doCalcText(String text, dynamic Function(String) function) {
    if (text.isEmpty) {
      return '';
    }

    if (_currentMode == GCWSwitchPosition.left) { // Letter Mode
      return function(text).toString();
    } else {
      var _validChars = _currentZeroValueBreakMode == GCWSwitchPosition.left
        ? widget.textValidCharacters
        : widget.textValidCharacters.replaceAll(' ', '');

      return text
          .split(RegExp('[^' + _validChars + ']'))
          .where((String word) => word.isNotEmpty)
          .map((String word) => function(word).toString())
          .join(' ');
    }
  }

  Widget _buildCrosstotalContent(BuildContext context) {
    var text = widget.text;
    List<int?> values = List<int?>.from(widget.values);

    List<List<Object?>> crosstotalValuesCommon = [];
    if (!widget.suppressSums) {
      crosstotalValuesCommon.addAll([
        [
          i18n(context, 'crosstotal_sum') +
              (widget.inputType == CROSSTOTAL_INPUT_TYPE.LETTERS ? '\n(${i18n(context, 'common_wordvalue')})' : ''),
          _doCalc(values, sum)
        ]
      ]);
    }
    crosstotalValuesCommon.addAll([
      [i18n(context, 'crosstotal_sum_crosssum'), _doCalc(values, sumCrossSum)],
      [i18n(context, 'crosstotal_sum_crosssum_iterated'), _doCalc(values, sumCrossSumIterated)],
    ]);

    var crosstotalValuesOthers = <List<Object?>>[];
    if (widget.inputType == CROSSTOTAL_INPUT_TYPE.NUMBERS && !widget.suppressSums) {
      crosstotalValuesOthers = [
        [i18n(context, 'crosstotal_count_numbers'), _doCalc(values, countElements)],
        [i18n(context, 'crosstotal_average'), _doCalc(values, average)],
      ];
    } else if (!widget.suppressSums) {
      crosstotalValuesOthers.addAll([
        [i18n(context, 'crosstotal_count_characters'), _doCalc(values, countElements)],
        [i18n(context, 'crosstotal_count_distinct_characters'), _doCalcText(text, countDistinctCharacters)],
        [i18n(context, 'crosstotal_count_letters'), _doCalcText(text, countLetters)],
        [i18n(context, 'crosstotal_count_digits'), _doCalcText(text, countDigits)]
      ]);
    }
    var crosstotalValuesBody = <List<Object?>>[];
    if (!widget.suppressSums) {
      crosstotalValuesBody.addAll([
        [i18n(context, 'crosstotal_sum_alternated_back'), _doCalc(values, sumAlternatedBackward)],
        [i18n(context, 'crosstotal_sum_alternated_forward'), _doCalc(values, sumAlternatedForward)],
      ]);
    }
    crosstotalValuesBody.addAll([
      [i18n(context, 'crosstotal_sum_crosssum_alternated_back'), _doCalc(values, sumCrossSumAlternatedBackward)],
      [i18n(context, 'crosstotal_sum_crosssum_alternated_forward'), _doCalc(values, sumCrossSumAlternatedForward)],
      [i18n(context, 'crosstotal_crosssum'), _doCalc(values, crossSum)],
      [i18n(context, 'crosstotal_crosssum_iterated'), _doCalc(values, crossSumIterated)],
      [i18n(context, 'crosstotal_crosssum_alternated_back'), _doCalc(values, crossSumAlternatedBackward)],
      [i18n(context, 'crosstotal_crosssum_alternated_forward'), _doCalc(values, crossSumAlternatedForward)],
    ]);
    if (!widget.suppressSums) {
      crosstotalValuesBody.addAll([
        [i18n(context, 'crosstotal_product'), _doCalc(values, product)],
        [i18n(context, 'crosstotal_product_alternated'), _doCalc(values, productAlternated)],
      ]);
    }
    crosstotalValuesBody.addAll([
      [i18n(context, 'crosstotal_product_crosssum'), _doCalc(values, productCrossSum)],
      [i18n(context, 'crosstotal_product_crosssum_iterated'), _doCalc(values, productCrossSumIterated)],
      [i18n(context, 'crosstotal_product_crosssum_alternated_back'), _doCalc(values, productCrossSumAlternatedBackward)],
      [i18n(context, 'crosstotal_product_crosssum_alternated_forward'), _doCalc(values, productCrossSumAlternatedForward)],
      [i18n(context, 'crosstotal_crossproduct'), _doCalc(values, crossProduct)],
      [i18n(context, 'crosstotal_crossproduct_iterated'), _doCalc(values, crossProductIterated)],
      [i18n(context, 'crosstotal_crossproduct_alternated'), _doCalc(values, crossProductAlternated)],
    ]);
    crosstotalValuesOthers.addAll(crosstotalValuesBody);

    return Column(
      children: [
        widget.suppressWordMode == false ?
        Column(
          children: [
            GCWTextDivider(text: i18n(context, 'crosstotal_wordmode'), suppressTopSpace: true),
            GCWTwoOptionsSwitch(
              notitle: true,
              leftValue: i18n(context, 'crosstotal_wordmode_characters'),
              rightValue: i18n(context, 'crosstotal_wordmode_groups'),
              value: _currentMode,
              onChanged: (value) {
                setState(() {
                  _currentMode = value;
                });
              },
            ),
            _currentMode == GCWSwitchPosition.right
                && (widget.values.contains(0)
                || (widget.text.contains(' ') && widget.textValidCharacters.contains(' '))
            )?
              Column(
                children: [
                  GCWTextDivider(text: i18n(context, 'crosstotal_wordmode_groups_ignorezero')),
                  GCWTwoOptionsSwitch(
                    notitle: true,
                    leftValue: i18n(context, 'common_no'),
                    rightValue: i18n(context, 'common_yes'),
                    value: _currentZeroValueBreakMode,
                    onChanged: (value) {
                      setState(() {
                        _currentZeroValueBreakMode = value;
                      });
                    },
                  )
                ],
              ) : Container()
          ],
        ) : Container(),
        GCWTextDivider(text: i18n(context, 'crosstotal_commonsums')),
        GCWColumnedMultilineOutput(
          data: crosstotalValuesCommon,
          flexValues: const [2, 1],
        ),
        GCWTextDivider(text: i18n(context, 'crosstotal_othersums')),
        GCWColumnedMultilineOutput(data: crosstotalValuesOthers, flexValues: const [2, 1]),
      ],
    );
  }
}
