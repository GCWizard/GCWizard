import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/color_pickers/gcw_colorpicker.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';

double _DEFAULT_RADIUS = 161.0;

class MapPointEditor extends StatefulWidget {
  final GCWMapPoint mapPoint;
  Length lengthUnit;

  MapPointEditor({Key key, this.mapPoint, this.lengthUnit}) : super(key: key) {
    if (lengthUnit == null) lengthUnit = LENGTH_METER;
  }

  @override
  MapPointEditorState createState() => MapPointEditorState();
}

class MapPointEditorState extends State<MapPointEditor> {
  var _nameController;

  var _currentRadius = _DEFAULT_RADIUS;
  HSVColor _currentMarkerColorPickerColor;
  HSVColor _currentCircleColorPickerColor;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.mapPoint.markerText ?? '');

    if (widget.mapPoint.hasCircle()) {
      _currentRadius = widget.lengthUnit.fromMeter(widget.mapPoint.circle.radius);
    }

    _currentMarkerColorPickerColor = HSVColor.fromColor(widget.mapPoint.color);
    if (widget.mapPoint.hasCircle() && !widget.mapPoint.circleColorSameAsPointColor)
      _currentCircleColorPickerColor = HSVColor.fromColor(widget.mapPoint.circle.color);
    else
      _currentCircleColorPickerColor = HSVColor.fromColor(widget.mapPoint.color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GCWTextDivider(text: i18n(context, 'coords_openmap_pointeditor_point')),
      GCWTextField(
        hintText: i18n(context, 'coords_openmap_pointeditor_point_text'),
        controller: _nameController,
        onChanged: (text) {
          widget.mapPoint.markerText = text;
          widget.mapPoint.update();
        },
      ),
      GCWCoords(
        title: i18n(context, 'coords_openmap_pointeditor_point_coordinate'),
        coordinates: widget.mapPoint.point,
        coordsFormat: widget.mapPoint.coordinateFormat,
        restoreCoordinates: true,
        onChanged: (ret) {
          setState(() {
            widget.mapPoint.coordinateFormat = ret['coordsFormat'];
            widget.mapPoint.point = ret['value'];
          });
        },
      ),
      GCWTextDivider(text: i18n(context, 'coords_openmap_pointeditor_point_color')),
      Container(
        child: GCWColorPicker(
          hsvColor: _currentMarkerColorPickerColor,
          onChanged: (color) {
            setState(() {
              _currentMarkerColorPickerColor = color;
              widget.mapPoint.color = _currentMarkerColorPickerColor.toColor();
            });
          },
        ),
        padding: EdgeInsets.only(bottom: 20.0),
      ),
      GCWTextDivider(text: i18n(context, 'coords_openmap_pointeditor_circle')),
      GCWOnOffSwitch(
        title: i18n(context, 'coords_openmap_pointeditor_circle_hascircle'),
        value: widget.mapPoint.hasCircle(),
        onChanged: (value) {
          setState(() {
            if (value) {
              widget.mapPoint.circle = GCWMapCircle(
                radius: _currentRadius,
              );
            } else {
              widget.mapPoint.circle = null;
            }

            widget.mapPoint.update();
          });
        },
      ),
      widget.mapPoint.hasCircle()
          ? Column(
              children: [
                GCWDistance(
                  value: _currentRadius,
                  unit: widget.lengthUnit,
                  onChanged: (value) {
                    _currentRadius = value;
                    widget.mapPoint.circle.radius = _currentRadius;
                    widget.mapPoint.update();
                  },
                ),
                GCWOnOffSwitch(
                  title: i18n(context, 'coords_openmap_pointeditor_circle_samecolor'),
                  value: widget.mapPoint.circleColorSameAsPointColor,
                  onChanged: (value) {
                    setState(() {
                      widget.mapPoint.circleColorSameAsPointColor = value;
                      widget.mapPoint.update();
                    });
                  },
                ),
                widget.mapPoint.circleColorSameAsPointColor
                    ? Container()
                    : Container(
                        child: GCWColorPicker(
                          hsvColor: _currentCircleColorPickerColor,
                          onChanged: (color) {
                            setState(() {
                              _currentCircleColorPickerColor = color;
                              widget.mapPoint.circle.color = _currentCircleColorPickerColor.toColor();
                            });
                          },
                        ),
                        padding: EdgeInsets.only(bottom: 20.0),
                      ),
              ],
            )
          : Container(),
    ]);
  }
}
