import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_bearing_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class _CompassDirection {
  String symbol;
  String name;
  double value;
  int level;

  _CompassDirection({
    required this.symbol,
    required this.name,
    required this.value,
    required this.level,
  });
}

const _NO_COMPASS_DIRECTION = '-';

final List<_CompassDirection> _COMPASS_ROSE = [
  _CompassDirection(symbol: _NO_COMPASS_DIRECTION, name: _NO_COMPASS_DIRECTION, value: double.nan, level: -1),
  _CompassDirection(symbol: 'common_compassrose_n_symbol', name: 'common_compassrose_n_name', value: 0.0, level: 0),
  _CompassDirection(
      symbol: 'common_compassrose_nbe_symbol', name: 'common_compassrose_nbe_name', value: 11.25, level: 3),
  _CompassDirection(symbol: 'common_compassrose_nne_symbol', name: 'common_compassrose_nne_name', value: 22.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_nebn_symbol', name: 'common_compassrose_nebn_name', value: 33.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_ne_symbol', name: 'common_compassrose_ne_name', value: 45.0, level: 1),
  _CompassDirection(
      symbol: 'common_compassrose_nebe_symbol', name: 'common_compassrose_nebe_name', value: 56.25, level: 3),
  _CompassDirection(symbol: 'common_compassrose_ene_symbol', name: 'common_compassrose_ene_name', value: 67.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_ebn_symbol', name: 'common_compassrose_ebn_name', value: 78.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_e_symbol', name: 'common_compassrose_e_name', value: 90.0, level: 0),
  _CompassDirection(
      symbol: 'common_compassrose_ebs_symbol', name: 'common_compassrose_ebs_name', value: 101.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_ese_symbol', name: 'common_compassrose_ese_name', value: 112.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_sebe_symbol', name: 'common_compassrose_sebe_name', value: 123.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_se_symbol', name: 'common_compassrose_se_name', value: 135.0, level: 1),
  _CompassDirection(
      symbol: 'common_compassrose_sebs_symbol', name: 'common_compassrose_sebs_name', value: 146.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_sse_symbol', name: 'common_compassrose_sse_name', value: 157.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_sbe_symbol', name: 'common_compassrose_sbe_name', value: 168.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_s_symbol', name: 'common_compassrose_s_name', value: 180.0, level: 0),
  _CompassDirection(
      symbol: 'common_compassrose_sbw_symbol', name: 'common_compassrose_sbw_name', value: 191.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_ssw_symbol', name: 'common_compassrose_ssw_name', value: 202.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_swbs_symbol', name: 'common_compassrose_swbs_name', value: 213.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_sw_symbol', name: 'common_compassrose_sw_name', value: 225.0, level: 1),
  _CompassDirection(
      symbol: 'common_compassrose_swbw_symbol', name: 'common_compassrose_swbw_name', value: 236.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_wsw_symbol', name: 'common_compassrose_wsw_name', value: 247.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_wbs_symbol', name: 'common_compassrose_wbs_name', value: 258.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_w_symbol', name: 'common_compassrose_w_name', value: 270.0, level: 0),
  _CompassDirection(
      symbol: 'common_compassrose_wbn_symbol', name: 'common_compassrose_wbn_name', value: 281.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_wnw_symbol', name: 'common_compassrose_wnw_name', value: 292.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_nwbw_symbol', name: 'common_compassrose_nwbw_name', value: 303.75, level: 3),
  _CompassDirection(symbol: 'common_compassrose_nw_symbol', name: 'common_compassrose_nw_name', value: 315.0, level: 1),
  _CompassDirection(
      symbol: 'common_compassrose_nwbn_symbol', name: 'common_compassrose_nwbn_name', value: 326.25, level: 3),
  _CompassDirection(
      symbol: 'common_compassrose_nnw_symbol', name: 'common_compassrose_nnw_name', value: 337.5, level: 2),
  _CompassDirection(
      symbol: 'common_compassrose_nbw_symbol', name: 'common_compassrose_nbw_name', value: 348.75, level: 3),
];

class GCWBearing extends StatefulWidget {
  final void Function(DoubleText) onChanged;
  final String? hintText;

  const GCWBearing({Key? key, required this.onChanged, this.hintText}) : super(key: key);

  @override
  _GCWBearingState createState() => _GCWBearingState();
}

class _GCWBearingState extends State<GCWBearing> {
  late TextEditingController _bearingController;
  var _currentBearing = defaultDoubleText;

  String? _currentCompassValue;

  @override
  void initState() {
    super.initState();
    _bearingController = TextEditingController(text: _currentBearing.text);
  }

  @override
  void dispose() {
    _bearingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentCompassValue ??=
        _COMPASS_ROSE.firstWhere((direction) => direction.symbol == 'common_compassrose_n_symbol').symbol;

    return Row(children: <Widget>[
      Expanded(
        flex: 5,
        child: GCWDoubleTextField(
            hintText: widget.hintText ?? i18n(context, 'common_bearing_hint'),
            controller: _bearingController,
            textInputFormatter: GCWBearingTextInputFormatter(),
            onChanged: (DoubleText ret) {
              setState(() {
                _currentBearing = ret;

                var normalizedBearing = modulo360(_currentBearing.value);

                var compassValue = _COMPASS_ROSE.firstWhereOrNull((direction) => direction.value == normalizedBearing);
                if (compassValue != null) {
                  _currentCompassValue = compassValue.symbol;
                } else {
                  _currentCompassValue = _NO_COMPASS_DIRECTION;
                }

                widget.onChanged(_currentBearing);
              });
            }),
      ),
      const Expanded(
        flex: 1,
        child: GCWText(text: ' °  = '),
      ),
      Expanded(
        flex: 5,
        child: GCWDropDown<String>(
            value: _currentCompassValue!,
            items: _COMPASS_ROSE.map((direction) {
              if (direction.symbol == _NO_COMPASS_DIRECTION) {
                return GCWDropDownMenuItem(value: _NO_COMPASS_DIRECTION, child: _NO_COMPASS_DIRECTION);
              }

              FontWeight fontweight = FontWeight.normal;
              var level = direction.level;
              if (level == 0) {
                fontweight = FontWeight.w900;
              } else if (level == 1) {
                fontweight = FontWeight.w600;
              } else if (level == 2) {
                fontweight = FontWeight.w400;
              } else if (level == 3) {
                fontweight = FontWeight.w300;
              }

              return GCWDropDownMenuItem(
                  value: direction.symbol,
                  child: i18n(context, direction.symbol),
                  subtitle: i18n(context, direction.name) + ' (${direction.value}°)',
                  style: gcwTextStyle().copyWith(fontSize: defaultFontSize() + 10 - 4 * level, fontWeight: fontweight));
            }).toList(),
            onChanged: (String value) {
              setState(() {
                _currentCompassValue = value;
                if (value == _NO_COMPASS_DIRECTION) return;

                var compassValue = _COMPASS_ROSE.firstWhere((direction) => direction.symbol == value).value;

                _currentBearing = DoubleText(compassValue.toString(), compassValue);
                _bearingController.text = compassValue.toString();

                widget.onChanged(_currentBearing);
              });
            }),
      ),
    ]);
  }
}
