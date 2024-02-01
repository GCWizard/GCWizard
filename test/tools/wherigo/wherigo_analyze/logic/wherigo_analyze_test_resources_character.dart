import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoCharacterData testOutputCHARACTER = const WherigoCharacterData(
  CharacterLUAName: 'objFredericVester',
  CharacterID: '1cb0425c-d5f9-4252-9f99-d2910900310e',
  CharacterName: 'Frederic Vester',
  CharacterDescription: 'Frederic Vester (* 23. November 1925 in Saarbruecken; + 2. November 2003 in Muenchen) war ein deutscher Biochemiker, Systemforscher, Umweltexperte, Universitaetsprofessor und populaerwissenschaftlicher Autor.\nUnter Berufung auf die Kybernetik (bzw. Biokybernetik) hat Vester systemisches, vernetztes Denken propagiert, ein Ansatz, in dem die Eigenschaften eines Systems als ein vernetztes Wirkungsgefuege gesehen werden.',
  CharacterVisible: 'false',
  CharacterMediaName: 'objVester',
  CharacterIconName: 'objicovester',
  CharacterLocation: '',
  CharacterZonepoint: WherigoZonePoint(),
  CharacterContainer: 'zPortal',
  CharacterGender: 'male',
  CharacterType: 'NPC',
);

String testInputCHARACTER =
    'objFredericVester = Wherigo.ZCharacter({Cartridge = objKlausdenktnach, Container = zPortal})\n' +
        'objFredericVester.Id = "1cb0425c-d5f9-4252-9f99-d2910900310e"\n' +
        'objFredericVester.Name = "Frederic Vester"\n' +
        'objFredericVester.Description = "Frederic Vester (* 23. November 1925 in Saarbruecken; + 2. November 2003 in Muenchen) war ein deutscher Biochemiker, Systemforscher, Umweltexperte, Universitaetsprofessor und populaerwissenschaftlicher Autor.<BR>Unter Berufung auf die Kybernetik (bzw. Biokybernetik) hat Vester systemisches, vernetztes Denken propagiert, ein Ansatz, in dem die Eigenschaften eines Systems als ein vernetztes Wirkungsgefuege gesehen werden. "\n' +
        'objFredericVester.Visible = false\n' +
        'objFredericVester.Media = objVester\n' +
        'objFredericVester.Icon = objicovester\n' +
        'objFredericVester.Commands = {\n' +
        'cmdBescheid = Wherigo.ZCommand({\n' +
        'Text = "Bescheid!",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nicht verfugbar"\n' +
        '}),\n' +
        'cmdInvestieren = Wherigo.ZCommand({\n' +
        'Text = "Investieren!",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nicht verfugbar"\n' +
        '}),\n' +
        'cmdWiestehtes = Wherigo.ZCommand({\n' +
        'Text = "Wie steht es?",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nicht verfugbar"\n' +
        '}),\n' +
        'cmdBilanz = Wherigo.ZCommand({\n' +
        'Text = "Bilanz?",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nicht verfugbar"\n' +
        '}),\n' +
        'cmdHilfe = Wherigo.ZCommand({\n' +
        'Text = "Hilfe!",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nothing available"\n' +
        '}),\n' +
        'cmdAnleitung = Wherigo.ZCommand({\n' +
        'Text = "Anleitung",\n' +
        'CmdWith = false,\n' +
        'Enabled = true,\n' +
        'EmptyTargetListText = "Nothing available"\n' +
        '})\n' +
        '}\n' +
        'objFredericVester.Commands.cmdBescheid.Custom = true\n' +
        'objFredericVester.Commands.cmdBescheid.Id = "de00d699-0924-48aa-9eaf-c9ae6a623b31"\n' +
        'objFredericVester.Commands.cmdBescheid.WorksWithAll = true\n' +
        'objFredericVester.Commands.cmdInvestieren.Custom = true\n' +
        'objFredericVester.Commands.cmdInvestieren.Id = "38895742-8813-4bf0-a6f4-6fba45a20b7a"\n' +
        'objFredericVester.Commands.cmdInvestieren.WorksWithAll = true\n' +
        'objFredericVester.Commands.cmdWiestehtes.Custom = true\n' +
        'objFredericVester.Commands.cmdWiestehtes.Id = "286dc96d-22bf-4058-a989-700604f1aea9"\n' +
        'objFredericVester.Commands.cmdWiestehtes.WorksWithAll = true\n' +
        'objFredericVester.Commands.cmdBilanz.Custom = true\n' +
        'objFredericVester.Commands.cmdBilanz.Id = "b1e801d2-8090-49ee-b682-38a9eebed6f6"\n' +
        'objFredericVester.Commands.cmdBilanz.WorksWithAll = true\n' +
        'objFredericVester.Commands.cmdHilfe.Custom = true\n' +
        'objFredericVester.Commands.cmdHilfe.Id = "518f0769-d396-4b07-bd8c-881ce55118ff"\n' +
        'objFredericVester.Commands.cmdHilfe.WorksWithAll = true\n' +
        'objFredericVester.Commands.cmdAnleitung.Custom = true\n' +
        'objFredericVester.Commands.cmdAnleitung.Id = "529a4519-bbf7-4157-a53f-c0e0115ae663"\n' +
        'objFredericVester.Commands.cmdAnleitung.WorksWithAll = true\n' +
        'objFredericVester.ObjectLocation = Wherigo.INVALID_ZONEPOINT\n' +
        'objFredericVester.Gender = "Male"\n' +
        'objFredericVester.Type = "NPC"';

void expectCharacter(WherigoCharacterData actual, WherigoCharacterData expected, ){
  expect(actual.CharacterLUAName, expected.CharacterLUAName);
  expect(actual.CharacterID, expected.CharacterID);
  expect(actual.CharacterName, expected.CharacterName);
  expect(actual.CharacterDescription, expected.CharacterDescription);
  expect(actual.CharacterVisible, expected.CharacterVisible);
  expect(actual.CharacterMediaName, expected.CharacterMediaName);
  expect(actual.CharacterIconName, expected.CharacterIconName);
  expect(actual.CharacterLocation, expected.CharacterLocation);
  expect(actual.CharacterZonepoint, expected.CharacterZonepoint);
  expect(actual.CharacterContainer, expected.CharacterContainer);
  expect(actual.CharacterGender, expected.CharacterGender);
  expect(actual.CharacterType, expected.CharacterType);
}

