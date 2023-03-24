import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

const double practical_epsilon = 0.5e-15;
const double theoretical_epsilon = double.minPositive;
const double doubleTolerance = 1.0e-9;
final NumberFormat doubleFormat = NumberFormat('0.0###');

final defaultIntegerText = IntegerText('', 0);
final defaultIntegerListText = IntegerListText('', []);
final defaultDoubleText = DoubleText('', 0.0);

enum CryptMode { encrypt, decrypt }

const UNKNOWN_ELEMENT = '<?>';

final RegExp REGEXP_SPLIT_STRINGLIST = RegExp(r'[\s,]+');

const double LOW_LOCATION_ACCURACY = 20.0;
