part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoTest wherigoTest(dynamic dataToTest, WHERIGO_OBJECT typeOfTest) {
  WherigoTest result = WherigoTest(
    cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
    cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
    cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
    cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
    cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
    cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
    cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
    cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
    cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
    cartridgeTestVariable: [],
    cartridgeTestBuilderVariable: [],
    cartridgeTestMessageDialog: [],
    cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
  );

  switch (typeOfTest) {
    case WHERIGO_OBJECT.ITEMS:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _analyzeAndExtractItemSectionData((dataToTest as String).split('\n')),
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.TASKS:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _analyzeAndExtractTaskSectionData((dataToTest as String).split('\n')),
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.TIMERS:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _analyzeAndExtractTimerSectionData((dataToTest as String).split('\n')),
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.CHARACTER:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _analyzeAndExtractCharacterSectionData((dataToTest as String).split('\n')),
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.ZONES:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _analyzeAndExtractZoneSectionData((dataToTest as String).split('\n')),
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.INPUTS:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _analyzeAndExtractInputSectionData((dataToTest as String).split('\n')),
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.MEDIAFILES:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _analyzeAndExtractMediaSectionData((dataToTest as String).split('\n')),
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.VARIABLES:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: _analyzeAndExtractVariableSectionData((dataToTest as String).split('\n')),
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    case WHERIGO_OBJECT.BUILDERVARIABLES:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: _analyzeAndExtractBuilderVariableSectionData((dataToTest as String).split('\n')),
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    //TODO
    case WHERIGO_OBJECT.GWCFILE:
      break;
    case WHERIGO_OBJECT.HEADER:
      break;
    case WHERIGO_OBJECT.ANSWERS:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: [],
        cartridgeTestAnswers: _analyzeAndExtractOnGetInputSectionData((dataToTest as String).split('\n')),
      );
      break;
    case WHERIGO_OBJECT.MESSAGES:
      result = WherigoTest(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeTestTask: _WHERIGO_EMPTYTESTTASK_LUA,
        cartridgeTestTimer: _WHERIGO_EMPTYTESTTIMER_LUA,
        cartridgeTestZone: _WHERIGO_EMPTYTESTZONE_LUA,
        cartridgeTestCharacter: _WHERIGO_EMPTYTESTCHARACTER_LUA,
        cartridgeTestItem: _WHERIGO_EMPTYTESTITEM_LUA,
        cartridgeTestInput: _WHERIGO_EMPTYTESTINPUT_LUA,
        cartridgeTestObfuscation: _WHERIGO_EMPTYTESTOBFUSCATION_LUA,
        cartridgeTestMedia: _WHERIGO_EMPTYTESTMEDIA_LUA,
        cartridgeTestVariable: [],
        cartridgeTestBuilderVariable: [],
        cartridgeTestMessageDialog: _getAllMessagesAndDialogsFromLUA(0, (dataToTest as String).split('\n'), null, 1),
        cartridgeTestAnswers: _WHERIGO_EMPTYTESTANSWER_LUA,
      );
      break;

    default:
  }

  return result;
}
