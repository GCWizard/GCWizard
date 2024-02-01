// Source: https://poisoncentres.echa.europa.eu/documents/1789887/1803644/ufi_developers_manual_en.pdf/9d47a5c9-ba58-4b5c-8101-7d5610928035

import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi_decode.dart';
part 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi_encode.dart';

class _UFI_COUNTRY_DEFINITION {
  final String countryCode;
  final String countryName;
  final String ufiRegExp;
  final int countryGroupCodeG;
  final int numberOfBitsForCountryCodeB;
  final int? countryCodeC;
  final BigInt Function(String)? specialEncode;
  final String Function(String) decode;

  const _UFI_COUNTRY_DEFINITION(
      {required this.countryCode,
      required this.countryName,
      required this.ufiRegExp,
      required this.countryGroupCodeG,
      required this.numberOfBitsForCountryCodeB,
      required this.countryCodeC,
      this.specialEncode,
      required this.decode});
}

class UFI {
  final String countryCode;
  final String vatNumber;
  final String formulationNumber;

  const UFI({required this.countryCode, required this.vatNumber, required this.formulationNumber});
}

const String UFI_COMPANYKEY = 'ufi_companykey';

final List<_UFI_COUNTRY_DEFINITION> UFI_DEFINITIONS = [
  const _UFI_COUNTRY_DEFINITION(
      countryCode: UFI_COMPANYKEY,
      countryName: UFI_COMPANYKEY,
      ufiRegExp: r'[0-9]+',
      countryGroupCodeG: 0,
      numberOfBitsForCountryCodeB: 0,
      countryCodeC: null,
      specialEncode: _vEncodeCompany,
      decode: _vDecodeCompany),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'FR',
      countryName: 'common_country_France',
      ufiRegExp: r'[0-9A-Z]{2}[0-9]{9}',
      countryGroupCodeG: 1,
      numberOfBitsForCountryCodeB: 0,
      countryCodeC: null,
      specialEncode: _vEncodeFR,
      decode: _vDecodeFR),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'GB',
      countryName: 'common_country_UnitedKingdom',
      ufiRegExp: r'([0-9]{9}([0-9]{3})?|[A-Z]{2}[0-9]{3})',
      countryGroupCodeG: 2,
      numberOfBitsForCountryCodeB: 0,
      countryCodeC: null,
      specialEncode: _vEncodeGB,
      decode: _vDecodeGB),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'XN',
      countryName: 'common_country_NorthernIreland',
      ufiRegExp: r'([0-9]{9}([0-9]{3})?|[A-Z]{2}[0-9]{3})',
      countryGroupCodeG: 2,
      numberOfBitsForCountryCodeB: 0,
      countryCodeC: 0,
      specialEncode: _vEncodeGB,
      decode: _vDecodeGB),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'LT',
      countryName: 'common_country_Lithuania',
      ufiRegExp: r'([0-9]{9}|[0-9]{12})',
      countryGroupCodeG: 3,
      numberOfBitsForCountryCodeB: 1,
      countryCodeC: 0,
      decode: _vDecodeLT),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'SE',
      countryName: 'common_country_Sweden',
      ufiRegExp: r'[0-9]{12}',
      countryGroupCodeG: 3,
      numberOfBitsForCountryCodeB: 1,
      countryCodeC: 1,
      decode: _vDecodeSE),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'HR',
      countryName: 'common_country_Croatia',
      ufiRegExp: r'[0-9]{11}',
      countryGroupCodeG: 4,
      numberOfBitsForCountryCodeB: 4,
      countryCodeC: 0,
      decode: _vDecodeHR),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'IT',
      countryName: 'common_country_Italy',
      ufiRegExp: r'[0-9]{11}',
      countryGroupCodeG: 4,
      numberOfBitsForCountryCodeB: 4,
      countryCodeC: 1,
      decode: _vDecodeIT),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'LV',
      countryName: 'common_country_Latvia',
      ufiRegExp: r'[0-9]{11}',
      countryGroupCodeG: 4,
      numberOfBitsForCountryCodeB: 4,
      countryCodeC: 2,
      decode: _vDecodeLV),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'NL',
      countryName: 'common_country_Netherlands',
      ufiRegExp: r'[0-9]{9}B[0-9]{2}',
      countryGroupCodeG: 4,
      numberOfBitsForCountryCodeB: 4,
      countryCodeC: 3,
      decode: _vDecodeNL),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'BG',
      countryName: 'common_country_Bulgaria',
      ufiRegExp: r'[0-9]{9,10}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 0,
      decode: _vDecodeBG),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'CZ',
      countryName: 'common_country_CzechRepublic',
      ufiRegExp: r'[0-9]{8,10}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 1,
      decode: _vDecodeCZ),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'IE',
      countryName: 'common_country_Ireland',
      ufiRegExp: r'([0-9][A-Z*+][0-9]{5}[A-Z]|[0-9]{7}([A-Z]W?|[A-Z]{2}))',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 2,
      specialEncode: _vEncodeIE,
      decode: _vDecodeIE),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'ES',
      countryName: 'common_country_Spain',
      ufiRegExp: r'[0-9A-Z][0-9]{7}[0-9A-Z]',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 3,
      specialEncode: _vEncodeES,
      decode: _vDecodeES),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'PL',
      countryName: 'common_country_Poland',
      ufiRegExp: r'[0-9]{10}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 4,
      decode: _vDecodePL),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'RO',
      countryName: 'common_country_Romania',
      ufiRegExp: r'[0-9]{2,10}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 5,
      decode: _vDecodeRO),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'SK',
      countryName: 'common_country_Slovakia',
      ufiRegExp: r'[0-9]{10}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 6,
      decode: _vDecodeSK),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'CY',
      countryName: 'common_country_Cyprus',
      ufiRegExp: r'[0-9]{8}[A-Z]',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 7,
      specialEncode: _vEncodeCY,
      decode: _vDecodeCY),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'IS',
      countryName: 'common_country_Iceland',
      ufiRegExp: r'[A-Z0-9]{6}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 8,
      specialEncode: _vEncodeIS,
      decode: _vDecodeIS),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'BE',
      countryName: 'common_country_Belgium',
      ufiRegExp: r'0[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 9,
      decode: _vDecodeBE),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'DE',
      countryName: 'common_country_Germany',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 10,
      decode: _vDecodeDE),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'EE',
      countryName: 'common_country_Estonia',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 11,
      decode: _vDecodeEE),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'GR',
      countryName: 'common_country_Greece',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 12,
      decode: _vDecodeGR),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'EL',
      countryName: 'common_country_Greece',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 12,
      decode: _vDecodeGR),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'NO',
      countryName: 'common_country_Norway',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 13,
      decode: _vDecodeNO),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'PT',
      countryName: 'common_country_Portugal',
      ufiRegExp: r'[0-9]{9}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 14,
      decode: _vDecodePT),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'AT',
      countryName: 'common_country_Austria',
      ufiRegExp: r'U[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 15,
      decode: _vDecodeAT),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'DK',
      countryName: 'common_country_Denmark',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 16,
      decode: _vDecodeDK),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'FI',
      countryName: 'common_country_Finland',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 17,
      decode: _vDecodeFI),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'HU',
      countryName: 'common_country_Hungary',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 18,
      decode: _vDecodeHU),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'LU',
      countryName: 'common_country_Luxembourg',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 19,
      decode: _vDecodeLU),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'MT',
      countryName: 'common_country_Malta',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 20,
      decode: _vDecodeMT),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'SI',
      countryName: 'common_country_Slovenia',
      ufiRegExp: r'[0-9]{8}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 21,
      decode: _vDecodeSI),
  const _UFI_COUNTRY_DEFINITION(
      countryCode: 'LI',
      countryName: 'common_country_Liechtenstein',
      ufiRegExp: r'[0-9]{5}',
      countryGroupCodeG: 5,
      numberOfBitsForCountryCodeB: 7,
      countryCodeC: 22,
      decode: _vDecodeLI),
];

const String _UFI_BASE31 = '0123456789ACDEFGHJKMNPQRSTUVWXY';

const String _ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const String _ALPHANUM = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

int _alphabetValueIndexOf(String char) {
  var index = _ALPHABET.indexOf(char);

  if (index < 0) {
    throw Exception();
  }

  return index;
}

String _alphabetValueCharAt(int index) {
  if (index >= _ALPHABET.length) {
    throw Exception();
  }

  return _ALPHABET[index];
}

int _alphaNumValueIndexOf(String char) {
  var index = _ALPHANUM.indexOf(char);

  if (index < 0) {
    throw Exception();
  }

  return index;
}

String _alphaNumValueCharAt(int index) {
  if (index >= _ALPHANUM.length) {
    throw Exception();
  }

  return _ALPHANUM[index];
}

_UFI_COUNTRY_DEFINITION _ufiDefinitionByCountryCode(String countryCode) {
  return UFI_DEFINITIONS.firstWhere((_UFI_COUNTRY_DEFINITION ufi) => ufi.countryCode == countryCode);
}

String encodeUFI(UFI ufi) {
  _UFI_COUNTRY_DEFINITION ufiDefinition = _ufiDefinitionByCountryCode(ufi.countryCode);
  String _vatNumber = ufi.vatNumber.toUpperCase().trim();

  if (!RegExp('^' + ufiDefinition.ufiRegExp + '\$').hasMatch(_vatNumber)) {
    throw Exception('ufi_invalidvat');
  }

  ////// Step 1 ///////////////////////////////////////////////////////////////

  var g = convertBase(ufiDefinition.countryGroupCodeG.toString(), 10, 2);
  g = g.padLeft(4, '0');

  var b = ufiDefinition.numberOfBitsForCountryCodeB;
  var c = '';
  if (b > 0 && ufiDefinition.countryCodeC != null) {
    c = convertBase(ufiDefinition.countryCodeC.toString(), 10, 2);
    c = c.padLeft(b, '0');
  }

  var n = convertBase(
      ufiDefinition.specialEncode == null
          ? _vEncodeRegular(_vatNumber).toString()
          : ufiDefinition.specialEncode!(_vatNumber).toString(),
      10,
      2);
  n = n.padLeft(41 - b, '0');

  var f = convertBase(ufi.formulationNumber, 10, 2);
  f = f.padLeft(28, '0');

  var ufiPayloadBinary = f + g + c + n + '0';
  var ufiPayload = convertBase(ufiPayloadBinary, 2, 10);

  ////// Step 2 ///////////////////////////////////////////////////////////////

  var base31 = convertBase(ufiPayload, 10, 31, alphabet: _UFI_BASE31);
  base31 = base31.padLeft(15, '0');

  ////// Step 3 ///////////////////////////////////////////////////////////////

  var reOrganised = base31[5] +
      base31[4] +
      base31[3] +
      base31[7] +
      base31[2] +
      base31[8] +
      base31[9] +
      base31[10] +
      base31[1] +
      base31[0] +
      base31[11] +
      base31[6] +
      base31[12] +
      base31[13] +
      base31[14];

  ////// Step 4 ///////////////////////////////////////////////////////////////

  int x = 0;
  for (int i = 0; i < reOrganised.length; i++) {
    var u = _UFI_BASE31.indexOf(reOrganised[i]);
    x += (i + 2) * u;
  }

  int u0 = modulo(31 - modulo(x, 31), 31) as int;
  var checkSum = _UFI_BASE31[u0];

  return insertEveryNthCharacter(checkSum + reOrganised, 4, '-');
}

bool _validateUFI(String ufi) {
  if (ufi.length != 16) {
    return false;
  }

  int x = 0;
  for (int i = 0; i < ufi.length; i++) {
    var u = _UFI_BASE31.indexOf(ufi[i]);
    x += (i + 1) * u;
  }

  return modulo(x, 31) == 0;
}

int _bByGroupCode(int groupCode) {
  if (groupCode < 0 || groupCode > 5) {
    throw Exception('ufi_notvalidgroupcode');
  }

  return UFI_DEFINITIONS.firstWhere((ufi) => ufi.countryGroupCodeG == groupCode).numberOfBitsForCountryCodeB;
}

UFI decodeUFI(String ufiCode) {
  ////// Step 4 ///////////////////////////////////////////////////////////////

  ufiCode = ufiCode.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  if (!_validateUFI(ufiCode)) {
    throw Exception('ufi_invalidufi');
  }

  var reOrganised = ufiCode.substring(1);

  ////// Step 3 ///////////////////////////////////////////////////////////////

  var base31 = reOrganised[9] +
      reOrganised[8] +
      reOrganised[4] +
      reOrganised[2] +
      reOrganised[1] +
      reOrganised[0] +
      reOrganised[11] +
      reOrganised[3] +
      reOrganised[5] +
      reOrganised[6] +
      reOrganised[7] +
      reOrganised[10] +
      reOrganised[12] +
      reOrganised[13] +
      reOrganised[14];

  ////// Step 2 ///////////////////////////////////////////////////////////////

  var ufiPayload = trimCharactersLeft(base31, '0');
  ufiPayload = convertBase(ufiPayload, 31, 10, alphabet: _UFI_BASE31);

  ////// Step 1 ///////////////////////////////////////////////////////////////

  var ufiPayloadBinary = convertBase(ufiPayload, 10, 2).padLeft(74, '0');

  var f = ufiPayloadBinary.substring(0, 28);
  var g = int.parse(ufiPayloadBinary.substring(28, 32), radix: 2);

  var formulationNumber = convertBase(f, 2, 10);

  var b = _bByGroupCode(g);

  int? c;
  if (b > 0) {
    c = int.parse(ufiPayloadBinary.substring(32, 32 + b), radix: 2);
  }

  var n = ufiPayloadBinary.substring(ufiPayloadBinary.length - 1 - (41 - b), ufiPayloadBinary.length - 1);
  n = convertBase(n, 2, 10);

  try {
    _UFI_COUNTRY_DEFINITION ufi = _ufiByGC(g, c);

    var vatNumber = ufi.decode(n);

    var countryCode = ufi.countryCode;
    switch (countryCode) {
      case 'EL':
        countryCode = 'GR';
        break;
      case 'XN':
        countryCode = 'GB';
        break;
      default:
        break;
    }

    return UFI(countryCode: countryCode, vatNumber: vatNumber, formulationNumber: formulationNumber);
  } catch (e) {
    throw Exception('ufi_invalidufi');
  }
}

_UFI_COUNTRY_DEFINITION _ufiByGC(int g, int? c) {
  if (g < 3) {
    return UFI_DEFINITIONS.firstWhere((ufi) => ufi.countryGroupCodeG == g);
  } else if (c != null) {
    return UFI_DEFINITIONS.firstWhere((ufi) => ufi.countryGroupCodeG == g && ufi.countryCodeC == c);
  } else {
    throw Exception();
  }
}
