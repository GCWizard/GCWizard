/*
Anne Solberg
Norsk Teknisk Museum, Oslo
 */

import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

const _CODEBOOK_OHLSEN = {
  '000': 'seilere sees, som kommme vestlig fra.',
  '001': 'seilere sees, som kommer nord fra.',
  '002': 'seilere sees, som kommer sydlig fra.',
  '003': 'det er krigsskibe, som sees.',
  '004': 'skibene, som sees, ere fiend tlige.',
  '005': 'skibene, som sees, ere danske.',
  '006': 'de skibe, som sees, bestaae af orlogsskibe, fregatter og andre krigsfartøier og ere i antal.',
  '007': 'de skibe, som sees, ere orlogsskibe.',
  '008': 'de skibe, som sees, ere fregatter',
  '009': 'de skibe, som sees , ere smaa krigsskibe og bestaae af brigger og mindre fartøier.',
  '010': 'de skibe, som sees, ere stevnbevæpnede roe fartøier.',
  '011': 'med skibene følge en transportflaade',
  '012': 'de signalerede skibe seile ind efter',
  '013': 'de signalerede skibe seile nord efter.',
  '014': 'de signalerede skibe styre mod Landet.',
  '015': 'de signalerede skibe styre fra Landet.',
  '016': 'de signalerede skibe løbe ind i en havn sønden for mig.',
  '017': 'de signalerede skibe løbe ind i en havn norden for mig.',
  '018': 'de fiendtlige skibe slaaes med vore.',
  '019': 'vore skibe behøve undsætning og hielp.',
  '020': 'vore skibe have fordeel før fienden.',
  '021': 'fienden giør landgang sønden for mig.',
  '022': 'fienden giør landgang norden for mig.',
  '023': 'den fiendtlige landgang skeer med mindre end end 100 mand. ',
  '024': 'den fiendtlige landgang skeer med over 100 mand.',
  '025': 'den fiendtlige landgang skeer med nogle hundrede mand.',
  '026': 'den fiendtlige landgang skeer med 1000 mand og derover.',
  '027': 'fartøier ere ankomne fra danmark.',
  '028': 'fartøier ere ankomne fra archangel.',
  '029': 'fienden har jaget og taget et af vore krigsfartøier.',
  '030': 'vore krigsfartøier have bemæstret dem et fiendtligt fartøi.',
  '031': 'fienden jager et -dansk fartøi, som trænger til undsæ tning.',
  '032': 'de signalerede skibe ere ud af Sigte.',
  '033': 'de signalerede skibe holde det krydsende ved kysten.',
  '034': 'den fiendtlige landgang er bevirket.',
  '035': 'den fiendtlige landgang ere afslaaet.',
  '036': 'meer hielp maa tilsendes kystbevogterne.',
  '037': 'skydning høres sønder fra.',
  '038': 'skydning høres nord fra.',
  '039': 'signalet kommer fra hovedstation	a.',
  '040': 'signalet kommer fra hovedstation	b.',
  '041': 'signalet kommer fra hovedstation	c.',
  '042': 'signalet kommer fra hovedstation	d.',
  '043': 'signalet kommer fra hovedstation	e.',
  '044': 'signalet kommer fra hovedstation	f.',
  '045': 'signalet kommer fra hovedstation	g.',
  '046': 'signalet kommer fra hovedstation	h.',
  '047': 'signalet kommer fra hovedstation	i.',
  '048': 'signalet kommer fra hovedstation	k.',
  '049': '-',
  '050': '-',
  '051': '-',
  '052': '-',
  '053': '-',
  '054': '-',
  '055': '-',
  '056': '-',
  '057': '-',
  '058': '-',
  '059': '-',
  '060': 'skydning høres vester fra.',
  '061': 'nordlandsfarere ere komne nord fra.',
  '062': 'nordlandsfarere er kom e syd fra.',
  '063': 'det er sandsynlig at fienden vil giøre an attaque paa christiansund.',
  '064': 'det er sandsynlig at fienden vil trænge ind at Fiordene norden for christiansund.',
  '065': 'de signalerede Skibe ere handelsskibe, som seile eller krydse langs kysten.',
  '066': 'fienden begynder anfaldet.',
  '067': 'fienden er tilbagedrevet. ',
  '068': 'vi have lidt meget.',
  '069': 'vort tab er ubetydeligt.',
  '070': 'efterretninger haves, at fienden har giort et anfald i bergens stift.',
  '071': 'efterretninger haves, at fienden har giort et anfald i christiansands stift.',
  '072': 'efterretninger haves, at fienden har giort et anfald i aggershuus stift.',
  '073': 'fienden har seiret.',
  '074': 'fienden er afslaaet.',
  '075': 'et dansk eller norsk Skib er strandet og gives hielp.',
  '076': 'et fiendtlig Skib er strandet paa kysten; man beimægtiger sig vraget og folkene .',
  '077': 'det strandede skib er betydeligt.',
  '078': 'det strandede skib er ubetydeljgt.',
  '079': 'en konvoi ligger færdig, til at omgaae stat sønder efter.',
  '080': 'i dette Øieblik afgaar konvoien sønder efter.',
  '081': 'i dag, indtil Øieblikket; have ingen seilere viist sig paa kysten.',
  '082': '-',
  '083': '-',
  '084': '-',
  '085': '-',
  '086': '-',
  '087': '-',
  '088': '-',
  '089': '-',
  '090': '-',
  '091': '-',
  '092': '-',
  '093': '-',
  '094': '-',
  '095': '-',
  '096': '-',
  '097': '-',
  '098': '-',
  '099': '-',
  '100': '-',
  '101': '-',
  '102': '-',
  '103': '-',
  '104': '-',
  '105': '-',
  '106': '-',
  '107': '-',
  '108': '-',
  '109': '-',
  '110': '-',
  '111': '-',
  '112': '-',
  '113': '-',
  '114': '-',
  '115': '-',
  '116': '-',
  '117': '-',
  '118': '-',
  '119': '-',
  '120': '-',
  '121': '-',
  '122': '-',
  '123': '-',
  '124': '-',
  '125': '-',
  '126': '-',
  '127': '-',
  '128': '-',
  '129': '-',
  '130': '-',
  '131': '-',
  '132': '-',
  '133': '-',
  '134': '-',
  '135': '-',
  '136': '-',
  '137': '-',
  '138': '-',
  '139': '-',
  '140': '-',
  '141': '-',
  '142': '-',
  '143': '-',
  '144': '-',
  '145': '-',
  '146': '-',
  '147': '-',
  '148': '-',
  '149': '-',
  '150': '-',
  '151': '-',
  '152': '-',
  '153': '-',
  '154': '-',
  '155': '-',
  '156': '-',
  '157': '-',
  '158': '-',
  '159': '-',
  '160': '-',
  '161': '-',
  '162': '-',
  '163': '-',
  '164': '-',
  '165': '-',
  '166': '-',
  '167': '-',
  '168': '-',
  '169': '-',
  '170': '-',
  '171': '-',
  '172': '-',
  '173': '-',
  '174': '-',
  '175': '-',
  '176': '-',
  '177': '-',
  '178': '-',
  '179': '-',
  '180': '-',
  '181': '-',
  '182': '-',
  '183': '-',
  '184': '-',
  '185': '-',
  '186': '-',
  '187': '-',
  '188': '-',
  '189': '-',
  '190': '-',
  '191': '-',
  '192': '-',
  '193': '-',
  '194': '-',
  '195': '-',
  '196': '-',
  '197': '-',
  '198': '-',
  '199': '-',
  '200': '-',
  '201': '-',
  '202': '-',
  '203': '-',
  '204': '-',
  '205': '-',
  '206': '-',
  '207': '-',
  '208': '-',
  '209': '-',
  '210': '-',
  '211': '-',
  '212': '-',
  '213': '-',
  '214': '-',
  '215': '-',
  '216': '-',
  '217': '-',
  '218': '-',
  '219': '-',
  '220': '-',
  '221': '-',
  '222': '-',
  '223': '-',
  '224': '-',
  '225': '-',
  '226': '-',
  '227': '-',
  '228': '-',
  '229': '-',
  '230': '-',
  '231': '-',
  '232': '-',
  '233': '-',
  '234': '-',
  '235': '-',
  '236': '-',
  '237': '-',
  '238': '-',
  '239': '-',
  '240': '-',
  '241': '-',
  '242': '-',
  '243': '-',
  '244': '-',
  '245': '-',
  '246': '-',
  '247': '-',
  '248': '-',
  '249': '-',
  '250': '-',
  '251': '-',
  '252': '-',
  '253': '-',
  '254': '-',
  '255': '-',
  '256': '-',
  '257': '-',
  '258': '-',
  '259': '-',
};

Segments encodeOhlsenTelegraph(String input) {
  if (input.isEmpty) return Segments.Empty();

  List<List<String>> encodedText = [];
  var CODEBOOK = switchMapKeyValue(_CODEBOOK_OHLSEN);

  if (CODEBOOK[input] != null) encodedText.add(_buildShutters(CODEBOOK[input]!));

  input.split('').forEach((element) {
    if (CODEBOOK[element] != null) encodedText.add(CODEBOOK[element]!.split(''));
  });
  return Segments(displays: encodedText);
}

SegmentsCodpoints decodeVisualOhlsenTelegraph(List<String>? inputs) {
  if (inputs == null || inputs.isEmpty) {
    return SegmentsCodpoints(displays: <List<String>>[], text: '', codepoints: '');
  }

  var displays = <List<String>>[];
  List<String> codepoints = [];
  var segment = <String>[];
  String text = '';

  for (var element in inputs) {
    segment = _stringToSegment(element);
    displays.add(segment);
    codepoints.add(segmentToCode(segment));
    text = text + (_CODEBOOK_OHLSEN[segmentToCode(segment)] ?? UNKNOWN_ELEMENT);
  }

  return SegmentsCodpoints(displays: displays, text: text, codepoints: codepoints.join(' '));
}

SegmentsCodpoints decodeTextOhlsenTelegraph(String inputs) {
  if (inputs.isEmpty) SegmentsCodpoints(displays: <List<String>>[], text: '', codepoints: '');

  var displays = <List<String>>[];
  String text = '';

  inputs.split(' ').forEach((element) {
    element = element.padLeft(3, '0');
    text = text + (_CODEBOOK_OHLSEN[element] ?? UNKNOWN_ELEMENT);

    displays.add(_buildShutters(element));
  });
  return SegmentsCodpoints(displays: displays, text: text, codepoints: '');
}

List<String> _stringToSegment(String input) {
  List<String> result = [];
  for (int i = 0; i < input.length / 3; i++) {
    result.add(input.substring(i * 3, i * 3 + 3));
  }
  return result;
}

String segmentToCode(List<String> segment) {
  int a = 0;

  if (segment.contains('a1o')) a = a + 100;
  if (segment.contains('a1u')) a = a + 3;
  if (segment.contains('a2o')) a = a + 10;
  if (segment.contains('a2u')) a = a + 40;
  if (segment.contains('b1o')) a = a + 1;
  if (segment.contains('b1u')) a = a + 4;
  if (segment.contains('b2o')) a = a + 20;
  if (segment.contains('b2u')) a = a + 50;
  if (segment.contains('c1o')) a = a + 2;
  if (segment.contains('c1u')) a = a + 5;
  if (segment.contains('c2o')) a = a + 30;
  if (segment.contains('c2u')) a = a + 60;

  if (a < 10) return '00' + a.toString();
  if (a < 100) return '0' + a.toString();
  return a.toString();
}

List<String> _buildShutters(String segments) {
  List<String> resultElement = [];
  int codepoint = 0;
  if (int.tryParse(segments) != null) {
    codepoint = int.parse(segments);

    switch (codepoint % 10) {
      case 1:
        resultElement.add('b1o');
        codepoint = codepoint - 1;
        break;
      case 2:
        resultElement.add('c1o');
        codepoint = codepoint - 2;
        break;
      case 3:
        resultElement.add('a1u');
        codepoint = codepoint - 3;
        break;
      case 4:
        resultElement.add('b1u');
        codepoint = codepoint - 4;
        break;
      case 5:
        resultElement.add('c1u');
        codepoint = codepoint - 5;
        break;
      case 6:
        resultElement.add('b1o');
        resultElement.add('c1u');
        codepoint = codepoint - 6;
        break;
      case 7:
        resultElement.add('b1u');
        resultElement.add('c1u');
        codepoint = codepoint - 7;
        break;
      case 8:
        resultElement.add('a1u');
        resultElement.add('c1u');
        codepoint = codepoint - 8;
        break;
      case 9:
        resultElement.add('b1u');
        resultElement.add('c1u');
        codepoint = codepoint - 9;
        break;
    }

    if (codepoint >= 200) {
      resultElement.add('a1o');
      codepoint = codepoint - 100;
    }
    if (codepoint == 150) {
      resultElement.add('c2u');
      resultElement.add('b2u');
      resultElement.add('a2u');
      codepoint = codepoint - 1500;
    }
    if (codepoint == 110) {
      if (resultElement.contains('a1o')) {
        resultElement.add('c2u');
        resultElement.add('b2u');
      } else {
        resultElement.add('a1o');
        resultElement.add('a2o');
      }
      codepoint = codepoint - 110;
    }
    if (codepoint == 100) {
      if (resultElement.contains('a1o')) {
        resultElement.add('c2u');
        resultElement.add('a2u');
      } else {
        resultElement.add('a1o');
      }
      codepoint = codepoint - 100;
    }

    switch (codepoint % 100) {
      case 10:
        resultElement.add('a2o');
        codepoint = codepoint - 10;
        break;
      case 20:
        resultElement.add('b2o');
        codepoint = codepoint - 20;
        break;
      case 30:
        resultElement.add('c2o');
        codepoint = codepoint - 30;
        break;
      case 40:
        resultElement.add('a2u');
        codepoint = codepoint - 40;
        break;
      case 50:
        resultElement.add('b2u');
        codepoint = codepoint - 50;
        break;
      case 60:
        resultElement.add('c2u');
        codepoint = codepoint - 60;
        break;
      case 70:
        resultElement.add('c2o');
        resultElement.add('a2u');
        codepoint = codepoint - 70;
        break;
      case 80:
        resultElement.add('b2u');
        resultElement.add('c2o');
        codepoint = codepoint - 80;
        break;
      case 90:
        resultElement.add('a2u');
        resultElement.add('b2u');
        codepoint = codepoint - 90;
        break;
    }
  }
  return resultElement;
}
