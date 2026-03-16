
const int _base = 36;
const int _tMin = 1;
const int _tMax = 26;
const int _skew = 38;
const int _damp = 700;
const int _initialBias = 72;
const int _initialN = 128;
const int _delimiter = 0x2D; // '-'

({String output, String errorText}) encodeDomainPunycode(String domain) {
  var result = domain.split('.')
      .map((label) {
    if (_needsPunycode(label)) {
      var _ = encodePunycode(label);
      return (output: 'xn--' + _.output, errorText: _.errorText);
    } else {
      return (output: label, errorText: '');
    }
  });

  var errors = result.where((result) => result.errorText != '');
  if (errors.isNotEmpty) {
    return (output: '', errorText: errors.first.errorText);
  }

  return (output: result.map((result) => result.output).join('.'), errorText: "");
}

({String output, String errorText}) decodeDomainPunycode(String domain) {
  var result = domain.split('.')
      .map((label) => label.toLowerCase().startsWith('xn--')
          ? decodePunycode(label.substring(4))
          : (output: label, errorText: ''));

  var errors = result.where((result) => result.errorText != '');
  if (errors.isNotEmpty) {
    return (output: '', errorText: errors.first.errorText);
  }

  return (output: result.map((result) => result.output).join('.'), errorText: "");
}

({String output, String errorText}) encodePunycode(String input) {
  // RFC 3492, Section 6.3: Encoding procedure
  final codePoints = input.runes.toList();

  final basic = <int>[];
  for (final cp in codePoints) {
    if (_isBasic(cp)) basic.add(cp);
  }

  final output = StringBuffer();
  for (final cp in basic) {
    output.writeCharCode(cp);
  }

  int b = basic.length;
  int h = b;

  if (b > 0) {
    output.writeCharCode(_delimiter);
  }

  int n = _initialN;
  int delta = 0;
  int bias = _initialBias;

  while (h < codePoints.length) {
    int m = 0x10FFFF;
    for (final cp in codePoints) {
      if (cp >= n && cp < m) {
        m = cp;
      }
    }

    if (m - n > (0x7FFFFFFF - delta) ~/ (h + 1)) {
      return (output: '', errorText: 'Overflow');
    }

    delta += (m - n) * (h + 1);
    n = m;

    for (final cp in codePoints) {
      if (cp < n) {
        delta++;
        if (delta == 0) {
          return (output: '', errorText: 'Overflow');
        }
      }

      if (cp == n) {
        int q = delta;
        for (int k = _base;; k += _base) {
          final t = _threshold(k, bias);
          if (q < t) break;
          final code = t + ((q - t) % (_base - t));
          output.writeCharCode(_encodeDigit(code));
          q = (q - t) ~/ (_base - t);
        }
        output.writeCharCode(_encodeDigit(q));
        bias = _adapt(delta, h + 1, h == b);
        delta = 0;
        h++;
      }
    }
    delta++;
    n++;
  }
  return (output: output.toString(), errorText: '');
}

({String output, String errorText}) decodePunycode(String input) {
  final output = <int>[];

  int n = _initialN;
  int i = 0;
  int bias = _initialBias;

  final lastDelim = input.lastIndexOf(String.fromCharCode(_delimiter));
  int index = 0;
  if (lastDelim != -1) {
    for (; index < lastDelim; index++) {
      final cp = input.codeUnitAt(index);
      if (!_isBasic(cp)) {
        return (output: '', errorText: 'Non-basic code point before delimiter');
      }
      output.add(cp);
    }
    index++;
  }

  while (index < input.length) {
    int oldi = i;
    int w = 1;

    for (int k = _base;; k += _base) {
      if (index >= input.length) {
        return (output: '', errorText: 'Bad input: truncated');
      }
      final digit = _decodeDigit(input.codeUnitAt(index++));
      if (digit >= _base) {
        return (output: '', errorText: 'invalid digit');
      }

      if (digit > (0x7FFFFFFF - i) ~/ w) {
        return (output: '', errorText: 'Overflow');
      }
      i += digit * w;

      final t = _threshold(k, bias);
      if (digit < t) break;
      if (w > 0x7FFFFFFF ~/ (_base - t)) {
        return (output: '', errorText: 'Overflow');
      }
      w *= (_base - t);
    }

    final outLen = output.length + 1;
    bias = _adapt(i - oldi, outLen, oldi == 0);

    if (i ~/ outLen > 0x7FFFFFFF - n) {
      return (output: '', errorText: 'Overflow');
    }
    n += i ~/ outLen;
    i %= outLen;

    output.insert(i, n);
    i++;
  }

  return (output: String.fromCharCodes(output), errorText: '');
}

bool _isBasic(int cp) => cp < 0x80;

bool _needsPunycode(String label) {
  for (final cp in label.runes) {
    if (!_isBasic(cp)) return true;
  }
  return false;
}

int _threshold(int k, int bias) {
  if (k <= bias + _tMin) return _tMin;
  if (k >= bias + _tMax) return _tMax;
  return k - bias;
}

int _adapt(int delta, int numPoints, bool firstTime) {
  delta = firstTime ? delta ~/ _damp : delta >> 1;
  delta += delta ~/ numPoints;

  int k = 0;
  while (delta > ((_base - _tMin) * _tMax) ~/ 2) {
    delta ~/= (_base - _tMin);
    k += _base;
  }
  return k + (((_base - _tMin + 1) * delta) ~/ (delta + _skew));
}

int _encodeDigit(int d) {
  // 0..25 -> 'a'..'z', 26..35 -> '0'..'9'
  if (d < 26) {
    return 0x61 + d; // 'a'
  } else {
    return 0x30 + (d - 26); // '0'
  }
}

int _decodeDigit(int cp) {
  // '0'..'9'
  if (cp >= 0x30 && cp <= 0x39) {
    return cp - 0x30 + 26;
  }
  // 'A'..'Z'
  if (cp >= 0x41 && cp <= 0x5A) {
    return cp - 0x41;
  }
  // 'a'..'z'
  if (cp >= 0x61 && cp <= 0x7A) {
    return cp - 0x61;
  }
  return _base; // invalid
}