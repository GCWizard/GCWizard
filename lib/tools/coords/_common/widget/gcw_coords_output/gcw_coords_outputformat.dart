import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_formatselector.dart';

class GCWCoordsOutputFormat extends StatefulWidget {
  final CoordinateFormat coordFormat;
  final void Function(CoordinateFormat) onChanged;

  const GCWCoordsOutputFormat({super.key, required this.coordFormat, required this.onChanged});

  @override
  _GCWCoordsOutputFormatState createState() => _GCWCoordsOutputFormatState();
}

class _GCWCoordsOutputFormatState extends State<GCWCoordsOutputFormat> {
  var _currentFormat = defaultCoordinateFormat;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTextDivider(
        text: i18n(context, 'coords_output_format'),
      ),
      GCWCoordsFormatSelector(
        format: widget.coordFormat,
        input: false,
        onChanged: (value) {
          setState(() {
            _currentFormat = value;
            widget.onChanged(_currentFormat);
          });
        },
      )
    ]);
  }
}
