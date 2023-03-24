import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

class GCWSymbolContainer extends StatefulWidget {
  final Image symbol;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showBackground;
  final bool showBorder;

  const GCWSymbolContainer(
      {Key? key,
      required this.symbol,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
      this.showBackground = true,
      this.showBorder = true})
      : super(key: key);

  @override
  _GCWSymbolContainerState createState() => _GCWSymbolContainerState();
}

class _GCWSymbolContainerState extends State<GCWSymbolContainer> {
  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;
    if (widget.showBackground) {
      backgroundColor = widget.backgroundColor ?? themeColors().iconImageBackground();
    }
    if (widget.showBorder) {
      borderColor = widget.borderColor ?? themeColors().mainFont();
    }

    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, border: Border.all(color: borderColor!, width: widget.borderWidth ?? 1.0)),
      padding: const EdgeInsets.all(2),
      child: widget.symbol,
    );
  }
}
