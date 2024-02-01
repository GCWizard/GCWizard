import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoInputData testOutputINPUTGC = const WherigoInputData(
  InputLUAName: 'zinputFinal',
  InputID: 'bc3d7e27b2632afb762386925af7ef65',
  InputVariableID: 'dc0ed01b5e82aeaeaf245a2b4080c929',
  InputName: 'Final',
  InputDescription: '',
  InputVisible: 'false',
  InputMedia: 'zmedialogo',
  InputIcon: '',
  InputType: 'Text',
  InputText: 'Welches \'Tier\' ist über dem Gold-Final?',
  InputChoices: [],
  InputAnswers: [],
);

WherigoInputData testOutputINPUT = const WherigoInputData(
  InputLUAName: 'objPortal2',
  InputID: '58b21b46-f71b-424f-829e-32d0b8268f34',
  InputVariableID: '',
  InputName: 'Portal',
  InputDescription: '',
  InputVisible: 'true',
  InputMedia: 'objPortal',
  InputIcon: 'objicoPortal',
  InputType: 'MultipleChoice',
  InputText: 'Wohin soll die Reise gehen?',
  InputChoices: ['Industrieland', 'Schwellenland', 'Entwicklungsland', 'Raus', 'Hilfe'],
  InputAnswers: [],
);

String testInputINPUTGC = '''
zinputFinal = Wherigo.ZInput(cartILuebeck)
zinputFinal.Id = "bc3d7e27b2632afb762386925af7ef65"
zinputFinal.Name = "Final"
zinputFinal.InputType = "Text"
zinputFinal.Text = WWB_multiplatform_string("Welches 'Tier' ist über dem Gold-Final?")
zinputFinal.Visible = false
zinputFinal.InputVariableId = "dc0ed01b5e82aeaeaf245a2b4080c929"
zinputFinal.Media = zmedialogo
''';

String testInputINPUT = 'objPortal2 = Wherigo.ZInput(objKlausdenktnach)\n'+
'objPortal2.Id = "58b21b46-f71b-424f-829e-32d0b8268f34"\n'+
'objPortal2.Name = "Portal"\n'+
'objPortal2.Description = ""\n'+
'objPortal2.Visible = true\n'+
'objPortal2.Media = objPortal\n'+
'objPortal2.Icon = objicoPortal\n'+
'objPortal2.Choices = {\n'+
'"Industrieland",\n'+
'"Schwellenland",\n'+
'"Entwicklungsland",\n'+
'"Raus",\n'+
'"Hilfe"\n'+
'}\n'+
'objPortal2.InputType = "MultipleChoice"\n'+
'objPortal2.Text = "Wohin soll die Reise gehen?"';

void expectInput(WherigoInputData actual, WherigoInputData expected, ){
  expect(actual.InputLUAName, expected.InputLUAName);
  expect(actual.InputID, expected.InputID);
  expect(actual.InputVariableID, expected.InputVariableID);
  expect(actual.InputName, expected.InputName);
  expect(actual.InputDescription, expected.InputDescription);
  expect(actual.InputVisible, expected.InputVisible);
  expect(actual.InputMedia, expected.InputMedia);
  expect(actual.InputIcon, expected.InputIcon);
  expect(actual.InputType, expected.InputType);
  expect(actual.InputText, expected.InputText);
  expect(actual.InputChoices, expected.InputChoices);
  expect(actual.InputAnswers, expected.InputAnswers);
}