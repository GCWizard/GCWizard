import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:photo_view/photo_view.dart';

class GCWImageViewFullScreen extends StatefulWidget {
  final Uint8List imageData;
  final Color bgColor;

  const GCWImageViewFullScreen({Key? key, required this.imageData, required this.bgColor}) : super(key: key);

  @override
  _GCWImageViewFullScreenState createState() => _GCWImageViewFullScreenState();
}

class _GCWImageViewFullScreenState extends State<GCWImageViewFullScreen> {
  late ImageProvider image;
  late Color _bgColor;

  @override
  void initState() {
    super.initState();

    image = MemoryImage(widget.imageData);
    _bgColor = widget.bgColor;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        PhotoView(
          imageProvider: image,
          backgroundDecoration: BoxDecoration(color: _bgColor),
        ),
        GCWPopupMenu(
            icon: Icons.color_lens,
            size: IconButtonSize.SMALL,
            backgroundColor: themeColors().dialog(),
            iconColor: themeColors().dialogText(),
            menuItemBuilder: (context) => [
              GCWPopupMenuItem(
                  child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_black'),
                      color: Colors.black
                  ),
                  action: (index) => setState(() {
                    _bgColor = Colors.black;
                  })
              ),
              GCWPopupMenuItem(
                  child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_white'),
                      color: Colors.white
                  ),
                  action: (index) => setState(() {
                    _bgColor = Colors.white;
                  })
              ),
              GCWPopupMenuItem(
                  child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_pink'),
                      color: Colors.purpleAccent
                  ),
                  action: (index) => setState(() {
                    _bgColor = Colors.purpleAccent;
                  })
              ),
              GCWPopupMenuItem(
                  child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_blue'),
                      color: Colors.indigo
                  ),
                  action: (index) => setState(() {
                    _bgColor = Colors.indigo;
                  })
              ),
              GCWPopupMenuItem(
                  child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_green'),
                      color: Colors.lightGreen
                  ),
                  action: (index) => setState(() {
                    _bgColor = Colors.lightGreen;
                  })
              ),
            ]
        )
      ],
    );

  }
}

void openInFullScreen(BuildContext context, Uint8List imgData, Color bgColor) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
                tool: GCWImageViewFullScreen(
                  imageData: imgData,
                  bgColor: bgColor,
                ),
                autoScroll: false,
                toolName: i18n(context, 'imageview_fullscreen_title'),
                defaultLanguageToolName: i18n(context, 'imageview_fullscreen_title', useDefaultLanguage: true),
                suppressHelpButton: true,
                id: '',
              )));
}
