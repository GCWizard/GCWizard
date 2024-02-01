import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_zoom_buttons.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer.dart';

class GCWSymbolTableSymbolMatrix extends StatefulWidget {
  final int countColumns;
  final MediaQueryData mediaQueryData;
  final Iterable<Map<String, SymbolData>> imageData;
  final bool selectable;
  final void Function() onChanged;
  final void Function(String, SymbolData) onSymbolTapped;
  final bool overlayOn;
  final String symbolKey;
  final bool fixed;
  final double scale;

  const GCWSymbolTableSymbolMatrix(
      {Key? key,
      required this.imageData,
      required this.countColumns,
      required this.mediaQueryData,
      required this.onChanged,
      this.selectable = false,
      required this.onSymbolTapped,
      this.fixed = false,
      this.overlayOn = true,
      this.symbolKey = '',
      this.scale = 1.0})
      : super(key: key);

  @override
  _GCWSymbolTableSymbolMatrixState createState() => _GCWSymbolTableSymbolMatrixState();
}

class _GCWSymbolTableSymbolMatrixState extends State<GCWSymbolTableSymbolMatrix> {
  late bool _currentShowOverlayedSymbols;
  late Iterable<Map<String, SymbolData>> _imageData;

  @override
  void initState() {
    super.initState();
    _currentShowOverlayedSymbols = widget.overlayOn;
  }

  @override
  Widget build(BuildContext context) {
    var _symbolTableSwitchPartWidth = (maxScreenWidth(context) - 40) / 3;
    var _decryptionSwitchWidth = (maxScreenWidth(context) - 40 - 57 - 20);
    var _decryptionSwitchPartWidth = (_symbolTableSwitchPartWidth / _decryptionSwitchWidth * 100).toInt();

    _imageData = widget.imageData;

    return Column(children: [
      Row(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: GCWOnOffSwitch(
                value: _currentShowOverlayedSymbols,
                title: i18n(context, 'symboltables_showoverlay'),
                flexValues: [
                  _decryptionSwitchPartWidth,
                  _decryptionSwitchPartWidth,
                  max(100 - 2 * _decryptionSwitchPartWidth, 0)
                ],
                onChanged: (value) {
                  setState(() {
                    _currentShowOverlayedSymbols = value;
                  });
                },
              )),
          widget.symbolKey.isEmpty
              ? Container(width: 20)
              : GCWIconButton(
                  icon: Icons.app_registration,
                  onPressed: () {
                    openInSymbolReplacer(context, widget.symbolKey);
                  }),
          Container(width: 15),
          GCWSymbolTableZoomButtons(
              countColumns: widget.countColumns, mediaQueryData: widget.mediaQueryData, onChanged: widget.onChanged)
        ],
      ),
      widget.fixed
          ? _buildDecryptionButtonMatrix(widget.countColumns, widget.selectable, widget.onSymbolTapped, widget.scale)
          : Expanded(
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  primary: true,
                  child: _buildDecryptionButtonMatrix(
                      widget.countColumns, widget.selectable, widget.onSymbolTapped, widget.scale)))
    ]);
  }

  String _showSpaceSymbolInOverlay(String text) {
    return text == ' ' ? String.fromCharCode(9251) : text;
  }

  Widget _buildDecryptionButtonMatrix(int countColumns, bool selectable, Function onSymbolTapped, double scale) {
    var rows = <Widget>[];
    var countRows = (_imageData.length / countColumns).floor();

    ThemeColors colors = themeColors();

    var symbolTexts = _imageData.map((element) => element.values.first.displayName ?? element.keys.first).toList();
    var images = _imageData.map((element) => element.values.first).toList();
    for (var i = 0; i <= countRows; i++) {
      var columns = <Widget>[];

      for (var j = 0; j < countColumns; j++) {
        Widget widget;
        var imageIndex = i * countColumns + j;

        if (imageIndex < _imageData.length) {
          var symbolText = symbolTexts[imageIndex];
          var image = images[imageIndex];

          widget = InkWell(
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                GCWSymbolContainer(
                  borderColor:
                      image.primarySelected ? colors.dialog() : (image.secondarySelected ? colors.focused() : null),
                  borderWidth: image.primarySelected || image.secondarySelected ? 5.0 : null,
                  symbol: Image.memory(image.bytes, scale: scale),
                ),
                _currentShowOverlayedSymbols
                    ? Opacity(
                        opacity: 0.85,
                        child: Container(
                          //TODO: Using GCWText instead: Currently it would expand the textfield width to max.
                          height: defaultFontSize() + 5,
                          decoration: ShapeDecoration(
                              color: colors.dialog(),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS)),
                              )),
                          //TODO: Using GCWText instead: Currently it would expand the textfield width to max.
                          child: AutoSizeText(
                            _showSpaceSymbolInOverlay(symbolText),
                            style: gcwTextStyle().copyWith(color: colors.dialogText(), fontWeight: FontWeight.bold),
                            maxLines: 2,
                            minFontSize: 9.0,
                          ),
                        ))
                    : Container()
              ],
            ),
            onTap: () {
              setState(() {
                if (selectable) {
                  image.primarySelected = !image.primarySelected;
                  image.secondarySelected = false;
                }

                onSymbolTapped(symbolText, image);
              });
            },
          );
        } else {
          widget = Container();
        }

        columns.add(Expanded(
            child: Container(
          padding: const EdgeInsets.all(3),
          child: widget,
        )));
      }

      rows.add(Row(
        children: columns,
      ));
    }

    return Column(
      children: rows,
    );
  }

  void openInSymbolReplacer(BuildContext context, String symbolKey) {
    Navigator.push(
        context,
        NoAnimationMaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: SymbolReplacer(symbolKey: symbolKey),
                toolName: i18n(context, 'symbol_replacer_title'),
                id: 'symbol_replacer')));
  }
}
