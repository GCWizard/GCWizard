import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/paperformat/logic/paperformat.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/area.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';

class PaperFormats extends StatefulWidget {
  const PaperFormats({Key? key}) : super(key: key);

  @override
  _PaperFormatState createState() => _PaperFormatState();
}

class _PaperFormatState extends State<PaperFormats> {
  var _currentDINFormat = DINA_FORMAT;
  var _currentTargetUnit = (UNITPREFIX_MILLI, LENGTH_METER, AREA_SQUARECENTIMETER);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<Map<String, FormatInfo>>(
          value: _currentDINFormat,
          items:[
            GCWDropDownMenuItem( value: DINA_FORMAT, child: 'DIN A'),
            GCWDropDownMenuItem( value: DINB_FORMAT, child: 'DIN B'),
            GCWDropDownMenuItem( value: DINC_FORMAT, child: 'DIN C'),
            GCWDropDownMenuItem( value: DIND_FORMAT, child: 'DIN D'),
            GCWDropDownMenuItem( value: US_FORMAT, child: 'US'),
            GCWDropDownMenuItem( value: US_ANSI_FORMAT, child: 'US ANSI'),
            GCWDropDownMenuItem( value: US_ARCH_FORMAT, child: 'US ARCH'),
          ],
          onChanged: (value) {
            setState(() {
              _currentDINFormat = value;
            });
          },
        ),
        Row(
          children: [
            Expanded(flex: 3, child: GCWText(text: i18n(context, 'unitconverter_unit') + ':')),
            Expanded(
                flex: 4,
                child: GCWDropDown<(UnitPrefix, Length, Area)>(
                  value: _currentTargetUnit,
                  items: getDropDownItems(context),
                  onChanged: ((UnitPrefix, Length, Area)  value) {
                    setState(() {
                      _currentTargetUnit =  value;
                    });
                  })
            )
          ],
        ),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  Widget _buildOutput() {
    List<List<String>> output = [];
    output.add([i18n(context, 'common_name'), i18n(context, 'common_size'), i18n(context, 'common_area')]);
    _currentDINFormat.forEach((name, formatInfo) {
      output.add([name,
        formatInfo.size(_currentTargetUnit.$1, _currentTargetUnit.$2),
        formatInfo.area(_currentTargetUnit.$3)]);
    });

    return GCWColumnedMultilineOutput(
        hasHeader: true,
        copyColumn: 1,
        data: output,
        flexValues: const [3, 8, 4]);
  }

  List<GCWDropDownMenuItem<(UnitPrefix, Length, Area)>> getDropDownItems(BuildContext context) {
    return <GCWDropDownMenuItem<(UnitPrefix, Length, Area)>>[
      GCWDropDownMenuItem<(UnitPrefix, Length, Area)>(
          value: (UNITPREFIX_MILLI, LENGTH_METER, AREA_SQUARECENTIMETER),
          child: UNITPREFIX_MILLI.symbol + LENGTH_METER.symbol + '/ ' + AREA_SQUARECENTIMETER.symbol),
      GCWDropDownMenuItem<(UnitPrefix, Length, Area)>(
          value: (UNITPREFIX_NONE, LENGTH_METER, AREA_SQUAREMETER),
          child: UNITPREFIX_NONE.symbol + LENGTH_METER.symbol + '/ ' + AREA_SQUAREMETER.symbol),
      GCWDropDownMenuItem<(UnitPrefix, Length, Area)>(
          value: (UNITPREFIX_NONE, LENGTH_INCH, AREA_SQUAREINCH),
          child: UNITPREFIX_NONE.symbol + LENGTH_INCH.symbol+ '/ ' + AREA_SQUAREINCH.symbol),
    ];
  }
}
