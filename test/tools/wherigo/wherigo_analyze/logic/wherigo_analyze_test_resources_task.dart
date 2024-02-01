import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoTaskData testOutputTASK = const WherigoTaskData(
  TaskLUAName: 'objwerdeMastermind',
  TaskID: '376fa2d8-dc30-4bb3-bc29-5998a281c1a8',
  TaskName: 'werde Mastermind',
  TaskDescription: 'Donald E. Knuth hat 1976 gezeigt, dass es moeglich ist, jeden moeglichen Farbcode des Spiels (4 Stellen, 6 Farben) in maximal fuenf Zuegen zu ermitteln.\n'+
      'Kenji Koyama und Tony W. Lai fanden 1994 eine Mastermind-Strategie, die im Durchschnitt nur 4,34 Versuche benoetigt.\n'+
      'Diese Strategie - und jede andere, die im Durchschnitt genauso schnell ist - benoetigt im schlechtesten Fall sechs Versuche.\n'+
      'Sie bewiesen ausserdem, dass es keine schnellere Strategie geben kann.',
  TaskVisible: 'false',
  TaskMedia: 'objFinal',
  TaskIcon: 'objicoFinal',
  TaskActive: 'true',
  TaskComplete: 'false',
  TaskCorrectstate: 'None',
);

String testInputTASK =
'objwerdeMastermind = Wherigo.ZTask(objKlausMastermindKlabuster)\n'+
'objwerdeMastermind.Id = "376fa2d8-dc30-4bb3-bc29-5998a281c1a8"\n'+
'objwerdeMastermind.Name = "werde Mastermind"\n'+
'objwerdeMastermind.Description = [[\n'+
'Donald E. Knuth hat 1976 gezeigt, dass es moeglich ist, jeden moeglichen Farbcode des Spiels (4 Stellen, 6 Farben) in maximal fuenf Zuegen zu ermitteln.<BR>\n'+
'Kenji Koyama und Tony W. Lai fanden 1994 eine Mastermind-Strategie, die im Durchschnitt nur 4,34 Versuche benoetigt.<BR>\n'+
'Diese Strategie - und jede andere, die im Durchschnitt genauso schnell ist - benoetigt im schlechtesten Fall sechs Versuche.<BR>\n'+
'Sie bewiesen ausserdem, dass es keine schnellere Strategie geben kann.]]\n'+
'objwerdeMastermind.Visible = false\n'+
'objwerdeMastermind.Media = objFinal\n'+
'objwerdeMastermind.Icon = objicoFinal\n'+
'objwerdeMastermind.Active = true\n'+
'objwerdeMastermind.Complete = false\n'+
'objwerdeMastermind.CorrectState = "None"';

void expectTask(WherigoTaskData actual, WherigoTaskData expected, ){
  expect(actual.TaskLUAName, expected.TaskLUAName);
  expect(actual.TaskID, expected.TaskID);
  expect(actual.TaskName, expected.TaskName);
  expect(actual.TaskDescription, expected.TaskDescription);
  expect(actual.TaskVisible, expected.TaskVisible);
  expect(actual.TaskMedia, expected.TaskMedia);
  expect(actual.TaskIcon, expected.TaskIcon);
  expect(actual.TaskActive, expected.TaskActive);
  expect(actual.TaskComplete, expected.TaskComplete);
  expect(actual.TaskCorrectstate, expected.TaskCorrectstate);
}

