part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

// https://www.bindb.com/bin-database
// https://www.bindb.com/identify-prepaid-cards
// https://www.bindb.com/card-schemes
// https://kreditkarte.net/ratgeber/kreditkartennummer/

// https://www.vccgenerator.org/de/credit-card-validator-result/

// http://www.pruefziffernberechnung.de/K/Kreditkarten.shtml

const Map<String, String> CHECKDIGITS_CREDITCARD_MMI = {
  '0': 'checkdigits_creditcard_major_industry_identifier_0',
  '1': 'checkdigits_creditcard_major_industry_identifier_1',
  '2': 'checkdigits_creditcard_major_industry_identifier_2',
  '3': 'checkdigits_creditcard_major_industry_identifier_3',
  '4': 'checkdigits_creditcard_major_industry_identifier_4',
  '5': 'checkdigits_creditcard_major_industry_identifier_5',
  '6': 'checkdigits_creditcard_major_industry_identifier_6',
  '7': 'checkdigits_creditcard_major_industry_identifier_7',
  '8': 'checkdigits_creditcard_major_industry_identifier_8',
  '9': 'checkdigits_creditcard_major_industry_identifier_9',
};

const Map<String, String> CHECKDIGITS_CREDITCARD_PREFIX = {
  '22': 'MasterCard, MIR, PayPak',
  '23': 'MasterCard',
  '24': 'MasterCard',
  '25': 'MasterCard',
  '26': 'MasterCard',
  '27': 'MasterCard',
  '30': 'Diners Club, Japan Credit Bureau, etc.',
  '31': 'Japan Credit Bureau',
  '33': 'Japan Credit Bureau',
  '34': 'American Express',
  '35': 'Japan Credit Bureau',
  '36': 'Diners Club',
  '37': 'American Express',
  '38': 'Diners Club',
  '40': 'Visa',
  '41': 'Visa',
  '42': 'Visa',
  '43': 'Visa',
  '44': 'Visa',
  '45': 'Visa',
  '46': 'Visa',
  '47': 'Visa',
  '48': 'Visa',
  '49': 'Visa',
  '50': 'MasterCard Maestro, Verve, EBT, Dankort, Meeza',
  '51': 'MasterCard',
  '52': 'MasterCard',
  '53': 'MasterCard',
  '54': 'MasterCard',
  '55': 'MasterCard',
  '56': 'EFTPOS',
  '57': 'EFTPOS',
  '60': 'Discover Cards, RuPay, Cabal, Hipercardetc.',
  '61': 'Merchandising-Cards (International)',
  '62': 'China Union Pay',
  '63': 'ComproCard',
  '64': 'Merchandising-Cards (International)',
  '65': 'RuPay, BC Card, Verve etc.',
  '66': 'Merchandising-Cards (International)',
  '67': 'Merchandising-Cards (International)',
  '68': 'Merchandising-Cards (International)',
  '69': 'Merchandising-Cards (International)',
  '81': 'China Union Pay',
  '90': 'Arca, etc.',
  '91': 'BelCart, etc.',
  '94': 'BC Card, Elcart, etc.',
  '97': 'Troy, ICA, etc.',
  '98': 'DinaCard, NSMEP, etc.',
};

const Map<int, List<Object>> CHECKDIGITS_CREDITCARD_CARDSCHEMES = {
  //https://www.bindb.com/card-schemes
  220000: [220499, 'MIR'],
  220500: [220599, 'PayPak'],
  222100: [272099, 'MasterCard'],
  300000: [309599, 'Diners Club'],
  309500: [309599, 'Diners Club'],
  308800: [310299, 'Japan Credit Bureau'],
  311200: [312099, 'Japan Credit Bureau'],
  315800: [315999, 'Japan Credit Bureau'],
  333700: [334999, 'Japan Credit Bureau'],
  340000: [349999, 'American Express'],
  352800: [358999, 'Japan Credit Bureau'],
  360000: [369999, 'Diners Club'],
  370000: [379999, 'American Express'],
  380000: [399999, 'Diners Club'],
  400000: [499999, 'Visa'],
  500000: [509999, 'MasterCard'],
  501900: [501999, 'MasterCard Dankort'],
  506099: [506198, 'MasterCard Verve'],
  507600: [507699, 'MasterCard EBT'],
  507800: [507899, 'MasterCard Meeza'],
  510000: [559999, 'MasterCard'],
  560200: [560299, 'Electronic funds transfer at point of sale'],
  579900: [579999, 'MasterCard'],
  601100: [601103, 'Discover Cards'],
  606000: [608000, 'Rupay'],
  601105: [601109, 'Discover Cards'],
  601120: [601149, 'Discover Cards'],
  601174: [601174, 'Discover Cards'],
  601177: [601179, 'Discover Cards'],
  601186: [601199, 'Discover Cards'],
  604200: [604299, 'Cabal'],
  606282: [606282, 'Hipercart'],
  622126: [622925, 'China Union Pay'],
  624000: [626999, 'China Union Pay'],
  628200: [628899, 'China Union Pay'],
  630000: [639999, 'MasterCard Maestro'],
  639200: [639299, 'ComproCard'],
  644000: [659999, 'Discover Cards'],
  650002: [650027, 'Verve'],
  652100: [654399, 'RuPay'],
  655600: [655699, 'BC Card'],
  670000: [679999, 'MasterCard Maestro'],
  810000: [817199, 'China Union Pay'],
  905100: [905199, 'Arca'],
  911200: [911299, 'BelCart'],
  941700: [941799, 'Elcart'],
  975200: [975299, 'ICA'],
  979200: [979289, 'Troy'],
  980400: [980499, 'NSMEP'],
  989100: [989199, 'DinaCard'],
};

class BINIINDetail {
  final String number_length;
  final String scheme;
  final String type;
  final String brand;
  final String prepaid;
  final String country_numeric;
  final String country_alpha2;
  final String country_name;
  final String bank_name;
  final String bank_url;
  final String bank_phone;
  final String bank_city;

  BINIINDetail(this.number_length, this.scheme, this.type, this.brand, this.prepaid, this.country_numeric,
      this.country_alpha2, this.country_name, this.bank_name, this.bank_url, this.bank_phone, this.bank_city);
}

enum OPENBINIINDB_STATUS { OK, ERROR }

class OpenBINIINDBOutput {
  final OPENBINIINDB_STATUS status;
  final String httpCode;
  final String httpMessage;
  final BINIINDetail BINIINData;

  OpenBINIINDBOutput({
    required this.status,
    required this.httpCode,
    required this.httpMessage,
    required this.BINIINData,
  });
}

class OpenBINIINDBgetJobData {
  final String biniin;

  OpenBINIINDBgetJobData({required this.biniin});
}

final EMPTY_OPENBINIINDB_TASK_OUTPUT = OpenBINIINDBOutput(
  status: OPENBINIINDB_STATUS.ERROR,
  httpCode: '',
  httpMessage: '',
  BINIINData: BINIINDetail(
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ),
);

Future<OpenBINIINDBOutput> OpenBINIINDBrunTaskAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! OpenBINIINDBgetJobData) {
    return Future.value(EMPTY_OPENBINIINDB_TASK_OUTPUT);
  }
  var OpenBINIINDBJob = jobData!.parameters as OpenBINIINDBgetJobData;

  OpenBINIINDBOutput output =
      await _OpenBINIINDBgetTextAsync(OpenBINIINDBJob.biniin, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<OpenBINIINDBOutput> _OpenBINIINDBgetTextAsync(String biniin, {SendPort? sendAsyncPort}) async {
  String httpMessage = '';
  int httpCode = 0;
  BINIINDetail BINIINData = BINIINDetail(
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  );
  OPENBINIINDB_STATUS status = OPENBINIINDB_STATUS.ERROR;
  Uri address = Uri.parse('https://lookup.binlist.net/' + biniin.substring(0, 6));

  try {
    final http.Response response = await http.post(
      address,
      headers: <String, String>{
        'Accept-Version': '3',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    httpCode = response.statusCode;
    httpMessage = response.reasonPhrase ?? '';
    if (httpCode == 200) {
      var BINIINDataJSON = jsonDecode(response.body);
      status = OPENBINIINDB_STATUS.OK;
      BINIINData = BINIINDetail(
        BINIINDataJSON['number'].toString() != 'null' ? BINIINDataJSON['number']['length'].toString() : 'null',
        BINIINDataJSON['scheme'].toString(),
        BINIINDataJSON['type'].toString(),
        BINIINDataJSON['brand'].toString(),
        BINIINDataJSON['prepaid'].toString(),
        BINIINDataJSON['country'].toString() != 'null' ? BINIINDataJSON['country']['numeric'].toString() : 'null',
        BINIINDataJSON['country'].toString() != 'null' ? BINIINDataJSON['country']['alpha2'].toString() : 'null',
        BINIINDataJSON['country'].toString() != 'null' ? BINIINDataJSON['country']['name'].toString() : 'null',
        BINIINDataJSON['bank'].toString() != 'null' ? BINIINDataJSON['bank']['name'].toString() : 'null',
        BINIINDataJSON['bank'].toString() != 'null' ? BINIINDataJSON['bank']['url'].toString() : 'null',
        BINIINDataJSON['bank'].toString() != 'null' ? BINIINDataJSON['bank']['phone'].toString() : 'null',
        BINIINDataJSON['bank'].toString() != 'null' ? BINIINDataJSON['bank']['city'].toString() : 'null',
      );
    } else {
      status = OPENBINIINDB_STATUS.ERROR;
    }
  } catch (exception) {
    //SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.178.93, port = 57582
    httpCode = 503;
    httpMessage = exception.toString();
    status = OPENBINIINDB_STATUS.ERROR;
  } // end catch exception
  return OpenBINIINDBOutput(
    status: status,
    httpCode: httpCode.toString(),
    httpMessage: httpMessage,
    BINIINData: BINIINData,
  );
}

CheckDigitOutput _CheckCreditCardNumber(String number) {
  if (int.tryParse(number) == null) {
    return CheckDigitOutput(false, 'checkdigits_invalid_format', ['']);
  }

  if (12 <= number.length && number.length <= 19) {
    if (_checkNumber(number, _checkCreditCard)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(
          false,
          _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateCreditCardNumber),
          _CalculateGlitch(number, _checkCreditCard));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateCreditCardNumber(String number) {
  if (11 <= number.length && number.length <= 18 ) {
    return number + _calculateCreditCardCheckDigit(number);
  }
  return 'checkdigits_invalid_length';
}

List<String> _CalculateCreditCardDigits(String number) {
  if (12 <= number.length && number.length <= 19 ) {
    return _CalculateDigits(number, _checkCreditCard);
  } else {
    return ['checkdigits_invalid_length'];
  }
}

bool _checkCreditCard(String number) {
  return (number[number.length - 1] == _calculateCreditCardCheckDigit(number.substring(0, number.length - 1)));
}

String _calculateCreditCardCheckDigit(String number) {
  int sum = 0;
  int product = 0;
  bool two = true;

  for (int i = number.length - 1; i >= 0; i--) {
    if (two) {
      product = 2 * int.parse(number[i]);
    }  else {
      product = 1 * int.parse(number[i]);
    }
    sum = sum + product ~/ 10 + product % 10;
    two = !two;
  }

  if (sum >= 100) {
    sum = sum % 100;
  }
  sum = sum % 10;
  sum = 10 - sum;

  if (sum == 10) {
    sum = 0;
  }

  return sum.toString();
}

