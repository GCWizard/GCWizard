import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

part 'package:gc_wizard/common_widgets/color_pickers/external_libs/fluttercandies.flutter_hsvcolor_picker/hsv_picker.dart';

class GCWColorPicker extends StatefulWidget {
  final void Function(HSVColor) onChanged;
  final HSVColor hsvColor;

  const GCWColorPicker({Key? key, required this.hsvColor, required this.onChanged}) : super(key: key);

  @override
  GCWColorPickerState createState() => GCWColorPickerState();
}

class GCWColorPickerState extends State<GCWColorPicker> {
  late HSVColor _currentColor;

  @override
  Widget build(BuildContext context) {
    _currentColor = widget.hsvColor;

    return Row(
      children: [
        Container(
          height: 100,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(color: themeColors().mainFont(), width: 1),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(3 * ROUNDED_BORDER_RADIUS)),
            color: _currentColor.toColor(),
          ),
          margin: const EdgeInsets.only(right: 7 * DEFAULT_MARGIN),
        ),
        Expanded(
            child: _HSVPicker(
          color: _currentColor,
          onChanged: widget.onChanged,
        )),
      ],
    );
  }
}
