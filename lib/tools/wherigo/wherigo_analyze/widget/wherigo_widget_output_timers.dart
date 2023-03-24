part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfTimerData(BuildContext context, WherigoTimerData data) {
  if (wherigoExpertMode) {
    return _buildOutputListTimerDataExpertMode(context, data);
  } else {
    return _buildOutputListTimerDataUserMode(context, data);
  }
}

List<List<String>> _buildOutputListTimerDataUserMode(BuildContext context, WherigoTimerData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.TimerName],
    [i18n(context, 'wherigo_output_description'), data.TimerDescription],
    [i18n(context, 'wherigo_output_duration'), data.TimerDuration + ' ' + i18n(context, 'dates_daycalculator_seconds')],
    [i18n(context, 'wherigo_output_type'), i18n(context, 'wherigo_output_timer_' + data.TimerType + ' s')],
  ];
}

List<List<String>> _buildOutputListTimerDataExpertMode(BuildContext context, WherigoTimerData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.TimerLUAName],
    [i18n(context, 'wherigo_output_id'), data.TimerID],
    [i18n(context, 'wherigo_output_name'), data.TimerName],
    [i18n(context, 'wherigo_output_description'), data.TimerDescription],
    [i18n(context, 'wherigo_output_duration'), data.TimerDuration + ' ' + i18n(context, 'dates_daycalculator_seconds')],
    [i18n(context, 'wherigo_output_type'), i18n(context, 'wherigo_output_timer_' + data.TimerType + ' s')],
    [i18n(context, 'wherigo_output_visible'), i18n(context, 'common_' + data.TimerVisible)],
  ];
}
