part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<String> WHERIGOerrorMsg_MediaFiles = [];

List<List<String>> WHERIGOoutputHeader = [];

WherigoCartridgeGWC WherigoCartridgeGWCData = _WHERIGO_EMPTYCARTRIDGE_GWC;

WherigoCartridgeLUA WherigoCartridgeLUAData = WHERIGO_EMPTYCARTRIDGE_LUA;

bool WHERIGOExpertMode = false;

Map<String, WherigoObjectData> WHERIGONameToObject = {};

WHERIGO_OBJECT_TYPE WHERIGOcurrentObjectSection = WHERIGO_OBJECT_TYPE.NONE;
