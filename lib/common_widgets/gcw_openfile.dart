import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart' as filePicker;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:http/http.dart' as http;

// Not supported by file picker plugin
const _UNSUPPORTED_FILEPICKERPLUGIN_TYPES = [FileType.GPX, FileType.GCW];
final SUPPORTED_IMAGE_TYPES = fileTypesByFileClass(FileClass.IMAGE);

class GCWOpenFile extends StatefulWidget {
  final Function onLoaded;
  final List<FileType> supportedFileTypes;
  final bool isDialog;
  final String title;
  final GCWFile file;
  final suppressHeader;

  const GCWOpenFile(
      {Key key,
      this.onLoaded,
      this.supportedFileTypes,
      this.title,
      this.isDialog: false,
      this.file,
      this.suppressHeader: false})
      : super(key: key);

  @override
  _GCWOpenFileState createState() => _GCWOpenFileState();
}

class _GCWOpenFileState extends State<GCWOpenFile> {
  var _urlController;
  String _currentUrl;
  Uri _currentUri;

  var _currentMode = GCWSwitchPosition.left;
  var _currentExpanded = true;

  GCWFile _loadedFile;

  @override
  void initState() {
    super.initState();

    _urlController = TextEditingController(text: _currentUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();

    super.dispose();
  }

  _buildOpenFromDevice() {
    return GCWButton(
      text: i18n(context, 'common_loadfile_open'),
      onPressed: () {
        _currentExpanded = true;
        _openFileExplorer(allowedFileTypes: widget.supportedFileTypes).then((GCWFile file) {
          if (file != null && file.bytes != null) {
            setState(() {
              _loadedFile = file;
              _currentExpanded = false;
            });
            widget.onLoaded(file);
          } else {
            showToast(i18n(context, 'common_loadfile_exception_nofile'));
          }
        });
      },
    );
  }

  Widget _buildDownloadButton() {
    return GCWButton(
        text: i18n(context, 'common_loadfile_open'),
        onPressed: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: Container(
                  child: GCWAsyncExecuter(
                    isolatedFunction: _downloadFileAsync,
                    parameter: _buildJobDataDownload(),
                    onReady: (data) => _saveDownload(data),
                    isOverlay: true,
                  ),
                  height: 220,
                  width: 150,
                ),
              );
            },
          );
        });
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataDownload() async {
    _currentExpanded = true;
    _currentUri = null;

    if (_currentUrl == null) {
      showToast(i18n(context, 'common_loadfile_exception_url'));
      return null;
    }

    await _getAndValidateUri(_currentUrl.trim()).then((uri) {
      if (uri == null) {
        showToast(i18n(context, 'common_loadfile_exception_url'));
        return null;
      }
      _currentUri = uri;
    });
    if (_currentUri == null) return null;

    return GCWAsyncExecuterParameters(_currentUri);
  }

  _buildOpenFromURL() {
    var urlTextField = GCWTextField(
        controller: _urlController,
        filled: widget.isDialog,
        hintText: i18n(context, 'common_loadfile_openfrom_url_address'),
        hintColor: widget.isDialog ? Color.fromRGBO(150, 150, 150, 1.0) : themeColors().textFieldHintText(),
        onChanged: (String value) {
          if (value == null || value.trim().isEmpty) {
            _currentUrl = null;
            return;
          }
          _currentUrl = value;
        });

    if (widget.isDialog) {
      return Column(
        children: [
          Container(
            child: urlTextField,
            width: 220,
            height: 50,
          ),
          _buildDownloadButton()
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: urlTextField),
          Container(
            padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
            child: _buildDownloadButton(),
          )
        ],
      );
    }
  }

  _saveDownload(dynamic data) {
    _loadedFile = null;
    if (data is Uint8List) {
      _loadedFile =
          GCWFile(name: Uri.decodeFull(_currentUrl).split('/').last.split('?').first, path: _currentUrl, bytes: data);
    } else if (data is String) showToast(i18n(context, data));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLoaded(_loadedFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedFile == null && widget.file != null) _loadedFile = widget.file;

    var content = Column(
      children: [
        GCWTwoOptionsSwitch(
          value: _currentMode,
          alternativeColor: widget.isDialog,
          title: i18n(context, 'common_loadfile_openfrom'),
          leftValue: i18n(context, 'common_loadfile_openfrom_file'),
          rightValue: i18n(context, 'common_loadfile_openfrom_url'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        if (_currentMode == GCWSwitchPosition.left) _buildOpenFromDevice(),
        if (_currentMode == GCWSwitchPosition.right) _buildOpenFromURL(),
      ],
    );

    return Column(
      children: [
        widget.isDialog || widget.suppressHeader
            ? content
            : GCWExpandableTextDivider(
                text:
                    i18n(context, 'common_loadfile_showopen') + (widget.title != null ? ' (' + widget.title + ')' : ''),
                expanded: _currentExpanded,
                onChanged: (value) {
                  setState(() {
                    _currentExpanded = value;
                  });
                },
                child: content),
        if (_currentExpanded && _loadedFile != null)
          GCWText(
            text: i18n(context, 'common_loadfile_currentlyloaded') + ': ' + (_loadedFile.name ?? ''),
            style: gcwTextStyle().copyWith(fontSize: fontSizeSmall()),
          ),
        if (!_currentExpanded && _loadedFile != null)
          GCWText(
            text: i18n(context, 'common_loadfile_loaded') + ': ' + (_loadedFile.name ?? ''),
          )
      ],
    );
  }

  bool _validateContentType(String contentType) {
    if (widget.supportedFileTypes == null) return true;

    for (FileType fileType in widget.supportedFileTypes) {
      if (mimeTypes(fileType).contains(contentType)) return true;
    }

    var _urlFileType = fileTypeByFilename(_currentUrl.split('?').first);

    if (_urlFileType != null && widget.supportedFileTypes.contains(_urlFileType)) {
      return true;
    }

    return false;
  }

  Future<Uri> _getAndValidateUri(String url) async {
    const _HTTP = 'http://';
    const _HTTPS = 'https://';

    var prefixes = [_HTTP, _HTTPS];
    if (url.startsWith(_HTTP)) {
      url = url.replaceAll(_HTTP, '');
    } else if (url.startsWith(_HTTPS)) {
      prefixes = [''];
    }

    for (var prefix in prefixes) {
      try {
        Uri uri = Uri.parse(prefix + url);
        var response = await http.head(uri);

        if (response.statusCode ~/ 100 == 2) {
          if (_validateContentType(response.headers[HttpHeaders.contentTypeHeader])) {
            return uri;
          } else {
            showToast(i18n(context, 'common_loadfile_exception_supportedfiletype'));
          }
        }
      } catch (e) {}
    }

    return null;
  }
}

showOpenFileDialog(BuildContext context, List<FileType> supportedFileTypes, Function onLoaded) {
  showGCWDialog(
      context,
      i18n(context, 'common_loadfile_showopen'),
      Column(
        children: [
          GCWOpenFile(
            supportedFileTypes: supportedFileTypes,
            isDialog: true,
            onLoaded: (_file) {
              if (onLoaded != null) onLoaded(_file);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      []);
}

Future<dynamic> _downloadFileAsync(dynamic jobData) async {
  int _total = 0;
  int _received = 0;
  List<int> _bytes = [];
  Future<Uint8List> result;
  SendPort sendAsyncPort = jobData?.sendAsyncPort;
  Uri uri = jobData?.parameters;

  var request = http.Request("GET", uri);
  var client = http.Client();
  await client.send(request).timeout(Duration(seconds: 10), onTimeout: () {
    if (sendAsyncPort != null) sendAsyncPort.send(null);
    return null; //http.Response('Error', 500);
  }).then((http.StreamedResponse response) async {
    if (response.statusCode != 200) {
      if (sendAsyncPort != null) sendAsyncPort.send('common_loadfile_exception_responsestatus');
      return 'common_loadfile_exception_responsestatus';
    }
    _total = response.contentLength ?? 0;
    int progressStep = max(_total ~/ 100, 1);

    await response.stream.listen((value) {
      _bytes.addAll(value);

      if (_total != 0 &&
          sendAsyncPort != null &&
          (_received % progressStep > (_received + value.length) % progressStep)) {
        sendAsyncPort.send({'progress': (_received + value.length) / _total});
      }
      _received += value.length;
    }).onDone(() {
      if (_bytes == null || _bytes.isEmpty) return 'common_loadfile_exception_nofile';

      var uint8List = Uint8List.fromList(_bytes);
      if (sendAsyncPort != null) sendAsyncPort.send(uint8List);
      result = Future.value(uint8List);
    });
  });

  await result;
  return result;
}

/// Open File Picker dialog
///
/// Returns null if nothing was selected.
///
/// * [allowedFileTypes] specifies a list of file extensions that will be displayed for selection, if empty - files with any extension are displayed. Example: `['jpg', 'jpeg']`
Future<GCWFile> _openFileExplorer({List<FileType> allowedFileTypes}) async {
  try {
    if (_hasUnsupportedTypes(allowedFileTypes)) allowedFileTypes = null;

    var files = (await filePicker.FilePicker.platform.pickFiles(
        type: allowedFileTypes == null ? filePicker.FileType.any : filePicker.FileType.custom,
        allowMultiple: false,
        allowedExtensions:
        allowedFileTypes == null ? null : allowedFileTypes.map((type) => fileExtension(type)).toList()))
        ?.files;

    if (allowedFileTypes == null) files = _filterFiles(files, allowedFileTypes);

    if (files == null || files.length == 0) return null;

    var bytes = await _getFileData(files.first);
    var path = kIsWeb ? null : files.first.path;

    return GCWFile(path: path, name: files.first.name, bytes: bytes);
  } on PlatformException catch (e) {
    print("Unsupported operation " + e.toString());
  }
  return null;
}

Future<Uint8List> _getFileData(filePicker.PlatformFile file) async {
  return kIsWeb ? Future.value(file.bytes) : readByteDataFromFile(file.path);
}

List<filePicker.PlatformFile> _filterFiles(List<filePicker.PlatformFile> files, List<FileType> allowedFileTypes) {
  if (files == null || allowedFileTypes == null) return files;

  var allowedExtensions = fileExtensions(allowedFileTypes);

  return files.where((element) => allowedExtensions.contains(element.extension)).toList();
}

bool _hasUnsupportedTypes(List<FileType> allowedExtensions) {
  if (allowedExtensions == null) return false;
  if (kIsWeb) return false;

  for (int i = 0; i < allowedExtensions.length; i++) {
    if (_UNSUPPORTED_FILEPICKERPLUGIN_TYPES.contains(allowedExtensions[i])) return true;
  }
  return false;
}

