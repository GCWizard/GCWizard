part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

// https://de.wikipedia.org/wiki/Pr%C3%BCfziffer#:~:text=Berechnung%20der%20Pr%C3%BCfziffer%3A%201%20Von%20links%20nach%20rechts,unmittelbar%20nach%20der%20Produktbildung%20erfolgen.%20Weitere%20Artikel...%20
// https://www.activebarcode.de/codes/checkdigit/modulo10.html

// https://opengtindb.org/api.php
// https://opengtindb.org/userid.php
// https://opengtindb.org/faq.php#g

class EANDetail {
  final String name;
  final String detailName;
  final String vendor;
  final String maincat;
  final String subcat;
  final String contents;
  final String pack;
  final String description;
  final String origin;
  final String validated;

  EANDetail(this.name, this.detailName, this.vendor, this.maincat, this.subcat, this.contents, this.pack,
      this.description, this.origin, this.validated);
}

enum OPENGTINDB_STATUS { OK, ERROR }

class OpenGTINDBOutput {
  final OPENGTINDB_STATUS status;
  final String httpCode;
  final String httpMessage;
  final String eanData;

  OpenGTINDBOutput({
    required this.status,
    required this.httpCode,
    required this.httpMessage,
    required this.eanData,
  });
}

class OpenGTINDBgetJobData {
  final String ean;
  final String apikey;

  OpenGTINDBgetJobData({required this.ean, required this.apikey});
}

final EMPTY_OPENGTINDB_TASK_OUTPUT = OpenGTINDBOutput(
  status: OPENGTINDB_STATUS.ERROR,
  httpCode: '',
  httpMessage: '',
  eanData: '',
);

const OPENGTINDEB_ERRORCODES = {
  '0': 'checkdigits_ean_error_ok',
  '1': 'checkdigits_ean_error_ean_not_found',
  '2': 'checkdigits_ean_error_ean_checksum_error',
  '3': 'checkdigits_ean_error_ean_format_error',
  '4': 'checkdigits_ean_error_not_a_global-unique_ean',
  '5': 'checkdigits_ean_error_access_limit_exceeded',
  '6': 'checkdigits_ean_error_no_product_name',
  '7': 'checkdigits_ean_error_product_name_too_long',
  '8': 'checkdigits_ean_error_no_or_wrong_main_category_id',
  '9': 'checkdigits_ean_error_no_or_wrong_sub_category_id',
  '10': 'checkdigits_ean_error_illegal_data_in_vendor_field',
  '11': 'checkdigits_ean_error_illegal_data_in_description_field',
  '12': 'checkdigits_ean_error_data_already_submitted',
  '13': 'checkdigits_ean_error_queryid_missing_or_wrong',
  '14': 'checkdigits_ean_error_unknown_command',
};

const OPENGTINDB_CONTENTS = {
  1: 'laktosefrei',
  2: 'koffeeinfrei',
  4: 'diätetisches Lebensmittel',
  8: 'glutenfrei',
  16: 'fruktosefrei',
  32: 'BIO-Lebensmittel nach EU-Ökoverordnung',
  64: 'fair gehandeltes Produkt nach FAIRTRADE™-Standard',
  128: 'vegetarisch',
  256: 'vegan',
  512: 'Warnung vor Mikroplastik',
  1024: 'Warnung vor Mineralöl',
  2048: 'Warnung vor Nikotin',
};

const OPENGTINDB_PACKS = {
  1: 'die Verpackung besteht überwiegend aus Plastik',
  2: 'die Verpackung besteht überwiegend aus Verbundmaterial',
  4: 'die Verpackung besteht überwiegend aus Papier/Pappe',
  8: 'die Verpackung besteht überwiegend aus Glas/Keramik/Ton',
  16: 'die Verpackung besteht überwiegend aus Metall',
  32: 'ist unverpackt',
  64: 'die Verpackung ist komplett frei von Plastik',
  128: 'Artikel ist übertrieben stark verpackt (nie zusammen mit 32)',
  256: 'Artikel ist angemessen sparsam verpackt',
  512: 'Pfandsystem / Mehrwegverpackung',
};

Future<OpenGTINDBOutput> OpenGTINDBrunTaskAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! OpenGTINDBgetJobData) {
    return Future.value(EMPTY_OPENGTINDB_TASK_OUTPUT);
  }
  var OpenGTINDBJob = jobData!.parameters as OpenGTINDBgetJobData;

  OpenGTINDBOutput output = await _OpenGTINDBgetTextAsync(OpenGTINDBJob.ean, OpenGTINDBJob.apikey, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<OpenGTINDBOutput> _OpenGTINDBgetTextAsync(String ean, String APIKey, {SendPort? sendAsyncPort}) async {
  String eanData = '';
  String httpMessage = '';
  int httpCode = 0;
  OPENGTINDB_STATUS status = OPENGTINDB_STATUS.ERROR;
  String address = 'http://opengtindb.org/?ean=' + ean + '&cmd=query&queryid=';

  if (APIKey == '' || APIKey == 'null') {
    address = address + '400000000';
  } else {
    address = address + APIKey;
  }

  try {
    var uri = Uri.parse(address);
    http.Response response = await http.get(uri);
    httpCode = response.statusCode;
    httpMessage = response.reasonPhrase ?? '';
    if (httpCode == 200) {
      eanData = response.body;
      if (eanData.trim().startsWith('error=0')) {
        status = OPENGTINDB_STATUS.OK;
      } else {
        status = OPENGTINDB_STATUS.ERROR;
        eanData = eanData.replaceAll('error=', '').replaceAll('\n', '').replaceAll('---', '');
        eanData = OPENGTINDEB_ERRORCODES[eanData].toString();
      }
    } else {
      eanData = httpMessage;
      status = OPENGTINDB_STATUS.ERROR;
    }
  } catch (exception) {
    //SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.178.93, port = 57582
    httpCode = 503;
    httpMessage = exception.toString();
    status = OPENGTINDB_STATUS.ERROR;
  } // end catch exception
  return OpenGTINDBOutput(
    status: status,
    httpCode: httpCode.toString(),
    httpMessage: httpMessage,
    eanData: eanData,
  );
}

CheckDigitOutput _CheckEANNumber(String number) {
  if (number == '') {
    return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
  }

  number = number.replaceAll('#', '');
  if (number.length == 8 || number.length == 13 || number.length == 14 || number.length == 18) {
    if (_checkNumber(number, _checkEAN)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(false, _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateEANNumber),
          _CalculateGlitch(number, _checkEAN));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateEANNumber(String number) {
  if (number == '') {
    return number + 'checkdigits_invalid_length';
  }

  if (number.length == 7 || number.length == 12 || number.length == 13 || number.length == 17) {
    return number + _calculateCheckDigit(number, _calculateEANCheckDigit);
  } else {
    return 'checkdigits_invalid_length';
  }
}

List<String> _CalculateEANDigits(String number) {
  if (number == '') {
    return ['checkdigits_invalid_length'];
  }

  if (number.length == 8 ||
      number.length == 13 ||
      number.length == 14 ||
      number.length == 18) {
    return _CalculateDigits(number, _checkEAN);
  } else {
    return ['checkdigits_invalid_length'];
  }
}

bool _checkEAN(String number) {
  return (number[number.length - 1] == _calculateEANCheckDigit(number.substring(0, number.length - 1)));
}

String _calculateEANCheckDigit(String number) {
  int sum = 0;
  for (int i = 0; i < number.length; i++) {
    if (i % 2 == 0) {
      sum = sum + 1 * int.parse(number[i]);
    } else {
      sum = sum + 3 * int.parse(number[i]);
    }
  }
  if (sum >= 100) {
    sum = sum % 100;
  }
  sum = sum % 10;
  sum = 10 - sum;
  return sum.toString();
}
