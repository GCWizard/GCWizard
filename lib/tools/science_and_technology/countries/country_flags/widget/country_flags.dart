import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

class CountriesFlags extends StatefulWidget {
  const CountriesFlags({Key? key}) : super(key: key);

  @override
  _CountriesFlagsState createState() => _CountriesFlagsState();
}

class _CountriesFlagsState extends State<CountriesFlags> {
  final _ASSET_PATH = 'lib/tools/symbol_tables/_common/assets/country_flags/country_flags.zip';
  final _KEY_PREFIX = 'common_country_';

  List<Map<String, SymbolData>> _images = [];
  String _currentImageKey = '';

  @override
  void initState() {
    super.initState();

    _initalizeImages();
  }

  void _initalizeImages() async {
    // Read the Zip file from disk.
    final bytes = await DefaultAssetBundle.of(context).load(_ASSET_PATH);
    InputStream input = InputStream(bytes.buffer.asByteData());
    // Decode the Zip file
    final archive = ZipDecoder().decodeBuffer(input);

    _images = archive.map((file) {
      var key = i18n(context, _KEY_PREFIX + file.name.split('.png')[0]);

      var data = toUint8ListOrNull(file.content) ?? Uint8List(0);

      return {key: SymbolData(path: file.name, bytes: data)};
    }).toList();

    _images.sort((a, b) => a.keys.first.compareTo(b.keys.first));

    setState(() {
      _currentImageKey = _images.first.keys.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GCWDropDown<String>(
          value: _currentImageKey,
          items: _images.map((image) {
            return GCWDropDownMenuItem(value: image.keys.first, child: image.keys.first);
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _currentImageKey = newValue;
            });
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          child:
              Image.memory(_images.firstWhere((element) => element.keys.first == _currentImageKey).values.first.bytes),
        ),
      ],
    );
  }
}
