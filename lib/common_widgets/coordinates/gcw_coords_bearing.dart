import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_bearing_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/utils/math_utils.dart';

final _NO_COMPASS_DIRECTION = '-';

final List<Map<String, dynamic>> COMPASS_ROSE = [
  {'symbol': _NO_COMPASS_DIRECTION, 'name': _NO_COMPASS_DIRECTION, 'value': double.nan, 'level': -1},
  {'symbol': 'common_compassrose_n_symbol', 'name': 'common_compassrose_n_name', 'value': 0.0, 'level': 0},
  {'symbol': 'common_compassrose_nbe_symbol', 'name': 'common_compassrose_nbe_name', 'value': 11.25, 'level': 3},
  {'symbol': 'common_compassrose_nne_symbol', 'name': 'common_compassrose_nne_name', 'value': 22.5, 'level': 2},
  {'symbol': 'common_compassrose_nebn_symbol', 'name': 'common_compassrose_nebn_name', 'value': 33.75, 'level': 3},
  {'symbol': 'common_compassrose_ne_symbol', 'name': 'common_compassrose_ne_name', 'value': 45.0, 'level': 1},
  {'symbol': 'common_compassrose_nebe_symbol', 'name': 'common_compassrose_nebe_name', 'value': 56.25, 'level': 3},
  {'symbol': 'common_compassrose_ene_symbol', 'name': 'common_compassrose_ene_name', 'value': 67.5, 'level': 2},
  {'symbol': 'common_compassrose_ebn_symbol', 'name': 'common_compassrose_ebn_name', 'value': 78.75, 'level': 3},
  {'symbol': 'common_compassrose_e_symbol', 'name': 'common_compassrose_e_name', 'value': 90.0, 'level': 0},
  {'symbol': 'common_compassrose_ebs_symbol', 'name': 'common_compassrose_ebs_name', 'value': 101.25, 'level': 3},
  {'symbol': 'common_compassrose_ese_symbol', 'name': 'common_compassrose_ese_name', 'value': 112.5, 'level': 2},
  {'symbol': 'common_compassrose_sebe_symbol', 'name': 'common_compassrose_sebe_name', 'value': 123.75, 'level': 3},
  {'symbol': 'common_compassrose_se_symbol', 'name': 'common_compassrose_se_name', 'value': 135.0, 'level': 1},
  {'symbol': 'common_compassrose_sebs_symbol', 'name': 'common_compassrose_sebs_name', 'value': 146.25, 'level': 3},
  {'symbol': 'common_compassrose_sse_symbol', 'name': 'common_compassrose_sse_name', 'value': 157.5, 'level': 2},
  {'symbol': 'common_compassrose_sbe_symbol', 'name': 'common_compassrose_sbe_name', 'value': 168.75, 'level': 3},
  {'symbol': 'common_compassrose_s_symbol', 'name': 'common_compassrose_s_name', 'value': 180.0, 'level': 0},
  {'symbol': 'common_compassrose_sbw_symbol', 'name': 'common_compassrose_sbw_name', 'value': 191.25, 'level': 3},
  {'symbol': 'common_compassrose_ssw_symbol', 'name': 'common_compassrose_ssw_name', 'value': 202.5, 'level': 2},
  {'symbol': 'common_compassrose_swbs_symbol', 'name': 'common_compassrose_swbs_name', 'value': 213.75, 'level': 3},
  {'symbol': 'common_compassrose_sw_symbol', 'name': 'common_compassrose_sw_name', 'value': 225.0, 'level': 1},
  {'symbol': 'common_compassrose_swbw_symbol', 'name': 'common_compassrose_swbw_name', 'value': 236.25, 'level': 3},
  {'symbol': 'common_compassrose_wsw_symbol', 'name': 'common_compassrose_wsw_name', 'value': 247.5, 'level': 2},
  {'symbol': 'common_compassrose_wbs_symbol', 'name': 'common_compassrose_wbs_name', 'value': 258.75, 'level': 3},
  {'symbol': 'common_compassrose_w_symbol', 'name': 'common_compassrose_w_name', 'value': 270.0, 'level': 0},
  {'symbol': 'common_compassrose_wbn_symbol', 'name': 'common_compassrose_wbn_name', 'value': 281.25, 'level': 3},
  {'symbol': 'common_compassrose_wnw_symbol', 'name': 'common_compassrose_wnw_name', 'value': 292.5, 'level': 2},
  {'symbol': 'common_compassrose_nwbw_symbol', 'name': 'common_compassrose_nwbw_name', 'value': 303.75, 'level': 3},
  {'symbol': 'common_compassrose_nw_symbol', 'name': 'common_compassrose_nw_name', 'value': 315.0, 'level': 1},
  {'symbol': 'common_compassrose_nwbn_symbol', 'name': 'common_compassrose_nwbn_name', 'value': 326.25, 'level': 3},
  {'symbol': 'common_compassrose_nnw_symbol', 'name': 'common_compassrose_nnw_name', 'value': 337.5, 'level': 2},
  {'symbol': 'common_compassrose_nbw_symbol', 'name': 'common_compassrose_nbw_name', 'value': 348.75, 'level': 3},
];

class GCWBearing extends StatefulWidget {
  final Function onChanged;
  final String hintText;

  const GCWBearing({Key key, this.onChanged, this.hintText}) : super(key: key);

  @override
  _GCWBearingState createState() => _GCWBearingState();
}

class _GCWBearingState extends State<GCWBearing> {
  TextEditingController _bearingController;
  var _currentBearing = {'text': '', 'value': 0.0};

  var _currentCompassValue;

  @override
  void initState() {
    super.initState();
    _bearingController = TextEditingController(text: _currentBearing['text']);
  }

  @override
  void dispose() {
    _bearingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentCompassValue == null) {
      _currentCompassValue =
          COMPASS_ROSE.firstWhere((direction) => direction['symbol'] == 'common_compassrose_n_symbol')['symbol'];
    }

    return Row(children: <Widget>[
      Expanded(
        flex: 5,
        child: GCWDoubleTextField(
          hintText: widget.hintText ?? i18n(context, 'common_bearing_hint'),
          controller: _bearingController,
          textInputFormatter: GCWBearingTextInputFormatter(),
          onChanged: (ret) {
            setState(() {
              _currentBearing['value'] = ret['value'];
              _currentBearing['text'] = ret['text'];

              var normalizedBearing = modulo(_currentBearing['value'], 360.0);

              var compassValue =
                  COMPASS_ROSE.firstWhere((direction) => direction['value'] == normalizedBearing, orElse: () => null);
              if (compassValue != null)
                _currentCompassValue = compassValue['symbol'];
              else
                _currentCompassValue = _NO_COMPASS_DIRECTION;

              widget.onChanged(_currentBearing);
            });
          },
        ),
      ),
      Expanded(
        flex: 1,
        child: GCWText(text: ' °  = '),
      ),
      Expanded(
        flex: 5,
        child: GCWDropDown(
          value: _currentCompassValue,
          items: COMPASS_ROSE.map((direction) {
            if (direction['symbol'] == _NO_COMPASS_DIRECTION) {
              return GCWDropDownMenuItem(value: _NO_COMPASS_DIRECTION, child: _NO_COMPASS_DIRECTION);
            }

            var fontweight;
            var level = direction['level'];
            if (level == 0)
              fontweight = FontWeight.w900;
            else if (level == 1)
              fontweight = FontWeight.w600;
            else if (level == 2)
              fontweight = FontWeight.w400;
            else if (level == 3) fontweight = FontWeight.w300;

            return GCWDropDownMenuItem(
                value: direction['symbol'],
                child: i18n(context, direction['symbol']),
                subtitle: i18n(context, direction['name']) + ' (${direction['value']}°)',
                style: gcwTextStyle().copyWith(fontSize: defaultFontSize() + 10 - 4 * level, fontWeight: fontweight));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentCompassValue = value;
              if (value == _NO_COMPASS_DIRECTION) return;

              var compassValue = COMPASS_ROSE.firstWhere((direction) => direction['symbol'] == value)['value'];

              _currentBearing = {'text': compassValue.toString(), 'value': compassValue};
              _bearingController.text = compassValue.toString();

              widget.onChanged(_currentBearing);
            });
          },
        ),
      )
    ]);
  }
}
