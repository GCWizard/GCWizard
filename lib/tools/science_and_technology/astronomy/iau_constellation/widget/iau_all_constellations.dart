import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/logic/iau_constellation.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/iau_constellation/widget/iau_single_constellations.dart';

class IAUAllConstellations extends StatefulWidget {
  const IAUAllConstellations({
    Key? key,
  }) : super(key: key);

  @override
  IAUAllConstellationsState createState() => IAUAllConstellationsState();
}

class IAUAllConstellationsState extends State<IAUAllConstellations> {
  IAU_CONSTELLATION_SORT _currentSortCategory = IAU_CONSTELLATION_SORT.CONSTELLATION;

  GCWSwitchPosition _currentSortingOrder = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GCWDropDown<IAU_CONSTELLATION_SORT>(
          title: i18n(context, 'iau_constellation_sort'),
          value: _currentSortCategory,
          items: IAU_SORT.entries.map((mode) {
            return GCWDropDownMenuItem(value: mode.key, child: i18n(context, mode.value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _currentSortCategory = newValue;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentSortingOrder,
          title: i18n(context, 'common_sorting'),
          leftValue: i18n(context, 'common_sorting_asc'),
          rightValue: i18n(context, 'common_sorting_desc'),
          onChanged: (value) {
            setState(() {
              _currentSortingOrder = value;
            });
          },
        ),
        _buildOutput(),
      ],
    );
  }

  List<List<Object>> _buildValueOutputs() {
    var sortableList = List<Constellation>.from(allConstellations);

    var sortOrder = _currentSortingOrder == GCWSwitchPosition.left ? 1 : -1;

    switch (_currentSortCategory) {
      case IAU_CONSTELLATION_SORT.CONSTELLATION:
        sortableList.sort((a, b) => a.ConstellationName.compareTo(b.ConstellationName) * sortOrder);
        break;
      case IAU_CONSTELLATION_SORT.NAME:
        sortableList.sort((a, b) => i18n(context, a.name).compareTo(i18n(context, b.name)) * sortOrder);
        break;
      case IAU_CONSTELLATION_SORT.STAR:
        sortableList.sort((a, b) => a.Star.compareTo(b.Star) * sortOrder);
        break;
      case IAU_CONSTELLATION_SORT.AREA:
        sortableList.sort((a, b) => a.area.compareTo(b.area) * sortOrder);
        break;
      case IAU_CONSTELLATION_SORT.VISIBILIY:
        sortableList.sort((a, b) => a.visibility.compareTo(b.visibility) * sortOrder);
        break;
      case IAU_CONSTELLATION_SORT.MAGNITUDO:
        sortableList.sort((a, b) => a.magnitudo.compareTo(b.magnitudo) * sortOrder);
        break;
      default:
        break;
    }

    return sortableList
        .asMap()
        .map((index, constellation) {
          Object relevantValue;

          switch (_currentSortCategory) {
            case IAU_CONSTELLATION_SORT.CONSTELLATION:
              relevantValue = constellation.ConstellationName;
              break;
            case IAU_CONSTELLATION_SORT.NAME:
              relevantValue = i18n(context, constellation.name);
              break;
            case IAU_CONSTELLATION_SORT.STAR:
              relevantValue = constellation.Star;
              break;
            case IAU_CONSTELLATION_SORT.AREA:
              relevantValue = constellation.area;
              break;
            case IAU_CONSTELLATION_SORT.VISIBILIY:
              relevantValue = constellation.visibility;
              break;
            case IAU_CONSTELLATION_SORT.MAGNITUDO:
              relevantValue = constellation.magnitudo;
              break;
            default:
              relevantValue = '';
              break;
          }

          var entry = <Object>[(index + 1).toString() + '.'];
          if (_currentSortCategory == IAU_CONSTELLATION_SORT.CONSTELLATION) {
            entry.add(constellation.ConstellationName);
          } else {
            entry.addAll([relevantValue, constellation.ConstellationName]);
          }
          return MapEntry<int, List<Object>>(index, entry);
        })
        .values
        .toList();
  }

  List<Object> _buildHeader() {
    switch (_currentSortCategory) {
      case IAU_CONSTELLATION_SORT.CONSTELLATION:
        return ['', i18n(context, 'iau_constellation_iauname')];
      case IAU_CONSTELLATION_SORT.NAME:
        return ['', i18n(context, 'iau_constellation_name'), i18n(context, 'iau_constellation_iauname')];
      case IAU_CONSTELLATION_SORT.STAR:
        return ['', i18n(context, 'iau_constellation_star'), i18n(context, 'iau_constellation_iauname')];
      case IAU_CONSTELLATION_SORT.AREA:
        return ['', i18n(context, 'iau_constellation_area'), i18n(context, 'iau_constellation_iauname')];
      case IAU_CONSTELLATION_SORT.VISIBILIY:
        return ['', i18n(context, 'iau_constellation_visibility'), i18n(context, 'iau_constellation_iauname')];
      case IAU_CONSTELLATION_SORT.MAGNITUDO:
        return ['', i18n(context, 'iau_constellation_magnitudo'), i18n(context, 'iau_constellation_iauname')];
      default:
        return [];
    }
  }

  Widget _buildOutput() {
    List<List<Object>> outputData = [];
    var flexValues = <int>[];
    List<void Function()> tappables;

    outputData.add(_buildHeader());
    outputData.addAll(_buildValueOutputs());
    flexValues = [
      1,
      4,
      3,
    ];
    tappables = outputData
        .asMap()
        .map((index, data) {
          if (index == 0) {
            return MapEntry<int, void Function()>(index, () => {});
          }

          return MapEntry<int, void Function()>(
              index,
              () => _showConstellation(
                  data[_currentSortCategory == IAU_CONSTELLATION_SORT.CONSTELLATION ? 1 : 2] as String));
        })
        .values
        .toList();

    List<Widget> rows = [
      GCWColumnedMultilineOutput(
          hasHeader: true,
          firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
          data: outputData,
          flexValues: flexValues,
          copyColumn: 1,
          tappables: tappables)
    ];

    return Column(children: rows);
  }

  void _showConstellation(String ConstellationName) {
    Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
        builder: (context) =>
            GCWTool(tool: IAUSingleConstellation(ConstellationName: ConstellationName), id: 'iau_constellation')));
  }
}
