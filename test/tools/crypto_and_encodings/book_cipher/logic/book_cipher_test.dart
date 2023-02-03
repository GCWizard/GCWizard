import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/book_cipher/logic/book_cipher.dart';

void main() {

  var text1 = "Und 'wieder' - schneit‘s zur Weihnachtszeit.\n"
      "Ja wieder mal. ist es so weit.\n"
      "Der Opa holt vom Abstellraum\n"
      "wie jedes Jahr den Plastikbaum.\n\n"
      "Sein Enkel 'hilft' (so) gut er kann\n"
      "und freut sich auf den Weihnachtsmann.\n"
      "Der Christbaum-schmuck wird angebracht.\n"
      "Schon strahlt der Plastikbaum voll Pracht.";
  

  var test2 = "A b (c)\n"
      "D e f\n"
      "g h i\n"
      "j k l m n\n\n"
      "o p q r - s t\n"
      "'u' v w\n"
      "x y z\n";

  var text2 = "Und 'wieder' - schneit‘s zur Weihnachtszeit.\n"
      "Ja wieder mal. ist es so weit.\n"
      "Der 9Opa holt vom Abstellraum\n"
      "wie jedes Jahr den Plastikbaum.\n\n"
      "Sein Enkel8 'hilft' (so) gut er kann\n"
      "und freut sich auf den Weihnachtsmann.\n"
      "Der Christbaum-schmuck wird angebracht.\n"
      "Schon strahlt der Plastikbaum voll Pracht.";

  group("book_cipher.encodeText:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'text' : null, 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'text' : '', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'text' : 'und', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'text' : '', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'text' : null, 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'text' : 'und', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : test2, 'text' : 'und', 'outFormat' : encodeOutFormat.SectionRowWordCharacter, 'expectedOutput' : '2.2.1.1 1.4.5.1 1.2.1.1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : test2, 'text' : 'und', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '6.1.1 4.5.1 2.1.1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : test2, 'text' : 'und', 'outFormat' : encodeOutFormat.WordCharacter, 'expectedOutput' : '21.1 14.1 4.1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : test2, 'text' : 'und', 'outFormat' : encodeOutFormat.Character, 'expectedOutput' : '37 24 6', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'AAAAAAAAAA', 'text' : 'M', 'outFormat' : encodeOutFormat.Character, 'expectedOutput' : '?', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : text1, 'text' : 'O', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '3.2.1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : true},
      {'input' : text1, 'text' : 'X', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '?.?.?', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : true},
      {'input' : text2, 'text' : '9', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '3.2.1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : true},
      {'input' : text2, 'text' : '9', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '?.?.?', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : false, 'onlyFirstWordLetter' : true},
      {'input' : text2, 'text' : '8', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '?.?.?', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : false, 'onlyFirstWordLetter' : false},
      {'input' : text2, 'text' : '8', 'outFormat' : encodeOutFormat.RowWordCharacter, 'expectedOutput' : '?.?.?', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : false, 'onlyFirstWordLetter' : true},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeText(elem['input'], elem['text'], elem['outFormat'],
            spacesOn: elem['spacesOn'],
            emptyLinesOn: elem['emptyLinesOn'],
            ignoreSymbols: elem['ignoreSymbols'],
            diacriticsOn: elem['diacriticsOn'],
            azOn: elem['azOn'],
            numbersOn: elem['numbersOn'],
            onlyFirstWordLetter: elem['onlyFirstWordLetter']
        );
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("book_cipher.decodeSearchWord:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'word' : null, 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'word' : '', 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'word' : 'und', 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'word' : '', 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'word' : null, 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'word' : 'und', 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : text1, 'word' : 'und', 'outFormat' : decodeOutFormat.SectionRowWord, 'expectedOutput' : ': 1, : 1, : 1\n: 2, : 2, : 1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'word' : 'und', 'outFormat' : decodeOutFormat.RowWord, 'expectedOutput' : ': 1, : 1\n: 6, : 1', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'word' : 'und', 'outFormat' : decodeOutFormat.Word, 'expectedOutput' : ': 1\n: 30', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'word' : 'schneits', 'outFormat' : decodeOutFormat.Word, 'expectedOutput' : ': 3', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'word' : 'hilft', 'outFormat' : decodeOutFormat.Word, 'expectedOutput' : ': 25', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'word' : 'so', 'outFormat' : decodeOutFormat.Word, 'expectedOutput' : ': 11\n: 26', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeSearchWord(elem['input'], elem['word'], elem['outFormat'], "", "", "",
            spacesOn: elem['spacesOn'],
            emptyLinesOn: elem['emptyLinesOn'],
            ignoreSymbols: elem['ignoreSymbols'],
            diacriticsOn: elem['diacriticsOn'],
            azOn: elem['azOn'],
            numbersOn: elem['numbersOn'],
            onlyFirstWordLetter: elem['onlyFirstWordLetter']
        );
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("book_cipher.decodeFindWord:", () {
    var testText1 =
    '''in den BV. Den Bezirksverwaltungen nachgeordnet wa-
ren die örtlichen Kreisdienststellen, von denen es DDR-
weit zuletzt 209 gab. Die Stasi-Offziere vor Ort führ-
ten die Hälfte aller Informanten und leisteten einen
Großteil der operativen Arbeit. Die Überwachung einer
knapp 120 Kilometer langen Grenze zu West-Berlin,
der Verlauf der Transitstrecken durch den Bezirk und
die dort angesiedelten westlichen Militärmissionen er-
klärten, dass Potsdam 1989 mit fast 4 000 Geheimpoli-
zisten die personalstärkste Stasi-Bezirksverwaltung
überhaupt war. Noch hinzu kamen etwas mehr als
9 600 inoffzielle Mitarbeiter, die die hauptamtlichen
Stasi-Offziere in ihrer Arbeit unterstützen sollten. Von
1971 bis 1985 leitete Siegfried Leibholz (1925–2005)
die Potsdamer Bezirksverwaltung. Ihm folgte bis 1990
Helmut Schickart (1931–1993). ''';

    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'positions' : null, 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'positions' : '', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : null, 'positions' : 'und', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'positions' : '', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'positions' : null, 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : '', 'positions' : 'und', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : text1, 'positions' : '1-1-1', 'searchFormat' : searchFormat.SectionRowWord, 'expectedOutput' : 'UND', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '3-1-1', 'searchFormat' : searchFormat.SectionRowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '7.2', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : 'CHRISTBAUMSCHMUCK', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '6, 6', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : 'WEIHNACHTSMANN', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '25', 'searchFormat' : searchFormat.Word, 'expectedOutput' : 'HILFT', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter'  : false},
      {'input' : text1, 'positions' : '0', 'searchFormat' : searchFormat.Word, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '999', 'searchFormat' : searchFormat.Word, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '1-1-2 1', 'searchFormat' : searchFormat.SectionRowWordCharacter, 'expectedOutput' : 'W', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '2 1 3 3', 'searchFormat' : searchFormat.SectionRowWordCharacter, 'expectedOutput' : 'L', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '2 1 3 1 2 1 3 2 2 1 3 3 2 1 3 4 2 1 3 5', 'searchFormat' : searchFormat.SectionRowWordCharacter, 'expectedOutput' : 'HILFT', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '2 1 3 1 2 1 3 2 2 1 3 3 2 1 3 4 2 1 3 5  2 1 3 6', 'searchFormat' : searchFormat.SectionRowWordCharacter, 'expectedOutput' : 'HILFT', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '2 1 3 ', 'searchFormat' : searchFormat.SectionRowWordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : text1, 'positions' : '5 1 4', 'searchFormat' : searchFormat.RowWordCharacter, 'expectedOutput' : 'N', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '1 3 8', 'searchFormat' : searchFormat.RowWordCharacter, 'expectedOutput' : 'S', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '25 3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : 'L', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : text1, 'positions' : '5', 'searchFormat' : searchFormat.Character, 'expectedOutput' : 'W', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TäΘ', 'positions' : '1.2', 'searchFormat' : searchFormat.SectionCharacter, 'expectedOutput' : 'Ä', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TäΘ', 'positions' : '1.2', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'Ä', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TËΘ', 'positions' : '1.2', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'Ë', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TËΘ', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'Θ', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TË-_Θ', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'Θ', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TË-_6', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : '6', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'TE ST', 'positions' : '1.3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : 'S', 'spacesOn' : false, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE' + String.fromCharCode(8195) + 'ST', 'positions' : '1.3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : 'S', 'spacesOn' : false, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE' + String.fromCharCode(0x00A0) + 'ST', 'positions' : '1.3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : 'S', 'spacesOn' : false, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'TE\n\nST', 'positions' : '2.1.1', 'searchFormat' : searchFormat.SectionRowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : false, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE\r\n\r\nST', 'positions' : '2.1.1', 'searchFormat' : searchFormat.SectionRowWord, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : false, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE\r\n\r\nST', 'positions' : '2.1.1', 'searchFormat' : searchFormat.SectionRowWord, 'expectedOutput' : 'ST', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE\r\n\r\nST', 'positions' : '2.1', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'S', 'spacesOn' : true, 'emptyLinesOn' : false, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'TEÄäÄÂÃÇST', 'positions' : '1.3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : 'S', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : false, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TEÄäÄÂÃÇ', 'positions' : '1.3', 'searchFormat' : searchFormat.WordCharacter, 'expectedOutput' : '', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\', 'diacriticsOn' : false, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'TË-_Θ', 'positions' : '1.2', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'Θ', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : false, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE_ST', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'S', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'TE1235ST', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : '3', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : false, 'numbersOn' : true, 'onlyFirstWordLetter' : false},
      {'input' : 'TE1235ST', 'positions' : '1.3', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'S', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : false, 'onlyFirstWordLetter' : false},

      {'input' : 'TEILEN IST EINE SIEBEN TESTWEISE', 'positions' : '1.1 1.3´1.4 1.5', 'searchFormat' : searchFormat.RowWord, 'expectedOutput' : 'TEST', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : '.;+-:!?\'"‘&(){}[]/\\_', 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : true},

      {'input' : testText1, 'positions' : '4,12; 1,3; 14,3; 1,7; 14,3; 12,1; 2,4; 3,14; 2,2; 4,4; 9,37; 8,4; 14,13; 15,4; 6,8; 7,11; 3,5; 14,4; 14,5; 16,21; 15,4; 14,3; 6,8; 6,6; 1,5', 'searchFormat' : searchFormat.RowCharacter, 'expectedOutput' : 'F 7 79 2E 4 5 2F 1 3 72 E', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : null, 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

      {'input' : 'Helmut Schickart (1931–1993).', 'positions' : ' 1,21; ', 'searchFormat' : searchFormat.SectionCharacter, 'expectedOutput' : '3', 'spacesOn' : true, 'emptyLinesOn' : true, 'ignoreSymbols' : null, 'diacriticsOn' : true, 'azOn' : true, 'numbersOn' : true, 'onlyFirstWordLetter' : false},

    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeFindWord(elem['input'], elem['positions'], elem['searchFormat'],
            spacesOn: elem['spacesOn'],
            emptyLinesOn: elem['emptyLinesOn'],
            ignoreSymbols: elem['ignoreSymbols'],
            diacriticsOn: elem['diacriticsOn'],
            azOn: elem['azOn'],
            numbersOn: elem['numbersOn'],
            onlyFirstWordLetter: elem['onlyFirstWordLetter']
        );
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}