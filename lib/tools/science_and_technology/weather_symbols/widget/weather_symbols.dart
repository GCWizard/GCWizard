import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/logic/symbol_table_data.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';

const _WEATHERSYMBOL_CLASSES = ['ww', 'w', 'a', 'n', 'c', 'cl', 'cm', 'ch'];

class WeatherSymbols extends StatefulWidget {
  @override
  WeatherSymbolsState createState() => WeatherSymbolsState();
}

class WeatherSymbolsState extends State<WeatherSymbols> {
  var _currentWeatherSymbolClazz = 'ww';

  Map<String, SymbolTableData> _data = {};

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future _initialize() async {
    for (String clazz in _WEATHERSYMBOL_CLASSES) {
      var symbolTableData = SymbolTableData(context, 'weather_$clazz');
      await symbolTableData.initialize();

      _data.putIfAbsent(clazz, () => symbolTableData);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown(
          value: _currentWeatherSymbolClazz,
          onChanged: (value) {
            setState(() {
              _currentWeatherSymbolClazz = value;
            });
          },
          items: _WEATHERSYMBOL_CLASSES.map((clazz) {
            return GCWDropDownMenuItem(
              value: clazz,
              child: i18n(context, 'symboltables_weather_${clazz}_title'),
              subtitle: i18n(context, 'symboltables_weather_${clazz}_description'),
            );
          }).toList(),
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildOutput() {
    if (_data == null || _data.isEmpty) return null;

    SymbolTableData data = _data[_currentWeatherSymbolClazz];
    return GCWColumnedMultilineOutput(
        data: data.images.map((Map<String, SymbolData> image) {
                return [
                  image.keys.first,
                  Container(
                    child: GCWSymbolContainer(
                      symbol: Image.memory(image.values.first.bytes),
                    ),
                    padding: EdgeInsets.all(10.0),
                  ),
                  i18n(context, 'weathersymbols_${_currentWeatherSymbolClazz}_${image.keys.first}')
                ];
              }).toList(),
        copyColumn: 2,
        flexValues: [1, 2, 6],
    );
  }
}
