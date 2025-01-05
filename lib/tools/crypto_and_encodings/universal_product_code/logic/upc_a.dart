part of 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/logic/universal_product_code.dart';

const Map<String, String> _UPC_A = {
  '0': '3211',
  '1': '2221',
  '2': '2122',
  '3': '1411',
  '4': '1132',
  '5': '1231',
  '6': '1114',
  '7': '1312',
  '8': '1213',
  '9': '3112',
};

String _UPC_A_START = '111';
String _UPC_A_END = '111';
String _UPC_A_MIDDLE = '11111';
String _UPC_A_QUIET = '9';

String _UPC_A_START_BIN = '101';
String _UPC_A_END_BIN = '101';
String _UPC_A_MIDDLE_BIN = '01010';

class _UPCAEncoder extends _UniversalProductCodeEncoder {
  _UPCAEncoder(super.input);

  @override
  String _encodePureNumbers() {
    var input = _input.replaceAll(RegExp(r'[^0-9]'), '');
    if (input.isEmpty) return '';

    return input.split('').map((e) => _UPC_A[e]!).join();
  }

  @override
  String _encodeCorrectEncoding() {
    var input = _input.replaceAll(RegExp(r'[^0-9]'), '');

    if (input.length != 12) {
      throw const FormatException('Need 12 digits');
    }

    var left = input.substring(0, 6);
    var right = input.substring(6);

    var leftNumbers = left.split('').map((e) => _UPC_A[e]!).join();
    var rightNumbers = right.split('').map((e) => _UPC_A[e]!).join();

    return _UPC_A_QUIET + _UPC_A_START + leftNumbers + _UPC_A_MIDDLE + rightNumbers + _UPC_A_END + _UPC_A_QUIET;
  }
}

class _UPCADecoder extends _UniversalProductCodeDecoder {
  _UPCADecoder(super.input);

  @override
  _UPCDecodeMode _checkMode() {
    var input = strUtils.trimCharacters(_input, '0');

    if (_isBinary()) {
      if (input.length == 95 &&
          input.startsWith(_UPC_A_START_BIN) &&
          input.endsWith(_UPC_A_END_BIN) &&
          input.contains(_UPC_A_MIDDLE_BIN)) {
        return _UPCDecodeMode.BINARY_CORRECT_ENCODING;
      } else {
        return _UPCDecodeMode.PURE_NUMBERS;
      }
    } else {
      if (input.length == 61 &&
          input.startsWith(_UPC_A_QUIET + _UPC_A_START) &&
          input.endsWith(_UPC_A_END + _UPC_A_QUIET) &&
          input.contains(_UPC_A_MIDDLE)) {
        return _UPCDecodeMode.CORRECT_ENCODING;
      } else {
        return _UPCDecodeMode.PURE_NUMBERS;
      }
    }
  }

  String _decodeNumbers(String numbers) {
    numbers = strUtils.insertEveryNthCharacter(numbers, 4, ' ');
    return numbers.split(' ').map((chunk) {
      var number = _UPC_A.entries.firstWhereOrNull((elem) => elem.value == chunk);

      if (number == null) {
        throw const FormatException('INVALID_CODE');
      }

      return number.key;
    }).join();
  }

  @override
  String _decodeCorrectEncoding([String? input]) {
    input ??= _input;

    var left = input.substring(4, 28);
    var right = input.substring(33, 57);

    return _decodeNumbers(left + right);
  }

  @override
  String _decodePureNumbers([String? input]) {
    input ??= _input;

    while (input!.length % 4 != 0) {
      input = input.substring(0, input.length - 1);
    }

    if (input.isEmpty) return '';

    return _decodeNumbers(input);
  }
}
