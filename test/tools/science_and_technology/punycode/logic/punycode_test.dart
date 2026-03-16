import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/punycode/logic/punycode.dart';

void main() {

  group("Punycode.encodeDomainPunycode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'müller.de', 'expectedOutput' : 'xn--mller-kva.de'},
      {'input' : 'www.müller.de', 'expectedOutput' : 'www.xn--mller-kva.de'},
      {'input' : 'bücher', 'expectedOutput' : 'xn--bcher-kva'},
      {'input' : 'ドメイン名例', 'expectedOutput' : 'xn--eckwd4c7cu47r2wf'},
      {'input' : 'test', 'expectedOutput' : 'test'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeDomainPunycode(elem['input'] as String);
        expect(_actual.errorText == '' ? _actual.output : _actual.errorText, elem['expectedOutput']);
      });
    }
  });

  group("Punycode.decodeDomainPunycode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'müller.de', 'input' : 'xn--mller-kva.de'},
      {'expectedOutput' : 'www.müller.de', 'input' : 'www.xn--mller-kva.de'},
      {'expectedOutput' : 'bücher', 'input' : 'xn--bcher-kva'},
      {'expectedOutput' : 'ドメイン名例', 'input' : 'xn--eckwd4c7cu47r2wf'},
      {'expectedOutput' : 'test', 'input' : 'test'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeDomainPunycode(elem['input'] as String);
        expect(_actual.errorText == '' ? _actual.output : _actual.errorText, elem['expectedOutput']);
      });
    }
  });
}