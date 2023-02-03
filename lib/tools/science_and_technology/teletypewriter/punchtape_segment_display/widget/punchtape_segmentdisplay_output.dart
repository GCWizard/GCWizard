import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:intl/intl.dart';

part 'package:gc_wizard/tools/science_and_technology/teletypewriter/punchtape_segment_display/widget/punchtape_segmentdisplay_output_utils.dart';

class PunchtapeSegmentDisplayOutput extends StatefulWidget {
  final bool upsideDownButton;
  final NSegmentDisplay Function(Map<String, bool>, bool, TeletypewriterCodebook) segmentFunction;
  final List<List<String>> segments;
  final bool readOnly;
  final Widget trailing;
  final TeletypewriterCodebook codeBook;

  const PunchtapeSegmentDisplayOutput(
      {Key key,
      this.upsideDownButton: false,
      this.segmentFunction,
      this.segments,
      this.readOnly,
      this.trailing,
      this.codeBook})
      : super(key: key);

  @override
  _PunchtapeSegmentDisplayOutputState createState() => _PunchtapeSegmentDisplayOutputState();
}

class _PunchtapeSegmentDisplayOutputState extends State<PunchtapeSegmentDisplayOutput> {
  var _currentUpsideDown = false;
  List<NSegmentDisplay> _displays;

  @override
  void initState() {
    super.initState();

    _currentUpsideDown = widget.upsideDownButton;
  }

  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return Column(children: <Widget>[
      GCWTextDivider(
        text: i18n(context, 'segmentdisplay_displayoutput'),
        trailing: Row(
          children: <Widget>[
            widget.upsideDownButton
                ? Container(
                    child: GCWIconButton(
                      icon: Icons.rotate_left,
                      size: IconButtonSize.SMALL,
                      onPressed: () {
                        setState(() {
                          _currentUpsideDown = !_currentUpsideDown;
                        });
                      },
                    ),
                  )
                : Container(),
            Container(
              child: GCWIconButton(
                size: IconButtonSize.SMALL,
                icon: Icons.save,
                iconColor: (widget.segments == null) || (widget.segments.length == 0) ? themeColors().inActive() : null,
                onPressed: () async {
                  await _buildPunchtapeSegmentDisplayImage(_displays, _currentUpsideDown).then((image) {
                    if (image != null)
                      image.toByteData(format: ui.ImageByteFormat.png).then((data) {
                        _exportFile(context, data.buffer.asUint8List());
                      });
                  });
                },
              ),
              padding: EdgeInsets.only(right: 10.0),
            ),
          ],
        ),
      ),
      _buildDigitalOutput(widget.segments)
    ]);
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    var list = _currentUpsideDown ? segments.reversed : segments;

    _displays = list.where((character) => character != null).map((character) {
      var displayedSegments = Map<String, bool>.fromIterable(character, key: (e) => e, value: (e) => true);
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