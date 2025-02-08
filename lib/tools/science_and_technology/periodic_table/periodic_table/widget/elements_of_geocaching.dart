import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/elements_of_geocaching.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/elements_of_geocaching_data_view.dart';

class ElementsOfGeocaching extends StatefulWidget {
  const ElementsOfGeocaching({Key? key}) : super(key: key);

  @override
  _ElementsOfGeocachingState createState() => _ElementsOfGeocachingState();
}

class _ElementsOfGeocachingState extends State<ElementsOfGeocaching> {
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
    _cellWidth = (maxScreenWidth(context) - 20) / 10;
    _maxCellHeight = maxScreenHeight(context) / 6;

    return Column(children: _buildOutput());
  }

  Widget _buildElement(ElementsOfGeocachingElement? element) {
    return element == null
        ? Container(width: _cellWidth)
        : InkWell(
      child: Container(
        height: min(defaultFontSize() * 2.5, _maxCellHeight),
        decoration: BoxDecoration(
          color: elementsOfGeocachingTypeToColor[element.type]?.color,
          border: Border(
              top: _border,
              left: _border,
              right: element.group == 9  || [1, 4].contains(element.group)
                  ? _border
                  : BorderSide.none,
              bottom: element.period == 5 ? _border : BorderSide.none),
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
                  style: gcwTextStyle()
                      .copyWith(color: Colors.black),
                  minFontSize: AUTO_FONT_SIZE_MIN,
                  maxLines: 1,
                ))
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: ElementsOfGeocachingDataView(atomicNumber: element.atomicNumber), id: 'elementsofgeocaching_dataview')));
      },
    );
  }

  Widget _buildGroupHeadlineElement(int group) {
    return SizedBox(
      height: min(defaultFontSize() * 2.5, _maxCellHeight),
      width: _cellWidth,
      child: Column(
        children: [
          Expanded(
              child: AutoSizeText(
                group.toString(),
                style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold),
                minFontSize: AUTO_FONT_SIZE_MIN,
                maxLines: 1,
              )),
        ],
      ),
    );
  }

  Widget? _buildHeadlineElement(int period, int group) {
    if (group == 0 && period > 0) {
      return SizedBox(
        width: _cellWidth,
        child: Text(
          period.toString(),
          style: gcwTextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
      );
    }

    if ([1, 9].contains(group) && period == 0) {
      return _buildGroupHeadlineElement(group);
    }

    if ([2, 8].contains(group) && period == 1) {
      return _buildGroupHeadlineElement(group);
    }

    if ([3, 4, 5, 6, 7].contains(group) && period == 2) {
      return _buildGroupHeadlineElement(group);
    }

    return null;
  }

  List<Widget> _buildOutput() {
    var periods = <Widget>[];

    for (int period = 0; period <= 5; period++) {
      var periodRow = <Widget>[];

      for (int group = 0; group <= 9; group++) {
        var headlineElement = _buildHeadlineElement(period, group);
        if (headlineElement != null) {
          periodRow.add(headlineElement);
          continue;
        }

        ElementsOfGeocachingElement? element = _getElementAtTableCoordinate(group, period);
        periodRow.add(_buildElement(element));
      }
      periods.add(Row(
        children: periodRow,
      ));
    }

    return periods;
  }

  ElementsOfGeocachingElement? _getElementAtTableCoordinate(int group, int period) {
    return allElementsOfGeocachingTableElements
        .firstWhereOrNull((element) => element.group == group && element.period == period);
  }
}