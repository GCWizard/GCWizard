part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

// https://www.geldschein.at/euro-banknoten/euro_seriennummer.html
// http://www.pruefziffernberechnung.de/B/Banknoten-EUR.shtml

const EUROBANKNOTEDATA = {
  1: {
    'B': {'country': 'common_country_Lithuania'},
    'C': {'country': 'common_country_Latvia'},
    'D': {'country': 'common_country_Estonia'},
    'E': {'country': 'common_country_Slovakia'},
    'F': {'country': 'common_country_Malta'},
    'G': {'country': 'common_country_Cyprus'},
    'H': {'country': 'common_country_Slovenia'},
    'J': {'country': 'common_country_UnitedKingdom'},
    'K': {'country': 'common_country_Sweden'},
    'L': {'country': 'common_country_Finland'},
    'M': {'country': 'common_country_Portugal'},
    'N': {'country': 'common_country_Austria'},
    'P': {'country': 'common_country_Netherlands'},
    'R': {'country': 'common_country_Luxembourg'},
    'S': {'country': 'common_country_Italy'},
    'T': {'country': 'common_country_Ireland'},
    'U': {'country': 'common_country_France'},
    'V': {'country': 'common_country_Spain'},
    'W': {'country': 'common_country_Denmark'},
    'X': {'country': 'common_country_Germany'},
    'Y': {'country': 'common_country_Greece'},
    'Z': {'country': 'common_country_Belgium'},
  },
  2: {
    'D': {'institute': 'Polska Wytwórnia Papierów Wartosciowych', 'country': 'common_country_Poland'},
    'E': {'institute': 'Francois Charles Oberthur Fiduciaire', 'country': 'common_country_France'},
    'F': {'institute': 'Oberthur Bulgarien', 'country': 'common_country_Bulgaria'},
    'H': {'institute': 'De La Rue Currency (Loughton)', 'country': 'common_country_UnitedKingdom'},
    'J': {'institute': 'De La Rue Currency (Gateshead)', 'country': 'common_country_UnitedKingdom'},
    'M': {'institute': 'Valora', 'country': 'common_country_Portugal'},
    'N': {'institute': 'Österreichische Banknoten- und Sicherheitsdruck GmbH', 'country': 'common_country_Austria'},
    'P': {'institute': 'Johan Enschede Security Printing BV', 'country': 'common_country_Netherlands'},
    'R': {'institute': 'Bundesdruckerei GmbH', 'country': 'common_country_Germany'},
    'S': {'institute': 'Banca d’Italia', 'country': 'common_country_Italy'},
    'T': {'institute': 'Central Bank of Ireland', 'country': 'common_country_Ireland'},
    'U': {'institute': 'Banque de France', 'country': 'common_country_France'},
    'V': {'institute': 'Fàbrica National de Mondea y Timbre', 'country': 'common_country_Spain'},
    'W': {'institute': 'Giesecke & Devrient (Leipzig)', 'country': 'common_country_Germany'},
    'X': {'institute': 'Giesecke & Devrient (München)', 'country': 'common_country_Germany'},
    'Y': {'institute': 'Bank of Greece', 'country': 'common_country_Greece'},
    'Z': {'institute': 'Banque Nationale de Belgique', 'country': 'common_country_Belgium'},
  },
};

bool _isLetter(String letter) {
  return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.contains(letter.toUpperCase());
}

int checkEuroSeries(String number) {
  if (_isLetter(number[0]) && _isLetter(number[1])) {
    return 2;
  } else {
    return 1;
  }
}

CheckDigitOutput _CheckEURONumber(String number) {
  if (number == '') {
    return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
  }

  if (number.length == 12) {
    if (_checkNumber(number, _checkEURO)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(
          false,
          _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateEURONumber),
          _CalculateGlitch(number, _checkEURO));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateEURONumber(String number) {
  if (number == '') {
    return 'checkdigits_invalid_length';
  }

  if (number.length == 11) {
    return number + _calculateCheckDigit(number, _calculateEUROCheckDigit);
  } else {
    return 'checkdigits_invalid_length';
  }
}

List<String> _CalculateEURODigits(String number) {
  if (number == '') {
    return ['checkdigits_invalid_length'];
  }

  if (number.length == 12) {
    return _CalculateDigits(number, _checkEURO);
  } else {
    return ['checkdigits_invalid_length'];
  }
}

bool _checkEURO(String number) {
  if (EUROBANKNOTEDATA[checkEuroSeries(number)]![number[0]] == null) {
    return false;
  } else {
    return (number[number.length - 1] == _calculateEUROCheckDigit(number.substring(0, number.length - 1)));
  }
}

String _calculateEUROCheckDigit(String number) {
  String result = '';
  int qSum = 0;
  switch (checkEuroSeries(number)) {
    case 1:
      int n1 = alphabet_AZ[number[0].toUpperCase()]!;
      qSum = sum([int.parse(n1.toString() + number.substring(1, number.length))]).toInt();
      qSum = 8 - (qSum % 9);
      if (qSum == 0) {
        result = '9';
      } else {
        result = qSum.toString();
      }
      break;
    case 2:
      int n1 = alphabet_AZ[number[0].toUpperCase()]!;
      int n2 = alphabet_AZ[number[1].toUpperCase()]!;
      qSum = sum([int.parse(n1.toString() + n2.toString() + number.substring(2, number.length))]).toInt();
      qSum = 7 - (qSum % 9);
      if (qSum == -1) {
        result = '8';
      } else if (qSum == 0) {
        result = '9';
      } else {
        result = qSum.toString();
      }
      break;
  }
  return result;
}
