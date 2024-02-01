part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

const bool _WHERIGO_EXPERT_MODE = true;
const bool _WHERIGO_USER_MODE = false;

const int _WHERIGO_MEDIATYPE_UNK = 0;
const int _WHERIGO_MEDIATYPE_BMP = 1;
const int _WHERIGO_MEDIATYPE_PNG = 2;
const int _WHERIGO_MEDIATYPE_JPG = 3;
const int _WHERIGO_MEDIATYPE_GIF = 4;
const int _WHERIGO_MEDIATYPE_WAV = 17;
const int _WHERIGO_MEDIATYPE_MP3 = 18;
const int _WHERIGO_MEDIATYPE_FDL = 19;
const int _WHERIGO_MEDIATYPE_SND = 20;
const int _WHERIGO_MEDIATYPE_OGG = 21;
const int _WHERIGO_MEDIATYPE_SWF = 33;
const int _WHERIGO_MEDIATYPE_TXT = 49;

const Map<int, String> WHERIGO_MEDIATYPE = {
  _WHERIGO_MEDIATYPE_UNK: UNKNOWN_ELEMENT,
  _WHERIGO_MEDIATYPE_BMP: 'bmp',
  _WHERIGO_MEDIATYPE_PNG: 'png',
  _WHERIGO_MEDIATYPE_JPG: 'jpg',
  _WHERIGO_MEDIATYPE_GIF: 'gif',
  _WHERIGO_MEDIATYPE_WAV: 'wav',
  _WHERIGO_MEDIATYPE_MP3: 'mp3',
  _WHERIGO_MEDIATYPE_FDL: 'fdl',
  _WHERIGO_MEDIATYPE_SND: 'snd',
  _WHERIGO_MEDIATYPE_OGG: 'ogg',
  _WHERIGO_MEDIATYPE_SWF: 'swf',
  _WHERIGO_MEDIATYPE_TXT: 'txt'
};

const Map<int, String> WHERIGO_MEDIACLASS = {
  _WHERIGO_MEDIATYPE_UNK: 'n/a',
  _WHERIGO_MEDIATYPE_BMP: 'Image',
  _WHERIGO_MEDIATYPE_PNG: 'Image',
  _WHERIGO_MEDIATYPE_JPG: 'Image',
  _WHERIGO_MEDIATYPE_GIF: 'Image',
  _WHERIGO_MEDIATYPE_WAV: 'Sound',
  _WHERIGO_MEDIATYPE_MP3: 'Sound',
  _WHERIGO_MEDIATYPE_FDL: 'Sound',
  _WHERIGO_MEDIATYPE_SND: 'Sound',
  _WHERIGO_MEDIATYPE_OGG: 'Sound',
  _WHERIGO_MEDIATYPE_SWF: 'Video',
  _WHERIGO_MEDIATYPE_TXT: 'Text'
};

const Map<WHERIGO_ACTIONMESSAGETYPE, String> _WHERIGO_ACTIONMESSAGETYPE_TEXT = {
  WHERIGO_ACTIONMESSAGETYPE.TEXT: 'txt',
  WHERIGO_ACTIONMESSAGETYPE.IMAGE: 'img',
  WHERIGO_ACTIONMESSAGETYPE.BUTTON: 'btn',
  WHERIGO_ACTIONMESSAGETYPE.COMMAND: 'cmd',
  WHERIGO_ACTIONMESSAGETYPE.CASE: 'cse',
};

Map<String, WHERIGO_ACTIONMESSAGETYPE> WHERIGO_TEXT_ACTIONMESSAGETYPE =
    switchMapKeyValue(_WHERIGO_ACTIONMESSAGETYPE_TEXT);

const String WHERIGO_NULLDATE = '0-01-01 00:00:00.000';
const WherigoZonePoint WHERIGO_NULLPOINT = WherigoZonePoint();

const Map<bool, Map<WHERIGO_FILE_LOAD_STATE, Map<WHERIGO_OBJECT, String>>> WHERIGO_DROPDOWN_DATA = {
  _WHERIGO_EXPERT_MODE: {
    WHERIGO_FILE_LOAD_STATE.NULL: {},
    WHERIGO_FILE_LOAD_STATE.GWC: _WHERIGO_DATA_GWC_EXPERT,
    WHERIGO_FILE_LOAD_STATE.LUA: _WHERIGO_DATA_LUA_EXPERT,
    WHERIGO_FILE_LOAD_STATE.FULL: _WHERIGO_DATA_FULL_EXPERT,
  },
  _WHERIGO_USER_MODE: {
    WHERIGO_FILE_LOAD_STATE.NULL: {},
    WHERIGO_FILE_LOAD_STATE.GWC: _WHERIGO_DATA_GWC_USER,
    WHERIGO_FILE_LOAD_STATE.LUA: _WHERIGO_DATA_LUA_USER,
    WHERIGO_FILE_LOAD_STATE.FULL: _WHERIGO_DATA_FULL_USER,
  }
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_FULL_EXPERT = {
  WHERIGO_OBJECT.HEADER: 'wherigo_data_header',
  WHERIGO_OBJECT.LUABYTECODE: 'wherigo_data_luabytecode',
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO_OBJECT.GWCFILE: 'wherigo_data_gwc',
  WHERIGO_OBJECT.OBFUSCATORTABLE: 'wherigo_data_obfuscatortable',
  WHERIGO_OBJECT.LUAFILE: 'wherigo_data_lua',
  WHERIGO_OBJECT.ITEMS: 'wherigo_data_item_list',
  WHERIGO_OBJECT.CHARACTER: 'wherigo_data_character_list',
  WHERIGO_OBJECT.ZONES: 'wherigo_data_zone_list',
  WHERIGO_OBJECT.INPUTS: 'wherigo_data_input_list',
  WHERIGO_OBJECT.TASKS: 'wherigo_data_task_list',
  WHERIGO_OBJECT.TIMERS: 'wherigo_data_timer_list',
  WHERIGO_OBJECT.MESSAGES: 'wherigo_data_message_list',
  WHERIGO_OBJECT.VARIABLES: 'wherigo_data_identifier_list',
  WHERIGO_OBJECT.BUILDERVARIABLES: 'wherigo_data_builder_identifier_list',
  WHERIGO_OBJECT.RESULTS_GWC: 'wherigo_data_results_gwc',
  WHERIGO_OBJECT.RESULTS_LUA: 'wherigo_data_results_lua',
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_GWC_EXPERT = {
  WHERIGO_OBJECT.HEADER: 'wherigo_data_header',
  WHERIGO_OBJECT.LUABYTECODE: 'wherigo_data_luabytecode',
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO_OBJECT.GWCFILE: 'wherigo_data_gwc',
  WHERIGO_OBJECT.RESULTS_GWC: 'wherigo_data_results_gwc',
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_LUA_EXPERT = {
  WHERIGO_OBJECT.OBFUSCATORTABLE: 'wherigo_data_obfuscatortable',
  WHERIGO_OBJECT.LUAFILE: 'wherigo_data_lua',
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO_OBJECT.ITEMS: 'wherigo_data_item_list',
  WHERIGO_OBJECT.CHARACTER: 'wherigo_data_character_list',
  WHERIGO_OBJECT.ZONES: 'wherigo_data_zone_list',
  WHERIGO_OBJECT.INPUTS: 'wherigo_data_input_list',
  WHERIGO_OBJECT.TASKS: 'wherigo_data_task_list',
  WHERIGO_OBJECT.TIMERS: 'wherigo_data_timer_list',
  WHERIGO_OBJECT.MESSAGES: 'wherigo_data_message_list',
  WHERIGO_OBJECT.VARIABLES: 'wherigo_data_identifier_list',
  WHERIGO_OBJECT.BUILDERVARIABLES: 'wherigo_data_builder_identifier_list',
  WHERIGO_OBJECT.RESULTS_LUA: 'wherigo_data_results_lua',
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_FULL_USER = {
  WHERIGO_OBJECT.HEADER: 'wherigo_data_header',
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO_OBJECT.RESULTS_GWC: 'wherigo_data_results_gwc',
  WHERIGO_OBJECT.ITEMS: 'wherigo_data_item_list',
  WHERIGO_OBJECT.CHARACTER: 'wherigo_data_character_list',
  WHERIGO_OBJECT.ZONES: 'wherigo_data_zone_list',
  WHERIGO_OBJECT.INPUTS: 'wherigo_data_input_list',
  WHERIGO_OBJECT.MESSAGES: 'wherigo_data_message_list',
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_GWC_USER = {
  WHERIGO_OBJECT.HEADER: 'wherigo_data_header',
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
};

const Map<WHERIGO_OBJECT, String> _WHERIGO_DATA_LUA_USER = {
  WHERIGO_OBJECT.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO_OBJECT.ITEMS: 'wherigo_data_item_list',
  WHERIGO_OBJECT.CHARACTER: 'wherigo_data_character_list',
  WHERIGO_OBJECT.ZONES: 'wherigo_data_zone_list',
  WHERIGO_OBJECT.INPUTS: 'wherigo_data_input_list',
  WHERIGO_OBJECT.MESSAGES: 'wherigo_data_message_list',
};

const Map<int, String> WHERIGO_HTTP_STATUS = {
  // https://api.dart.dev/stable/2.19.2/dart-html/HttpStatus-class.html
  // https://de.wikipedia.org/wiki/HTTP-Statuscode
  // https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  // https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
  100: 'wherigo_http_code_exception',
  101: 'wherigo_http_code_exception',
  102: 'wherigo_http_code_exception',
  103: 'wherigo_http_code_exception',
  200: 'wherigo_http_code_200',
  201: 'wherigo_http_code_exception',
  202: 'wherigo_http_code_exception',
  204: 'wherigo_http_code_exception',
  205: 'wherigo_http_code_exception',
  206: 'wherigo_http_code_exception',
  207: 'wherigo_http_code_exception',
  208: 'wherigo_http_code_exception',
  226: 'wherigo_http_code_exception',
  301: 'wherigo_http_code_exception',
  302: 'wherigo_http_code_exception',
  303: 'wherigo_http_code_exception',
  304: 'wherigo_http_code_exception',
  305: 'wherigo_http_code_exception',
  307: 'wherigo_http_code_exception',
  308: 'wherigo_http_code_exception',
  400: 'wherigo_http_code_400',
  401: 'wherigo_http_code_401',
  402: 'wherigo_http_code_exception',
  403: 'wherigo_http_code_exception',
  404: 'wherigo_http_code_404',
  405: 'wherigo_http_code_exception',
  406: 'wherigo_http_code_exception',
  407: 'wherigo_http_code_exception',
  408: 'wherigo_http_code_exception',
  409: 'wherigo_http_code_exception',
  410: 'wherigo_http_code_exception',
  411: 'wherigo_http_code_exception',
  412: 'wherigo_http_code_exception',
  413: 'wherigo_http_code_413',
  414: 'wherigo_http_code_exception',
  415: 'wherigo_http_code_exception',
  416: 'wherigo_http_code_exception',
  417: 'wherigo_http_code_exception',
  418: 'wherigo_http_code_418',
  420: 'wherigo_http_code_exception',
  421: 'wherigo_http_code_exception',
  422: 'wherigo_http_code_exception',
  423: 'wherigo_http_code_exception',
  424: 'wherigo_http_code_exception',
  425: 'wherigo_http_code_exception',
  426: 'wherigo_http_code_exception',
  428: 'wherigo_http_code_exception',
  429: 'wherigo_http_code_exception',
  431: 'wherigo_http_code_exception',
  444: 'wherigo_http_code_444',
  451: 'wherigo_http_code_exception',
  460: 'wherigo_http_code_exception',
  463: 'wherigo_http_code_exception',
  494: 'wherigo_http_code_exception',
  495: 'wherigo_http_code_exception',
  496: 'wherigo_http_code_exception',
  497: 'wherigo_http_code_exception',
  499: 'wherigo_http_code_exception',
  500: 'wherigo_http_code_500',
  501: 'wherigo_http_code_exception',
  502: 'wherigo_http_code_exception',
  503: 'wherigo_http_code_503',
  504: 'wherigo_http_code_exception',
  505: 'wherigo_http_code_exception',
  506: 'wherigo_http_code_exception',
  507: 'wherigo_http_code_exception',
  508: 'wherigo_http_code_exception',
  509: 'wherigo_http_code_exception',
  510: 'wherigo_http_code_exception',
  511: 'wherigo_http_code_exception',
  520: 'wherigo_http_code_exception',
  521: 'wherigo_http_code_exception',
  522: 'wherigo_http_code_exception',
  523: 'wherigo_http_code_exception',
  524: 'wherigo_http_code_exception',
  525: 'wherigo_http_code_exception',
  526: 'wherigo_http_code_exception',
  527: 'wherigo_http_code_exception',
  529: 'wherigo_http_code_exception',
  530: 'wherigo_http_code_exception',
  561: 'wherigo_http_code_exception',
  598: 'wherigo_http_code_exception',
  599: 'wherigo_http_code_exception',
};

const int _WHERIGO_HTTP_CODE_OK = 200;

const Map<String, TextStyle> WHERIGO_SYNTAX_HIGHLIGHT_STRINGMAP = {
  // fontWeight: FontWeight.bold
  // fontStyle: FontStyle.italic
  "function": TextStyle(color: Colors.purple),
  "if": TextStyle(color: Colors.purple),
  "then": TextStyle(color: Colors.purple),
  "else": TextStyle(color: Colors.purple),
  "end": TextStyle(color: Colors.purple),
  "return": TextStyle(color: Colors.purple),
  "Dialog": TextStyle(color: Colors.red),
  "MessageBox": TextStyle(color: Colors.red),
  "Wherigo.ZMedia": TextStyle(color: Colors.red),
  "Wherigo.ZCharacter": TextStyle(color: Colors.red),
  "Wherigo.Zone": TextStyle(color: Colors.red),
  "Wherigo.ZItem": TextStyle(color: Colors.red),
  "Wherigo.ZTask": TextStyle(color: Colors.red),
  "Wherigo.ZTimer": TextStyle(color: Colors.red),
  ".ZVariables": TextStyle(color: Colors.red),
  "Wherigo.ZCartridge": TextStyle(color: Colors.red),
  "OnEnter": TextStyle(color: Colors.blue),
  "OnExit": TextStyle(color: Colors.blue),
  "OnGetInput": TextStyle(color: Colors.blue),
  "MoveTo": TextStyle(color: Colors.blue),
  "Id": TextStyle(color: Colors.orange),
  "Type": TextStyle(color: Colors.orange),
  "ZonePoint": TextStyle(color: Colors.orange),
  "Filename": TextStyle(color: Colors.orange),
  "Text": TextStyle(color: Colors.orange),
  "Media": TextStyle(color: Colors.orange),
  "Name": TextStyle(color: Colors.orange),
  "Description": TextStyle(color: Colors.orange),
  "Choices": TextStyle(color: Colors.orange),
};

const WherigoCartridgeLUA WHERIGO_EMPTYCARTRIDGE_LUA = WherigoCartridgeLUA(
    LUAFile: '',
    CartridgeLUAName: '',
    CartridgeGUID: '',
    ObfuscatorTable: '',
    ObfuscatorFunction: '',
    Characters: [],
    Items: [],
    Tasks: [],
    Inputs: [],
    Zones: [],
    Timers: [],
    Media: [],
    Messages: [],
    //Answers: [],
    Variables: [],
    BuilderVariables: [],
    NameToObject: {},
    ResultStatus: WHERIGO_ANALYSE_RESULT_STATUS.NONE,
    ResultsLUA: [],
    Builder: WHERIGO_BUILDER.UNKNOWN,
    BuilderVersion: '',
    TargetDevice: '',
    TargetDeviceVersion: '',
    StartLocation: WherigoZonePoint(),
    CountryID: '',
    StateID: '',
    UseLogging: '',
    CreateDate: WHERIGO_NULLDATE,
    PublishDate: WHERIGO_NULLDATE,
    UpdateDate: WHERIGO_NULLDATE,
    LastPlayedDate: WHERIGO_NULLDATE,
    httpCode: 0,
    httpMessage: '');
const WherigoCartridgeGWC _WHERIGO_EMPTYCARTRIDGE_GWC = WherigoCartridgeGWC(
  Signature: '',
  NumberOfObjects: 0,
  MediaFilesHeaders: [],
  MediaFilesContents: [],
  HeaderLength: 0,
  Splashscreen: 0,
  SplashscreenIcon: 0,
  Latitude: 0.0,
  Longitude: 0.0,
  Altitude: 0.0,
  DateOfCreation: 0,
  TypeOfCartridge: '',
  Player: '',
  PlayerID: 0,
  CartridgeLUAName: '',
  CartridgeGUID: '',
  CartridgeDescription: '',
  StartingLocationDescription: '',
  Version: '',
  Author: '',
  Company: '',
  RecommendedDevice: '',
  LengthOfCompletionCode: 0,
  CompletionCode: '',
  ResultStatus: WHERIGO_ANALYSE_RESULT_STATUS.NONE,
  ResultsGWC: [],
);
const WherigoTaskData _WHERIGO_EMPTYTESTTASK_LUA = WherigoTaskData(
  TaskLUAName: '',
  TaskID: '',
  TaskName: '',
  TaskDescription: '',
  TaskVisible: '',
  TaskMedia: '',
  TaskIcon: '',
  TaskActive: '',
  TaskComplete: '',
  TaskCorrectstate: '',
);
const WherigoZoneData _WHERIGO_EMPTYTESTZONE_LUA = WherigoZoneData(
  ZoneLUAName: '',
  ZoneID: '',
  ZoneName: '',
  ZoneDescription: '',
  ZoneVisible: '',
  ZoneMediaName: '',
  ZoneIconName: '',
  ZoneActive: '',
  ZoneDistanceRange: '',
  ZoneShowObjects: '',
  ZoneProximityRange: '',
  ZoneOriginalPoint: WherigoZonePoint(),
  ZoneDistanceRangeUOM: '',
  ZoneProximityRangeUOM: '',
  ZoneOutOfRange: '',
  ZoneInRange: '',
  ZonePoints: [],
);
const WherigoItemData _WHERIGO_EMPTYTESTITEM_LUA = WherigoItemData(
  ItemLUAName: '',
  ItemID: '',
  ItemName: '',
  ItemDescription: '',
  ItemVisible: '',
  ItemMedia: '',
  ItemIcon: '',
  ItemLocation: '',
  ItemZonepoint: WherigoZonePoint(),
  ItemContainer: '',
  ItemLocked: '',
  ItemOpened: '',
);
const WherigoMediaData _WHERIGO_EMPTYTESTMEDIA_LUA = WherigoMediaData(
  MediaLUAName: '',
  MediaID: '',
  MediaName: '',
  MediaDescription: '',
  MediaAltText: '',
  MediaType: '',
  MediaFilename: '',
);
const WherigoCharacterData _WHERIGO_EMPTYTESTCHARACTER_LUA = WherigoCharacterData(
  CharacterLUAName: '',
  CharacterID: '',
  CharacterName: '',
  CharacterDescription: '',
  CharacterVisible: '',
  CharacterMediaName: '',
  CharacterIconName: '',
  CharacterLocation: '',
  CharacterZonepoint: WherigoZonePoint(),
  CharacterContainer: '',
  CharacterGender: '',
  CharacterType: '',
);
const WherigoTimerData _WHERIGO_EMPTYTESTTIMER_LUA = WherigoTimerData(
  TimerLUAName: '',
  TimerID: '',
  TimerName: '',
  TimerDescription: '',
  TimerVisible: '',
  TimerDuration: '',
  TimerType: '',
);
const WherigoInputData _WHERIGO_EMPTYTESTINPUT_LUA = WherigoInputData(
  InputLUAName: '',
  InputID: '',
  InputVariableID: '',
  InputName: '',
  InputDescription: '',
  InputVisible: '',
  InputMedia: '',
  InputIcon: '',
  InputType: '',
  InputText: '',
  InputChoices: [],
  InputAnswers: [],
);
const WherigoObfuscationData _WHERIGO_EMPTYTESTOBFUSCATION_LUA = WherigoObfuscationData(
  ObfuscationTable: '',
  ObfuscationName: '',
);
WherigoAnswer _WHERIGO_EMPTYTESTANSWER_LUA = WherigoAnswer(
  InputFunction: '',
  InputAnswers: [],
);
