import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

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
  final double fontSize;
  final List<Widget>? firstRows;

  const GCWColumnedMultilineOutput(
      {Key? key,
        required this.data,
        this.flexValues = const [],
        this.copyColumn,
        this.suppressCopyButtons = false,
        this.hasHeader = false,
        this.copyAll = false,
        this.tappables,
        this.fontSize = 0.0,
        this.firstRows})
      : super(key: key);

  @override
  _GCWColumnedMultilineOutputState createState() => _GCWColumnedMultilineOutputState();
}

class _GCWColumnedMultilineOutputState extends State<GCWColumnedMultilineOutput> {
  @override
  Widget build(BuildContext context) {

    var rows = _columnedMultiLineOutputRows();
    if (widget.firstRows != null) rows.insertAll(0, widget.firstRows!);

    return Column(
      children: rows
    );
  }


  List<Widget> _columnedMultiLineOutputRows() {
    var odd = true;
    var isFirst = true;
    var copyColumn = widget.copyColumn;

    int index = 0;
    return widget.data.map((rowData) {
      Widget output;

      var columns = rowData
          .asMap()
          .map((index, column) {
            var textStyle = gcwTextStyle(fontSize: widget.fontSize);
            if (isFirst && widget.hasHeader) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

            Widget child;

            if (column is Widget) {
              child = column;
            } else {
              if (widget.tappables == null || widget.tappables!.isEmpty) {
                child = GCWText(text: column != null ? column.toString() : '', style: textStyle);
              } else {
                child = Text(column != null ? column.toString() : '', style: textStyle);
              }
            }

            return MapEntry(index, Expanded(flex: index < widget.flexValues.length ? widget.flexValues[index] : 1, child: child));
          })
          .values
          .toList();

      String? copyText;
      copyColumn ??= rowData.length - 1;
      if (copyColumn != null && copyColumn! >= 0) {
        copyText = rowData[copyColumn!] is Widget ? null : rowData[copyColumn!].toString();
        if (isFirst && widget.hasHeader && widget.copyAll) {
          copyText = '';
          widget.data.skip(1).forEach((dataRow) {
            copyText = (copyText ?? '') + dataRow[copyColumn!].toString() + '\n';
          });
        }
      }

      var row = Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          children: [
            Expanded(
              child: Row(children: columns),
            ),
            copyText == null || copyText!.isEmpty
                ? Container(width: 21.0)
                : Container(
                    child: (((isFirst && widget.hasHeader) & !widget.copyAll) || widget.suppressCopyButtons)
                        ? Container()
                        : GCWIconButton(
                            icon: Icons.content_copy,
                            iconSize: 14,
                            size: IconButtonSize.TINY,
                            onPressed: () {
                              insertIntoGCWClipboard(context, copyText!);
                            },
                  )     ,
            )
          ],
        ),
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
          onTap: widget.tappables![index++],
          child: output,
        );
      } else {
        return output;
      }
    }).toList();
  }
}
