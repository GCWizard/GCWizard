import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

WherigoAnswer testOutputANSWER = WherigoAnswer(InputFunction: '_Ejb_', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '491', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Wunderbach, du scheinst sehr gute Augen zu haben.'),
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
  ]),
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Das war er wohl nicht ... versuche es doch einfach erneut!'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_rZ0wN'),
  ]),
  // final List<WherigoActionMessageElementData>
]);

WherigoAnswer testOutputANSWERGC = WherigoAnswer(InputFunction: 'zinputFinal', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: 'Drache\ndrache', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'cartILuebeck.Complete = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: ' .. Player.CompletionCode .. '),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmedialogo'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'zitemUnlockCode:MoveTo(Player)'),
  ]),
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Das war leider nicht korrekt. Versuch es anders.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmediathavorianer'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON, ActionMessageContent: '"Unlock-Code"'),
  ]),
]);

WherigoAnswer testOutputANSWERGCWandernMitWalter01 = WherigoAnswer(InputFunction: '_U9jrC', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '_xOfI', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Perfekt, dann können wir ja los.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_jKUq'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'ShowScreen MAINSCREEN'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_fRPL.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_fRPL.Visible = true'),
  ]),
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Versuch es nochmal.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_gPf'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'Wherigo.GetInput(_U9jrC)'),
  ]),
]);

WherigoAnswer testOutputANSWERGCWandernMitWalter02 = WherigoAnswer(InputFunction: '_CCLU', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '_ZA9h', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Absolut richtig! Weiter gehts.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_jKUq'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'ShowScreen MAINSCREEN'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_YEA3.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_YEA3.Visible = true'),
  ]),
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Versuch es nochmal.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_gPf'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'Wherigo.GetInput(_CCLU)'),
  ]),
]);

WherigoAnswer testOutputANSWERGCMighla01 =
    WherigoAnswer(InputFunction: 'zinputHilfeKettenschlossAuflsung', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '310', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Die Ersatzteile sind:'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmediaLsung'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON, ActionMessageContent: '"Code eingeben",'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON,
        ActionMessageContent: 'WWB_multiplatform_string("zurück", {PocketPC = 1})'),
  ]),
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Auf Seite 45 musst Du die letzten Worte jeder Zeile von oben nach unten lesen. In der App sind die Zeilen mit einem Strich - am Anfang und Ende gekennzeichnet.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: 'zmediaLsungFrage'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON, ActionMessageContent: '"Ja",'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON, ActionMessageContent: '"neuer Versuch"'),
  ]),
]);

WherigoAnswer testOutputANSWEREdersee_48h5 = WherigoAnswer(InputFunction: '_48h5', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '33911\x01aiiyn\x0162', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Das ist natuerlich korrekt und die aktuelle Aufgabe damit schon erledigt.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Und da dies gleichzeitig die letzte Aufgabe der Stufe 2 war, kannst du ab jetzt jederzeit Final Stufe 2 aktivieren.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_jBF9t.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_WWB.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_cJX.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_C_G9.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_bHJ.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Bevor du dich aber auf den Weg zum Final von Stufe 2 machst, solltest du erst noch die restlichen Edersee-Atlantis-Aufgaben erledigen.\nDann kannst du anschliessend gleich mehrere Dosen auf einmal einsammeln.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_3_2.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_MKBn:MoveTo(nil)'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Bevor du dich aber auf den Weg zum Final von Stufe 2 machst, solltest du erst noch die restlichen Edersee-Atlantis-Aufgaben erledigen.\nDann kannst du anschliessend gleich mehrere Dosen auf einmal einsammeln.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_5sM.Active = true'),
  ]), // final List<WherigoActionMessageElementData>
  WherigoAnswerData(AnswerAnswer: '>62', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Leider verkehrt!\nDie gesuchte Grabnummer ist nicht so hoch.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_RCtz'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'Wherigo.GetInput(_48h5)'),
  ]), // final List<WherigoActionMessageElementData>
  WherigoAnswerData(AnswerAnswer: '<62', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Leider verkehrt!\nDie gesuchte Grabnummer ist nicht so niedrig.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_RCtz'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: 'Wherigo.GetInput(_48h5)'),
  ]), // final List<WherigoActionMessageElementData>
]);

WherigoAnswer testOutputANSWEREdersee_VKB = WherigoAnswer(InputFunction: '_VKB', InputAnswers: [
  WherigoAnswerData(AnswerAnswer: '>=240 && <=250', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Im Rahmen der Messgenauigkeit lasse ich dieses Ergebnis auf jeden Fall gelten.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Jetzt besuche noch kurz das Denkmal.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_JU_y'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_wR46N.Active = false'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_k5m4.Active = true'),
  ]), // final List<WherigoActionMessageElementData>
  WherigoAnswerData(AnswerAnswer: '>215 && <240', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'So ganz richtig ist deine Antwort nicht.\nEin klein wenig laenger ist der Trog schon.\nIch glaube, du hast nur geschaetzt und nicht gemessen.\nUnd das nicht sonderlich gut hinbekommen.\n'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Nur fuer den Fall, dass du eventuell einen falschen Futtertrog vermessen haben solltest, ist hier noch mal ein Spoilerbild.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_akoE'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Probiere es noch einmal!\n(nachdem du die Zone kurz verlassen und wieder betreten hast)'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_wR46N.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_Rv8P.Active = false'),
  ]), // final List<WherigoActionMessageElementData>
  WherigoAnswerData(AnswerAnswer: '>250 && <275', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'So ganz richtig ist deine Antwort nicht.\nEin klein wenig kuerzer ist der Trog schon.\nIch glaube, du hast nur geschaetzt und nicht gemessen.\nUnd das nicht sonderlich gut hinbekommen.\n'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Nur fuer den Fall, dass du eventuell einen falschen Futtertrog vermessen haben solltest, ist hier noch mal ein Spoilerbild.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_akoE'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Probiere es noch einmal!\n(nachdem du die Zone kurz verlassen und wieder betreten hast)'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_wR46N.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_Rv8P.Active = false'),
  ]), // final List<WherigoActionMessageElementData>
  WherigoAnswerData(AnswerAnswer: '-<ELSE>-', AnswerHash: '', AnswerActions: [
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Also deine Antwort ist leider vollkommen (auf jeden Fall mehr als 30 cm) verkehrt.'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent: 'Hast du vielleicht einen falschen Futtertrog vermessen?'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Hier noch mal ein Spoilerbild.'),
    WherigoActionMessageElementData(ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.IMAGE, ActionMessageContent: '_akoE'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT,
        ActionMessageContent:
            'Oder hast du als Einheit nicht wie gefordert Zentimeter sondern etwas anderes gewaehlt?'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.TEXT, ActionMessageContent: 'Probiere es noch einmal!'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_wR46N.Active = true'),
    WherigoActionMessageElementData(
        ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.COMMAND, ActionMessageContent: '_Rv8P.Active = false'),
  ]),
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

String testInputANSWERGCWandernMitWalter01 = '''
function _U9jrC:OnGetInput(input)
  if input == nil then
    input = ""
  end
  if Wherigo.NoCaseEquals(_xOfI, input) then
    _Urwigo.MessageBox({
      Text = "Perfekt, dann können wir ja los.",
      Media = _jKUq,
      Callback = function(action)
        if action ~= nil then
          Wherigo.ShowScreen(Wherigo.MAINSCREEN)
        end
      end
    })
    _fRPL.Active = true
    _fRPL.Visible = true
  else
    _Urwigo.MessageBox({
      Text = "Versuch es nochmal.",
      Media = _gPf,
      Callback = function(action)
        if action ~= nil then
          _Urwigo.RunDialogs(function()
            Wherigo.GetInput(_U9jrC)
          end)
        end
      end
    })
  end
end
''';

String testInputANSWERGCWandernMitWalter02 = '''
function _CCLU:OnGetInput(input)
  input = tonumber(input)
  if input == nil then
    return
  end
  if _ZA9h == input then
    _Urwigo.MessageBox({
      Text = "Absolut richtig! Weiter gehts.",
      Media = _jKUq,
      Callback = function(action)
        if action ~= nil then
          Wherigo.ShowScreen(Wherigo.MAINSCREEN)
        end
      end
    })
    _YEA3.Active = true
    _YEA3.Visible = true
  else
    _Urwigo.MessageBox({
      Text = "Versuch es nochmal.",
      Media = _gPf,
      Callback = function(action)
        if action ~= nil then
          _Urwigo.RunDialogs(function()
            Wherigo.GetInput(_CCLU)
          end)
        end
      end
    })
  end
end
''';

String testInputANSWERGCMighla01 = '''
function zinputHilfeKettenschlossAuflsung:OnGetInput(input)
  var_Hilfe = tonumber(input)
  if var_Hilfe ~= nil then
    if var_Hilfe == 310 then
      var_Anzahl_Hilfen_Kettenschloss = "6 Punkte Kettenschloss"
      var_Anzahl_Hilfen_KettenschlossLsung = 6
      Wherigo.MessageBox({
        Text = WWB_multiplatform_string("Die Ersatzteile sind:\nDoppel-Glockenlager \nKurbelkeil\nLenkstange\nSattelstütze\nGlockenriemen \nKettenräder \nDreiradachse\nSattel\nDie Anzahl der gesuchten Buchstaben in den Ersatzteilen sind:\nR=7\nA=6\nD=4\nDer Code für das Kettenschloss lautet: 764", {PocketPC = 1}),
        Media = zmediaLsung,
        Buttons = {
          "Code eingeben",
          WWB_multiplatform_string("zurück", {PocketPC = 1})
        },
        Callback = cartMighlaTeil1v3.MsgBoxCBFuncs.MsgBoxCB171
      })
    else
      Wherigo.MessageBox({
        Text = WWB_multiplatform_string("Auf Seite 45 musst Du die letzten Worte jeder Zeile von oben nach unten lesen. In der App sind die Zeilen mit einem Strich "-" am Anfang und Ende gekennzeichnet.\nDie richtigen Buchstaben sind durch "R-A-D" vorgegeben. R,A,D groß oder klein ist egal. Die Ersatzteile sind umrandet oder in der App großgeschrieben.\n~\nMit dem Code 310 kannst Du Dir die Lösung anzeigen lassen. Möchtest Du das wirklich?\n", {PocketPC = 1}),
        Media = zmediaLsungFrage,
        Buttons = {
          "Ja",
          "neuer Versuch"
        },
        Callback = cartMighlaTeil1v3.MsgBoxCBFuncs.MsgBoxCB172
      })
    end
  end
end
''';

String testInputANSWEREdersee_48h5 = '''
function _48h5:OnGetInput(input)
  input = tonumber(input)
  if input == nil then
    _Urwigo.MessageBox({
      Text = "Nur Ziffern eingeben!",
      Callback = function(action)
        if action ~= nil then
          _Urwigo.RunDialogs(function()
            Wherigo.GetInput(_48h5)
          end)
        end
      end
    })
    return
  end
  if _Urwigo.Hash(string.lower(input)) == 33911 then
    _Urwigo.Dialog(false, {
      {
        Text = "Das ist natuerlich korrekt und die aktuelle Aufgabe damit schon erledigt."
      },
      {
        Text = "Und da dies gleichzeitig die letzte Aufgabe der Stufe 2 war, kannst du ab jetzt jederzeit "Final Stufe 2" aktivieren."
      }
    }, function(action)
      _jBF9t.Active = false
      _WWB.Active = true
      _cJX.Active = false
      _C_G9.Active = false
      _bHJ.Active = false
      if _GIhl == true then
        _Urwigo.OldDialog({
          {
            Text = "Bevor du dich aber auf den Weg zum Final von Stufe 2 machst, solltest du erst noch die restlichen Edersee-Atlantis-Aufgaben erledigen.<BR>Dann kannst du anschliessend gleich mehrere Dosen auf einmal einsammeln."
          }
        })
        _3_2.Active = true
        if _kEjQ == false then
          _MKBn:MoveTo(nil)
        end
      elseif _GIhl == false and _kEjQ == true then
        _Urwigo.OldDialog({
          {
            Text = "Bevor du dich aber auf den Weg zum Final von Stufe 2 machst, solltest du erst noch die restlichen Edersee-Atlantis-Aufgaben erledigen.<BR>Dann kannst du anschliessend gleich mehrere Dosen auf einmal einsammeln."
          }
        })
        _5sM.Active = true
      end
      _ceLKO()
    end)
  elseif input > tonumber("62") then
    _Urwigo.Dialog(false, {
      {
        Text = "Leider verkehrt!<BR>Die gesuchte Grabnummer ist nicht so hoch.",
        Media = _RCtz
      }
    }, function(action)
      _Urwigo.RunDialogs(function()
        Wherigo.GetInput(_48h5)
      end)
    end)
  elseif input < tonumber("62") then
    _Urwigo.Dialog(false, {
      {
        Text = "Leider verkehrt!<BR>Die gesuchte Grabnummer ist nicht so niedrig.",
        Media = _RCtz
      }
    }, function(action)
      _Urwigo.RunDialogs(function()
        Wherigo.GetInput(_48h5)
      end)
    end)
  end
end''';

String testInputANSWEREdersee_VKB = '''
function _VKB:OnGetInput(input)
  input = tonumber(input)
  if input == nil then
    _Urwigo.MessageBox({
      Text = "Nur Ziffern eingeben!",
      Callback = function(action)
        if action ~= nil then
          _Urwigo.RunDialogs(function()
            Wherigo.GetInput(_VKB)
          end)
        end
      end
    })
    return
  end
  if input >= 240 and input <= 250 then
    _Urwigo.Dialog(false, {
      {
        Text = "Im Rahmen der Messgenauigkeit lasse ich dieses Ergebnis auf jeden Fall gelten."
      },
      {
        Text = "Jetzt besuche noch kurz das Denkmal.",
        Media = _JU_y
      }
    }, function(action)
      _wR46N.Active = false
      _k5m4.Active = true
    end)
  elseif input > 215 and input < 240 then
    _Urwigo.Dialog(false, {
      {
        Text = "So ganz richtig ist deine Antwort nicht.<BR>Ein klein wenig laenger ist der Trog schon.<BR>Ich glaube, du hast nur geschaetzt und nicht gemessen.<BR>Und das nicht sonderlich gut hinbekommen.<BR>"
      },
      {
        Text = "Nur fuer den Fall, dass du eventuell einen falschen Futtertrog vermessen haben solltest, ist hier noch mal ein Spoilerbild.",
        Media = _akoE
      },
      {
        Text = "Probiere es noch einmal!<BR>(nachdem du die Zone kurz verlassen und wieder betreten hast)"
      }
    }, function(action)
      _wR46N.Active = true
      _Rv8P.Active = false
    end)
  elseif input > 250 and input < 275 then
    _Urwigo.Dialog(false, {
      {
        Text = "So ganz richtig ist deine Antwort nicht.<BR>Ein klein wenig kuerzer ist der Trog schon.<BR>Ich glaube, du hast nur geschaetzt und nicht gemessen.<BR>Und das nicht sonderlich gut hinbekommen.<BR>"
      },
      {
        Text = "Nur fuer den Fall, dass du eventuell einen falschen Futtertrog vermessen haben solltest, ist hier noch mal ein Spoilerbild.",
        Media = _akoE
      },
      {
        Text = "Probiere es noch einmal!<BR>(nachdem du die Zone kurz verlassen und wieder betreten hast)"
      }
    }, function(action)
      _wR46N.Active = true
      _Rv8P.Active = false
    end)
  else
    _Urwigo.Dialog(false, {
      {
        Text = "Also deine Antwort ist leider vollkommen (auf jeden Fall mehr als 30 cm) verkehrt."
      },
      {
        Text = "Hast du vielleicht einen falschen Futtertrog vermessen?"
      },
      {
        Text = "Hier noch mal ein Spoilerbild.",
        Media = _akoE
      },
      {
        Text = "Oder hast du als Einheit nicht wie gefordert Zentimeter sondern etwas anderes gewaehlt?"
      },
      {
        Text = "Probiere es noch einmal!"
      }
    }, function(action)
      _wR46N.Active = true
      _Rv8P.Active = false
    end)
  end
end''';

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
