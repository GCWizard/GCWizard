import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/units/temperature.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/roman_numbers/roman_numbers.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/periodic_table.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:intl/intl.dart';

class PeriodicTableDataView extends StatefulWidget {
  final int atomicNumber;

  const PeriodicTableDataView({Key key, this.atomicNumber}) : super(key: key);

  @override
  PeriodicTableDataViewState createState() => PeriodicTableDataViewState();
}

class PeriodicTableDataViewState extends State<PeriodicTableDataView> {
  var _newCategory = true;
  var _currentCategory = PeriodicTableCategory.ELEMENT_NAME;
  var _currentValueCategoryValue;
  var _currentValueCategoryListItems = [];
  var _currentSortingOrder = GCWSwitchPosition.left;

  var _categories = <PeriodicTableCategory, String>{};
  var _elementNames = {};
  var _chemicalSymbols = {};
  var _atomicNumbers = {};
  List<int> _iupacGroups;
  List<int> _mainGroups;
  List<int> _subGroups;
  List<int> _periods;
  List<String> _iupacGroupNames;
  List<String> _statesOfMatter;

  var _setSpecificValue = false;

  final _valueCategories = [
    PeriodicTableCategory.MASS,
    PeriodicTableCategory.MELTING_POINT,
    PeriodicTableCategory.BOILING_POINT,
    PeriodicTableCategory.ELECTRONEGATIVITY,
    PeriodicTableCategory.DENSITY,
    PeriodicTableCategory.HALF_LIFE,
    PeriodicTableCategory.MOST_COMMON_ISOTOP,
  ];

  final _sortableCategories = [
    PeriodicTableCategory.IUPAC_GROUP,
    PeriodicTableCategory.IUPAC_GROUP_NAME,
    PeriodicTableCategory.MAIN_GROUP,
    PeriodicTableCategory.SUB_GROUP,
    PeriodicTableCategory.PERIOD,
    PeriodicTableCategory.STATE_OF_MATTER,
    PeriodicTableCategory.MASS,
    PeriodicTableCategory.MELTING_POINT,
    PeriodicTableCategory.BOILING_POINT,
    PeriodicTableCategory.ELECTRONEGATIVITY,
    PeriodicTableCategory.DENSITY,
    PeriodicTableCategory.IS_SYNTHETIC,
    PeriodicTableCategory.IS_RADIOACTIVE,
    PeriodicTableCategory.HALF_LIFE,
    PeriodicTableCategory.MOST_COMMON_ISOTOP,
  ];

  @override
  void initState() {
    super.initState();

    _categories = {
      PeriodicTableCategory.ELEMENT_NAME: 'periodictable_attribute_elementname',
      PeriodicTableCategory.CHEMICAL_SYMBOL: 'periodictable_attribute_chemicalsymbol',
      PeriodicTableCategory.ATOMIC_NUMBER: 'periodictable_attribute_atomicnumber',
      PeriodicTableCategory.IUPAC_GROUP: 'periodictable_attribute_iupacgroup',
      PeriodicTableCategory.IUPAC_GROUP_NAME: 'periodictable_attribute_iupacgroupname',
      PeriodicTableCategory.MAIN_GROUP: 'periodictable_attribute_maingroup',
      PeriodicTableCategory.SUB_GROUP: 'periodictable_attribute_subgroup',
      PeriodicTableCategory.PERIOD: 'periodictable_attribute_period',
      PeriodicTableCategory.STATE_OF_MATTER: 'periodictable_attribute_stateofmatter',
      PeriodicTableCategory.MASS: 'periodictable_attribute_mass',
      PeriodicTableCategory.MELTING_POINT: 'periodictable_attribute_meltingpoint',
      PeriodicTableCategory.BOILING_POINT: 'periodictable_attribute_boilingpoint',
      PeriodicTableCategory.ELECTRONEGATIVITY: 'periodictable_attribute_electronegativity',
      PeriodicTableCategory.DENSITY: 'periodictable_attribute_density',
      PeriodicTableCategory.IS_RADIOACTIVE: 'periodictable_attribute_isradioactive',
      PeriodicTableCategory.HALF_LIFE: 'periodictable_attribute_halflife',
      PeriodicTableCategory.MOST_COMMON_ISOTOP: 'periodictable_attribute_mostcommonisotop',
      PeriodicTableCategory.IS_SYNTHETIC: 'periodictable_attribute_issynthetic',
    };

    allPeriodicTableElements.forEach((element) {
      _elementNames.putIfAbsent(element.atomicNumber, () => element.name);
      _chemicalSymbols.putIfAbsent(element.atomicNumber, () => element.chemicalSymbol);
      _atomicNumbers.putIfAbsent(element.atomicNumber, () => element.atomicNumber);
    });

    _iupacGroups = allPeriodicTableElements.map((element) => element.iupacGroup).toSet().toList();
    _iupacGroups.sort();

    _mainGroups = allPeriodicTableElements
        .where((element) => element.mainGroup != null)
        .map((element) => element.mainGroup)
        .toSet()
        .toList();
    _mainGroups.sort();

    _subGroups = allPeriodicTableElements
        .where((element) => element.subGroup != null)
        .map((element) => element.subGroup)
        .toSet()
        .toList();
    _subGroups.sort();

    _periods = allPeriodicTableElements.map((element) => element.period).toSet().toList();
    _periods.sort();

    _iupacGroupNames = allPeriodicTableElements
        .where((element) => element.iupacGroupName != null)
        .map((element) => iupacGroupNameToString[element.iupacGroupName])
        .toSet()
        .toList();
    _iupacGroupNames.sort();

    _statesOfMatter =
        allPeriodicTableElements.map((element) => stateOfMatterToString[element.stateOfMatter]).toSet().toList();
    _statesOfMatter.sort();

    if (widget.atomicNumber != null) {
      _setSpecificValue = true;
      _currentValueCategoryValue = widget.atomicNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_newCategory && !_valueCategories.contains(_currentCategory)) {
      _currentValueCategoryListItems = _buildNonValueCategoryItems(_currentCategory);
      _newCategory = false;
      _setSpecificValue = false;
    }

    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'periodictable_attribute')),
        GCWDropDownButton(
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
        _valueCategories.contains(_currentCategory)
            ? Container()
            : GCWDropDownButton(
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

  _buildNonValueCategoryItems(PeriodicTableCategory category) {
    var listItems = SplayTreeMap<dynamic, dynamic>();

    switch (category) {
      case PeriodicTableCategory.ELEMENT_NAME:
        _elementNames.entries.forEach((entry) => listItems.putIfAbsent(i18n(context, entry.value), () => entry.key));
        break;
      case PeriodicTableCategory.CHEMICAL_SYMBOL:
        _chemicalSymbols.entries.forEach((entry) => listItems.putIfAbsent(entry.value, () => entry.key));
        break;
      case PeriodicTableCategory.ATOMIC_NUMBER:
        _atomicNumbers.entries.forEach((entry) => listItems.putIfAbsent(entry.value, () => entry.key));
        break;
      case PeriodicTableCategory.IUPAC_GROUP:
        _iupacGroups.forEach((entry) => listItems.putIfAbsent(entry, () => entry));
        break;
      case PeriodicTableCategory.IUPAC_GROUP_NAME:
        _iupacGroupNames.forEach((entry) => listItems.putIfAbsent(
            i18n(context, entry), () => iupacGroupNameToString.map((k, v) => MapEntry(v, k))[entry]));
        break;
      case PeriodicTableCategory.MAIN_GROUP:
        _mainGroups.forEach((entry) => listItems.putIfAbsent(encodeRomanNumbers(entry), () => entry));
        break;
      case PeriodicTableCategory.SUB_GROUP:
        _subGroups.forEach((entry) => listItems.putIfAbsent(encodeRomanNumbers(entry), () => entry));
        break;
      case PeriodicTableCategory.PERIOD:
        _periods.forEach((entry) => listItems.putIfAbsent(entry, () => entry));
        break;
      case PeriodicTableCategory.STATE_OF_MATTER:
        _statesOfMatter.forEach((entry) => listItems.putIfAbsent(
            i18n(context, entry), () => stateOfMatterToString.map((k, v) => MapEntry(v, k))[entry]));
        break;
      case PeriodicTableCategory.IS_RADIOACTIVE:
        listItems.putIfAbsent(i18n(context, 'periodictable_attribute_isradioactive_true'), () => true);
        listItems.putIfAbsent(i18n(context, 'periodictable_attribute_isradioactive_false'), () => false);
        break;
      case PeriodicTableCategory.IS_SYNTHETIC:
        listItems.putIfAbsent(i18n(context, 'periodictable_attribute_issynthetic_true'), () => true);
        listItems.putIfAbsent(i18n(context, 'periodictable_attribute_issynthetic_false'), () => false);
        break;
      default:
        break;
    }

    if (!_setSpecificValue) _currentValueCategoryValue = listItems[listItems.firstKey()];

    return listItems.entries.map((entry) {
      return GCWDropDownMenuItem(
        value: entry.value,
        child: entry.key.toString(),
      );
    }).toList();
  }

  _buildGroupOutputs() {
    List<PeriodicTableElement> filteredList;

    switch (_currentCategory) {
      case PeriodicTableCategory.IUPAC_GROUP:
        filteredList =
            allPeriodicTableElements.where((element) => element.iupacGroup == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.IUPAC_GROUP_NAME:
        filteredList =
            allPeriodicTableElements.where((element) => element.iupacGroupName == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.MAIN_GROUP:
        filteredList =
            allPeriodicTableElements.where((element) => element.mainGroup == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.SUB_GROUP:
        filteredList =
            allPeriodicTableElements.where((element) => element.subGroup == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.PERIOD:
        filteredList =
            allPeriodicTableElements.where((element) => element.period == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.STATE_OF_MATTER:
        filteredList =
            allPeriodicTableElements.where((element) => element.stateOfMatter == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.IS_SYNTHETIC:
        filteredList =
            allPeriodicTableElements.where((element) => element.isSynthetic == _currentValueCategoryValue).toList();
        break;
      case PeriodicTableCategory.IS_RADIOACTIVE:
        filteredList =
            allPeriodicTableElements.where((element) => element.isRadioactive == _currentValueCategoryValue).toList();
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

  _buildValueOutputs() {
    var sortableList = List<PeriodicTableElement>.from(allPeriodicTableElements);

    var sortOrder = _currentSortingOrder == GCWSwitchPosition.left ? 1 : -1;

    switch (_currentCategory) {
      case PeriodicTableCategory.MASS:
        sortableList.sort((a, b) => a.mass.compareTo(b.mass) * sortOrder);
        break;
      case PeriodicTableCategory.MELTING_POINT:
        sortableList = sortableList.where((element) => element.meltingPoint > -double.infinity).toList();
        sortableList.sort((a, b) => a.meltingPoint.compareTo(b.meltingPoint) * sortOrder);
        break;
      case PeriodicTableCategory.BOILING_POINT:
        sortableList = sortableList.where((element) => element.boilingPoint > -double.infinity).toList();
        sortableList.sort((a, b) => a.boilingPoint.compareTo(b.boilingPoint) * sortOrder);
        break;
      case PeriodicTableCategory.ELECTRONEGATIVITY:
        sortableList = sortableList
            .where((element) =>
                element.electronegativity > -double.infinity && element.electronegativity < double.infinity)
            .toList();
        sortableList.sort((a, b) => a.electronegativity.compareTo(b.electronegativity) * sortOrder);
        break;
      case PeriodicTableCategory.DENSITY:
        sortableList = sortableList.where((element) => element.density > -double.infinity).toList();
        sortableList.sort((a, b) => a.density.compareTo(b.density) * sortOrder);
        break;
      case PeriodicTableCategory.HALF_LIFE:
        sortableList = sortableList.where((element) => element.halfLife < double.infinity).toList();
        sortableList.sort((a, b) => a.halfLife.compareTo(b.halfLife) * sortOrder);
        break;
      case PeriodicTableCategory.MOST_COMMON_ISOTOP:
        sortableList.sort((a, b) => a.mostCommonIsotop.compareTo(b.mostCommonIsotop) * sortOrder);
        break;
      default:
        break;
    }

    return sortableList
        .asMap()
        .map((index, element) {
          var relevantValue;

          switch (_currentCategory) {
            case PeriodicTableCategory.MASS:
              relevantValue = element.mass;
              break;
            case PeriodicTableCategory.MELTING_POINT:
              relevantValue = _temperatures(element.meltingPoint);
              break;
            case PeriodicTableCategory.BOILING_POINT:
              relevantValue = _temperatures(element.boilingPoint);
              break;
            case PeriodicTableCategory.ELECTRONEGATIVITY:
              relevantValue = element.electronegativity;
              break;
            case PeriodicTableCategory.DENSITY:
              relevantValue = element.formattedDensity;
              break;
            case PeriodicTableCategory.HALF_LIFE:
              relevantValue = element.formattedHalfLife;
              break;
            case PeriodicTableCategory.MOST_COMMON_ISOTOP:
              relevantValue = element.mostCommonIsotop;
              break;
            default:
              break;
          }

          return MapEntry(index, [
            (index + 1).toString() + '.',
            relevantValue,
            i18n(context, element.name),
            element.chemicalSymbol,
            element.atomicNumber
          ]);
        })
        .values
        .toList();
  }

  _temperatures(double tempInCelsius) {
    var format = NumberFormat('0.0');

    var kelvin = TEMPERATURE_CELSIUS.toKelvin(tempInCelsius);

    return format.format(kelvin) +
        ' ' +
        TEMPERATURE_KELVIN.symbol +
        '\n' +
        format.format(tempInCelsius) +
        ' ' +
        TEMPERATURE_CELSIUS.symbol +
        '\n' +
        format.format(TEMPERATURE_FAHRENHEIT.fromKelvin(kelvin)) +
        ' ' +
        TEMPERATURE_FAHRENHEIT.symbol;
  }

  _buildElementOutputs() {
    PeriodicTableElement pte =
        allPeriodicTableElements.firstWhere((element) => element.atomicNumber == _currentValueCategoryValue);

    return {
      'data': [
        [i18n(context, 'periodictable_attribute_elementname'), i18n(context, pte.name)],
        [i18n(context, 'periodictable_attribute_chemicalsymbol'), pte.chemicalSymbol],
        [i18n(context, 'periodictable_attribute_atomicnumber'), pte.atomicNumber],
        [i18n(context, 'periodictable_attribute_iupacgroup'), pte.iupacGroup],
        [
          i18n(context, 'periodictable_attribute_iupacgroupname'),
          pte.iupacGroupName == null ? '' : i18n(context, iupacGroupNameToString[pte.iupacGroupName])
        ],
        pte.mainGroup == null
            ? [i18n(context, 'periodictable_attribute_subgroup'), encodeRomanNumbers(pte.subGroup)]
            : [i18n(context, 'periodictable_attribute_maingroup'), encodeRomanNumbers(pte.mainGroup)],
        [i18n(context, 'periodictable_attribute_period'), pte.period],
        [
          i18n(context, 'periodictable_attribute_stateofmatter'),
          i18n(context, stateOfMatterToString[pte.stateOfMatter])
        ],
        [
          i18n(context, 'periodictable_attribute_meltingpoint'),
          pte.meltingPoint > -double.infinity ? _temperatures(pte.meltingPoint) : i18n(context, 'common_unknown')
        ],
        [
          i18n(context, 'periodictable_attribute_boilingpoint'),
          pte.boilingPoint > -double.infinity ? _temperatures(pte.boilingPoint) : i18n(context, 'common_unknown')
        ],
        [
          i18n(context, 'periodictable_attribute_density'),
          pte.density > -double.infinity ? pte.formattedDensity : i18n(context, 'common_unknown')
        ],
        [i18n(context, 'periodictable_attribute_mass'), pte.mass],
        [
          i18n(context, 'periodictable_attribute_electronegativity'),
          pte.electronegativity > -double.infinity
              ? (pte.electronegativity < double.infinity
                  ? pte.electronegativity
                  : i18n(context, 'periodictable_attribute_electronegativity_none'))
              : i18n(context, 'common_unknown')
        ],
        [
          i18n(context, 'periodictable_attribute_issynthetic_alternative'),
          pte.isSynthetic
              ? i18n(context, 'periodictable_attribute_issynthetic_true')
              : i18n(context, 'periodictable_attribute_issynthetic_false')
        ],
        [
          i18n(context, 'periodictable_attribute_isradioactive'),
          pte.isRadioactive
              ? i18n(context, 'periodictable_attribute_isradioactive_true')
              : i18n(context, 'periodictable_attribute_isradioactive_false')
        ],
        [
          i18n(context, 'periodictable_attribute_halflife'),
          pte.halfLife < double.infinity
              ? pte.formattedHalfLife
              : i18n(context, 'periodictable_attribute_halflife_stable')
        ],
        [i18n(context, 'periodictable_attribute_mostcommonisotop'), pte.mostCommonIsotop],
      ],
      'comments': pte.comments ?? []
    };
  }

  Widget _buildOutput() {
    var outputData = [[]];
    var flexValues = <int>[];
    var comments;
    var tappables;

    switch (_currentCategory) {
      case PeriodicTableCategory.ELEMENT_NAME:
      case PeriodicTableCategory.ATOMIC_NUMBER:
      case PeriodicTableCategory.CHEMICAL_SYMBOL:
        var data = _buildElementOutputs();
        outputData = data['data'];
        comments = data['comments'].map((comment) {
          return '- ' + i18n(context, comment);
        }).join('\n');
        break;
      case PeriodicTableCategory.IUPAC_GROUP:
      case PeriodicTableCategory.IUPAC_GROUP_NAME:
      case PeriodicTableCategory.MAIN_GROUP:
      case PeriodicTableCategory.SUB_GROUP:
      case PeriodicTableCategory.PERIOD:
      case PeriodicTableCategory.STATE_OF_MATTER:
      case PeriodicTableCategory.IS_SYNTHETIC:
      case PeriodicTableCategory.IS_RADIOACTIVE:
        outputData = _buildGroupOutputs();
        flexValues = [1, 1, 3, 1];
        tappables = outputData.map((data) {
          return () => _showElement(data[1]);
        }).toList();
        break;
      case PeriodicTableCategory.MASS:
      case PeriodicTableCategory.MELTING_POINT:
      case PeriodicTableCategory.BOILING_POINT:
      case PeriodicTableCategory.ELECTRONEGATIVITY:
      case PeriodicTableCategory.DENSITY:
      case PeriodicTableCategory.HALF_LIFE:
      case PeriodicTableCategory.MOST_COMMON_ISOTOP:
        outputData = _buildValueOutputs();
        flexValues = [1, 2, 3, 1, 1];
        tappables = outputData.map((data) {
          return () => _showElement(data[4]);
        }).toList();
        break;
    }

    List<Widget> rows = [GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: outputData,
        flexValues: flexValues,
        copyColumn: 1,
        tappables: tappables
    )];

    if (comments != null && comments.length > 0) {
      rows.addAll(
          [GCWTextDivider(text: i18n(context, 'periodictable_attribute_comments')), GCWOutputText(text: comments)]);
    }

    return Column(children: rows);
  }

  _showElement(int atomicNumber) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute(
        builder: (context) =>
            GCWTool(tool: PeriodicTableDataView(atomicNumber: atomicNumber), i18nPrefix: 'periodictable_dataview')));
  }
}
