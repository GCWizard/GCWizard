part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

double _getValueFromMathConstant(MathematicalConstant constant) {
  return double.parse(constant.value.replaceAll(' ', '').replaceAll('...', ''));
}

double _getValueFromPhysicalConstant(PhysicalConstant constant) {
  return double.parse(constant.value.replaceAll(' ', '').replaceAll('...', '')) * pow(10, constant.exponent as int);
}

Map<String, double> _GCWIZARDSCRIPT_SCIENCE_CONST = {
  'PI': pi,
  'EULER': e,
  'PHI': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_phi']!),
  'RHO': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_silverratio']!),
  'CONWAY': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_conway']!),
  'APERY': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_apery']!),
  'SQRT2': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_pythagoras']!),
  'SQRT3': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_theodorus']!),
  'SQRT5': _getValueFromMathConstant(MATHEMATICAL_CONSTANTS['mathematical_constants_sqrt5']!),

  'STEFANBOLTZMANN':
      _getValueFromPhysicalConstant(PHYSICAL_CONSTANTS['physical_constants_stefan_boltzmann']!), //5.670374419e-8,
  'BOLTZMANN': _getValueFromPhysicalConstant(PHYSICAL_CONSTANTS['physical_constants_boltzmann']!), //1.380649e-23,
};

int _sgn(Object? x) {
  if (_isNotANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  } else if (x as num == 0) {
    return 0;
  } else if (x > 0) {
    return 1;
  } else {
    return -1;
  }
}

num _mod(Object? x, Object? y) {
  num result = 0;
  if (_isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
  } else if (y == 0) {
    _handleError(_DIVISIONBYZERO);
  } else {
    result = ((x as num) % (y as num));
  }
  return result;
}

double _sqrt(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return sqrt(x as num);
}

num _sqr(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return ((x as num) * x);
}

double _exp(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return exp(x as num);
}

double _sin(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return sin(x as num);
}

double _cos(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return cos(x as num);
}

double _tan(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return tan(x as num);
}

double _asin(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return asin(x as num);
}

double _acos(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return acos(x as num);
}

double _atan(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return atan(x as num);
}

double _deg(Object? radian) {
  if (!_isANumber(radian)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (radian as num) * 180 / pi;
}

double _rad(Object? degree) {
  if (!_isANumber(degree)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (degree as num) * pi / 180;
}

int _ceil(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (x as num).ceil();
}

int _floor(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (x as num).floor();
}

double _ln(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return log(x as num);
}

double _log10(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return log(x as num) / log(10);
}

double _rnd(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }

  if (x != 0) {
    _state.randomNumber = _random.nextDouble();
    return _state.randomNumber;
  } else {
    return _state.randomNumber;
  }
}

int _fac(Object? x) {
  if (!(((x as num) - x.truncate()) == 0)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }

  int result = 1;
  for (int i = 1; i <= x.toInt(); i++) {
    result *= i;
  }
  return result;
}

num _frac(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return ((x as num) - x.truncate());
}

int _trunc(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (x as num).truncate();
}

num _abs(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return (x as num).abs();
}

num _pow(Object? x, Object? y) {
  if (!_isANumber(x) || !_isANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return pow(x as num, y as num);
}

int _csum(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  int result = 0;
  x.toString().split('').forEach((digit) {
    result += _isADigit(digit) ? int.parse(digit) : 0;
  });
  return result;
}

int _icsum(Object? x) {
  if (!_isANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  int result = _csum(x);
  while (result.toString().length > 1) {
    result = _csum(result);
  }
  return result;
}

int _ggt(Object? x, Object? y) {
  if (_isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  } else {
    int h;

    if (x as num == 0) return (y as num).toInt().abs();
    if (y as num == 0) return x.toInt().abs();

    do {
      h = (x as num).toInt() % (y as num).toInt();
      x = y;
      y = h;
    } while (y != 0);

    return x.toInt().abs();
  }
}

num _kgv(Object? x, Object? y) {
  if (_isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }

  return (((x as num) * (y as num)).abs() / _ggt(x, y));
}

int _gcd(Object? x, Object? y) {
  if (!_isANumber(x) || !_isANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  int h;

  if (x as num == 0) return (y as num).toInt().abs();
  if (y as num == 0) return x.toInt().abs();

  do {
    h = (x as num).toInt() % (y as num).toInt();
    x = y;
    y = h;
  } while (y != 0);

  return x.toInt().abs();
}

num _lcm(Object? x, Object? y) {
  if (!_isANumber(x) || !_isANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }

  return (((x as num) * (y as num)).abs() / _ggt(x, y));
}

String _convertBase(Object? value, Object? startBase, Object? destinationBase) {
  if (_isANumber(value)) {
    value = value.toString();
  }
  if (_isNotAInt(startBase) || _isNotAInt(destinationBase)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return convertBase(value as String, startBase as int, destinationBase as int);
}

int _isPrime(Object x) {
  if (_isNotAInt(x)) {
    _handleError(_INVALIDTYPECAST);
    return -1;
  }
  if (isPrime(BigInt.from(x as int))) {
    return 1;
  }
  return 0;
}

double _round(Object? x, Object? y) {
  if (_isNotANumber(x) || _isNotAInt(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return double.parse((x as double).toStringAsFixed(y as int));
}

int _isSqr(Object? x) {
  if (_isNotAInt(x)) {
    _handleError(_INVALIDTYPECAST);
    return -1;
  }
  if (_frac(sqrt(x as num)) == 0) {
    return 1;
  }
  return 0;
}

int _div(Object? x, Object? y) {
  if (_isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  if (y == 0) {
    _handleError(_DIVISIONBYZERO);
    return 0;
  }
  return ((x as num) ~/ (y as num));
}

void _divisors(Object? list, Object? number) {
  if (_isNotAList(list) || _isNotAInt(number)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    divisors(number as int).forEach((element) {
      _listAdd(list as _GCWList?, element);
    });
  }
}

void _polar(
  Object? list,
  Object? x,
  Object? y,
) {
  if (_isNotAList(list) || _isNotANumber(x) || _isNotANumber(y)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    Map<String, String> result = CartesianToPolar((x as num).toString(), (y as num).toString());
    _listAdd(list as _GCWList, double.parse(result['complex_numbers_hint_radius']!));
    _listAdd(list, double.parse(result['complex_numbers_hint_angle']!));
  }
}

void _carthesian(
  Object? list,
  Object? angle,
  Object? radius,
) {
  if (_isNotAList(list) || _isNotANumber(angle) || _isNotANumber(radius)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    Map<String, String> result = PolarToCartesian((angle as num).toString(), (radius as num).toString());
    _listAdd(list as _GCWList, double.parse(result['complex_numbers_hint_a']!));
    _listAdd(list, double.parse(result['complex_numbers_hint_b']!));
  }
}

double _sum(
  Object? list,
) {
  double result = 0.0;
  if (_isNotAList(list)) {
    _handleError(_INVALIDTYPECAST);
    return result;
  } else {
    for (int i = 0; i < (list as _GCWList).length(); i++) {
      Object element = list.getIndex(i);
      if (_isANumber(element)) result = result + (element as num);
    }
    return result;
  }
}

String _float2binary(Object number, Object? bitLength) {
  String result = '';
  if (_isNotANumber(number) || _isNotAInt(bitLength)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    if (bitLength as int == 32) {
      result = encodeIEEE754(number as double, true);
    } else if (bitLength == 64) {
      result = encodeIEEE754(number as double, false);
    } else {
      result = '';
    }
  }
  return result;
}

double _binary2float(Object? binary) {
  double result = 0.0;
  if (_isNotAString(binary)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    result = decodeIEEE754(binary as String);
  }
  return result;
}
