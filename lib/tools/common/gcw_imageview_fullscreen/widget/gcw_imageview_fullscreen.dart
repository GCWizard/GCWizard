import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/common/gcw_tool/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/utils/no_animation_material_page_route/widget/no_animation_material_page_route.dart';
import 'package:photo_view/photo_view.dart';

class GCWImageViewFullScreen extends StatefulWidget {
  final Uint8List imageData;

  const GCWImageViewFullScreen({Key key, @required this.imageData}) : super(key: key);

  @override
  GCWImageViewFullScreenState createState() => GCWImageViewFullScreenState();
}

class GCWImageViewFullScreenState extends State<GCWImageViewFullScreen> {
  ImageProvider image;

  @override
  void initState() {
    super.initState();

    image = MemoryImage(widget.imageData);
  }

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: image);
  }
}

openInFullScreen(BuildContext context, Uint8List imgData) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
                tool: GCWImageViewFullScreen(
                  imageData: imgData,
                ),
                autoScroll: false,
                toolName: i18n(context, 'imageview_fullscreen_title'),
                defaultLanguageToolName: i18n(context, 'imageview_fullscreen_title', useDefaultLanguage: true),
                suppressHelpButton: true,
              )));
}
