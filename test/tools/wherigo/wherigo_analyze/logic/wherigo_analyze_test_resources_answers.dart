import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoAnswer testOutputANSWERGC = WherigoAnswer(InputFunction: 'zinputFinal', InputAnswers: [
    WherigoAnswerData(AnswerAnswer: 'Drache\ndrache', AnswerHash: '', AnswerActions: [
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'cartILuebeck.Complete = true'),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: ' .. Player.CompletionCode .. '),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmedialogo'),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'zitemUnlockCode:MoveTo(Player)'),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Das war leider nicht korrekt. Versuch es anders.'),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmediathavorianer'),
      WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON, ActionMessageContent: '"Unlock-Code"'),
    ]),
]);

WherigoAnswer testOutputANSWER = WherigoAnswer(InputFunction: '_Ejb_', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '491', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Wunderbach, du scheinst sehr gute Augen zu haben.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_rZ0wN'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_Aie.Complete = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_n1j.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_n1j.Visible = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_kcK.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_kcK.Visible = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_4VcW.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_lJLB.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND,
        ActionMessageContent: '_L0J.Commands._PxceW.Enabled = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND,
        ActionMessageContent: '_L0J.Commands._geDc.Enabled = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_L0J:MoveTo(_lJLB)'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'ShowScreen MAINSCREEN'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Das war er wohl nicht ... versuche es doch einfach erneut!'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_rZ0wN'),
  ]) // final List<WherigoActionMessageElementData>
]);

String testInputANSWER = '''
function _Ejb_:OnGetInput(input)
  input = tonumber(input)
  if input == nil then
    return
  end
  if input == 491 then
    _KMOuP()
    _Urwigo.Dialog(false, {
      {
        Text = "Wunderbach, du scheinst sehr gute Augen zu haben.",
        Media = _rZ0wN,
        Buttons = {"Ok"}
      }
    }, function(action)
      _LQrTf.Media = _OVQaC
      _Aie.Complete = true
      _n1j.Active = true
      _n1j.Visible = true
      _kcK.Active = true
      _kcK.Visible = true
      _4VcW.Active = false
      _lJLB.Active = true
      _L0J.Commands._PxceW.Enabled = false
      _L0J.Commands._geDc.Enabled = false
      _L0J:MoveTo(_lJLB)
      Wherigo.ShowScreen(Wherigo.MAINSCREEN)
    end)
  else
    _Urwigo.Dialog(false, {
      {
        Text = "Das war er wohl nicht ... versuche es doch einfach erneut!",
        Media = _rZ0wN,
        Buttons = {"Ok"}
      }
    }, nil)
    FalscheEingabe = FalscheEingabe + 1
  end
end''';

String testInputANSWERGC = '''
function zinputFinal:OnGetInput(input)
  var_Final = input
  if var_Final ~= nil then
    if Wherigo.NoCaseEquals(var_Final, "Drache") or Wherigo.NoCaseEquals(var_Final, "drache") then
      cartILuebeck.Complete = true
      Wherigo.MessageBox({
        Text = WWB_multiplatform_string("" .. Player.CompletionCode .. "}),
        Media = zmedialogo,
        Callback = cartILuebeck.MsgBoxCBFuncs.MsgBoxCB180
      })
      zitemUnlockCode.Description = WWB_multiplatform_string("" .. Player.CompletionCode .. "")
      zitemUnlockCode:MoveTo(Player)
    else
      Wherigo.MessageBox({
        Text = [[Das war leider nicht korrekt. Versuch es anders.]],
        Media = zmediathavorianer,
        Buttons = {
          "Unlock-Code"
        },
        Callback = cartILuebeck.MsgBoxCBFuncs.MsgBoxCB181
      })
    end
  end
end
''';

void expectANSWER(
  WherigoAnswer actual,
  WherigoAnswer expected,
) {
  expect(actual.InputFunction, expected.InputFunction);

  List<WherigoAnswerData> listInputAnswers = actual.InputAnswers;
  if (expected.InputAnswers.length == listInputAnswers.length) {
    for (int i = 0; i < listInputAnswers.length; i++) {
      expect(listInputAnswers[i].AnswerAnswer, expected.InputAnswers[i].AnswerAnswer);
      expect(listInputAnswers[i].AnswerHash, expected.InputAnswers[i].AnswerHash);

      List<WherigoActionMessageElementData>? listAnswerActions = listInputAnswers[i].AnswerActions;

      for (int j = 0; j < listAnswerActions.length; j++) {
        expect(listAnswerActions[j].ActionMessageType, expected.InputAnswers[i].AnswerActions[j].ActionMessageType);
        expect(
            listAnswerActions[j].ActionMessageContent, expected.InputAnswers[i].AnswerActions[j].ActionMessageContent);
      }
    }
  } else {
    expect(true, false);
  }
}
