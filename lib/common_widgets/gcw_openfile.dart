import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:file_picker/file_picker.dart' as filePicker;
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:http/http.dart' as http;

final SUPPORTED_IMAGE_TYPES = fileTypesByFileClass(FileClass.IMAGE);

enum OpenFileType {FILE, URL, GALLERY, CAMERA}

class GCWOpenFile extends StatefulWidget {
  final void Function(GCWFile?) onLoaded;
  final List<FileType>? supportedFileTypes;
  final bool isDialog;
  final String? title;
  final GCWFile? file;
  final bool suppressHeader;
  final bool suppressGallery;

  const GCWOpenFile(
      {Key? key,
      required this.onLoaded,
      this.supportedFileTypes,
      this.title,
      this.isDialog = false,
      this.file,
      this.suppressHeader = false,
      this.suppressGallery = true}
      )
      : super(key: key);

  @override
  _GCWOpenFileState createState() => _GCWOpenFileState();
}

class _GCWOpenFileState extends State<GCWOpenFile> {
  late TextEditingController _urlController;
  OpenFileType _currentMode = OpenFileType.FILE;
  String? _currentUrl;
  Uri? _currentUri;

  var _currentExpanded = true;

  GCWFile? _loadedFile;

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

  void _buildOpenFromDevice() {
    // todo: open only the filebrowser in android
    openFileExplorer(allowedFileTypes: widget.supportedFileTypes)
        .then((GCWFile? file) {
      if (file != null) {
        setState(() {
          _loadedFile = file;
          _currentExpanded = false;
        });
        widget.onLoaded(file);
      } else {
        showSnackBar(
            i18n(context, 'common_loadfile_exception_nofile'), context);
      }
    });
  }

  void _buildOpenFromGallery() {
    final imagePicker.ImagePicker picker = imagePicker.ImagePicker();
    picker
        .pickImage(source: imagePicker.ImageSource.gallery)
        .then((imagePicker.XFile? pickedFile) {
      if (pickedFile != null) {
        pickedFile.readAsBytes().then((Uint8List bytes) {
          setState(() {
            _loadedFile = GCWFile(
              name: pickedFile.name,
              path: pickedFile.path,
              bytes: bytes,
            );
          });
          widget.onLoaded(_loadedFile);
        });
      } else {
        showSnackBar(
            i18n(context, 'common_loadfile_exception_nofile'), context);
      }
    });
  }

  Widget _buildDownloadButton() {
    return GCWButton(
        text: i18n(context, 'common_loadfile_open'),
        onPressed: () async {
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: SizedBox(
                  height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
                  width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
                  child: GCWAsyncExecuter<Uint8ListText?>(
                    isolatedFunction: _downloadFileAsync,
                    parameter: _buildJobDataDownload,
                    onReady: (data) => _saveDownload(data),
                    isOverlay: true,
                  ),
                ),
              );
            },
          );
        });
  }

  Future<GCWAsyncExecuterParameters?> _buildJobDataDownload() async {
    _currentExpanded = true;
    _currentUri = null;

    if (_currentUrl == null) {
      showSnackBar(i18n(context, 'common_loadfile_exception_url'), context);
      return null;
    }

    await _getAndValidateUri(_currentUrl!.trim()).then((uri) {
      if (uri == null) {
        showSnackBar(i18n(context, 'common_loadfile_exception_url'), context);
        return null;
      }
      _currentUri = uri;
    });
    if (_currentUri == null) return null;

    return GCWAsyncExecuterParameters(_currentUri);
  }

  Widget _buildOpenFromURL() {
    var urlTextField = GCWTextField(
        controller: _urlController,
        filled: widget.isDialog,
        hintText: i18n(context, 'common_loadfile_openfrom_url_address'),
        hintColor: widget.isDialog
            ? const Color.fromRGBO(150, 150, 150, 1.0)
            : themeColors().textFieldHintText(),
        onChanged: (String value) {
          if (value.trim().isEmpty) {
            _currentUrl = null;
            return;
          }
          _currentUrl = value;
        });

    if (widget.isDialog) {
      return Column(
        children: [
          SizedBox(
            width: 220,
            height: 50,
            child: urlTextField,
          ),
          _buildDownloadButton()
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: urlTextField),
          Container(
            padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
            child: _buildDownloadButton(),
          )
        ],
      );
    }
  }

  void _saveDownload(Uint8ListText? data) {
    _loadedFile = null;
    if (data != null && data.value.isNotEmpty && _currentUrl != null) {
      _loadedFile = GCWFile(
          name: Uri.decodeFull(_currentUrl!).split('/').last.split('?').first, path: _currentUrl, bytes: data.value);
    } else if (data != null && data.text.isNotEmpty) {
      showSnackBar(i18n(context, data.text), context);
    }

    if (_loadedFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoaded(_loadedFile!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadedFile == null && widget.file != null) _loadedFile = widget.file;

    var content = Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        (widget.suppressGallery || kIsWeb)
            ? const SizedBox()
            : GCWIconButton(
                icon: Icons.photo_library,
                iconColor: widget.isDialog ? themeColors().dialogText() : themeColors().mainFont(),
                size: IconButtonSize.LARGE,
                onPressed: () {
                  setState(() {
                    _currentMode = OpenFileType.GALLERY;
                  });
                  _buildOpenFromGallery();
                }),
        Container(width: widget.suppressGallery ? null : DOUBLE_DEFAULT_MARGIN),
        GCWIconButton(
            icon: Icons.folder,
            iconColor: widget.isDialog ? themeColors().dialogText() : themeColors().mainFont(),
            size: IconButtonSize.LARGE,
            onPressed: () {
              setState(() {
                _currentMode = OpenFileType.FILE;
              });
              _buildOpenFromDevice();
            }),
        Container(width: DOUBLE_DEFAULT_MARGIN),
        kIsWeb ? Container() : GCWIconButton(
          icon: Icons.public,
          iconColor: widget.isDialog ? themeColors().dialogText() : themeColors().mainFont(),
          size: IconButtonSize.LARGE,
          onPressed: () {
            setState(() {
              _currentMode = OpenFileType.URL;
            });
          },
        ),
      ]),
      if (_currentMode == OpenFileType.URL) _buildOpenFromURL(),
    ]);

    return Column(
      children: [
        widget.isDialog || widget.suppressHeader
            ? content
            : GCWExpandableTextDivider(
                text: i18n(context, 'common_loadfile_showopen') +
                    (widget.title != null ? ' (' + widget.title! + ')' : ''),
                expanded: _currentExpanded,
                onChanged: (value) {
                  setState(() {
                    _currentExpanded = value;
                  });
                },
                child: content),
        if (_currentExpanded && _loadedFile != null)
          GCWText(
            text: i18n(context, 'common_loadfile_currentlyloaded') +
                ': ' +
                (_loadedFile?.name ?? ''),
            style: gcwTextStyle().copyWith(fontSize: fontSizeSmall()),
          ),
        if (!_currentExpanded && _loadedFile != null)
          GCWText(
            text: i18n(context, 'common_loadfile_loaded') +
                ': ' +
                (_loadedFile?.name ?? ''),
          )
      ],
    );
  }

  bool _validateContentType(String contentType) {
    if (widget.supportedFileTypes == null || widget.supportedFileTypes!.isEmpty) return true;
    for (FileType fileType in widget.supportedFileTypes ?? []) {
      var mimeTypeList = mimeTypes(fileType);
      if (mimeTypeList != null && mimeTypeList.contains(contentType)) return true;
    }

    var _fileName = _currentUrl?.split('?').first;
    var _urlFileType = _fileName == null ? null : fileTypeByFilename(_fileName);

    if (_urlFileType != null && (widget.supportedFileTypes ?? []).contains(_urlFileType)) {
      return true;
    }

    return false;
  }

  Future<Uri?> _getAndValidateUri(String url) async {
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
          var contentType = response.headers[HttpHeaders.contentTypeHeader];
          if ((contentType != null) && _validateContentType(contentType)) {
            return uri;
          } else {
            showSnackBar(i18n(context, 'common_loadfile_exception_supportedfiletype'), context);
          }
        }
      } catch (e) {}
    }

    return null;
  }
}

void showOpenFileDialog(BuildContext context, List<FileType> supportedFileTypes, void Function(GCWFile?) onLoaded) {
  showGCWDialog(
      context,
      i18n(context, 'common_loadfile_showopen'),
      Column(
        children: [
          GCWOpenFile(
            supportedFileTypes: supportedFileTypes,
            isDialog: true,
            onLoaded: (GCWFile? _file) {
              onLoaded(_file);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      []);
}

Future<Uint8ListText?> _downloadFileAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! Uri) return null;
  int _total = 0;
  int _received = 0;
  List<int> _bytes = [];
  SendPort? sendAsyncPort = jobData?.sendAsyncPort;
  Uri? uri = jobData!.parameters as Uri;
  var result = Uint8ListText('', Uint8List.fromList(_bytes));

  var request = http.Request("GET", uri);
  var client = http.Client();

  try {
    await client
        .send(request)
        .timeout(const Duration(seconds: 10))
        .then<http.StreamedResponse?>((http.StreamedResponse response) async {
      if (response.statusCode != 200) {
        result = Uint8ListText('common_loadfile_exception_responsestatus', Uint8List(0));
      } else {
        _total = response.contentLength ?? 0;
        int progressStep = max(_total ~/ 100, 1);

        response.stream.listen(
          (value) async {
            _bytes.addAll(value);

            if (_total != 0 &&
                sendAsyncPort != null &&
                (_received % progressStep > (_received + value.length) % progressStep)) {
              sendAsyncPort.send(DoubleText(PROGRESS, (_received + value.length) / _total));
            }
            _received += value.length;
          },
          onDone: () {
            if (_bytes.isEmpty) {
              result = Uint8ListText('common_loadfile_exception_nofile', Uint8List(0));
            } else {
              sendAsyncPort?.send(Uint8ListText('', Uint8List.fromList(_bytes)));
              result = Uint8ListText('', Uint8List.fromList(_bytes));
            }
          },
        );
      }
      return response;
    });
  } on TimeoutException catch (_) {
    result = Uint8ListText('common_loadfile_exception_responsestatus', Uint8List(0));
  } on SocketException catch (_) {
    result = Uint8ListText('common_loadfile_exception_nofile', Uint8List(0));
  }

// ToDo only working with AsyncPort (await not working)
  if (result.text.isNotEmpty) {
    sendAsyncPort?.send(result);
  }
  return Future.value(result);
}

/// Open File Picker dialog
///
/// Returns null if nothing was selected.
///
Future<GCWFile?> openFileExplorer({List<FileType>? allowedFileTypes}) async {
  try {
     var files = (await filePicker.FilePicker.platform.pickFiles(
            type: filePicker.FileType.any,
            allowMultiple: false
         ))?.files;

    if (allowedFileTypes != null && allowedFileTypes.isNotEmpty && files != null) files = _filterFiles(files, allowedFileTypes);

    if (files == null || files.isEmpty) return null;

    var bytes = await _getFileData(files.first);
    var path = kIsWeb ? null : files.first.path;
    if (bytes == null) return null;

    return GCWFile(path: path, name: files.first.name, bytes: bytes);
  } catch (e) {}
  return null;
}

Future<Uint8List?> _getFileData(filePicker.PlatformFile file) async {
  return kIsWeb
      ? Future.value(file.bytes)
      : (file.path == null)
          ? null
          : readByteDataFromFile(file.path!);
}

List<filePicker.PlatformFile> _filterFiles(List<filePicker.PlatformFile> files, List<FileType> allowedFileTypes) {
  var allowedExtensions = fileExtensions(allowedFileTypes);

  return files.where((element) => allowedExtensions.contains(element.extension.toString().toLowerCase())).toList();
}