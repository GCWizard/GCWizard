import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class GCWCoordsPasteButton extends StatefulWidget {
  final void Function(List<BaseCoordinate>) onPasted;
  final IconButtonSize size;

  const GCWCoordsPasteButton({Key? key, required this.onPasted, required this.size}) : super(key: key);

  @override
  _GCWCoordsPasteButtonState createState() => _GCWCoordsPasteButtonState();
}

class _GCWCoordsPasteButtonState extends State<GCWCoordsPasteButton> {
  @override
  Widget build(BuildContext context) {
    return GCWPasteButton(
      iconSize: widget.size,
      onSelected: _parseClipboardAndSetCoords,
    );
  }

  void _parseClipboardAndSetCoords(String text) {
    List<BaseCoordinate> parsed = parseCoordinates(text);

    if (parsed.isEmpty) {
      showSnackBar(i18n(context, 'coords_common_clipboard_nocoordsfound'), context);
      widget.onPasted([]);
      return;
    } else if (parsed.length > 1) {
      var recognizedFormats = parsed.map((coords) {
        var text = '\r\n';
        var coordFormat = allCoordinateWidgetInfos.firstWhere((widgetInfo) => widgetInfo.type == coords.format.type);
        if (coordFormat is! GCWCoordWidgetWithSubtypeInfo) {
          text += coordFormat.name;
        } else {
          text += i18n(context, coordFormat.name);
        }
        return text;
      }).join();
      showSnackBar(i18n(context, 'coords_common_clipboard_recognizedcoordformats') + ':' + recognizedFormats, context);
    }

    widget.onPasted(parsed);
  }
}
