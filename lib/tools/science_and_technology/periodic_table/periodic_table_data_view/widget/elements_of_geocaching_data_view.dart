import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/elements_of_geocaching.dart';

class ElementsOfGeocachingDataView extends StatefulWidget {
  final int atomicNumber;

  const ElementsOfGeocachingDataView({super.key, required this.atomicNumber});

  @override
  _ElementsOfGeocachingDataViewState createState() => _ElementsOfGeocachingDataViewState();
}

class _ElementsOfGeocachingDataViewState extends State<ElementsOfGeocachingDataView> {
  var _newCategory = true;
  var _currentCategory = ElementsOfGeocachingCategory.ELEMENT_NAME;
  late Object _currentValueCategoryValue;
  List<GCWDropDownMenuItem<Object>> _currentValueCategoryListItems = [];
  var _currentSortingOrder = GCWSwitchPosition.left;

  var _categories = <ElementsOfGeocachingCategory, String>{};
  final Map<int, String> _elementNames = {};
  final Map<int, String> _chemicalSymbols = {};
  final Map<int, int> _atomicNumbers = {};
  late List<int> _groups;
  late List<int> _periods;
  late List<String> _types;

  var _setSpecificValue = false;

  static const _sortableCategories = [
    ElementsOfGeocachingCategory.GROUP,
    ElementsOfGeocachingCategory.PERIOD,
    ElementsOfGeocachingCategory.TYPE,
  ];

  @override
  void initState() {
    super.initState();

    _categories = {
      ElementsOfGeocachingCategory.ELEMENT_NAME: 'elementsofgeocaching_attribute_elementname',
      ElementsOfGeocachingCategory.CHEMICAL_SYMBOL: 'elementsofgeocaching_attribute_chemicalsymbol',
      ElementsOfGeocachingCategory.ATOMIC_NUMBER: 'elementsofgeocaching_attribute_atomicnumber',
      ElementsOfGeocachingCategory.GROUP: 'elementsofgeocaching_attribute_group',
      ElementsOfGeocachingCategory.PERIOD: 'elementsofgeocaching_attribute_period',
      ElementsOfGeocachingCategory.TYPE: 'elementsofgeocaching_attribute_type',
    };

    for (var element in allElementsOfGeocachingTableElements) {
      _elementNames.putIfAbsent(element.atomicNumber, () => element.name);
      _chemicalSymbols.putIfAbsent(element.atomicNumber, () => element.chemicalSymbol);
      _atomicNumbers.putIfAbsent(element.atomicNumber, () => element.atomicNumber);
    }

    _groups = allElementsOfGeocachingTableElements.map((element) => element.group).toSet().toList();
    _groups.sort();

    _periods = allElementsOfGeocachingTableElements.map((element) => element.period).toSet().toList();
    _periods.sort();

    _types =
        allElementsOfGeocachingTableElements.map((element) => elementsOfGeocachingTypeToString[element.type]!).toSet().toList();
    _types.sort();

    _setSpecificValue = true;
    _currentValueCategoryValue = widget.atomicNumber;
  }

  @override
  Widget build(BuildContext context) {
    if (_newCategory) {
      _currentValueCategoryListItems = _buildNonValueCategoryItems(_currentCategory);
      _newCategory = false;
      _setSpecificValue = false;
    }

    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'periodictable_attribute')),
        GCWDropDown<ElementsOfGeocachingCategory>(
          value: _currentCategory,
          items: _categories.entries.map((category) {
            return GCWDropDownMenuItem(
              value: category.key,
              child: i18n(context, category.value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _newCategory = value != _currentCategory;
              _currentCategory = value;
            });
          },
        ),
        GCWDropDown<Object>(
          value: _currentValueCategoryValue,
          items: _currentValueCategoryListItems,
          onChanged: (value) {
            setState(() {
              _currentValueCategoryValue = value;
            });
          },
        ),
        _sortableCategories.contains(_currentCategory)
            ? GCWTwoOptionsSwitch(
                value: _currentSortingOrder,
                title: i18n(context, 'common_sorting'),
                leftValue: i18n(context, 'common_sorting_asc'),
                rightValue: i18n(context, 'common_sorting_desc'),
                onChanged: (value) {
                  setState(() {
                    _currentSortingOrder = value;
                  });
                },
              )
            : Container(),
        _buildOutput()
      ],
    );
  }

  List<GCWDropDownMenuItem<Object>> _buildNonValueCategoryItems(ElementsOfGeocachingCategory category) {
    var listItems = SplayTreeMap<Object, Object>();

    switch (category) {
      case ElementsOfGeocachingCategory.ELEMENT_NAME:
        for (var entry in _elementNames.entries) {
          listItems.putIfAbsent(i18n(context, entry.value), () => entry.key);
        }
        break;
      case ElementsOfGeocachingCategory.CHEMICAL_SYMBOL:
        for (var entry in _chemicalSymbols.entries) {
          listItems.putIfAbsent(entry.value, () => entry.key);
        }
        break;
      case ElementsOfGeocachingCategory.ATOMIC_NUMBER:
        for (var entry in _atomicNumbers.entries) {
          listItems.putIfAbsent(entry.value, () => entry.key);
        }
        break;
      case ElementsOfGeocachingCategory.GROUP:
        for (var entry in _groups) {
          listItems.putIfAbsent(entry, () => entry);
        }
        break;
      case ElementsOfGeocachingCategory.PERIOD:
        for (var entry in _periods) {
          listItems.putIfAbsent(entry, () => entry);
        }
        break;
      case ElementsOfGeocachingCategory.TYPE:
        for (var entry in _types) {
          listItems.putIfAbsent(
              i18n(context, entry), () => elementsOfGeocachingTypeToString.map((k, v) => MapEntry(v, k))[entry]!);
        }
        break;
    }

    if (!_setSpecificValue) _currentValueCategoryValue = listItems[listItems.firstKey()]!;

    return listItems.entries.map((entry) {
      return GCWDropDownMenuItem(
        value: entry.value,
        child: category == ElementsOfGeocachingCategory.TYPE
            ? Row (
                children: [
                  Container(color: elementsOfGeocachingTypeToColor[entry.value]!.color, width: 50, height: defaultFontSize() * 2),
                  Container(width: 2* DOUBLE_DEFAULT_MARGIN),
                  Text(entry.key.toString()),
                ],
              )

            : entry.key.toString(),
      );
    }).toList();
  }

  List<List<Object>> _buildGroupOutputs() {
    List<ElementsOfGeocachingElement> filteredList = [];

    switch (_currentCategory) {
      case ElementsOfGeocachingCategory.GROUP:
        filteredList =
            allElementsOfGeocachingTableElements.where((element) => element.group == _currentValueCategoryValue).toList();
        break;
      case ElementsOfGeocachingCategory.PERIOD:
        filteredList =
            allElementsOfGeocachingTableElements.where((element) => element.period == _currentValueCategoryValue).toList();
        break;
      case ElementsOfGeocachingCategory.TYPE:
        filteredList =
            allElementsOfGeocachingTableElements.where((element) => element.type == _currentValueCategoryValue).toList();
        break;
      default:
        break;
    }

    filteredList.sort((a, b) {
      var sortOrder = a.atomicNumber.compareTo(b.atomicNumber);
      return _currentSortingOrder == GCWSwitchPosition.left ? sortOrder : sortOrder * -1;
    });

    return filteredList
        .asMap()
        .map((index, element) {
          return MapEntry(index, [
            (index + 1).toString() + '.',
            element.atomicNumber,
            i18n(context, element.name),
            element.chemicalSymbol
          ]);
        })
        .values
        .toList();
  }

  Map<String, List<List<Object>>> _buildElementOutputs() {
    ElementsOfGeocachingElement eoge =
    allElementsOfGeocachingTableElements.firstWhere((element) => element.atomicNumber == _currentValueCategoryValue);

    return {
      'data': [
        [i18n(context, 'elementsofgeocaching_attribute_elementname'), i18n(context, eoge.name)],
        [i18n(context, 'elementsofgeocaching_attribute_chemicalsymbol'), eoge.chemicalSymbol],
        [i18n(context, 'elementsofgeocaching_attribute_atomicnumber'), eoge.atomicNumber],
        [i18n(context, 'elementsofgeocaching_attribute_group'), eoge.group],
        [i18n(context, 'elementsofgeocaching_attribute_period'), eoge.period],
        [
          i18n(context, 'elementsofgeocaching_attribute_type'),
          i18n(context, elementsOfGeocachingTypeToString[eoge.type]!)
        ],
        [
          i18n(context, 'common_color'),
          Row(
            children: [
              Container(color: elementsOfGeocachingTypeToColor[eoge.type]!.color, width: 50, height: defaultFontSize() * 2),
              Container(width: 2* DOUBLE_DEFAULT_MARGIN),
              GCWText(text: i18n(context, elementsOfGeocachingTypeToColor[eoge.type]!.name))
            ],
          )
        ],
      ]
    };
  }

  Widget _buildOutput() {
    List<List<Object>>? outputData;
    var flexValues = <int>[];
    List<void Function()>? tappables;

    switch (_currentCategory) {
      case ElementsOfGeocachingCategory.ELEMENT_NAME:
      case ElementsOfGeocachingCategory.ATOMIC_NUMBER:
      case ElementsOfGeocachingCategory.CHEMICAL_SYMBOL:
        var data = _buildElementOutputs();
        outputData = data['data']!;
        break;
      case ElementsOfGeocachingCategory.GROUP:
      case ElementsOfGeocachingCategory.PERIOD:
      case ElementsOfGeocachingCategory.TYPE:
        outputData = _buildGroupOutputs();
        flexValues = [1, 1, 3, 1];
        tappables = outputData.map((data) {
          return () => _showElement(data[1] as int);
        }).toList();
        break;
    }

    List<Widget> rows = [
      GCWColumnedMultilineOutput(
          firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
          data: outputData,
          flexValues: flexValues,
          copyColumn: 1,
          tappables: tappables)
    ];

    return Column(children: rows);
  }

  void _showElement(int atomicNumber) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
        builder: (context) =>
            GCWTool(tool: ElementsOfGeocachingDataView(atomicNumber: atomicNumber), id: 'elementsofgeocaching_dataview')));
  }
}
