import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

class GCWDivider extends StatefulWidget {
  final Color? color;
  final Widget? trailing;
  final bool? suppressTopSpace;
  final bool? suppressBottomSpace;

  const GCWDivider({super.key, this.color, this.trailing, this.suppressTopSpace, this.suppressBottomSpace});

  @override
  _GCWDividerState createState() => _GCWDividerState();
}

class _GCWDividerState extends State<GCWDivider> {
  @override
  Widget build(BuildContext context) {
    //return Divider(color: color ?? themeColors().mainFont(), indent: 15, endIndent: 15);
    return Container(
        margin: EdgeInsets.only(
            top: (widget.suppressTopSpace ?? false ? 0.0 : 25.0),
            bottom: (widget.suppressBottomSpace ?? false ? 0.0 : 10.0)),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: widget.color ?? themeColors().mainFont(), indent: 15, endIndent: 15)),
          widget.trailing ?? Container()
        ]));
  }
}
