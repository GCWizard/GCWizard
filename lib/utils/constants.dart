import 'dart:math';

import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

const int MAX_INT = 9007199254740992;
const int MIN_INT = -9007199254740991;

const double MAX_DOUBLE = 9007199254740992.0;
const double MIN_DOUBLE = -9007199254740991.0;

/// from dart_numerics: The number of binary digits used to represent the binary number for a double
/// precision floating point value. i.e. there are this many digits used
/// to represent the actual number, where in a number as:
/// 0.134556 * 10^5 the digits are 0.134556 and the exponent is 5.
const int _doubleWidth = 53;

/// from dart_numerics: According to the definition of Prof. Demmel and used in LAPACK and Scilab.
final double _doublePrecision = pow(2, -_doubleWidth) as double;
double practical_epsilon = 2 * _doublePrecision;
const double theoretical_epsilon = double.minPositive;
const double doubleTolerance = 1.0e-9;
final NumberFormat doubleFormat = NumberFormat('0.0###');

IntegerText get defaultIntegerText => IntegerText('', 0);
IntegerListText get defaultIntegerListText => IntegerListText('', []);
DoubleText get defaultDoubleText => DoubleText('', 0.0);

enum CryptMode { encrypt, decrypt }

const UNKNOWN_ELEMENT = '\u25a1';

final RegExp REGEXP_SPLIT_STRINGLIST = RegExp(r'[\s,]+');

const double LOW_LOCATION_ACCURACY = 20.0;

const String BASE_URL = 'https://gcwizard.net';
