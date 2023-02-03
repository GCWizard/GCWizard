import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_colorhoney/widget/symbol_table_encryption_colorhoney.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_colortokki/widget/symbol_table_encryption_colortokki.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_paint_data/widget/symbol_table_encryption_paint_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_puzzlecode/widget/symbol_table_encryption_puzzlecode.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_stipplecode/widget/symbol_table_encryption_stipplecode.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_tenctonese/widget/symbol_table_encryption_tenctonese.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:intl/intl.dart';

class GCWSymbolTableTextToSymbols extends StatefulWidget {
  final String text;
  final bool ignoreUnknown;
  final int countColumns;
  final SymbolTableData data;
  final bool showExportButton;
  final bool fixed;
  final double borderWidth;
  final bool specialEncryption;

  const GCWSymbolTableTextToSymbols(
      {Key key,
      this.text,
      this.ignoreUnknown,
      this.data,
      this.countColumns,
      this.showExportButton: true,
      this.borderWidth,
      this.specialEncryption,
      this.fixed: false})
      : super(key: key);

  @override
  GCWSymbolTableTextToSymbolsState createState() => GCWSymbolTableTextToSymbolsState();
}

class GCWSymbolTableTextToSymbolsState extends State<GCWSymbolTableTextToSymbols> {
  var _alphabetMap = <String, int>{};

  var _encryptionHasImages = false;

  SymbolTableData _data;

  @override
  void initState() {
    super.initState();

    _data = widget.data;
    _data.images.forEach((element) {
      _alphabetMap.putIfAbsent(element.keys.first, () => _data.images.indexOf(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.fixed
            ? _buildEncryptionOutput(widget.countColumns)
            : Expanded(child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                primary: true,
                child: _buildEncryptionOutput(widget.countColumns)
              )),
        widget.showExportButton && _encryptionHasImages
            ? GCWButton(
                text: i18n(context, 'common_exportfile_saveoutput'),
                onPressed: () {
                  _exportEncryption(widget.countColumns, _data.isCaseSensitive()).then((value) {
                    if (value == null) {
                      return;
                    }

                    showExportedFileDialog(
                      context,
                      contentWidget: Container(
                        child: Image.memory(value),
                        margin: EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(border: Border.all(color: themeColors().dialogText())),
                      ),
                    );
                  });
                },
              )
            : Container()
      ],
    );
  }

  List<int> _getImageIndexes(bool isCaseSensitive) {
    var _text = widget.text;
    var imageIndexes = <int>[];

    while (_text.length > 0) {
      var imageIndex;
      int i;
      String chunk;
      for (i = min(_data.maxSymbolTextLength, _text.length); i > 0; i--) {
        chunk = _text.substring(0, i);

        if (isCaseSensitive) {
          if (_alphabetMap.containsKey(chunk)) {
            imageIndex = _alphabetMap[chunk];
            break;
          }
        } else {
          if (_alphabetMap.containsKey(chunk.toUpperCase())) {
            imageIndex = _alphabetMap[chunk.toUpperCase()];
            break;
          }
        }
      }

      if ((widget.ignoreUnknown && imageIndex != null) || !widget.ignoreUnknown) imageIndexes.add(imageIndex);

      if (imageIndex == null)
        _text = _text.substring(1, _text.length);
      else
        _text = _text.substring(i, _text.length);
    }

    return imageIndexes;
  }

  Widget _buildEncryptionOutput(countColumns) {
    if (_data == null) return Container();

    var isCaseSensitive = _data.isCaseSensitive();

    var imageIndexes = _getImageIndexes(isCaseSensitive);
    _encryptionHasImages = imageIndexes.length > 0;
    if (!_encryptionHasImages) return Container();

    var sizes = _symbolTableEncryption().sizes(SymbolTableEncryptionSizes(
      mode: SymbolTableEncryptionMode.FIXED_CANVASWIDTH,
      countImages: imageIndexes.length,
      countColumns: countColumns,
      symbolWidth: _data.imageSize().width,
      symbolHeight: _data.imageSize().height,
      relativeBorderWidth: widget.borderWidth,
      canvasWidth: MediaQuery.of(context).size.width * 0.95,
    ));

    return Container(
      width: sizes.canvasWidth,
      height: sizes.canvasHeight,
      child: CustomPaint(
          size: Size(sizes.canvasWidth, sizes.canvasHeight),
          painter: SymbolTableEncryptionPainter(
              paintData: SymbolTablePaintData(
                sizes: sizes,
                data: _data,
                imageIndexes: imageIndexes,
              ),
              encryption: _symbolTableEncryption())),
    );
  }

  SymbolTableEncryption _symbolTableEncryption() {
    if (!widget.specialEncryption) return SymbolTableEncryption();

    switch (_data.symbolKey) {
      case 'color_honey':
        return ColorHoneySymbolTableEncryption();
      case 'color_tokki':
        return ColorTokkiSymbolTableEncryption();
      case 'puzzle':
        return PuzzleSymbolTableEncryption();
      case 'stippelcode':
        return StippleSymbolTableEncryption();
      case 'tenctonese_cursive':
        return TenctoneseSymbolTableEncryption();
      default:
        return SymbolTableEncryption();
    }
  }

  Future<Uint8List> _exportEncryption(int countColumns, isCaseSensitive) async {
    var imageIndexes = _getImageIndexes(isCaseSensitive);

    var countRows = (imageIndexes.length / countColumns).floor();
    if (countRows * countColumns < imageIndexes.length) countRows++;

    final canvasRecorder = ui.PictureRecorder();
    var canvas = Canvas(canvasRecorder);

    var sizes = _symbolTableEncryption().sizes(SymbolTableEncryptionSizes(
        mode: SymbolTableEncryptionMode.FIXED_SYMBOLSIZE,
        symbolWidth: _data.imageSize().width,
        symbolHeight: _data.imageSize().height,
        countImages: imageIndexes.length,
        countColumns: countColumns,
        relativeBorderWidth: widget.borderWidth));

    var paintData = SymbolTablePaintData(canvas: canvas, sizes: sizes, data: _data, imageIndexes: imageIndexes);

    canvas = _symbolTableEncryption().paint(paintData);

    final img = await canvasRecorder.endRecording().toImage(sizes.canvasWidth.floor(), sizes.canvasHeight.floor());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return await saveByteDataToFile(context, trimNullBytes(data.buffer.asUint8List()),
        'img_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.png');
  }
}
