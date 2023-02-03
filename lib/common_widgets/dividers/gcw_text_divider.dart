import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';

class GCWTextDivider extends StatefulWidget {
  final String text;
  final Widget trailing;
  final bottom;
  final TextStyle style;
  final bool suppressTopSpace;
  final bool suppressBottomSpace;

  const GCWTextDivider(
      {Key key, this.text: '', this.trailing, this.bottom, this.style, this.suppressTopSpace, this.suppressBottomSpace})
      : super(key: key);

  @override
  _GCWTextDividerState createState() => _GCWTextDividerState();
}

class _GCWTextDividerState extends State<GCWTextDivider> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minDividerWidth = 100.0;

    return Container(
        margin: EdgeInsets.only(
            top: (widget.suppressTopSpace ?? false ? 0.0 : 25.0),
            bottom: (widget.suppressBottomSpace ?? false ? 0.0 : 10.0)),
        child: Row(children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth - minDividerWidth),
            child: Text(widget.text != '' ? '${widget.text}:' : '', style: widget.style ?? gcwTextStyle()),
          ),
          Expanded(child: GCWDivider(color: widget.style?.color ?? gcwTextStyle().color)),
          widget.trailing ?? Container()
        ]));
  }
}
