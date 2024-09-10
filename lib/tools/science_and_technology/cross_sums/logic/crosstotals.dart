import 'package:diacritic/diacritic.dart';

List<int>? _validateAndSanitizeList(List<int> list) {
  if (list.isEmpty) return null;

  return list;
}

bool _containsNegativeValue(List<int> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] < 0) return true;
  }

  return false;
}

BigInt sum(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return list.map((e) => BigInt.from(e)).reduce((a, b) => a + b);
}

BigInt product(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return list.map((e) => BigInt.from(e)).reduce((a, b) => a * b);
}

List<BigInt> _intListToIntDigitList(List<BigInt> list) {
  return list
      .map((element) => element.toString())
      .toList()
      .join()
      .split('')
      .map((element) => BigInt.tryParse(element) ?? BigInt.zero)
      .toList();
}

List<BigInt> _numberToIntDigitList(BigInt number) {
  return number.toString().split('').map((element) => BigInt.tryParse(element) ?? BigInt.zero).toList();
}

BigInt _crossSumNumber(BigInt number) {
  var sign = number < BigInt.zero ? BigInt.from(-1) : BigInt.one;
  return sign * _numberToIntDigitList(number.abs()).reduce((a, b) => a + b);
}

BigInt _crossProductNumber(BigInt number) {
  var sign = number < BigInt.zero ? BigInt.from(-1) : BigInt.one;
  return sign * _numberToIntDigitList(number.abs()).reduce((a, b) => a * b);
}

BigInt _crossSumNumberIterated(BigInt number) {
  while (number >= BigInt.from(10) || number <= BigInt.from(-10)) {
    number = _crossSumNumber(number);
  }
  return number;
}

BigInt _crossProductNumberIterated(BigInt number) {
  while (number >= BigInt.from(10)) {
    number = _crossProductNumber(number);
  }
  return number;
}

BigInt sumCrossSum(List<int> list) {
  BigInt s = sum(list);
  return _crossSumNumber(s);
}

BigInt productCrossSum(List<int> list) {
  BigInt p = product(list);
  return _crossSumNumber(p);
}

BigInt sumCrossSumIterated(List<int> list) {
  BigInt s = sum(list);
  return _crossSumNumberIterated(s);
}

BigInt? sumCrossSumAlternatedBackward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  BigInt s = sum(list);
  return _crossSumAlternatedBackward([s]);
}

BigInt? sumCrossSumAlternatedForward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  BigInt s = sum(list);
  return _crossSumAlternatedForward([s]);
}

BigInt productCrossSumIterated(List<int> list) {
  BigInt p = product(list);
  return _crossSumNumberIterated(p);
}

BigInt? productCrossSumAlternatedBackward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  BigInt p = product(list);
  return _crossSumAlternatedBackward([p]);
}

BigInt? productCrossSumAlternatedForward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  BigInt p = product(list);
  return _crossSumAlternatedForward([p]);
}

BigInt crossSumIterated(List<int> list) {
  BigInt c = crossSum(list);
  return _crossSumNumberIterated(c);
}

BigInt crossProductIterated(List<int> list) {
  BigInt c = crossProduct(list);
  return _crossProductNumberIterated(c);
}

BigInt sumAlternatedForward(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  BigInt i = BigInt.one;
  return list.map((e) => BigInt.from(e)).reduce((a, b) {
    i *= BigInt.from(-1);
    return a + i * b;
  });
}

BigInt sumAlternatedBackward(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  BigInt i = BigInt.one;
  return list.reversed.map((e) => BigInt.from(e)).reduce((a, b) {
    i *= BigInt.from(-1);
    return a + i * b;
  });
}

BigInt productAlternated(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  BigInt i = BigInt.one;
  return list.reversed.map((e) => BigInt.from(e)).reduce((a, b) {
    i *= BigInt.from(-1);
    return a * i * b;
  });
}

BigInt _crossSumAlternatedForward(List<BigInt> list) {
  BigInt i = BigInt.one;
  return _intListToIntDigitList(list).reduce((a, b) {
    i *= BigInt.from(-1);
    return a + i * b;
  });
}

BigInt? crossSumAlternatedForward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return _crossSumAlternatedForward(list.map((e) => BigInt.from(e)).toList());
}

BigInt _crossSumAlternatedBackward(List<BigInt> list) {
  BigInt i = BigInt.one;
  return _intListToIntDigitList(list).reversed.reduce((a, b) {
    i *= BigInt.from(-1);
    return a + i * b;
  });
}

BigInt? crossSumAlternatedBackward(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return _crossSumAlternatedBackward(list.map((e) => BigInt.from(e)).toList());
}

BigInt? crossProductAlternated(List<int> list) {
  if (_containsNegativeValue(list)) return null;

  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  BigInt i = BigInt.one;
  return _intListToIntDigitList(list.map((e) => BigInt.from(e)).toList()).reversed.reduce((a, b) {
    i *= BigInt.from(-1);
    return a * i * b;
  });
}

BigInt crossSum(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return list.map((element) {
    return _crossSumNumber(BigInt.from(element));
  }).reduce((a, b) => a + b);
}

BigInt crossProduct(List<int> list) {
  if (_validateAndSanitizeList(list) == null) return BigInt.zero;

  return list.map((element) {
    return _crossProductNumber(BigInt.from(element));
  }).reduce((a, b) => a * b);
}

int countElements(List<int> list) {
  return list.length;
}

int countDistinctCharacters(List<int> list) {
  return list.toSet().length;
}

int countLetters(String text) {
  return removeDiacritics(text).toUpperCase().replaceAll(RegExp('[^A-Zß\u1e9e]'), '').length;
}

int countDigits(String text) {
  return text.replaceAll(RegExp(r'\D'), '').length;
}