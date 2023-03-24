import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/keyboard/_common/logic/keyboard.dart';

void main() {
  String inputString = 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890';

  group("Keyboard.null:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.QWERTZ_T1, 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.QWERTZ_T1:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : inputString},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxzy\';[ABCDEFGHIJKLMNOPQRSTUVWXZY":{1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axje.uidchtnmbrl\'poygk,q;f-s/AXJE>UIDCHTNMBRL"POYGK<Q:F_S?`123456789'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axje.iuhcdrnmbtzüpoygk,qöfls?AXJE:IUHCDRNMBTZÜPOYGK;QÖFLSß1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'abke.uidchtnwmrläpoygx,jüfßsqABKE:UIDCHTNWMRLÄPOYGX;JÜF?SQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abkeäuidchtnwmrlöpoygxüj,fßsABKEÄUIDCHTNWMRLÖPOYGXÜJ;F?SQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abkeüuidchtnwmrläpoygxöj,fßsABKEÜUIDCHTNWMRLÄPOYGXÖJ;F?SQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkgarniudehsüäwjqolctmpvxbyföZKGARNIUDEHSÜÄWJQOLCTMPVXBYFÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abcsftdhuneimky;qprglvwxzj\'o[ABCSFTDHUNEIMKY:QPRGLVWXZJ"O{1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzäaleosgnrtmbfqxciwhpvöükydßUZÄALEOSGNRTMBFQXCIWHPVÖÜKYDẞ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbcdefghijkl.noparstuvzxwy/m-QBCDEFGHIJKL?NOPARSTUVZXWY\\M_àéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akxipe,cdtsrq\'ljbouèv.éyà^mnzAKXIPE;CDTSRQ?LJBOUÈV:ÉYÀ!MNZ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.QWERTZ_T1, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cöüiueoblnrszymwjatxhädvfpqgßCÖÜIUEOBLNRSZYMWJATXHÄDVFPQGẞ1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.QWERTY_US_INT:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'abcdefghijklmnopqrstuvwxzyABCDEFGHIJKLMNOPQRSTUVWXZY1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axje.uidchtnmbrl\'poygk,qf;AXJE>UIDCHTNMBRL"POYGK<QF:`123456789'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axje.iuhcdrnmbtzüpoygk,qföAXJE:IUHCDRNMBTZÜPOYGK;QFÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'abke.uidchtnwmrläpoygx,jfüABKE:UIDCHTNWMRLÄPOYGX;JFÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abkeäuidchtnwmrlöpoygxüjf,ABKEÄUIDCHTNWMRLÖPOYGXÜJF;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abkeüuidchtnwmrläpoygxöjf,ABKEÜUIDCHTNWMRLÄPOYGXÖJF;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abcsftdhuneimky;qprglvwxjzABCSFTDHUNEIMKY:QPRGLVWXJZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzäaleosgnrtmbfqxciwhpvöküUZÄALEOSGNRTMBFQXCIWHPVÖKÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkgarniudehsüäwjqolctmpvbxZKGARNIUDEHSÜÄWJQOLCTMPVBX1234567890'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbcdefghijkl.noparstuvzxywQBCDEFGHIJKL?NOPARSTUVZXYWàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akxipe,cdtsrq\'ljbouèv.éy^àAKXIPE;CDTSRQ?LJBOUÈV:ÉY!À"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.QWERTY_US_INT, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cöüiueoblnrszymwjatxhädvpfCÖÜIUEOBLNRSZYMWJATXHÄDVPF1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.Dvorak:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'anihdzujgcvpmlsrxoökf.,bt-ANIHDZUJGCVPMLSRXOÖKF:;BT_234567890ß'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'anihdyujgcvpmlsrxo;kf.,bt/ANIHDYUJGCVPMLSRXO:KF><BT?234567890-'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'abchefgdujkzmnopqtsrivwxy\'ABCHEFGDUJKZMNOPQTSRIVWXY#234567890+'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'amcdefghikxlwnopjrstuzvbyAMCDEFGHIKXLWNOPJRSTUZVBY234567890+'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'amcdefghikxlwnopjrstuzvbyAMCDEFGHIKXLWNOPJRSTUZVBY234567890+'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'amcdefghikxlwnopjrstuzvbyAMCDEFGHIKXLWNOPJRSTUZVBY234567890+'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'akuhsjlndcv;mirpxyoet.,bg/AKUHSJLNDCV:MIRPXYOET><BG?234567890-'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.NEO,           'expectedOutput' : 'ubgsakhnoäpqmticöfdre.,zwjUBGSAKHNOÄPQMTICÖFDRE·-ZWJ234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zäduabteigmjüslovwfhn,ßkc.ZÄDUABTEIGMJÜSLOVWFHN;?KC:234567890-'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qnihdyujgcvp.lsrxomkf:,bt;QNIHDYUJGCVP?LSRXOMKF…!BT=éèê()ߵߴ«»\''},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'a\'dci^vt,x.jqruoylnsehgkèfA?DCI!VT;X:JQRUOYLNSEHGKÈF«»()@+-/*='},
      {'input' : inputString, 'from' : KeyboardType.Dvorak, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cylbiphnoüäwzstavmgre.,öxkCYLBIPHNOÜÄWZSTAVMGRE·-ÖXK234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.Dvorak_II_DEU:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'anijdzuhfcvämlsrxköog.,btp<yqANIJDZUHFCVÄMLSRXKÖOG:;BTP>YQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'anijdyuhfcv\'mlsrxk;og.,btpzqANIJDYUHFCV"MLSRXK:OG><BTPZQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'abchefgdujk-mnopqtsrivwxyl;\'ABCHEFGDUJK_MNOPQTSRIVWXYL:"`123456789'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : inputString},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'amchefgdukxßwnopjtsrizvbylöüäAMCHEFGDUKX?WNOPJTSRIZVBYLÖÜÄ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'amchefgdukxßwnopjtsrizvbyl.,öAMCHEFGDUKX?WNOPJTSRIZVBYL:;Ö1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'amchefgdukxßwnopjtsrizvbyl.,äAMCHEFGDUKX?WNOPJTSRIZVBYL:;Ä1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'akunsjlhtcv\'mirpxeoyd.,bg;zqAKUNSJLHTCV"MIRPXEOYD><BG:ZQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.NEO,           'expectedOutput' : 'ubgnakhseäpymticördfo.,zwqüxUBGNAKHSEÄPYMTICÖRDFO·-ZWQÜX1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zädeabtungmyüslovhfwi,ßkcj<xqZÄDEABTUNGMYÜSLOVHFWI;?KCJ>XQ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qnijdyuhfcv/.lsrxkmog:,btp<waQNIJDYUHFCV\\?LSRXKMOG…!BTP>WAàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'a\'dti^vcex.mqruoysnl,hgkèjêàbA?DTI!VCEX:MQRUOYSNL;HGKÈJÊÀB"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_II_DEU, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cylniphbeüäqzstavrgmo.,öxwfjCYLNIPHBEÜÄQZSTAVRGMO·-ÖXWFJ1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.Dvorak_I_DEU1:", () {
	List<Map<String, Object?>> _inputsToExpected = [
	  {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.QWERTZ_T1,       'expectedOutput' : 'abihdzujgxcpnlsrüoökf,mvt.q<yABIHDZUJGXCPNLSRÜOÖKF;MVT:Q>Y1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abihdyujgxcpnlsr[o;kf,mvt.qzABIHDYUJGXCPNLSR{O:KF<MVT>QZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axcdefghiqjlbnop/rstuwmkyv\';AXCDEFGHIQJLBNOP?RSTUWMKYV":`123456789'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axchefgduqjzbnop?tsriwmkyvüäöAXCHEFGDUQJZBNOPßTSRIWMKYVÜÄÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : inputString},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abcdefghijklmnoprstuvwxyzö.,ABCDEFGHIJKLMNOPQRSTUVWXYZÖ:;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abcdefghijklmnoprstuvwxyzä.,ABCDEFGHIJKLMNOPQRSTUVWXYZÄ:;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abuhsjlndxc;kirp[yoet,mvg.qzABUHSJLNDXC:KIRP{YOET<MVG>QZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzgsakhnoöäqbticßfdre,mpw.xüUZGSAKHNOÖÄQBTICẞFDRE-MPW·XÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkduabteivgjäsloöwfhnßümc,q<xZKDUABTEIVGJÄSLOÖWFHN?ÜMC;Q>X1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbihdyujgxcpnlsr-omkf,.vt:a<wQBIHDYUJGXCPNLSR_OMKF!?VT…A>Wàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akdci^vt,yxj\'ruozlnsegq.èhbêàAKDCI!VT;YXJ?RUOZLNSEGQ:ÈHBÊÀ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU1, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cölbiphnovüwystaßmgre,zäx.jfCÖLBIPHNOVÜWYSTAẞMGRE-ZÄX·JF1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.Dvorak_I_DEU2:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'abihdzujgxcpnlsr#oökf,mvt.eqwABIHDZUJGXCPNLSRÜOÖKF;MVT:EQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abihdyujgxcpnlsro;kf,mvt.eqwABIHDYUJGXCPNLSR{O:KF<MVT>EQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axcdefghiqjlbnoprstuwmkyv.\',AXCDEFGHIQJLBNOP?RSTUWMKYV>"<`123456789'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axchefgduqjzbnop-tsriwmkyv.ü,AXCHEFGDUQJZBNOPßTSRIWMKYV:Ü;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'abcdefghijklmnop-rstuvwxyz.ä,ABCDEFGHIJKLMNOPQRSTUVWXYZ:Ä;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzüäöABCDEFGHIJKLMNOPQRSTUVWXYZÜÄÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abuhsjlndxc;kirpyoet,mvg.fqwABUHSJLNDXC:KIRP{YOET<MVG>FQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzgsakhnoöäqbticfdre,mpw.lxvUZGSAKHNOÖÄQBTICẞFDRE-MPW·LXV1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkduabteivgjäslo#wfhnßümc,rqpZKDUABTEIVGJÄSLOÖWFHN?ÜMC;RQP1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbihdyujgxcpnlsr*omkf,.vt:eazQBIHDYUJGXCPNLSR_OMKF!?VT…EAZàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akdci^vt,yxj\'ruoçlnsegq.èhpbéAKDCI!VT;YXJ?RUOZLNSEGQ:ÈHPBÉ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU2, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cölbiphnovüwystamgre,zäx.ujdCÖLBIPHNOVÜWYSTAẞMGRE-ZÄX·UJD1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.Dvorak_I_DEU3:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'abihdzujgxcpnlsr#oökf,mvt.qweABIHDZUJGXCPNLSRÜOÖKF;MVT:QWE1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abihdyujgxcpnlsro;kf,mvt.qweABIHDYUJGXCPNLSR{O:KF<MVT>QWE1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axcdefghiqjlbnoprstuwmkyv\',.AXCDEFGHIQJLBNOP?RSTUWMKYV"<>`123456789'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axchefgduqjzbnop-tsriwmkyvü,.AXCHEFGDUQJZBNOPßTSRIWMKYVÜ;:1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'abcdefghijklmnop-rstuvwxyzä,.ABCDEFGHIJKLMNOPQRSTUVWXYZÄ;:1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzöüäABCDEFGHIJKLMNOPQRSTUVWXYZÖÜÄ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abuhsjlndxc;kirpyoet,mvg.qwfABUHSJLNDXC:KIRP{YOET<MVG>QWF1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzgsakhnoöäqbticfdre,mpw.xvlUZGSAKHNOÖÄQBTICẞFDRE-MPW·XVL1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkduabteivgjäslo#wfhnßümc,qprZKDUABTEIVGJÄSLOÖWFHN?ÜMC;QPR1234567890'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbihdyujgxcpnlsr*omkf,.vt:azeQBIHDYUJGXCPNLSR_OMKF!?VT…AZEàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akdci^vt,yxj\'ruoçlnsegq.èhbépAKDCI!VT;YXJ?RUOZLNSEGQ:ÈHBÉP"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.Dvorak_I_DEU3, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cölbiphnovüwystamgre,zäx.jduCÖLBIPHNOVÜWYSTAẞMGRE-ZÄX·JDU1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.COLEMAK:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'abcgkethlznumjörqsdfivwxoyABCGKETHLZNUMJÖRQSDFIVWXOY1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'abcgkethlynumj;rqsdfivwxozABCGKETHLYNUMJ:RQSDFIVWXOZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'axjit.ydnfbgmhsp\'oeuck,qr;AXJIT>YDNFBGMHSP"OEUCK<QR:`123456789'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'axjur.yhnfbgmdspüoeick,qtöAXJUR:YHNFBGMDSPÜOEICK;QTÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'abkit.ydnfmgwhspäoeucx,jrüABKIT:YDNFMGWHSPÄOEUCX;JRÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'abkitäydnfmgwhspöoeucxüjr,ABKITÄYDNFMGWHSPÖOEUCXÜJR;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'abkitüydnfmgwhspäoeucxöjr,ABKITÜYDNFMGWHSPÄOEUCXÖJR;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uzäorlwstkbhmndcxiaegpvöfüUZÄORLWSTKBHMNDCXIAEGPVÖFÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zkgihrcusbätüefoqlandmpvwxZKGIHRCUSBÄTÜEFOQLANDMPVWX1234567890'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qbcgkethlynu.jmrasdfivzxowQBCGKETHLYNU?JMRASDFIVZXOWàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'akx,spècr^\'vqtnobuied.éylàAKX;SPÈCR!?VQTNOBUIED:ÉYLÀ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.COLEMAK, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cöüoruxbspyhzngajtielädvmfCÖÜORUXBSPYHZNGAJTIELÄDVMF1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.NEO:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'dnröfoius-zemjgvpkhlawtqäbcxyDNRÖFOIUS_ZEMJGVPKHLAWTQÄBCXY1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'dnr;foius/yemjgvpkhlawtq\'bcxzDNR:FOIUS?YEMJGVPKHLAWTQ"BCXZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'ebpsurcgozf.mhikltdna,y\'-xjq;EBPSURCGOZF>MHIKLTDNA<Y"_XJQ:`123456789'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'ebpsitcgo\'f.mdukzrhna,yülxjqöEBPSITCGO#F:MDUKZRHNA;YÜLXJQÖ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'empsurcgof.whixltdna,yäßbkjüEMPSURCGOF:WHIXLTDNA;YÄ?BKJÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'empsurcgofäwhixltdnaüyößbkj,EMPSURCGOFÄWHIXLTDNAÜYÖ?BKJ;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'empsurcgofüwhixltdnaöyäßbkj,EMPSURCGOFÜWHIXLTDNAÖYÄ?BKJ;1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'skpotyulr/jfmndv;ehiawgq\'bcxzSKPOTYULR?JFMNDV:EHIAWGQ"BCXZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.NEO,           'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'aäofnwdtl.brüeimjhuszpcqykgvxAÄOFNWDTL:BRÜEIMJHUSZPCQYKGVX1234567890'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'dnrmfoius;ye.jgvpkhlqzta/bcxwDNRMFOIUS=YE?JGVPKHLQZTA\\BCXWàéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'i\'oneldvuf^pqt,.jscraéèbmkxyàI?ONELDVUF!PQT;:JSCRAÉÈBMKXYÀ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.NEO, 'to' : KeyboardType.BONE,          'expectedOutput' : 'iyagemlhtkpuznoäwrbscdxjqöüvfIYAGEMLHTKPUZNOÄWRBSCDXJQÖÜVF1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.RISTOME:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'dztijöckgpbsvfrwqeluhxoyäanümDZTIJÖCKGPBSVFRWQELUHXOYÄANÜM1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'dytij;ckgpbsvfrwqeluhxoz\'an[mDYTIJ:CKGPBSVFRWQELUHXOZ"AN{M1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'efychsjtilxokup,\'.ngdqr;-ab/mEFYCHSJTILXOKUP<">NGDQR:_AB?M`123456789'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'efycdsjruzxokip,ü.nghqtölab?mEFYCDSJRUZXOKIP;Ü:NGHQTÖLABßM1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'efychsktilboxup,ä.ngdjrüßamqwEFYCHSKTILBOXUP;Ä:NGDJRÜ?AMQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'efychsktilboxupüöängdjr,ßamwEFYCHSKTILBOXUPÜÖÄNGDJR;?AMQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'efychsktilboxupöäüngdjr,ßamwEFYCHSKTILBOXUPÖÄÜNGDJR;?AMQW1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'sjgunoced;brvtpwqfilhxyz\'ak[mSJGUNOCED:BRVTPWQFILHXYZ"AK{M1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.NEO,           'expectedOutput' : 'akwgndäroqzipecvxlthsöfüyubßmAKWGNDÄROQZIPECVXLTHSÖFÜYUBẞM1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'dytijmckgpbsvfrzaeluhxow/qn-.DYTIJMCKGPBSVFRZAELUHXOW\\QN_?àéèê()ߵߴ«»'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'i^èdtnxs,jku.eoébprvcylàma\'zqI!ÈDTNXS;JKU:EOÉBPRVCYLÀMA?ZQ"«»()@+-/*'},
      {'input' : inputString, 'from' : KeyboardType.RISTOME, 'to' : KeyboardType.BONE,          'expectedOutput' : 'ipxlngürowötäeadjushbvmfqcyßzIPXLNGÜROWÖTÄEADJUSHBVMFQCYẞZ1234567890'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.FRA_AZERTY:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'qbcdefghijklönoparstuvyxzwQBCDEFGHIJKLÖNOPARSTUVYXZW!"§\$%&/()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'qbcdefghijkl;noparstuvzxywQBCDEFGHIJKL:NOPARSTUVZXYW!@#\$%^&*()'},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.Dvorak,        'expectedOutput' : '\'xje.uidchtnsbrlapoygk;qf,"XJE>UIDCHTNSBRLAPOYGK:QF<~!@#\$%^&*('},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'üxje.iuhcdrnsbtzapoygköqf,ÜXJE:IUHCDRNSBTZAPOYGKÖQF;!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'äbke.uidchtnsmrlapoygxüjf,ÄBKE:UIDCHTNSMRLAPOYGXÜJF;!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'öbkeäuidchtnsmrlapoygx,jfüÖBKEÄUIDCHTNSMRLAPOYGX;JFÜ!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'äbkeüuidchtnsmrlapoygx,jföÄBKEÜUIDCHTNSMRLAPOYGX;JFÖ!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'qbcsftdhuneioky;aprglvzxjwQBCSFTDHUNEIOKY:APRGLVZXJW!@#\$%^&*()'},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.NEO,           'expectedOutput' : 'xzäaleosgnrtdbfquciwhpüökvXZÄALEOSGNRTDBFQUCIWHPÜÖKV°§ℓ»«\$€„“”'},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'qkgarniudehsfäwjzolctmxvbpQKGARNIUDEHSFÄWJZOLCTMXVBP!"§\$%&/()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'bkxipe,cdtsrn\'ljaouèv.ày^éBKXIPE;CDTSRN?LJAOUÈV:ÀY!É1234567890'},
      {'input' : inputString, 'from' : KeyboardType.FRA_AZERTY, 'to' : KeyboardType.BONE,          'expectedOutput' : 'jöüiueoblnrsgymwcatxhäfvpdJÖÜIUEOBLNRSGYMWCATXHÄFVPD°§ℓ»«\$€„“”'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.FRA_BEPO:", () {
	List<Map<String, Object?>> _inputsToExpected = [
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.QWERTZ_T1,     'expectedOutput' : 'aqhif-,.dpboäöremlkjsu+cxüAQHIF_;:DPBOÄÖREMLKJSU*CXÜ!"§\$%&/()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.QWERTY_US_INT, 'expectedOutput' : 'aqhif/,.dpbo\';remlkjsu]cx[AQHIF?<>DPBO":REMLKJSU}CX{!@#\$%^&*()'},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.Dvorak,        'expectedOutput' : 'a\'dcuzwvelxr-sp.mnthog=jq/A"DCUZWVELXR_SP>MNTHOG+JQ?~!@#\$%^&*('},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.Dvorak_II_DEU, 'expectedOutput' : 'aühci\'wvezxtlsp.mnrdog/jq?AÜHCI#WVEZXTLSP:MNRDOG\\JQß!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.Dvorak_I_DEU1, 'expectedOutput' : 'aädcuvzelbrßsp.wnthog\\kjqAÄDCUVZELBR?SP:WNTHOG/KJQ!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.Dvorak_I_DEU2, 'expectedOutput' : 'aödcuvzelbrßspäwnthog\\kjAÖDCUVZELBR?SPÄWNTHOG/KJQ!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.Dvorak_I_DEU3, 'expectedOutput' : 'aädcuvzelbrßspüwnthog\\kjAÄDCUVZELBR?SPÜWNTHOG/KJQ!"§\$%&()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.COLEMAK,       'expectedOutput' : 'aqhut/,.s;by\'opfmienrl]cx[AQHUT?<>S:BY"OPFMIENRL}CX{!@#\$%^&*()'},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.NEO,           'expectedOutput' : 'uxsgej,.aqzfydclmtrnih´äößUXSGEJ-·AQZFYDCLMTRNIH˜ÄÖẞ°§ℓ»«\$€„“”'},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.RISTOME,       'expectedOutput' : 'zqudn.ß,ajkwyforüshelt+gvöZQUDN:?;AJKWYFORÜSHELT*GVÖ!"§\$%&/()='},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.FRA_AZERTY,    'expectedOutput' : 'qahif;,:dpbo/mre.lkjsu+cx-QAHIF=!…DPBO\\MRE?LKJSU±CX_1234567890'},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.FRA_BEPO,      'expectedOutput' : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'},
      {'input' : inputString, 'from' : KeyboardType.FRA_BEPO, 'to' : KeyboardType.BONE,          'expectedOutput' : 'cjblek,.iwömqgauzsrnth´üvßCJBLEK-·IWÖMQGAUZSRNTH˜ÜVẞ°§ℓ»«\$€„“”'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, from: ${elem['from']}, to: ${elem['to']}', () {
        var _actual = encodeKeyboard(elem['input'] as String, elem['from'] as KeyboardType, elem['to'] as KeyboardType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.encodeKeyboardNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '1234567890', 'expectedOutput' : [
        ['keyboard_mode_qwertz_ristome_dvorak', '!"§\$%&/()='],
        ['keyboard_mode_neo', '°§ℓ»«\$€„“”'],
        ['keyboard_mode_neo_3', '¹²³›‹₵¥‚‘’'],
        ['keyboard_mode_neo_5', '¹²³♀♂⚥𝛘〈〉𝛐'],
        ['keyboard_mode_neo_6', '¬∨∧⊥∡∥→∞∝∅'],
        ['keyboard_mode_fra_azerty', '&é"\'(-è_çà'],
        ['keyboard_mode_fra_bepo', '"«»()@+-/*'],
        ['keyboard_mode_qwerty_us_int_colemak_dvorak', '!@#\$%^&*()']
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeKeyboardNumbers(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Keyboard.decodeKeyboardNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '!"§\$%&/()=°§ℓ»«\$€„“”¹²³›‹₵¥‚‘’³♀♂⚥𝛘〈〉𝛐¬∨∧⊥∡∥→∞∝∅"«»()@+-/*', 'expectedOutput' : [
        ['keyboard_mode_qwertz_ristome_dvorak',
          '1234567890 3   4     23       3                   2  89   7 '],
        ['keyboard_mode_neo',
          '  26  7   123456 890                               54     7 '],
        ['keyboard_mode_neo_3',
          '                    12345678903                             '],
        ['keyboard_mode_neo_5',
          '                    123       3456  89                      '],
        ['keyboard_mode_neo_6',
          '                                        1234567890          '],
        ['keyboard_mode_fra_azerty',
          ' 3   1 5                                          3  5 0 6  '],
        ['keyboard_mode_fra_bepo',
          ' 1    945    32                                   1234567890'],
        ['keyboard_mode_qwerty_us_int_colemak_dvorak',
          '1  457 90      4                                     902   8'],
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeKeyboardNumbers(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}