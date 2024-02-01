part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<WherigoBuilderVariableData> _analyzeAndExtractBuilderVariableSectionData(List<String> lines) {
  List<WherigoBuilderVariableData> result = [];
  String varName = '';
  String varID = '';
  String varType = '';
  String varDescription = '';
  String varData = '';
  int i = 0;
  while (i < lines.length) {
    if (lines[i].trim().startsWith('buildervar.')) {
      varName = lines[i]
          .replaceAll('buildervar.', '')
          .replaceAll('=', '')
          .replaceAll(' ', '')
          .replaceAll('{', '')
          .replaceAll('}', '');

      varID = lines[i + 1]
          .replaceAll('buildervar.', '')
          .replaceAll(varName + '.Id', '')
          .replaceAll('=', '')
          .replaceAll(' ', '')
          .replaceAll('"', '');

      varType = lines[i + 3]
          .replaceAll('buildervar.', '')
          .replaceAll(varName + '.Type', '')
          .replaceAll('=', '')
          .replaceAll(' ', '')
          .replaceAll('"', '');

      varData = lines[i + 4]
          .replaceAll('buildervar.', '')
          .replaceAll(varName + '.Data', '')
          .replaceAll('=', '')
          .replaceAll(' ', '')
          .replaceAll('"', '');

      if ((i + 5) < lines.length && lines[i + 5].contains('Description')) {
        varDescription = lines[i + 5]
            .replaceAll('buildervar.', '')
            .replaceAll(varName + '.Description', '')
            .replaceAll(' = ', '')
            .replaceAll('"', '');
        i = i + 5;
      } else {
        varDescription = '';
        i = i + 4;
      }
      result.add(WherigoBuilderVariableData(
          BuilderVariableID: varID,
          BuilderVariableName: varName,
          BuilderVariableType: varType,
          BuilderVariableData: varData,
          BuilderVariableDescription: varDescription));
    }
    i++;
  }
  return result;
}
