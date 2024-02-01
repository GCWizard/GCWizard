import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/logic/iau_constellation.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

class IAUSingleConstellation extends StatefulWidget {
  final String ConstellationName;

  const IAUSingleConstellation({Key? key, required this.ConstellationName}) : super(key: key);

  @override
  IAUSingleConstellationState createState() => IAUSingleConstellationState();
}

class IAUSingleConstellationState extends State<IAUSingleConstellation> {
  final String _ASSET_PATH =
      'lib/tools/science_and_technology/astronomy/iau_constellation/assets/iau_constellation.zip';

  List<Map<String, SymbolData>> _images = [];

  @override
  void initState() {
    super.initState();

    _initalizeImages();
  }

  Future<ui.Image> _initializeImage(Uint8List bytes) async {
    return decodeImageFromList(bytes);
  }

  Future<void> _initalizeImages() async {
    // Read the Zip file from disk.
    final bytes = await DefaultAssetBundle.of(context).load(_ASSET_PATH);
    InputStream input = InputStream(bytes.buffer.asByteData());
    // Decode the Zip file
    final archive = ZipDecoder().decodeBuffer(input);

    _images = [];
    for (ArchiveFile file in archive) {
      var key = file.name.split('.png')[0];

      var imagePath = (file.isFile && SymbolTableConstants.IMAGE_SUFFIXES.hasMatch(file.name)) ? file.name : null;
      if (imagePath == null) continue;

      var data = toUint8ListOrNull(file.content);
      if (data != null) {
        var standardImage = await _initializeImage(data);
        ui.Image? specialEncryptionImage;

        _images.add({
          key: SymbolData(
              path: imagePath,
              bytes: data,
              standardImage: standardImage,
              specialEncryptionImage: specialEncryptionImage)
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int constellationIndex =
        allConstellations.indexWhere((constellation) => constellation.ConstellationName == widget.ConstellationName);

    List<List<Object>> data = [];

    data.add([i18n(context, 'iau_constellation_iauname'), allConstellations[constellationIndex].ConstellationName]);
    data.add([i18n(context, 'iau_constellation_name'), i18n(context, allConstellations[constellationIndex].name)]);
    data.add([i18n(context, 'iau_constellation_iau'), allConstellations[constellationIndex].IAU]);
    data.add([i18n(context, 'iau_constellation_nasa'), allConstellations[constellationIndex].NASA]);
    data.add([i18n(context, 'iau_constellation_position'), allConstellations[constellationIndex].position]);
    data.add([i18n(context, 'iau_constellation_visibility'), allConstellations[constellationIndex].visibility]);
    data.add([i18n(context, 'iau_constellation_area'), allConstellations[constellationIndex].area]);
    data.add([i18n(context, 'iau_constellation_star'), allConstellations[constellationIndex].Star]);
    data.add([i18n(context, 'iau_constellation_magnitudo'), allConstellations[constellationIndex].magnitudo]);

    return Column(children: <Widget>[
      GCWColumnedMultilineOutput(data: data, flexValues: const [3, 2], copyColumn: 1),
      _images.isEmpty
          ? Container()
          : Container(
              padding: const EdgeInsets.only(top: 20),
              child: Image.memory(_images[constellationIndex].values.first.bytes),
            ),
    ]);
  }
}
