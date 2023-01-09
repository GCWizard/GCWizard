import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class GCWColumnedMultilineOutput extends StatefulWidget {
  final List<List<dynamic>> data;
  final List<int> flexValues;
  final int copyColumn;
  final bool suppressCopyButtons;
  final bool hasHeader;
  final bool copyAll;
  final List<Function> tappables;
  final double fontSize;
  final List<Widget> firstRows;

  const GCWColumnedMultilineOutput(
      {Key key,
        @required this.data,
        this.flexValues = const [],
        this.copyColumn,
        this.suppressCopyButtons: false,
        this.hasHeader: false,
        this.copyAll: false,
        this.tappables,
        this.fontSize,
        this.firstRows})
      : super(key: key);

  @override
  _GCWColumnedMultilineOutputState createState() => _GCWColumnedMultilineOutputState();
}

class _GCWColumnedMultilineOutputState extends State<GCWColumnedMultilineOutput> {
  @override
  Widget build(BuildContext context) {

    var rows = _columnedMultiLineOutputRows();
    if (widget.firstRows != null) rows.insertAll(0, widget.firstRows);

    return Column(
      children: rows
    );
  }


  List<Widget> _columnedMultiLineOutputRows() {
    var odd = true;
    var isFirst = true;
    var copyColumn = widget.copyColumn;

    int index = 0;
    return widget.data.where((row) => row != null).map((rowData) {
      Widget output;

      var columns = rowData
          .asMap()
          .map((index, column) {
            var textStyle = gcwTextStyle(fontSize: widget.fontSize);
            if (isFirst && widget.hasHeader) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

            var child;

            if (column is Widget) {
              child = column;
            } else {
              if (widget.tappables == null || widget.tappables.isEmpty) {
                child = GCWText(text: column != null ? column.toString() : '', style: textStyle);
              } else {
                child = Text(column != null ? column.toString() : '', style: textStyle);
              }
            }

            return MapEntry(index, Expanded(child: child, flex: index < widget.flexValues.length ? widget.flexValues[index] : 1));
          })
          .values
          .toList();

      if (copyColumn == null) copyColumn = rowData.length - 1;
      var copyText = rowData[copyColumn] is Widget ? null : rowData[copyColumn].toString();
      if (isFirst && widget.hasHeader && widget.copyAll) {
        copyText = '';
        widget.data.where((row) => row != null).skip(1).forEach((dataRow) {
          copyText += dataRow[copyColumn].toString() + '\n';
        });
      }

      var row = Container(
        child: Row(
          children: [
            Expanded(
              child: Row(children: columns),
            ),
            context == null || copyText == null || copyText.length == 0
                ? Container(width: 21.0)
                : Container(
                    child: (((isFirst && widget.hasHeader) & !widget.copyAll) || widget.suppressCopyButtons)
                        ? Container()
                        : GCWIconButton(
                            icon: Icons.content_copy,
                            iconSize: 14,
                            size: IconButtonSize.TINY,
                            onPressed: () {
                              insertIntoGCWClipboard(context, copyText);
                            },
                  )     ,
            )
          ],
        ),
        margin: EdgeInsets.only(top: 6, bottom: 6),
      );

      if (odd) {
        output = Container(color: themeColors().outputListOddRows(), child: row);
      } else {
        output = Container(child: row);
      }
      odd = !odd;

      isFirst = false;

      if (widget.tappables != null) {
        return InkWell(
          child: output,
          onTap: widget.tappables[index++],
        );
      } else {
        return output;
      }
    }).toList();
  }
}
