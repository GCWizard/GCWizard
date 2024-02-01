import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bifid/logic/bifid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

void main() {
  // https://gc.de/gc/bifid/
  // https://www.dcode.fr/bifid-cipher
  // https://geocaching.dennistreysa.de/multisolver/
  //      does not work with 6x6 square
  // https://www.geocachingtoolbox.com/index.php?lang=en&page=bifidCipher
  // https://cryptii.com/pipes/bifid-cipher
  // http://rumkin.com/tools/cipher/bifid.php
  // http://kryptografie.de/kryptografie/chiffre/bifid.htm
  // https://www.braingle.com/brainteasers/codes/bifid.php
  // http://practicalcryptography.com/ciphers/classical-era/bifid/
  // https://www.cryptool.org/en/jcryptool
  //      supports only 5x5 square


  group("Bifid.encryptBifid:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty Input
      {'input' : '', 'key': '', 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'bifid_error_wrong_griddimension'},

      //empty alphabet
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': null, 'alphabetMode':AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP'},

      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ'},

      //5x5 |  AZ09, ZA90, Custom | J-I, C-K, W-VV
      {'input' : 'THE', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'REJ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'RERHEPLPJNSVQLZDJAHRQXZHRPSUKOEGAYODGZ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'RERHEPLPJNSVQLZDJAHRQXZHRPSUKOEGAYODGZ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : 'QDVCDOXHVXSODCEULPAOOFRBOGPXUKTJKFYTIFK'},

      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'RERHEPLPJNSVQLZDJAHRQXZHRPSUKOEGAYODGZ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : 'QDVCDOXHVXSODCEULPAOOFRBOGPXUKTJKFYTIFK'},

      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZQPNDSIOAXEFCLUMTHYVR', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'ROLFZIDAXCNYYLZNGWFGTFDZNIDKHHMYAYCSWD'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZQPNDSIOAXEFLUMTHYVRJ', 'alphabetMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'TOUBZIDARLNVVUZNGWBHHIMKNIDVLYEUNYLSWM'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGVKZQPNDSIOAXEFCLUMTHYRJ', 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : 'JOLFZIGLEUPIEXIHIQXBSKGFCAIDRHHELAYCSVD'},

      // https://en.wikipedia.org/wiki/Bifid_cipher#:~:text=%20%20%20%20v%20t%20e%20Classical,Cryptogram%20Frequency%20analysis%20Index%20of%20c%20...%20
      {'input' : 'FLEEATONCE', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZQPNDSIOAXEFCLUMTHYVR', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'UAEOLWRINS'},

      //6x6 |  AZ09, ZA90, Custom
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '123456', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '123456', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'QGXFATKTNMSWPJZGG7FZE02X2X36PO8MMY6SY2'},
      {'input' : 'THE QUICK BROWN FOX JUMPS OVER A LAZY DOGS BACK', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZ0QPNDS2IOAXE4FCLUM6THYVR813579J', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'ROLFZIDA7CNYYLZNGWFGTFDZNID7HHMYAYCSWD'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}, alphabetMode: ${elem['alphabetMode']}', () {
        BifidOutput _actual = encryptBifid(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, alphabet: elem['alphabet'] as String?, alphabetMode: elem['alphabetMode'] as AlphabetModificationMode);
                    expect(_actual.output, elem['expectedOutput']);
        });
    }
  });

  group("Bifid.decryptBifid:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty Input
      {'input' : '', 'key': '', 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'bifid_error_wrong_griddimension'},

      //empty alphabet
      {'input' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'THEQUICKBROWNFOXIUMPSOVERALAZYDOGSBACK'},
      {'input' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'THEQUICKBROWNFOXIUMPSOVERALAZYDOGSBACK'},

      {'input' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'THEQUICKBROWNFOXJUMPSOVERALAZYDOGSBACK'},
      {'input' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'THEQUICKBROWNFOXJUMPSOVERALAZYDOGSBACK'},

      //5x5 |  AZ09, ZA90, Custom | J-I, C-K, W-VV
      {'expectedOutput' : 'THEQUICKBROWNFOXIUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP'},
      {'expectedOutput' : 'THEQUIKKBROWNFOXJUMPSOVERALAZYDOGSBAKK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'input' : 'RERHEPLPJNSVQLZDJAHRQXZHRPSUKOEGAYODGZ'},
      {'expectedOutput' : 'THEQUICKBROVVNFOXJUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'input' : 'QDVCDOXHVXSODCEULPAOOFRBOGPXUKTJKFYTIFK'},

      {'expectedOutput' : 'THEQUICKBROWNFOXIUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'RDRBDPMPINSVQLZCIABSVYPGRLSUKOEFAYTHFP'},
      {'expectedOutput' : 'THEQUIKKBROWNFOXJUMPSOVERALAZYDOGSBAKK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.C_TO_K, 'input' : 'RERHEPLPJNSVQLZDJAHRQXZHRPSUKOEGAYODGZ'},
      {'expectedOutput' : 'THEQUICKBROVVNFOXJUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'input' : 'QDVCDOXHVXSODCEULPAOOFRBOGPXUKTJKFYTIFK'},

      {'expectedOutput' : 'THEQUICKBROWNFOXIUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZQPNDSIOAXEFCLUMTHYVR', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'ROLFZIDAXCNYYLZNGWFGTFDZNIDKHHMYAYCSWD'},
      {'expectedOutput' : 'THEQUIKKBROWNFOXJUMPSOVERALAZYDOGSBAKK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZQPNDSIOAXEFLUMTHYVRJ', 'alphabetMode': AlphabetModificationMode.C_TO_K, 'input' : 'TOUBZIDARLNVVUZNGWBHHIMKNIDVLYEUNYLSWM'},
      {'expectedOutput' : 'THEQUICKBROVVNFOXJUMPSOVERALAZYDOGSBACK', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGVKZQPNDSIOAXEFCLUMTHYRJ', 'alphabetMode': AlphabetModificationMode.W_TO_VV, 'input' : 'JOLFZIGLEUPIEXIHIQXBSKGFCAIDRHHELAYCSVD'},

      //6x6 |  AZ09, ZA90, Custom
      {'expectedOutput' : 'THEQUICKBROWNFOXJUMPSOVERALAZYDOGSBACK', 'key': '123456', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'TCTBCPMPJOUSMG2CJABH2OQLQLRUDCW44GUAGQ'},
      {'expectedOutput' : 'THEQUICKBROWNFOXJUMPSOVERALAZYDOGSBACK', 'key': '123456', 'mode': PolybiosMode.ZA90, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'QGXFATKTNMSWPJZGG7FZE02X2X36PO8MMY6SY2'},
      {'expectedOutput' : 'THEQUICKBROWNFOXJUMPSOVERALAZYDOGSBACK', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'alphabet': 'BGWKZ0QPNDS2IOAXE4FCLUM6THYVR813579J', 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'ROLFZIDA7CNYYLZNGWFGTFDZNID7HHMYAYCSWD'},

      // https://coord.info/GC8K32B
      {'expectedOutput' : 'DRAKENBURG', 'key': '12345', 'mode': PolybiosMode.AZ09, 'alphabet': null, 'alphabetMode': AlphabetModificationMode.J_TO_I, 'input' : 'DBCDRREXKG'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}, alphabetMode: ${elem['alphabetMode']}', () {
        BifidOutput _actual = decryptBifid(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, alphabet: elem['alphabet'] as String?, alphabetMode: elem['alphabetMode'] as AlphabetModificationMode);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });
}