part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfTaskData(BuildContext context, WherigoTaskData data) {
  if (WHERIGOExpertMode) {
    return _buildOutputListTaskDataExpertMode(context, data);
  } else {
    return _buildOutputListTaskDataUserMode(context, data);
  }
}

List<List<String>> _buildOutputListTaskDataExpertMode(BuildContext context, WherigoTaskData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.TaskLUAName],
    [i18n(context, 'wherigo_output_id'), data.TaskID],
    [i18n(context, 'wherigo_output_name'), data.TaskName],
    [i18n(context, 'wherigo_output_description'), data.TaskDescription],
    [i18n(context, 'wherigo_output_visible'), i18n(context, 'common_' + data.TaskVisible)],
    [
      i18n(context, 'wherigo_output_medianame'),
      data.TaskMedia +
          (data.TaskMedia != ''
              ? (WHERIGONameToObject[data.TaskMedia] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.TaskMedia]!.ObjectName
                  : '')
              : '')
    ],
    [
      i18n(context, 'wherigo_output_iconname'),
      data.TaskIcon +
          (data.TaskIcon != ''
              ? (WHERIGONameToObject[data.TaskIcon] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.TaskIcon]!.ObjectName
                  : '')
              : '')
    ],
    [i18n(context, 'wherigo_output_active'), i18n(context, 'common_' + data.TaskActive)],
    [i18n(context, 'wherigo_output_complete'), i18n(context, 'common_' + data.TaskComplete)],
    [i18n(context, 'wherigo_output_correctstate'), data.TaskCorrectstate]
  ];
}

List<List<String>> _buildOutputListTaskDataUserMode(BuildContext context, WherigoTaskData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.TaskName],
    [i18n(context, 'wherigo_output_description'), data.TaskDescription],
  ];
}
