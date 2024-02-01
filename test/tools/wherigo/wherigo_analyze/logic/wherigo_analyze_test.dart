import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';
import 'package:path/path.dart' as path;

import 'wherigo_analyze_test_resources_answers.dart';
import 'wherigo_analyze_test_resources_builder_variable.dart';
import 'wherigo_analyze_test_resources_character.dart';
import 'wherigo_analyze_test_resources_gwc.dart';
import 'wherigo_analyze_test_resources_input.dart';
import 'wherigo_analyze_test_resources_item.dart';
import 'wherigo_analyze_test_resources_lua_source.dart';
import 'wherigo_analyze_test_resources_media.dart';
import 'wherigo_analyze_test_resources_messages.dart';
import 'wherigo_analyze_test_resources_task.dart';
import 'wherigo_analyze_test_resources_timer.dart';
import 'wherigo_analyze_test_resources_variable.dart';
import 'wherigo_analyze_test_resources_zone.dart';

String testDirPath = 'test/tools/wherigo/wherigo_analyze/resources/';

Uint8List _getFileData(String name) {
  io.File file = io.File(path.join(testDirPath, name));
  return file.readAsBytesSync();
}

const WherigoTaskData _WHERIGO_EMPTYTESTTASK_LUA = WherigoTaskData(
  TaskLUAName: '',
  TaskID: '',
  TaskName: '',
  TaskDescription: '',
  TaskVisible: '',
  TaskMedia: '',
  TaskIcon: '',
  TaskActive: '',
  TaskComplete: '',
  TaskCorrectstate: '',
);
const WherigoZoneData _WHERIGO_EMPTYTESTZONE_LUA = WherigoZoneData(
  ZoneLUAName: '',
  ZoneID: '',
  ZoneName: '',
  ZoneDescription: '',
  ZoneVisible: '',
  ZoneMediaName: '',
  ZoneIconName: '',
  ZoneActive: '',
  ZoneDistanceRange: '',
  ZoneShowObjects: '',
  ZoneProximityRange: '',
  ZoneOriginalPoint: WherigoZonePoint(),
  ZoneDistanceRangeUOM: '',
  ZoneProximityRangeUOM: '',
  ZoneOutOfRange: '',
  ZoneInRange: '',
  ZonePoints: [],
);
const WherigoItemData _WHERIGO_EMPTYTESTITEM_LUA = WherigoItemData(
  ItemLUAName: '',
  ItemID: '',
  ItemName: '',
  ItemDescription: '',
  ItemVisible: '',
  ItemMedia: '',
  ItemIcon: '',
  ItemLocation: '',
  ItemZonepoint: WherigoZonePoint(),
  ItemContainer: '',
  ItemLocked: '',
  ItemOpened: '',
);
const WherigoMediaData _WHERIGO_EMPTYTESTMEDIA_LUA = WherigoMediaData(
  MediaLUAName: '',
  MediaID: '',
  MediaName: '',
  MediaDescription: '',
  MediaAltText: '',
  MediaType: '',
  MediaFilename: '',
);
const WherigoCharacterData _WHERIGO_EMPTYTESTCHARACTER_LUA = WherigoCharacterData(
  CharacterLUAName: '',
  CharacterID: '',
  CharacterName: '',
  CharacterDescription: '',
  CharacterVisible: '',
  CharacterMediaName: '',
  CharacterIconName: '',
  CharacterLocation: '',
  CharacterZonepoint: WherigoZonePoint(),
  CharacterContainer: '',
  CharacterGender: '',
  CharacterType: '',
);
const WherigoTimerData _WHERIGO_EMPTYTESTTIMER_LUA = WherigoTimerData(
  TimerLUAName: '',
  TimerID: '',
  TimerName: '',
  TimerDescription: '',
  TimerVisible: '',
  TimerDuration: '',
  TimerType: '',
);
const WherigoInputData _WHERIGO_EMPTYTESTINPUT_LUA = WherigoInputData(
  InputLUAName: '',
  InputID: '',
  InputVariableID: '',
  InputName: '',
  InputDescription: '',
  InputVisible: '',
  InputMedia: '',
  InputIcon: '',
  InputType: '',
  InputText: '',
  InputChoices: [],
  InputAnswers: [],
);
WherigoAnswer _WHERIGO_EMPTYTESTANSWER_LUA = WherigoAnswer(
  InputFunction: '',
  InputAnswers: [],
);
const List<WherigoVariableData> emptyListVariable = [];
const List<WherigoBuilderVariableData> emptyListBuilderVariable = [];
const List<List<WherigoActionMessageElementData>> emptyListMessages = [];

void main() {
  String emptyString = '';

  group("Wherigo_analyze.TASK:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTTASK_LUA,
      },
      {
        'input': testInputTASK,
        'expectedOutput': testOutputTASK,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.TASKS);
        expectTask(
          _actual.cartridgeTestTask,
          elem['expectedOutput'] as WherigoTaskData,
        );
      });
    }
  });

  group("Wherigo_analyze.TIMER:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTTIMER_LUA,
      },
      {
        'input': testInputTIMER,
        'expectedOutput': testOutputTIMER,
      },
      {
        'input': testInputTIMERGC,
        'expectedOutput': testOutputTIMERGC,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.TIMERS);
        expectTimer(
          _actual.cartridgeTestTimer,
          elem['expectedOutput'] as WherigoTimerData,
        );
      });
    }
  });

  group("Wherigo_analyze.ZONE:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTZONE_LUA,
      },
      {
        'input': testInputZONE,
        'expectedOutput': testOutputZONE,
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.ZONES);
        expectZone(
          _actual.cartridgeTestZone,
          elem['expectedOutput'] as WherigoZoneData,
        );
      });
    }
  });

  group("Wherigo_analyze.MEDIA:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTMEDIA_LUA,
      },
      {
        'input': testInputMEDIA,
        'expectedOutput': testOutputMEDIA,
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.MEDIAFILES);
        expectMedia(
          _actual.cartridgeTestMedia,
          elem['expectedOutput'] as WherigoMediaData,
        );
      });
    }
  });

  group("Wherigo_analyze.ITEM:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTITEM_LUA,
      },
      {
        'input': testInputITEM,
        'expectedOutput': testOutputITEM,
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.ITEMS);
        expectItem(
          _actual.cartridgeTestItem,
          elem['expectedOutput'] as WherigoItemData,
        );
      });
    }
  });

  group("Wherigo_analyze.CHARACTER:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTCHARACTER_LUA,
      },
      {
        'input': testInputCHARACTER,
        'expectedOutput': testOutputCHARACTER,
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.CHARACTER);
        expectCharacter(
          _actual.cartridgeTestCharacter,
          elem['expectedOutput'] as WherigoCharacterData,
        );
      });
    }
  });

  group("Wherigo_analyze.INPUT:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTINPUT_LUA,
      },
      {
        'input': testInputINPUT,
        'expectedOutput': testOutputINPUT,
      },
      {
        'input': testInputINPUTGC,
        'expectedOutput': testOutputINPUTGC,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.INPUTS);
        expectInput(_actual.cartridgeTestInput, elem['expectedOutput'] as WherigoInputData);
      });
    }
  });

  group("Wherigo_analyze.VARIABLES:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': emptyListVariable,
      },
      {
        'input': testInputVARIABLE_BUILDERVAR,
        'expectedOutput': testOutputVARIABLE_BUILDERVAR,
      },
      {
        'input': testInputVARIABLE,
        'expectedOutput': testOutputVARIABLE,
      },
      {
        'input': testInputVARIABLEGC78Z6J,
        'expectedOutput': testOutputVARIABLEGC78Z6J,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.VARIABLES);
        expectVariable(_actual.cartridgeTestVariable, elem['expectedOutput'] as List<WherigoVariableData>);
      });
    }
  });

  group("Wherigo_analyze.BUILDERVARIABLES:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': emptyListBuilderVariable,
      },
      {
        'input': testInputBUILDERVARIABLE,
        'expectedOutput': testOutputBUILDERVARIABLE,
      },
      {
        'input': testInputVARIABLE_BUILDERVARGC,
        'expectedOutput': testOutputBUILDERVARIABLEGC,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.BUILDERVARIABLES);
        expectBuilderVariable(
            _actual.cartridgeTestBuilderVariable, elem['expectedOutput'] as List<WherigoBuilderVariableData>);
      });
    }
  });

  group("Wherigo_analyze.OBFUSCATION:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': testInputLUASOURCE, 'expectedOutput': ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        //var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.OBFUSCATORTABLE);
      });
    }
  });

  group("Wherigo_analyze.GWC:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'test.gwc', 'expectedOutput': testOutputGWC},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(_getFileData(elem['input'] as String), WHERIGO_OBJECT.OBFUSCATORTABLE);
        expectGWC(_actual.cartridgeGWC, elem['expectedOutput'] as WherigoCartridgeGWC);
      });
    }
  });

  group("Wherigo_analyze.MESSAGES:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': emptyListMessages,
      },
      {
        'input': testInputMESSAGE,
        'expectedOutput': testOutputMESSAGE,
      }
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.MESSAGES);
        expectMessage(
            _actual.cartridgeTestMessageDialog, elem['expectedOutput'] as List<List<WherigoActionMessageElementData>>);
      });
    }
  });


  group("Wherigo_analyze.ANSWERS:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': emptyString,
        'expectedOutput': _WHERIGO_EMPTYTESTANSWER_LUA,
      },
      {
        'input': testInputANSWER,
        'expectedOutput': testOutputANSWER,
      },
      {
        'input': testInputANSWERGC,
        'expectedOutput': testOutputANSWERGC,
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}}', () {
        var _actual = wherigoTest(elem['input'], WHERIGO_OBJECT.ANSWERS);
        expectANSWER(_actual.cartridgeTestAnswers, elem['expectedOutput'] as WherigoAnswer);
      });
    }
  });
}
