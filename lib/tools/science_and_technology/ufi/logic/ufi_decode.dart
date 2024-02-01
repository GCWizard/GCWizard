// coded with one code snippet from https://raw.githubusercontent.com/ThiBsc/ufi-generator/master/src/ufinumber.cpp -> reverse_ufi
// GPL-3.0 license

part of 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi.dart';

String _vDecodeRegular(String value) {
  return trimCharactersLeft(value, '0');
}

String _vDecodeAT(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return 'U' + decoded;
}

String _vDecodeBE(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return '0' + decoded;
}

String _vDecodeBG(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 10) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeCZ(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 10) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeDE(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeDK(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeEE(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeGR(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeFI(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeHR(String value) {
  var decoded = _vDecodeRegular(value).padLeft(11, '0');
  if (decoded.length > 11) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeHU(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeIT(String value) {
  var decoded = _vDecodeRegular(value).padLeft(11, '0');
  if (decoded.length > 11) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeLI(String value) {
  var decoded = _vDecodeRegular(value).padLeft(5, '0');
  if (decoded.length > 5) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeLT(String value) {
  var decoded = _vDecodeRegular(value);
  if (decoded.length <= 9) {
    decoded = decoded.padLeft(9, '0');
  } else if (decoded.length <= 12) {
    decoded = decoded.padLeft(12, '0');
  } else {
    throw Exception();
  }

  return decoded;
}

String _vDecodeLU(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeLV(String value) {
  var decoded = _vDecodeRegular(value).padLeft(11, '0');
  if (decoded.length > 11) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeMT(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeNL(String value) {
  var decoded = _vDecodeRegular(value).padLeft(11, '0');
  if (decoded.length > 11) {
    throw Exception();
  }

  return decoded.substring(0, 9) + 'B' + decoded.substring(9);
}

String _vDecodeNO(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return decoded;
}

String _vDecodePL(String value) {
  var decoded = _vDecodeRegular(value).padLeft(10, '0');
  if (decoded.length > 10) {
    throw Exception();
  }

  return decoded;
}

String _vDecodePT(String value) {
  var decoded = _vDecodeRegular(value).padLeft(9, '0');
  if (decoded.length > 9) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeRO(String value) {
  var decoded = _vDecodeRegular(value).padLeft(2, '0');
  if (decoded.length > 10) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeSE(String value) {
  var decoded = _vDecodeRegular(value).padLeft(12, '0');
  if (decoded.length > 12) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeSI(String value) {
  var decoded = _vDecodeRegular(value).padLeft(8, '0');
  if (decoded.length > 8) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeSK(String value) {
  var decoded = _vDecodeRegular(value).padLeft(10, '0');
  if (decoded.length > 10) {
    throw Exception();
  }

  return decoded;
}

String _vDecodeGB(String value) {
  BigInt d = BigInt.parse(value) - BigInt.two.pow(40);
  if (d > BigInt.zero) {
    var dStr = d.toString();
    if (dStr.length <= 9) {
      return dStr.padLeft(9, '0');
    }
    if (dStr.length <= 12) {
      return dStr.padLeft(12, '0');
    } else {
      throw Exception();
    }
  } else {
    var str = value;
    if (str.length < 3) {
      throw Exception();
    } else if (str.length == 3) {
      str = '0' + str;
    }

    var d = str.substring(str.length - 3);

    var l = int.parse(str.substring(0, str.length - 3));
    if (l > (26 * 25 + 25)) {
      throw Exception();
    }

    var l2 = l % 26;
    var l1 = l ~/ 26;

    return _alphabetValueCharAt(l1) + _alphabetValueCharAt(l2) + d;
  }
}

String _vDecodeCY(String value) {
  if (value.length < 8) {
    throw Exception();
  }

  var d = value.substring(value.length - 8);
  var l = value.substring(0, value.length - 8);
  if (l.isEmpty) {
    l = '0';
  }

  return d + _alphabetValueCharAt(int.parse(l));
}

String _vDecodeES(String value) {
  if (value.length < 7) {
    throw Exception();
  }

  var d = value.substring(value.length - 7);

  var cStr = value.substring(0, value.length - 7);
  if (cStr.isEmpty) {
    cStr = '0';
  }
  var c = int.parse(cStr);
  if (c > (36 * 35 + 35)) {
    throw Exception();
  }

  var c2 = c % 36;
  var c1 = c ~/ 36;

  return _alphaNumValueCharAt(c1) + _alphaNumValueCharAt(c2) + d;
}

String _vDecodeFR(String value) {
  if (value.length < 9) {
    throw Exception();
  }

  var d = value.substring(value.length - 9);

  var cStr = value.substring(0, value.length - 9);
  if (cStr.isEmpty) {
    cStr = '0';
  }
  var c = int.parse(cStr);
  if (c > (36 * 35 + 35)) {
    throw Exception();
  }

  var c2 = c % 36;
  var c1 = c ~/ 36;

  return _alphaNumValueCharAt(c1) + _alphaNumValueCharAt(c2) + d;
}

String _vDecodeIE(String value) {
  if (value.length > 9) {
    var numerical = BigInt.parse(value) - BigInt.two.pow(33);
    var numStr = numerical.toString();

    var d = numStr.substring(numStr.length - 7);

    var cStr = numStr.substring(0, numStr.length - 7);
    if (cStr.isEmpty) {
      cStr = '0';
    }

    var c = int.parse(cStr);
    if (c > (26 * 25 + 25)) {
      throw Exception();
    }

    var c1 = c % 26; // in all other cases it's 26 * c_2_ + c_1_; only exception is here! where it is 26 * c_1_ + c_2_
    var c2 = c ~/ 26;

    return d + _alphabetValueCharAt(c1) + (c2 > 0 ? _alphabetValueCharAt(c2) : '');
  } else {
    if (value.length < 6) {
      throw Exception();
    }

    var d = value.substring(value.length - 6);

    var cStr = value.substring(0, value.length - 6);
    if (cStr.isEmpty) {
      cStr = '0';
    }
    var c = int.parse(cStr);
    if (c > (26 * 27 + 25)) {
      throw Exception();
    }

    // Brute force the possibility to find c1 and c2
    int c1 = -1, c2 = -1, i = 0, j = 0;
    while (c1 == -1 && i < 28) {
      while (c2 == -1 && j < 26) {
        if ((26 * i + j) == c) {
          c1 = i;
          c2 = j;
        }
        j++;
      }
      j = 0;
      i++;
    }

    String c1Str;
    switch (c1) {
      case 26:
        c1Str = '+';
        break;
      case 27:
        c1Str = '*';
        break;
      default:
        c1Str = _alphabetValueCharAt(c1);
        break;
    }

    return d.substring(0, 1) + c1Str + d.substring(1) + _alphabetValueCharAt(c2);
  }
}

String _vDecodeIS(String value) {
  return convertBase(value, 10, 36, alphabet: _ALPHANUM);
}

String _vDecodeCompany(String value) {
  return value;
}
