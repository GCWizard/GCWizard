part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfVariables(BuildContext context, WherigoVariableData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.VariableLUAName],
    [i18n(context, 'wherigo_output_text'), data.VariableName],
  ];
}

List<List<String>> _buildOutputListOfVariablesDetails(BuildContext context, WherigoVariableData data) {
  List<List<String>> result = [];

  if (NameToObject[data.VariableName] == null) {
    result = [
      [i18n(context, 'wherigo_output_identifier_no_detail'), '']
    ];
  } else {
    result = [
      [
        i18n(context, 'wherigo_output_identifier_detail_title'),
        NameToObject[data.VariableName]!.ObjectType.toString().split('.')[1]
      ]
    ];

    switch (NameToObject[data.VariableName]!.ObjectType) {
      case WHERIGO_OBJECT_TYPE.CHARACTER:
        result.addAll(_addDetailsCharacter(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.INPUT:
        result.addAll(_addDetailsInput(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.ITEM:
        result.addAll(_addDetailsItem(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.MEDIA:
        result.addAll(_addDetailsMedia(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.TASK:
        result.addAll(_addDetailsTask(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.TIMER:
        result.addAll(_addDetailsTimer(context, data));
        break;
      case WHERIGO_OBJECT_TYPE.ZONE:
        result.addAll(_addDetailsZone(context, data));
        break;
      default:
    }
  }

  return result;
}

List<List<String>> _addDetailsCharacter(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Characters.length; i++) {
    if (WherigoCartridgeLUAData.Characters[i].CharacterLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Characters[i].CharacterID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Characters[i].CharacterName]);
      result.add([
        i18n(context, 'wherigo_output_description'),
        WherigoCartridgeLUAData.Characters[i].CharacterDescription
      ]);
      result.add(
          [i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Characters[i].CharacterMediaName]);
    }
  }
  return result;
}

List<List<String>> _addDetailsTask(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Tasks.length; i++) {
    if (WherigoCartridgeLUAData.Tasks[i].TaskLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Tasks[i].TaskID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Tasks[i].TaskName]);
      result.add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Tasks[i].TaskDescription]);
      result.add([i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Tasks[i].TaskMedia]);
    }
  }
  return result;
}

List<List<String>> _addDetailsMedia(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Media.length; i++) {
    if (WherigoCartridgeLUAData.Media[i].MediaLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Media[i].MediaID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Media[i].MediaName]);
      result.add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Media[i].MediaDescription]);
      result.add([i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Media[i].MediaFilename]);
    }
  }
  return result;
}

List<List<String>> _addDetailsItem(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Items.length; i++) {
    if (WherigoCartridgeLUAData.Items[i].ItemLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Items[i].ItemID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Items[i].ItemName]);
      result.add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Items[i].ItemDescription]);
      result.add([i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Items[i].ItemMedia]);
    }
  }
  return result;
}

List<List<String>> _addDetailsInput(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Inputs.length; i++) {
    if (WherigoCartridgeLUAData.Inputs[i].InputLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Inputs[i].InputID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Inputs[i].InputName]);
      result
          .add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Inputs[i].InputDescription]);
      result.add([i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Inputs[i].InputMedia]);
      result.add([i18n(context, 'wherigo_output_question'), WherigoCartridgeLUAData.Inputs[i].InputText]);
    }
  }
  return result;
}

List<List<String>> _addDetailsTimer(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];

  for (int i = 0; i < WherigoCartridgeLUAData.Timers.length; i++) {
    if (WherigoCartridgeLUAData.Timers[i].TimerLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Timers[i].TimerID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Timers[i].TimerName]);
      result
          .add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Timers[i].TimerDescription]);
      result.add([i18n(context, 'wherigo_output_duration'), WherigoCartridgeLUAData.Timers[i].TimerDuration]);
      result.add([i18n(context, 'wherigo_output_type'), WherigoCartridgeLUAData.Timers[i].TimerType]);
      result.add([i18n(context, 'wherigo_output_visible'), WherigoCartridgeLUAData.Timers[i].TimerVisible]);
    }
  }
  return result;
}

List<List<String>> _addDetailsZone(BuildContext context, WherigoVariableData data){
  List<List<String>> result = [];
  for (int i = 0; i < WherigoCartridgeLUAData.Zones.length; i++) {
    if (WherigoCartridgeLUAData.Zones[i].ZoneLUAName == data.VariableName) {
      result.add([i18n(context, 'wherigo_output_id'), WherigoCartridgeLUAData.Zones[i].ZoneID]);
      result.add([i18n(context, 'wherigo_output_name'), WherigoCartridgeLUAData.Zones[i].ZoneName]);
      result.add([i18n(context, 'wherigo_output_description'), WherigoCartridgeLUAData.Zones[i].ZoneDescription]);
      result.add([i18n(context, 'wherigo_output_medianame'), WherigoCartridgeLUAData.Zones[i].ZoneMediaName]);
    }
  }
  return result;
}
