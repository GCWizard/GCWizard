import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoTimerData testOutputTIMER = const WherigoTimerData(
  TimerLUAName: 'objupdate_distance',
  TimerID: 'f8e161bb-9069-4a91-8f41-ea3927d37561',
  TimerName: 'update_distance',
  TimerDescription: '',
  TimerVisible: 'true',
  TimerDuration: '3',
  TimerType: 'interval',
);

WherigoTimerData testOutputTIMERGC = const WherigoTimerData(
  TimerLUAName: 'terminate',
  TimerID: '',
  TimerName: '',
  TimerDescription: '',
  TimerVisible: '',
  TimerDuration: '3',
  TimerType: 'countdown',
);

String testInputTIMERGC = '''
terminate = Wherigo.ZTimer(cart)
      terminate.Type = "Countdown"
      terminate.Duration = 3
      terminate:Start()
      Wherigo.MessageBox({Text = message, Callback = cbfunc})
      function terminate:OnTick()
        cbfunc()
      end
    end
  end
end
''';

String testInputTIMER = 'objupdate_distance = Wherigo.ZTimer(objKlausMastermindKlabuster)\n' +
    'objupdate_distance.Id = "f8e161bb-9069-4a91-8f41-ea3927d37561"\n' +
    'objupdate_distance.Name = "update_distance"\n' +
    'objupdate_distance.Description = ""\n' +
    'objupdate_distance.Visible = true\n' +
    'objupdate_distance.Duration = 3\n' +
    'objupdate_distance.Type = "Interval"';

void expectTimer(WherigoTimerData actual, WherigoTimerData expected, ){
  expect(actual.TimerLUAName, expected.TimerLUAName);
  expect(actual.TimerID, expected.TimerID);
  expect(actual.TimerName, expected.TimerName);
  expect(actual.TimerDescription, expected.TimerDescription);
  expect(actual.TimerVisible, expected.TimerVisible);
  expect(actual.TimerDuration, expected.TimerDuration);
  expect(actual.TimerType, expected.TimerType);
}