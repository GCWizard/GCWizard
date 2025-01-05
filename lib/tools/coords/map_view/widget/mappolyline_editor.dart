import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';

class MapPolylineEditor extends StatefulWidget {
  final GCWMapPolyline polyline;

  const MapPolylineEditor({Key? key, required this.polyline}) : super(key: key);

  @override
  _MapPolylineEditorState createState() => _MapPolylineEditorState();
}

class _LineAttributes {
  final String name;
  final String explanation;

  _LineAttributes({required this.name, required this.explanation});
}

class _MapPolylineEditorState extends State<MapPolylineEditor> {
  late HSVColor _currentColorPickerColor;
  late GCWMapLineType _currentLineType;

  Map<GCWMapLineType, _LineAttributes> _lineTypes = {};

  @override
  void initState() {
    super.initState();

    _currentColorPickerColor = HSVColor.fromColor(widget.polyline.color);
    _currentLineType = widget.polyline.type;
  }

  @override
  Widget build(BuildContext context) {
    if (_lineTypes.isEmpty) {
      _lineTypes = <GCWMapLineType, _LineAttributes>{
        GCWMapLineType.GEODETIC: _LineAttributes(
            name: i18n(context, 'coords_openmap_lineeditor_line_type_geodetic_title'),
            explanation: i18n(context, 'coords_openmap_lineeditor_line_type_geodetic_description')),
        GCWMapLineType.RHUMB: _LineAttributes(
            name: i18n(context, 'coords_openmap_lineeditor_line_type_rhumb_title'),
            explanation: i18n(context, 'coords_openmap_lineeditor_line_type_rhumb_description')),
      };
    }

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
      ),
      GCWTextDivider(
        text: i18n(context, 'coords_openmap_lineeditor_line_type'),
      ),
      GCWDropDown<GCWMapLineType>(
        value: _currentLineType,
        onChanged: (value) {
          setState(() {
            _currentLineType = value;
            widget.polyline.type = _currentLineType;
          });
        },
        items: _lineTypes.entries.map((item) {
          return GCWDropDownMenuItem(
            value: item.key,
            child: Column(
              children: [
                IgnorePointer(
                  child: GCWText(text: item.value.name),
                ),
                Container(
                  padding: const EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN),
                  child: IgnorePointer(
                    child: GCWText(
                      text: item.value.explanation,
                      style: gcwDescriptionTextStyle(),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      )
    ]);
  }
}
