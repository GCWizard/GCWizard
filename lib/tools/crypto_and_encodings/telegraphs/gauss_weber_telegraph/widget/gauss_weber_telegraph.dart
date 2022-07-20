import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_output/widget/gcw_output.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';

class GaussWeberTelegraph extends StatefulWidget {
  final GaussWeberTelegraphMode mode;

  GaussWeberTelegraph({Key key, this.mode: GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL}) : super(key: key);

  @override
  GaussWeberTelegraphState createState() => GaussWeberTelegraphState();
}

class GaussWeberTelegraphState extends State<GaussWeberTelegraph> {
  var _decodeController;
  var _encodeController;

  String _currentDecodeInput = '';
  String _currentEncodeInput = '';

  var _currentMode = GCWSwitchPosition.right;
  var _currentNeedleNumber = GaussWeberTelegraphMode.WHEATSTONE_COOKE_5;

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
          GCWDropDownButton(
            value: _currentNeedleNumber,
            onChanged: (value) {
              setState(() {
                _currentNeedleNumber = value;
              });
            },
            items: WHEATSTONECOOKENEEDLENUMBER.entries.map((mode) {
              return GCWDropDownMenuItem(
                  value: mode.key,
                  child: i18n(context, mode.value['title']),
                  subtitle: mode.value['subtitle'] != null ? i18n(context, mode.value['subtitle']) : null);
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

  _buildOutput() {
    if (widget.mode == GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL) {
      if (_currentMode == GCWSwitchPosition.left) {
        var outputOriginal =
            encodeGaussWeberTelegraph(_currentEncodeInput, GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL);
        var outputAlt = encodeGaussWeberTelegraph(_currentEncodeInput, GaussWeberTelegraphMode.GAUSS_WEBER_ALTERNATIVE);

        return Column(children: [
          GCWOutput(child: outputOriginal, title: i18n(context, 'telegraph_gausswebertelegraph_original')),
          GCWOutput(child: outputAlt, title: i18n(context, 'telegraph_gausswebertelegraph_alternative')),
        ]);
      } else {
        var countOriginal = _currentDecodeInput.toLowerCase().replaceAll(RegExp(r'[^\+\-]'), '').length;
        var countAlt = _currentDecodeInput.toLowerCase().replaceAll(RegExp(r'[^rl]'), '').length;

        var mode = countOriginal >= countAlt
            ? GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL
            : GaussWeberTelegraphMode.GAUSS_WEBER_ALTERNATIVE;
        return GCWDefaultOutput(
            child: decodeGaussWeberTelegraph(_currentDecodeInput, mode)
                .replaceAll('telegraph_schillingcanstatt_stop', i18n(context, 'telegraph_schillingcanstatt_stop'))
                .replaceAll('telegraph_schillingcanstatt_goon', i18n(context, 'telegraph_schillingcanstatt_goon'))
                .replaceAll('telegraph_schillingcanstatt_finish', i18n(context, 'telegraph_schillingcanstatt_finish')));
      }
    } else {
      var output;
      if (_currentMode == GCWSwitchPosition.left) {
        if (widget.mode == GaussWeberTelegraphMode.WHEATSTONE_COOKE_5)
          output = encodeGaussWeberTelegraph(_currentEncodeInput, _currentNeedleNumber);
        else
          output = encodeGaussWeberTelegraph(_currentEncodeInput, widget.mode);
      } else {
        if (widget.mode == GaussWeberTelegraphMode.WHEATSTONE_COOKE_5)
          output = decodeGaussWeberTelegraph(_currentDecodeInput, _currentNeedleNumber);
        else
          output = decodeGaussWeberTelegraph(_currentDecodeInput, widget.mode);
        output = output
            .replaceAll('telegraph_schillingcanstatt_stop', i18n(context, 'telegraph_schillingcanstatt_stop'))
            .replaceAll('telegraph_schillingcanstatt_goon', i18n(context, 'telegraph_schillingcanstatt_goon'))
            .replaceAll('telegraph_schillingcanstatt_finish', i18n(context, 'telegraph_schillingcanstatt_finish'));
      }

      return GCWDefaultOutput(child: output);
    }
  }
}
