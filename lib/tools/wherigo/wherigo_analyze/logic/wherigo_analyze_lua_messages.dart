part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';


void _getAllMessagesAndDialogsFromLUA(int progress, List<String> lines, SendPort? sendAsyncPort, int progressStep) {
  progress = lines.length;
  for (int i = 0; i < lines.length; i++) {
    progress++;
    if (sendAsyncPort != null && (progress % progressStep == 0)) {
      sendAsyncPort.send(DoubleText('progress', progress / lines.length / 2));
    }

    lines[i] = lines[i].trim();
    try {
      if (RegExp(r'(Wherigo.ZCartridge\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.MESSAGES;
      }
      if (currentObjectSection == WHERIGO_OBJECT_TYPE.MESSAGES) {
        if (lines[i].trimLeft().startsWith('_Urwigo.MessageBox(') ||
            lines[i].trimLeft().startsWith('Wherigo.MessageBox(')) {
          _singleMessageDialog = [];

          if (lines[i].contains('Text = ') || lines[i].contains('Media = ')) {
            String line = lines[i];
            if (line.contains('Text = ')) {
              do {
                line = line.substring(1);
              } while (!line.startsWith('Text'));
              line = line.replaceAll('Text = ', '').replaceAll('(', '').replaceAll('{', '');
              if (line.contains('"')) {
                line = line.substring(0, line.indexOf('"')).replaceAll('"', '');
              } else if (line.contains(',')) {
                line = line.substring(0, line.indexOf(',')).replaceAll('"', '');
              } else {
                line = line.substring(0, line.indexOf('}')).replaceAll('"', '');
              }
              if (line.isNotEmpty) {
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.TEXT, line));
              }
            }
            line = lines[i];
            if (line.contains('Media = ')) {
              do {
                line = line.substring(1);
              } while (!line.startsWith('Media'));
              line = line
                  .replaceAll('Media = ', '')
                  .replaceAll('"', '')
                  .replaceAll(',', '')
                  .replaceAll(')', '')
                  .replaceAll('}', '');
              _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.IMAGE, line));
            }
          } else {
            i++;
            lines[i] = lines[i].trim();
            _sectionMessages = true;
            do {
              if (lines[i].trimLeft().startsWith('Text')) {
                _singleMessageDialog.add(WherigoActionMessageElementData(
                    WHERIGO_ACTIONMESSAGETYPE.TEXT, getTextData(lines[i])));
              } else if (lines[i].trimLeft().startsWith('Media')) {
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.IMAGE,
                    lines[i].trimLeft().replaceAll('Media = ', '').replaceAll('"', '').replaceAll(',', '')));
              } else if (lines[i].trimLeft().startsWith('Buttons')) {
                if (lines[i].trimLeft().endsWith('}') || lines[i].trimLeft().endsWith('},')) {
                  // single line
                  _singleMessageDialog.add(WherigoActionMessageElementData(
                      WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                      getTextData(
                          lines[i].trim().replaceAll('Buttons = {', '').replaceAll('},', '').replaceAll('}', ''))));
                } else {
                  // multi line
                  i++;
                  lines[i] = lines[i].trim();
                  List<String> buttonText = [];
                  do {
                    buttonText
                        .add(getTextData(lines[i].replaceAll('),', ')').trim()));
                    i++;
                    lines[i] = lines[i].trim();
                  } while (!lines[i].trimLeft().startsWith('}'));
                  _singleMessageDialog
                      .add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.BUTTON, buttonText.join(' » « ')));
                } // end else multiline
              } // end buttons

              i++;
              lines[i] = lines[i].trim();

              if (i > lines.length - 2 || lines[i].trimLeft().startsWith('})') || lines[i].trimLeft().startsWith('end')) {
                _sectionMessages = false;
              }
            } while (_sectionMessages);
          }
          _cartridgeMessages.add(_singleMessageDialog);
        } else if (lines[i].trimLeft().startsWith('_Urwigo.Dialog(') ||
            lines[i].trimLeft().startsWith('Wherigo.Dialog(')) {
          _sectionMessages = true;
          _singleMessageDialog = [];
          i++;
          lines[i] = lines[i].trim();
          do {
            if (lines[i].contains('{Text = ')) {
              String line = lines[i];
              if (line.contains('Text = ')) {
                do {
                  line = line.substring(1);
                } while (!line.startsWith('Text'));
                line = line.replaceAll('Text = ', '').replaceAll('(', '').replaceAll('{', '');
                if (line.contains('"')) {
                  line = line.substring(0, line.indexOf('"')).replaceAll('"', '');
                } else if (line.contains(',')) {
                  line = line.substring(0, line.indexOf(',')).replaceAll('"', '');
                } else {
                  line = line.substring(0, line.indexOf('}')).replaceAll('"', '');
                }
                if (line.isNotEmpty) {
                  _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.TEXT, line));
                }
              }
              line = lines[i];
              if (line.contains('Media = ')) {
                do {
                  line = line.substring(1);
                } while (!line.startsWith('Media'));
                line = line
                    .replaceAll('Media = ', '')
                    .replaceAll('"', '')
                    .replaceAll(',', '')
                    .replaceAll(')', '')
                    .replaceAll('}', '');
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.IMAGE, line));
              }
            } else if (lines[i].trimLeft().startsWith('Text = ') ||
                lines[i].trimLeft().startsWith('Text = ' + _obfuscatorFunction + '(') ||
                lines[i].trimLeft().startsWith('Text = (' + _obfuscatorFunction + '(')) {
              _singleMessageDialog.add(WherigoActionMessageElementData(
                  WHERIGO_ACTIONMESSAGETYPE.TEXT, getTextData(lines[i])));
            } else if (lines[i].trimLeft().startsWith('Media')) {
              _singleMessageDialog.add(WherigoActionMessageElementData(
                  WHERIGO_ACTIONMESSAGETYPE.IMAGE, lines[i].trimLeft().replaceAll('Media = ', '')));
            } else if (lines[i].trimLeft().startsWith('Buttons')) {
              i++;
              lines[i] = lines[i].trim();
              do {
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                    getTextData('Text = ' + lines[i].trim())));
                i++;
                lines[i] = lines[i].trim();
              } while (lines[i].trimLeft() != '}');
            }

            if (lines[i].trimLeft().startsWith('}, function(action)') ||
                lines[i].trimLeft().startsWith('}, nil)') ||
                lines[i].trimLeft().startsWith('})')) {
              _sectionMessages = false;
            }
            i++;
            lines[i] = lines[i].trim();
          } while (_sectionMessages && (i < lines.length));
          _cartridgeMessages.add(_singleMessageDialog);
        } else if (lines[i].trimLeft().startsWith('_Urwigo.OldDialog(')) {
          i++;
          lines[i] = lines[i].trim();
          _sectionMessages = true;
          _singleMessageDialog = [];

          do {
            if (lines[i].contains('{Text = ')) {
              String line = lines[i];
              if (line.contains('Text = ')) {
                do {
                  line = line.substring(1);
                } while (!line.startsWith('Text'));
                line = line.replaceAll('Text = ', '').replaceAll('(', '').replaceAll('{', '');
                if (line.contains('"')) {
                  line = line.substring(0, line.indexOf('"')).replaceAll('"', '');
                } else if (line.contains(',')) {
                  line = line.substring(0, line.indexOf(',')).replaceAll('"', '');
                } else {
                  line = line.substring(0, line.indexOf('}')).replaceAll('"', '');
                }
                if (line.isNotEmpty) {
                  _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.TEXT, line));
                }
              }
              line = lines[i];
              if (line.contains('Media = ')) {
                do {
                  line = line.substring(1);
                } while (!line.startsWith('Media'));
                line = line
                    .replaceAll('Media = ', '')
                    .replaceAll('"', '')
                    .replaceAll(',', '')
                    .replaceAll(')', '')
                    .replaceAll('}', '');
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.IMAGE, line));
              }
            } else if (lines[i].trimLeft().startsWith('})')) {
              _sectionMessages = false;
            } else if (lines[i].trimLeft().startsWith('Text = ')) {
              _singleMessageDialog.add(WherigoActionMessageElementData(
                  WHERIGO_ACTIONMESSAGETYPE.TEXT, getTextData(lines[i])));
            } else if (lines[i].trimLeft().startsWith('Media')) {
              _singleMessageDialog.add(WherigoActionMessageElementData(
                  WHERIGO_ACTIONMESSAGETYPE.IMAGE, lines[i].trimLeft().replaceAll('Media = ', '')));
            } else if (lines[i].trimLeft().startsWith('Buttons')) {
              i++;
              lines[i] = lines[i].trim();
              do {
                _singleMessageDialog.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                    getTextData('Text = ' + lines[i].trim())));
                i++;
                lines[i] = lines[i].trim();
              } while (lines[i].trimLeft() != '}');
            } else {
              _singleMessageDialog.add(WherigoActionMessageElementData(
                  WHERIGO_ACTIONMESSAGETYPE.TEXT, lines[i].replaceAll('{', '').replaceAll('}', '')));
            }

            i++;
            lines[i] = lines[i].trim();
          } while (_sectionMessages);
          _cartridgeMessages.add(_singleMessageDialog);
        }
      }
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_messages', exception));
    }
  } // end of second parse for i = 0 to lines.length - getting Messages/Dialogs
}
