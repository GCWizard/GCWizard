//
// https://web.archive.org/web/20071011164305/http://en.wikipedia.org/wiki/Gray_code

class GrayOutput {
  final List<String> decimalOutput;
  final List<String> binaryOutput;

  GrayOutput(this.decimalOutput, this.binaryOutput);
}

enum GrayMode { DECIMAL, BINARY }

BigInt _encodeGray(BigInt i) {
  return i ^ (i >> 1);
}

BigInt _decodeGray(BigInt i) {
  BigInt mask = i;

  while (mask > BigInt.zero) {
    mask >>= 1;
    i ^= mask;
  }

  return i;
}

GrayOutput encodeGray(String plainText, {GrayMode mode = GrayMode.DECIMAL}) {
  if (plainText.isEmpty) return GrayOutput([], []);

  var encoded = plainText
      .split(RegExp(mode == GrayMode.DECIMAL ? r'\D' : r'[^01]'))
      .where((input) => input.isNotEmpty)
      .map((input) {
    var inputIntPlain = BigInt.tryParse(input, radix: mode == GrayMode.DECIMAL ? 10 : 2) ?? BigInt.zero;
    return _encodeGray(inputIntPlain);
  }).toList();

  return GrayOutput(encoded.map((i) => i.toString()).toList(), encoded.map((i) => i.toRadixString(2)).toList());
}

GrayOutput decodeGray(String plainText, {GrayMode mode = GrayMode.DECIMAL}) {
  if (plainText.isEmpty) return GrayOutput([], []);

  var decoded = plainText
      .split(RegExp(mode == GrayMode.DECIMAL ? r'\D' : r'[^01]'))
      .where((input) => input.isNotEmpty)
      .map((input) {
    var inputIntPlain = BigInt.tryParse(input, radix: mode == GrayMode.DECIMAL ? 10 : 2) ?? BigInt.zero;
    return _decodeGray(inputIntPlain);
  }).toList();

  return GrayOutput(decoded.map((i) => i.toString()).toList(), decoded.map((i) => i.toRadixString(2)).toList());
}
