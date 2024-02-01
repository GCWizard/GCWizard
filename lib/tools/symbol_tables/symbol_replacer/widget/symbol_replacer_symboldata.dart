import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';

class SymbolReplacerSymbolTableViewData {
  final String symbolKey;
  final GCWSymbolContainer? icon;
  final String? toolName;
  final String? description;
  SymbolReplacerSymbolTableData? data;

  SymbolReplacerSymbolTableViewData(
      {required this.symbolKey, required this.icon, required this.toolName, required this.description, this.data});

  Future<SymbolReplacerSymbolTableData?> initialize(BuildContext context) async {
    var originalData = SymbolTableData(context, symbolKey);
    await originalData.initialize(importEncryption: false);

    data = SymbolReplacerSymbolTableData(originalData);
    return Future.value(data);
  }
}

class SymbolReplacerSymbolTableData {
  String? symbolKey;
  late List<Map<String, SymbolReplacerSymbolData>> images;

  SymbolReplacerSymbolTableData(SymbolTableData data) {
    images = data.images.map((Map<String, SymbolData> elem) {
      Map<String, SymbolReplacerSymbolData> _tempMap = {};
      elem.forEach((String key, SymbolData value) {
        _tempMap.putIfAbsent(key, () => SymbolReplacerSymbolData(value));
      });

      return _tempMap;
    }).toList();
  }
}

class SymbolReplacerSymbolData {
  Uint8List? bytes;
  String? displayName;

  SymbolReplacerSymbolData(SymbolData data) {
    bytes = data.bytes;
    displayName = data.displayName;
  }
}
