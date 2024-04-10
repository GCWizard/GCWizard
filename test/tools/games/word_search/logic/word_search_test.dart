import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/word_search/logic/word_search.dart';


void main() {
  group("wordSearch.searchHorizontal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'uewie\npotto\nojftj\njfjoh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'uewhe\npotti\nojffj\njfjkh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'SSUNEZNALG\nSTNESIWBSÜ\nUTEBLOWEGT\nCCIERFGEII\nHÖHLENEREG\nEHENLFWENK\nHGNUREDNAW\nIAVOGELKSN\nTSSEIDARAP\nETUEHOWEFE\n',
        'searchWords': 'Ast Vogel Höhlen Wander',
        'expectedOutput': [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]],
      },
      {'input': 'uewh\npotti\nojffj\njfjk',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.HORIZONTAL);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.searchHorizontalReverse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'uewie\npotto\nojftj\njfjoh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'uewhe\npotti\nojffj\njfjkh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'uewhe\npitto\nojffj\njfjkh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'SSUNEZNALG\nSTNESIWBSÜ\nUTEBLOWEGT\nCCIERFGEII\nHÖHLENEREG\nEHENLFWENK\nHGNUREDNAW\nIAVOGELKSN',
        'searchWords': 'Ast Vogel Höhlen Wander utu ean hite',
        'expectedOutput': [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
                            [0, 0, 1, 1, 1, 1, 1, 0, 0, 0]],
      },
      {'input': 'uewh\npotti\nojffj\njfjk',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.HORIZONTAL) |
            SearchDirectionFlags.setFlag(0, SearchDirectionFlags.REVERSE);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.searchVertical:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'uewie\npotto\nojftj\njfjoh',
        'searchWords': 'otto',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'uewoe\npotto\nojftj\njfjoh',
        'searchWords': 'otto',
        'expectedOutput': [[0, 0, 0, 2, 0], [0, 0, 0, 2, 0], [0, 0, 0, 2, 0], [0, 0, 0, 2, 0]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.VERTICAL);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.searchVerticalReverse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'uewie\npotto\nojftj\njfjoh',
        'searchWords': 'otto',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input': 'uewie\npotto\nojftj\njfjoh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 2, 0], [0, 0, 0, 2, 0], [0, 0, 0, 2, 0], [0, 0, 0, 2, 0]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.VERTICAL) |
        SearchDirectionFlags.setFlag(0, SearchDirectionFlags.REVERSE);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.searchDiagonal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'uewoe\npotto\nojftj\njfjoh',
        'searchWords': 'otto',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input' : 'uewoe\npotto\notftj\nifjoh',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 4, 0], [0, 0, 4, 0, 0], [0, 4, 0, 0, 0], [4, 0, 0, 0, 0]],
      },
      {'input' : 'uowoe\npotto\nojftj\njfjoi',
        'searchWords': 'otti',
        'expectedOutput': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
      },
      {'input' : 'SSUNEZNALG\nSTNESIWBSÜ\nUTEBLOWEGT\nCCIERFGEII\nHÖHLENEREG\nEHENLFWENK\nHGNUREDNAW\nIAVOGELKSN',
        'searchWords': 'Ast Vogel Höhlen Wander utu ean hite',
        'expectedOutput': [[0, 0, 4, 0, 0, 0, 0, 4, 0, 0],
                            [0, 4, 0, 0, 0, 0, 0, 0, 4, 0],
                            [4, 0, 0, 0, 0, 0, 0, 0, 0, 4],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 4, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 4, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 4]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.DIAGONAL);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.searchDiagonalReverse:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'uowoe\npotto\nojftj\njfjio',
        'searchWords': 'otti',
        'expectedOutput': [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
      },
      {'input' : 'uiwoe\npotto\nojftj\njfjoo',
        'searchWords': 'otti',
        'expectedOutput': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
      },
      {'input' : 'SSUNEZNALG\nSTNESIWBSÜ\nUTEBLOWEGT\nCCIERFGEII\nHÖHLENEREG\nEHENLFWENK\nHGNUREDNAW\nIAVOGELKSN',
        'searchWords': 'Ast Vogel Höhlen Wander utu ean hite',
        'expectedOutput': [[0, 0, 4, 0, 0, 0, 0, 4, 0, 0],
                            [0, 4, 0, 0, 0, 0, 0, 0, 4, 0],
                            [4, 0, 0, 0, 0, 0, 0, 0, 0, 4],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 4, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 4, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 4]],
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['searchWords']}', () {
        var searchDirection = SearchDirectionFlags.setFlag(0, SearchDirectionFlags.DIAGONAL) |
        SearchDirectionFlags.setFlag(0, SearchDirectionFlags.REVERSE);
        var _actual = searchWordList(elem['input'] as String, elem['searchWords'] as String, searchDirection);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  var bigMatrixInput = 'EMEEETREDEILFED\nBEEEEEZKRJFWEZA\nALTTFTEXPRRTBPR\nLIMREENTUTNSBEJ\nDSAEETNENORTIZE\nRSSSTDCCLEPWUBE\nIESSEHNYHLRVWYL\nANAITBEULEIEWFI\nNTWEACSXLTLMISN\nTETWMJIQMOUTANG\nEETSUKSIBIHJEKM\nEETRETUEARKQUER';
  var bigMatrix = [[4,2,2,7,1,1,1,1,1,1,1,1,1,4,2],[2,6,2,2,4,4,0,0,0,0,4,0,4,0,2],[2,2,6,2,4,4,4,0,0,4,0,4,0,0,2],[2,2,2,6,2,4,4,4,4,0,4,0,0,0,2],[2,2,2,3,7,1,5,5,5,5,1,1,1,1,2],[2,2,2,2,2,4,4,4,4,4,0,0,0,0,2],[2,2,2,2,2,4,4,4,4,4,4,0,0,0,2],[2,2,2,2,6,0,4,4,0,4,4,4,0,0,2],[2,2,0,6,2,4,0,0,4,0,4,4,4,0,2],[2,2,4,2,2,0,0,0,0,4,0,4,4,4,2],[3,7,1,1,1,1,1,1,1,1,5,0,4,4,0],[7,1,1,1,1,1,1,1,1,1,1,0,0,4,0]];

  group("wordSearch.fillSpacesMode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'TCIPRAOE\nSCLDIFSI\nBOKRNFRS\nSOHALERT\nTBSEHHEH\nORFDCSVA\nEBRULOLI\nNAMEMSEB\n',
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]],
        'expectedOutput': ['TCIPRAOE','SCLDIFSI','BOKRNFRS','SOHALERT','TBSEHHEH','ORFDCSVA','EBRULOLI','NAMEMSEB'],
      },
      {'input' : 'KCETTEHA\nNHHNNNSF\nEKUWALKR\nNONHFEIO\nINEAEGNS\nHCAGELEC\nSMIETNEB\nDMEHCKRI\n',
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 0, 0, 0, 0]],
        'expectedOutput': ['KCETTEHA','NHHNNN F', 'EKUWAL R', 'NONHFE O', 'INEAEGNS', 'HCAGELEC', 'SMIETNEB', '    CKRI'],
      },
      {'input' : 'uewie\npotto\nojftj\njfjoh',
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        'expectedOutput': ['uewie', 'p    ', 'ojftj', 'jfjoh'],
      },
      {'input' : 'uowie\npotto\nojftj\njfjoo',
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
        'expectedOutput': ['u wie', 'po to', 'ojf j', 'jfjo '],
      },
      {'input' : 'S	S	U	N	E	Z	N	Ä	L	G\nS	T	N	E	S	I	W	B	S	Ü',
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix' : [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 0, 0, 0, 0, 0]],
        'expectedOutput': ['SSUNEZNÄLG', 'ST   IWBSÜ'],
      },
      {'input' : bigMatrixInput,
        'fillSpacesMode': FillGapMode.OFF,
        'markedMatrix' : bigMatrix,
        'expectedOutput': ['               ','      ZKRJ W Z ','       XP R BP ','         T SBE ','               ','          PWUB ','           VWY ','     B  L   WF ','  W   SX T   S ','     JIQM U    ','           J  M','           QU R'],
      },

      {'input' : 'TCIPRAOE\nSCLDIFSI\nBOKRNFRS\nSOHALERT\nTBSEHHEH\nORFDCSVA\nEBRULOLI\nNAMEMSEB\n',
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]],
        'expectedOutput': ['TCIPRAOE','SCLDIFSI','BOKRNFRS','SOHALERT','TBSEHHEH','ORFDCSVA','EBRULOLI','NAMEMSEB'],
      },
      {'input' : 'KCETTEHA\nNHHNNNSF\nEKUWALKR\nNONHFEIO\nINEAEGNS\nHCAGELEC\nSMIETNEB\nDMEHCKRI\n',
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 0, 0, 0, 0]],
        'expectedOutput': ['    TE A','KCETNN F','NHHNAL R','EKUWFEHO','NONHEGNS','INEAELEC','HCAGTNEB','SMIECKRI'],
      },
      {'input' : 'uewie\npotto\nojftj\njfjoh',
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        'expectedOutput': ['u    ', 'pewie', 'ojftj', 'jfjoh'],
      },
      {'input' : 'uowie\npotto\nojftj\njfjoo',
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
        'expectedOutput': ['u    ', 'powie', 'ojfto', 'jfjoj'],
      },
      {'input' : 'S	S	U	N	E	Z	N	Ä	L	G\nS	T	N	E	S	I	W	B	S	Ü',
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix' : [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 0, 0, 0, 0, 0]],
        'expectedOutput': ['SS   ZNÄLG', 'STUNEIWBSÜ'],
      },
      {'input' : bigMatrixInput,
        'fillSpacesMode': FillGapMode.DOWN,
        'markedMatrix' : bigMatrix,
        'expectedOutput': ['               ','               ','               ','               ','               ','             Z ','           WBP ','           SBE ','       KR  WUB ','      ZXPJRVWY ','     BSXLTPJWFM','  W  JIQMTUQUSR']
      },

      {'input' : 'TCIPRAOE\nSCLDIFSI\nBOKRNFRS\nSOHALERT\nTBSEHHEH\nORFDCSVA\nEBRULOLI\nNAMEMSEB\n',
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]],
        'expectedOutput': ['TCIPRAOE','SCLDIFSI','BOKRNFRS','SOHALERT','TBSEHHEH','ORFDCSVA','EBRULOLI','NAMEMSEB'],
      },
      {'input' : 'KCETTEHA\nNHHNNNSF\nEKUWALKR\nNONHFEIO\nINEAEGNS\nHCAGELEC\nSMIETNEB\nDMEHCKRI\n',
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix': [[1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 0, 0, 0, 0]],
        'expectedOutput': ['NCETTEHA', 'EHHNNNNF', 'NKUWALER', 'IONHFEEO', 'HNEAEGRS', 'SCAGEL C', ' MIETN B', '    CK I'],
      },
      {'input' : 'uewie\npotto\nojftj\njfjoh',
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        'expectedOutput': ['uewie', 'pjftj', 'ofjoh', 'j    '],
      },
      {'input' : 'uowie\npotto\nojftj\njfjoo',
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
        'expectedOutput': ['uowie', 'pjfto', 'ofjoj', 'j    '],
      },
      {'input' : 'S	S	U	N	E	Z	N	Ä	L	G\nS	T	N	E	S	I	W	B	S	Ü',
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix' : [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 0, 0, 0, 0, 0]],
        'expectedOutput': ['SSUNEZNÄLG', 'ST   IWBSÜ'],
      },
      {'input' : bigMatrixInput,
        'fillSpacesMode': FillGapMode.TOP,
        'markedMatrix' : bigMatrix,
        'expectedOutput': ['  W  BZKRJRWBZM','     JSXPTPSBPR','      IXLTUWUE ','       QM  VWB ','           JWY ','           QUF ','             S ','               ','               ','               ','               ','               ']
      },
      
      {'input' : 'TCIPRAOE\nSCLDIFSI\nBOKRNFRS\nSOHALERT\nTBSEHHEH\nORFDCSVA\nEBRULOLI\nNAMEMSEB\n',
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]],
        'expectedOutput': ['TCIPRAOE','SCLDIFSI','BOKRNFRS','SOHALERT','TBSEHHEH','ORFDCSVA','EBRULOLI','NAMEMSEB'],
      },
      {'input' : 'KCETTEHA\nNHHNNNSF\nEKUWALKR\nNONHFEIO\nINEAEGNS\nHCAGELEC\nSMIETNEB\nDMEHCKRI\n',
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix': [[1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 0, 0, 0, 0]],
        'expectedOutput': [' CETTEHA', ' NHHNNNF', ' EKUWALR', ' NONHFEO', 'INEAEGNS', 'HCAGELEC', 'SMIETNEB', '    CKRI'],
      },
      {'input' : 'uewie\npotto\nojftj\njfjoh',
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        'expectedOutput': ['uewie', '    p', 'ojftj', 'jfjoh'],
      },
      {'input' : 'uowie\npotto\nojftj\njfjoo',
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
        'expectedOutput': [' uwie', ' poto', ' ojfj', ' jfjo'],
      },
      {'input' : 'S	S	U	N	E	Z	N	Ä	L	G\nS	T	N	E	S	I	W	B	S	Ü',
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix' : [[1, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 0, 0, 0, 0, 0]],
        'expectedOutput': [' SUNEZNÄLG', '   STIWBSÜ'],
      },
      {'input' : bigMatrixInput,
        'fillSpacesMode': FillGapMode.RIGHT,
        'markedMatrix' : bigMatrix,
        'expectedOutput': ['               ','         ZKRJWZ','          XPRBP','           TSBE','               ','           PWUB','            VWY','           BLWF','          WSXTS','          JIQMU','             JM','            QUR']
      },

      {'input' : 'TCIPRAOE\nSCLDIFSI\nBOKRNFRS\nSOHALERT\nTBSEHHEH\nORFDCSVA\nEBRULOLI\nNAMEMSEB\n',
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix': [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0]],
        'expectedOutput': ['TCIPRAOE','SCLDIFSI','BOKRNFRS','SOHALERT','TBSEHHEH','ORFDCSVA','EBRULOLI','NAMEMSEB'],
      },
      {'input' : 'KCETTEHA\nNHHNNNSF\nEKUWALKR\nNONHFEIO\nINEAEGNS\nHCAGELEC\nSMIETNEB\nDMEHCKRI\n',
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix': [[1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 0, 0, 0, 0]],
        'expectedOutput': ['CETTEHA ', 'NHHNNNF ', 'EKUWALR ', 'NONHFEO ', 'INEAEGNS', 'HCAGELEC', 'SMIETNEB', 'CKRI    '],
      },
      {'input' : 'uewie\npotto\nojftj\njfjoh',
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix': [[0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        'expectedOutput': ['uewie', 'p    ', 'ojftj', 'jfjoh'],
      },
      {'input' : 'uowie\npotto\nojftj\njfjoo',
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix': [[0, 4, 0, 0, 0], [0, 0, 4, 0, 0], [0, 0, 0, 4, 0], [0, 0, 0, 0, 4]],
        'expectedOutput': ['uwie ', 'poto ', 'ojfj ', 'jfjo '],
      },
      {'input' : 'S	S	U	N	E	Z	N	Ä	L	G\nS	T	N	E	S	I	W	B	S	Ü',
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix' : [[1, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 0, 0, 0, 0, 0]],
        'expectedOutput': ['SUNEZNÄLG ', 'STIWBSÜ   '],
      },
      {'input' : bigMatrixInput,
        'fillSpacesMode': FillGapMode.LEFT,
        'markedMatrix' : bigMatrix,
        'expectedOutput': ['               ','ZKRJWZ         ','XPRBP          ','TSBE           ','               ','PWUB           ','VWY            ','BLWF           ','WSXTS          ','JIQMU          ','JM             ','QUR            ']
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} mode: ${elem['fillSpacesMode']}', () {

        var marked = (elem['markedMatrix'] as List<List<int>>).map((row) => Uint8List.fromList(row)).toList();
        var _actual = fillSpaces(elem['input'] as String, marked, elem['fillSpacesMode'] as FillGapMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("wordSearch.normalizeAndSplitInputForView:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'uewie\npotto\n  \r\nojftj\njfjoh',
        'expectedOutput': ['uewie', 'potto', 'ojftj', 'jfjoh'],
      },
      {'input': 'uewoe\npotto\nojftjr\njfjoh',
        'expectedOutput': ['uewoe ', 'potto ', 'ojftjr', 'jfjoh '],
      },
      {'input' : 'uewoe\npotto\nojftjr\njf joh',
        'expectedOutput': ['uewoe ', 'potto ', 'ojftjr', 'jfjoh '],
      },
      {'input' : 'uewoe\npotto\nojftjr\njf joh',
        'noSpaces': false,
        'expectedOutput': ['uewoe ', 'potto ', 'ojftjr', 'jf joh'],
       },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} words: ${elem['noSpaces']}', () {
        var _actual = normalizeAndSplitInputForView(elem['input'] as String, noSpaces: elem['noSpaces'] != null ? elem['noSpaces'] as bool : true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}