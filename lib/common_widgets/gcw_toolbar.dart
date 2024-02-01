import 'package:flutter/material.dart';

class GCWToolBar extends StatefulWidget {
  final List<Widget> children;
  final List<int> flexValues;

  const GCWToolBar({Key? key, required this.children, this.flexValues = const []}) : super(key: key);

  @override
  _GCWToolBarState createState() => _GCWToolBarState();
}

class _GCWToolBarState extends State<GCWToolBar> {
  @override
  Widget build(BuildContext context) {
    var children = widget.children.map((child) {
      return Expanded(
        flex: ((widget.flexValues.isEmpty) || (widget.children.length != widget.flexValues.length))
            ? 1
            : widget.flexValues[widget.children.indexOf(child)],
        child: Padding(
          padding: const EdgeInsets.only(
            right: 2,
          ),
          child: child,
        ),
      );
    }).toList();

    return Row(children: children);
  }
}
