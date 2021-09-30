import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_button.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';

class GCWTextViewer extends StatefulWidget {
  final String text;

  const GCWTextViewer({Key key, @required this.text}) : super(key: key);

  @override
  GCWTextViewerState createState() => GCWTextViewerState();
}

class GCWTextViewerState extends State<GCWTextViewer> {
  @override
  Widget build(BuildContext context) {
    var text = widget.text ?? '';

    return Column(
      children: [
        GCWButton(
          text: i18n(context, 'common_copy'),
          onPressed: () {
            if (widget.text == null || widget.text.isEmpty) return;

            insertIntoGCWClipboard(context, widget.text);
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: GCWText(
            text: text,
            style: gcwMonotypeTextStyle(),
          ),
        )
      ],
    );
  }
}

openInTextViewer(BuildContext context, String text) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
                tool: GCWTextViewer(text: text ?? ''),
                toolName: i18n(context, 'textviewer_title'),
                i18nPrefix: '',
                suppressHelpButton: true,
              )));
}
