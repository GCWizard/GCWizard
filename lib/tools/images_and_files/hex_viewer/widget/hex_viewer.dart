import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textviewer.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class HexViewer extends StatefulWidget {
  final GCWFile platformFile;

  const HexViewer({Key key, this.platformFile}) : super(key: key);

  @override
  HexViewerState createState() => HexViewerState();
}

class HexViewerState extends State<HexViewer> {
  ScrollController _scrollControllerHex;
  ScrollController _scrollControllerASCII;

  String _hexData;
  double _hexDataLines;
  Uint8List _bytes;

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

  _setData(Uint8List bytes) {
    _bytes = bytes;
    _hexData = file2hexstring(bytes);
    _hexDataLines = _hexData.length / _CHARS_PER_LINE;
  }

  @override
  Widget build(BuildContext context) {
    if (_hexData == null && widget.platformFile != null) {
      _setData(widget.platformFile.bytes);
    }

    return Column(
      children: <Widget>[
        GCWOpenFile(
          onLoaded: (_file) {
            _currentLines = 0;
            if (_file == null) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }

            if (_file != null) {
              _setData(_file.bytes);

              setState(() {});
            }
          },
        ),
        GCWDefaultOutput(
            child: _buildOutput(),
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
                    insertIntoGCWClipboard(context, _hexData);
                  },
                ),
              ],
            ))
      ],
    );
  }

  _resetScrollViews() {
    _scrollControllerASCII.jumpTo(0.0);
    _scrollControllerHex.jumpTo(0.0);
  }

  _buildOutput() {
    if (_hexData == null) return null;

    var hexStrStart = _currentLines * _CHARS_PER_LINE;
    var hexStrEnd = hexStrStart + _CHARS_PER_LINE * _MAX_LINES;
    var hexDataStr = _hexData.substring(hexStrStart, min(hexStrEnd, _hexData.length));
    var hexText = insertEveryNthCharacter(hexDataStr, _CHARS_PER_LINE, '\n');
    var hexTextList = hexText.split('\n').map((line) => insertSpaceEveryNthCharacter(line, 2) + ' ').toList();
    hexText = hexTextList.join('\n');

    var asciiText = hexTextList.map((line) {
      return line.split(' ').map((hexValue) {
        if (hexValue == null || hexValue.isEmpty) return '';

        var charCode = int.tryParse(hexValue, radix: 16);
        if (charCode < 32) return '.';

        return String.fromCharCode(charCode);
      }).join();
    }).join('\n');

    return Column(
      children: [
        if (_hexData.length > _MAX_LINES)
          Container(
            child: Row(
              children: [
                GCWIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () {
                    setState(() {
                      _currentLines -= _MAX_LINES;
                      if (_currentLines < 0) {
                        _currentLines = (_hexDataLines.floor() ~/ _MAX_LINES) * _MAX_LINES;
                      }

                      _resetScrollViews();
                    });
                  },
                ),
                Expanded(
                  child: GCWText(
                    text:
                        '${i18n(context, 'hexviewer_lines')}: ${_currentLines + 1} - ${min(_currentLines + _MAX_LINES, _hexDataLines.ceil())} / ${_hexDataLines.ceil()}',
                    align: Alignment.center,
                  ),
                ),
                GCWIconButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: () {
                    setState(() {
                      _currentLines += _MAX_LINES;
                      if (_currentLines > _hexDataLines) {
                        _currentLines = 0;
                      }

                      _resetScrollViews();
                    });
                  },
                )
              ],
            ),
            padding: EdgeInsets.only(bottom: 10),
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
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
              flex: 15,
            ),
            Expanded(child: Container(), flex: 1),
            Expanded(
                child: Container(
                  child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
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
                  ),
                ),
                flex: 5)
          ],
        )
      ],
    );
  }
}

openInHexViewer(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
              tool: HexViewer(platformFile: file), toolName: i18n(context, 'hexviewer_title'), i18nPrefix: '')));
}
