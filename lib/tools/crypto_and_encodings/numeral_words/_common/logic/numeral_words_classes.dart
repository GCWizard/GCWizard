part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

class NumeralWordsDecodeOutput {
  final String number;
  final String numWord;
  final String language;

  NumeralWordsDecodeOutput(this.number, this.numWord, this.language);
}

class NumeralWordsOutput {
  final bool state;
  final String output;
  final String? language;

  NumeralWordsOutput(this.state, this.output, this.language);
}

class OutputConvertBase {
  final String numbersystem;
  final String nameOfNumberSystem;
  final String error;

  OutputConvertBase({required this.numbersystem, required this.nameOfNumberSystem, required this.error});
}

class OutputConvertToNumber extends OutputConvertBase {
  final int number;

  OutputConvertToNumber(
      {required this.number, required super.numbersystem, required String title, required super.error})
      : super(nameOfNumberSystem: title);
}

class OutputConvertToNumeralWord extends OutputConvertBase {
  final String numeralWord;

  OutputConvertToNumeralWord(
      {required this.numeralWord,
      required String targetNumberSystem,
      required String title,
      required String errorMessage})
      : super(numbersystem: targetNumberSystem, nameOfNumberSystem: title, error: errorMessage);
}
