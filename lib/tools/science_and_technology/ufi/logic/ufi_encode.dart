part of 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi.dart';

BigInt _vEncodeRegular(String vatNumber) {
  return BigInt.parse(vatNumber.replaceAll(RegExp(r'[^\d]'), ''));
}

BigInt _vEncodeCY(String vatNumber) {
  var d = BigInt.parse(vatNumber.replaceAll(RegExp(r'[^\d]'), ''));
  var l = _alphabetValueIndexOf(vatNumber[vatNumber.length - 1]);

  return BigInt.from(l) * BigInt.from(10).pow(8) + d;
}

BigInt _vEncodeES(String vatNumber) {
  var d = BigInt.parse(vatNumber.substring(1, vatNumber.length - 1));
  var c1 = _alphaNumValueIndexOf(vatNumber[0]);
  var c2 = _alphaNumValueIndexOf(vatNumber[vatNumber.length - 1]);

  return BigInt.from(36 * c1 + c2) * BigInt.from(10).pow(7) + d;
}

BigInt _vEncodeFR(String vatNumber) {
  var d = BigInt.parse(vatNumber.substring(2));
  var c1 = _alphaNumValueIndexOf(vatNumber[0]);
  var c2 = _alphaNumValueIndexOf(vatNumber[1]);

  return BigInt.from(36 * c1 + c2) * BigInt.from(10).pow(9) + d;
}

BigInt _vEncodeGB(String vatNumber) {
  RegExp regExp1 = RegExp(r'[0-9]{9}([0-9]{3})?');
  RegExp regExp2 = RegExp(r'[A-Z]{2}[0-9]{3}');

  if (regExp1.hasMatch(vatNumber)) {
    return BigInt.two.pow(40) + BigInt.parse(vatNumber);
  } else if (regExp2.hasMatch(vatNumber)) {
    var d = BigInt.parse(vatNumber.substring(2));
    var l1 = _alphabetValueIndexOf(vatNumber[0]);
    var l2 = _alphabetValueIndexOf(vatNumber[1]);

    return BigInt.from(26 * l1 + l2) * BigInt.from(10).pow(3) + d;
  }

  throw Exception('Invalid VAT Number for GB/XN');
}

BigInt _vEncodeIE(String vatNumber) {
  RegExp regExp1 = RegExp(r'[0-9][A-Z*+][0-9]{5}[A-Z]');
  RegExp regExp2 = RegExp(r'[0-9]{7}([A-Z]W?|[A-Z]{2})');

  if (regExp1.hasMatch(vatNumber)) {
    var d = BigInt.parse(vatNumber.replaceAll(RegExp(r'[^\d]'), ''));
    var c = vatNumber.replaceAll(RegExp(r'[\d]'), '');

    int c1;
    switch (c[0]) {
      case '+':
        c1 = 26;
        break;
      case '*':
        c1 = 27;
        break;
      default:
        c1 = _alphabetValueIndexOf(c[0]);
    }

    int c2 = _alphabetValueIndexOf(c[1]);

    return BigInt.from(26 * c1 + c2) * BigInt.from(10).pow(6) + d;
  } else if (regExp2.hasMatch(vatNumber)) {
    var d = BigInt.parse(vatNumber.replaceAll(RegExp(r'[^\d]'), ''));
    var c = vatNumber.replaceAll(RegExp(r'[\d]'), '');

    var c1 = _alphabetValueIndexOf(c[0]);
    var c2 = c.length == 1 ? 0 : _alphabetValueIndexOf(c[1]);

    return BigInt.two.pow(33) + (BigInt.from(26 * c2 + c1) * BigInt.from(10).pow(7) + d);
  }

  throw Exception('Invalid VAT Number for IE');
}

BigInt _vEncodeIS(String vatNumber) {
  BigInt V = BigInt.zero;
  const vatLength = 6;
  for (int i = 0; i < vatLength; i++) {
    V += BigInt.from(_alphaNumValueIndexOf(vatNumber[vatLength - 1 - i])) * BigInt.from(36).pow(i);
  }

  return V;
}

BigInt _vEncodeCompany(String companyCode) {
  return BigInt.parse(companyCode);
}
