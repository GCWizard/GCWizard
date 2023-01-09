import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_toolbar.dart';
import 'package:gc_wizard/widgets/tools/symbol_tables/gcw_symbol_table_symbol_matrix.dart';
import 'package:gc_wizard/widgets/tools/symbol_tables/symbol_table_data.dart';

class GCWSymbolTableDecryption extends StatefulWidget {
  final int countColumns;
  final MediaQueryData mediaQueryData;
  final SymbolTableData data;
  final Function onChanged;
  final Function onAfterDecrypt;

  const GCWSymbolTableDecryption(
      {Key key, this.data, this.countColumns, this.mediaQueryData, this.onChanged, this.onAfterDecrypt})
      : super(key: key);

  @override
  GCWSymbolTableDecryptionState createState() => GCWSymbolTableDecryptionState();
}

class GCWSymbolTableDecryptionState extends State<GCWSymbolTableDecryption> {
  String _decryptionOutput = '';

  SymbolTableData _data;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scrollToBottom() {
    _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    _data = widget.data;

    return Column(
      children: <Widget>[
        (widget.data == null)
            ? Container()
            : Expanded(
                child: GCWSymbolTableSymbolMatrix(
                imageData: _data.images,
                symbolKey: _data.symbolKey,
                countColumns: widget.countColumns,
                mediaQueryData: widget.mediaQueryData,
                onChanged: widget.onChanged,
                onSymbolTapped: (String tappedText, SymbolData imageData) {
                  setState(() {
                    _decryptionOutput += tappedText;
                    _scrollToBottom();
                  });
                },
              )),
        ConstrainedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GCWToolBar(children: [
                GCWIconButton(
                  icon: Icons.space_bar,
                  onPressed: () {
                    setState(() {
                      _decryptionOutput += ' ';
                      _scrollToBottom();
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.backspace,
                  onPressed: () {
                    setState(() {
                      if (_decryptionOutput.length > 0)
                        _decryptionOutput = _decryptionOutput.substring(0, _decryptionOutput.length - 1);
                      _scrollToBottom();
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.clear,
                  onPressed: () {
                    setState(() {
                      _decryptionOutput = '';
                      _scrollToBottom();
                    });
                  },
                )
              ]),
              Flexible(
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: widget.onAfterDecrypt != null
                    ? Column(
                        children: [
                          GCWOutput(title: i18n(context, 'common_input'), child: _decryptionOutput),
                          GCWDefaultOutput(child: widget.onAfterDecrypt(_decryptionOutput))
                        ],
                      )
                    : GCWDefaultOutput(child: _decryptionOutput),
              ))
            ],
          ),
          constraints: BoxConstraints(maxHeight: widget.mediaQueryData.orientation == Orientation.portrait ? 350 : 150),
        ),
      ],
    );
  }
}
