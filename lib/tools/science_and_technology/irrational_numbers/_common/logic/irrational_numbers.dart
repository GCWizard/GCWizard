final ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL = 'irrationalnumbers_error_indextoosmall';
final ERROR_IRRATIONALNUMBERS_INDEXTOOBIG = 'irrationalnumbers_error_indextoobig';

class IrrationalNumber {
  final String integerPart;
  final String decimalPart;
  final String symbol;

  IrrationalNumber({this.symbol, this.integerPart, this.decimalPart});
}

class IrrationalNumberCalculator {
  final IrrationalNumber irrationalNumber;

  IrrationalNumberCalculator({this.irrationalNumber});

  String decimalAt(int index) {
    if (index == null || index <= 0) throw FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL);
    if (index > irrationalNumber.decimalPart.length) throw FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOBIG);

    return irrationalNumber.decimalPart[index - 1];
  }

  String decimalRange(int start, int length) {
    if (length == null || length == 0) return '';

    if (start == null || start <= 0 || (start + length) < 0)
      throw FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL);
    if ((start + length) > irrationalNumber.decimalPart.length)
      throw FormatException(ERROR_IRRATIONALNUMBERS_INDEXTOOBIG);

    if (length < 0) {
      length *= -1;
      start = start - length + 1;
    }

    return irrationalNumber.decimalPart.substring(start - 1, start + length - 1);
  }

  List<IrrationalNumberDecimalOccurence> decimalOccurences(String input) {
    if (input == null || input.length == 0) return [];

    if (!input.contains(RegExp(r'[0-9]'))) throw Exception('irrationalnumbers_error_nonumbers');

    var _input = input.replaceAll(RegExp(r'[^0-9]'), '.');

    var out = <IrrationalNumberDecimalOccurence>[];
    RegExp(_input).allMatches(irrationalNumber.decimalPart).map((RegExpMatch match) {
      out.add(IrrationalNumberDecimalOccurence(value: match.group(0), start: match.start + 1, end: match.end));
    }).toList();

    return out;
  }
}

class IrrationalNumberDecimalOccurence {
  final String value;
  final int start;
  final int end;

  const IrrationalNumberDecimalOccurence({this.value, this.start, this.end});
}
