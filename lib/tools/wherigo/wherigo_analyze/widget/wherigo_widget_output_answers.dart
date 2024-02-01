part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListAnswers(BuildContext context, WherigoInputData input, WherigoAnswerData data) {
  List<List<String>> result;
  List<String> answers = data.AnswerAnswer.split('\x01');
  var hash = answers[0].trim();
  var answerAlphabetical = answers.length >= 2 ? answers[1].trim() : null;
  var answerNumeric = answers.length == 3 ? answers[2].trim() : null;

  if (input.InputType == 'MultipleChoice') {
    result = [
      answers.length > 1
          ? [i18n(context, 'wherigo_output_hash'), hash, '']
          : [i18n(context, 'wherigo_output_answer'), hash],
    ];
    if (hash != '0') {
      for (int i = 0; i < input.InputChoices.length; i++) {
        if (RSHash(input.InputChoices[i].toLowerCase()).toString() == hash) {
          result.add([i18n(context, 'wherigo_output_answerdecrypted'), input.InputChoices[i], '']);
        }
      }
    }
  } else {
    result = [
      answers.length > 1
          ? [i18n(context, 'wherigo_output_hash'), hash, '']
          : [i18n(context, 'wherigo_output_answer'), hash],
      if (answerAlphabetical != null)
        [i18n(context, 'wherigo_output_answerdecrypted'), answerAlphabetical, i18n(context, 'common_letters')],
      if (answerNumeric != null)
        [i18n(context, 'wherigo_output_answerdecrypted'), answerNumeric, i18n(context, 'common_numbers')],
    ];

    result = [
      answers.length > 1
          ? [i18n(context, 'wherigo_output_hash'), hash, '']
          : [i18n(context, 'wherigo_output_answer'), hash],
      if (answerAlphabetical != null)
        [i18n(context, 'wherigo_output_answerdecrypted'), i18n(context, 'common_letters'), answerAlphabetical],
      if (answerNumeric != null)
        [i18n(context, 'wherigo_output_answerdecrypted'), i18n(context, 'common_numbers'), answerNumeric],
    ];
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

          resultWidget.add(GCWImageView(
            imageData: GCWImageViewData(file),
            suppressedButtons: const {GCWImageViewButtons.ALL},
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
          if (element.ActionMessageContent.startsWith('Wherigo.PlayAudio')) {
            String LUAName = element.ActionMessageContent.replaceAll('Wherigo.PlayAudio(', '').replaceAll(')', '');
            if (WHERIGONameToObject[LUAName] == null ||
                WHERIGONameToObject[LUAName]!.ObjectIndex >= WherigoCartridgeGWCData.MediaFilesContents.length) {
              break;
            }

            if (WherigoCartridgeGWCData.MediaFilesContents.isNotEmpty) {
              resultWidget.add(GCWFilesOutput(
                suppressHiddenDataMessage: true,
                suppressedButtons: const {GCWImageViewButtons.SAVE},
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
