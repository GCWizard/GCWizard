part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/widget/wherigo_analyze.dart';

void buildHeader(BuildContext context) {
  if (WHERIGOExpertMode) {
    WHERIGOoutputHeader = _buildHeaderExpertMode(context);
  } else {
    WHERIGOoutputHeader = _buildHeaderUserMode(context);
  }
}

List<List<String>> _buildHeaderUserMode(BuildContext context) {
  return [
    [i18n(context, 'wherigo_header_numberofmediafiles'), (WherigoCartridgeGWCData.NumberOfObjects - 1).toString()],
    [
      i18n(context, 'wherigo_output_location'),
      formatCoordOutput(LatLng(WherigoCartridgeGWCData.Latitude, WherigoCartridgeGWCData.Longitude),
          defaultCoordinateFormat, defaultEllipsoid)
    ],
    [i18n(context, 'wherigo_header_altitude'), WherigoCartridgeGWCData.Altitude.toString()],
    [i18n(context, 'wherigo_header_typeofcartridge'), WherigoCartridgeGWCData.TypeOfCartridge],
    [i18n(context, 'wherigo_header_player'), WherigoCartridgeGWCData.Player],
    [
      i18n(context, 'wherigo_header_completion'),
      (WherigoCartridgeGWCData.CompletionCode.length > 15)
          ? WherigoCartridgeGWCData.CompletionCode.substring(0, 15)
          : WherigoCartridgeGWCData.CompletionCode
    ],
    [
      i18n(context, 'wherigo_header_cartridgename'),
      WherigoCartridgeGWCData.CartridgeLUAName.isEmpty
          ? WherigoCartridgeLUAData.CartridgeLUAName
          : WherigoCartridgeGWCData.CartridgeLUAName
    ],
    [i18n(context, 'wherigo_header_cartridgedescription'), WherigoCartridgeGWCData.CartridgeDescription],
    [i18n(context, 'wherigo_header_startinglocation'), WherigoCartridgeGWCData.StartingLocationDescription],
    [
      i18n(context, 'wherigo_header_creationdate') + ' (GWC)',
      _getCreationDate(context, WherigoCartridgeGWCData.DateOfCreation)
    ],
    [i18n(context, 'wherigo_header_author'), WherigoCartridgeGWCData.Author],
  ];
}

List<List<String>> _buildHeaderExpertMode(BuildContext context) {
  List<List<String>> header = [
    [i18n(context, 'wherigo_header_signature'), WherigoCartridgeGWCData.Signature],
    [i18n(context, 'wherigo_header_numberofmediafiles'), (WherigoCartridgeGWCData.NumberOfObjects - 1).toString()],
    [
      i18n(context, 'wherigo_output_location'),
      formatCoordOutput(LatLng(WherigoCartridgeGWCData.Latitude, WherigoCartridgeGWCData.Longitude),
          defaultCoordinateFormat, defaultEllipsoid)
    ],
    [i18n(context, 'wherigo_header_altitude'), WherigoCartridgeGWCData.Altitude.toString()],
    [i18n(context, 'wherigo_header_typeofcartridge'), WherigoCartridgeGWCData.TypeOfCartridge],
    [i18n(context, 'wherigo_header_splashicon'), WherigoCartridgeGWCData.SplashscreenIcon.toString()],
    [i18n(context, 'wherigo_header_splashscreen'), WherigoCartridgeGWCData.Splashscreen.toString()],
    [i18n(context, 'wherigo_header_player'), WherigoCartridgeGWCData.Player],
    [i18n(context, 'wherigo_header_playerid'), WherigoCartridgeGWCData.PlayerID.toString()],
    [
      i18n(context, 'wherigo_header_completion'),
      (WherigoCartridgeGWCData.CompletionCode.length > 15)
          ? WherigoCartridgeGWCData.CompletionCode.substring(0, 15)
          : WherigoCartridgeGWCData.CompletionCode
    ],
    [i18n(context, 'wherigo_header_lengthcompletion'), WherigoCartridgeGWCData.LengthOfCompletionCode.toString()],
    [i18n(context, 'wherigo_header_completion_full'), WherigoCartridgeGWCData.CompletionCode],
    [
      i18n(context, 'wherigo_header_cartridgename'),
      WherigoCartridgeGWCData.CartridgeLUAName.isEmpty
          ? WherigoCartridgeLUAData.CartridgeLUAName
          : WherigoCartridgeGWCData.CartridgeLUAName
    ],
    [
      i18n(context, 'wherigo_header_cartridgeguid'),
      WherigoCartridgeGWCData.CartridgeGUID.isEmpty
          ? WherigoCartridgeLUAData.CartridgeGUID
          : WherigoCartridgeGWCData.CartridgeGUID
    ],
    [i18n(context, 'wherigo_header_cartridgedescription'), WherigoCartridgeGWCData.CartridgeDescription],
    [
      i18n(context, 'wherigo_header_startinglocation'),
      WherigoCartridgeGWCData.StartingLocationDescription +
          '\n' +
          formatCoordOutput(
              LatLng(WherigoCartridgeLUAData.StartLocation.Latitude, WherigoCartridgeLUAData.StartLocation.Longitude),
              defaultCoordinateFormat,
              defaultEllipsoid)
    ],
    [i18n(context, 'wherigo_header_state'), WherigoCartridgeLUAData.StateID],
    [i18n(context, 'wherigo_header_country'), WherigoCartridgeLUAData.CountryID],
    [i18n(context, 'wherigo_header_version'), WherigoCartridgeGWCData.Version],
    [
      i18n(context, 'wherigo_header_creationdate') + ' (GWC)',
      _getCreationDate(context, WherigoCartridgeGWCData.DateOfCreation)
    ],
    [i18n(context, 'wherigo_header_creationdate') + ' (LUA)', _formatDate(context, WherigoCartridgeLUAData.CreateDate)],
    [i18n(context, 'wherigo_header_publish'), _formatDate(context, WherigoCartridgeLUAData.PublishDate)],
    [i18n(context, 'wherigo_header_update'), _formatDate(context, WherigoCartridgeLUAData.UpdateDate)],
    [i18n(context, 'wherigo_header_lastplayed'), _formatDate(context, WherigoCartridgeLUAData.LastPlayedDate)],
    [i18n(context, 'wherigo_header_author'), WherigoCartridgeGWCData.Author],
    [i18n(context, 'wherigo_header_company'), WherigoCartridgeGWCData.Company],
    [
      i18n(context, 'wherigo_header_device'),
      WherigoCartridgeGWCData.RecommendedDevice + '\n' + WherigoCartridgeLUAData.TargetDevice
    ],
    [i18n(context, 'wherigo_header_deviceversion'), WherigoCartridgeLUAData.TargetDeviceVersion],
    [i18n(context, 'wherigo_header_logging'), i18n(context, 'common_' + WherigoCartridgeLUAData.UseLogging)]
  ];
  switch (WherigoCartridgeLUAData.Builder) {
    case WHERIGO_BUILDER.EARWIGO:
      header.add([i18n(context, 'wherigo_header_builder'), 'Earwigo Webbuilder']);
      break;
    case WHERIGO_BUILDER.URWIGO:
      header.add([i18n(context, 'wherigo_header_builder'), 'Urwigo']);
      break;
    case WHERIGO_BUILDER.UNKNOWN:
      header.add([i18n(context, 'wherigo_header_builder'), i18n(context, 'wherigo_header_builder_unknown')]);
      break;
    case WHERIGO_BUILDER.WHERIGOKIT:
      header.add([i18n(context, 'wherigo_header_builder'), 'Wherigo Kit']);
      break;
    case WHERIGO_BUILDER.GROUNDSPEAK:
      header.add([i18n(context, 'wherigo_header_builder'), 'Groundspeak']);
      break;

    default:
      {}
  }
  header.add([i18n(context, 'wherigo_header_version'), WherigoCartridgeLUAData.BuilderVersion]);
  return header;
}
