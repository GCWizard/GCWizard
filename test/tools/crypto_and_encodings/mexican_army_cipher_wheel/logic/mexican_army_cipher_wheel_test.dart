import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/mexican_army_cipher_wheel/logic/mexican_army_cipher_wheel.dart';

void main() {
  group("MexicanArmyCipherWheel.encryptMexicanArmyCipherWheel:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'keys': <int>[], 'expectedOutput' : ''},

      {'input' : 'AZ', 'keys': [1,27,53,79],   'expectedOutput' : '0126 2726 5326 7926  0152 2752 5352 7952  0178 2778 5378 7978'},
      {'input' : 'AZ', 'keys': [25,29,78,80],   'expectedOutput' : '2524 2924 7824 8024  2528 2928 7828 8028  2577 2977 7877 8077  2579 2979 7879 8079'},
      {'input' : 'AZ', 'keys': [19,39,67,101],   'expectedOutput' : '1918 3918 6718  1938 3938 6738  1966 3966 6766  1900 3900 6700'},
      {'input' : 'AZ', 'keys': [19,39,67,102],   'expectedOutput' : '1918 3918 6718  1938 3938 6738  1966 3966 6766'},
      {'input' : 'AZ', 'keys': [19,39,67,100],   'expectedOutput' : '1918 3918 6718 0018  1938 3938 6738 0038  1966 3966 6766 0066  1999 3999 6799 0099'},
      {'input' : 'AB', 'keys': [19,39,67,100],   'expectedOutput' : '1920 3920 6720 0020  1940 3940 6740 0040  1968 3968 6768 0068'},
      {'input' : 'AL', 'keys': [19,39,67,100],   'expectedOutput' : '1904 3904 6704 0004  1950 3950 6750 0050  1978 3978 6778 0078  1985 3985 6785 0085'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keys: ${elem['keys']}', () {
        for (int i = 0; i < 1000; i++) {
          var _actual = encryptMexicanArmyCipherWheel(elem['input'] as String, elem['keys'] as List<int>);
          expect((elem['expectedOutput'] as String).contains(_actual), true);
        }
      });
    }
  });

  group("MexicanArmyCipherWheel.decryptMexicanArmyCipherWheel:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'keys': <int>[], 'input' : ''},

      {'expectedOutput' : 'AFIMQX', 'keys': [22,40,58,90], 'input' : '406304088055'},
      {'expectedOutput' : 'AFIMQX', 'keys': [22,40,58,90], 'input' : '900104521287'},
      {'expectedOutput' : 'AFIMQX', 'keys': [22,40,58,90], 'input' : '229598703019'},

      {'expectedOutput' : 'AFIMQX', 'keys': [26,30,78,102], 'input' : '780584424699'},
      {'expectedOutput' : 'AFIMQX', 'keys': [26,30,78,102], 'input' : '268138886827'},

      {'expectedOutput' : 'AFIMQX', 'keys': [7,34,74,95], 'input' : '340056195004'},
      {'expectedOutput' : 'AFIMQX', 'keys': [7,34,74,95], 'input' : '951242602392'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keys: ${elem['keys']}', () {
        var _actual = decryptMexicanArmyCipherWheel(elem['input'] as String, elem['keys'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}