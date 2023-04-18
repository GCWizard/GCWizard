part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<String> errorMsg_MediaFiles = [];

List<List<String>> outputHeader = [];

WherigoCartridgeGWC WherigoCartridgeGWCData = _WHERIGO_EMPTYCARTRIDGE_GWC;

WherigoCartridgeLUA WherigoCartridgeLUAData = WHERIGO_EMPTYCARTRIDGE_LUA;

bool wherigoExpertMode = false;

Map<String, WherigoObjectData> NameToObject = {};

WHERIGO_OBJECT_TYPE currentObjectSection = WHERIGO_OBJECT_TYPE.NONE;

