import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

enum WHERIGO {
  NULL,
  GWCFILE,
  HEADER,
  LUAFILE,
  LUABYTECODE,
  CHARACTER,
  ITEMS,
  ZONES,
  INPUTS,
  TASKS,
  TIMERS,
  OBFUSCATORTABLE,
  MEDIAFILES,
  MESSAGES,
  IDENTIFIER,
  RESULTS_GWC,
  RESULTS_LUA
}

const DATA_TYPE_LUA = 'LUA-Sourcecode';
const DATA_TYPE_GWC = 'GWC-Cartridge';

const EXPERT_MODE = true;
const USER_MODE = false;

enum FILE_LOAD_STATE { NULL, GWC, LUA, FULL }

enum BUILDER { EARWIGO, URWIGO, GROUNDSPEAK, WHERIGOKIT, UNKNOWN }

enum ANALYSE_RESULT_STATUS { OK, ERROR_GWC, ERROR_LUA, ERROR_HTTP, NONE }

enum OBJECT_TYPE { MEDIA, CARTRIDGE, ZONE, CHARACTER, ITEM, TASK, VARIABLES, TIMER, INPUT, MESSAGES }

OBJECT_TYPE currentObjectSection;

const MEDIATYPE_UNK = 0;
const MEDIATYPE_BMP = 1;
const MEDIATYPE_PNG = 2;
const MEDIATYPE_JPG = 3;
const MEDIATYPE_GIF = 4;
const MEDIATYPE_WAV = 17;
const MEDIATYPE_MP3 = 18;
const MEDIATYPE_FDL = 19;
const MEDIATYPE_SND = 20;
const MEDIATYPE_OGG = 21;
const MEDIATYPE_SWF = 33;
const MEDIATYPE_TXT = 49;

Map MEDIATYPE = {
  MEDIATYPE_UNK: '<?>',
  MEDIATYPE_BMP: 'bmp',
  MEDIATYPE_PNG: 'png',
  MEDIATYPE_JPG: 'jpg',
  MEDIATYPE_GIF: 'gif',
  MEDIATYPE_WAV: 'wav',
  MEDIATYPE_MP3: 'mp3',
  MEDIATYPE_FDL: 'fdl',
  MEDIATYPE_SND: 'snd',
  MEDIATYPE_OGG: 'ogg',
  MEDIATYPE_SWF: 'swf',
  MEDIATYPE_TXT: 'txt'
};

Map MEDIACLASS = {
  MEDIATYPE_UNK: 'n/a',
  MEDIATYPE_BMP: 'Image',
  MEDIATYPE_PNG: 'Image',
  MEDIATYPE_JPG: 'Image',
  MEDIATYPE_GIF: 'Image',
  MEDIATYPE_WAV: 'Sound',
  MEDIATYPE_MP3: 'Sound',
  MEDIATYPE_FDL: 'Sound',
  MEDIATYPE_SND: 'Sound',
  MEDIATYPE_OGG: 'Sound',
  MEDIATYPE_SWF: 'Video',
  MEDIATYPE_TXT: 'Text'
};

class StringOffset {
  final String ASCIIZ;
  final int offset;

  StringOffset(this.ASCIIZ, this.offset);
}

class MediaFileHeader {
  final int MediaFileID;
  final int MediaFileAddress;

  MediaFileHeader(this.MediaFileID, this.MediaFileAddress);
}

class MediaFileContent {
  final int MediaFileID;
  final int MediaFileType;
  final Uint8List MediaFileBytes;
  final int MediaFileLength;

  MediaFileContent(this.MediaFileID, this.MediaFileType, this.MediaFileBytes, this.MediaFileLength);
}

class ObjectData {
  final String ObjectID;
  final int ObjectIndex;
  final String ObjectName;
  final String ObjectMedia;
  final OBJECT_TYPE ObjectType;

  ObjectData(
    this.ObjectID,
    this.ObjectIndex,
    this.ObjectName,
    this.ObjectMedia,
    this.ObjectType,
  );
}

enum ACTIONMESSAGETYPE { TEXT, IMAGE, BUTTON, COMMAND, CASE }

Map<ACTIONMESSAGETYPE, String> ACTIONMESSAGETYPE_TEXT = {
  ACTIONMESSAGETYPE.TEXT: 'txt',
  ACTIONMESSAGETYPE.IMAGE: 'img',
  ACTIONMESSAGETYPE.BUTTON: 'btn',
  ACTIONMESSAGETYPE.COMMAND: 'cmd',
  ACTIONMESSAGETYPE.CASE: 'cse',
};

Map TEXT_ACTIONMESSAGETYPE = switchMapKeyValue(ACTIONMESSAGETYPE_TEXT);

class ZonePoint {
  final double Latitude;
  final double Longitude;
  final double Altitude;

  ZonePoint(this.Latitude, this.Longitude, this.Altitude);
}

class ZoneData {
  final String ZoneLUAName;
  final String ZoneID;
  final String ZoneName;
  final String ZoneDescription;
  final String ZoneVisible;
  final String ZoneMediaName;
  final String ZoneIconName;
  final String ZoneActive;
  final String ZoneDistanceRange;
  final String ZoneShowObjects;
  final String ZoneProximityRange;
  final ZonePoint ZoneOriginalPoint;
  final String ZoneDistanceRangeUOM;
  final String ZoneProximityRangeUOM;
  final String ZoneOutOfRange;
  final String ZoneInRange;
  final List<ZonePoint> ZonePoints;

  ZoneData(
      this.ZoneLUAName,
      this.ZoneID,
      this.ZoneName,
      this.ZoneDescription,
      this.ZoneVisible,
      this.ZoneMediaName,
      this.ZoneIconName,
      this.ZoneActive,
      this.ZoneDistanceRange,
      this.ZoneShowObjects,
      this.ZoneProximityRange,
      this.ZoneOriginalPoint,
      this.ZoneDistanceRangeUOM,
      this.ZoneProximityRangeUOM,
      this.ZoneOutOfRange,
      this.ZoneInRange,
      this.ZonePoints);
}

class CharacterData {
  final String CharacterLUAName;
  final String CharacterID;
  final String CharacterName;
  final String CharacterDescription;
  final String CharacterVisible;
  final String CharacterMediaName;
  final String CharacterIconName;
  final String CharacterLocation;
  final ZonePoint CharacterZonepoint;
  final String CharacterContainer;
  final String CharacterGender;
  final String CharacterType;

  CharacterData(
      this.CharacterLUAName,
      this.CharacterID,
      this.CharacterName,
      this.CharacterDescription,
      this.CharacterVisible,
      this.CharacterMediaName,
      this.CharacterIconName,
      this.CharacterLocation,
      this.CharacterZonepoint,
      this.CharacterContainer,
      this.CharacterGender,
      this.CharacterType);
}

class InputData {
  final String InputLUAName;
  final String InputID;
  final String InputVariableID;
  final String InputName;
  final String InputDescription;
  final String InputVisible;
  final String InputMedia;
  final String InputIcon;
  final String InputType;
  final String InputText;
  final List<String> InputChoices;
  final List<AnswerData> InputAnswers;

  InputData(
      this.InputLUAName,
      this.InputID,
      this.InputVariableID,
      this.InputName,
      this.InputDescription,
      this.InputVisible,
      this.InputMedia,
      this.InputIcon,
      this.InputType,
      this.InputText,
      this.InputChoices,
      this.InputAnswers);
}

class AnswerData {
  final String AnswerAnswer;
  final String AnswerHash;
  final List<ActionMessageElementData> AnswerActions;

  AnswerData(
    this.AnswerAnswer,
    this.AnswerHash,
    this.AnswerActions,
  );
}

class MessageData {
  final List<List<ActionMessageElementData>> MessageElement;

  MessageData(
    this.MessageElement,
  );
}

class ActionMessageElementData {
  final ACTIONMESSAGETYPE ActionMessageType;
  final String ActionMessageContent;

  ActionMessageElementData(
    this.ActionMessageType,
    this.ActionMessageContent,
  );
}

class TaskData {
  final String TaskLUAName;
  final String TaskID;
  final String TaskName;
  final String TaskDescription;
  final String TaskVisible;
  final String TaskMedia;
  final String TaskIcon;
  final String TaskActive;
  final String TaskComplete;
  final String TaskCorrectstate;

  TaskData(this.TaskLUAName, this.TaskID, this.TaskName, this.TaskDescription, this.TaskVisible, this.TaskMedia,
      this.TaskIcon, this.TaskActive, this.TaskComplete, this.TaskCorrectstate);
}

class MediaData {
  final String MediaLUAName;
  final String MediaID;
  final String MediaName;
  final String MediaDescription;
  final String MediaAltText;
  final String MediaType;
  final String MediaFilename;

  MediaData(this.MediaLUAName, this.MediaID, this.MediaName, this.MediaDescription, this.MediaAltText, this.MediaType,
      this.MediaFilename);
}

class VariableData {
  final String VariableLUAName;
  final String VariableName;

  VariableData(this.VariableLUAName, this.VariableName);
}

class ItemData {
  final String ItemLUAName;
  final String ItemID;
  final String ItemName;
  final String ItemDescription;
  final String ItemVisible;
  final String ItemMedia;
  final String ItemIcon;
  final String ItemLocation;
  final ZonePoint ItemZonepoint;
  final String ItemContainer;
  final String ItemLocked;
  final String ItemOpened;

  ItemData(this.ItemLUAName, this.ItemID, this.ItemName, this.ItemDescription, this.ItemVisible, this.ItemMedia,
      this.ItemIcon, this.ItemLocation, this.ItemZonepoint, this.ItemContainer, this.ItemLocked, this.ItemOpened);
}

class TimerData {
  final String TimerLUAName;
  final String TimerID;
  final String TimerName;
  final String TimerDescription;
  final String TimerVisible;
  final String TimerDuration;
  final String TimerType;

  TimerData(this.TimerLUAName, this.TimerID, this.TimerName, this.TimerDescription, this.TimerVisible,
      this.TimerDuration, this.TimerType);
}

class WherigoCartridgeGWC {
  final String Signature;
  final int NumberOfObjects;
  final List<MediaFileHeader> MediaFilesHeaders;
  final List<MediaFileContent> MediaFilesContents;
  final int HeaderLength;
  final int Splashscreen;
  final int SplashscreenIcon;
  final double Latitude;
  final double Longitude;
  final double Altitude;
  final int DateOfCreation;
  final String TypeOfCartridge;
  final String Player;
  final int PlayerID;
  final String CartridgeLUAName;
  final String CartridgeGUID;
  final String CartridgeDescription;
  final String StartingLocationDescription;
  final String Version;
  final String Author;
  final String Company;
  final String RecommendedDevice;
  final int LengthOfCompletionCode;
  final String CompletionCode;
  final ANALYSE_RESULT_STATUS ResultStatus;
  final List<String> ResultsGWC;

  WherigoCartridgeGWC({
    this.Signature = '',
    this.NumberOfObjects = 0,
    this.MediaFilesHeaders,
    this.MediaFilesContents,
    this.HeaderLength = 0,
    this.Splashscreen = 0,
    this.SplashscreenIcon = 0,
    this.Latitude = 0.0,
    this.Longitude = 0.0,
    this.Altitude = 0.0,
    this.DateOfCreation = 0,
    this.TypeOfCartridge = '',
    this.Player = '',
    this.PlayerID = 0,
    this.CartridgeLUAName = '',
    this.CartridgeGUID = '',
    this.CartridgeDescription = '',
    this.StartingLocationDescription = '',
    this.Version = '',
    this.Author = '',
    this.Company = '',
    this.RecommendedDevice = '',
    this.LengthOfCompletionCode = 0,
    this.CompletionCode = '',
    this.ResultStatus = ANALYSE_RESULT_STATUS.NONE,
    this.ResultsGWC,
  });
}

class WherigoCartridgeLUA {
  final String LUAFile;
  final String CartridgeLUAName;
  final String CartridgeGUID;
  final String ObfuscatorTable;
  final String ObfuscatorFunction;
  final List<CharacterData> Characters;
  final List<ItemData> Items;
  final List<TaskData> Tasks;
  final List<InputData> Inputs;
  final List<ZoneData> Zones;
  final List<TimerData> Timers;
  final List<MediaData> Media;
  final List<List<ActionMessageElementData>> Messages;
  final List<AnswerData> Answers;
  final List<VariableData> Variables;
  final Map<String, ObjectData> NameToObject;
  final ANALYSE_RESULT_STATUS ResultStatus;
  final List<String> ResultsLUA;
  final BUILDER Builder;
  final String BuilderVersion;
  final String TargetDeviceVersion;
  final String StateID;
  final String CountryID;
  final String UseLogging;
  final DateTime CreateDate;
  final DateTime PublishDate;
  final DateTime UpdateDate;
  final DateTime LastPlayedDate;
  final String httpCode;
  final String httpMessage;

  WherigoCartridgeLUA(
      {this.LUAFile = '',
      this.CartridgeLUAName = '',
      this.CartridgeGUID = '',
      this.ObfuscatorTable = '',
      this.ObfuscatorFunction = '',
      this.Characters,
      this.Items,
      this.Tasks,
      this.Inputs,
      this.Zones,
      this.Timers,
      this.Media,
      this.Messages,
      this.Answers,
      this.Variables,
      this.NameToObject,
      this.ResultStatus = ANALYSE_RESULT_STATUS.NONE,
      this.ResultsLUA,
      this.Builder = BUILDER.UNKNOWN,
      this.BuilderVersion = '',
      this.TargetDeviceVersion = '',
      this.CountryID = '',
      this.StateID = '',
      this.UseLogging = '',
      this.CreateDate,
      this.PublishDate,
      this.UpdateDate,
      this.LastPlayedDate,
      this.httpCode = '',
      this.httpMessage = ''});
}

Map<bool, Map<FILE_LOAD_STATE, Map<WHERIGO, String>>> WHERIGO_DATA = {
  EXPERT_MODE: {
    FILE_LOAD_STATE.NULL: {},
    FILE_LOAD_STATE.GWC: WHERIGO_DATA_GWC_EXPERT,
    FILE_LOAD_STATE.LUA: WHERIGO_DATA_LUA_EXPERT,
    FILE_LOAD_STATE.FULL: WHERIGO_DATA_FULL_EXPERT,
  },
  USER_MODE: {
    FILE_LOAD_STATE.NULL: {},
    FILE_LOAD_STATE.GWC: WHERIGO_DATA_GWC_USER,
    FILE_LOAD_STATE.LUA: WHERIGO_DATA_LUA_USER,
    FILE_LOAD_STATE.FULL: WHERIGO_DATA_FULL_USER,
  }
};

Map<WHERIGO, String> WHERIGO_DATA_FULL_EXPERT = {
  WHERIGO.HEADER: 'wherigo_data_header',
  WHERIGO.LUABYTECODE: 'wherigo_data_luabytecode',
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO.GWCFILE: 'wherigo_data_gwc',
  WHERIGO.OBFUSCATORTABLE: 'wherigo_data_obfuscatortable',
  WHERIGO.LUAFILE: 'wherigo_data_lua',
  WHERIGO.ITEMS: 'wherigo_data_item_list',
  WHERIGO.CHARACTER: 'wherigo_data_character_list',
  WHERIGO.ZONES: 'wherigo_data_zone_list',
  WHERIGO.INPUTS: 'wherigo_data_input_list',
  WHERIGO.TASKS: 'wherigo_data_task_list',
  WHERIGO.TIMERS: 'wherigo_data_timer_list',
  WHERIGO.MESSAGES: 'wherigo_data_message_list',
  WHERIGO.IDENTIFIER: 'wherigo_data_identifier_list',
  WHERIGO.RESULTS_GWC: 'wherigo_data_results_gwc',
  WHERIGO.RESULTS_LUA: 'wherigo_data_results_lua',
};

Map<WHERIGO, String> WHERIGO_DATA_GWC_EXPERT = {
  WHERIGO.HEADER: 'wherigo_data_header',
  WHERIGO.LUABYTECODE: 'wherigo_data_luabytecode',
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO.GWCFILE: 'wherigo_data_gwc',
  WHERIGO.RESULTS_GWC: 'wherigo_data_results_gwc',
};

Map<WHERIGO, String> WHERIGO_DATA_LUA_EXPERT = {
  WHERIGO.OBFUSCATORTABLE: 'wherigo_data_obfuscatortable',
  WHERIGO.LUAFILE: 'wherigo_data_lua',
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO.ITEMS: 'wherigo_data_item_list',
  WHERIGO.CHARACTER: 'wherigo_data_character_list',
  WHERIGO.ZONES: 'wherigo_data_zone_list',
  WHERIGO.INPUTS: 'wherigo_data_input_list',
  WHERIGO.TASKS: 'wherigo_data_task_list',
  WHERIGO.TIMERS: 'wherigo_data_timer_list',
  WHERIGO.MESSAGES: 'wherigo_data_message_list',
  WHERIGO.IDENTIFIER: 'wherigo_data_identifier_list',
  WHERIGO.RESULTS_LUA: 'wherigo_data_results_lua',
};

Map<WHERIGO, String> WHERIGO_DATA_FULL_USER = {
  WHERIGO.HEADER: 'wherigo_data_header',
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO.RESULTS_GWC: 'wherigo_data_results_gwc',
  WHERIGO.ITEMS: 'wherigo_data_item_list',
  WHERIGO.CHARACTER: 'wherigo_data_character_list',
  WHERIGO.ZONES: 'wherigo_data_zone_list',
  WHERIGO.INPUTS: 'wherigo_data_input_list',
  WHERIGO.MESSAGES: 'wherigo_data_message_list',
};

Map<WHERIGO, String> WHERIGO_DATA_GWC_USER = {
  WHERIGO.HEADER: 'wherigo_data_header',
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
};

Map<WHERIGO, String> WHERIGO_DATA_LUA_USER = {
  WHERIGO.MEDIAFILES: 'wherigo_data_mediafiles',
  WHERIGO.ITEMS: 'wherigo_data_item_list',
  WHERIGO.CHARACTER: 'wherigo_data_character_list',
  WHERIGO.ZONES: 'wherigo_data_zone_list',
  WHERIGO.INPUTS: 'wherigo_data_input_list',
  WHERIGO.MESSAGES: 'wherigo_data_message_list',
};

final Map<String, String> HTTP_STATUS = {
  '200': 'wherigo_http_code_200',
  '400': 'wherigo_http_code_400',
  '404': 'wherigo_http_code_404',
  '413': 'wherigo_http_code_413',
  '500': 'wherigo_http_code_500',
  '503': 'wherigo_http_code_503',
};

final Map<String, TextStyle> WHERIGO_SYNTAX_HIGHLIGHT_STRINGMAP = {
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
