import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/common/base/gcw_iconbutton/widget/gcw_iconbutton.dart';
import 'package:gc_wizard/tools/common/gcw_text_divider/widget/gcw_text_divider.dart';

class GCWExpandableTextDivider extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool expanded;
  final Widget child;
  final Function onChanged;

  const GCWExpandableTextDivider({Key key, this.text: '', this.expanded: true, this.style, this.child, this.onChanged})
      : super(key: key);

  @override
  _GCWExpandableTextDividerState createState() => _GCWExpandableTextDividerState();
}

class _GCWExpandableTextDividerState extends State<GCWExpandableTextDivider> {
  var _currentExpanded;

  _toggleExpand() {
    setState(() {
      _currentExpanded = !_currentExpanded;

      if (widget.onChanged != null) widget.onChanged(_currentExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentExpanded == null || widget.onChanged != null) _currentExpanded = widget.expanded;

    return Column(
      children: [
        InkWell(
          child: GCWTextDivider(
            text: widget.text,
            suppressTopSpace: true,
            style: widget.style,
            bottom: 0.0,
            trailing: GCWIconButton(
              icon: _currentExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: IconButtonSize.TINY,
              onPressed: () => _toggleExpand(),
            ),
          ),
          onTap: () => _toggleExpand(),
        ),
        if (_currentExpanded)
          Container(
            child: widget.child,
          ),
      ],
    );
  }
}
