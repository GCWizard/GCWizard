import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

void main() {
  group("numbersequence.getNumberAt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'sequence' : NumberSequencesMode.CATALAN,          'position' : 30, 'expectedOutput' : BigInt.from(3814986502092304)},
      {'sequence' : NumberSequencesMode.RECAMAN,          'position' : 30, 'expectedOutput' : BigInt.from(45)},
      {'sequence' : NumberSequencesMode.LUCAS,            'position' : 30, 'expectedOutput' : BigInt.from(1860498)},
      {'sequence' : NumberSequencesMode.FIBONACCI,        'position' : 30, 'expectedOutput' : BigInt.from(832040)},
      {'sequence' : NumberSequencesMode.JACOBSTAHL,       'position' : 30, 'expectedOutput' : BigInt.from(357913941)},
      {'sequence' : NumberSequencesMode.JACOBSTHAL_LUCAS, 'position' : 30, 'expectedOutput' : BigInt.from(1073741825)},
      {'sequence' : NumberSequencesMode.PELL,             'position' : 30, 'expectedOutput' : BigInt.from(107578520350)},
      {'sequence' : NumberSequencesMode.MERSENNE_FERMAT,  'position' : 30, 'expectedOutput' : BigInt.from(1073741825)},
      {'sequence' : NumberSequencesMode.MERSENNE,         'position' : 30, 'expectedOutput' : BigInt.from(1073741823)},
      {'sequence' : NumberSequencesMode.PELL_LUCAS,       'position' : 30, 'expectedOutput' : BigInt.from(304278004998)},
      {'sequence' : NumberSequencesMode.FERMAT,           'position' :  5, 'expectedOutput' : BigInt.from(4294967297)},
      {'sequence' : NumberSequencesMode.FACTORIAL,        'position' : 20, 'expectedOutput' : BigInt.from(2432902008176640000)},
      {'sequence' : NumberSequencesMode.LYCHREL,          'position' : 20, 'expectedOutput' : BigInt.from(1767)},
    ];

    for (var elem in _inputsToExpected) {
      test('sequence: ${elem['sequence']}, position: ${elem['position']}', () {
        var _actual = getNumberAt(elem['sequence'] as NumberSequencesMode, elem['position'] as int?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("numbersequence.checkNumber:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'sequence' : NumberSequencesMode.CATALAN,          'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(3814986502092304)},
      {'sequence' : NumberSequencesMode.RECAMAN,          'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(45)},
      {'sequence' : NumberSequencesMode.LUCAS,            'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(1860498)},
      {'sequence' : NumberSequencesMode.FIBONACCI,        'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(832040)},
      {'sequence' : NumberSequencesMode.JACOBSTAHL,       'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(357913941)},
      {'sequence' : NumberSequencesMode.JACOBSTHAL_LUCAS, 'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(1073741825)},
      {'sequence' : NumberSequencesMode.PELL,             'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(107578520350)},
      {'sequence' : NumberSequencesMode.MERSENNE_FERMAT,  'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(1073741825)},
      {'sequence' : NumberSequencesMode.MERSENNE,         'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(1073741823)},
      {'sequence' : NumberSequencesMode.PELL_LUCAS,       'maxIndex' : 100, 'expectedOutput' : 30, 'number' : BigInt.from(304278004998)},
      {'sequence' : NumberSequencesMode.FERMAT,           'maxIndex' : 100, 'expectedOutput' :  5, 'number' : BigInt.from(4294967297)},
      {'sequence' : NumberSequencesMode.FACTORIAL,        'maxIndex' : 100, 'expectedOutput' : 20, 'number' : BigInt.from(2432902008176640000)},
      {'sequence' : NumberSequencesMode.LYCHREL,          'maxIndex' : 100, 'expectedOutput' : 20, 'number' : BigInt.from(1767)},
    ];

    for (var elem in _inputsToExpected) {
      test('sequence: ${elem['sequence']}, number: ${elem['number']}', () {
        var _actual = checkNumber(elem['sequence'] as NumberSequencesMode, elem['number'] as BigInt?, elem['maxIndex'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("numbersequence.getNumbersInRange:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'sequence' : NumberSequencesMode.CATALAN,          'start' : 10, 'stop' : 15, 'expectedOutput' : [16796, 58786, 208012, 742900, 2674440, 9694845]},
      {'sequence' : NumberSequencesMode.RECAMAN,          'start' : 10, 'stop' : 15, 'expectedOutput' : [11, 22, 10, 23, 9, 24]},
      {'sequence' : NumberSequencesMode.LUCAS,            'start' : 10, 'stop' : 15, 'expectedOutput' : [123, 199, 322, 521, 843, 1364]},
      {'sequence' : NumberSequencesMode.FIBONACCI,        'start' : 10, 'stop' : 15, 'expectedOutput' : [55, 89, 144, 233, 377, 610]},
      {'sequence' : NumberSequencesMode.JACOBSTAHL,       'start' : 10, 'stop' : 15, 'expectedOutput' : [341, 683, 1365, 2731, 5461, 10923]},
      {'sequence' : NumberSequencesMode.JACOBSTHAL_LUCAS, 'start' : 10, 'stop' : 15, 'expectedOutput' : [1025, 2047, 4097, 8191, 16385, 32767]},
      {'sequence' : NumberSequencesMode.PELL,             'start' : 10, 'stop' : 15, 'expectedOutput' : [2378,5741,13860,33461,80782,195025]},
      {'sequence' : NumberSequencesMode.MERSENNE_FERMAT,  'start' : 10, 'stop' : 15, 'expectedOutput' : [1025,2049,4097, 8193, 16385, 32769]},
      {'sequence' : NumberSequencesMode.MERSENNE,         'start' : 10, 'stop' : 15, 'expectedOutput' : [1023, 2047, 4095, 8191, 16383, 32767]},
      {'sequence' : NumberSequencesMode.PELL_LUCAS,       'start' : 10, 'stop' : 15, 'expectedOutput' : [6726, 16238, 39202, 94642, 228486, 551614]},
      {'sequence' : NumberSequencesMode.FERMAT,           'start' :  3, 'stop' :  5, 'expectedOutput' : [257, 65537, 4294967297]},
      {'sequence' : NumberSequencesMode.FACTORIAL,        'start' : 10, 'stop' : 15, 'expectedOutput' : [3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000]},
      {'sequence' : NumberSequencesMode.LYCHREL,          'start' : 10, 'stop' : 15, 'expectedOutput' : [887, 978, 986, 1495, 1497]},
    ];

    for (var elem in _inputsToExpected) {
      test('sequence: ${elem['sequence']}, start: ${elem['start']}, stop: ${elem['stop']}', () {
        var _actual = getNumbersInRange(elem['sequence'] as NumberSequencesMode, elem['start'] as int?, elem['stop'] as int?);
        var length = (elem['expectedOutput'] as List<int>).length;
        for (int i = 0; i < length; i++) {
          expect(_actual[i], BigInt.from((elem['expectedOutput'] as List<int>)[i]));
        }
      });
    }
  });

  group("numbersequence.getNumbersWithNDigits:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'sequence' : NumberSequencesMode.CATALAN,          'digits' : 4, 'expectedOutput' : [1430,4862]},
      {'sequence' : NumberSequencesMode.JACOBSTAHL,       'digits' : 4, 'expectedOutput' : [1365,2731,5461]},
      {'sequence' : NumberSequencesMode.JACOBSTHAL_LUCAS, 'digits' : 4, 'expectedOutput' : [1025,2047,4097,8191]},
      {'sequence' : NumberSequencesMode.MERSENNE_FERMAT,  'digits' : 4, 'expectedOutput' : [1025,2049,4097,8193]},
      {'sequence' : NumberSequencesMode.MERSENNE,         'digits' : 4, 'expectedOutput' : [1023,2047,4095,8191]},
      {'sequence' : NumberSequencesMode.FERMAT,           'digits' : 5, 'expectedOutput' : [65537]},
      {'sequence' : NumberSequencesMode.RECAMAN,          'digits' : 2, 'expectedOutput' : [13,20,12,21,11,22,10,23,24,25,43,62,42,63,41,18,42,17,43,16,44,15,45,14,46,79,78,77,39,78,38,79,37,80,36,81,35,82,34,83,33,84,32,85,31,86,30,87,29,88,28,89,27,90,26]},
      {'sequence' : NumberSequencesMode.LUCAS,            'digits' : 4, 'expectedOutput' : [1364,2207,3571,5778,9349]},
      {'sequence' : NumberSequencesMode.FIBONACCI,        'digits' : 4, 'expectedOutput' : [1597,2584,4181,6765]},
      {'sequence' : NumberSequencesMode.PELL,             'digits' : 4, 'expectedOutput' : [2378,5741]},
      {'sequence' : NumberSequencesMode.PELL_LUCAS,       'digits' : 4, 'expectedOutput' : [1154,2786,6726]},
      {'sequence' : NumberSequencesMode.FACTORIAL,        'digits' : 3, 'expectedOutput' : [120,720]},
      {'sequence' : NumberSequencesMode.LYCHREL,          'digits' : 3, 'expectedOutput' : [196, 295, 394, 493, 592, 689, 691, 788, 790, 879, 887, 978, 986]}, // Mark test
    ];

    for (var elem in _inputsToExpected) {
      test('sequence: ${elem['sequence']}, digits: ${elem['digits']}', () {
        var _actual = getNumbersWithNDigits(elem['sequence'] as NumberSequencesMode, elem['digits'] as int?);
        var length = (elem['expectedOutput'] as List<Object>).length;
        for (int i = 0; i < length; i++) {
          if (_actual[i].runtimeType.toString() == 'String') {
            expect(BigInt.parse(_actual[i].toString()), BigInt.from((elem['expectedOutput'] as List<int>)[i]));
          } else {
            expect(_actual[i], BigInt.from((elem['expectedOutput'] as List<int>)[i]));
          }
        }
      });
    }
  });

  group("numbersequence.getFirstPositionOfSequence:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'sequence' : NumberSequencesMode.CATALAN,          'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('7107690250413013761896628105173181658589772625392889208165477368352734802736195805963143770815133859332929972050727625767936724822523808745285247568658130484108957872094022098605943811100613700',
          327, 73)},
      {'sequence' : NumberSequencesMode.RECAMAN,          'maxIndex' : 90000, 'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('273610',
          83075, 1)},
      {'sequence' : NumberSequencesMode.LUCAS,            'maxIndex' : 1500,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('18748771816031882432361279585437379027793299399977527519157412464660965640249644313681249312162162629997750374920749068562512008441470175698571763320577336460472736199197895450368969873315889049038863774234995048085554243',
          1054, 161)},
      {'sequence' : NumberSequencesMode.FIBONACCI,        'maxIndex' : 1200,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('192825882676106134378869728155374187660112414871811939193829103432318224700718717483263710524617634117161273616072137461357355627213312950037507329891012147460930383989353659980559007148865250358951233784907640314179868106583934968628863665186',
          1161, 106)},
      {'sequence' : NumberSequencesMode.JACOBSTAHL,       'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('2590225189634305427892615875764691875523209118736186028335749879651872380273611330901',
          282, 74)},
      {'sequence' : NumberSequencesMode.JACOBSTHAL_LUCAS, 'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('6546781215792283740026379393655198304433284092086129578966582736192267592809349109766540184651808314301773368255120142018434513091770786106657055178751',
          501, 61)},
      {'sequence' : NumberSequencesMode.PELL,             'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('20384220119784227273612728531358390881151829634178',
          130, 18)},
      {'sequence' : NumberSequencesMode.MERSENNE_FERMAT,  'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('6546781215792283740026379393655198304433284092086129578966582736192267592809349109766540184651808314301773368255120142018434513091770786106657055178753',
          501, 61)},
      {'sequence' : NumberSequencesMode.MERSENNE,         'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('6546781215792283740026379393655198304433284092086129578966582736192267592809349109766540184651808314301773368255120142018434513091770786106657055178751',
          501, 61)},
      {'sequence' : NumberSequencesMode.PELL_LUCAS,       'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('29774604858329219664456332466656921673276471399199273612561389350268513626587176095809188915836887219380276486',
          286, 51)},
      {'sequence' : NumberSequencesMode.FERMAT,           'maxIndex' : 1000,  'number' : '23731', 'expectedOutput' : PositionOfSequenceOutput('115792089237316195423570985008687907853269984665640564039457584007913129639937',
          8, 10)},
      {'sequence' : NumberSequencesMode.FACTORIAL,        'maxIndex' : 1000,  'number' : '27361', 'expectedOutput' : PositionOfSequenceOutput('23253512673402975649030219517802388212008068837208869508318464355013920279143899108672994147315919703030880622767679396866340190791013489376711460575586621328808078030221607416835754080915509200193567689830381661447084331787366822584467958045707956215554076622321971107403773482677717770719835479561276613084367632005431955656279435291455206551540853209029847006303117120940193077621247832444065125486279435774814422901201765327214272114274216760930417792134750312836895272433618482621109490451324448449864059857201278688531263992450359151349011478401428811903933154714395422786107367084702200161958717726513651427362699388705379318219964600238769420372143927905797647339003145382760152194331251723435182249367538832250671077443541255757685857545473824310812120959584596053559251742941120812453454520929229292999042732707443975099682870572564608273195076736602858239049990379586682574344643100262157360191426239851065045323629593980291244200960315535850206717970892248287218349093197402045548057599056802262219585058251212685414973657747800129308945588637703832589017356695817144461662048084676024098030325113360716882736185580558745600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
          549, 1118)},
      {'sequence' : NumberSequencesMode.LYCHREL,          'maxIndex' : 1000,  'number' : '996', 'expectedOutput' : PositionOfSequenceOutput('2996',
          38, 2)},
    ];

    for (var elem in _inputsToExpected) {
      test('sequence: ${elem['sequence']}, number: ${elem['start']}', () {
        PositionOfSequenceOutput _actual = getFirstPositionOfSequence(elem['sequence'] as NumberSequencesMode, elem['number'] as String?, elem['maxIndex'] as int);
        expect(_actual.number, (elem['expectedOutput'] as PositionOfSequenceOutput).number);
        expect(_actual.positionSequence, (elem['expectedOutput'] as PositionOfSequenceOutput).positionSequence);
        expect(_actual.positionDigits, (elem['expectedOutput'] as PositionOfSequenceOutput).positionDigits);
      });
    }
  });


}