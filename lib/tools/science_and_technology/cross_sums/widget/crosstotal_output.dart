import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';

enum CROSSTOTAL_INPUT_TYPE { LETTERS, NUMBERS }

class CrosstotalOutput extends StatefulWidget {
  final List<int> values;
  final String text;
  final bool suppressSums;
  final CROSSTOTAL_INPUT_TYPE inputType;

  const CrosstotalOutput(
      {Key? key,
      required this.text,
      required this.values,
      this.suppressSums = false,
      this.inputType = CROSSTOTAL_INPUT_TYPE.LETTERS})
      : super(key: key);

  @override
  _CrosstotalOutputState createState() => _CrosstotalOutputState();
}

class _CrosstotalOutputState extends State<CrosstotalOutput> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[Container(height: 30), _buildCrosstotalContent(context)]);
  }

  Widget _buildCrosstotalContent(BuildContext context) {
    var text = widget.text;
    List<int> values = List.from(widget.values);

    List<List<Object?>> crosstotalValuesCommon = [];
    if (!widget.suppressSums) {
      crosstotalValuesCommon.addAll([
        [
          i18n(context, 'crosstotal_sum') +
              (widget.inputType == CROSSTOTAL_INPUT_TYPE.LETTERS ? '\n(${i18n(context, 'common_wordvalue')})' : ''),
          sum(values)
        ]
      ]);
    }
    crosstotalValuesCommon.addAll([
      [i18n(context, 'crosstotal_sum_crosssum'), sumCrossSum(values)],
      [i18n(context, 'crosstotal_sum_crosssum_iterated'), sumCrossSumIterated(values)],
    ]);

    var crosstotalValuesOthers = <List<Object?>>[];
    if (widget.inputType == CROSSTOTAL_INPUT_TYPE.NUMBERS && !widget.suppressSums) {
      crosstotalValuesOthers = [
        [i18n(context, 'crosstotal_count_numbers'), countCharacters(values)]
      ];
    } else if (!widget.suppressSums) {
      crosstotalValuesOthers.addAll([
        [i18n(context, 'crosstotal_count_characters'), countCharacters(values)],
        [i18n(context, 'crosstotal_count_distinct_characters'), countDistinctCharacters(values)],
        [i18n(context, 'crosstotal_count_letters'), countLetters(text)],
        [i18n(context, 'crosstotal_count_digits'), countDigits(text)]
      ]);
    }
    var crosstotalValuesBody = <List<Object?>>[];
    if (!widget.suppressSums) {
      crosstotalValuesBody.addAll([
        [i18n(context, 'crosstotal_sum_alternated_back'), sumAlternatedBackward(values)],
        [i18n(context, 'crosstotal_sum_alternated_forward'), sumAlternatedForward(values)],
      ]);
    }
    crosstotalValuesBody.addAll([
      [
        i18n(context, 'crosstotal_sum_crosssum_alternated_back'),
        sumCrossSumAlternatedBackward(values) ?? i18n(context, 'common_notdefined')
      ],
      [
        i18n(context, 'crosstotal_sum_crosssum_alternated_forward'),
        sumCrossSumAlternatedForward(values) ?? i18n(context, 'common_notdefined')
      ],
      [i18n(context, 'crosstotal_crosssum'), crossSum(values)],
      [i18n(context, 'crosstotal_crosssum_iterated'), crossSumIterated(values)],
      [
        i18n(context, 'crosstotal_crosssum_alternated_back'),
        crossSumAlternatedBackward(values) ?? i18n(context, 'common_notdefined')
      ],
      [
        i18n(context, 'crosstotal_crosssum_alternated_forward'),
        crossSumAlternatedForward(values) ?? i18n(context, 'common_notdefined')
      ],
    ]);
    if (!widget.suppressSums) {
      crosstotalValuesBody.addAll([
        [i18n(context, 'crosstotal_product'), product(values)],
        [i18n(context, 'crosstotal_product_alternated'), productAlternated(values)],
      ]);
    }
    crosstotalValuesBody.addAll([
      [i18n(context, 'crosstotal_product_crosssum'), productCrossSum(values)],
      [i18n(context, 'crosstotal_product_crosssum_iterated'), productCrossSumIterated(values)],
      [
        i18n(context, 'crosstotal_product_crosssum_alternated_back'),
        productCrossSumAlternatedBackward(values) ?? i18n(context, 'common_notdefined')
      ],
      [
        i18n(context, 'crosstotal_product_crosssum_alternated_forward'),
        productCrossSumAlternatedForward(values) ?? i18n(context, 'common_notdefined')
      ],
      [i18n(context, 'crosstotal_crossproduct'), crossProduct(values)],
      [i18n(context, 'crosstotal_crossproduct_iterated'), crossProductIterated(values)],
      [
        i18n(context, 'crosstotal_crossproduct_alternated'),
        crossProductAlternated(values) ?? i18n(context, 'common_notdefined')
      ],
    ]);
    crosstotalValuesOthers.addAll(crosstotalValuesBody);

    return Column(
      children: [
        GCWTextDivider(text: i18n(context, 'crosstotal_commonsums'), suppressTopSpace: true),
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
