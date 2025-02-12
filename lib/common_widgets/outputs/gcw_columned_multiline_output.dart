import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';

class GCWColumnedMultilineOutput extends StatefulWidget {
  //TODO: Is input data type correctly defined? Is there a better way than List<List<...>>? Own return type?
  // -> I found lists with different types (example -> blood_alcohol -> dynamic list)
  final List<List<Object?>> data;
  final List<int> flexValues;
  final int? copyColumn;
  final bool suppressCopyButtons;
  final bool hasHeader;
  final bool copyAll;
  final List<void Function()>? tappables;
  final TextStyle? style;
  final double fontSize;
  final List<Widget>? firstRows;
  final List<Widget>? lastRows;

  final int maxRowLimit;

  const GCWColumnedMultilineOutput({Key? key,
    required this.data,
    this.flexValues = const [],
    this.copyColumn,
    this.suppressCopyButtons = false,
    this.hasHeader = false,
    this.copyAll = false,
    this.tappables,
    this.style,
    this.fontSize = 0.0,
    this.firstRows,
    this.lastRows,

    this.maxRowLimit = 200}) // max loaded rows for Listview.builder
      : super(key: key);

  @override
  _GCWColumnedMultilineOutputState createState() => _GCWColumnedMultilineOutputState();
}

class _GCWColumnedMultilineOutputState extends State<GCWColumnedMultilineOutput> {
  late int _currentLimit = widget.maxRowLimit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _currentLimit = (_currentLimit + widget.maxRowLimit).clamp(0, widget.data.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFirstRows(),
        (widget.hasHeader) ? _buildHeader() : const SizedBox.shrink(),
        _buildListView(),
        _buildLastRows()
      ],
    );
  }

  Widget _buildListView() {
    bool hasMore = _currentLimit < widget.data.length;

    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 2),
      itemCount: _currentLimit + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => widget.tappables?[index + (widget.hasHeader ? 1 : 0)].call(),
          child: _buildRow(widget.hasHeader ? index + 1 : index),
        );
      },
    );
  }

  Widget _buildFirstRows() {
    if (widget.firstRows != null) {
      return Column(children: widget.firstRows!.map((firstWidget) => firstWidget).toList());
    }
    return const SizedBox.shrink();
  }

  Widget _buildLastRows() {
    if (widget.lastRows != null) {
      return Column(children: widget.lastRows!.map((firstWidget) => firstWidget).toList());
    }
    return const SizedBox.shrink();
  }

  Widget _buildHeader() {
    if (widget.data.isEmpty || widget.data.first.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<dynamic> rowData = widget.data.first;
    final String copytext = _getItemsAtPosition(widget.data, widget.copyColumn ?? rowData.length - 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: _buildRowEntries(rowData, 0, copytext, boldType: true),
    );
  }

  Widget _buildRow(int rowIdx) {
    if (rowIdx >= widget.data.length) return const SizedBox.shrink();

    List<dynamic> rowData = widget.data[rowIdx];
    String copyText = _getCopyText(rowData);
    var rowColor = rowIdx.isOdd ? themeColors().outputListOddRows() : themeColors().primaryBackground();

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(color: rowColor),
        child: _buildRowEntries(rowData, rowIdx, copyText)  // todo: Tap effect on tappables
    );
  }

  Widget _buildRowEntries(List<dynamic> rowData, int rowIdx, String copytext, {bool boldType = false}) {
    return Row(
        children: rowData.asMap().entries.map((entry) {
          var colIndex = entry.key;
          var value = entry.value;
          var isLastCol = colIndex == rowData.length - 1;

          return Expanded(
              flex: colIndex < widget.flexValues.length ? widget.flexValues[colIndex] : 1,
              child: _buildColumnElement(value, rowIdx, isLastCol, copytext, boldType: boldType));
        }).toList());
  }

  Widget _buildColumnElement(dynamic value, int rowIdx, bool isLastCol, String copytext, {bool boldType = false}) {
    Widget output;
    Widget button= const SizedBox.shrink();

    var isFirst = rowIdx == 0;
    var _text_style = widget.style ?? gcwTextStyle();
    _text_style = (boldType) ? _text_style.copyWith(fontWeight: FontWeight.bold) : _text_style;

    if (value is Widget) {
      output = Expanded(child: value);
    } else {
      output = Expanded(child: Text((value ?? '').toString(), style: _text_style));
    }

    if (isLastCol) {
      if (widget.copyAll && isFirst && widget.hasHeader) { // bigger copy all button in header row
        button = GCWIconButton(
          icon: Icons.content_copy,
          iconSize: 14,
          size: IconButtonSize.SMALL,
          onPressed: () {
            insertIntoGCWClipboard(context, copytext);
          },
        );
      } else if (!widget.suppressCopyButtons) {
        button = GCWIconButton(
          icon: Icons.content_copy,
          iconSize: 12,
          size: IconButtonSize.TINY,
          onPressed: () {
            insertIntoGCWClipboard(context, copytext);
          },
        );
      }
    }
    return Row(spacing:1, children: [output, button]);
  }

  String _getCopyText(List<dynamic> rowData) {
    if (widget.copyColumn != null && widget.copyColumn! < rowData.length) {
      return rowData[widget.copyColumn!].toString();
    }
    return rowData.isNotEmpty ? rowData.last.toString() : '';
  }

  String _getItemsAtPosition(List<List<Object?>> data, int copyColumn) {
    if (data.isEmpty || copyColumn < 0) return '';

    return data
        .where((innerList) => innerList.length > copyColumn)
        .map((innerList) => innerList[copyColumn]?.toString() ?? '')
        .join('\n');
  }
}
