part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfItemData(BuildContext context, WherigoItemData data) {
  List<List<String>> result = [];
  if (WHERIGOExpertMode) {
    result = _buildOutputListOfItemDataExpertMode(context, data);
  } else {
    result = _buildOutputListOfItemDataUserMode(context, data);
  }

  if (data.ItemLocation == 'ZonePoint') {
    result.add([
      i18n(context, 'wherigo_output_location'),
      formatCoordOutput(
          LatLng(data.ItemZonepoint.Latitude, data.ItemZonepoint.Longitude), defaultCoordinateFormat, defaultEllipsoid)
    ]);
  } else {
    result.add([i18n(context, 'wherigo_output_location'), data.ItemLocation]);
  }

  result.add([
    i18n(context, 'wherigo_output_container'),
    data.ItemContainer +
        (data.ItemContainer != ''
            ? (WHERIGONameToObject[data.ItemContainer] != null
                ? ' ⬌ ' + WHERIGONameToObject[data.ItemContainer]!.ObjectName
                : '')
            : '')
  ]);
  return result;
}

List<List<String>> _buildOutputListOfItemDataUserMode(BuildContext context, WherigoItemData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.ItemName],
    [i18n(context, 'wherigo_output_description'), data.ItemDescription],
  ];
}

List<List<String>> _buildOutputListOfItemDataExpertMode(BuildContext context, WherigoItemData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.ItemLUAName],
    [i18n(context, 'wherigo_output_id'), data.ItemID],
    [i18n(context, 'wherigo_output_name'), data.ItemName],
    [i18n(context, 'wherigo_output_description'), data.ItemDescription],
    [i18n(context, 'wherigo_output_visible'), data.ItemVisible],
    [
      i18n(context, 'wherigo_output_medianame'),
      data.ItemMedia +
          (data.ItemMedia != ''
              ? (WHERIGONameToObject[data.ItemMedia] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.ItemMedia]!.ObjectName
                  : '')
              : '')
    ],
    [
      i18n(context, 'wherigo_output_iconname'),
      data.ItemIcon +
          (data.ItemIcon != ''
              ? (WHERIGONameToObject[data.ItemIcon] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.ItemIcon]!.ObjectName
                  : '')
              : '')
    ],
    [i18n(context, 'wherigo_output_locked'), data.ItemLocked],
    [i18n(context, 'wherigo_output_opened'), data.ItemOpened],
  ];
}
