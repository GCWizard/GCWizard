import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/phone_models.dart';
import 'package:gc_wizard/utils/constants.dart';

PhoneCaseMode? _getModeFromState(String? state) {
  if (state == null) return null;
  switch (state.split('_')[0]) {
    case 'ABC':
      return PhoneCaseMode.UPPER_CASE;
    case 'Abc':
      return PhoneCaseMode.CAMEL_CASE;
    case 'abc':
      return PhoneCaseMode.LOWER_CASE;
    case '123':
      return PhoneCaseMode.NUMBERS;
    case 'char':
      return PhoneCaseMode.SPECIAL_CHARACTERS;
    default:
      return null;
  }
}

List<String> _sanitizeDecodeInput(String input) {
  var sanitizedInput = '';
  var prevCharacter = input[0];
  input.trim().replaceAll(RegExp(r'\s+'), ' ').split('').forEach((character) {
    if (character == ' ') {
      prevCharacter = ' ';
      return;
    }

    if (character == prevCharacter) {
      sanitizedInput += character;
    } else {
      sanitizedInput += ' ' + character;
    }

    prevCharacter = character;
  });

  return sanitizedInput.split(' ').where((element) => element.isNotEmpty).toList();
}

bool _isTransitionCharacter(Map<String, Map<String, String>> stateModel, String state, String character) {
  return !('_?'.contains(character)) && stateModel[state]?[character] != null;
}

Map<String, String> _getCharMap(Map<PhoneCaseMode, Map<String, String>> languageCharMap, PhoneCaseMode mode) {
  return languageCharMap[mode == PhoneCaseMode.CAMEL_CASE ? PhoneCaseMode.UPPER_CASE : mode] ?? {};
}

String? _getNewState(Map<String, Map<String, String>> stateModel, String state, String character) {
  if ([' ', '\n', '¶'].contains(character)) return stateModel[state]?['_'];

  if (['.', '!', '?'].contains(character)) return stateModel[state]?['?'];

  return stateModel[state]?['x'];
}

({PhoneCaseMode? mode, String text})? decodeVanityMultitap(String input, PhoneModel model, PhoneInputLanguage inputLanguage) {
  var stateModel = model.defaultCaseStateModel;

  if (model.specificCaseStateModels != null && model.specificCaseStateModels![inputLanguage] != null) {
    stateModel = model.specificCaseStateModels![inputLanguage]!;
  }

  var currentState = stateModel[PHONE_STATEMODEL_START]?.values.first;
  if (currentState == null) return null;

  var currentMode = _getModeFromState(currentState);

  if (input.trim().isEmpty || currentMode == null) {
    return (mode: currentMode, text: '');
  }

  var languageIndex = model.languages.indexWhere((langList) => langList.contains(inputLanguage));
  var languageCharmap = model.characterMap[languageIndex];
  var currentCharmap = _getCharMap(languageCharmap, currentMode);

  List<String> inputBlocks = _sanitizeDecodeInput(input);
  if (inputBlocks.isEmpty) return (mode: currentMode, text: '');

  var output = '';
  for (int i = 0; i < inputBlocks.length; i++) {
    var block = inputBlocks[i];
    var firstLetter = block[0];

    var characters = currentCharmap[firstLetter];
    if (characters == null && !_isTransitionCharacter(stateModel, currentState!, firstLetter)) continue;

    if (characters != null) {
      if (characters.length == 1 && block.length > 1) {
        output += characters;
        currentState = _getNewState(stateModel, currentState!, firstLetter);
        currentMode = _getModeFromState(currentState);
        currentCharmap = _getCharMap(languageCharmap, currentMode!);

        inputBlocks[i] = inputBlocks[i].substring(1);
        i--;
        continue;
      }

      var outputCharacter = characters[(block.length - 1) % characters.length];

      currentState = _getNewState(stateModel, currentState!, outputCharacter);
      currentMode = _getModeFromState(currentState);
      currentCharmap = _getCharMap(languageCharmap, currentMode!);

      output += outputCharacter;
    } else {
      // Transition
      currentState = stateModel[currentState]?[firstLetter];
      currentMode = _getModeFromState(currentState);
      currentCharmap = _getCharMap(languageCharmap, currentMode!);

      if (block.length > 1) {
        inputBlocks[i] = inputBlocks[i].substring(1);
        i--;
      }
    }
  }

  return (mode: currentMode, text: output);
}

String _sanitizeEncodeInput(String input, Map<PhoneCaseMode, Map<String, String>> languageCharMap) {
  var availableCharacters = languageCharMap.values.map((keyMap) => keyMap.values.join()).join();
  return input.split('').where((character) => availableCharacters.contains(character)).join();
}

({String transitions, String state})? _findStateForCharacter(Map<String, Map<String, String>> stateModel, String currentState,
    Map<PhoneCaseMode, Map<String, String>> languageCharMap, String character, int numberHops, String transitions) {
  if (numberHops > 3) return null;

  var mode = _getModeFromState(currentState);
  if (mode == null) return null;
  var availableCharactersForMode = _getCharMap(languageCharMap, mode).values.join();

  if (availableCharactersForMode.contains(character)) return (transitions: transitions, state: currentState);

  for (String transitionCharacter in ['0', '*', '#']) {
    var newState = stateModel[currentState]![transitionCharacter];
    if (newState != null) {
      var result = _findStateForCharacter(
          stateModel, newState, languageCharMap, character, numberHops + 1, transitions + transitionCharacter);
      if (result != null) return result;
    }
  }

  return null;
}

String _getInputForCharacter(Map<String, String> charMap, String character) {
  var entry = charMap.entries.firstWhere((entry) => entry.value.contains(character));
  return entry.key * (entry.value.indexOf(character) + 1);
}

({PhoneCaseMode? mode, String text})? encodeVanityMultitap(
    String input, PhoneModel model, PhoneInputLanguage? inputLanguage) {
  if (inputLanguage == null) return null;

  var stateModel = model.defaultCaseStateModel;

  if (model.specificCaseStateModels != null && model.specificCaseStateModels![inputLanguage] != null) {
    stateModel = model.specificCaseStateModels![inputLanguage]!;
  }

  var currentState = stateModel[PHONE_STATEMODEL_START]!.values.first;
  var currentMode = _getModeFromState(currentState);

  if (input.isEmpty || currentMode == null) return (mode: currentMode, text: '');

  var languageIndex = model.languages.indexWhere((langList) => langList.contains(inputLanguage));
  var languageCharmap = model.characterMap[languageIndex];

  input = _sanitizeEncodeInput(input, languageCharmap);
  if (input.isEmpty) return (mode: currentMode, text: '');

  List<String> output = [];

  input.split('').forEach((character) {
    var newState = _findStateForCharacter(stateModel, currentState, languageCharmap, character, 0, '');
    if (newState == null) {
      output.add(UNKNOWN_ELEMENT);
      return;
    }

    if (newState.transitions.isNotEmpty) output.add(newState.transitions);

    currentState = newState.state;
    currentMode = _getModeFromState(currentState);

    var currentCharmap = _getCharMap(languageCharmap, currentMode!);

    output.add(_getInputForCharacter(currentCharmap, character));
    currentState = _getNewState(stateModel, currentState, character)!;
  });

  return (mode: _getModeFromState(currentState), text: output.join(' '));
}

String encodeVanitySingletap(String input, PhoneModel model) {
  if (input.isEmpty) return '';

  return encodeVanityMultitap(input, model, PhoneInputLanguage.UNSPECIFIED)!
      .text
      .split(' ')
      .map((group) => group.isEmpty ? '' : group[0])
      .join();
}
