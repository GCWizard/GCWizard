import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_files_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/logic/hidden_data.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:intl/intl.dart';

class HiddenData extends StatefulWidget {
  final GCWFile platformFile;

  const HiddenData({Key key, this.platformFile}) : super(key: key);

  @override
  HiddenDataState createState() => HiddenDataState();
}

class HiddenDataState extends State<HiddenData> {
  TextEditingController _hideController;

  GCWFile _unHideFile;

  GCWFile _publicFile;
  GCWFile _secretFile;

  var _currentMode = GCWSwitchPosition.right;
  var _currentHideMode = GCWSwitchPosition.left;

  String _currentHideInput = '';

  @override
  void initState() {
    super.initState();

    _hideController = TextEditingController(text: _currentHideInput);
  }

  @override
  void dispose() {
    _hideController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_unHideFile == null && widget.platformFile != null) {
      _unHideFile = widget.platformFile;
    }

    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'hiddendata_hidedata'),
          rightValue: i18n(context, 'hiddendata_unhidedata'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right ? _buildUnhideWidget() : _buildHideWidget()
      ],
    );
  }

  Widget _buildHideWidget() {
    return Column(
      children: [
        GCWOpenFile(
          title: i18n(context, 'hiddendata_openpublicfile'),
          file: _publicFile,
          onLoaded: (_openedFile) {
            if (_openedFile == null) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }

            setState(() {
              _publicFile = _openedFile;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'hiddendata_opensecretfile')),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'hiddendata_hide'),
          leftValue: i18n(context, 'hiddendata_hide_text'),
          rightValue: i18n(context, 'hiddendata_hide_file'),
          value: _currentHideMode,
          onChanged: (value) {
            setState(() {
              _currentHideMode = value;
            });
          },
        ),
        if (_currentHideMode == GCWSwitchPosition.left)
          GCWTextField(
            controller: _hideController,
            onChanged: (text) {
              _currentHideInput = text;
            },
          ),
        if (_currentHideMode == GCWSwitchPosition.right)
          GCWOpenFile(
            file: _secretFile,
            onLoaded: (_openedFile) {
              if (_openedFile == null) {
                showToast(i18n(context, 'common_loadfile_exception_notloaded'));
                return;
              }

              setState(() {
                _secretFile = _openedFile;
              });
            },
          ),
        Container(height: 15),
        GCWDivider(),
        GCWButton(
          text: i18n(context, 'hiddendata_hideandsave'),
          onPressed: () {
            var data;
            if (_currentHideMode == GCWSwitchPosition.left) {
              data = mergeFiles([_publicFile.bytes, _currentHideInput]);
            } else {
              data = mergeFiles([_publicFile.bytes, _secretFile.bytes]);
            }

            _exportFile(
                context, GCWFile(name: 'hidden_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()), bytes: data));
          },
        )
      ],
    );
  }

  Widget _buildUnhideWidget() {
    return Column(
      children: [
        Container(), // fixes strange behaviour: First GCWOpenFile widget from hide/unhide affect each other
        GCWOpenFile(
          file: _unHideFile,
          onLoaded: (_openedFile) {
            if (_openedFile == null) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }

            setState(() {
              _unHideFile = _openedFile;
            });
          },
        ),

        GCWDefaultOutput(
          child: _buildOutput(),
          suppressCopyButton: true,
        )
      ],
    );
  }

  Widget _buildOutput() {
    if (_unHideFile == null) return Container();

    var _complete = false;
    var _hiddenDataList = hiddenData(_unHideFile);
    _hiddenDataList.then((value) {
      _complete = true;
    });

    return FutureBuilder(
        future: _hiddenDataList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!_complete)
            return GCWOutputText(text: i18n(context, 'common_please_wait'), suppressCopyButton: true);
          else if (snapshot.data == null || snapshot.data.isEmpty)
            return GCWOutputText(text: i18n(context, 'hiddendata_nohiddendatafound'), suppressCopyButton: true);
          else
            return GCWFilesOutput(files: snapshot.data);
        });
  }

  _exportFile(BuildContext context, GCWFile file) async {
    if (file.bytes == null) {
      showToast(i18n(context, 'hiddendata_datanotreadable'));
      return;
    }

    var fileName = file.name.replaceFirst(HIDDEN_FILE_IDENTIFIER, 'hidden_file');
    var ext = file.name.split('.');

    if (ext.length <= 1 || ext.last.length >= 5) fileName = fileName + '.' + fileExtension(file.fileType);

    var value = await saveByteDataToFile(context, file.bytes, fileName);
    if (value != null) showExportedFileDialog(context, fileType: file.fileType);
  }
}

openInHiddenData(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
              tool: HiddenData(platformFile: file), toolName: i18n(context, 'hiddendata_title'), i18nPrefix: '')));
}
