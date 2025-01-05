import 'package:flutter/material.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_creditcard_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_de_taxid_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_ean_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_euro_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_iban_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_imei_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_isbn_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/checkdigits/checkdigits_uic_selection.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/application/tools/widget/gcw_toollist.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class CheckDigitsSelection extends GCWSelection {
  const CheckDigitsSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const CheckDigitsCreditCardSelection()),
        className(const CheckDigitsEANSelection()),
        className(const CheckDigitsEUROSelection()),
        className(const CheckDigitsIBANSelection()),
        className(const CheckDigitsIMEISelection()),
        className(const CheckDigitsISBNSelection()),
        className(const CheckDigitsDETaxIDSelection()),
        className(const CheckDigitsUICSelection()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
