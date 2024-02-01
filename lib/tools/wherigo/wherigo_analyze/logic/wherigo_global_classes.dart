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

  const WherigoZonePoint({this.Latitude = 0.0, this.Longitude = 0.0, this.Altitude = 0.0});
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

  const WherigoZoneData(
      {required this.ZoneLUAName,
      required this.ZoneID,
      required this.ZoneName,
      required this.ZoneDescription,
      required this.ZoneVisible,
      required this.ZoneMediaName,
      required this.ZoneIconName,
      required this.ZoneActive,
      required this.ZoneDistanceRange,
      required this.ZoneShowObjects,
      required this.ZoneProximityRange,
      required this.ZoneOriginalPoint,
      required this.ZoneDistanceRangeUOM,
      required this.ZoneProximityRangeUOM,
      required this.ZoneOutOfRange,
      required this.ZoneInRange,
      required this.ZonePoints});
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

  const WherigoCharacterData({
    required this.CharacterLUAName,
    required this.CharacterID,
    required this.CharacterName,
    required this.CharacterDescription,
    required this.CharacterVisible,
    required this.CharacterMediaName,
    required this.CharacterIconName,
    required this.CharacterLocation,
    required this.CharacterZonepoint,
    required this.CharacterContainer,
    required this.CharacterGender,
    required this.CharacterType,
  });
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

  const WherigoInputData({
    required this.InputLUAName,
    required this.InputID,
    required this.InputVariableID,
    required this.InputName,
    required this.InputDescription,
    required this.InputVisible,
    required this.InputMedia,
    required this.InputIcon,
    required this.InputType,
    required this.InputText,
    required this.InputChoices,
    required this.InputAnswers,
  });
}

class WherigoAnswer {
  final String InputFunction;
  final List<WherigoAnswerData> InputAnswers;

  WherigoAnswer({
    required this.InputFunction,
    required this.InputAnswers,
  });
}

class WherigoAnswerData {
  final String AnswerAnswer;
  final String AnswerHash;
  final List<WherigoActionMessageElementData> AnswerActions;

  WherigoAnswerData({
    required this.AnswerAnswer,
    required this.AnswerHash,
    required this.AnswerActions,
  });
}

class WherigoActionMessageElementData {
  final WHERIGO_ACTIONMESSAGETYPE ActionMessageType;
  final String ActionMessageContent;

  WherigoActionMessageElementData({
    required this.ActionMessageType,
    required this.ActionMessageContent,
  });
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

  const WherigoTaskData({
    required this.TaskLUAName,
    required this.TaskID,
    required this.TaskName,
    required this.TaskDescription,
    required this.TaskVisible,
    required this.TaskMedia,
    required this.TaskIcon,
    required this.TaskActive,
    required this.TaskComplete,
    required this.TaskCorrectstate,
  });
}

class WherigoMediaData {
  final String MediaLUAName;
  final String MediaID;
  final String MediaName;
  final String MediaDescription;
  final String MediaAltText;
  final String MediaType;
  final String MediaFilename;

  const WherigoMediaData({
    required this.MediaLUAName,
    required this.MediaID,
    required this.MediaName,
    required this.MediaDescription,
    required this.MediaAltText,
    required this.MediaType,
    required this.MediaFilename,
  });
}

class WherigoBuilderVariableData {
  final String BuilderVariableID;
  final String BuilderVariableName;
  final String BuilderVariableType;
  final String BuilderVariableData;
  final String BuilderVariableDescription;

  const WherigoBuilderVariableData(
      {required this.BuilderVariableID,
      required this.BuilderVariableName,
      required this.BuilderVariableType,
      required this.BuilderVariableData,
      required this.BuilderVariableDescription});
}

class WherigoVariableData {
  final String VariableLUAName;
  final String VariableName;

  const WherigoVariableData({required this.VariableLUAName, required this.VariableName});
}

class WherigoObfuscationData {
  final String ObfuscationTable;
  final String ObfuscationName;

  const WherigoObfuscationData({required this.ObfuscationTable, required this.ObfuscationName});
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

  const WherigoItemData({
    required this.ItemLUAName,
    required this.ItemID,
    required this.ItemName,
    required this.ItemDescription,
    required this.ItemVisible,
    required this.ItemMedia,
    required this.ItemIcon,
    required this.ItemLocation,
    required this.ItemZonepoint,
    required this.ItemContainer,
    required this.ItemLocked,
    required this.ItemOpened,
  });
}

class WherigoTimerData {
  final String TimerLUAName;
  final String TimerID;
  final String TimerName;
  final String TimerDescription;
  final String TimerVisible;
  final String TimerDuration;
  final String TimerType;

  const WherigoTimerData({
    required this.TimerLUAName,
    required this.TimerID,
    required this.TimerName,
    required this.TimerDescription,
    required this.TimerVisible,
    required this.TimerDuration,
    required this.TimerType,
  });
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
    required this.Signature,
    required this.NumberOfObjects,
    required this.MediaFilesHeaders,
    required this.MediaFilesContents,
    required this.HeaderLength,
    required this.Splashscreen,
    required this.SplashscreenIcon,
    required this.Latitude,
    required this.Longitude,
    required this.Altitude,
    required this.DateOfCreation,
    required this.TypeOfCartridge,
    required this.Player,
    required this.PlayerID,
    required this.CartridgeLUAName,
    required this.CartridgeGUID,
    required this.CartridgeDescription,
    required this.StartingLocationDescription,
    required this.Version,
    required this.Author,
    required this.Company,
    required this.RecommendedDevice,
    required this.LengthOfCompletionCode,
    required this.CompletionCode,
    required this.ResultStatus,
    required this.ResultsGWC,
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
  final List<WherigoVariableData> Variables;
  final List<WherigoBuilderVariableData> BuilderVariables;
  final Map<String, WherigoObjectData> NameToObject;
  final WHERIGO_ANALYSE_RESULT_STATUS ResultStatus;
  final List<String> ResultsLUA;
  final WherigoZonePoint StartLocation;
  final WHERIGO_BUILDER Builder;
  final String BuilderVersion;
  final String TargetDevice;
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

  const WherigoCartridgeLUA({
    required this.LUAFile,
    required this.CartridgeLUAName,
    required this.CartridgeGUID,
    required this.ObfuscatorTable,
    required this.ObfuscatorFunction,
    required this.Characters,
    required this.Items,
    required this.Tasks,
    required this.Inputs,
    required this.Zones,
    required this.Timers,
    required this.Media,
    required this.Messages,
    required this.Variables,
    required this.BuilderVariables,
    required this.NameToObject,
    required this.ResultStatus,
    required this.ResultsLUA,
    required this.StartLocation,
    required this.Builder,
    required this.BuilderVersion,
    required this.TargetDevice,
    required this.TargetDeviceVersion,
    required this.CountryID,
    required this.StateID,
    required this.UseLogging,
    required this.CreateDate,
    required this.PublishDate,
    required this.UpdateDate,
    required this.LastPlayedDate,
    required this.httpCode,
    required this.httpMessage,
  });
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

class WherigoTest {
  final WherigoCartridgeGWC cartridgeGWC;
  final WherigoTaskData cartridgeTestTask;
  final WherigoTimerData cartridgeTestTimer;
  final WherigoZoneData cartridgeTestZone;
  final WherigoCharacterData cartridgeTestCharacter;
  final WherigoItemData cartridgeTestItem;
  final WherigoInputData cartridgeTestInput;
  final WherigoMediaData cartridgeTestMedia;
  final WherigoObfuscationData cartridgeTestObfuscation;
  final List<WherigoVariableData> cartridgeTestVariable;
  final List<WherigoBuilderVariableData> cartridgeTestBuilderVariable;
  final List<List<WherigoActionMessageElementData>> cartridgeTestMessageDialog;
  final WherigoAnswer cartridgeTestAnswers;

  WherigoTest({
    required this.cartridgeGWC,
    required this.cartridgeTestTask,
    required this.cartridgeTestTimer,
    required this.cartridgeTestZone,
    required this.cartridgeTestCharacter,
    required this.cartridgeTestItem,
    required this.cartridgeTestInput,
    required this.cartridgeTestMedia,
    required this.cartridgeTestObfuscation,
    required this.cartridgeTestVariable,
    required this.cartridgeTestBuilderVariable,
    required this.cartridgeTestMessageDialog,
    required this.cartridgeTestAnswers,
  });
}
