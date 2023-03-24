import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:photo_view/photo_view.dart';

class GCWImageViewFullScreen extends StatefulWidget {
  final Uint8List imageData;

  const GCWImageViewFullScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  GCWImageViewFullScreenState createState() => GCWImageViewFullScreenState();
}

class GCWImageViewFullScreenState extends State<GCWImageViewFullScreen> {
  late ImageProvider image;

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

void openInFullScreen(BuildContext context, Uint8List imgData) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
                tool: GCWImageViewFullScreen(
                  imageData: imgData,
                ),
                autoScroll: false,
                toolName: i18n(context, 'imageview_fullscreen_title'),
                defaultLanguageToolName: i18n(context, 'imageview_fullscreen_title', useDefaultLanguage: true),
                suppressHelpButton: true,
                id: '',
              )));
}
