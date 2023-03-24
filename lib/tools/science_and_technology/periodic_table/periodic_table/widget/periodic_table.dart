import 'dart:math';
import 'package:collection/collection.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';

const _LEGEND_WIDTH = 2;
const _LEGEND_START_IUPAC_GROUP = 6;

class PeriodicTable extends StatefulWidget {
  const PeriodicTable({Key? key}) : super(key: key);

  @override
  PeriodicTableState createState() => PeriodicTableState();
}

class PeriodicTableState extends State<PeriodicTable> {
  late double _cellWidth;
  late double _maxCellHeight;
  final BorderSide _border = const BorderSide(width: 1.0, color: Colors.black87);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cellWidth = (MediaQuery.of(context).size.width - 20) / 19;
    _maxCellHeight = maxScreenHeight(context) / 11;

    return Column(children: _buildOutput());
  }

  Color _getColorByStateOfMatter(StateOfMatter stateOfMatter) {
    switch (stateOfMatter) {
      case StateOfMatter.GAS:
        return const Color(0xFFFFCDD2);
      case StateOfMatter.LIQUID:
        return const Color(0xFFBCFF9F);
      case StateOfMatter.SOLID:
        return const Color(0xFF9DCBFF);
      case StateOfMatter.UNKNOWN:
        return const Color(0xFFD9D9D9);
    }
  }

  Widget _buildElement(PeriodicTableElement? element) {
    return element == null
        ? Container(width: _cellWidth)
        : InkWell(
            child: Container(
              height: min(defaultFontSize() * 2.5, _maxCellHeight),
              decoration: BoxDecoration(
                color: _getColor(element.stateOfMatter, element.isRadioactive),
                border: Border(
                    top: _border,
                    left: _border,
                    right: element.iupacGroup == 18 || [1, 4, 12, 71, 103].contains(element.atomicNumber)
                        ? _border
                        : BorderSide.none,
                    bottom: element.period == 7 ? _border : BorderSide.none),
              ),
              width: _cellWidth,
              child: Column(
                children: [
                  Expanded(
                      child: AutoSizeText(
                    element.atomicNumber.toString(),
                    style: gcwTextStyle().copyWith(color: Colors.black),
                    minFontSize: AUTO_FONT_SIZE_MIN,
                    maxLines: 1,
                  )),
                  Expanded(
                      child: AutoSizeText(
                    element.chemicalSymbol,
                    style: gcwTextStyle().copyWith(color: Colors.black),
                    minFontSize: AUTO_FONT_SIZE_MIN,
                    maxLines: 1,
                  ))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
                  builder: (context) => GCWTool(
                      tool: PeriodicTableDataView(atomicNumber: element.atomicNumber),
                      id: 'periodictable_dataview')));
            },
          );
  }

  Widget _buildGroupHeadlineElement(int iupacGroup) {
    var group = iupacGroupToMainSubGroup(iupacGroup);

    return SizedBox(
      height: min(defaultFontSize() * 2.5, _maxCellHeight),
      width: _cellWidth,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
            iupacGroup.toString(),
            style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 1,
          )),
          Expanded(
              child: AutoSizeText(
                group?.item2 == null ? '' : encodeRomanNumbers(group!.item2),
            style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold),
            minFontSize: AUTO_FONT_SIZE_MIN,
            maxLines: 1,
          ))
        ],
      ),
    );
  }

  Widget? _buildHeadlineElement(int period, int iupacGroup) {
    if (iupacGroup == 0 && period > 0) {
      return SizedBox(
        width: _cellWidth,
        child: Text(
          period.toString(),
          style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
      );
    }

    if ([1, 18].contains(iupacGroup) && period == 0) {
      return _buildGroupHeadlineElement(iupacGroup);
    }

    if ([2, 13, 14, 15, 16, 17].contains(iupacGroup) && period == 1) {
      return _buildGroupHeadlineElement(iupacGroup);
    }

    if ([3, 4, 5, 6, 7, 8, 9, 10, 11, 12].contains(iupacGroup) && period == 3) {
      return _buildGroupHeadlineElement(iupacGroup);
    }

    return null;
  }

  List<Widget> _buildOutput() {
    var periods = <Widget>[];

    for (int period = 0; period <= 7; period++) {
      var periodRow = <Widget>[];

      for (int iupacGroup = 0; iupacGroup <= 18; iupacGroup++) {
        var headlineElement = _buildHeadlineElement(period, iupacGroup);
        if (headlineElement != null) {
          periodRow.add(headlineElement);
          continue;
        }

        var legendEntry = _getLegendElement(iupacGroup, period);
        if (legendEntry != null) {
          periodRow.add(legendEntry);
          iupacGroup += _legendWidth(period) - 1;
          continue;
        }

        PeriodicTableElement? element = _getElementAtPSECoordinate(iupacGroup, period);
        periodRow.add(_buildElement(element));
      }
      periods.add(Row(
        children: periodRow,
      ));
    }

    periods.add(Container(height: min(defaultFontSize() * 2.5, _maxCellHeight)));

    List<Widget> lanthanides = allPeriodicTableElements
        .where((element) => element.iupacGroupName == IUPACGroupName.LANTHANIDES)
        .map((element) => _buildElement(element))
        .toList();

    lanthanides.insert(
        0,
        SizedBox(
            width: _cellWidth * 4,
            child: AutoSizeText(
              i18n(context, 'periodictable_attribute_iupacgroupname_lanthanides'),
              style: gcwTextStyle(),
              minFontSize: AUTO_FONT_SIZE_MIN,
              maxLines: 1,
            )));

    periods.add(Row(
      children: lanthanides,
    ));

    List<Widget> actinides = allPeriodicTableElements
        .where((element) => element.iupacGroupName == IUPACGroupName.ACTINIDES)
        .map((element) => _buildElement(element))
        .toList();

    actinides.insert(
        0,
        SizedBox(
            width: _cellWidth * 4,
            child: AutoSizeText(
              i18n(context, 'periodictable_attribute_iupacgroupname_actinides'),
              style: gcwTextStyle(),
              minFontSize: AUTO_FONT_SIZE_MIN,
              maxLines: 1,
            )));

    periods.add(Row(
      children: actinides,
    ));

    return periods;
  }

  Color _getColor(StateOfMatter stateOfMatter, bool isRadioactive) {
    var color = HSVColor.fromColor(_getColorByStateOfMatter(stateOfMatter));
    var saturation = color.saturation;
    color = color.withSaturation(saturation * (isRadioactive ? 1.8 : 1.0));

    return color.toColor();
  }

  int _legendWidth(int period) {
    return _LEGEND_WIDTH * (period == 2 ? 2 : 1);
  }

  Widget? _getLegendElement(int iupacGroup, int period) {
    Color? color1;
    String? text1;
    Color? color2;
    String? text2;

    if (iupacGroup == _LEGEND_START_IUPAC_GROUP && period == 0) {
      color2 = _getColor(StateOfMatter.SOLID, false);
      text2 = i18n(context, 'periodictable_attribute_stateofmatter_solid');
    } else if (iupacGroup == _LEGEND_START_IUPAC_GROUP && period == 1) {
      color1 = _getColor(StateOfMatter.LIQUID, false);
      text1 = i18n(context, 'periodictable_attribute_stateofmatter_liquid');
    } else if (iupacGroup == _LEGEND_START_IUPAC_GROUP + _LEGEND_WIDTH && period == 0) {
      color2 = _getColor(StateOfMatter.GAS, false);
      text2 = i18n(context, 'periodictable_attribute_stateofmatter_gas');
    } else if (iupacGroup == _LEGEND_START_IUPAC_GROUP + _LEGEND_WIDTH && period == 1) {
      color1 = _getColor(StateOfMatter.UNKNOWN, false);
      text1 = i18n(context, 'common_unknown');
    } else if (iupacGroup == _LEGEND_START_IUPAC_GROUP && period == 2) {
      color1 = _getColor(StateOfMatter.SOLID, true);
      text1 = i18n(context, 'periodictable_attribute_isradioactive_true');
    }

    if (color1 == null && color2 == null) return null;
    var list =
      [MapEntry<Color?, String?>(color1, text1),
       MapEntry<Color?, String?>(color2, text2)];

    return Column(
      children: list.map((e) {
        return Container(
            height: min<double>(defaultFontSize() * 2.5, _maxCellHeight) / 2.0,
            color: e.key,
            width: _cellWidth * _legendWidth(period),
            child: AutoSizeText(
              e.value ?? '',
              style: gcwTextStyle().copyWith(color: Colors.black),
              minFontSize: AUTO_FONT_SIZE_MIN,
              maxLines: 1,
            ));
      }).toList(),
    );
  }

  PeriodicTableElement? _getElementAtPSECoordinate(int iupacGroup, int period) {
    return allPeriodicTableElements
        .firstWhereOrNull((element) => element.iupacGroup == iupacGroup && element.period == period);
  }
}
