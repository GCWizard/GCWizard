part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfCharacterData(BuildContext context, WherigoCharacterData data) {
  List<List<String>> result = [];
  if (wherigoExpertMode) {
    result = _buildOutputListCharacterDataExpertMode(context, data);
  } else {
    result = _buildOutputListCharacterDataUserMode(context, data);
  }

  if (data.CharacterLocation == 'ZonePoint') {
    result.add([
      i18n(context, 'wherigo_output_location'),
      formatCoordOutput(LatLng(data.CharacterZonepoint.Latitude, data.CharacterZonepoint.Longitude),
          defaultCoordinateFormat, defaultEllipsoid)
    ]);
  } else {
    result.add([i18n(context, 'wherigo_output_location'), data.CharacterLocation]);
  }

  return result;
}

List<List<String>> _buildOutputListCharacterDataExpertMode(BuildContext context, WherigoCharacterData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.CharacterLUAName],
    [i18n(context, 'wherigo_output_id'), data.CharacterID],
    [i18n(context, 'wherigo_output_name'), data.CharacterName],
    [i18n(context, 'wherigo_output_description'), data.CharacterDescription],
    [
      i18n(context, 'wherigo_output_medianame'),
      data.CharacterMediaName +
          (data.CharacterMediaName != ''
              ? (NameToObject[data.CharacterMediaName] != null
                  ? ' ⬌ ' + NameToObject[data.CharacterMediaName]!.ObjectName
                  : '')
              : '')
    ],
    [
      i18n(context, 'wherigo_output_iconname'),
      data.CharacterIconName +
          (data.CharacterIconName != ''
              ? (NameToObject[data.CharacterIconName] != null
                  ? ' ⬌ ' + NameToObject[data.CharacterIconName]!.ObjectName
                  : '')
              : '')
    ],
    [
      i18n(context, 'wherigo_output_container'),
      data.CharacterContainer +
          (NameToObject[data.CharacterContainer] != null
              ? ' ⬌ ' + NameToObject[data.CharacterContainer]!.ObjectName
              : '')
    ],
    [i18n(context, 'wherigo_output_gender'), i18n(context, 'wherigo_output_gender_' + data.CharacterGender)],
    [i18n(context, 'wherigo_output_type'), data.CharacterType],
    [i18n(context, 'wherigo_output_visible'), i18n(context, 'common_' + data.CharacterVisible)],
  ];
}

List<List<String>> _buildOutputListCharacterDataUserMode(BuildContext context, WherigoCharacterData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.CharacterName],
    [i18n(context, 'wherigo_output_description'), data.CharacterDescription],
    [i18n(context, 'wherigo_output_type'), data.CharacterType],
  ];
}
