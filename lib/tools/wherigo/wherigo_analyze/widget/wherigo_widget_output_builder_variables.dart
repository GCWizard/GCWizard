part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfBuilderVariables(BuildContext context, WherigoBuilderVariableData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.BuilderVariableName],
    [i18n(context, 'wherigo_output_id'), data.BuilderVariableID],
    [i18n(context, 'wherigo_output_type'), data.BuilderVariableType],
    [i18n(context, 'wherigo_output_data'), data.BuilderVariableData],
    [i18n(context, 'wherigo_output_description'), data.BuilderVariableDescription],
  ];
}
