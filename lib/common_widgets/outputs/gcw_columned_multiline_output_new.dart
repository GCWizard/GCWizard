import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:image/image.dart';

import '../../application/i18n/logic/app_localizations.dart';
import 'gcw_output_text.dart';

class GCWColumnedMultilineOutputNew extends StatefulWidget {
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
  final int maxRowLimit;

  const GCWColumnedMultilineOutputNew({Key? key,
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
    this.maxRowLimit = 500})
      : super(key: key);

  @override
  _GCWColumnedMultilineOutputNewState createState() => _GCWColumnedMultilineOutputNewState();
}

class _GCWColumnedMultilineOutputNewState extends State<GCWColumnedMultilineOutputNew> {
  late final int columns = widget.data.isNotEmpty ? widget.data[0].length : 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(5),
        itemCount: widget.data.length,
        itemBuilder: (context, i) {
          return _buildRow(i);
        }
    );
  }

  Widget _buildRow(int rowIdx) {
    if (rowIdx >= widget.data.length) return const SizedBox.shrink();

    List<dynamic> rowData = widget.data[rowIdx]; // Die Zeile als Liste holen
    String copytext = (widget.copyColumn != null && widget.copyColumn! < rowData.length)
        ? rowData[widget.copyColumn!].toString()
        : rowData[rowData.length-1].toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: rowIdx.isOdd ? themeColors().outputListOddRows() : themeColors().primaryBackground(),
      ),
      child: Row(
        children: rowData.asMap().entries.map((entry) {
          var colIndex = entry.key;
          var value = entry.value.toString();
          var isLastCol = colIndex == rowData.length - 1;

          return Expanded(
              flex: colIndex < widget.flexValues.length ? widget
                  .flexValues[colIndex] : 1, // Standardflex = 1
              child: _outText(value, rowIdx, isLastCol, copytext)
          );
        }).toList(),
      ),
    );
  }

  Widget _outText(String value, int rowIdx, bool isLastCol, String copytext) {
    var _text_style = widget.style;
    if (widget.hasHeader && rowIdx == 0) {
      return GCWText(
          text: value,
          style: _text_style?.copyWith(fontWeight: FontWeight.bold));
    }
    if (isLastCol) {
      return GCWOutputText(
        text: value,
        style: _text_style,
        suppressCopyButton: widget.suppressCopyButtons,
        copyText: copytext);
    }
    return GCWText(text: value, style: _text_style);
  }
}

//   var rows = _columnedMultiLineOutputRows();
//   if (widget.firstRows != null) rows.insertAll(0, widget.firstRows!);
//
//   return Column(children: rows);
// }

// List<Widget> _columnedMultiLineOutputRows() {
//   bool odd = true;
//   bool isFirst = true;
//   var copyColumn = widget.copyColumn;
//
//   int itemCount = widget.data.length;
//   if (itemCount > widget.maxRowLimit) {
//     String tableText = widget.data.map((row) => row.join('\t')).join('\n'); // Spalten durch | trennen
//     return [
//       GCWOutputText(
//         text: i18n(context, 'common_count') + ': $itemCount - Too large to display. Press Copy to get a tab separated list!',
//         copyText: tableText,
//       )
//     ];
//   }
//
//   int index = 0;
//   return widget.data.map((rowData) {
//     Widget output;
//     var textStyle = widget.style ?? gcwTextStyle(fontSize: widget.fontSize);
//
//     var columns = rowData
//         .asMap()
//         .map((index, column) {
//           var _textStyle = textStyle;
//           if (isFirst && widget.hasHeader) _textStyle = _textStyle.copyWith(fontWeight: FontWeight.bold);
//
//           Widget child;
//
//           if (column is Widget) {
//             child = column;
//           } else {
//             if (widget.tappables == null || widget.tappables!.isEmpty) {
//               child = GCWText(text: column != null ? column.toString() : '', style: _textStyle);
//             } else {
//               child = Text(column != null ? column.toString() : '', style: _textStyle);
//             }
//           }
//
//           return MapEntry(
//               index, Expanded(flex: index < widget.flexValues.length ? widget.flexValues[index] : 1, child: child));
//         })
//         .values
//         .toList();
//
//     String? copyText;
//     copyColumn ??= rowData.length - 1;
//     if (copyColumn != null && copyColumn! >= 0) {
//       copyText = rowData[copyColumn!] is Widget ? null : rowData[copyColumn!].toString();
//       if (isFirst && widget.hasHeader && widget.copyAll) {
//         copyText = '';
//         widget.data.skip(1).forEach((dataRow) {
//           copyText = (copyText ?? '') + dataRow[copyColumn!].toString() + '\n';
//         });
//       }
//     }
//
//     var row = Container(
//       margin: const EdgeInsets.only(top: 6, bottom: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Row(children: columns),
//           ),
//           copyText == null || copyText!.isEmpty
//               ? Container(width: 21.0)
//               : Container(
//                   child: (((isFirst && widget.hasHeader) & !widget.copyAll) || widget.suppressCopyButtons)
//                       ? Container()
//                       : GCWIconButton(
//                           icon: Icons.content_copy,
//                           iconSize: 14,
//                           size: IconButtonSize.TINY,
//                           onPressed: () {
//                             insertIntoGCWClipboard(context, copyText!);
//                           },
//                         ),
//                 )
//         ],
//       ),
//     );
//
//     if (odd) {
//       output = Container(color: themeColors().outputListOddRows(), child: row);
//     } else {
//       output = Container(child: row);
//     }
//     odd = !odd;
//
//     isFirst = false;
//     if (widget.tappables != null) {
//       return InkWell(
//         onTap: widget.tappables![index++],
//         child: output,
//       );
//     } else {
//       return output;
//     }
//   }).toList();
// }
