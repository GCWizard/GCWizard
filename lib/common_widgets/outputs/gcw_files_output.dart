import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_soundplayer.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_textviewer.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/logic/hidden_data.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

class GCWFilesOutput extends StatefulWidget {
  final List<GCWFile> files;
  final bool suppressHiddenDataMessage;
  final Set<GCWImageViewButtons> suppressedButtons;

  const GCWFilesOutput({Key key, @required this.files, this.suppressHiddenDataMessage = false, this.suppressedButtons})
      : super(key: key);

  @override
  _GCWFilesOutputState createState() => _GCWFilesOutputState();
}

class _GCWFilesOutputState extends State<GCWFilesOutput> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[_buildFileTree(widget.files, [])]);
  }

  Widget _buildFileTree(List<GCWFile> files, List<String> parents, {level: 0}) {
    var isFirst = true;
    var children = files.map((GCWFile file) {
      var hasChildren = file.children != null && file.children.isNotEmpty;

      var actionButton = _buildActionButton(file);

      var text;
      if (file.fileClass == FileClass.TEXT) {
        text = String.fromCharCodes(file.bytes ?? []);
        if (text != null && text.length > 100) text = text.substring(0, 100) + '...';
      }

      var fileName = file.name;
      if (fileName != null) {
        if (fileName.startsWith(HIDDEN_FILE_IDENTIFIER)) {
          var index = fileName.split('_').last;
          var prefix;
          if (index == '0') {
            prefix = i18n(context, 'hiddendata_source');
          } else {
            prefix = i18n(context, 'hiddendata_hidden') + ' $index';
          }

          fileName = '$prefix: ' + file.fileType.toString().split('.').last;
        }
      } else
        fileName = '';

      var parentsString = parents.join(' → ');
      var newParents = List<String>.from(parents);
      newParents.add(fileName);

      var out = Column(
        children: [
          Row(
            children: [
              Container(
                  child: actionButton == null ? Container() : actionButton,
                  width: 42,
                  padding: EdgeInsets.only(right: 10)),
              Expanded(
                child: Container(
                    child: Column(
                      children: [
                        if (parents.isNotEmpty)
                          GCWText(
                              text: parentsString,
                              style: gcwTextStyle()
                                  .copyWith(fontSize: fontSizeSmall(), color: themeColors().dialogText())),
                        Row(
                          children: [
                            Expanded(
                              child: GCWText(
                                  text: fileName,
                                  style: gcwTextStyle()
                                      .copyWith(fontWeight: FontWeight.bold, color: themeColors().dialogText())),
                            ),
                            GCWText(
                                text: file.bytes == null ? '??? Bytes' : '${file.bytes.length} Bytes',
                                style: gcwTextStyle()
                                    .copyWith(color: themeColors().dialogText(), fontSize: defaultFontSize() - 2))
                          ],
                        )
                      ],
                    ),
                    color: themeColors().accent(),
                    padding: EdgeInsets.all(DOUBLE_DEFAULT_MARGIN)),
              ),
            ],
          ),
          if (file.fileClass == FileClass.IMAGE)
            Container(
                child: GCWImageView(
                  imageData: GCWImageViewData(file),
                  suppressedButtons: widget.suppressedButtons,
                ),
                margin: EdgeInsets.only(left: 42)),
          if (file.fileClass == FileClass.TEXT)
            Container(child: GCWText(style: gcwMonotypeTextStyle(), text: text), margin: EdgeInsets.only(left: 42)),
          if (file.fileClass == FileClass.SOUND)
            Container(child: GCWSoundPlayer(file: file), margin: EdgeInsets.only(left: 42)),
          if (hasChildren)
            Container(
              child: _buildFileTree(file.children, newParents, level: level + 1),
            ),
          if (level == 0 && isFirst) GCWDivider(),
          if (!widget.suppressHiddenDataMessage)
            if (files.length <= 1 && level == 0 && !hasChildren)
              GCWText(text: i18n(context, 'hiddendata_nohiddendatafound'))
        ],
      );

      isFirst = false;

      return out;
    }).toList();

    return Column(
      children: children,
    );
  }

  _buildActionButton(GCWFile file) {
    var actions = <GCWPopupMenuItem>[
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.save, 'hiddendata_savefile'),
        action: (index) => setState(() {
          _exportFile(context, file);
        }),
      ),
      GCWPopupMenuItem(
        child: iconedGCWPopupMenuItem(context, Icons.text_snippet_outlined, 'hexviewer_openinhexviewer'),
        action: (index) => setState(() {
          if (file.bytes == null) {
            showToast(i18n(context, 'hiddendata_datanotreadable'));
            return;
          }
          openInHexViewer(context, file);
        }),
      ),
      if (file.fileClass == FileClass.TEXT)
        GCWPopupMenuItem(
          child: iconedGCWPopupMenuItem(context, Icons.text_snippet_outlined, 'textviewer_openintextviewer'),
          action: (index) => setState(() {
            if (file.bytes == null) {
              showToast(i18n(context, 'hiddendata_datanotreadable'));
              return;
            }
            openInTextViewer(context, String.fromCharCodes(file.bytes));
          }),
        ),
    ];

    return GCWPopupMenu(
      iconData: Icons.open_in_new,
      size: IconButtonSize.SMALL,
      menuItemBuilder: (context) => actions,
    );
  }

  _exportFile(BuildContext context, GCWFile file) async {
    if (file.bytes == null) {
      showToast(i18n(context, 'hiddendata_datanotreadable'));
      return;
    }

    var fileName = file.name.replaceFirst(HIDDEN_FILE_IDENTIFIER, 'hidden_file');
    var ext = file.name.split('.');

    if (ext.length <= 1 || ext.last.length >= 5) fileName = fileName + '.' + fileExtension(file.fileType);

    var value = await saveByteDataToFile(context, file.bytes, fileName);
    if (value != null) showExportedFileDialog(context, fileType: file.fileType);
  }
}
