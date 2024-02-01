import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_default/widget/symbol_table_encryption_default.dart';
import 'package:gc_wizard/tools/symbol_tables/special_encryption_painters/symbol_table_encryption_sizes/widget/symbol_table_encryption_sizes.dart';

class SymbolTablePaintData {
  late Canvas canvas;
  SymbolTableData data;
  SymbolTableEncryptionSizes sizes;
  List<int> imageIndexes;

  SymbolTablePaintData({required this.sizes, required this.data, required this.imageIndexes});
}

class SymbolTableEncryptionPainter extends CustomPainter {
  final SymbolTablePaintData paintData;
  final SymbolTableEncryption encryption;

  const SymbolTableEncryptionPainter({required this.paintData, required this.encryption});

  @override
  void paint(Canvas canvas, Size size) {
    paintData.canvas = canvas;
    encryption.paint(paintData);
  }

  @override
  bool shouldRepaint(SymbolTableEncryptionPainter oldDelegate) => true;
}
