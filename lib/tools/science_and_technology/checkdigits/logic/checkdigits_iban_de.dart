part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

// https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/pruefzifferberechnung/pruefzifferberechnung-fuer-kontonummern-603282
// https://www.bundesbank.de/resource/blob/603320/16a80c739bbbae592ca575905975c2d0/mL/pruefzifferberechnungsmethoden-data.pdf
// https://www.bundesbank.de/de/aufgaben/unbarer-zahlungsverkehr/serviceangebot/bankleitzahlen/download-bankleitzahlen-602592

bool checkDigitsIBANDEBankNumberDoesNotExist(String number) {
  bool result = false;
  if (number.length > 12) {
    if (CHECKDIGITS_IBAN_DE_BANK_ACCOUNT_DATA[int.parse(number.substring(4, 12))] == null) {
      result = true;
    }
  } else {
    return true;
  }
  return result;
}
