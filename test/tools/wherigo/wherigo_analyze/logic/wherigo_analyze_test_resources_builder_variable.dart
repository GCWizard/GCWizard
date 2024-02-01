import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

String testInputVARIABLE_BUILDERVARGC = '''
buildervar = {}
buildervar.var_Anzahl = {}
buildervar.var_Anzahl.Id = "267b20afe75745002981d1d54753e9cc"
buildervar.var_Anzahl.Name = "Anzahl"
buildervar.var_Anzahl.Type = "Number"
buildervar.var_Anzahl.Data = "0"
buildervar.var_Bronze = {}
buildervar.var_Bronze.Id = "5046477a65cb4436ffe0a97fed127221"
buildervar.var_Bronze.Name = "Bronze"
buildervar.var_Bronze.Type = "Number"
buildervar.var_Bronze.Data = "0"
buildervar.var_Final = {}
buildervar.var_Final.Id = "dc0ed01b5e82aeaeaf245a2b4080c929"
buildervar.var_Final.Name = "Final"
buildervar.var_Final.Type = "String"
buildervar.var_Final.Data = ""
buildervar.var_Gold = {}
buildervar.var_Gold.Id = "c850d1feea2f02f1f26ac05dadbae39a"
buildervar.var_Gold.Name = "Gold"
buildervar.var_Gold.Type = "Number"
buildervar.var_Gold.Data = "0"
buildervar.var_Silber = {}
buildervar.var_Silber.Id = "3830970a4f5dfce9292f8d1570e7be50"
buildervar.var_Silber.Name = "Silber"
buildervar.var_Silber.Type = "Number"
buildervar.var_Silber.Data = "0"
''';

String testInputBUILDERVARIABLE = 'buildervar.Answer = {}\n' +
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

List<WherigoBuilderVariableData> testOutputBUILDERVARIABLE = [
  const WherigoBuilderVariableData(
    BuilderVariableID: '00000000-0000-0000-0000-000000000000',
    BuilderVariableName: 'Answer',
    BuilderVariableType: 'String',
    BuilderVariableData: '',
    BuilderVariableDescription: '',
  ),
  const WherigoBuilderVariableData(
    BuilderVariableID: '00000000-0000-0000-0000-000000000001',
    BuilderVariableName: 'EnteredFinalZone',
    BuilderVariableType: 'Flag',
    BuilderVariableData: 'False',
    BuilderVariableDescription:
        'Has the player entered the final zone? &nbsp;Used so the final zone can stay active, but the events will not be triggered a second time.',
  ),
];

List<WherigoBuilderVariableData> testOutputBUILDERVARIABLEGC = [
  const WherigoBuilderVariableData(
    BuilderVariableID: '267b20afe75745002981d1d54753e9cc',
    BuilderVariableName: 'var_Anzahl',
    BuilderVariableType: 'Number',
    BuilderVariableData: '0',
    BuilderVariableDescription: '',
  ),
  const WherigoBuilderVariableData(
    BuilderVariableID: '5046477a65cb4436ffe0a97fed127221',
    BuilderVariableName: 'var_Bronze',
    BuilderVariableType: 'Number',
    BuilderVariableData: '0',
    BuilderVariableDescription: '',
  ),
  const WherigoBuilderVariableData(
    BuilderVariableID: 'dc0ed01b5e82aeaeaf245a2b4080c929',
    BuilderVariableName: 'var_Final',
    BuilderVariableType: 'String',
    BuilderVariableData: '',
    BuilderVariableDescription: '',
  ),
  const WherigoBuilderVariableData(
    BuilderVariableID: 'c850d1feea2f02f1f26ac05dadbae39a',
    BuilderVariableName: 'var_Gold',
    BuilderVariableType: 'Number',
    BuilderVariableData: '0',
    BuilderVariableDescription: '',
  ),
  const WherigoBuilderVariableData(
    BuilderVariableID: '3830970a4f5dfce9292f8d1570e7be50',
    BuilderVariableName: 'var_Silber',
    BuilderVariableType: 'Number',
    BuilderVariableData: '0',
    BuilderVariableDescription: '',
  ),
];

void expectBuilderVariable(List<WherigoBuilderVariableData> actual, List<WherigoBuilderVariableData> expected) {
  for (int i = 0; i < expected.length; i++) {
    expect(actual[i].BuilderVariableID, expected[i].BuilderVariableID);
    expect(actual[i].BuilderVariableName, expected[i].BuilderVariableName);
    expect(actual[i].BuilderVariableType, expected[i].BuilderVariableType);
    expect(actual[i].BuilderVariableData, expected[i].BuilderVariableData);
    expect(actual[i].BuilderVariableDescription, expected[i].BuilderVariableDescription);
  }
}
