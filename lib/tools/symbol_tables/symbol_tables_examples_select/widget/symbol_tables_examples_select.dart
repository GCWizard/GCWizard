import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_table_symbol_matrix.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_tables_examples_select/widget/symbol_tables_examples.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:prefs/prefs.dart';

const _LOGO_NAME = 'logo.png';
const _ALERT_COUNT_SELECTIONS = 50;

class SymbolTableExamplesSelect extends StatefulWidget {
  const SymbolTableExamplesSelect({Key? key}) : super(key: key);

  @override
  _SymbolTableExamplesSelectState createState() => _SymbolTableExamplesSelectState();
}

class _SymbolTableExamplesSelectState extends State<SymbolTableExamplesSelect> {
  List<Map<String, SymbolData>> images = [];
  List<String> selectedSymbolTables = [];

  @override
  void initState() {
    super.initState();

    _initializeImages();
  }

  String _pathKey() {
    return SYMBOLTABLES_ASSETPATH;
  }

  String _symbolKey(String path) {
    var regex = RegExp(SYMBOLTABLES_ASSETPATH + r'(.*)/' + _LOGO_NAME);

    var matches = regex.allMatches(path);
    return matches.first.group(1) ?? '';
  }

  Future<void> _initializeImages() async {
    //AssetManifest.json holds the information about all asset files
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final manifestMap = asJsonMapOrNull(json.decode(manifestContent));

    final imagePaths = manifestMap == null
        ? <String>[]
        : manifestMap.keys.where((String key) => key.contains(_pathKey()) && key.contains(_LOGO_NAME)).toList();

    if (imagePaths.isEmpty) return;

    for (String imagePath in imagePaths) {
      final data = await DefaultAssetBundle.of(context).load(imagePath);
      var key = _symbolKey(imagePath);

      images.add({
        key: SymbolData(
            path: imagePath, bytes: data.buffer.asUint8List(), displayName: i18n(context, 'symboltables_${key}_title'))
      });
    }

    images.sort((a, b) {
      if (a.values.first.displayName == null || b.values.first.displayName == null) return 0;
      return a.values.first.displayName!.compareTo(b.values.first.displayName!);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return Container();

    final mediaQueryData = MediaQuery.of(context);
    var countColumns = mediaQueryData.orientation == Orientation.portrait
        ? Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT)
        : Prefs.getInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE);

    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, 'symboltablesexamples_selecttables'),
          suppressTopSpace: true,
        ),
        Row(
          children: [
            Expanded(
                child: GCWButton(
              text: i18n(context, 'symboltablesexamples_selectall'),
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              onPressed: () {
                setState(() {
                  for (var image in images) {
                    var data = image.values.first;
                    data.primarySelected = true;
                    selectedSymbolTables.add(_symbolKey(data.path));
                  }
                });
              },
            )),
            Container(width: DOUBLE_DEFAULT_MARGIN),
            Expanded(
                child: GCWButton(
              text: i18n(context, 'symboltablesexamples_deselectall'),
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              onPressed: () {
                setState(() {
                  for (var image in images) {
                    var data = image.values.first;
                    data.primarySelected = false;
                    selectedSymbolTables = <String>[];
                  }
                });
              },
            )),
          ],
        ),
        Expanded(
            child: GCWSymbolTableSymbolMatrix(
          imageData: images,
          countColumns: countColumns,
          mediaQueryData: mediaQueryData,
          onChanged: () => setState(() {}),
          selectable: true,
          overlayOn: false,
          onSymbolTapped: (String tappedText, SymbolData imageData) {
            if (imageData.primarySelected) {
              selectedSymbolTables.add(_symbolKey(imageData.path));
            } else {
              selectedSymbolTables.remove(_symbolKey(imageData.path));
            }
          },
        )),
        GCWButton(
          text: i18n(context, 'symboltablesexamples_submitandnext'),
          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          onPressed: () {
            if (selectedSymbolTables.length <= _ALERT_COUNT_SELECTIONS) {
              _openInSymbolSearch();
            } else {
              showGCWAlertDialog(
                  context,
                  i18n(context, 'symboltablesexamples_manyselections_title'),
                  i18n(context, 'symboltablesexamples_manyselections_text', parameters: [selectedSymbolTables.length]),
                  () => _openInSymbolSearch(),
                  cancelButton: true);

              return;
            }
          },
        )
      ],
    );
  }

  void _openInSymbolSearch() {
    Navigator.push(
        context,
        NoAnimationMaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                  tool: SymbolTableExamples(
                    symbolKeys: selectedSymbolTables,
                  ),
                  autoScroll: false,
                  id: 'symboltablesexamples',
                )));
  }
}
