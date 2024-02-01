import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_symbol_matrix.dart';

class GCWSymbolTableDecryption extends StatefulWidget {
  final int countColumns;
  final MediaQueryData mediaQueryData;
  final SymbolTableData data;
  final void Function() onChanged;
  final String? Function(String)? onAfterDecrypt;

  const GCWSymbolTableDecryption(
      {Key? key,
      required this.data,
      required this.countColumns,
      required this.mediaQueryData,
      required this.onChanged,
      required this.onAfterDecrypt})
      : super(key: key);

  @override
  _GCWSymbolTableDecryptionState createState() => _GCWSymbolTableDecryptionState();
}

class _GCWSymbolTableDecryptionState extends State<GCWSymbolTableDecryption> {
  String _decryptionOutput = '';

  late SymbolTableData _data;

  late ScrollController _scrollController;

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

  void _scrollToBottom() {
    _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    _data = widget.data;

    return Column(
      children: <Widget>[
        Expanded(
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
          constraints: BoxConstraints(maxHeight: widget.mediaQueryData.orientation == Orientation.portrait ? 350 : 150),
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
                      if (_decryptionOutput.isNotEmpty) {
                        _decryptionOutput = _decryptionOutput.substring(0, _decryptionOutput.length - 1);
                      }
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
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: widget.onAfterDecrypt != null
                    ? Column(
                        children: [
                          GCWOutput(title: i18n(context, 'common_input'), child: _decryptionOutput),
                          GCWDefaultOutput(child: widget.onAfterDecrypt!(_decryptionOutput))
                        ],
                      )
                    : GCWDefaultOutput(child: _decryptionOutput),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
