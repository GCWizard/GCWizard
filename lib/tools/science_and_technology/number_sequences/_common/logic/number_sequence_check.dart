part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

int numberSequencesCheckNumber(NumberSequencesMode sequence, BigInt? checkNumber, int maxIndex) {
  if (checkNumber == null) {
    return -1;
  } else if (numberSequencesGetFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex, checkMode: true).positionSequence == -1) {
    return -1;
  } else if (numberSequencesGetFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex, checkMode: true).positionDigits == 1) {
    return numberSequencesGetFirstPositionOfSequence(sequence, checkNumber.toString(), maxIndex, checkMode: true).positionSequence;
  } else {
    return -1;
  }
}


