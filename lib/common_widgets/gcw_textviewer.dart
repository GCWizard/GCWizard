import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWTextViewer extends StatefulWidget {
  final String text;

  const GCWTextViewer({super.key, required this.text});

  @override
  _GCWTextViewerState createState() => _GCWTextViewerState();
}

class _GCWTextViewerState extends State<GCWTextViewer> {
  @override
  Widget build(BuildContext context) {
    var text = widget.text;

    return Column(
      children: [
        GCWButton(
          text: i18n(context, 'common_copy'),
          onPressed: () {
            if (widget.text.isEmpty) return;

            insertIntoGCWClipboard(context, widget.text);
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: GCWText(
            text: text,
            style: gcwMonotypeTextStyle(),
          ),
        )
      ],
    );
  }
}

void openInTextViewer(BuildContext context, String text) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
                tool: GCWTextViewer(text: text),
                toolName: i18n(context, 'textviewer_title'),
                id: 'textviewer',
                suppressHelpButton: true,
              )));
}
