import 'package:flutter/material.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';

class GCWOutput extends StatefulWidget {
  final dynamic child; // could be Widget or String
  final String title;
  final bool suppressCopyButton;
  final String copyText;

  const GCWOutput({Key key, @required this.child, this.title, this.suppressCopyButton: false, this.copyText})
      : super(key: key);

  @override
  _GCWOutputState createState() => _GCWOutputState();
}

class _GCWOutputState extends State<GCWOutput> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      widget.title != null && widget.title.length > 0 ? GCWTextDivider(text: widget.title) : Container(),
      widget.child is Widget
          ? widget.child
          : GCWOutputText(
              text: widget.child.toString(),
              suppressCopyButton: widget.suppressCopyButton,
              copyText: widget.copyText,
            )
    ]);
  }
}
