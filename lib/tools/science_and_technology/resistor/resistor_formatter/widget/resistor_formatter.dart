import 'package:flutter/material.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';
import 'package:intl/intl.dart';

String formatResistorValue(double value) {
  var formatter = NumberFormat('0.####');
  return formatter.format(value) + ' \u03A9';
}

String formatResistorTolerancedValueInterval(List<double> valueInterval) {
  var formatter = NumberFormat('0.############');
  return formatter.format(valueInterval[0]) + ' \u03A9 - ' +
      formatter.format(valueInterval[1]) + ' \u03A9';
}

String formatResistorTolerance(double tolerance) {
  var formatter = NumberFormat('0.##');
  return '\u00B1 ' + formatter.format(tolerance * 100) + ' %';
}

RichText formatResistorTemperatureCoefficient(double temperatureCoefficient, TextStyle textStyle) {
  return RichText(
      text: TextSpan(style: textStyle, children: [
    TextSpan(text: temperatureCoefficient.floor().toString() + ' \u00D7 10'),
    superscriptedTextForRichText('-6', textStyle: textStyle),
    const TextSpan(text: ' K'),
    superscriptedTextForRichText('-1', textStyle: textStyle),
  ]));
}

RichText formatResistorMultiplier(double multiplier, TextStyle textStyle) {
  var valueExponential = multiplier.toStringAsExponential().split('e');
  var formatter = NumberFormat('###,###,###,##0.####');

  return RichText(
    text: TextSpan(style: textStyle, children: [
      const TextSpan(text: '\u00D7 10'),
      superscriptedTextForRichText(valueExponential[1].replaceFirst('+', ''), textStyle: textStyle),
      TextSpan(text: ' = ${formatter.format(multiplier).replaceAll(',', ' ')}')
    ]),
  );
}
