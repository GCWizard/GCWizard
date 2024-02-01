import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output_utils.dart';

class PunchtapeSegmentDisplayOutput extends StatefulWidget {
  final bool upsideDownButton;
  final NSegmentDisplay Function(Map<String, bool>, bool, TeletypewriterCodebook) segmentFunction;
  final Segments segments;
  final bool readOnly;
  final Widget? trailing;
  final TeletypewriterCodebook codeBook;

  const PunchtapeSegmentDisplayOutput(
      {Key? key,
      this.upsideDownButton = false,
      required this.segmentFunction,
      required this.segments,
      required this.readOnly,
      this.trailing,
      required this.codeBook})
      : super(key: key);

  @override
  _PunchtapeSegmentDisplayOutputState createState() => _PunchtapeSegmentDisplayOutputState();
}

class _PunchtapeSegmentDisplayOutputState extends State<PunchtapeSegmentDisplayOutput> {
  var _currentUpsideDown = false;
  late List<NSegmentDisplay> _displays;

  @override
  void initState() {
    super.initState();

    _currentUpsideDown = widget.upsideDownButton;
  }

  @override
  Widget build(BuildContext context) {
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
                  await _buildPunchtapeSegmentDisplayImage(_displays, _currentUpsideDown).then((image) {
                    image.toByteData(format: ui.ImageByteFormat.png).then((data) {
                      _exportFile(context, data?.buffer.asUint8List());
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
      _buildDigitalOutput(widget.segments)
    ]);
  }

  Widget _buildDigitalOutput(Segments segments) {
    var list = _currentUpsideDown ? segments.displays.reversed : segments.displays;

    _displays = list.map((character) {
      var displayedSegments = {for (var e in character) e.toString(): true};
      return widget.segmentFunction(displayedSegments, widget.readOnly, widget.codeBook);
    }).toList();

    var viewList = !_currentUpsideDown
        ? _displays
        : _displays.map((display) {
            return Transform.rotate(angle: _currentUpsideDown ? pi : 0, child: display);
          }).toList();
    return _buildPunchtapeSegmentDisplayOutput(viewList);
  }
}
