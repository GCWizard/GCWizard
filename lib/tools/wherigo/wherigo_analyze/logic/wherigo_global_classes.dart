part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

class WherigoStringOffset {
  final String ASCIIZ;
  final int offset;

  WherigoStringOffset(this.ASCIIZ, this.offset);
}

class WherigoMediaFileHeader {
  final int MediaFileID;
  final int MediaFileAddress;

  WherigoMediaFileHeader(this.MediaFileID, this.MediaFileAddress);
}

class WherigoMediaFileContent {
  final int MediaFileID;
  final int MediaFileType;
  final Uint8List MediaFileBytes;
  final int MediaFileLength;

  WherigoMediaFileContent(this.MediaFileID, this.MediaFileType, this.MediaFileBytes, this.MediaFileLength);
}

class WherigoObjectData {
  final String ObjectID;
  final int ObjectIndex;
  final String ObjectName;
  final String ObjectMedia;
  final WHERIGO_OBJECT_TYPE ObjectType;

  WherigoObjectData(
    this.ObjectID,
    this.ObjectIndex,
    this.ObjectName,
    this.ObjectMedia,
    this.ObjectType,
  );
}

class WherigoZonePoint {
  final double Latitude;
  final double Longitude;
  final double Altitude;

  WherigoZonePoint(this.Latitude, this.Longitude, this.Altitude);
}

class WherigoZoneData {
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
  final WherigoZonePoint ZoneOriginalPoint;
  final String ZoneDistanceRangeUOM;
  final String ZoneProximityRangeUOM;
  final String ZoneOutOfRange;
  final String ZoneInRange;
  final List<WherigoZonePoint> ZonePoints;

  WherigoZoneData(
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

class WherigoCharacterData {
  final String CharacterLUAName;
  final String CharacterID;
  final String CharacterName;
  final String CharacterDescription;
  final String CharacterVisible;
  final String CharacterMediaName;
  final String CharacterIconName;
  final String CharacterLocation;
  final WherigoZonePoint CharacterZonepoint;
  final String CharacterContainer;
  final String CharacterGender;
  final String CharacterType;

  WherigoCharacterData(
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

class WherigoInputData {
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
  final List<WherigoAnswerData> InputAnswers;

  WherigoInputData(
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

class WherigoAnswer {
  final String InputFunction;
  final List<WherigoAnswerData> InputAnswers;

  WherigoAnswer(
    this.InputFunction,
    this.InputAnswers,
  );
}

class WherigoAnswerData {
  final String AnswerAnswer;
  final String AnswerHash;
  final List<WherigoActionMessageElementData> AnswerActions;

  WherigoAnswerData(
    this.AnswerAnswer,
    this.AnswerHash,
    this.AnswerActions,
  );
}

class WherigoMessageData {
  final List<List<WherigoActionMessageElementData>> MessageElement;

  WherigoMessageData(
    this.MessageElement,
  );
}

class WherigoActionMessageElementData {
  final WHERIGO_ACTIONMESSAGETYPE ActionMessageType;
  final String ActionMessageContent;

  WherigoActionMessageElementData(
    this.ActionMessageType,
    this.ActionMessageContent,
  );
}

class WherigoTaskData {
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

  WherigoTaskData(this.TaskLUAName, this.TaskID, this.TaskName, this.TaskDescription, this.TaskVisible, this.TaskMedia,
      this.TaskIcon, this.TaskActive, this.TaskComplete, this.TaskCorrectstate);
}

class WherigoMediaData {
  final String MediaLUAName;
  final String MediaID;
  final String MediaName;
  final String MediaDescription;
  final String MediaAltText;
  final String MediaType;
  final String MediaFilename;

  WherigoMediaData(this.MediaLUAName, this.MediaID, this.MediaName, this.MediaDescription, this.MediaAltText,
      this.MediaType, this.MediaFilename);
}

class WherigoVariableData {
  final String VariableLUAName;
  final String VariableName;

  WherigoVariableData(this.VariableLUAName, this.VariableName);
}

class WherigoItemData {
  final String ItemLUAName;
  final String ItemID;
  final String ItemName;
  final String ItemDescription;
  final String ItemVisible;
  final String ItemMedia;
  final String ItemIcon;
  final String ItemLocation;
  final WherigoZonePoint ItemZonepoint;
  final String ItemContainer;
  final String ItemLocked;
  final String ItemOpened;

  WherigoItemData(this.ItemLUAName, this.ItemID, this.ItemName, this.ItemDescription, this.ItemVisible, this.ItemMedia,
      this.ItemIcon, this.ItemLocation, this.ItemZonepoint, this.ItemContainer, this.ItemLocked, this.ItemOpened);
}

class WherigoTimerData {
  final String TimerLUAName;
  final String TimerID;
  final String TimerName;
  final String TimerDescription;
  final String TimerVisible;
  final String TimerDuration;
  final String TimerType;

  WherigoTimerData(this.TimerLUAName, this.TimerID, this.TimerName, this.TimerDescription, this.TimerVisible,
      this.TimerDuration, this.TimerType);
}

class WherigoCartridgeGWC {
  final String Signature;
  final int NumberOfObjects;
  final List<WherigoMediaFileHeader> MediaFilesHeaders;
  final List<WherigoMediaFileContent> MediaFilesContents;
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
  final WHERIGO_ANALYSE_RESULT_STATUS ResultStatus;
  final List<String> ResultsGWC;

  const WherigoCartridgeGWC({
    this.Signature = '',
    this.NumberOfObjects = 0,
    this.MediaFilesHeaders = const [],
    this.MediaFilesContents = const [],
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
    this.ResultStatus = WHERIGO_ANALYSE_RESULT_STATUS.NONE,
    this.ResultsGWC = const [],
  });
}

class WherigoCartridgeLUA {
  final String LUAFile;
  final String CartridgeLUAName;
  final String CartridgeGUID;
  final String ObfuscatorTable;
  final String ObfuscatorFunction;
  final List<WherigoCharacterData> Characters;
  final List<WherigoItemData> Items;
  final List<WherigoTaskData> Tasks;
  final List<WherigoInputData> Inputs;
  final List<WherigoZoneData> Zones;
  final List<WherigoTimerData> Timers;
  final List<WherigoMediaData> Media;
  final List<List<WherigoActionMessageElementData>> Messages;
  final List<WherigoAnswerData> Answers;
  final List<WherigoVariableData> Variables;
  final Map<String, WherigoObjectData> NameToObject;
  final WHERIGO_ANALYSE_RESULT_STATUS ResultStatus;
  final List<String> ResultsLUA;
  final WHERIGO_BUILDER Builder;
  final String BuilderVersion;
  final String TargetDeviceVersion;
  final String StateID;
  final String CountryID;
  final String UseLogging;
  final String CreateDate;
  final String PublishDate;
  final String UpdateDate;
  final String LastPlayedDate;
  final int httpCode;
  final String httpMessage;

  const WherigoCartridgeLUA(
      {this.LUAFile = '',
      this.CartridgeLUAName = '',
      this.CartridgeGUID = '',
      this.ObfuscatorTable = '',
      this.ObfuscatorFunction = '',
      this.Characters = const [],
      this.Items =
          const [], // TODO Thomas: Gave the lists init values to keep it null-safe. Please check if it makes sense from logic point of view
      // from a logic point of view initial values do not make any sense
      this.Tasks = const [],
      this.Inputs = const [],
      this.Zones = const [],
      this.Timers = const [],
      this.Media = const [],
      this.Messages = const [],
      this.Answers = const [],
      this.Variables = const [],
      this.NameToObject = const {},
      this.ResultStatus = WHERIGO_ANALYSE_RESULT_STATUS.NONE,
      this.ResultsLUA = const [],
      this.Builder = WHERIGO_BUILDER.UNKNOWN,
      this.BuilderVersion = '',
      this.TargetDeviceVersion = '',
      this.CountryID = '',
      this.StateID = '',
      this.UseLogging = '',
      this.CreateDate = WHERIGO_NULLDATE,
      this.PublishDate = WHERIGO_NULLDATE,
      this.UpdateDate = WHERIGO_NULLDATE,
      this.LastPlayedDate = WHERIGO_NULLDATE,
      this.httpCode = 0,
      this.httpMessage = ''});
}

class WherigoCartridge {
  final WherigoCartridgeGWC cartridgeGWC;
  final WherigoCartridgeLUA cartridgeLUA;

  WherigoCartridge({this.cartridgeGWC = _WHERIGO_EMPTYCARTRIDGE_GWC, this.cartridgeLUA = WHERIGO_EMPTYCARTRIDGE_LUA});
}

class WherigoJobData {
  final Uint8List jobDataBytes;
  final bool jobDataMode;
  final WHERIGO_CARTRIDGE_DATA_TYPE jobDataType;

  WherigoJobData({
    required this.jobDataBytes,
    required this.jobDataMode,
    required this.jobDataType,
  });
}
