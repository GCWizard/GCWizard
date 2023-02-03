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
  @override
  MathematicalConstantsState createState() => MathematicalConstantsState();
}

class MathematicalConstantsState extends State<MathematicalConstants> {
  var _currentConstant;
  Map<String, Map<String, dynamic>> _constants;

  List<String> _orderedConstantKeys = [];

  @override
  Widget build(BuildContext context) {
    if (_constants == null) {
      _buildConstants(context);
    }

    return Column(
      children: <Widget>[
        GCWDropDown(
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

  void _buildConstants(BuildContext context) {
    _constants = {};

    MATHEMATICAL_CONSTANTS.entries.forEach((constant) {
      _constants.putIfAbsent(constant.key, () => constant.value);

      if (constant.value['additional_names'] != null) {
        List<String> names = constant.value['additional_names'];

        names.forEach((name) {
          var mapKey = name;

          var symbol = constant.value['symbol'];
          var value = constant.value['value'];
          var tool = constant.value['tool'];
          var additionalNames = List<String>.from(constant.value['additional_names']);
          additionalNames.add(constant.key);
          additionalNames.remove(name);

          var mapValue = {'value': value, 'additional_names': additionalNames};

          if (symbol != null) mapValue.putIfAbsent('symbol', () => symbol);

          if (tool != null) mapValue.putIfAbsent('tool', () => tool);

          _constants.putIfAbsent(mapKey, () => mapValue);
        });
      }
    });

    List<String> _temp = _constants.keys.map((constant) => i18n(context, constant)).toList();
    _temp.sort();

    for (String constant in _temp) {
      _orderedConstantKeys.add(_constants.keys.firstWhere((c) => i18n(context, c) == constant));
    }

    _currentConstant = _orderedConstantKeys.first;
  }

  Widget _buildOutput() {
    Map<String, dynamic> constantData = _constants[_currentConstant];

    List<String> names;
    if (constantData['additional_names'] != null) {
      print(constantData['additional_names']);

      names = constantData['additional_names'].map<String>((name) => i18n(context, name)).toList();
    }

    var data = [
      constantData['symbol'] != null
          ? [
              i18n(context, 'physical_constants_symbol'),
              buildSubOrSuperscriptedRichTextIfNecessary(constantData['symbol'])
            ]
          : null,
      [i18n(context, 'physical_constants_value'), constantData['value']],
      names != null ? [i18n(context, 'mathematical_constants_additionalnames'), names.join('\n')] : null
    ];

    var dataView = GCWColumnedMultilineOutput(
        data: data,
        flexValues: [1, 2]
    );

    var toolLink = _buildToolLink(constantData['tool']);

    return Column(
      children: [dataView, toolLink],
    );
  }

  Widget _buildToolLink(String toolReference) {
    if (toolReference == null) return Container();

    Widget widget;
    String title;
    switch (toolReference) {
      case 'e':
        widget = ESelection();
        title = 'e_selection_title';
        break;
      case 'pi':
        widget = PiSelection();
        title = 'pi_selection_title';
        break;
      case 'phi':
        widget = PhiSelection();
        title = 'phi_selection_title';
        break;
      case 'silverratio':
        widget = SilverRatioSelection();
        title = 'silverratio_selection_title';
        break;
      case 'sqrt2':
        widget = SQRT2Selection();
        title = 'sqrt2_selection_title';
        break;
      case 'sqrt3':
        widget = SQRT3Selection();
        title = 'sqrt3_selection_title';
        break;
      case 'sqrt5':
        widget = SQRT5Selection();
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
            NoAnimationMaterialPageRoute(
                builder: (context) => GCWTool(tool: widget, toolName: i18n(context, title), i18nPrefix: '')));
      },
    );
  }
}
