import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';

class GCWOutput extends StatefulWidget {
  final Object? child; // could be Widget or String
  final String? title;
  final bool suppressCopyButton;
  final String? copyText;
  final Widget? trailing;

  const GCWOutput(
      {Key? key, required this.child, this.title, this.suppressCopyButton = false, this.copyText, this.trailing})
      : super(key: key);

  @override
  _GCWOutputState createState() => _GCWOutputState();
}

class _GCWOutputState extends State<GCWOutput> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      widget.title != null && widget.title!.isNotEmpty
          ? GCWTextDivider(text: widget.title!, trailing: widget.trailing)
          : Container(),
      widget.child is Widget
          ? widget.child as Widget
          : GCWOutputText(
              text: widget.child == null ? '' : widget.child.toString(),
              suppressCopyButton: widget.suppressCopyButton,
              copyText: widget.copyText,
            )
    ]);
  }
}
