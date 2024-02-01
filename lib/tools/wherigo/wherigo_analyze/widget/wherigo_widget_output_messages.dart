part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<Widget> _buildOutputListOfMessageData(BuildContext context, List<WherigoActionMessageElementData> data) {
  List<Widget> resultWidget = [];
  for (var element in data) {
    switch (element.ActionMessageType) {
      case WHERIGO_ACTIONMESSAGETYPE.TEXT:
        resultWidget.add(Container(
          padding: const EdgeInsets.only(top: DOUBLE_DEFAULT_MARGIN, bottom: DOUBLE_DEFAULT_MARGIN),
          child: GCWOutput(
            child: element.ActionMessageContent,
            suppressCopyButton: false,
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
        resultWidget.add(Text(
            '\n' + i18n(context, 'wherigo_output_action_btn') + ' « ' + element.ActionMessageContent + ' »' + '\n',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)));
        break;
      case WHERIGO_ACTIONMESSAGETYPE.COMMAND:
        if (element.ActionMessageContent.startsWith('Wherigo.PlayAudio')) {
          String LUAName = element.ActionMessageContent.replaceAll('Wherigo.PlayAudio(', '').replaceAll(')', '');
          if (WHERIGONameToObject[LUAName] == null ||
              WHERIGONameToObject[LUAName]!.ObjectIndex >= WherigoCartridgeGWCData.MediaFilesContents.length) {
            break;
          }
          resultWidget.add(GCWSoundPlayer(
            file: GCWFile(
                bytes: WherigoCartridgeGWCData
                    .MediaFilesContents[WHERIGONameToObject[LUAName]!.ObjectIndex].MediaFileBytes,
                name: WHERIGONameToObject[LUAName]!.ObjectMedia),
          ));
        } else {
          resultWidget.add(GCWOutput(
            child: '\n' + _resolveLUAName(element.ActionMessageContent) + '\n',
            suppressCopyButton: true,
          ));
        }
        break;
      default:
        {}
    }
  }
  return resultWidget;
}
