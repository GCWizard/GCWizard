import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_multitap/widget/vanity_multitap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_singletap/widget/vanity_singletap.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_list/widget/vanity_words_list.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_search/widget/vanity_words_search.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class VanitySelection extends GCWSelection {
  const VanitySelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const VanitySingletap()),
        className(const VanityMultitap()),
        className(const VanityWordsList()),
        className(const VanityWordsTextSearch()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
