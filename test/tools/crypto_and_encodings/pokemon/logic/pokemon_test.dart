import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/pokemon/logic/pokemon.dart';

void main() {
  group("Pokemon.encodePokemon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'cache nord drei vier sechs acht', 'expectedOutput' : 'FLAPIFLAKASA TUSAMKLALU LUKLASAFLOR ASFLORSAKLA SESAFLAKASE PIFLAKADA'},

    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodePokemon(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Pokemon.decodePokemon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'se', 'expectedOutput' : 'S'},
      {'input' : 'sew', 'expectedOutput' : '<?>'},
      {'input' : 'x', 'expectedOutput' : '<?>'},
      {'input' : 'x sa', 'expectedOutput' : '<?> E'},
      {'input' : 'x sa y', 'expectedOutput' : '<?> E <?>'},

      {'input' : 'Piluffme luflorsasesa Florlusasa manpison sonsaflortu SesamkatuMansamsonsonpi lupi sakla arsaklatusa Regsammansasonsamtu seregflorsakarda lufftulu saflortusa Assaklamonflortululufftuar zuluffson Arsasamflapiflakasatu mosamkarkardasaReglufftumanda', 'expectedOutput' : 'AUF DIESE IDEE KAM MEIN SOHNKOMMA DA ER GERNE POKEMON SPIELT UND EINE VERBINDUNG ZUM GEOCACHEN WOLLTEPUNKT'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}}', () {
        var _actual = decodePokemon(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}