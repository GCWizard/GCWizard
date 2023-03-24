import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

class GCWDivider extends StatelessWidget {
  final Color? color;

  const GCWDivider({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(color: color ?? themeColors().mainFont(), indent: 15, endIndent: 15);
  }
}
