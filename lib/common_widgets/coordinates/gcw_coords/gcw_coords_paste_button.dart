import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';

class GCWCoordsPasteButton extends StatefulWidget {
  final Function onPasted;
  final IconButtonSize size;
  final Widget customIcon;
  final Color backgroundColor;

  const GCWCoordsPasteButton({Key key, this.onPasted, this.size, this.backgroundColor, this.customIcon})
      : super(key: key);

  @override
  _GCWCoordsPasteButtonState createState() => _GCWCoordsPasteButtonState();
}

class _GCWCoordsPasteButtonState extends State<GCWCoordsPasteButton> {
  @override
  Widget build(BuildContext context) {
    return GCWPasteButton(
      iconSize: widget.size,
      customIcon: widget.customIcon,
      backgroundColor: widget.backgroundColor,
      onSelected: _parseClipboardAndSetCoords,
    );
  }

  _parseClipboardAndSetCoords(text) {
    var parsed = parseCoordinates(text);

    if (parsed == null || parsed.length == 0) {
      showToast(i18n(context, 'coords_common_clipboard_nocoordsfound'));
      widget.onPasted(null);
      return;
    } else if (parsed.length > 1) {
      var recognizedformates = parsed.map((coords) {
        var text = '\r\n';
        var coordFormat = allCoordFormats.firstWhere((format) => format.key == coords.key);
        if (coordFormat.subtypes == null)
          text += coordFormat.name;
        else
          text += i18n(context, coordFormat.name);
        return text;
      }).join();
      showToast(i18n(context, 'coords_common_clipboard_recognizedcoordformats') + ':' + recognizedformates);
    }

    widget.onPasted(parsed);
  }
}
