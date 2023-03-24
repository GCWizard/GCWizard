import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/category_views/selector_lists/e_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/phi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/pi_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/silverratio_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt2_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt3_selection.dart';
import 'package:gc_wizard/application/category_views/selector_lists/sqrt5_selection.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/mathematical_constants/logic/mathematical_constants.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class MathematicalConstants extends StatefulWidget {
  const MathematicalConstants({Key? key}) : super(key: key);

  @override
  MathematicalConstantsState createState() => MathematicalConstantsState();
}

class MathematicalConstantsState extends State<MathematicalConstants> {
  String _currentConstant = '';
  late Map<String, MathematicalConstant> _constants;

  final List<String> _orderedConstantKeys = [];

  @override
  void initState() {
    super.initState();
    _constants = _buildConstants(context);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        GCWDropDown<String>(
          value: _currentConstant,
          onChanged: (value) {
            setState(() {
              _currentConstant = value;
            });
          },
          items: _orderedConstantKeys.map((constant) {
            return GCWDropDownMenuItem(value: constant, child: i18n(context, constant));
          }).toList(),
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Map<String, MathematicalConstant> _buildConstants(BuildContext context) {
    _constants = {};

    for (var constant in MATHEMATICAL_CONSTANTS.entries) {
      _constants.putIfAbsent(constant.key, () => constant.value);

      if (constant.value.additional_names != null) {
        List<String> names = constant.value.additional_names!;

        for (var name in names) {
          var additionalNames = List<String>.from(constant.value.additional_names!);
          additionalNames.add(constant.key);
          additionalNames.remove(name);

          var mapValue = MathematicalConstant(
              value: constant.value.value,
              symbol: constant.value.symbol,
              additional_names: additionalNames,
              tool: constant.value.tool);

          _constants.putIfAbsent(name, () => mapValue);
        }
      }
    }

    List<String> _temp = _constants.keys.map((constant) => i18n(context, constant)).toList();
    _temp.sort();

    for (String constant in _temp) {
      _orderedConstantKeys.add(_constants.keys.firstWhere((c) => i18n(context, c) == constant));
    }

    _currentConstant = _orderedConstantKeys.first;
    return _constants;
  }

  Widget _buildOutput() {
    var constantData = _constants[_currentConstant];
    if (constantData == null) return Container();

    List<String>? names;
    if (constantData.additional_names != null) {
      names = constantData.additional_names!.map<String>((name) => i18n(context, name)).toList();
    }

    List<List<Object?>> data = [];
      if (constantData.symbol != null) {
        data.add([
                  i18n(context, 'physical_constants_symbol'),
                  buildSubOrSuperscriptedRichTextIfNecessary(constantData.symbol!)
                ]);
      }
      data.add([i18n(context, 'physical_constants_value'), constantData.value]);
      if (names != null) {
        data.add([i18n(context, 'mathematical_constants_additionalnames'), names.join('\n')]);
      }


    var dataView = GCWColumnedMultilineOutput(
        data: data,
        flexValues: const [1, 2]
    );

    var toolLink = _buildToolLink(constantData.tool);

    return Column(
      children: [dataView, toolLink],
    );
  }

  Widget _buildToolLink(String? toolReference) {
    if (toolReference == null) return Container();

    Widget widget;
    String title;
    switch (toolReference) {
      case 'e':
        widget = const ESelection();
        title = 'e_selection_title';
        break;
      case 'pi':
        widget = const PiSelection();
        title = 'pi_selection_title';
        break;
      case 'phi':
        widget = const PhiSelection();
        title = 'phi_selection_title';
        break;
      case 'silverratio':
        widget = const SilverRatioSelection();
        title = 'silverratio_selection_title';
        break;
      case 'sqrt2':
        widget = const SQRT2Selection();
        title = 'sqrt2_selection_title';
        break;
      case 'sqrt3':
        widget = const SQRT3Selection();
        title = 'sqrt3_selection_title';
        break;
      case 'sqrt5':
        widget = const SQRT5Selection();
        title = 'sqrt5_selection_title';
        break;
      default:
        return Container();
    }

    return GCWButton(
      text: i18n(context, 'mathematical_constants_showmore'),
      onPressed: () {
        Navigator.push(
            context,
            NoAnimationMaterialPageRoute<GCWTool>(
                builder: (context) => GCWTool(tool: widget, toolName: i18n(context, title), id: '')));
      },
    );
  }
}
