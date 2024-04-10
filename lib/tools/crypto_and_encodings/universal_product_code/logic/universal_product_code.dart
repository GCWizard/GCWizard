import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/string_utils.dart' as strUtils;

part 'package:gc_wizard/tools/crypto_and_encodings/universal_product_code/logic/upc_a.dart';

class UniversalProductCode {
  final String pureNumbers;
  final String correctEncoding;
  final String barcodeBinaryCorrectEncoding;

  UniversalProductCode(this.pureNumbers, this.correctEncoding, this.barcodeBinaryCorrectEncoding);

  @override
  String toString() {
    return [pureNumbers, correctEncoding, barcodeBinaryCorrectEncoding].join('\n');
  }
}

abstract class _UniversalProductCodeEncoder {
  final String _input;

  _UniversalProductCodeEncoder(this._input);

  String _encodePureNumbers();
  String _encodeCorrectEncoding();

  String _toBarcodeBinary(String input) {
    if (input.isEmpty) return '';

    var black = false;
    var out = '';

    input.split('').forEach((number) {
      out += (black ? '1' : '0') * int.parse(number);
      black = !black;
    });

    return out;
  }

  UniversalProductCode toUPC() {
    var pure = _encodePureNumbers();
    var correct = '';
    try {
      correct = _encodeCorrectEncoding();
    } catch(e) {}

    return UniversalProductCode(
      pure,
      correct,
      _toBarcodeBinary(correct)
    );
  }
}

enum _UPCDecodeMode {PURE_NUMBERS, CORRECT_ENCODING, BINARY_CORRECT_ENCODING}

abstract class _UniversalProductCodeDecoder {
  late final String _input;

  _UniversalProductCodeDecoder(String text) {
    _input = text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  _UPCDecodeMode _checkMode();
  String _decodePureNumbers();
  String _decodeCorrectEncoding([String? input]);

  bool _isBinary() {
    return _input.length == _input.replaceAll(RegExp(r'[^01]'), '').length;
  }

  String _fromBarcodeBinary() {
    var input = _input;
    var out = '';
    var black = false;

    var value = 0;
    for (int i = 0; i < input.length; i++) {
      var char = input[i];
      if ((char == '1' && black) || (char == '0' && !black)) {
        value++;
      } else {
        black = !black;
        out += value.toString();
        value = 1;
      }
    }

    return out + value.toString();
  }

  String decode() {
    var mode = _checkMode();

    switch (mode) {
      case _UPCDecodeMode.PURE_NUMBERS: return _decodePureNumbers();
      case _UPCDecodeMode.CORRECT_ENCODING: return _decodeCorrectEncoding();
      case _UPCDecodeMode.BINARY_CORRECT_ENCODING: return _decodeCorrectEncoding(_fromBarcodeBinary());
      default: throw Exception('INVALID CODE');
    }
  }
}

UniversalProductCode encodeUPC_A(String input) {
  return _UPCAEncoder(input).toUPC();
}

String decodeUPC_A(String input) {
  return _UPCADecoder(input).decode();
}