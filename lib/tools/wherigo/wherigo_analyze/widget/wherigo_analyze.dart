import 'dart:collection';
import 'dart:typed_data';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_soundplayer.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_files_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_code_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/wherigo/krevo/logic/ucommons.dart';
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';
import 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';

part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_common_methods.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_zones.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_items.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_messages.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_variables.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_tasks.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_timers.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_inputs.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_answers.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_characters.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_bytecodestructure.dart';
part 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_widget_output_header.dart';

class WherigoAnalyze extends StatefulWidget {
  const WherigoAnalyze({Key? key}) : super(key: key);

  @override
  WherigoAnalyzeState createState() => WherigoAnalyzeState();
}

class WherigoAnalyzeState extends State<WherigoAnalyze> {
  Uint8List _GWCbytes = Uint8List(0);
  Uint8List _LUAbytes = Uint8List(0);

  List<GCWDropDownMenuItem<WHERIGO_OBJECT>> _displayCartridgeDataList = [];

  WHERIGO_FILE_LOAD_STATE _fileLoadedState = WHERIGO_FILE_LOAD_STATE.NULL;

  final List<GCWMapPoint> _ZonePoints = [];
  final List<GCWMapPolyline> _ZonePolylines = [];
  final List<GCWMapPoint> _ItemPoints = [];
  final List<GCWMapPoint> _CharacterPoints = [];

  WherigoCartridge _outData = WherigoCartridge();

  var _displayedCartridgeData = WHERIGO_OBJECT.NULL;

  List<Widget> _GWCFileStructure = [];

  bool _currentDeObfuscate = false;
  bool _currentSyntaxHighlighting = false;
  bool _WherigoShowLUASourcecodeDialog = true;
  bool _getLUAOnline = true;
  bool _nohttpError = true;

  late TextEditingController _codeControllerHighlightedLUA;
  String _LUA_SourceCode = '';

  int _mediaFileIndex = 1;
  int _zoneIndex = 1;
  int _inputIndex = 1;
  int _characterIndex = 1;
  int _timerIndex = 1;
  int _taskIndex = 1;
  int _itemIndex = 1;
  int _messageIndex = 1;
  int _answerIndex = 1;
  int _identifierIndex = 1;

  @override
  void initState() {
    super.initState();
    wherigoExpertMode = Prefs.getBool(PREFERENCE_WHERIGOANALYZER_EXPERTMODE);

    _codeControllerHighlightedLUA = TextEditingController(text: _LUA_SourceCode);
  }

  void _askFoSyntaxHighlighting() {
    showGCWDialog(
        context,
        i18n(context, 'wherigo_syntaxhighlighting_title'),
        SizedBox(
          width: 250,
          height: 150,
          child: GCWText(
            text: i18n(context, 'wherigo_syntaxhighlighting_message'),
            style: gcwDialogTextStyle(),
          ),
        ),
        [
          GCWDialogButton(
              text: i18n(context, 'common_ok'),
              onPressed: () {
                setState(() {
                  _currentSyntaxHighlighting = true;
                });
              }),
          GCWDialogButton(
              text: i18n(context, 'common_cancel'),
              onPressed: () {
                setState(() {
                  _currentSyntaxHighlighting = false;
                });
              }),
        ],
        cancelButton: false);
  }

  void _askForOnlineDecompiling() {
    if (_WherigoShowLUASourcecodeDialog) {
      showGCWDialog(
          context,
          i18n(context, 'wherigo_decompile_title'),
          SizedBox(
            width: 250,
            height: 380,
            child: GCWText(
              text: i18n(context, 'wherigo_decompile_message'),
              style: gcwDialogTextStyle(),
            ),
          ),
          [
            GCWDialogButton(
                text: i18n(context, 'common_ok'),
                onPressed: () {
                  setState(() {
                    _getLUAOnline = true;
                    // do decompiling and analyzing
                    _setLUAData(WherigoCartridgeGWCData.MediaFilesContents[0].MediaFileBytes);
                    _analyseCartridgeFileAsync(WHERIGO_CARTRIDGE_DATA_TYPE.LUA);

                    _fileLoadedState = WHERIGO_FILE_LOAD_STATE.FULL;

                    _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
                    _displayCartridgeDataList = _setDisplayCartridgeDataList();
                  });
                }),
            GCWDialogButton(
                text: i18n(context, 'common_cancel'),
                onPressed: () {
                  setState(() {
                    _getLUAOnline = false;
                  });
                }),
          ],
          cancelButton: false);
      _WherigoShowLUASourcecodeDialog = false;
    } else {
      _setLUAData(WherigoCartridgeGWCData.MediaFilesContents[0].MediaFileBytes);
      _analyseCartridgeFileAsync(WHERIGO_CARTRIDGE_DATA_TYPE.LUA);
    }
  }

  @override
  void dispose() {
    _codeControllerHighlightedLUA.dispose();
    super.dispose();
  }

  void _setGWCData(Uint8List bytes) {
    _GWCbytes = bytes;
    _GWCFileStructure = _buildOutputListByteCodeStructure(context, _GWCbytes);

    if (_fileLoadedState == WHERIGO_FILE_LOAD_STATE.NULL) {
      _fileLoadedState = WHERIGO_FILE_LOAD_STATE.GWC;
    } else if (_fileLoadedState == WHERIGO_FILE_LOAD_STATE.LUA) {
      _fileLoadedState = WHERIGO_FILE_LOAD_STATE.FULL;
    }
  }

  void _setLUAData(Uint8List bytes) {
    _LUAbytes = bytes;
    if (_fileLoadedState == WHERIGO_FILE_LOAD_STATE.NULL) {
      _fileLoadedState = WHERIGO_FILE_LOAD_STATE.LUA;
    } else if (_fileLoadedState == WHERIGO_FILE_LOAD_STATE.GWC) {
      _fileLoadedState = WHERIGO_FILE_LOAD_STATE.FULL;
    }
  }

  @override
  Widget build(BuildContext context) {
    // https://www.kindacode.com/article/flutter-ask-for-confirmation-when-back-button-pressed/
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(i18n(context, 'wherigo_exit_title')),
                    titleTextStyle: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                    content: Text(i18n(context, 'wherigo_exit_message')),
                    contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
                    backgroundColor: themeColors().dialog(),
                    actions: [
                      TextButton(
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: Text(i18n(context, 'common_yes'))),
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(), child: Text(i18n(context, 'common_no')))
                    ],
                  ));
          return willLeave;
        },
        child: Column(
          children: <Widget>[
            _widgetOpenGWCFile(context),

            // Show Button if GWC File loaded and not httpError
            if (_fileLoadedState == WHERIGO_FILE_LOAD_STATE.GWC && _nohttpError) _widgetShowDecompileButton(context),

            // Show OpenFileDialog if GWC File loaded an get LUA offline
            if (_fileLoadedState != WHERIGO_FILE_LOAD_STATE.NULL && !_getLUAOnline) _widgetOpenLUAFile(context),

            // show dropdown if files are loaded
            if (_fileLoadedState != WHERIGO_FILE_LOAD_STATE.NULL) _widgetShowDropDown(context),

            _buildOutput(context)
          ],
        ));
  }

  Widget _widgetShowDropDown(BuildContext context) {
    return Row(
      children: <Widget>[
        GCWIconButton(
          customIcon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(wherigoExpertMode ? Icons.psychology : Icons.psychology_outlined, color: themeColors().mainFont()),
              wherigoExpertMode
                  ? Container()
                  : Stack(
                      alignment: Alignment.center,
                      children: [Icon(Icons.block, size: 35.0, color: themeColors().mainFont())],
                    ),
            ],
          ),
          onPressed: () {
            setState(() {
              wherigoExpertMode = !wherigoExpertMode;
              Prefs.setBool(PREFERENCE_WHERIGOANALYZER_EXPERTMODE, wherigoExpertMode);
              _displayCartridgeDataList = _setDisplayCartridgeDataList();
              showToast(wherigoExpertMode ? i18n(context, 'wherigo_mode_expert') : i18n(context, 'wherigo_mode_user'));
              if (!wherigoExpertMode && (_displayedCartridgeData == WHERIGO_OBJECT.LUABYTECODE) ||
                  _displayedCartridgeData == WHERIGO_OBJECT.GWCFILE ||
                  _displayedCartridgeData == WHERIGO_OBJECT.OBFUSCATORTABLE ||
                  _displayedCartridgeData == WHERIGO_OBJECT.LUAFILE ||
                  _displayedCartridgeData == WHERIGO_OBJECT.TASKS ||
                  _displayedCartridgeData == WHERIGO_OBJECT.TIMERS ||
                  _displayedCartridgeData == WHERIGO_OBJECT.IDENTIFIER ||
                  _displayedCartridgeData == WHERIGO_OBJECT.RESULTS_GWC ||
                  _displayedCartridgeData == WHERIGO_OBJECT.RESULTS_LUA) {
                _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
              }
            });
          },
        ),
        Expanded(
          child: GCWDropDown<WHERIGO_OBJECT>(
            value: _displayedCartridgeData,
            onChanged: (WHERIGO_OBJECT value) {
              setState(() {
                _displayedCartridgeData = value;
                _resetIndices();
              });
            },
            items: _displayCartridgeDataList,
          ),
        ),
      ],
    );
  }

  Widget _widgetShowDecompileButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: GCWButton(
          text: i18n(context, 'wherigo_decompile_button'),
          onPressed: () {
            _askForOnlineDecompiling();
          },
        ))
      ],
    );
  }

  Widget _widgetOpenLUAFile(BuildContext context) {
    return GCWOpenFile(
      title: i18n(context, 'wherigo_open_lua'),
      onLoaded: (_LUAfile) {
        if (_LUAfile == null) {
          showToast(i18n(context, 'common_loadfile_exception_notloaded'));
          return;
        }

        if (isInvalidLUASourcecode(String.fromCharCodes(_LUAfile.bytes.sublist(0, 18)))) {
          showToast(i18n(context, 'common_loadfile_exception_wrongtype_lua'));
          return;
        }

        _setLUAData(_LUAfile.bytes);

        _resetIndices();

        _analyseCartridgeFileAsync(WHERIGO_CARTRIDGE_DATA_TYPE.LUA);

        setState(() {
          _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
          _displayCartridgeDataList = _setDisplayCartridgeDataList();
        });
      },
    );
  }

  Widget _widgetOpenGWCFile(BuildContext context) {
    return GCWOpenFile(
      title: i18n(context, 'wherigo_open_gwc'),
      onLoaded: (_GWCfile) {
        if (_GWCfile == null) {
          showToast(i18n(context, 'common_loadfile_exception_notloaded'));
          return;
        }

        if (isInvalidCartridge(_GWCfile.bytes)) {
          showToast(i18n(context, 'common_loadfile_exception_wrongtype_gwc'));
          return;
        }

        _setGWCData(_GWCfile.bytes);

        _resetIndices();

        _getLUAOnline = true;
        _nohttpError = true;
        _WherigoShowLUASourcecodeDialog = true;

        _analyseCartridgeFileAsync(WHERIGO_CARTRIDGE_DATA_TYPE.GWC);

        setState(() {
          _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
          _displayCartridgeDataList = _setDisplayCartridgeDataList();
        });
      },
    );
  }

  void _resetIndices() {
    _mediaFileIndex = 1;
    _zoneIndex = 1;
    _inputIndex = 1;
    _characterIndex = 1;
    _timerIndex = 1;
    _taskIndex = 1;
    _itemIndex = 1;
    _messageIndex = 1;
    _answerIndex = 1;
    _identifierIndex = 1;
  }

  Widget _buildOutput(BuildContext context) {
    if ((_GWCbytes.isEmpty) && (_LUAbytes.isEmpty)) return Container();

    List<String> errorMsg = [];
    _getErrorMessagesFromGWCAnalyzation(errorMsg, context);
    errorMsg.add('');
    _getErrorMessagesFromLUAAnalyzation(errorMsg, context);

    switch (_displayedCartridgeData) {
      case WHERIGO_OBJECT.NULL:
        return Container();

      case WHERIGO_OBJECT.RESULTS_GWC:
      case WHERIGO_OBJECT.RESULTS_LUA:
        return _buildWidgetToDisplayAnalyzeResultsData(errorMsg);

      case WHERIGO_OBJECT.OBFUSCATORTABLE:
        return _buildWidgetToDisplayObfuscatorTableData(context);

      case WHERIGO_OBJECT.HEADER:
        return _buildWidgetToDisplayHeaderData();

      case WHERIGO_OBJECT.GWCFILE:
        return _buildWidgetToDisplayGCWFileData(context);

      case WHERIGO_OBJECT.LUABYTECODE:
        return _buildWidgetToDisplayLUAByteCodeData(context);

      case WHERIGO_OBJECT.MEDIAFILES:
        return _buildWidgetToDisplayMediaFilesData(context);

      case WHERIGO_OBJECT.LUAFILE:
        return _buildWidgetToDisplayLUAFileData(context);

      case WHERIGO_OBJECT.CHARACTER:
        return _buildWidgetToDisplayCharactersData(context);

      case WHERIGO_OBJECT.ZONES:
        return _buildWidgetToDisplayZonesData(context);

      case WHERIGO_OBJECT.INPUTS:
        return _buildWidgetToDisplayInputsData(context);

      case WHERIGO_OBJECT.TASKS:
        return _buildWidgetToDisplayTasksData(context);

      case WHERIGO_OBJECT.TIMERS:
        return _buildWidgetToDisplayTimersData(context);

      case WHERIGO_OBJECT.ITEMS:
        return _buildWidgetToDisplayItemsData(context);

      case WHERIGO_OBJECT.MESSAGES:
        return _buildWidgetToDisplayMessagesData(context);

      case WHERIGO_OBJECT.IDENTIFIER:
        return _buildWidgetToDisplayIdentifierData(context);

      default:
        return Container();
    }
  }

  Widget _buildWidgetToDisplayAnalyzeResultsData(List<String> _errorMsg) {
    _errorMsg.addAll(errorMsg_MediaFiles);
    return GCWDefaultOutput(
      child: GCWOutputText(
        text: _errorMsg.join('\n'),
        style: gcwMonotypeTextStyle(),
      ),
    );
  }

  Widget _buildWidgetToDisplayObfuscatorTableData(BuildContext context) {
    return Column(
      children: <Widget>[
        if (WherigoCartridgeLUAData.ObfuscatorTable.isEmpty)
          GCWOutput(
            child: i18n(context, 'wherigo_data_nodata'),
            suppressCopyButton: true,
          ),
        if (WherigoCartridgeLUAData.ObfuscatorTable != '')
          GCWOutput(
            title: i18n(context, 'wherigo_header_obfuscatorfunction'),
            child: WherigoCartridgeLUAData.ObfuscatorFunction,
            suppressCopyButton: (WherigoCartridgeLUAData.ObfuscatorFunction == 'NO_OBFUSCATOR'),
          ),
        if (WherigoCartridgeLUAData.ObfuscatorTable != '')
          GCWOutput(
            title: 'dTable',
            child: GCWOutputText(
              text: WherigoCartridgeLUAData.ObfuscatorTable,
              style: gcwMonotypeTextStyle(),
            ),
          ),
      ],
    );
  }

  Widget _buildWidgetToDisplayHeaderData() {
    buildHeader(context);
    return Column(children: <Widget>[
      GCWDefaultOutput(
        trailing: Row(children: <Widget>[
          GCWIconButton(
            icon: Icons.my_location,
            size: IconButtonSize.SMALL,
            iconColor: themeColors().mainFont(),
            onPressed: () {
              _openInMap(
                  _currentZonePoints(
                      WherigoCartridgeGWCData.CartridgeLUAName,
                      WherigoZonePoint(
                          Latitude: WherigoCartridgeGWCData.Latitude,
                          Longitude: WherigoCartridgeGWCData.Longitude,
                          Altitude: WherigoCartridgeGWCData.Altitude)),
                  []);
            },
          ),
        ]),
      ),
      GCWColumnedMultilineOutput(data: (outputHeader.join('') == '[]') ? [<Object>[]] : outputHeader)
    ]);
  }

  Widget _buildWidgetToDisplayGCWFileData(BuildContext context) {
    GCWFile file = GCWFile(bytes: _GWCbytes);

    return Column(
      children: <Widget>[
        // openInHexViewer(BuildContext context, PlatformFile file)
        GCWDefaultOutput(
          child: i18n(context, 'wherigo_media_size') +
              ': ' +
              _GWCbytes.length.toString() +
              '\n\n' +
              i18n(context, 'wherigo_hint_openinhexviewer_1'),
          suppressCopyButton: true,
          trailing: Row(children: <Widget>[
            GCWIconButton(
              iconColor: themeColors().mainFont(),
              size: IconButtonSize.SMALL,
              icon: Icons.input,
              onPressed: () {
                openInHexViewer(context, file);
              },
            ),
          ]),
        ),
        GCWOutput(
          title: i18n(context, 'wherigo_bytecode'),
          child: Column(
              //children: columnedMultiLineOutput(context, _GWCStructure, flexValues: [1, 3, 2])
              children: _GWCFileStructure),
        ),
      ],
    );
  }

  Widget _buildWidgetToDisplayLUAByteCodeData(BuildContext context) {
    GCWFile file = GCWFile(bytes: WherigoCartridgeGWCData.MediaFilesContents[0].MediaFileBytes);

    return Column(
      children: <Widget>[
        // openInHexViewer(BuildContext context, PlatformFile file)
        GCWDefaultOutput(
          child: i18n(context, 'wherigo_media_size') +
              ': ' +
              WherigoCartridgeGWCData.MediaFilesContents[0].MediaFileLength.toString() +
              '\n\n' +
              i18n(context, 'wherigo_hint_openinhexviewer_1') +
              '\n\n' +
              i18n(context, 'wherigo_hint_openinhexviewer_2'),
          suppressCopyButton: true,
          trailing: Row(children: <Widget>[
            GCWIconButton(
              iconColor: themeColors().mainFont(),
              size: IconButtonSize.SMALL,
              icon: Icons.input,
              onPressed: () {
                openInHexViewer(context, file);
              },
            ),
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: themeColors().mainFont(),
              onPressed: () {
                _exportFile(context, WherigoCartridgeGWCData.MediaFilesContents[0].MediaFileBytes, 'LUAByteCode',
                    FileType.LUAC);
              },
            )
          ]),
        ),
      ],
    );
  }

  Widget _buildWidgetToDisplayMediaFilesData(BuildContext context) {
    if ((WherigoCartridgeLUAData.Media.isEmpty) && (WherigoCartridgeGWCData.MediaFilesContents.isEmpty)) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    if (WherigoCartridgeGWCData.MediaFilesContents.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    List<List<String>> _outputMedia = [];
    String filename = '';

    if (_mediaFileIndex < WherigoCartridgeGWCData.MediaFilesContents.length) {
      filename =
          WHERIGO_MEDIACLASS[WherigoCartridgeGWCData.MediaFilesContents[_mediaFileIndex].MediaFileType].toString() +
              ' : ' +
              WHERIGO_MEDIATYPE[WherigoCartridgeGWCData.MediaFilesContents[_mediaFileIndex].MediaFileType].toString();
    }
    if (WherigoCartridgeLUAData.Media.isNotEmpty) {
      filename = WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaFilename;
      if (wherigoExpertMode) {
        _outputMedia = [
          [i18n(context, 'wherigo_media_id'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaID],
          [i18n(context, 'wherigo_media_luaname'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaLUAName],
          [i18n(context, 'wherigo_media_name'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaName],
          [
            i18n(context, 'wherigo_media_description'),
            WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaDescription
          ],
          [i18n(context, 'wherigo_media_alttext'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaAltText],
        ];
      } else {
        _outputMedia = [
          [i18n(context, 'wherigo_media_name'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaName],
          [
            i18n(context, 'wherigo_media_description'),
            WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaDescription
          ],
          [i18n(context, 'wherigo_media_alttext'), WherigoCartridgeLUAData.Media[_mediaFileIndex - 1].MediaAltText],
        ];
      }
    }

    return Column(
      children: <Widget>[
        const GCWDefaultOutput(),
        Row(
          children: <Widget>[
            GCWIconButton(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                setState(() {
                  _mediaFileIndex--;
                  if (_mediaFileIndex < 1) _mediaFileIndex = WherigoCartridgeGWCData.NumberOfObjects - 1;
                });
              },
            ),
            Expanded(
              child: GCWText(
                align: Alignment.center,
                text: i18n(context, 'wherigo_data_media') +
                    ' ' +
                    _mediaFileIndex.toString() +
                    ' / ' +
                    (WherigoCartridgeGWCData.NumberOfObjects - 1).toString(),
              ),
            ),
            GCWIconButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () {
                setState(() {
                  _mediaFileIndex++;
                  if (_mediaFileIndex > WherigoCartridgeGWCData.NumberOfObjects - 1) _mediaFileIndex = 1;
                });
              },
            ),
          ],
        ),
        if (_mediaFileIndex > WherigoCartridgeGWCData.MediaFilesContents.length - 1)
          GCWOutputText(
              text: i18n(context, 'wherigo_error_invalid_mediafile') +
                  '\n' +
                  '» ' +
                  filename +
                  ' «\n\n' +
                  i18n(context, 'wherigo_error_invalid_mediafile_2') +
                  '\n'),
        WherigoCartridgeGWCData.MediaFilesContents[_mediaFileIndex].MediaFileBytes.isNotEmpty
            ? GCWFilesOutput(
                suppressHiddenDataMessage: true,
                suppressedButtons: const {GCWImageViewButtons.SAVE},
                files: [
                  GCWFile(
                      //bytes: _WherigoCartridge.MediaFilesContents[_mediaFileIndex].MediaFileBytes,
                      bytes: _getBytes(WherigoCartridgeGWCData.MediaFilesContents, _mediaFileIndex),
                      name: filename),
                ],
              )
            : GCWOutputText(
                text: i18n(context, 'wherigo_error_invalid_gwc') +
                    '\n' +
                    i18n(context, 'wherigo_error_invalid_mediafile') +
                    '\n' +
                    i18n(context, 'wherigo_error_invalid_mediafile_2') +
                    '\n'),
        GCWColumnedMultilineOutput(data: _outputMedia, flexValues: const [1, 3])
      ],
    );
  }

  Widget _buildWidgetToDisplayLUAFileData(BuildContext context) {
    _LUA_SourceCode = _normalizeLUA(WherigoCartridgeLUAData.LUAFile, _currentDeObfuscate);
    _codeControllerHighlightedLUA.text = _LUA_SourceCode;
    return Column(
      children: <Widget>[
        GCWDefaultOutput(
            trailing: Row(
              children: <Widget>[
                GCWIconButton(
                  icon: (_currentDeObfuscate == true) ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    setState(() {
                      _currentDeObfuscate = !_currentDeObfuscate;
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.color_lens,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    if (!_currentSyntaxHighlighting && _LUA_SourceCode.split('\n').length > 2000) {
                      _askFoSyntaxHighlighting();
                    } else {
                      _currentSyntaxHighlighting = !_currentSyntaxHighlighting;
                    }
                    setState(() {});
                  },
                ),
                GCWIconButton(
                  iconColor: themeColors().mainFont(),
                  size: IconButtonSize.SMALL,
                  icon: Icons.content_copy,
                  onPressed: () {
                    var copyText = _LUA_SourceCode;

                    insertIntoGCWClipboard(context, copyText);
                  },
                ),
                GCWIconButton(
                  icon: Icons.save,
                  size: IconButtonSize.SMALL,
                  iconColor: themeColors().inActive(),
                  onPressed: () {
                    _exportFile(
                        context,
                        Uint8List.fromList(_LUA_SourceCode.codeUnits),
                        //_normalizeLUA(WherigoCartridgeLUAData.LUAFile, _currentDeObfuscate).codeUnits),
                        'LUAsourceCode',
                        FileType.LUA);
                  },
                ),
              ],
            ),
            child: (_currentSyntaxHighlighting == true)
                ? GCWCodeTextField(
                    controller: _codeControllerHighlightedLUA,
                    language: CodeHighlightingLanguage.LUA,
                    lineNumberStyle: const GCWCodeTextFieldLineNumberStyle(width: 80.0),
                    patternMap: WHERIGO_SYNTAX_HIGHLIGHT_STRINGMAP)
                : GCWOutputText(
                    text: _LUA_SourceCode,
                  ))
      ],
    );
  }

  Widget _buildWidgetToDisplayCharactersData(BuildContext context) {
    if (WherigoCartridgeLUAData.Characters.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      (_CharacterPoints.isNotEmpty)
          ? GCWDefaultOutput(
              trailing: Row(children: <Widget>[
                GCWIconButton(
                  icon: Icons.save,
                  size: IconButtonSize.SMALL,
                  iconColor: themeColors().mainFont(),
                  onPressed: () {
                    _exportCoordinates(context, _CharacterPoints, []);
                  },
                ),
                GCWIconButton(
                  icon: Icons.my_location,
                  size: IconButtonSize.SMALL,
                  iconColor: themeColors().mainFont(),
                  onPressed: () {
                    _openInMap(_CharacterPoints, []);
                  },
                ),
              ]),
            )
          : const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _characterIndex--;
                if (_characterIndex < 1) _characterIndex = WherigoCartridgeLUAData.Characters.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_character') +
                  ' ' +
                  _characterIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Characters.length).toString(),
            ),
          ),
          if (WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterZonepoint.Latitude != 0.0 &&
              WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterZonepoint.Longitude != 0.0)
            GCWIconButton(
              icon: Icons.my_location,
              size: IconButtonSize.SMALL,
              iconColor: themeColors().mainFont(),
              onPressed: () {
                _openInMap(
                    _currentZonePoints(
                        WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterName,
                        WherigoZonePoint(
                            Latitude:
                                WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterZonepoint.Latitude,
                            Longitude:
                                WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterZonepoint.Longitude,
                            Altitude:
                                WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterZonepoint.Altitude)),
                    []);
              },
            ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _characterIndex++;
                if (_characterIndex > WherigoCartridgeLUAData.Characters.length) _characterIndex = 1;
              });
            },
          ),
        ],
      ),
      _buildImageView(
          context,
          WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterMediaName != '' &&
              WherigoCartridgeGWCData.MediaFilesContents.length > 1,
          WherigoCartridgeLUAData.Characters[_characterIndex - 1].CharacterMediaName),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfCharacterData(context, WherigoCartridgeLUAData.Characters[_characterIndex - 1]),
          flexValues: const [1, 3])
    ]);
  }

  Widget _buildWidgetToDisplayZonesData(BuildContext context) {
    if (WherigoCartridgeLUAData.Zones.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      GCWDefaultOutput(
        trailing: Row(children: <Widget>[
          GCWIconButton(
            icon: Icons.save,
            size: IconButtonSize.SMALL,
            iconColor: themeColors().mainFont(),
            onPressed: () {
              _exportCoordinates(context, _ZonePoints, _ZonePolylines);
            },
          ),
          GCWIconButton(
            icon: Icons.my_location,
            size: IconButtonSize.SMALL,
            iconColor: themeColors().mainFont(),
            onPressed: () {
              _openInMap(_ZonePoints, _ZonePolylines);
            },
          ),
        ]),
      ),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _zoneIndex--;
                if (_zoneIndex < 1) _zoneIndex = WherigoCartridgeLUAData.Zones.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_zone') +
                  ' ' +
                  _zoneIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Zones.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.my_location,
            size: IconButtonSize.SMALL,
            iconColor: themeColors().mainFont(),
            onPressed: () {
              _openInMap(
                  _currentZonePoints(WherigoCartridgeLUAData.Zones[_zoneIndex - 1].ZoneName,
                      WherigoCartridgeLUAData.Zones[_zoneIndex - 1].ZoneOriginalPoint),
                  _currentZonePolylines(WherigoCartridgeLUAData.Zones[_zoneIndex - 1].ZonePoints));
            },
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _zoneIndex++;
                if (_zoneIndex > WherigoCartridgeLUAData.Zones.length) _zoneIndex = 1;
              });
            },
          ),
        ],
      ),
      _buildImageView(
          context,
          (WherigoCartridgeLUAData.Zones[_zoneIndex - 1].ZoneMediaName != '') &&
              WherigoCartridgeGWCData.MediaFilesContents.length > 1,
          WherigoCartridgeLUAData.Zones[_zoneIndex - 1].ZoneMediaName),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfZoneData(context, WherigoCartridgeLUAData.Zones[_zoneIndex - 1]),
          flexValues: const [1, 3])
    ]);
  }

  Widget _buildWidgetToDisplayInputsData(BuildContext context) {
    if (WherigoCartridgeLUAData.Inputs.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _inputIndex--;
                _answerIndex = 1;
                if (_inputIndex < 1) _inputIndex = WherigoCartridgeLUAData.Inputs.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_input') +
                  ' ' +
                  _inputIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Inputs.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _inputIndex++;
                _answerIndex = 1;
                if (_inputIndex > WherigoCartridgeLUAData.Inputs.length) _inputIndex = 1;
              });
            },
          ),
        ],
      ),

      // Widget for Answer-Details
      _buildImageView(
          context,
          WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputMedia != '' &&
              WherigoCartridgeGWCData.MediaFilesContents.length > 1,
          WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputMedia),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfInputData(context, WherigoCartridgeLUAData.Inputs[_inputIndex - 1]),
          flexValues: const [1, 3]),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _answerIndex--;
                if (_answerIndex < 1) {
                  _answerIndex = WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers.length;
                }
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_answer') +
                  ' ' +
                  _answerIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _answerIndex++;
                if (_answerIndex > WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers.length) {
                  _answerIndex = 1;
                }
              });
            },
          ),
        ],
      ),
      Column(
        children: <Widget>[
          GCWColumnedMultilineOutput(
              data: _buildOutputListAnswers(
                context,
                WherigoCartridgeLUAData.Inputs[_inputIndex - 1],
                (WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers.isNotEmpty)
                    ? WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers[_answerIndex - 1]
                    : WherigoAnswerData(AnswerAnswer: '', AnswerHash: '', AnswerActions: []),
              ),
              copyColumn: 1,
              flexValues: const [2, 3, 3]),
          GCWExpandableTextDivider(
            expanded: false,
            text: i18n(context, 'wherigo_output_answeractions'),
            suppressTopSpace: false,
            child: Column(
                children: _outputAnswerActionsWidgets(
              context,
              (WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers.isNotEmpty)
                  ? WherigoCartridgeLUAData.Inputs[_inputIndex - 1].InputAnswers[_answerIndex - 1]
                  : WherigoAnswerData(AnswerAnswer: '', AnswerHash: '', AnswerActions: []),
            )),
          ),
        ],
      ),
    ]);
  }

  Widget _buildWidgetToDisplayTasksData(BuildContext context) {
    if (WherigoCartridgeLUAData.Tasks.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _taskIndex--;
                if (_taskIndex < 1) _taskIndex = WherigoCartridgeLUAData.Tasks.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_task') +
                  ' ' +
                  _taskIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Tasks.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _taskIndex++;
                if (_taskIndex > WherigoCartridgeLUAData.Tasks.length) _taskIndex = 1;
              });
            },
          ),
        ],
      ),
      _buildImageView(
          context,
          WherigoCartridgeLUAData.Tasks[_taskIndex - 1].TaskMedia != '' &&
              WherigoCartridgeGWCData.MediaFilesContents.length > 1,
          WherigoCartridgeLUAData.Tasks[_taskIndex - 1].TaskMedia),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfTaskData(context, WherigoCartridgeLUAData.Tasks[_taskIndex - 1]),
          flexValues: const [1, 3])
    ]);
  }

  Widget _buildWidgetToDisplayTimersData(BuildContext context) {
    if (WherigoCartridgeLUAData.Timers.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _timerIndex--;
                if (_timerIndex < 1) _timerIndex = WherigoCartridgeLUAData.Timers.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_timer') +
                  ' ' +
                  _timerIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Timers.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _timerIndex++;
                if (_timerIndex > WherigoCartridgeLUAData.Timers.length) _timerIndex = 1;
              });
            },
          ),
        ],
      ),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfTimerData(context, WherigoCartridgeLUAData.Timers[_timerIndex - 1]),
          flexValues: const [1, 3])
    ]);
  }

  Widget _buildWidgetToDisplayItemsData(BuildContext context) {
    if (WherigoCartridgeLUAData.Items.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      (_ItemPoints.isNotEmpty)
          ? GCWDefaultOutput(
              trailing: Row(children: <Widget>[
                GCWIconButton(
                  icon: Icons.save,
                  size: IconButtonSize.SMALL,
                  iconColor: themeColors().mainFont(),
                  onPressed: () {
                    _exportCoordinates(context, _ItemPoints, []);
                  },
                ),
                GCWIconButton(
                  icon: Icons.my_location,
                  size: IconButtonSize.SMALL,
                  iconColor: themeColors().mainFont(),
                  onPressed: () {
                    _openInMap(_ItemPoints, []);
                  },
                ),
              ]),
            )
          : const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _itemIndex--;
                if (_itemIndex < 1) _itemIndex = WherigoCartridgeLUAData.Items.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_item') +
                  ' ' +
                  _itemIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Items.length).toString(),
            ),
          ),
          if (WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemZonepoint.Latitude != 0.0 &&
              WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemZonepoint.Longitude != 0.0)
            GCWIconButton(
              icon: Icons.my_location,
              size: IconButtonSize.SMALL,
              iconColor: themeColors().mainFont(),
              onPressed: () {
                _openInMap(
                    _currentZonePoints(
                        WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemName,
                        WherigoZonePoint(
                            Latitude: WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemZonepoint.Latitude,
                            Longitude: WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemZonepoint.Longitude,
                            Altitude: WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemZonepoint.Altitude)),
                    []);
              },
            ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _itemIndex++;
                if (_itemIndex > WherigoCartridgeLUAData.Items.length) _itemIndex = 1;
              });
            },
          ),
        ],
      ),
      _buildImageView(
          context,
          WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemMedia != '' &&
              WherigoCartridgeGWCData.MediaFilesContents.length > 1,
          WherigoCartridgeLUAData.Items[_itemIndex - 1].ItemMedia),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfItemData(context, WherigoCartridgeLUAData.Items[_itemIndex - 1]),
          flexValues: const [1, 3])
    ]);
  }

  Widget _buildWidgetToDisplayMessagesData(BuildContext context) {
    if (WherigoCartridgeLUAData.Messages.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _messageIndex--;
                if (_messageIndex < 1) _messageIndex = WherigoCartridgeLUAData.Messages.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: i18n(context, 'wherigo_data_message') +
                  ' ' +
                  _messageIndex.toString() +
                  ' / ' +
                  (WherigoCartridgeLUAData.Messages.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _messageIndex++;
                if (_messageIndex > WherigoCartridgeLUAData.Messages.length) _messageIndex = 1;
              });
            },
          ),
        ],
      ),
      Column(children: _buildOutputListOfMessageData(context, WherigoCartridgeLUAData.Messages[_messageIndex - 1]))
    ]);
  }

  Widget _buildWidgetToDisplayIdentifierData(BuildContext context) {
    if (WherigoCartridgeLUAData.Variables.isEmpty) {
      return GCWDefaultOutput(
        child: i18n(context, 'wherigo_data_nodata'),
        suppressCopyButton: true,
      );
    }

    return Column(children: <Widget>[
      const GCWDefaultOutput(),
      Row(
        children: <Widget>[
          GCWIconButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              setState(() {
                _identifierIndex--;
                if (_identifierIndex < 1) _identifierIndex = WherigoCartridgeLUAData.Variables.length;
              });
            },
          ),
          Expanded(
            child: GCWText(
              align: Alignment.center,
              text: _identifierIndex.toString() + ' / ' + (WherigoCartridgeLUAData.Variables.length).toString(),
            ),
          ),
          GCWIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                _identifierIndex++;
                if (_identifierIndex > WherigoCartridgeLUAData.Variables.length) _identifierIndex = 1;
              });
            },
          ),
        ],
      ),
      GCWColumnedMultilineOutput(
          data: _buildOutputListOfVariables(context, WherigoCartridgeLUAData.Variables[_identifierIndex - 1])),
      GCWExpandableTextDivider(
        expanded: false,
        text: i18n(context, 'wherigo_output_identifier_details'),
        child: GCWColumnedMultilineOutput(
            data: _buildOutputListOfVariablesDetails(context, WherigoCartridgeLUAData.Variables[_identifierIndex - 1])),
      ),
    ]);
  }

  Future<void> _exportFile(BuildContext context, Uint8List data, String name, FileType fileType) async {
    await saveByteDataToFile(context, data, buildFileNameWithDate(name, fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }

  Future<void> _exportCoordinates(
      BuildContext context, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) async {
    showCoordinatesExportDialog(context, points, polylines);
  }

  void _openInMap(List<GCWMapPoint> points, List<GCWMapPolyline> polylines) {
    Navigator.push(
        context,
        MaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: GCWMapView(
                  points: List<GCWMapPoint>.from(points),
                  polylines: List<GCWMapPolyline>.from(polylines),
                  isEditable: false, // false: open in Map
                  // true:  open in FreeMap
                ),
                id: 'coords_map_view',
                autoScroll: false,
                suppressToolMargin: true)));
  }

  void _analyseCartridgeFileAsync(WHERIGO_CARTRIDGE_DATA_TYPE dataType) async {
    switch (dataType) {
      case WHERIGO_CARTRIDGE_DATA_TYPE.GWC:
        _analyseGWCCartridgeFileAsync();
        break;
      case WHERIGO_CARTRIDGE_DATA_TYPE.LUA:
        _analyseLUACartridgeFileAsync();
        break;
      default:
        {}
    }
  }

  void _analyseGWCCartridgeFileAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 150,
            child: GCWAsyncExecuter<WherigoCartridge>(
              isolatedFunction: getGcwCartridgeAsync,
              parameter: _buildGwcJobData,
              onReady: (data) => _showCartridgeOutputGWC(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  void _analyseLUACartridgeFileAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 220,
            width: 150,
            child: GCWAsyncExecuter<WherigoCartridge>(
              isolatedFunction: getLuaCartridgeAsync,
              parameter: _buildLuaJobData,
              onReady: (data) => _showCartridgeOutputLUA(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildGwcJobData() async {
    return GCWAsyncExecuterParameters(WherigoJobData(
        jobDataBytes: _GWCbytes, jobDataMode: _getLUAOnline, jobDataType: WHERIGO_CARTRIDGE_DATA_TYPE.GWC));
  }

  Future<GCWAsyncExecuterParameters?> _buildLuaJobData() async {
    return GCWAsyncExecuterParameters(WherigoJobData(
        jobDataBytes: _LUAbytes, jobDataMode: _getLUAOnline, jobDataType: WHERIGO_CARTRIDGE_DATA_TYPE.LUA));
  }

  void _showCartridgeOutputLUA(WherigoCartridge output) {
    _outData = output;
    String toastMessage = '';
    int toastDuration = 3;

    WherigoCartridgeLUAData = _outData.cartridgeLUA;

    NameToObject = WherigoCartridgeLUAData.NameToObject;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    switch (WherigoCartridgeLUAData.ResultStatus) {
      case WHERIGO_ANALYSE_RESULT_STATUS.OK:
        toastMessage = i18n(context, 'wherigo_data_loaded') + ': LUA';
        toastDuration = 5;
        _nohttpError = false;

        // check if GWC and LUA are from the same cartridge
        if ((WherigoCartridgeGWCData.CartridgeGUID != WherigoCartridgeLUAData.CartridgeGUID &&
                WherigoCartridgeLUAData.CartridgeGUID != '') &&
            (WherigoCartridgeGWCData.CartridgeLUAName != WherigoCartridgeLUAData.CartridgeLUAName &&
                WherigoCartridgeLUAData.CartridgeLUAName != '')) {
          // files belong to different cartridges
          WherigoCartridgeLUAData = _resetLUA('wherigo_error_diff_gwc_lua_1');
          _fileLoadedState = WHERIGO_FILE_LOAD_STATE.GWC;
          _displayedCartridgeData = WHERIGO_OBJECT.HEADER;

          toastMessage =
              i18n(context, 'wherigo_error_diff_gwc_lua_1') + '\n' + i18n(context, 'wherigo_error_diff_gwc_lua_2');
          toastDuration = 30;
        } else {
          _fileLoadedState = WHERIGO_FILE_LOAD_STATE.FULL;
          _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
          showToast(toastMessage, duration: toastDuration);

          _updateOutput();
        }
        break;

      case WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA:
        toastMessage = i18n(context, 'wherigo_error_runtime') +
            '\n' +
            i18n(context, 'wherigo_error_runtime_lua') +
            '\n\n' +
            i18n(context, 'wherigo_error_hint_1');
        toastDuration = 20;
        break;

      case WHERIGO_ANALYSE_RESULT_STATUS.ERROR_HTTP:
        _fileLoadedState = WHERIGO_FILE_LOAD_STATE.GWC;
        _nohttpError = false;
        _displayedCartridgeData = WHERIGO_OBJECT.HEADER;
        toastMessage = i18n(context, 'wherigo_http_code') +
            ' ' +
            WherigoCartridgeLUAData.httpCode.toString() +
            '\n\n' +
            (WHERIGO_HTTP_STATUS[WherigoCartridgeLUAData.httpCode] != null
                ? i18n(context, WHERIGO_HTTP_STATUS[WherigoCartridgeLUAData.httpCode]!)
                : '') +
            '\n';

        if (WherigoCartridgeLUAData.httpMessage.startsWith('wherigo')) {
          toastMessage = toastMessage + i18n(context, WherigoCartridgeLUAData.httpMessage);
        } else {
          toastMessage = toastMessage + WherigoCartridgeLUAData.httpMessage;
        }
        _getLUAOnline = false;
        WherigoCartridgeLUAData = WherigoCartridgeLUA(
          LUAFile: '',
          CartridgeLUAName: '',
          CartridgeGUID: '',
          ObfuscatorTable: '',
          ObfuscatorFunction: '',
          Characters: [],
          Items: [],
          Tasks: [],
          Inputs: [],
          Zones: [],
          Timers: [],
          Media: [],
          Messages: [],
          Variables: [],
          NameToObject: {},
          Builder: WHERIGO_BUILDER.UNKNOWN,
          BuilderVersion: '',
          TargetDeviceVersion: '',
          CountryID: '',
          StateID: '',
          UseLogging: '',
          CreateDate: WHERIGO_NULLDATE,
          PublishDate: WHERIGO_NULLDATE,
          UpdateDate: WHERIGO_NULLDATE,
          LastPlayedDate: WHERIGO_NULLDATE,
          httpCode: WherigoCartridgeLUAData.httpCode,
          httpMessage: WherigoCartridgeLUAData.httpMessage,
          ResultStatus: WHERIGO_ANALYSE_RESULT_STATUS.ERROR_HTTP,
          ResultsLUA: [
            i18n(context, 'wherigo_error_runtime'),
            i18n(context, 'wherigo_error_decompile_gwc'),
            i18n(context, 'wherigo_http_code') + ' ' + WherigoCartridgeLUAData.httpCode.toString() + '\n',
            (WHERIGO_HTTP_STATUS[WherigoCartridgeLUAData.httpCode] != null
                ? i18n(context, WHERIGO_HTTP_STATUS[WherigoCartridgeLUAData.httpCode]!)
                : ''),
            WherigoCartridgeLUAData.httpMessage.startsWith('wherigo')
                ? i18n(context, WherigoCartridgeLUAData.httpMessage)
                : WherigoCartridgeLUAData.httpMessage,
            '',
            i18n(context, 'wherigo_error_hint_2'),
          ],
        );
        toastDuration = 30;
        break;
      default:
        {}
    } // outData != null
  }

  void _showCartridgeOutputGWC(WherigoCartridge output) {
    _outData = output;
    String toastMessage = '';
    int toastDuration = 3;

    WherigoCartridgeGWCData = _outData.cartridgeGWC;

    switch (WherigoCartridgeGWCData.ResultStatus) {
      case WHERIGO_ANALYSE_RESULT_STATUS.OK:
        toastMessage = i18n(context, 'wherigo_data_loaded') + ': GWC';
        break;

      case WHERIGO_ANALYSE_RESULT_STATUS.ERROR_GWC:
        toastMessage = i18n(context, 'wherigo_error_runtime') +
            '\n' +
            i18n(context, 'wherigo_error_runtime_gwc') +
            '\n\n' +
            i18n(context, 'wherigo_error_hint_1');
        toastDuration = 20;
        break;
      default:
        {}
    }

    // check if GWC and LUA are from the same cartridge
    if (_GCWandLUAareFromDifferentCartridges()) {
      // files belong to different cartridges
      WherigoCartridgeLUAData = _resetLUA('wherigo_error_diff_gwc_lua_1');
      _getLUAOnline = true;
      _nohttpError = true;
      _WherigoShowLUASourcecodeDialog = true;
      showToast(i18n(context, 'wherigo_error_diff_gwc_lua_1') + '\n' + i18n(context, 'wherigo_error_diff_gwc_lua_2'),
          duration: 30);
    }
    _fileLoadedState = WHERIGO_FILE_LOAD_STATE.GWC;
    _displayedCartridgeData = WHERIGO_OBJECT.HEADER;

    showToast(toastMessage, duration: toastDuration);

    _updateOutput();
    // outData != null

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  bool _GCWandLUAareFromDifferentCartridges() {
    return ((WherigoCartridgeGWCData.CartridgeGUID != WherigoCartridgeLUAData.CartridgeGUID &&
            WherigoCartridgeLUAData.CartridgeGUID != '') &&
        (WherigoCartridgeGWCData.CartridgeLUAName != WherigoCartridgeLUAData.CartridgeLUAName &&
            WherigoCartridgeLUAData.CartridgeLUAName != ''));
  }

  void _updateOutput() {
    _buildZonesForMapExport();
    _buildItemPointsForMapExport();
    _buildCharacterPointsForMapExport();
    buildHeader(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _buildItemPointsForMapExport() {
    _ItemPoints.clear();

    // Build data
    for (var item in WherigoCartridgeLUAData.Items) {
      if (item.ItemZonepoint.Latitude != 0.0 && item.ItemZonepoint.Longitude != 0.0) {
        if (NameToObject[item.ItemLUAName] == null) continue;

        _ItemPoints.add(// add location of item
            GCWMapPoint(
                uuid: 'Point ' + NameToObject[item.ItemLUAName]!.ObjectName,
                markerText: NameToObject[item.ItemLUAName]!.ObjectName,
                point: LatLng(item.ItemZonepoint.Latitude, item.ItemZonepoint.Longitude),
                color: Colors.black));
      }
    }
  }

  void _buildCharacterPointsForMapExport() {
    _CharacterPoints.clear();

    // Build data
    for (var character in WherigoCartridgeLUAData.Characters) {
      if (character.CharacterLocation == 'ZonePoint') {
        if (NameToObject[character.CharacterLUAName] == null) continue;

        _CharacterPoints.add(// add location of character
            GCWMapPoint(
                uuid: 'Point ' + NameToObject[character.CharacterLUAName]!.ObjectName,
                markerText: NameToObject[character.CharacterLUAName]!.ObjectName,
                point: LatLng(character.CharacterZonepoint.Latitude, character.CharacterZonepoint.Longitude),
                color: Colors.black));
      }
    }
  }

  void _buildZonesForMapExport() {
    // Clear data

    _ZonePoints.clear();
    _ZonePolylines.clear();

    // Build data

    for (WherigoZoneData zone in WherigoCartridgeLUAData.Zones) {
      if (NameToObject[zone.ZoneLUAName] == null) return;

      _ZonePoints.add(// add originalpoint of zone
          GCWMapPoint(
              uuid: 'Original Point ' + NameToObject[zone.ZoneLUAName]!.ObjectName,
              markerText: NameToObject[zone.ZoneLUAName]!.ObjectName,
              point: LatLng(zone.ZoneOriginalPoint.Latitude, zone.ZoneOriginalPoint.Longitude),
              color: Colors.black87));

      List<GCWMapPoint> polyline = [];

      for (WherigoZonePoint point in zone.ZonePoints) {
        polyline.add(GCWMapPoint(point: LatLng(point.Latitude, point.Longitude), color: Colors.black));
      }
      polyline.add(// close polyline
          GCWMapPoint(point: LatLng(zone.ZonePoints[0].Latitude, zone.ZonePoints[0].Longitude), color: Colors.black));
      _ZonePolylines.add(GCWMapPolyline(uuid: zone.ZoneLUAName, points: polyline, color: Colors.black));
    }

    if (WherigoCartridgeGWCData.Latitude != 0.0 && WherigoCartridgeGWCData.Longitude != 0.0) {
      _ZonePoints.add(GCWMapPoint(
          uuid: 'Cartridge Start',
          markerText: 'Wherigo "' + WherigoCartridgeGWCData.CartridgeLUAName + '"',
          point: LatLng(WherigoCartridgeGWCData.Latitude, WherigoCartridgeGWCData.Longitude),
          color: Colors.redAccent));
    }
  }

  String _normalizeLUA(String LUAFile, bool deObfuscate) {
    if (deObfuscate) {
      LUAFile = LUAFile.replaceAll(WherigoCartridgeLUAData.ObfuscatorFunction, 'deObfuscate');
      LUAFile = LUAFile.replaceAll(WherigoCartridgeLUAData.CartridgeLUAName,
          'objCartridge_' + WherigoCartridgeLUAData.CartridgeLUAName.replaceAll(' ', ''));
      for (var element in WherigoCartridgeLUAData.Characters) {
        LUAFile = LUAFile.replaceAll(element.CharacterLUAName, 'objCharacter_' + element.CharacterName);
      }
      for (var element in WherigoCartridgeLUAData.Items) {
        LUAFile = LUAFile.replaceAll(element.ItemLUAName, 'objItem_' + element.ItemName);
      }
      for (var element in WherigoCartridgeLUAData.Tasks) {
        LUAFile = LUAFile.replaceAll(element.TaskLUAName, 'objTask_' + element.TaskName);
      }
      for (var element in WherigoCartridgeLUAData.Inputs) {
        LUAFile = LUAFile.replaceAll(element.InputLUAName, 'objInput_' + element.InputName);
      }
      for (var element in WherigoCartridgeLUAData.Zones) {
        LUAFile = LUAFile.replaceAll(element.ZoneLUAName, 'objZone_' + element.ZoneName);
      }
      for (var element in WherigoCartridgeLUAData.Timers) {
        LUAFile = LUAFile.replaceAll(element.TimerLUAName, 'objTimer_' + element.TimerName);
      }
      for (var element in WherigoCartridgeLUAData.Media) {
        LUAFile = LUAFile.replaceAll(element.MediaLUAName, 'objMedia_' + element.MediaName);
      }
      NameToObject.forEach((key, value) {
        LUAFile = LUAFile.replaceAll(key, 'objVariable_' + key);
      });

      RegExp(r'deObfuscate\(".*?"\)').allMatches(LUAFile).forEach((obfuscatedText) {
        var group = obfuscatedText.group(0);
        if (group == null) return;
        LUAFile = LUAFile.replaceAll(group, _deObfuscate(group));
      });
    }
    return LUAFile;
  }

  String _deObfuscate(String obfuscatedText) {
    obfuscatedText = obfuscatedText.replaceAll('deObfuscate("', '').replaceAll('")', '');
    return '"' + deobfuscateUrwigoText(obfuscatedText, WherigoCartridgeLUAData.ObfuscatorTable) + '"';
  }

  List<GCWMapPoint> _currentZonePoints(String text, WherigoZonePoint point) {
    return [
      GCWMapPoint(
          uuid: 'Zone OriginalPoint',
          markerText: text,
          point: LatLng(point.Latitude, point.Longitude),
          color: Colors.redAccent)
    ];
  }

  List<GCWMapPolyline> _currentZonePolylines(List<WherigoZonePoint> points) {
    List<GCWMapPolyline> result = [];
    List<GCWMapPoint> polyline = [];

    for (var point in points) {
      polyline.add(GCWMapPoint(point: LatLng(point.Latitude, point.Longitude), color: Colors.black));
    }
    polyline.add(// close polyline
        GCWMapPoint(point: LatLng(points[0].Latitude, points[0].Longitude), color: Colors.black));

    result.add(GCWMapPolyline(points: polyline, color: Colors.black));
    return result;
  }

  Uint8List _getBytes(List<WherigoMediaFileContent> MediaFilesContents, int mediaFileIndex) {
    for (int i = 0; i < MediaFilesContents.length; i++) {
      if (MediaFilesContents[i].MediaFileID == mediaFileIndex) {
        return MediaFilesContents[i].MediaFileBytes;
      }
    }
    return Uint8List.fromList([]);
  }

  WherigoCartridgeLUA _resetLUA(String error) {
    return WHERIGO_EMPTYCARTRIDGE_LUA;
  }

  List<GCWDropDownMenuItem<WHERIGO_OBJECT>> _setDisplayCartridgeDataList() {
    var loadedState = WHERIGO_DROPDOWN_DATA[wherigoExpertMode]?[_fileLoadedState];
    if (loadedState == null) return <GCWDropDownMenuItem<WHERIGO_OBJECT>>[];

    return SplayTreeMap<String, WHERIGO_OBJECT>.from(switchMapKeyValue(loadedState)
            .map((String key, WHERIGO_OBJECT value) => MapEntry<String, WHERIGO_OBJECT>(i18n(context, key), value)))
        .entries
        .map((mode) {
      return GCWDropDownMenuItem(
        value: mode.value,
        child: mode.key,
      );
    }).toList();
  }
}
