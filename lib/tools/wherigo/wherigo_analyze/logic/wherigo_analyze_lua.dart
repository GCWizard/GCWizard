part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

String _LUAFile = '';

String _CartridgeLUAName = '';

String _obfuscatorTable = '';
String _obfuscatorFunction = 'NO_OBFUSCATOR';
bool _obfuscatorFound = false;

String _LUACartridgeName = '';
String _LUACartridgeGUID = '';
String _BuilderVersion = '';
String _TargetDeviceVersion = '';
String _CountryID = '';
String _StateID = '';
String _UseLogging = '';
String _CreateDate = WHERIGO_NULLDATE;
String _PublishDate = WHERIGO_NULLDATE;
String _UpdateDate = WHERIGO_NULLDATE;
String _LastPlayedDate = WHERIGO_NULLDATE;
WHERIGO_BUILDER _builder = WHERIGO_BUILDER.UNKNOWN;

int httpCode = 0;
String httpMessage = '';

bool _sectionMessages = true;

bool _sectionAnalysed = false;

String _answerVariable = '';

List<WherigoInputData> _cartridgeInputs = [];
List<List<WherigoActionMessageElementData>> _cartridgeMessages = [];
List<WherigoAnswerData> _cartridgeAnswers = [];
List<WherigoVariableData> _cartridgeVariables = [];
Map<String, WherigoObjectData> _cartridgeNameToObject = {};

List<String> _LUAAnalyzeResults = [];
WHERIGO_ANALYSE_RESULT_STATUS _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.OK;

String _LUAname = '';
String _container = '';

List<String> _declaration = [];

List<WherigoActionMessageElementData> _singleMessageDialog = [];

String _inputObject = '';
List<WherigoInputData> _resultInputs = [];

List<WherigoActionMessageElementData> _answerActions = [];
List<String> _answerList = [];
String _answerHash = '';
// TODO Thomas As all of such constructions, please use explicit class types for values which make it better to check for Nullability
// this is not feasibla at this point. Because if there is no input then there will be no answer.
// This construction eases the access to answers. Otherwise the list of answers will be repeatedly searched for the correct answers corresponding with the input
Map<String, List<WherigoAnswerData>> _Answers = {};
// class WherigoAnswer {
//   final String InputFunction;
//   final List<WherigoAnswerData> InputAnswers;
//
//   WherigoAnswer(
//     this.InputFunction,
//     this.InputAnswers,
//   );
// }
// List<WherigoAnswer> _Answers = [];

Future<WherigoCartridge> getCartridgeLUA(Uint8List byteListLUA, bool getLUAonline, {SendPort? sendAsyncPort}) async {
  WHERIGO_FILE_LOAD_STATE _LUAchecksToDo = WHERIGO_FILE_LOAD_STATE.NULL;
  if (getLUAonline) {
    // Code snippet for accessing REST API
    // https://medium.com/nerd-for-tech/multipartrequest-in-http-for-sending-images-videos-via-post-request-in-flutter-e689a46471ab
    try {
      await _getDecompiledLUAFileFromServer(byteListLUA);
    } catch (exception) {
      //SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.178.93, port = 57582
      httpCode = 503;
      httpMessage = exception.toString();
    } // end catch exception
    if (httpCode != _WHERIGO_HTTP_CODE_OK) {
      return WherigoCartridge(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeLUA: _faultyWherigoCartridgeLUA(_LUAFile, WHERIGO_ANALYSE_RESULT_STATUS.ERROR_HTTP,
            ['wherigo_http_code', WHERIGO_HTTP_STATUS[httpCode] ?? ''], httpCode, httpMessage),
      );
    }
  } // end if not offline
  else {
    _LUAFile = String.fromCharCodes(byteListLUA);
  }

  _LUAFile = _normalizeLUAmultiLineText(_LUAFile);

  _LUAchecksToDo = WHERIGO_FILE_LOAD_STATE.LUA;

  if (_LUAchecksToDo == WHERIGO_FILE_LOAD_STATE.NULL) {
    _LUAAnalyzeResults.add('wherigo_error_empty_lua');
    return WherigoCartridge(
        cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
        cartridgeLUA:
            _faultyWherigoCartridgeLUA('', WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA, _LUAAnalyzeResults, 0, ''));
  }

  _checkAndGetWherigoBuilder();

  _checkAndGetObfuscatorWWBorGSUB();

  List<String> lines = _LUAFile.split('\n');

  if (!_obfuscatorFound) _checkAndGetObfuscatorURWIGO(lines);

  if (_obfuscatorFound) {
    _deObfuscateAllTexts();
  }

  // ----------------------------------------------------------------------------------------------------------------
  // get all objects - Messages and Dialogs will be analyzed in a second parse
  // - name of cartridge
  // - Media Objects
  // - cartridge meta data
  // - Zones
  // - Characters
  // - Items
  // - Tasks
  // - Variables
  // - Timer
  // - Inputs
  // - Answers
  //
  List<WherigoCharacterData> _cartridgeCharacters = [];
  List<WherigoItemData> _cartridgeItems = [];
  List<WherigoTaskData> _cartridgeTasks = [];
  List<WherigoZoneData> _cartridgeZones = [];
  List<WherigoTimerData> _cartridgeTimers = [];
  List<WherigoMediaData> _cartridgeMedia = [];

  bool _sectionVariables = true;

  int index = 0;
  int progress = 0;
  int progressStep = max(lines.length ~/ 200, 1); // 2 * 100 steps
  List<String> analyzeLines = [];

  lines = _LUAFile.split('\n');
  for (int i = 0; i < lines.length; i++) {
    lines[i] = lines[i].trim();

    if (sendAsyncPort != null && (i % progressStep == 0)) {
      sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
    }

    _checkAndGetCartridgeName(lines[i]);
    _checkAndGetCartridgeMetaData(lines[i]);

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Media Object
    //
    try {
      if (RegExp(r'(Wherigo.ZMedia\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.MEDIA;
        analyzeLines = [];
       _LUAname = getLUAName(lines[i]);
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionMedia(lines[i + 1]) && (i < lines.length - 1));

        WherigoMediaData cartridgeMediaData = _analyzeAndExtractMediaSectionData(analyzeLines);
        _cartridgeMedia.add(cartridgeMediaData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(cartridgeMediaData.MediaID, index,
            cartridgeMediaData.MediaName, cartridgeMediaData.MediaName, WHERIGO_OBJECT_TYPE.MEDIA);
      } // end if line hasmatch zmedia
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_media', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Zone Object
    //
    try {
      if (RegExp(r'( Wherigo.Zone\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.ZONE;
        analyzeLines = [];
        _LUAname = getLUAName(lines[i]);
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionZone(lines[i + 1]) && (i < lines.length - 1));

        WherigoZoneData cartridgeZoneData = _analyzeAndExtractZoneSectionData(analyzeLines);

        _cartridgeZones.add(cartridgeZoneData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(cartridgeZoneData.ZoneID, 0, cartridgeZoneData.ZoneName,
            cartridgeZoneData.ZoneMediaName, WHERIGO_OBJECT_TYPE.ZONE);
      }
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_zones', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Character Object
    //
    try {
      if (RegExp(r'( Wherigo.ZCharacter\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.CHARACTER;
        _LUAname = getLUAName(lines[i]);
        _container = getContainer(lines[i]);
        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionCharacter(lines[i + 1]) && (i < lines.length - 1));

        WherigoCharacterData cartridgeCharacterData = _analyzeAndExtractCharacterSectionData(analyzeLines, _container);

        _cartridgeCharacters.add(cartridgeCharacterData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(
            cartridgeCharacterData.CharacterID,
            0,
            cartridgeCharacterData.CharacterName,
            cartridgeCharacterData.CharacterMediaName,
            WHERIGO_OBJECT_TYPE.CHARACTER);
      } // end if
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_characters', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Item Object
    //
    try {
      if (RegExp(r'( Wherigo.ZItem\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.ITEM;
        _LUAname = getLUAName(lines[i]);
        _container = getContainer(lines[i]);
        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionItem(lines[i + 1]) && (i < lines.length - 1));

        WherigoItemData cartridgeItemData = _analyzeAndExtractItemSectionData(analyzeLines, _container);

        _cartridgeItems.add(cartridgeItemData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(cartridgeItemData.ItemID, 0, cartridgeItemData.ItemName,
            cartridgeItemData.ItemMedia, WHERIGO_OBJECT_TYPE.ITEM);
      } // end if
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_items', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Task Object
    //
    try {
      if (RegExp(r'( Wherigo.ZTask\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.TASK;
        _LUAname = getLUAName(lines[i]);
        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionTask(lines[i + 1]) && (i < lines.length - 1));

        WherigoTaskData cartridgeTaskData = _analyzeAndExtractTaskSectionData(analyzeLines);

        _cartridgeTasks.add(cartridgeTaskData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(cartridgeTaskData.TaskID, 0, cartridgeTaskData.TaskName,
            cartridgeTaskData.TaskMedia, WHERIGO_OBJECT_TYPE.TASK);
      } // end if task
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_tasks', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Variables Object
    //
    try {
      if (RegExp(r'(.ZVariables =)').hasMatch(lines[i])) {
        _sectionVariables = true;
        currentObjectSection = WHERIGO_OBJECT_TYPE.VARIABLES;
        if (lines[i + 1].trim().startsWith('buildervar')) {
          _declaration = lines[i]
              .replaceAll(_CartridgeLUAName + '.ZVariables', '')
              .replaceAll('{', '')
              .replaceAll('}', '')
              .split('=');
          if (_declaration[1].startsWith(_obfuscatorFunction)) {
            // content is obfuscated
            _cartridgeVariables.add(WherigoVariableData(
                _declaration[1].trim(),
                deobfuscateUrwigoText(
                    _declaration[2].replaceAll(_obfuscatorFunction, '').replaceAll('("', '').replaceAll('")', ''),
                    _obfuscatorTable)));
          } else {
            _cartridgeVariables.add(// content not obfuscated
                WherigoVariableData(_declaration[1].trim(), _declaration[2].replaceAll('"', '')));
          }
        }
        i++;
        lines[i] = lines[i].trim();
        do {
          _declaration = lines[i].trim().replaceAll(',', '').replaceAll(' ', '').split('=');
          if (_declaration.length == 2) {
            if (_declaration[1].startsWith(_obfuscatorFunction)) {
              // content is obfuscated
              _cartridgeVariables.add(WherigoVariableData(
                  _declaration[0].trim(),
                  deobfuscateUrwigoText(
                      _declaration[1].replaceAll(_obfuscatorFunction, '').replaceAll('("', '').replaceAll('")', ''),
                      _obfuscatorTable)));
            } else {
              _cartridgeVariables.add(// content not obfuscated
                  WherigoVariableData(_declaration[0].trim(), _declaration[1].replaceAll('"', '')));
            }
          } else {
            _cartridgeVariables.add(WherigoVariableData(_declaration[0].trim(), ''));
          }

          i++;
          lines[i] = lines[i].trim();
          if (lines[i].trim() == '}' || lines[i].trim().startsWith('buildervar')) _sectionVariables = false;
        } while ((i < lines.length - 1) && _sectionVariables);
      }
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_identifiers', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Timer Object
    //
    try {
      if (RegExp(r'( Wherigo.ZTimer\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.TIMER;
        _LUAname = getLUAName(lines[i]);
        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionTimer(lines[i + 1]) && (i < lines.length - 1));

        WherigoTimerData cartridgeTimerData = _analyzeAndExtractTimerSectionData(analyzeLines);

        _cartridgeTimers.add(cartridgeTimerData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(
            cartridgeTimerData.TimerID, 0, cartridgeTimerData.TimerName, '', WHERIGO_OBJECT_TYPE.TIMER);
      }
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_timers', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get Input Object
    //
    try {
      if (RegExp(r'( Wherigo.ZInput\()').hasMatch(lines[i])) {
        currentObjectSection = WHERIGO_OBJECT_TYPE.INPUT;
        _LUAname = getLUAName(lines[i]);
        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i]);
          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionInput(lines[i + 1]) && (i < lines.length - 1));

        WherigoInputData cartridgeInputData = _analyzeAndExtractInputSectionData(analyzeLines);

        _cartridgeInputs.add(cartridgeInputData);
        _cartridgeNameToObject[_LUAname] = WherigoObjectData(cartridgeInputData.InputID, 0,
            cartridgeInputData.InputName, cartridgeInputData.InputMedia, WHERIGO_OBJECT_TYPE.INPUT);
      } // end if lines[i] hasMatch Wherigo.ZInput - Input-Object
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_inputs', exception));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // search and get all Answers - these are part of the function <InputObject>:OnGetInput(input)
    //
    try {
      if (lines[i].trimRight().endsWith(':OnGetInput(input)')) {
        // function for getting all inputs for an input object found

        _inputObject = '';
        _answerActions = [];
        _answerVariable = '';

        // getting name of input function
        _inputObject = lines[i].replaceAll('function ', '').replaceAll(':OnGetInput(input)', '').trim();
        _Answers[_inputObject] = [];

        analyzeLines = [];
        do {
          i++;
          analyzeLines.add(lines[i].trim());

          if (sendAsyncPort != null && (i % progressStep == 0)) {
            sendAsyncPort.send(DoubleText('progress', i / lines.length / 2));
          }
        } while (_insideSectionOnGetInput(lines[i], lines[i + 1]) && (i < lines.length - 1));
        _analyzeAndExtractOnGetInputSectionData(analyzeLines);
      } // end if identify input function
    } catch (exception) {
      _LUAAnalyzeStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_LUA;
      _LUAAnalyzeResults.addAll(addExceptionErrorMessage(i, 'wherigo_error_lua_answers', exception));
    }
  } // end of first parse - for i = 0 to lines.length

  // ------------------------------------------------------------------------------------------------------------------
  // Save Answers to Input Objects
  //
  for (var inputObject in _cartridgeInputs) {
    // _Answers.forEach((answer) {
    //   if (answer.InputLUAName == inputObject.InputLUAName) {
    //     _resultInputs.add(WherigoInputData(
    //         inputObject.InputLUAName,
    //         inputObject.InputID,
    //         inputObject.InputVariableID,
    //         inputObject.InputName,
    //         inputObject.InputDescription,
    //         inputObject.InputVisible,
    //         inputObject.InputMedia,
    //         inputObject.InputIcon,
    //         inputObject.InputType,
    //         inputObject.InputText,
    //         inputObject.InputChoices,
    //         answer.InputAnswers));
    //   }
    //   }
    // });
    _resultInputs.add(WherigoInputData(
        inputObject.InputLUAName,
        inputObject.InputID,
        inputObject.InputVariableID,
        inputObject.InputName,
        inputObject.InputDescription,
        inputObject.InputVisible,
        inputObject.InputMedia,
        inputObject.InputIcon,
        inputObject.InputType,
        inputObject.InputText,
        inputObject.InputChoices,
        // TODO Thomas I can not check if logically correct to send empty list as exception. However this can be removed when using explicit values
        // it is logically correct. If there is no input then there will be no answer
        _Answers[inputObject.InputLUAName] ?? []));
  }
  _cartridgeInputs = _resultInputs;

  // ----------------------------------------------------------------------------------------------------------------
  // second parse
  _getAllMessagesAndDialogsFromLUA(progress, lines, sendAsyncPort, progressStep);

  return WherigoCartridge(
      cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC,
      cartridgeLUA: WherigoCartridgeLUA(
        LUAFile: _LUAFile,
        CartridgeLUAName: _LUACartridgeName,
        CartridgeGUID: _LUACartridgeGUID,
        ObfuscatorTable: _obfuscatorTable,
        ObfuscatorFunction: _obfuscatorFunction,
        Characters: _cartridgeCharacters,
        Items: _cartridgeItems,
        Tasks: _cartridgeTasks,
        Inputs: _cartridgeInputs,
        Zones: _cartridgeZones,
        Timers: _cartridgeTimers,
        Media: _cartridgeMedia,
        Messages: _cartridgeMessages,
        Answers: _cartridgeAnswers,
        Variables: _cartridgeVariables,
        NameToObject: _cartridgeNameToObject,
        ResultStatus: _LUAAnalyzeStatus,
        ResultsLUA: _LUAAnalyzeResults,
        Builder: _builder,
        BuilderVersion: _BuilderVersion,
        TargetDeviceVersion: _TargetDeviceVersion,
        StateID: _StateID,
        CountryID: _CountryID,
        UseLogging: _UseLogging,
        CreateDate: _CreateDate,
        PublishDate: _PublishDate,
        UpdateDate: _UpdateDate,
        LastPlayedDate: _LastPlayedDate,
        httpCode: httpCode,
        httpMessage: httpMessage,
      ));
}

void _checkAndGetCartridgeName(String currentLine) {
  if (RegExp(r'(Wherigo.ZCartridge)').hasMatch(currentLine)) {
    _CartridgeLUAName =
        currentLine.replaceAll('=', '').replaceAll(' ', '').replaceAll('Wherigo.ZCartridge()', '').trim();
  }
}

void _checkAndGetCartridgeMetaData(String currentLine) {
  currentLine = currentLine.replaceAll(_CartridgeLUAName, '').trim();

  if (currentLine.startsWith('.Name')) {
    _LUACartridgeName = currentLine.replaceAll('.Name = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.Id')) {
    _LUACartridgeGUID = currentLine.replaceAll('.Id = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.BuilderVersion')) {
    _BuilderVersion = currentLine.replaceAll('.BuilderVersion = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.TargetDeviceVersion')) {
    _TargetDeviceVersion = currentLine.replaceAll('.TargetDeviceVersion = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.CountryId')) {
    _CountryID = currentLine.replaceAll('.CountryId = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.StateId')) {
    _StateID = currentLine.replaceAll('.StateId = ', '').replaceAll('"', '').trim();
  }

  if (currentLine.startsWith('.UseLogging')) {
    _UseLogging = currentLine.replaceAll('.UseLogging = ', '').replaceAll('"', '').trim().toLowerCase();
  }

  if (currentLine.startsWith('.CreateDate')) {
    _CreateDate = _normalizeDate(currentLine.replaceAll('.CreateDate = ', '').replaceAll('"', '').trim());
  }

  if (currentLine.startsWith('.PublishDate')) {
    _PublishDate = _normalizeDate(currentLine.replaceAll('.PublishDate = ', '').replaceAll('"', '').trim());
  }

  if (currentLine.startsWith('.UpdateDate')) {
    _UpdateDate = _normalizeDate(currentLine.replaceAll('.UpdateDate = ', '').replaceAll('"', '').trim());
  }

  if (currentLine.startsWith('.LastPlayedDate')) {
    _LastPlayedDate = _normalizeDate(currentLine.replaceAll('.LastPlayedDate = ', '').replaceAll('"', '').trim());
  }
}

void _checkAndGetWherigoBuilder() {
  if (RegExp(r'(_Urwigo)').hasMatch(_LUAFile)) {
    _builder = WHERIGO_BUILDER.URWIGO;
  } else if (RegExp(r'(WWB_deobf)').hasMatch(_LUAFile)) {
    _builder = WHERIGO_BUILDER.EARWIGO;
  } else if (RegExp(r'(gsub_wig)').hasMatch(_LUAFile)) {
    _builder = WHERIGO_BUILDER.WHERIGOKIT;
  }
}

Future<void> _getDecompiledLUAFileFromServer(Uint8List byteListLUA) async {
  String address = 'http://sdklmfoqdd5qrtha.myfritz.net:7323/GCW_Unluac/';
  var uri = Uri.parse(address);
  var request = http.MultipartRequest('POST', uri)
    ..files.add(
        http.MultipartFile.fromBytes('file', byteListLUA, contentType: MediaType('application', 'octet-stream')));
  var response = await request.send();

  httpCode = response.statusCode;
  httpMessage = response.reasonPhrase ?? '';
  if (httpCode == 200) {
    var responseData = await http.Response.fromStream(response);
    _LUAFile = responseData.body;
  }
}
