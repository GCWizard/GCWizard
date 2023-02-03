import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';

class GCWCoordsOutput extends StatefulWidget {
  final List<dynamic> outputs;
  final List<dynamic> copyTexts;
  List<GCWMapPoint> points;
  List<GCWMapPolyline> polylines;
  final bool mapButtonTop;
  final String title;

  GCWCoordsOutput(
      {Key key, this.outputs, this.copyTexts, this.points, this.polylines, this.mapButtonTop: false, this.title})
      : super(key: key) {
    if (points == null) this.points = [];
    if (polylines == null) this.polylines = [];
  }

  @override
  _GCWCoordsOutputState createState() => _GCWCoordsOutputState();
}

class _GCWCoordsOutputState extends State<GCWCoordsOutput> {
  @override
  Widget build(BuildContext context) {
    var children = widget.outputs
        .asMap()
        .map((index, output) {
          return MapEntry(
              index,
              Container(
                child: GCWOutput(
                  child: output,
                  copyText:
                      widget.copyTexts != null && widget.copyTexts.length > index ? widget.copyTexts[index] : null,
                ),
                padding: EdgeInsets.only(bottom: 15),
              ));
        })
        .values
        .toList();
    var _outputText = Column(
      children: children,
    );

    var _isNoOutput = widget.outputs == null || widget.outputs.length == 0 || widget.points.length == 0;
    var _button = Visibility(
        visible: !_isNoOutput,
        child: GCWToolBar(
          children: [
            GCWButton(
              text: i18n(context, 'coords_show_on_map'),
              onPressed: () {
                _openInMap();
              },
            ),
            GCWButton(
              text: i18n(context, 'coords_show_on_openmap'),
              onPressed: () {
                _openInMap(freeMap: true);
              },
            )
          ],
        ));

    var _children = widget.mapButtonTop ? [_button, _outputText] : [_outputText, _button];

    return GCWMultipleOutput(
        title: widget.title,
        children: _children,
        trailing: GCWIconButton(
          icon: Icons.save,
          size: IconButtonSize.SMALL,
          iconColor: _isNoOutput ? themeColors().inActive() : null,
          onPressed: () {
            _isNoOutput ? null : _exportCoordinates(context, widget.points, widget.polylines);
          },
        ));
  }

  _openInMap({freeMap: false}) {
    if (freeMap) {
      widget.points.forEach((point) {
        point.isEditable = true;
      });
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GCWTool(
                tool: GCWMapView(
                  points: List<GCWMapPoint>.from(widget.points),
                  polylines: List<GCWMapPolyline>.from(widget.polylines),
                  isEditable: freeMap,
                ),
                i18nPrefix: freeMap ? 'coords_openmap' : 'coords_map_view',
                autoScroll: false,
                suppressToolMargin: true)));
  }

  Future<bool> _exportCoordinates(
      BuildContext context, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) async {
    showCoordinatesExportDialog(context, points, polylines);
  }
}
