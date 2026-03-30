part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

PositionOfSequenceOutput numberSequencesGetFirstPositionOfSequence(
    NumberSequencesMode sequence, String? check, int maxIndex, {bool checkMode = false}) {

  if (check == null || check.isEmpty) {
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  RegExp expr = RegExp(r'(' + check + ')');

  if (checkMode) {
    expr = RegExp(r'(^' + check + '\$)');
  }

  return NUMBERSEQUENCES[sequence]!.sequence.getFirstPositionOfSequence(check, maxIndex, expr);
}