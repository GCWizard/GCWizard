part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

// http://www.pruefziffernberechnung.de/I/IBAN.shtml
// https://de.wikipedia.org/wiki/Internationale_Bankkontonummer
// https://en.wikipedia.org/wiki/International_Bank_Account_Number
// https://web.archive.org/web/20171220203336/http://www.europebanks.info/ibanguide.php#5

// https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/pruefzifferberechnung/pruefzifferberechnung-fuer-kontonummern-603282
// https://www.bundesbank.de/resource/blob/603320/16a80c739bbbae592ca575905975c2d0/mL/pruefzifferberechnungsmethoden-data.pdf
// https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/bankleitzahlen/download-bankleitzahlen-602592

// GC7DCXZ => calculate checkDigit
//         => calculate Number
// GC4TKB5 => calculate checkDigit

CheckDigitOutput _CheckIBANNumber(String number) {
  number = number.toUpperCase();
  if (number == '' || number.length < 5) {
    return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
  }
  if (_checkNumber(number, _checkIBAN)) {
    return CheckDigitOutput(true, '', ['']);
  } else {
    return CheckDigitOutput(
        false, _CalculateNumber(number, _CalculateIBANNumber), _CalculateGlitch(number, _checkIBAN));
  }
}

final IBAN_DATA_MEANING = {
  'b': 'checkdigits_iban_data_b_bank_number',
  's': 'checkdigits_iban_data_s_branch_code',
  'k': 'checkdigits_iban_data_k_account_number',
  'K': 'checkdigits_iban_data_K_control_digit',
  'd': 'checkdigits_iban_data_d_type_of_account',
  'r': 'checkdigits_iban_data_r_regional_code',
  'X': 'checkdigits_iban_data_x_other',
};

final IBAN_DATA = {
  'AE': [
    {'country': 'common_country_UnitedArabEmirates'},
    {'length': 23},
    {'b': 3},
    {'k': 16},
  ],
  'AL': [
    {'country': 'common_country_Albania'},
    {'length': 28},
    {'b': 3},
    {'s': 4},
    {'K': 1},
    {'k': 16},
  ],
  'AD': [
    {'country': 'common_country_Andorra'},
    {'length': 24},
    {'b': 4},
    {'s': 4},
    {'k': 12},
  ],
  'AO': [
    {'country': 'common_country_Angola'},
    {'length': 25},
    {'b': 4},
    {'s': 5},
    {'k': 11},
    {'k': 2},
  ],
  'AT': [
    {'country': 'common_country_Austria'},
    {'length': 20},
    {'b': 5},
    {'k': 11},
  ],
  'AZ': [
    {'country': 'common_country_Azerbaijan'},
    {'length': 28},
    {'b': 4},
    {'k': 20},
  ],
  'BH': [
    {'country': 'common_country_Bahrain'},
    {'length': 22},
    {'b': 4},
    {'k': 14},
  ],
  'BE': [
    {'country': 'common_country_Belgium'},
    {'length': 16},
    {'b': 3},
    {'k': 7},
    {'K': 2},
  ],
  'BY': [
    {'country': 'common_country_Belarus'},
    {'length': 28},
    {'s': 4},
    {'b': 4},
    {'k': 16},
  ],
  'BJ': [
    {'country': 'common_country_Benin'},
    {'length': 28},
    {'b': 5},
    {'s': 5},
    {'k': 12},
    {'K': 2},
  ],
  'BA': [
    {'country': 'common_country_BosniaandHerzegovina'},
    {'length': 20},
    {'b': 3},
    {'s': 3},
    {'k': 8},
    {'K': 2},
  ],
  'BR': [
    {'country': 'common_country_Brasil'},
    {'length': 29},
    {'b': 7},
    {'s': 5},
    {'k': 12},
  ],
  'BG': [
    {'country': 'common_country_Bulgaria'},
    {'length': 22},
    {'b': 4},
    {'s': 4},
    {'d': 2},
    {'k': 8},
  ],
  'BF': [
    {'country': 'common_country_BurkinaFaso'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 2},
  ],
  'BI': [
    {'country': 'common_country_Burundi'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 13},
  ],
  'CI': [
    {'country': 'common_country_CotedIvoire'},
    {'length': 28},
    {'b': 5},
    {'s': 5},
    {'k': 12},
    {'K': 2},
  ],
  'CF': [
    {'country': 'common_country_CentralAfricanRepublic'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 2},
  ],
  'CG': [
    {'country': 'common_country_RepublicoftheCongo'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 2},
  ],
  'CH': [
    {'country': 'common_country_Switzerland'},
    {'length': 21},
    {'b': 5},
    {'k': 12},
  ],
  'CM': [
    {'country': 'common_country_Cameroon'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 2},
  ],
  'CR': [
    {'country': 'common_country_CostaRica'},
    {'length': 22},
    {'k': 18},
  ],
  'CV': [
    {'country': 'common_country_CapeVerde'},
    {'length': 25},
    {'b': 5},
    {'s': 4},
    {'k': 11},
    {'K': 2},
  ],
  'CY': [
    {'country': 'common_country_Cyprus'},
    {'length': 28},
    {'b': 3},
    {'s': 5},
    {'k': 16},
  ],
  'CZ': [
    {'country': 'common_country_CzechRepublic'},
    {'length': 24},
    {'b': 4},
    {'k': 16},
  ],
  'DE': [
    {'country': 'common_country_Germany'},
    {'length': 22},
    {'b': 8},
    {'k': 10},
  ],
  'DK': [
    {'country': 'common_country_Denmark'},
    {'length': 22},
    {'b': 8},
    {'k': 9},
    {'K': 1},
  ],
  'DO': [
    {'country': 'common_country_DominicanRepublic'},
    {'length': 28},
    {'b': 4},
    {'k': 20},
  ],
  'DZ': [
    {'country': 'common_country_Algeria'},
    {'length': 24},
    {'b': 3},
    {'s': 5},
    {'k': 10},
    {'K': 2},
  ],
  'EE': [
    {'country': 'common_country_Estonia'},
    {'length': 20},
    {'b': 2},
    {'k': 13},
    {'K': 1},
  ],
  'EG': [
    {'country': 'common_country_Egypt'},
    {'length': 29},
    {'b': 4},
    {'s': 4},
    {'k': 17},
  ],
  'ES': [
    {'country': 'common_country_Spain'},
    {'length': 24},
    {'b': 4},
    {'s': 4},
    {'K': 2},
    {'k': 10},
  ],
  'FI': [
    {'country': 'common_country_Finland'},
    {'length': 18},
    {'b': 6},
    {'k': 7},
    {'K': 1},
  ],
  'FO': [
    {'country': 'common_country_FaroeIslands'},
    {'length': 18},
    {'b': 4},
    {'k': 9},
    {'K': 1},
  ],
  'FR': [
    {'country': 'common_country_France'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 2},
  ],
  'GA': [
    {'country': 'common_country_Gabon'},
    {'length': 27},
    {'b': 5},
    {'s': 5},
    {'k': 11},
    {'K': 3},
  ],
  'GB': [
    {'country': 'common_country_UnitedKingdom'},
    {'length': 22},
    {'b': 4},
    {'s': 6},
    {'k': 8},
  ],
  'GE': [
    {'country': 'common_country_Georgia'},
    {'length': 22},
    {'b': 2},
    {'k': 16},
  ],
  'GI': [
    {'country': 'common_country_Gibraltar'},
    {'length': 23},
    {'b': 4},
    {'k': 15},
  ],
  'GL': [
    {'country': 'common_country_Greenland'},
    {'length': 18},
    {'b': 4},
    {'k': 9},
    {'K': 1},
  ],
  'GR': [
    {'country': 'common_country_Greece'},
    {'length': 27},
    {'b': 3},
    {'s': 4},
    {'k': 16},
  ],
  'GT': [
    {'country': 'common_country_Guatemala'},
    {'length': 28},
    {'b': 4},
    {'k': 20},
  ],
  'HR': [
    {'country': 'common_country_Croatia'},
    {'length': 21},
    {'b': 7},
    {'k': 10},
  ],
  'HU': [
    {'country': 'common_country_Hungary'},
    {'length': 28},
    {'b': 3},
    {'s': 4},
    {'K': 1},
    {'k': 15},
    {'K': 1},
  ],
  'IE': [
    {'country': 'common_country_Ireland'},
    {'length': 22},
    {'b': 4},
    {'s': 6},
    {'k': 8},
    {'K': },
  ],
  'IL': [
    {'country': 'common_country_Israel'},
    {'length': 23},
    {'b': 3},
    {'s': 3},
    {'k': 13},
    {'K': },
  ],
  'IQ': [
    {'country': 'common_country_Iraq'},
    {'length': 23},
    {'b': 4},
    {'s': 3},
    {'k': 12},
    {'K': },
  ],
  'IR': [
    {'country': 'common_country_Iran'},
    {'length': 26},
    {'b': },
    {'s': },
    {'k': 22},
    {'K': },
  ],
  'IS': [
    {'country': 'common_country_Iceland'},
    {'length': 26},
    {'b': 4},
    {'s': 2},
    {'k': 6},
    {'K': },
    {'X': 10},
  ],
  'IT': [
    {'country': 'common_country_Italy'},
    {'length': 27},
    {'K': 1},
    {'b': 5},
    {'s': 5},
    {'k': 12},
  ],
  'JO': [
    {'country': 'common_country_Jordan'},
    {'length': 30},
    {'b': 4},
    {'s': 4},
    {'k': 18},
    {'K': },
  ],
  'KW': [
    {'country': 'common_country_Kuwait'},
    {'length': 30},
    {'b': 4},
    {'s': },
    {'k': 22},
    {'K': },
  ],
  'KZ': [
    {'country': 'common_country_Kazakhstan'},
    {'length': 20},
    {'b': 3},
    {'s': },
    {'k': 13},
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  '': [
    {'country': ''},
    {'length': },
    {'b': },
    {'s': },
    {'k': },
    {'K': },
  ],
  'VG': [
    {'country': 'common_country_BritishVirginIslands'},
    {'length': 24},
    {'b': 4},
    {'k': 16},
  ],
};

String _CalculateIBANNumber(String number) {
  if (number.length < 5) {
    return ('checkdigits_invalid_length');
  } else {
    return number.substring(0, 2) + _calculateIBANCheckDigit(number) + number.substring(4);
  }
}

List<String> _CalculateIBANDigits(String number) {
  return _CalculateDigits(number, _checkIBAN);
}

bool _checkIBAN(String number) {
  number = number.substring(4) +
      ID_LETTERCODE[number[0]].toString() +
      ID_LETTERCODE[number[1]].toString() +
      number[2] +
      number[3];
  return (BigInt.parse(number) % BigInt.from(97) == BigInt.one);
}

String _calculateIBANCheckDigit(String number) {
  number = number.substring(4) + ID_LETTERCODE[number[0]].toString() + ID_LETTERCODE[number[1]].toString() + '00';
  BigInt checkDigit = BigInt.from(98) - BigInt.parse(number) % BigInt.from(97);
  if (checkDigit < BigInt.from(10)) {
    number = '0' + checkDigit.toString();
  } else {
    number = checkDigit.toString();
  }
  return number;
}