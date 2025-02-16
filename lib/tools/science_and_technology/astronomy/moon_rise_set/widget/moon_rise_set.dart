import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/moon_rise_set/logic/moon_rise_set.dart' as logic;
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class MoonRiseSet extends StatefulWidget {
  const MoonRiseSet({Key? key}) : super(key: key);

  @override
  _MoonRiseSetState createState() => _MoonRiseSetState();
}

class _MoonRiseSetState extends State<MoonRiseSet> {
  var _currentDateTime = DateTimeTZ.now();
  var _currentCoords = defaultBaseCoordinate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCoords(
          title: i18n(context, 'common_location'),
          coordsFormat: _currentCoords.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoords = ret;
              }
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'astronomy_riseset_date'),
        ),
        GCWDateTimePicker(
          config: const {DateTimePickerConfig.DATE, DateTimePickerConfig.TIMEZONES},
          onChanged: (datetime) {
            setState(() {
              _currentDateTime = datetime;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var moonRise = logic.MoonRiseSet(_currentCoords.toLatLng() ?? defaultCoordinate, JulianDate(_currentDateTime),
        _currentDateTime.timezone, defaultEllipsoid);

    var outputs = [
      [
        i18n(context, 'astronomy_riseset_moonrise'),
        moonRise.rise.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(moonRise.rise)
      ],
      [
        i18n(context, 'astronomy_riseset_transit'),
        moonRise.transit.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(moonRise.transit)
      ],
      [
        i18n(context, 'astronomy_riseset_moonset'),
        moonRise.set.isNaN ? i18n(context, 'astronomy_riseset_notavailable') : formatHoursToHHmmss(moonRise.set)
      ],
    ];

    return GCWColumnedMultilineOutput(firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))], data: outputs);
  }
}
