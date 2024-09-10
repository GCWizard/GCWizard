import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/navajo/logic/navajo.dart';

void main() {

  String in1 =  'COMMANDING GEN. MILLER ATTACK BOMBER PLANE NORTH FOUR FIVE ZERO PILL BOX TWO';
  String in2 =  'TWO';
  String in3 =  'BEISPIEL';
  String in4 =  'CACHE AT NORTH FIVE SUX EIGHT EAST ZERO ONE NINE';
  String o1k =  'COMMANDING GEN . <?>MILLER ATTACK BOMBER PLANE NORTH FOUR FIVE ZERO PILL BOX TWO';
  String o1d =  'COMMANDING GEN. . MILLERATTACKBOMBER PLANENORTHFOURFIVEZEROPILL BOXTWO';
  String o2 =  'TWO';
  String o3 =  'BEISPIEL';
  String o4k =  'CACHE AT NORTH FIVE SUX EIGHT EAST ZERO ONE NINE';
  String o4d =  'CACHEATNORTHFIVESUXEIGHTEASTZEROONENINE';

  String oK11 = 'MOASI NE-AHS-JAH NA-AS-TSO-SI NA-AS-TSO-SI WOL-LA-CHEE NESH-CHEE BE TKIN NESH-CHEE KLIZZIE  KLIZZIE DZEH NESH-CHEE .  NA-AS-TSO-SI TKIN DIBEH-YAZZIE DIBEH-YAZZIE DZEH GAH  WOL-LA-CHEE THAN-ZIE THAN-ZIE WOL-LA-CHEE MOASI KLIZZIE-YAZZIE  SHUSH NE-AHS-JAH NA-AS-TSO-SI SHUSH DZEH GAH  BI-SO-DIH DIBEH-YAZZIE WOL-LA-CHEE NESH-CHEE DZEH  NESH-CHEE NE-AHS-JAH GAH THAN-ZIE LIN  MA-E NE-AHS-JAH NO-DA-IH GAH  MA-E TKIN A-KEH-DI-GLINI DZEH  BESH-DO-TLIZ DZEH GAH NE-AHS-JAH  BI-SO-DIH TKIN DIBEH-YAZZIE DIBEH-YAZZIE  SHUSH NE-AHS-JAH AL-NA-AS-DZOH  THAN-ZIE GLOE-IH NE-AHS-JAH';
  String oK12 = 'MOASI NE-AHS-JAH NA-AS-TSO-SI NA-AS-TSO-SI WOL-LA-CHEE NESH-CHEE BE TKIN NESH-CHEE KLIZZIE KLIZZIE DZEH NESH-CHEE  NA-AS-TSO-SI TKIN DIBEH-YAZZIE DIBEH-YAZZIE DZEH GAH  WOL-LA-CHEE THAN-ZIE THAN-ZIE WOL-LA-CHEE MOASI KLIZZIE-YAZZIE  SHUSH NE-AHS-JAH NA-AS-TSO-SI SHUSH DZEH GAH BI-SO-DIH DIBEH-YAZZIE WOL-LA-CHEE NESH-CHEE DZEH  NESH-CHEE NE-AHS-JAH GAH THAN-ZIE LIN  MA-E NE-AHS-JAH NO-DA-IH GAH  MA-E TKIN A-KEH-DI-GLINI DZEH  BESH-DO-TLIZ DZEH GAH NE-AHS-JAH  BI-SO-DIH TKIN DIBEH-YAZZIE DIBEH-YAZZIE SHUSH NE-AHS-JAH AL-NA-AS-DZOH  THAN-ZIE GLOE-IH NE-AHS-JAH';
  String oK2 = 'THAN-ZIE GLOE-IH NE-AHS-JAH';
  String oK3 = 'SHUSH DZEH TKIN DIBEH BI-SO-DIH TKIN DZEH DIBEH-YAZZIE';
  String oK4 = 'MOASI WOL-LA-CHEE MOASI LIN DZEH  WOL-LA-CHEE THAN-ZIE  NESH-CHEE NE-AHS-JAH GAH THAN-ZIE LIN  MA-E TKIN A-KEH-DI-GLINI DZEH  DIBEH NO-DA-IH AL-NA-AS-DZOH  DZEH TKIN KLIZZIE LIN THAN-ZIE  DZEH WOL-LA-CHEE DIBEH THAN-ZIE  BESH-DO-TLIZ DZEH GAH NE-AHS-JAH  NE-AHS-JAH NESH-CHEE DZEH  NESH-CHEE TKIN NESH-CHEE DZEH';
  //
  // encodings from dcode.de
  String oD1 = 'BA-GOSHI NE-AHS-JAH BE-TAS-TNI NA-AS-TSO-SI TSE-NILL TSAH CHINDI YEH-HES TSAH KLIZZIE JEHA AH-NAH TSAH . BE-TAS-TNI TKIN AH-JAD AH-JAD AH-JAH DAH-NES-TSA TSE-NILL D-AH THAN-ZIE BE-LA-SANA MOASI BA-AH-NE-DI-TININ SHUSH TLO-CHIN NA-AS-TSO-SI SHUSH DZEH DAH-NES-TSA NE-ZHONI NASH-DOIE-TSO WOL-LA-CHEE TSAH AH-NAH A-CHIN A-KHA DAH-NES-TSA A-WOH LIN MA-E TLO-CHIN SHI-DA GAH MA-E A-CHI A-KEH-DI-GLINI AH-JAH BESH-DO-TLIZ AH-JAH AH-LOSZ NE-AHS-JAH CLA-GI-AIH TKIN AH-JAD NASH-DOIE-TSO SHUSH TLO-CHIN AL-NA-AS-DZOH D-AH GLOE-IH A-KHA';
  String oD2 = 'A-WOH GLOE-IH A-KHA';
  String oD3 = 'NA-HASH-CHID AH-NAH YEH-HES KLESH BI-SO-DIH YEH-HES AH-NAH DIBEH-YAZZIE';
  String oD4 = 'BA-GOSHI TSE-NILL MOASI LIN AH-JAH WOL-LA-CHEE A-WOH NESH-CHEE TLO-CHIN AH-LOSZ THAN-ZIE LIN TSA-E-DONIN-EE YEH-HES A-KEH-DI-GLINI DZEH DIBEH NO-DA-IH AL-NA-AS-DZOH AH-JAH A-CHI JEHA LIN A-WOH AH-JAH BE-LA-SANA KLESH A-WOH BESH-DO-TLIZ AH-NAH GAH A-KHA A-KHA TSAH AH-JAH A-CHIN TKIN A-CHIN DZEH';

  group("Navajo.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'alphabet' : true, 'expectedOutput' : ''},

      {'expectedOutput' : o1k, 'alphabet' : true, 'input' : oK11},
      {'expectedOutput' : o1d, 'alphabet' : true, 'input' : oD1},
      {'expectedOutput' : o2, 'alphabet' : true, 'input' : oK2},
      {'expectedOutput' : o2, 'alphabet' : true, 'input' : oD2},
      {'expectedOutput' : o3, 'alphabet' : true, 'input' : oK3},
      {'expectedOutput' : o3, 'alphabet' : true, 'input' : oD3},
      {'expectedOutput' : o4k, 'alphabet' : true, 'input' : oK4},
      {'expectedOutput' : o4d, 'alphabet' : true, 'input' : oD4},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeNavajo(elem['input'] as String, elem['alphabet'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Navajo.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'alphabet' : true, 'expectedOutput' : ''},

      {'input' : in1, 'alphabet' : true, 'expectedOutput' : oK12},
      {'input' : in2, 'alphabet' : true, 'expectedOutput' : oK2},
      {'input' : in3, 'alphabet' : true, 'expectedOutput' : oK3},
      {'input' : in4, 'alphabet' : true, 'expectedOutput' : oK4},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeNavajo(encodeNavajo(elem['input'] as String, elem['alphabet'] as bool), elem['alphabet'] as bool);
        expect(_actual, elem['input']);
      });
    }
  });
}