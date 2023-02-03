import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_converter/widget/numeral_words_converter.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_identify_languages/widget/numeral_words_identify_languages.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_lists/widget/numeral_words_lists.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/numeral_words_text_search/widget/numeral_words_text_search.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class NumeralWordsSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(NumeralWordsTextSearch()),
        className(NumeralWordsLists()),
        className(NumeralWordsIdentifyLanguages()),
        className(NumeralWordsConverter()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
