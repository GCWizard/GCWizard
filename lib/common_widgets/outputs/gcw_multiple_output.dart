import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';

class GCWMultipleOutput extends StatefulWidget {
  final List<dynamic> children;
  final bool suppressDefaultTitle;
  final Widget trailing;
  final Function onExportCoordinates;
  final String title;

  const GCWMultipleOutput(
      {Key key,
      @required this.children,
      this.suppressDefaultTitle: false,
      this.trailing,
      this.onExportCoordinates,
      this.title})
      : super(key: key);

  @override
  _GCWMultipleOutputState createState() => _GCWMultipleOutputState();
}

class _GCWMultipleOutputState extends State<GCWMultipleOutput> {
  @override
  Widget build(BuildContext context) {
    var children = widget.children.map((child) {
      if (child is Widget) return child;

      return GCWOutput(
        child: child.toString(),
      );
    }).toList();

    if (!widget.suppressDefaultTitle)
      children.insert(
          0, GCWTextDivider(text: this.widget.title ?? i18n(context, 'common_output'), trailing: widget.trailing));

    return Column(children: children);
  }
}
