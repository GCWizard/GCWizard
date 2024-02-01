import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

const int MAX_INT = 9007199254740992;
const int MIN_INT = -9007199254740991;

const double MAX_DOUBLE = 9007199254740992.0;
const double MIN_DOUBLE = -9007199254740991.0;

const double practical_epsilon = 0.5e-15;
const double theoretical_epsilon = double.minPositive;
const double doubleTolerance = 1.0e-9;
final NumberFormat doubleFormat = NumberFormat('0.0###');

IntegerText get defaultIntegerText => IntegerText('', 0);
IntegerListText get defaultIntegerListText => IntegerListText('', []);
DoubleText get defaultDoubleText => DoubleText('', 0.0);

enum CryptMode { encrypt, decrypt }

const UNKNOWN_ELEMENT = '<?>';

final RegExp REGEXP_SPLIT_STRINGLIST = RegExp(r'[\s,]+');

const double LOW_LOCATION_ACCURACY = 20.0;

const String BASE_URL = 'https://gcwizard.net';
