import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';

class GCWCoordsOutput extends StatefulWidget {
  final List<Object> outputs;
  late final List<GCWMapPoint> points;
  late final List<GCWMapPolyline> polylines;
  final bool? mapButtonTop;
  final String? title;
  late final Ellipsoid ellipsoid;

  GCWCoordsOutput(
      {Key? key,
      required this.outputs,
      List<GCWMapPoint>? points,
      List<GCWMapPolyline>? polylines,
      this.mapButtonTop = false,
      this.title,
      Ellipsoid? ellipsoid})
      : super(key: key) {
    this.points = points ?? [];
    this.polylines = polylines ?? [];
    this.ellipsoid = ellipsoid ?? defaultEllipsoid;
  }

  @override
  _GCWCoordsOutputState createState() => _GCWCoordsOutputState();
}

class _GCWCoordsOutputState extends State<GCWCoordsOutput> {
  @override
  Widget build(BuildContext context) {
    var children = widget.outputs
        .asMap()
        .map((int index, Object output) {
          return MapEntry(
              index,
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: GCWOutput(
                  child: output is BaseCoordinate ? formatCoordOutput(output.toLatLng()!, output.format, widget.ellipsoid) : output,
                  copyText: output is BaseCoordinate
                      ? formatCoordOutput(output.toLatLng()!, output.format, widget.ellipsoid, false).replaceAll('\n', ' ')
                      : ((output is String) || (output is int) || (output is double) ? output.toString() : null)
                ),
              ));
        })
        .values
        .toList();
    var _outputText = Column(
      children: children,
    );

    var _hasOutput = widget.outputs.isNotEmpty && widget.points.isNotEmpty;
    var _button = Visibility(
        visible: _hasOutput,
        child: GCWToolBar(
          children: [
            GCWButton(
              text: i18n(context, 'coords_show_on_map'),
              onPressed: () {
                openInMap(
                  context,
                  List<GCWMapPoint>.from(widget.points),
                  mapPolylines: List<GCWMapPolyline>.from(widget.polylines)
                );
              },
            ),
            GCWButton(
              text: i18n(context, 'coords_show_on_openmap'),
              onPressed: () {
                openInMap(
                  context,
                  List<GCWMapPoint>.from(widget.points),
                  isCommonMap: true,
                  mapPolylines: List<GCWMapPolyline>.from(widget.polylines)
                );
              },
            )
          ],
        ));

    var _children = widget.mapButtonTop! ? [_button, _outputText] : [_outputText, _button];

    return GCWMultipleOutput(
        title: widget.title,
        trailing: GCWIconButton(
          icon: Icons.save,
          size: IconButtonSize.SMALL,
          iconColor: _hasOutput ? null : themeColors().inActive(),
          onPressed: () {
            if (_hasOutput) {
              _exportCoordinates(context, widget.points, widget.polylines);
            }
          },
        ),
        children: _children);
  }

  Future<void> _exportCoordinates(
      BuildContext context, List<GCWMapPoint> points, List<GCWMapPolyline> polylines) async {
    showCoordinatesExportDialog(context, points, polylines);
  }
}
