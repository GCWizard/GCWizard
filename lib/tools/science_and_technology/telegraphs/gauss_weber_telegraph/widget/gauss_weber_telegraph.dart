import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';

class GaussWeberTelegraph extends StatefulWidget {
  final GaussWeberTelegraphMode mode;

  const GaussWeberTelegraph({super.key, this.mode = GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1});

  @override
  _GaussWeberTelegraphState createState() => _GaussWeberTelegraphState();
}

class _GaussWeberTelegraphState extends State<GaussWeberTelegraph> {
  late TextEditingController _decodeController;
  late TextEditingController _encodeController;

  String _currentDecodeInput = '';
  String _currentEncodeInput = '';

  var _currentMode = GCWSwitchPosition.right;
  var _currentNeedleNumber = GaussWeberTelegraphMode.WHEATSTONE_COOKE_5;
  var _currentGaussVersion = GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1;

  @override
  void initState() {
    super.initState();

    _decodeController = TextEditingController(text: _currentDecodeInput);
    _encodeController = TextEditingController(text: _currentEncodeInput);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    _encodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.mode == GaussWeberTelegraphMode.WHEATSTONE_COOKE_5)
          GCWDropDown<GaussWeberTelegraphMode>(
            value: _currentNeedleNumber,
            onChanged: (value) {
              setState(() {
                _currentNeedleNumber = value;
              });
            },
            items: WHEATSTONECOOKENEEDLENUMBER.entries.map((mode) {
              return GCWDropDownMenuItem(
                  value: mode.key,
                  child: i18n(context, mode.value.title),
                  subtitle: mode.value.subtitle.isNotEmpty ? i18n(context, mode.value.subtitle) : null);
            }).toList(),
          ),
        if (widget.mode == GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1)
          GCWDropDown<GaussWeberTelegraphMode>(
            value: _currentGaussVersion,
            onChanged: (value) {
              setState(() {
                _currentGaussVersion = value;
              });
            },
            items: GAUSSWEBERVERSION.entries.map((mode) {
              return GCWDropDownMenuItem(
                  value: mode.key,
                  child: i18n(context, mode.value.title),
                  subtitle: mode.value.subtitle.isNotEmpty ? i18n(context, mode.value.subtitle) : null);
            }).toList(),
          ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (widget.mode == GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1) {
      if (_currentMode == GCWSwitchPosition.left) {
        var outputOriginal =
            encodeGaussWeberTelegraph(_currentEncodeInput, _currentGaussVersion);

        return GCWOutput(child: outputOriginal, title: i18n(context, 'telegraph_gausswebertelegraph_original'));
      } else {

        return GCWDefaultOutput(
            child: decodeGaussWeberTelegraph(_currentDecodeInput, _currentGaussVersion));
      }
    } else {
      String output;
      if (_currentMode == GCWSwitchPosition.left) {
        if (widget.mode == GaussWeberTelegraphMode.WHEATSTONE_COOKE_5) {
          output = encodeGaussWeberTelegraph(_currentEncodeInput, _currentNeedleNumber);
        } else {
          output = encodeGaussWeberTelegraph(_currentEncodeInput, widget.mode);
        }
      } else {
        if (widget.mode == GaussWeberTelegraphMode.WHEATSTONE_COOKE_5) {
          output = decodeGaussWeberTelegraph(_currentDecodeInput, _currentNeedleNumber);
        } else {
          output = decodeGaussWeberTelegraph(_currentDecodeInput, widget.mode);
        }
        output = output
            .replaceAll('schillingcanstatt_stop', i18n(context, 'telegraph_schillingcanstatt_stop'))
            .replaceAll('schillingcanstatt_goon', i18n(context, 'telegraph_schillingcanstatt_goon'))
            .replaceAll('schillingcanstatt_finish', i18n(context, 'telegraph_schillingcanstatt_finish'));
      }

      return GCWDefaultOutput(child: output);
    }
  }
}
