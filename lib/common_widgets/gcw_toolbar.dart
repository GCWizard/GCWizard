import 'package:flutter/material.dart';

class GCWToolBar extends StatefulWidget {
  final List<Widget> children;
  final List<int> flexValues;

  const GCWToolBar({Key key, this.children, this.flexValues}) : super(key: key);

  @override
  _GCWToolBarState createState() => _GCWToolBarState();
}

class _GCWToolBarState extends State<GCWToolBar> {
  @override
  Widget build(BuildContext context) {
    var children = widget.children.map((child) {
      return Expanded(
        child: Padding(
          child: child,
          padding: EdgeInsets.only(
            right: 2,
          ),
        ),
        flex: ((widget.flexValues == null) || (widget.children.length != widget.flexValues.length))
            ? 1
            : widget.flexValues[widget.children.indexOf(child)],
      );
    }).toList();

    return Row(children: children);
  }
}
