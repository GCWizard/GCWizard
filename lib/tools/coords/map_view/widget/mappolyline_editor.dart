import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class MapPolylineEditor extends StatefulWidget {
  final GCWMapPolyline polyline;

  const MapPolylineEditor({Key? key, required this.polyline}) : super(key: key);

  @override
  MapPolylineEditorState createState() => MapPolylineEditorState();
}

class MapPolylineEditorState extends State<MapPolylineEditor> {
  late HSVColor _currentColorPickerColor;

  @override
  void initState() {
    super.initState();

    _currentColorPickerColor = HSVColor.fromColor(widget.polyline.color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GCWTextDivider(text: i18n(context, 'coords_openmap_lineeditor_line_color')),
      Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GCWColorPicker(
          hsvColor: _currentColorPickerColor,
          onChanged: (color) {
            setState(() {
              _currentColorPickerColor = color;
              widget.polyline.color = _currentColorPickerColor.toColor();
            });
          },
        ),
      )
    ]);
  }
}
