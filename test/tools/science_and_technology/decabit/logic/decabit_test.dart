import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/decabit/logic/decabit.dart';

void main() {
  group("Decabit.encryptDecabit:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : null, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : <String, String>{}, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : {'+': '+'}, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : {'+': '+', '-': '-'}, 'numericMode' : false, 'expectedOutput' : ''},
  
      {'input' : 'A', 'numericMode' : false, 'expectedOutput' : '++-+++----'},
      {'input' : 'N', 'numericMode' : false, 'expectedOutput' : '--++--+++-'},
      {'input' : 'Z', 'numericMode' : false, 'expectedOutput' : '+-++++----'},
  
      {'input' : '0', 'numericMode' : true, 'expectedOutput' : '--+-+++-+-'},
      {'input' : '63', 'numericMode' : true, 'expectedOutput' : '++---++--+'},
      {'input' : '126', 'numericMode' : true, 'expectedOutput' : '++++++++++'},

      {'input' : 'ANZ', 'numericMode' : false, 'expectedOutput' : '++-+++---- --++--+++- +-++++----'},
      {'input' : 'A N Z', 'numericMode' : false, 'expectedOutput' : '++-+++---- +-+-++-+-- --++--+++- +-+-++-+-- +-++++----'},
      {'input' : ' A N Z ', 'numericMode' : false, 'expectedOutput' : '+-+-++-+-- ++-+++---- +-+-++-+-- --++--+++- +-+-++-+-- +-++++---- +-+-++-+--'},
  
      {'input' : '0 63 126', 'numericMode' : true, 'expectedOutput' : '--+-+++-+- ++---++--+ ++++++++++'},
      {'input' : '   0    63    126   ', 'numericMode' : true, 'expectedOutput' : '--+-+++-+- ++---++--+ ++++++++++'},
      {'input' : '   0000    0063    00126   ', 'numericMode' : true, 'expectedOutput' : '--+-+++-+- ++---++--+ ++++++++++'},
  
      {'input' : String.fromCharCodes([127, 128, 129]), 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : "ABCabc.,-+", 'numericMode' : true, 'expectedOutput' : ''},
  
      {'input' : '222 333 444 555', 'numericMode' : true, 'expectedOutput' : ''},

      {'input' : 'ANZ', 'replaceCharacters': {'+': '0', '-': '1'}, 'numericMode' : false, 'expectedOutput' : '0010001111 1100110001 0100001111'},
      {'input' : 'ANZ', 'replaceCharacters': {'+': '-', '-': '+'}, 'numericMode' : false, 'expectedOutput' : '--+---++++ ++--++---+ -+----++++'},
  
      {'input' : '0 63 126', 'replaceCharacters': {'+': '0', '-': '1'}, 'numericMode' : true, 'expectedOutput' : '1101000101 0011100110 0000000000'},
      {'input' : '0 63 126', 'replaceCharacters': {'+': '-', '-': '+'}, 'numericMode' : true, 'expectedOutput' : '++-+---+-+ --+++--++- ----------'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}, numericMode: ${elem['numericMode']}', () {
        var _actual = encryptDecabit(elem['input'] as String, (elem['replaceCharacters'] ?? <String, String>{}) as Map<String, String>, elem['numericMode'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Decabit.decryptDecabit:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : null, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : <String, String>{}, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : {'+': '+'}, 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters' : {'+': '+', '-': '-'}, 'numericMode' : false, 'expectedOutput' : ''},

      {'input' : '++-+++----', 'numericMode' : false, 'expectedOutput' : 'A'},
      {'input' : '--++--+++-', 'numericMode' : false, 'expectedOutput' : 'N'},
      {'input' : '+-++++----', 'numericMode' : false, 'expectedOutput' : 'Z'},

      {'input' : '--+-+++-+-', 'numericMode' : true, 'expectedOutput' : '0'},
      {'input' : '++---++--+', 'numericMode' : true, 'expectedOutput' : '63'},
      {'input' : '++++++++++', 'numericMode' : true, 'expectedOutput' : '126'},

      {'input' : '++-+++---- --++--+++- +-++++----', 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '++-+++------++--+++-+-++++----', 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '++-+++----    --++--+++-    +-++++----', 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '+ + - + + + - - - - - - + + - - + + + - + - + + + + - - - -', 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '++-+++---- +-+-++-+-- --++--+++- +-+-++-+-- +-++++----', 'numericMode' : false, 'expectedOutput' : 'A N Z'},
      {'input' : '+-+-++-+-- ++-+++---- +-+-++-+-- --++--+++- +-+-++-+-- +-++++---- +-+-++-+--', 'numericMode' : false, 'expectedOutput' : ' A N Z '},
      {'input' : '+a+b-c+d+e+f-g-h-i-j-k-l+m+n-o-p+q+r+s-t+u-v+w+x+y+z-0-1-2-3', 'numericMode' : false, 'expectedOutput' : 'ANZ'},

      {'input' : '--+-+++-+- ++---++--+ ++++++++++', 'numericMode' : true, 'expectedOutput' : '0 63 126'},
      {'input' : '--+-+++-+-++---++--+++++++++++', 'numericMode' : true, 'expectedOutput' : '0 63 126'},
      {'input' : '--+-+++-+-     ++---++--+     ++++++++++', 'numericMode' : true, 'expectedOutput' : '0 63 126'},
      {'input' : '- - + - + + + - + - + + - - - + + - - + + + + + + + + + + +', 'numericMode' : true, 'expectedOutput' : '0 63 126'},
      {'input' : '-a-b+c-d+e+f+g-h+i-j+k+l-m-n-o+p+q-r-s+t+u+v+w+x+y+z+0+1+2+3', 'numericMode' : true, 'expectedOutput' : '0 63 126'},

      {'input' : '++-+++---- --++--+++- +-++++---- +-+-+-+-+', 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '--+-+++-+- ++---++--+ ++++++++++ +-+-+-+-+', 'numericMode' : true, 'expectedOutput' : '0 63 126'},

      {'input' : '+-+-+-+-+', 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : '+ - + - + - + - +', 'numericMode' : false, 'expectedOutput' : ''},
      {'input' : "ABCabc0123", 'numericMode' : false, 'expectedOutput' : ''},

      {'input' : '0010001111 1100110001 0100001111', 'replaceCharacters': {'+': '0', '-': '1'}, 'numericMode' : false, 'expectedOutput' : 'ANZ'},
      {'input' : '--+---++++ ++--++---+ -+----++++', 'replaceCharacters': {'+': '-', '-': '+'}, 'numericMode' : false, 'expectedOutput' : 'ANZ'},

      {'input' : '1101000101 0011100110 0000000000', 'replaceCharacters': {'+': '0', '-': '1'}, 'numericMode' : true, 'expectedOutput' : '0 63 126'},
      {'input' : '++-+---+-+ --+++--++- ----------', 'replaceCharacters': {'+': '-', '-': '+'}, 'numericMode' : true, 'expectedOutput' : '0 63 126'},

      {'input' : '+-+-++-+--', 'numericMode' : false, 'expectedOutput' : ' '},
      {'input' : '+- +-+-++-+--', 'numericMode' : false, 'expectedOutput' : '>'},
      {'input' : '+- +-+-++-+-- +---+-+++- +-+---+++- -+--++-++- +---+++-+- +-+-++-+-- +-+++---+- +++-++---- +-+-++-+-- -+++--+-+- -+++-+-+-- +++-+---+- -++--+++-- -+-+--+++- +-+-++-+-- +++-++---- ++--+--++- +-+-+---++ +-+-++-+-- +-+---+-++ +-++--+-+- -+-+--+++- +-+-++-+-- ++--+--++- +--+-+-++- ++-++---+- +-+-++-+-- +---+-+++- +-+---+++- -+--', 'numericMode' : false, 'expectedOutput' : '>Grad 47 Punkt 706 Ost 013 Gr'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}, numericMode: ${elem['numericMode']}', () {
        var _actual = decryptDecabit(elem['input'] as String, (elem['replaceCharacters'] ?? <String, String>{}) as Map<String, String>, elem['numericMode']as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}