part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

String _answerIsVariable(String answer) {
  for (var element in WherigoCartridgeLUAData.Variables) {
    if (element.VariableLUAName == answer) {
      return element.VariableName;
    } else if (element.VariableName == answer) {
      return element.VariableName;
    }
  }
  return '';
}

List<List<String>> _buildOutputListAnswers(
    BuildContext context, WherigoInputData input, WherigoAnswerData data, String LUASourceCode) {
  List<List<String>> result = [];
  List<String> answers = data.AnswerAnswer.split('\x01');
  var hash = answers[0].trim();
  var answerAlphabetical = answers.length >= 2 ? answers[1].trim() : null;
  var answerNumeric = answers.length == 3 ? answers[2].trim() : null;
  if (input.InputType == 'MultipleChoice') {
    if (answers.length > 1) {
      result.add(
          [i18n(context, 'wherigo_output_hash'), hash == '-<ELSE>-' ? i18n(context, 'wherigo_answer_else') : hash, '']);
    } else {
      result.add([
        i18n(context, 'wherigo_output_answer'),
        hash == '-<ELSE>-' ? i18n(context, 'wherigo_answer_else') : hash,
        ''
      ]);
    }
    if (hash != '0') {
      for (int i = 0; i < input.InputChoices.length; i++) {
        if (RSHash(input.InputChoices[i].toLowerCase()).toString() == hash) {
          result.add([i18n(context, 'wherigo_output_answerdecrypted'), input.InputChoices[i], '']);
        }
      }
    }
  } else {
     String _variable = answers.length > 1 ? _answerIsVariable(answers[1]) : '';

    if (_variable.isNotEmpty) {
      result.add([i18n(context, 'wherigo_output_answer'), _variable, '']);
    }
    //else {
    if (answers.length > 1) {
      result.add(
          [i18n(context, 'wherigo_output_hash'), hash == '-<ELSE>-' ? i18n(context, 'wherigo_answer_else') : hash, '']);
    } else {
      if (hash == '-<ELSE>-') {
        result.add([
          i18n(context, 'wherigo_output_answer'), i18n(context, 'wherigo_answer_else'), '']);
      } else {
        result.add([
          i18n(context, 'wherigo_output_answervariable'), hash, '']);

        RegExp(r'' + hash + ' = .*').allMatches(LUASourceCode).forEach((variableWithValue) {
          var group = variableWithValue.group(0);
          if (group != null) {
            result.add([i18n(context, 'wherigo_data_answer'), group, '']);
          }
        });
      }
    }
    if (answerAlphabetical != null) {
      result
          .add([i18n(context, 'wherigo_output_answerdecrypted'), i18n(context, 'common_letters'), answerAlphabetical]);
    }
    if (answerNumeric != null) {
      result.add([i18n(context, 'wherigo_output_answerdecrypted'), i18n(context, 'common_numbers'), answerNumeric]);
    }
    //}
  }

  return result;
}

List<Widget> _outputAnswerActionsWidgets(BuildContext context, WherigoAnswerData data) {
  List<Widget> resultWidget = [];

  if (data.AnswerActions.isNotEmpty) {
    for (var element in data.AnswerActions) {
      switch (element.ActionMessageType) {
        case WHERIGO_ACTIONMESSAGETYPE.TEXT:
          resultWidget.add(Container(
            padding: const EdgeInsets.only(top: DOUBLE_DEFAULT_MARGIN, bottom: DOUBLE_DEFAULT_MARGIN),
            child: GCWOutput(
              child: element.ActionMessageContent,
              suppressCopyButton: true,
            ),
          ));
          break;

        case WHERIGO_ACTIONMESSAGETYPE.IMAGE:
          var file = _getFileFrom(context, element.ActionMessageContent);
          if (file == null) break;

          resultWidget.add(GCWFilesOutput(
            suppressHiddenDataMessage: true,
            files: [
              GCWFile(bytes: file.bytes, name: file.name),
            ],
          ));

          break;

        case WHERIGO_ACTIONMESSAGETYPE.BUTTON:
          resultWidget.add(Text('\n' '« ' + element.ActionMessageContent + ' »' + '\n',
              textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)));
          break;

        case WHERIGO_ACTIONMESSAGETYPE.CASE:
          WHERIGOExpertMode
              ? resultWidget.add(Text(
                  '\n' + (element.ActionMessageContent.toUpperCase()) + '\n',
                  textAlign: TextAlign.center,
                ))
              : null;
          break;

        case WHERIGO_ACTIONMESSAGETYPE.COMMAND:
          resultWidget.add(GCWText(
            text: element.ActionMessageContent,
          ));
          if (element.ActionMessageContent.startsWith('Wherigo.PlayAudio')) {
            String LUAName = element.ActionMessageContent.replaceAll('Wherigo.PlayAudio(', '').replaceAll(')', '');
            if (WHERIGONameToObject[LUAName] == null ||
                WHERIGONameToObject[LUAName]!.ObjectIndex >= WherigoCartridgeGWCData.MediaFilesContents.length) {
              break;
            }

            if (WherigoCartridgeGWCData.MediaFilesContents.isNotEmpty) {
              resultWidget.add(GCWFilesOutput(
                suppressHiddenDataMessage: true,
                files: [
                  GCWFile(
                      //bytes: _WherigoCartridge.MediaFilesContents[_mediaFileIndex].MediaFileBytes,
                      bytes: WherigoCartridgeGWCData
                          .MediaFilesContents[WHERIGONameToObject[LUAName]!.ObjectIndex].MediaFileBytes,
                      name: WHERIGONameToObject[LUAName]!.ObjectMedia),
                ],
              ));
            }
          } else {
            WHERIGOExpertMode
                ? resultWidget.add(GCWOutput(
                    child: '\n' + _resolveLUAName(element.ActionMessageContent) + '\n',
                    suppressCopyButton: true,
                  ))
                : null;
          }
          break;
        default:
          {}
      }
    }
  }
  return resultWidget;
}
