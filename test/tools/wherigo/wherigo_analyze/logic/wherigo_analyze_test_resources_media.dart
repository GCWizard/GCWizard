import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoMediaData testOutputMEDIA = const WherigoMediaData(
  MediaLUAName: 'objicospoiler',
  MediaID: '233c2988-a38c-4ca5-8ddf-fe8fcc2ffb86',
  MediaName: 'ico-spoiler',
  MediaDescription: '',
  MediaAltText: '',
  MediaType: 'jpg',
  MediaFilename: 'ico-spoiler.jpg',
);

String testInputMEDIA = 'objicospoiler = Wherigo.ZMedia(objKlausMastermindKlabuster)\n' +
    'objicospoiler.Id = "233c2988-a38c-4ca5-8ddf-fe8fcc2ffb86"\n' +
    'objicospoiler.Name = "ico-spoiler"\n' +
    'objicospoiler.Description = ""\n' +
    'objicospoiler.AltText = ""\n' +
    'objicospoiler.Resources = {\n' +
    '{\n' +
    'Type = "jpg",\n' +
    'Filename = "ico-spoiler.jpg",\n' +
    'Directives = {}\n' +
    '}\n' +
    '}';

void expectMedia(WherigoMediaData actual, WherigoMediaData expected, ){
  expect(actual.MediaLUAName, expected.MediaLUAName);
  expect(actual.MediaID, expected.MediaID);
  expect(actual.MediaName, expected.MediaName);
  expect(actual.MediaDescription, expected.MediaDescription);
  expect(actual.MediaAltText, expected.MediaAltText);
  expect(actual.MediaType, expected.MediaType);
  expect(actual.MediaFilename, expected.MediaFilename);}