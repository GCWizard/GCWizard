part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<String> errorMsg_MediaFiles = [];

List<List<String>> outputHeader = [];

WherigoCartridgeGWC WherigoCartridgeGWCData = const WherigoCartridgeGWC(
    MediaFilesHeaders: [],
    MediaFilesContents: [], ResultsGWC: []);

WherigoCartridgeLUA WherigoCartridgeLUAData = const WherigoCartridgeLUA(
    Characters: [],
    Items: [],
    Tasks: [],
    Inputs: [],
    Zones: [],
    Timers: [],
    Media: [],
    Messages: [],
    Answers: [],
    Variables: [],
    NameToObject: {},
    ResultsLUA: []);

bool wherigoExpertMode = false;

Map<String, WherigoObjectData> NameToObject = {};

WHERIGO_OBJECT_TYPE currentObjectSection = WHERIGO_OBJECT_TYPE.NONE;

