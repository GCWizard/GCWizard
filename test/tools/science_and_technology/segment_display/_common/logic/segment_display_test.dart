import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/constants.dart';

void main() {
  group("SegmentDisplay.encodeSegment:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': []},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g'], ['c', 'd', 'e', 'f', 'g']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c']]},

      {'input' : '.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp']]},
      {'input' : '..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'],['dp']]},
      {'input' : '1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b','c','dp']]},
      {'input' : '1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b','c','dp'],['dp']]},
      {'input' : '.1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['b', 'c', 'dp']]},
      {'input' : '.1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['b', 'c', 'dp'], ['dp']]},
      {'input' : '..1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['dp'], ['b', 'c', 'dp']]},
      {'input' : '..1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['dp'], ['b', 'c', 'dp'], ['dp']]},
      {'input' : '11.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c'], ['b', 'c', 'dp']]},
      {'input' : '1.1', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['b', 'c']]},
      {'input' : '1.1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['b', 'c', 'dp']]},
      {'input' : '.1.1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['b', 'c', 'dp'], ['b', 'c', 'dp']]},
      {'input' : '..1.1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['dp'], ['b', 'c', 'dp'], ['b', 'c', 'dp']]},
      {'input' : '..1.1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['dp'], ['b', 'c', 'dp'], ['b', 'c', 'dp'], ['dp']]},
      {'input' : '1..1', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['dp'], ['b', 'c']]},
      {'input' : '1..1.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['dp'], ['b', 'c', 'dp']]},
      {'input' : '1..1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['dp'], ['b', 'c', 'dp'], ['dp']]},
      {'input' : '..1..1..', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'], ['dp'], ['b', 'c', 'dp'], ['dp'], ['b', 'c', 'dp'], ['dp']]},
      {'input' : '1.11', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['b', 'c'], ['b', 'c']]},
      {'input' : '1.11.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c', 'dp'], ['b', 'c'], ['b', 'c', 'dp']]},

      {'input' : ' ', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [<String>[]]},
      {'input' : '  ', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [<String>[],<String>[]]},
      {'input' : ' .', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp']]},
      {'input' : '  .', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [<String>[],['dp']]},
      {'input' : '1 1', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['b', 'c'], <String>[], ['b', 'c']]},

      {'input' : 'ö', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': []},
      {'input' : 'öa', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g']]},
      {'input' : 'ö.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp']]},
      {'input' : 'aö', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g']]},
      {'input' : '.ö', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp']]},
      {'input' : 'aö.', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g', 'dp']]},
      {'input' : '.öa', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'],['a', 'b', 'c', 'e', 'f', 'g']]},
      {'input' : 'ö.a', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': [['dp'],['a', 'b', 'c', 'e', 'f', 'g']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': [['1', '2', '3', '5', '6', '7']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput':  [['1', '2', '3', '5', '6', '7'], ['3', '4', '5', '6', '7']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': [['2', '3']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': [['1', '2', '4', '5', '7']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': []},


      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': [['b', 'c','j']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': [['a', 'b', 'd', 'e', 'g1', 'g2']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': [['j', 'k']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': [['b', 'c','j']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': [['a', 'b', 'd', 'e', 'g1', 'g2']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': [['j', 'm']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'n', 'j']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'n', 'j'], ['a', 'b', 'c', 'd', 'j', 'g', 'l']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': [['b', 'c', 'h']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': [['a', 'b', 'd', 'e', 'n', 'j']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': [['h', 'm']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'm', 's']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': [['b', 'c', 'n']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': [['a', 'b', 'd', 'e', 'g1', 'g2']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': [['n', 'r']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'p', 'k']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'p', 'k'], ['a', 'b', 'c', 'd', 'k', 'h', 'm']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': [['b', 'c','j']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': [['a', 'b', 'd', 'e', 'p', 'k']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': [['j', 'n']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'j', 'm']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': [['b', 'c', 'k']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': [['a', 'b', 'd', 'e', 'g1', 'g2']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': [['k', 'n']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g', 'm']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g', 'm'], ['a', 'b', 'c', 'd', 'm', 'j', 'p']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': [['b', 'c', 'k']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput':  [['a', 'b', 'd', 'e', 'g', 'm']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': [['k', 'q']]},


      {'input' : 'A', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2'],['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2', 'i', 'l']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['b', 'c','j']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['a1', 'a2', 'b', 'd1', 'd2', 'e', 'g1', 'g2']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['j', 'k']]},

      {'input' : 'A', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': [['a', 'b', 'c', 'd', 'g', 'h', 'u', 'p']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': [['a', 'b', 'c', 'd', 'g', 'h', 'u', 'p'],['a', 'b', 'c', 'd', 'e', 'f', 'p', 'm', 's']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': [['c', 'd', 'n']]},
      {'input' : '2', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': [['a', 'b', 'c', 'e', 'f', 'g', 'u', 'p']]},
      {'input' : '/', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': [['n', 't']]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, segmentType: ${elem['segmentType']}', () {
        var _actual = encodeSegment(elem['input'] as String, elem['segmentType'] as SegmentDisplayType);
        expect(_actual.displays, elem['expectedOutput']);
      });
    }
  });

  group("SegmentDisplay.decodeSegment:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[], text: '')},

      {'input' : 'bc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},
      {'input' : 'bc bc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c'],['b','c']], text: '11')},
      {'input' : 'bbcc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},

      {'input' : 'cb', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},

      {'input' : 'ba', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['a','b']], text: UNKNOWN_ELEMENT)},
      {'input' : 'a', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['a']], text: UNKNOWN_ELEMENT)},
      {'input' : 'bc a', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c'],['a']], text: '1' + UNKNOWN_ELEMENT)},
      {'input' : 'a cb', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['a'],['b','c']], text: UNKNOWN_ELEMENT + '1')},
      {'input' : 'a CB', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['a'],['b','c']], text: UNKNOWN_ELEMENT + '1')},

      {'input' : 'z', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : 'z bc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},
      {'input' : 'bc z', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},
      {'input' : 'bczbc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c'],['b','c']], text: '11')},
      {'input' : 'bczzz zzzbc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['b','c'],['b','c']], text: '11')},

      {'input' : 'dp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['dp']], text: '.')},
      {'input' : 'dpdp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays:[['dp']], text: '.')},
      {'input' : 'dp dp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['dp'], ['dp']], text: '..')},
      {'input' : 'bcdp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['b', 'c', 'dp']], text: '1.')},
      {'input' : 'bc dp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['b', 'c'], ['dp']], text: '1.')},
      {'input' : 'bcdp dp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['b', 'c', 'dp'], ['dp']], text: '1..')},
      {'input' : 'dpcb bdpc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['b', 'c', 'dp'], ['b', 'c', 'dp']], text: '1.1.')},
      {'input' : 'dp bc', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['dp'], ['b', 'c']], text: '.1')},
      {'input' : 'dp bcdp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['dp'], ['b', 'c', 'dp']], text: '.1.')},
      {'input' : 'dp bcdpdp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['dp'], ['b', 'c', 'dp']], text: '.1.')},
      {'input' : 'dp bcdp dp', 'segmentType' : SegmentDisplayType.SEVEN, 'expectedOutput': SegmentsText(displays: [['dp'], ['b', 'c', 'dp'], ['dp']], text: '.1..')},

      {'input' : '23 12457', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': SegmentsText(displays:[['b', 'c'], ['a', 'b', 'd', 'e', 'g']], text: '12')},

      {'input' : '23 12457', 'segmentType' : SegmentDisplayType.SEVENAUTO, 'expectedOutput': SegmentsText(displays:[['b', 'c'], ['a', 'b', 'd', 'e', 'g']], text: '12')},
      {'input' : 'cb', 'segmentType' : SegmentDisplayType.SEVENAUTO, 'expectedOutput': SegmentsText(displays:[['b','c']], text: '1')},

      {'input' : '123567', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g']], text: 'A')},
      {'input' : '123567 34567', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g'], ['c', 'd', 'e', 'f', 'g']], text: 'AB')},
      {'input' : '23', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': SegmentsText(displays:[['b', 'c']], text: '1')},
      {'input' : '12457', 'segmentType' : SegmentDisplayType.SEVEN12345678, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g']], text: '2')},

      {'input' : 'abcefg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefg1g2 abcdg2il', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bcj', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdeg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'jk', 'segmentType' : SegmentDisplayType.FOURTEEN, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefg1g2 abcdg2il', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bcj', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdeg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'jm', 'segmentType' : SegmentDisplayType.FOURTEEN_HIJ_G1G2_MLK, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefnj', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefnj abcdjgl', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bch', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdenj', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'hm', 'segmentType' : SegmentDisplayType.FOURTEEN_PGH_NJ_MLK, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefg1g2 abcdg2ms', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bcn', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdeg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'nr', 'segmentType' : SegmentDisplayType.FOURTEEN_KMN_G1G2_RST, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefpk', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefpk abcdkhm', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bcj', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdepk', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'jn', 'segmentType' : SegmentDisplayType.FOURTEEN_GHJ_PK_NMI, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefg1g2 abcdg2jm', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bck', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdeg1g2', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'kn', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_G1G2_NML, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefgm', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcefgm abcdmjp', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'bck', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': SegmentsText(displays:[['b', 'c','j']], text: '1')},
      {'input' : 'abdegm', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'd', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'kq', 'segmentType' : SegmentDisplayType.FOURTEEN_HJK_GM_QPN, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},

      {'input' : 'abcefg1g2 abcdg2il', 'segmentType' : SegmentDisplayType.FOURTEENAUTO, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'abcefnj abcdjgl', 'segmentType' : SegmentDisplayType.FOURTEENAUTO, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'abcefg1g2 abcdg2ms', 'segmentType' : SegmentDisplayType.FOURTEENAUTO, 'expectedOutput': SegmentsText(displays:[['a', 'b', 'c', 'e', 'f', 'g1', 'g2'], ['a', 'b', 'c', 'd', 'g2', 'i', 'l']], text: 'AB')},


      {'input' : 'a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'a1a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'ba1a2c', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1','a2','b','c']], text: '7')},

      {'input' : 'b1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : 'a1 b1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'a1 b1a2', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1'],['a2']], text: UNKNOWN_ELEMENT * 2)},
      {'input' : 'a3', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : 'b1a', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : '1a', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : '1a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays: [['a1']], text: UNKNOWN_ELEMENT)},

      {'input' : 'abcdghup', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'abcdghup abcdefpms', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2'],['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2', 'i', 'l']], text: 'AB')},
      {'input' : 'cdn', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['b', 'c', 'j']], text: '1')},
      {'input' : 'abcefgup', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['a1', 'a2', 'b', 'd1', 'd2', 'e', 'g1', 'g2']], text: '2')},
      {'input' : 'nt', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['j', 'k']], text: '/')},
      {'input' : 'cdn', 'segmentType' : SegmentDisplayType.SIXTEEN_KMN_UP_TSR, 'expectedOutput': SegmentsText(displays:[['b', 'c', 'j']], text: '1')},

      {'input' : 'abcdghup', 'segmentType' : SegmentDisplayType.SIXTEENAUTO, 'expectedOutput': SegmentsText(displays:[['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2']], text: 'A')},
      {'input' : 'ba1a2c', 'segmentType' : SegmentDisplayType.SIXTEENAUTO, 'expectedOutput': SegmentsText(displays:[['a1','a2','b','c']], text: '7')},
      {'input' : 'cdn', 'segmentType' : SegmentDisplayType.SIXTEENAUTO, 'expectedOutput': SegmentsText(displays:[['b', 'c', 'j']], text: '1')},


    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, segmentType: ${elem['segmentType']}', () {
        var _actual = decodeSegment(elem['input'] as String, elem['segmentType'] as SegmentDisplayType);
        var expected  = elem['expectedOutput'] as SegmentsText;
        expect(_actual.text, expected.text);
        expect(_actual.displays, expected.displays);
      });
    }
  });
}