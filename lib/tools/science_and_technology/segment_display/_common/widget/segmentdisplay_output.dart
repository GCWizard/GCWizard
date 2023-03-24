import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:prefs/prefs.dart';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segment_display_utils.dart';

class SegmentDisplayOutput extends StatefulWidget {
  final bool upsideDownButton;
  final NSegmentDisplay Function(Map<String, bool>, bool) segmentFunction;
  final Segments segments;
  final bool readOnly;
  final Widget? trailing;
  final bool showZoomButtons;
  final double? verticalSymbolPadding;
  final double? horizontalSymbolPadding;

  const SegmentDisplayOutput(
      {Key? key,
      this.upsideDownButton = false,
      required this.segmentFunction,
      required this.segments,
      required this.readOnly,
      this.trailing,
      this.showZoomButtons = true,
      this.verticalSymbolPadding,
      this.horizontalSymbolPadding})
      : super(key: key);

  @override
  _SegmentDisplayOutputState createState() => _SegmentDisplayOutputState();
}

class _SegmentDisplayOutputState extends State<SegmentDisplayOutput> {
  var _currentUpsideDown = false;
  List<NSegmentDisplay> _displays = [];

  @override
  void initState() {
    super.initState();

    _currentUpsideDown = widget.upsideDownButton;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    return Column(children: <Widget>[
      GCWTextDivider(
        text: i18n(context, 'segmentdisplay_displayoutput'),
        trailing: Row(
          children: <Widget>[
            widget.upsideDownButton
                ? GCWIconButton(
                  icon: Icons.rotate_left,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    setState(() {
                      _currentUpsideDown = !_currentUpsideDown;
                    });
                  },
                )
                : Container(),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.save,
                iconColor: (widget.segments.displays.isEmpty) ? themeColors().inActive() : null,
                onPressed: () async {
                  await buildSegmentDisplayImage(countColumns, _displays, _currentUpsideDown,
                          horizontalPadding: widget.horizontalSymbolPadding,
                          verticalPadding: widget.verticalSymbolPadding)
                      .then((image) {

                    image.toByteData(format: ui.ImageByteFormat.png).then((data) {
                      _exportFile(context, data?.buffer.asUint8List());
                    });
                  });
                },
              ),
            ),
            if (widget.showZoomButtons)
              GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.zoom_in,
                onPressed: () {
                  setState(() {
                    int newCountColumn = max(countColumns - 1, 1);
                    mediaQueryData.orientation == Orientation.portrait
                        ? Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT, newCountColumn)
                        : Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE, newCountColumn);
                  });
                },
              ),
            if (widget.showZoomButtons)
              GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.zoom_out,
                onPressed: () {
                  setState(() {
                    int newCountColumn = countColumns + 1;
                    mediaQueryData.orientation == Orientation.portrait
                        ? Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT, newCountColumn)
                        : Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE, newCountColumn);
                  });
                },
              ),
          ],
        ),
      ),
      _buildDigitalOutput(countColumns, widget.segments)
    ]);
  }

  Widget _buildDigitalOutput(int countColumns, Segments segments) {
    var segmentsList = _currentUpsideDown ? Segments(displays: segments.displays.reversed.toList()) : segments;

    _displays = segmentsList.displays.map((character) {
      var displayedSegments = { for (var e in character) e.toString() : true };
      return widget.segmentFunction(displayedSegments, widget.readOnly);
    }).toList();

    var viewList = !_currentUpsideDown
        ? _displays
        : _displays.map((display) {
            return Transform.rotate(angle: _currentUpsideDown ? pi : 0, child: display);
          }).toList();
    return _buildSegmentDisplayOutput(countColumns, viewList,
        verticalPadding: widget.verticalSymbolPadding, horizontalPadding: widget.horizontalSymbolPadding);
  }
}