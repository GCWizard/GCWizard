import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/widget/vigenere_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/widget/gronsfeld.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/larrabee/widget/larrabee.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/porta/widget/porta.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trithemius/widget/trithemius.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/widget/vigenere.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class VigenereSelection extends GCWSelection {
  const VigenereSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(Vigenere()),
        className(const VigenereBreaker()),
        className(const Trithemius()),
        className(const Gronsfeld()),
        className(const Porta()),
        className(Larrabee()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
