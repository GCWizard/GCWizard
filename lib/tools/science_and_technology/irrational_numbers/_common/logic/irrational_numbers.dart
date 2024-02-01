const ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL = 'irrationalnumbers_error_indextoosmall';
const ERROR_IRRATIONALNUMBERS_INDEXTOOBIG = 'irrationalnumbers_error_indextoobig';

class IrrationalNumber {
  final String integerPart;
  final String decimalPart;
  final String symbol;

  const IrrationalNumber({required this.symbol, required this.integerPart, required this.decimalPart});
}

class IrrationalNumberCalculator {
  final IrrationalNumber irrationalNumber;

  IrrationalNumberCalculator({required this.irrationalNumber});

  String decimalAt(int index) {
    if (index <= 0) throw const FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL);
    if (index > irrationalNumber.decimalPart.length) throw const FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOBIG);

    return irrationalNumber.decimalPart[index - 1];
  }

  String decimalRange(int start, int length) {
    if (length == 0) return '';

    if (start <= 0 || (start + length) < 0) {
      throw const FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL);
    }
    if ((start + length) > irrationalNumber.decimalPart.length) {
      throw const FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOBIG);
    }

    if (length < 0) {
      length *= -1;
      start = start - length + 1;
    }

    return irrationalNumber.decimalPart.substring(start - 1, start + length - 1);
  }

  List<IrrationalNumberDecimalOccurence> decimalOccurences(String input) {
    if (input.isEmpty) return [];

    if (!input.contains(RegExp(r'[\d]'))) throw Exception('irrationalnumbers_error_nonumbers');

    var _input = input.toUpperCase().replaceAll(RegExp(r'[A-Z*+]'), '');

    var out = <IrrationalNumberDecimalOccurence>[];
    RegExp(_input).allMatches(irrationalNumber.decimalPart).map((RegExpMatch match) {
      out.add(IrrationalNumberDecimalOccurence(value: match.group(0)!, start: match.start + 1, end: match.end));
    }).toList();

    return out;
  }
}

class IrrationalNumberDecimalOccurence {
  final String value;
  final int start;
  final int end;

  const IrrationalNumberDecimalOccurence({required this.value, required this.start, required this.end});
}
