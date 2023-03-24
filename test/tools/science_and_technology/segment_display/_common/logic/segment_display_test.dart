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

      {'input' : 'A', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2']]},
      {'input' : 'AB', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['a1', 'a2', 'b', 'c', 'e', 'f', 'g1', 'g2'],['a1', 'a2', 'b', 'c', 'd1', 'd2', 'g2', 'i', 'l']]},
      {'input' : '1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': [['b', 'c','j']]},

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

      {'input' : 'a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'a1a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'ba1a2c', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1','a2','b','c']], text: '7')},

      {'input' : 'b1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : 'a1 b1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1']], text: UNKNOWN_ELEMENT)},
      {'input' : 'a1 b1a2', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[['a1'],['a2']], text: UNKNOWN_ELEMENT * 2)},
      {'input' : 'a3', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : 'b1a', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : '1a', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays:[], text: '')},
      {'input' : '1a1', 'segmentType' : SegmentDisplayType.SIXTEEN, 'expectedOutput': SegmentsText(displays: [['a1']], text: '<?>')},

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