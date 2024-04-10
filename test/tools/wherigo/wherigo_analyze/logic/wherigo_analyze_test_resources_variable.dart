import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<WherigoVariableData> testOutputVARIABLE_BUILDERVAR = [
  const WherigoVariableData(
    VariableLUAName: 'Answer',
    VariableName: ' ',
  ),
];

String testInputVARIABLEGC3897N = '''
_8KwNK.ZVariables = {}
''';

String testInputVARIABLEGC78Z6J = '''
cartILuebeck.ZVariables = {
  WWB_device = nil,
  var_Anzahl = 0,
  var_Bronze = 0,
  var_Final = "",
  var_Gold = 0,
  var_Silber = 0
}
''';

String testInputVARIABLE_BUILDERVAR = 'cartStetsgernfuerSiebesch.ZVariables = {Answer = ""}\n' +
    'buildervar = {}\n' +
    'buildervar.Answer = {}\n' +
    'buildervar.Answer.Id = "00000000-0000-0000-0000-000000000000"\n' +
    'buildervar.Answer.Name = "Answer"\n' +
    'buildervar.Answer.Type = "String"\n' +
    'buildervar.Answer.Data = ""\n' +
    'buildervar.Answer.Description = ""\n' +
    'buildervar.EnteredFinalZone = {}\n' +
    'buildervar.EnteredFinalZone.Id = "00000000-0000-0000-0000-000000000001"\n' +
    'buildervar.EnteredFinalZone.Name = "EnteredFinalZone"\n' +
    'buildervar.EnteredFinalZone.Type = "Flag"\n' +
    'buildervar.EnteredFinalZone.Data = "False"\n' +
    'buildervar.EnteredFinalZone.Description = "Has the player entered the final zone? &nbsp;Used so the final zone can stay active, but the events will not be triggered a second time."';

List<WherigoVariableData> testOutputVARIABLEGC78Z6J = [
  const WherigoVariableData(
    VariableLUAName: 'cartILuebeck.ZVariables',
    VariableName: '{',
  ),
  const WherigoVariableData(
    VariableLUAName: 'WWB_device',
    VariableName: 'nil',
  ),
  const WherigoVariableData(
    VariableLUAName: 'var_Anzahl',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'var_Bronze',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'var_Final',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'var_Gold',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'var_Silber',
    VariableName: '0',
  ),
];

List<WherigoVariableData> testOutputVARIABLE = [
  const WherigoVariableData(
    VariableLUAName: 'objKlausdenktnach.ZVariables',
    VariableName: '{',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAktionspunkte',
    VariableName: '8',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPSanierung',
    VariableName: '1',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPProduktion',
    VariableName: '9',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPPolitik',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPBevoelkerung',
    VariableName: '23',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPLebensqualitaet',
    VariableName: '9',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPVermehrungsrate',
    VariableName: '20',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPAufklaerung',
    VariableName: '4',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vAPUmweltbelastung',
    VariableName: '13',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vRunde',
    VariableName: '1',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vIntAktionspunkte',
    VariableName: '8',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vIntAPAuf',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vIntAPSan',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vIntAPPro',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vIntAPLeb',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vfirstAPPro',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vfirstAPSan',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vfirstAPLeb',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vfirstAPAuf',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vMeldung',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vLF',
    VariableName: '.<BR>',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanz',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vEnde',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vGutesEnde',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'objBuchLesen',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vParadies',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vStaatsstreich',
    VariableName: 'false',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vEndeMeldung',
    VariableName: 'Aus und vorbei!',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzSan',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzAuf',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzLeb',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzAP',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzPol',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzPro',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzUmw',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzBev',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vBilanzVer',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vUrsache',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPVer',
    VariableName: '20',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPLeb',
    VariableName: '9',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPPro',
    VariableName: '9',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPPol',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPSan',
    VariableName: '1',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPUmw',
    VariableName: '13',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPBev',
    VariableName: '23',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldAPAuf',
    VariableName: '4',
  ),
  const WherigoVariableData(
    VariableLUAName: 'vOldBilanz',
    VariableName: '41',
  ),
  const WherigoVariableData(
    VariableLUAName: 'objName',
    VariableName: '',
  ),
  const WherigoVariableData(
    VariableLUAName: 'objHinweise',
    VariableName: '0',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentZone',
    VariableName: 'zCache',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentCharacter',
    VariableName: 'objFredericVester',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentItem',
    VariableName: 'objVernetztesDenken',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentTask',
    VariableName: 'vIntRundenzaehler',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentInput',
    VariableName: 'objPortal2',
  ),
  const WherigoVariableData(
    VariableLUAName: 'currentTimer',
    VariableName: 'dummy',
  ),
];

String testInputVARIABLE = 'objKlausdenktnach.ZVariables = {\n' +
    'vAktionspunkte = 8,\n' +
    'vAPSanierung = 1,\n' +
    'vAPProduktion = 9,\n' +
    'vAPPolitik = 0,\n' +
    'vAPBevoelkerung = 23,\n' +
    'vAPLebensqualitaet = 9,\n' +
    'vAPVermehrungsrate = 20,\n' +
    'vAPAufklaerung = 4,\n' +
    'vAPUmweltbelastung = 13,\n' +
    'vRunde = 1,\n' +
    'vIntAktionspunkte = 8,\n' +
    'vIntAPAuf = 0,\n' +
    'vIntAPSan = 0,\n' +
    'vIntAPPro = 0,\n' +
    'vIntAPLeb = 0,\n' +
    'vfirstAPPro = false,\n' +
    'vfirstAPSan = false,\n' +
    'vfirstAPLeb = false,\n' +
    'vfirstAPAuf = false,\n' +
    'vMeldung = "",\n' +
    'vLF = ".<BR>",\n' +
    'vBilanz = 0,\n' +
    'vEnde = false,\n' +
    'vGutesEnde = false,\n' +
    'objBuchLesen = false,\n' +
    'vParadies = false,\n' +
    'vStaatsstreich = false,\n' +
    'vEndeMeldung = "Aus und vorbei!",\n' +
    'vBilanzSan = "",\n' +
    'vBilanzAuf = "",\n' +
    'vBilanzLeb = "",\n' +
    'vBilanzAP = "",\n' +
    'vBilanzPol = "",\n' +
    'vBilanzPro = "",\n' +
    'vBilanzUmw = "",\n' +
    'vBilanzBev = "",\n' +
    'vBilanzVer = "",\n' +
    'vUrsache = "",\n' +
    'vOldAPVer = 20,\n' +
    'vOldAPLeb = 9,\n' +
    'vOldAPPro = 9,\n' +
    'vOldAPPol = 0,\n' +
    'vOldAPSan = 1,\n' +
    'vOldAPUmw = 13,\n' +
    'vOldAPBev = 23,\n' +
    'vOldAPAuf = 4,\n' +
    'vOldBilanz = 41,\n' +
    'objName = "",\n' +
    'objHinweise = 0,\n' +
    'currentZone = "zCache",\n' +
    'currentCharacter = "objFredericVester",\n' +
    'currentItem = "objVernetztesDenken",\n' +
    'currentTask = "vIntRundenzaehler",\n' +
    'currentInput = "objPortal2",\n' +
    'currentTimer = "dummy"\n' +
    '}';

void expectVariable(List<WherigoVariableData> actual, List<WherigoVariableData> expected) {
  for (int i = 0; i < expected.length; i++) {
    expect(actual[i].VariableLUAName, expected[i].VariableLUAName);
    expect(actual[i].VariableName, expected[i].VariableName);
  }
}
