import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textviewer.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class HexViewer extends StatefulWidget {
  final GCWFile? file;

  const HexViewer({Key? key, this.file}) : super(key: key);

  @override
  _HexViewerState createState() => _HexViewerState();
}

class _HexViewerState extends State<HexViewer> {
  late ScrollController _scrollControllerHex;
  late ScrollController _scrollControllerASCII;

  String? _hexData;
  double? _hexDataLines;
  Uint8List? _bytes;

  final _MAX_LINES = 100;
  final _CHARS_PER_LINE = 16 * 2;

  var _currentLines = 0;

  var _isHexScrolling = false;
  var _isASCIIScrolling = false;

  @override
  void initState() {
    _scrollControllerHex = ScrollController();
    _scrollControllerASCII = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerHex.dispose();
    _scrollControllerASCII.dispose();

    super.dispose();
  }

  void _setData(Uint8List bytes) {
    _bytes = bytes;
    _hexData = file2hexstring(bytes);
    _hexDataLines = (_hexData?.length ?? 0) / _CHARS_PER_LINE;
  }

  @override
  Widget build(BuildContext context) {
    if (_hexData == null && widget.file != null) {
      _setData(widget.file!.bytes);
    }

    return Column(
      children: <Widget>[
        GCWOpenFile(
          onLoaded: (GCWFile? value) {
            _currentLines = 0;
            if (value == null) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
              return;
            }

            _setData(value.bytes);

            setState(() {});
          },
        ),
        GCWDefaultOutput(
            trailing: Row(
              children: [
                GCWIconButton(
                  icon: Icons.text_snippet_outlined,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    openInTextViewer(context, String.fromCharCodes(_bytes ?? []));
                  },
                ),
                GCWIconButton(
                  icon: Icons.copy,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    if (_hexData != null) insertIntoGCWClipboard(context, _hexData!);
                  },
                ),
              ],
            ),
            child: _buildOutput())
      ],
    );
  }

  void _resetScrollViews() {
    _scrollControllerASCII.jumpTo(0.0);
    _scrollControllerHex.jumpTo(0.0);
  }

  Widget _buildOutput() {
    if (_hexData == null || _hexDataLines == null) return Container();

    var hexStrStart = _currentLines * _CHARS_PER_LINE;
    var hexStrEnd = hexStrStart + _CHARS_PER_LINE * _MAX_LINES;
    var hexDataStr = _hexData!.substring(hexStrStart, min(hexStrEnd, _hexData!.length));
    var hexText = insertEveryNthCharacter(hexDataStr, _CHARS_PER_LINE, '\n');
    var hexTextList = hexText.split('\n').map((line) => insertSpaceEveryNthCharacter(line, 2) + ' ').toList();
    hexText = hexTextList.join('\n');

    var asciiText = hexTextList.map((line) {
      return line.split(' ').map((hexValue) {
        if (hexValue.isEmpty) return '';

        var charCode = int.tryParse(hexValue, radix: 16);
        if (charCode == null) return '';
        if (charCode < 32 || charCode == 127) return '.';
        // Bug in Text Widget which does not convert this manually for some reasons since a few Flutter versions.
        // Instead it adds a linebreak to the end... weird
        if (charCode == 133) return '…';

        return String.fromCharCode(charCode);
      }).join();
    }).join('\n');

    return Column(
      children: [
        if (_hexData!.length > _MAX_LINES)
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                GCWIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () {
                    setState(() {
                      _currentLines -= _MAX_LINES;
                      if (_currentLines < 0) {
                        _currentLines = (_hexDataLines!.floor() ~/ _MAX_LINES) * _MAX_LINES;
                      }

                      _resetScrollViews();
                    });
                  },
                ),
                Expanded(
                  child: GCWText(
                    text:
                        '${i18n(context, 'hexviewer_lines')}: ${_currentLines + 1} - ${min(_currentLines + _MAX_LINES, _hexDataLines?.ceil() as int)} / ${_hexDataLines?.ceil()}',
                    align: Alignment.center,
                  ),
                ),
                GCWIconButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    setState(() {
                      _currentLines += _MAX_LINES;
                      if (_currentLines > _hexDataLines!) {
                        _currentLines = 0;
                      }

                      _resetScrollViews();
                    });
                  },
                )
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              flex: 15,
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollControllerHex,
                  scrollDirection: Axis.horizontal,
                  child: GCWText(
                    text: hexText,
                    style: gcwMonotypeTextStyle(),
                  ),
                ),
                onNotification: (ScrollNotification scrollNotification) {
                  if (_isASCIIScrolling) return false;

                  if (scrollNotification is ScrollStartNotification) {
                    _isHexScrolling = true;
                  } else if (scrollNotification is ScrollEndNotification) {
                    _isHexScrolling = false;
                  } else if (scrollNotification is ScrollUpdateNotification) {
                    _scrollControllerASCII.position.jumpTo(_scrollControllerASCII.position.maxScrollExtent *
                        _scrollControllerHex.position.pixels /
                        _scrollControllerHex.position.maxScrollExtent);
                  }

                  return true;
                },
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 5,
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollControllerASCII,
                    scrollDirection: Axis.horizontal,
                    child: GCWText(
                      text: asciiText,
                      style: gcwMonotypeTextStyle(),
                    ),
                  ),
                  onNotification: (ScrollNotification scrollNotification) {
                    if (_isHexScrolling) return false;

                    if (scrollNotification is ScrollStartNotification) {
                      _isASCIIScrolling = true;
                    } else if (scrollNotification is ScrollEndNotification) {
                      _isASCIIScrolling = false;
                    } else if (scrollNotification is ScrollUpdateNotification) {
                      _scrollControllerHex.position.jumpTo(_scrollControllerHex.position.maxScrollExtent *
                          _scrollControllerASCII.position.pixels /
                          _scrollControllerASCII.position.maxScrollExtent);
                    }

                    return true;
                  },
                ))
          ],
        )
      ],
    );
  }
}

void openInHexViewer(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) =>
              GCWTool(tool: HexViewer(file: file), toolName: i18n(context, 'hexviewer_title'), id: 'hexviewer')));
}
