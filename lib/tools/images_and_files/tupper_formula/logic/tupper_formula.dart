import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

String kToImage(String kString) {
  List<String> imageBinary = [];

  String binary = '';

  BigInt k = BigInt.parse(kString);
  BigInt n17 = BigInt.from(17);

  if (k % n17 == BigInt.zero) {
    k = k ~/ n17;
    binary = convertBase(k.toString(), 10, 2).padLeft(1802, '0');
    for (int i = 0; i < 106; i++) {
      imageBinary.add(binary.substring(i * 17, i * 17 + 17));
    }
  }

  return imageBinary.join('\n');
}