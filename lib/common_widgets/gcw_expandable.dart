import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';

class GCWExpandableTextDivider extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool expanded;
  final Widget? child;
  final Widget? trailing;
  final void Function(bool)? onChanged;
  final bool? suppressBottomSpace;
  final bool? suppressTopSpace;

  const GCWExpandableTextDivider(
      {super.key,
      this.text = '',
      this.expanded = true,
      this.style,
      this.child,
      this.trailing,
      this.onChanged,
      this.suppressBottomSpace,
      this.suppressTopSpace = true});

  @override
  _GCWExpandableTextDividerState createState() => _GCWExpandableTextDividerState();
}

class _GCWExpandableTextDividerState extends State<GCWExpandableTextDivider> {
  bool? _currentExpanded;
  Widget trailing = Container();
  
  void _toggleExpand() {
    setState(() {
      _currentExpanded = !_currentExpanded!;

      if (widget.onChanged != null) {
        widget.onChanged!(_currentExpanded!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentExpanded ??= widget.expanded;

    if (widget.trailing != null) trailing = widget.trailing!;
    return Column(
      children: [
        InkWell(
          child: GCWTextDivider(
            text: widget.text,
            suppressTopSpace: widget.suppressTopSpace,
            suppressBottomSpace: widget.suppressBottomSpace,
            style: widget.style,
            trailing: Row(
              children: <Widget>[
                trailing,
                GCWIconButton(
                  icon: _currentExpanded! ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: IconButtonSize.TINY,
                  onPressed: () => _toggleExpand(),
                )
              ],
            ),
          ),
          onTap: () => _toggleExpand(),
        ),
        if (_currentExpanded!)
          Container(
            child: widget.child,
          ),
      ],
    );
  }
}
