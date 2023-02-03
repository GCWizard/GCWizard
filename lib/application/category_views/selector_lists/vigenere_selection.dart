import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/widget/vigenere_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/widget/gronsfeld.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class VigenereSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(Vigenere()),
        className(VigenereBreaker()),
        className(Trithemius()),
        className(Gronsfeld()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
