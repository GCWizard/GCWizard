import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';

class GCWText extends StatefulWidget {
  final String text;
  final Alignment align;
  final TextAlign? textAlign;
  final TextStyle? style;

  const GCWText({Key? key, this.text = '', this.align = Alignment.centerLeft, this.textAlign, this.style}) : super(key: key);

  @override
  _GCWTextState createState() => _GCWTextState();
}

class _GCWTextState extends State<GCWText> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: widget.align,
        child: SelectableText(
          widget.text,
          textAlign: widget.textAlign,
          style: widget.style ?? gcwTextStyle(),
          selectionControls: GCWTextSelectionControls(),
        ));
  }
}
