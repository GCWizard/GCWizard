import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/slash_and_pipe/widget/slash_and_pipe.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class SlashAndPipeSelection extends GCWSelection {
  const SlashAndPipeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      if ((className(element.tool) == className(const SymbolTable()) && (element.tool as SymbolTable).symbolKey == 'slash_and_pipe') ||
      (className(element.tool) == className(const SymbolTable()) && (element.tool as SymbolTable).symbolKey == 'slash_and_pipe_underland')    ||
      (className(element.tool) == className(const SymbolTable()) && (element.tool as SymbolTable).symbolKey == 'slash_and_pipe_codeofclaw'))   {
        return true;
      }

      return [
        className(const SlashAndPipe()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
