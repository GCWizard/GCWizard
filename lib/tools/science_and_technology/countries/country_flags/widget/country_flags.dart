import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';

class CountriesFlags extends StatefulWidget {
  @override
  CountriesFlagsState createState() => CountriesFlagsState();
}

class CountriesFlagsState extends State<CountriesFlags> {
  var _ASSET_PATH = 'assets/symbol_tables/country_flags/country_flags.zip';
  var _KEY_PREFIX = 'common_country_';

  List<Map<String, SymbolData>> _images;
  String _currentImageKey;

  @override
  void initState() {
    super.initState();

    _initalizeImages();
  }

  _initalizeImages() async {
    // Read the Zip file from disk.
    final bytes = await DefaultAssetBundle.of(context).load(_ASSET_PATH);
    InputStream input = new InputStream(bytes.buffer.asByteData());
    // Decode the Zip file
    final archive = ZipDecoder().decodeBuffer(input);

    _images = archive.map((file) {
      var key = i18n(context, _KEY_PREFIX + file.name.split('.png')[0]);

      var data = file.content;

      return {key: new SymbolData(path: file.name, bytes: data)};
    }).toList();

    _images.sort((a, b) => a.keys.first.compareTo(b.keys.first));

    setState(() {
      _currentImageKey = _images.first.keys.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_images == null) return Container();

    return Column(
      children: [
        GCWDropDown(
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
          child:
              Image.memory(_images.firstWhere((element) => element.keys.first == _currentImageKey).values.first.bytes),
          padding: EdgeInsets.only(top: 20),
        ),
      ],
    );
  }
}
