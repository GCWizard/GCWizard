part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

// TODO Thomas: Does not return anything in some cases. For example if filedata == null but Contents.length > 1 (else case of "if" in line 17)
// Although media objects are defined for both devices - garmin and pc - the content of a GWC Cartridge is defined at download time.
// Hence the GWC contains either sound files for Garmin or pc.
// Hence there could be a conflict in number of media files and media objects
GCWFile? _getFileFrom(BuildContext context, String resourceName) {
  Uint8List? filedata;
  String? filename;
  int fileindex = 0;
  GCWFile? result;

  try {
    if (WherigoCartridgeGWCData.MediaFilesContents.length > 1) {
      for (var element in WherigoCartridgeLUAData.Media) {
        if (element.MediaLUAName == resourceName) {
          filename = element.MediaFilename;
          filedata = WherigoCartridgeGWCData.MediaFilesContents[fileindex + 1].MediaFileBytes;
        }
        fileindex++;
      }
      if (filedata != null) {
        result = GCWFile(bytes: filedata, name: filename);
      }
    } else {
      result = null;
    }
  } catch (exception) {
    WHERIGOerrorMsg_MediaFiles = [];
    WHERIGOerrorMsg_MediaFiles.add('');
    WHERIGOerrorMsg_MediaFiles.add(i18n(context, 'wherigo_error_runtime_widget'));
    WHERIGOerrorMsg_MediaFiles.add(i18n(context, 'wherigo_error_runtime'));
    WHERIGOerrorMsg_MediaFiles.add(i18n(context, 'wherigo_error_runtime_exception'));
    WHERIGOerrorMsg_MediaFiles.add(exception.toString());
    WHERIGOerrorMsg_MediaFiles.add(i18n(context, 'wherigo_error_gwc_mediafiles'));
    WHERIGOerrorMsg_MediaFiles.add(i18n(context, 'wherigo_error_hint_2'));
    showSnackBar(
        i18n(context, 'wherigo_error_runtime') +
            '\n' +
            i18n(context, 'wherigo_error_runtime_exception') +
            '\n' +
            i18n(context, 'wherigo_error_gwc_mediafiles') +
            '\n' +
            exception.toString() +
            '\n\n' +
            i18n(context, 'wherigo_error_hint_2'),
        context,
        duration: 10);
  }
  return result;
}

String _resolveLUAName(String chiffre) {
  String resolve(List<String> chiffreList, String joinPattern) {
    if (WHERIGONameToObject[chiffreList[0]] == null) {
      return '';
    }

    List<String> result = [];
    result.add(WHERIGONameToObject[chiffreList[0]]!.ObjectType.toString().split('.')[1] +
        ' ' +
        WHERIGONameToObject[chiffreList[0]]!.ObjectName);
    for (int i = 1; i < chiffreList.length; i++) {
      result.add(chiffreList[i]);
    }
    return result.join(joinPattern);
  }

  if (chiffre.split('.').length > 1) {
    List<String> listChiffre = chiffre.split('.');
    if (WHERIGONameToObject[listChiffre[0]] != null) {
      return resolve(listChiffre, '.');
    } else {
      return chiffre;
    }
  } else if (chiffre.split(':').length > 1) {
    List<String> listChiffre = chiffre.split(':');
    if (WHERIGONameToObject[listChiffre[0]] != null) {
      return resolve(listChiffre, ':');
    } else {
      return chiffre;
    }
  } else {
    return chiffre;
  }
}

Widget _buildImageView(BuildContext context, bool condition, String fileSource) {
  if (!condition) return Container();

  var file = _getFileFrom(context, fileSource);

  if (file == null) return Container();

  return GCWImageView(
    imageData: GCWImageViewData(file),
    suppressedButtons: const {GCWImageViewButtons.ALL},
  );
}

void _getErrorMessagesFromLUAAnalyzation(List<String> _errorMsg, BuildContext context) {
  if (WherigoCartridgeLUAData.ResultStatus == WHERIGO_ANALYSE_RESULT_STATUS.OK) {
    _errorMsg.add(i18n(context, 'wherigo_error_runtime_lua'));
    _errorMsg.add(i18n(context, 'wherigo_error_no_error'));
  } else {
    _errorMsg.add(i18n(context, 'wherigo_error_runtime_lua'));
    for (int i = 0; i < WherigoCartridgeLUAData.ResultsLUA.length; i++) {
      if (WherigoCartridgeLUAData.ResultsLUA[i].startsWith('wherigo')) {
        _errorMsg.add(i18n(context, WherigoCartridgeLUAData.ResultsLUA[i]));
      } else {
        _errorMsg.add(WherigoCartridgeLUAData.ResultsLUA[i]);
      }
    }
  }
}

void _getErrorMessagesFromGWCAnalyzation(List<dynamic> _errorMsg, BuildContext context) {
  if (WherigoCartridgeGWCData.ResultStatus == WHERIGO_ANALYSE_RESULT_STATUS.OK) {
    _errorMsg.add(i18n(context, 'wherigo_error_runtime_gwc'));
    _errorMsg.add(i18n(context, 'wherigo_error_no_error'));
    _errorMsg.add('');
  } else {
    _errorMsg.add(i18n(context, 'wherigo_error_runtime_gwc'));
    for (int i = 0; i < WherigoCartridgeGWCData.ResultsGWC.length; i++) {
      if (WherigoCartridgeGWCData.ResultsGWC[i].startsWith('wherigo')) {
        _errorMsg.add(i18n(context, WherigoCartridgeGWCData.ResultsGWC[i]));
      } else {
        _errorMsg.add(WherigoCartridgeGWCData.ResultsGWC[i]);
      }
    }
  }
}

String _getCreationDate(BuildContext context, int duration) {
  // Date of creation   ; Seconds since 2004-02-10 01:00:00
  return _formatDate(context, DateTime(2004, 2, 1, 1, 0, 0, 0).add(Duration(seconds: duration)).toString());
}

String _formatDate(BuildContext context, String datetime) {
  String loc = Localizations.localeOf(context).toString();
  String result = '';
  try {
    result = DateFormat.yMd(loc).add_jms().format(DateTime.parse(datetime)).toString();
  } catch (exception) {
    result = WHERIGO_NULLDATE;
  }
  return result;
}
