import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_text_export.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:gc_wizard/main.dart';

class GCWOutputText extends StatefulWidget {
  final String? text;
  final Alignment align;
  final bool isMonotype;
  final TextStyle? style;
  final bool suppressCopyButton;
  final String? copyText;

  const GCWOutputText(
      {Key? key,
      this.text,
      this.align = Alignment.centerLeft,
      this.isMonotype = false,
      this.style,
      this.suppressCopyButton = false,
      this.copyText})
      : super(key: key);

  @override
  _GCWOutputTextState createState() => _GCWOutputTextState();
}

class _GCWOutputTextState extends State<GCWOutputText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: //Align(
              //alignment: Alignment.centerLeft,
             SelectableText(
                widget.text ?? '',
                textAlign: TextAlign.left,
                style: widget.style ?? (widget.isMonotype ? gcwMonotypeTextStyle() : gcwTextStyle()),
                selectionControls: GCWTextSelectionControls(),
              )//),
        ),
        widget.text != null && widget.text!.isNotEmpty && !widget.suppressCopyButton
            ?
              Column(
                  children: [
                    GCWIconButton(
                      iconColor: widget.style != null ? widget.style!.color : themeColors().mainFont(),
                      size: IconButtonSize.SMALL,
                      icon: Icons.content_copy,
                      onPressed: () {
                        var copyText = widget.copyText != null ? widget.copyText.toString() : widget.text ?? '';
                        insertIntoGCWClipboard(context, copyText);
                      },
                    ),
                    GCWIconButton(
                        size: IconButtonSize.SMALL,
                        icon: widget.text!.length <= MAX_QR_TEXT_LENGTH_FOR_EXPORT ? Icons.qr_code : Icons.save,
                        onPressed: () async {
                          showGCWDialog(
                              context,
                              'Output',
                              GCWTextExport(
                                  text: widget.text!
                              ),
                              [GCWDialogButton(text: i18n(context, 'common_ok'))],
                              cancelButton: false);
                        }
                    )
                  ],
                )


            : Container()
      ],
    );
  }
}
