part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

List<List<String>> _buildOutputListOfZoneData(BuildContext context, WherigoZoneData data) {
  List<List<String>> result = [];
  if (WHERIGOExpertMode) {
    result = _buildOutputListOfZoneDataExpertMode(context, data);
  } else {
    result = _buildOutputListOfZoneDataUserMode(context, data);
  }

  for (var point in data.ZonePoints) {
    result.add(
        ['', formatCoordOutput(LatLng(point.Latitude, point.Longitude), defaultCoordinateFormat, defaultEllipsoid)]);
  }
  return result;
}

List<List<String>> _buildOutputListOfZoneDataUserMode(BuildContext context, WherigoZoneData data) {
  return [
    [i18n(context, 'wherigo_output_name'), data.ZoneName],
    [i18n(context, 'wherigo_output_description'), data.ZoneDescription],
    [
      i18n(context, 'wherigo_output_originalpoint'),
      formatCoordOutput(LatLng(data.ZoneOriginalPoint.Latitude, data.ZoneOriginalPoint.Longitude),
          defaultCoordinateFormat, defaultEllipsoid)
    ],
    [i18n(context, 'wherigo_output_zonepoints'), ''],
  ];
}

List<List<String>> _buildOutputListOfZoneDataExpertMode(BuildContext context, WherigoZoneData data) {
  return [
    [i18n(context, 'wherigo_output_luaname'), data.ZoneLUAName],
    [i18n(context, 'wherigo_output_id'), data.ZoneID],
    [i18n(context, 'wherigo_output_name'), data.ZoneName],
    [i18n(context, 'wherigo_output_description'), data.ZoneDescription],
    [i18n(context, 'wherigo_output_visible'), i18n(context, 'common_' + data.ZoneVisible)],
    [
      i18n(context, 'wherigo_output_medianame'),
      data.ZoneMediaName +
          (data.ZoneMediaName != ''
              ? (WHERIGONameToObject[data.ZoneMediaName] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.ZoneMediaName]!.ObjectName
                  : '')
              : '')
    ],
    [
      i18n(context, 'wherigo_output_iconname'),
      data.ZoneIconName +
          (data.ZoneIconName != ''
              ? (WHERIGONameToObject[data.ZoneIconName] != null
                  ? ' ⬌ ' + WHERIGONameToObject[data.ZoneIconName]!.ObjectName
                  : '')
              : '')
    ],
    [i18n(context, 'wherigo_output_active'), i18n(context, 'common_' + data.ZoneActive)],
    [i18n(context, 'wherigo_output_showobjects'), data.ZoneShowObjects],
    [i18n(context, 'wherigo_output_distancerange'), data.ZoneDistanceRange],
    [i18n(context, 'wherigo_output_distancerangeuom'), data.ZoneDistanceRangeUOM],
    [i18n(context, 'wherigo_output_proximityrange'), data.ZoneProximityRange],
    [i18n(context, 'wherigo_output_proximityrangeuom'), data.ZoneProximityRangeUOM],
    [i18n(context, 'wherigo_output_outofrange'), data.ZoneOutOfRange],
    [i18n(context, 'wherigo_output_inrange'), data.ZoneInRange],
    [
      i18n(context, 'wherigo_output_originalpoint'),
      formatCoordOutput(LatLng(data.ZoneOriginalPoint.Latitude, data.ZoneOriginalPoint.Longitude),
          defaultCoordinateFormat, defaultEllipsoid)
    ],
    [i18n(context, 'wherigo_output_zonepoints'), ''],
  ];
}
