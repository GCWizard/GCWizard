import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/symbol_table.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_replacer/widget/symbol_replacer.dart';
import 'package:gc_wizard/tools/symbol_tables/symbol_tables_examples_select/widget/symbol_tables_examples_select.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class SymbolTableSelection extends GCWSelection {
  const SymbolTableSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const SymbolTable()),
      ].contains(className(element.tool));
    }).toList();

    _toolList.sort((a, b) => sortToolList(a, b));

    _toolList.insert(0, registeredTools.firstWhere((element) {
      return [
        className(const SymbolReplacer()),
      ].contains(className(element.tool));
    }));

    _toolList.insert(0, registeredTools.firstWhere((element) {
      return [
        className(const SymbolTableExamplesSelect()),
      ].contains(className(element.tool));
    }));

    return GCWToolList(toolList: _toolList);
  }
}

String _symboltablesDownloadLink(BuildContext context) {
  const _SUPPORTED_LANGUAGES = ['de', 'en', 'fr', 'ko', 'nl', 'sv', 'se'];
  var locale = Localizations.localeOf(context).languageCode;

  var usedLocale = 'en';
  if (_SUPPORTED_LANGUAGES.contains(locale)) usedLocale = locale;

  return 'https://misc.gcwizard.net/symbol_tables/symboltables_$usedLocale.pdf';
}

GCWPopupMenuItem symbolTableToolbarMenuItem(BuildContext context) {
  return GCWPopupMenuItem(
      child: iconedGCWPopupMenuItem(context, Icons.file_download, 'symboltables_selection_download_toolitem'),
      action: (index) {
        showGCWAlertDialog(
          context,
          i18n(context, 'symboltables_selection_download_dialog_title'),
          i18n(context, 'symboltables_selection_download_dialog_text'),
          () {
            launchUrl(Uri.parse(_symboltablesDownloadLink(context)));
          },
        );
      });
}
