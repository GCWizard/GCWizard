import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<List<WherigoActionMessageElementData>> testOutputMESSAGE = [
  [
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
      ActionMessageContent: 'Also im Emulator spielen ... nun mal ehrlich ...)',
    ),
  ],
  [
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
      ActionMessageContent: '(Hallo  .. Player.Name) .. , echt toll, dass Du mir helfen willst! Die ganzen Nachrichten ueber Politik und Umwelt machen mich voellig durcheinander. Das konn doch nicht so schwierig sein?\n\n        Was hat es mit diesem vernetzten Denken bloss auf sich? Warum ist regieren so schwer? Ich brauche hier echt einen Erklaerbaer, der mich an die Hand nimmt!',
    ),
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE,
      ActionMessageContent: 'objKlaus',
    ),
  ],
  [
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
      ActionMessageContent: '((((Du hast  .. vIntAktionspunkte) ..  Aktionspunkte. ) .. Der Bereich Politik steht bei ) .. vAPPolitik) ..  Punkte',
    ),
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE,
      ActionMessageContent: 'objVester',
    ),
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
      ActionMessageContent: 'Der Bereich Politik laesst sich normalerweise nicht direkt steuern - und Besetchungssgelder gibt es hier nicht. Die Politik wird - wie im Wirkungsgefuege dargestellt - durch die Lebensqualitaet beeinflusst.',
    ),
    WherigoActionMessageElementData(
      ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE,
      ActionMessageContent: 'objWirkungsgefuege',
    ),
  ]
];

String testInputMESSAGE = '''objHinweise = 0
currentZone = "zCache"
currentCharacter = "objFredericVester"
currentItem = "objVernetztesDenken"
currentTask = "vIntRundenzaehler"
currentInput = "objPortal2"
currentTimer = "dummy"
objKlausdenktnach.ZVariables = {
function objKlausdenktnach:OnStart()
  if _G["Env"]["DeviceID"] == "Desktop" or _G["Env"]["Platform"] == "Win32" then
    for k, v in pairs(_G["objKlausdenktnach"]["AllZObjects"]) do
      v["Visible"] = false
      v["Active"] = false
    end
    _Urwigo.MessageBox({
      Text = tostring("Also im Emulator spielen ... nun mal ehrlich ..."),
      Callback = function(action)
        if action ~= nil then
          _G["Wherigo"]["Command"]("SaveClose")
        end
      end
    })
    return
  end
  initFeld()
  _Urwigo.Dialog(false, {
    {
      Text = ("Hallo " .. Player.Name) .. ", echt toll, dass Du mir helfen willst! Die ganzen Nachrichten ueber Politik und Umwelt machen mich voellig durcheinander. Das konn doch nicht so schwierig sein?<BR><BR>Was hat es mit diesem vernetzten Denken bloss auf sich? Warum ist regieren so schwer? Ich brauche hier echt einen Erklaerbaer, der mich an die Hand nimmt!",
      Media = objKlaus
    }
  }, function(action)
    Wherigo.ShowScreen(Wherigo.MAINSCREEN)
  end)
end
function zPolitik:OnEnter()
  currentZone = "zPolitik"
  objPolitik.Visible = true
  objFredericVester:MoveTo(_G[currentZone])
  objKlausMastermindKlabuster:MoveTo(_G[currentZone])
  _Urwigo.Dialog(false, {
    {
      Text = (((("Du hast " .. vIntAktionspunkte) .. " Aktionspunkte. ") .. "Der Bereich Politik steht bei ") .. vAPPolitik) .. " Punkte",
      Media = objVester
    },
    {
      Text = "Der Bereich Politik laesst sich normalerweise nicht direkt steuern - und Besetchungssgelder gibt es hier nicht. Die Politik wird - wie im Wirkungsgefuege dargestellt - durch die Lebensqualitaet beeinflusst.",
      Media = objWirkungsgefuege
    }
  }, function(action)
    Wherigo.ShowScreen(Wherigo.MAINSCREEN)
  end)
end''';

void expectMessage(List<List<WherigoActionMessageElementData>> actual, List<List<WherigoActionMessageElementData>> expected){
  List<WherigoActionMessageElementData> actualList  = [];
  List<WherigoActionMessageElementData> expectedList = [];
  for (int i = 0; i < actual.length; i++) {
    actualList = actual[i];
    expectedList = expected[i];
    for (int j = 0; j < actualList.length; j++) {
      expect(actualList[j].ActionMessageType, expectedList[j].ActionMessageType);
      expect(actualList[j].ActionMessageContent, expectedList[j].ActionMessageContent);
    }
  }
}
