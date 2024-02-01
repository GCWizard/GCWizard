part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfInputData(BuildContext context, WherigoInputData data) {
  if (WHERIGOExpertMode) {
    return _buildOutputListInputDataExpertMode(context, data);
  } else {
    return _buildOutputListInputDataUserMode(context, data);
  }
}

List<List<String>> _buildOutputListInputDataExpertMode(BuildContext context, WherigoInputData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.InputLUAName],
    [i18n(context, 'wherigo_output_id'), data.InputID],
    [i18n(context, 'wherigo_output_name'), data.InputName],
    [i18n(context, 'wherigo_output_description'), data.InputDescription],
    [
      i18n(context, 'wherigo_output_medianame'),
      data.InputMedia +
          (data.InputMedia != ''
              ? (WHERIGONameToObject[data.InputMedia] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.InputMedia]!.ObjectName
                  : '')
              : '')
    ],
    [i18n(context, 'wherigo_output_text'), data.InputText],
    [i18n(context, 'wherigo_output_type'), data.InputType],
    [i18n(context, 'wherigo_output_variableid'), data.InputVariableID],
    [i18n(context, 'wherigo_output_choices'), data.InputChoices.join('\n')],
    [i18n(context, 'wherigo_output_visible'), i18n(context, 'common_' + data.InputVisible)],
  ];
}

List<List<String>> _buildOutputListInputDataUserMode(BuildContext context, WherigoInputData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.InputName],
    [i18n(context, 'wherigo_output_description'), data.InputDescription],
    [i18n(context, 'wherigo_output_text'), data.InputText],
    [i18n(context, 'wherigo_output_type'), data.InputType],
    [i18n(context, 'wherigo_output_choices'), data.InputChoices.join('\n')],
  ];
}
