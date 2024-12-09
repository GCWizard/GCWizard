part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionOnGetInput(String currentLine) {
  if (currentLine.endsWith(':OnGetInput(input)') || currentLine.startsWith('function')) {
    return false;
  }
  return true;
}

WherigoAnswer _analyzeAndExtractOnGetInputSectionData(List<String> onGetInputLines) {
  String resultInputFunction = '';
  List<WherigoAnswerData> resultAnswerData = [];

  List<String> _answerAnswerList = [];
  String _answerHash = '';
  List<WherigoActionMessageElementData> _answerActions = [];

  for (int i = 0; i < onGetInputLines.length; i++) {
    if (onGetInputLines[i].endsWith(':OnGetInput(input)')) {
      resultInputFunction = onGetInputLines[i].replaceAll('function ', '').replaceAll(':OnGetInput(input)', '').trim();
    }
    if (onGetInputLines[i].trim().endsWith('= tonumber(input)')) {
      _answerVariable = onGetInputLines[i].trim().replaceAll(' = tonumber(input)', '');
    } else if (onGetInputLines[i].trim().endsWith(' = input')) {
      _answerVariable = onGetInputLines[i].trim().replaceAll(' = input', '');
    } else if (onGetInputLines[i].trim().endsWith(' == input then')) {
      _answerVariable = onGetInputLines[i].trim().replaceAll(' == input then', '').replaceAll('if ', '');
    } else if (onGetInputLines[i].trimLeft() == 'if input == nil then') {
      // suppress this
      //answer = 'NIL';
      i++;
      onGetInputLines[i] = onGetInputLines[i].trim();
      _answerVariable = 'input';
      _sectionAnalysed = false;
      do {
        i++;
        onGetInputLines[i] = onGetInputLines[i].trim();
        if (onGetInputLines[i].trim() == 'end') _sectionAnalysed = true;
      } while (!_sectionAnalysed); // end of section
    } // end of NIL

    //else
    if (_OnGetInputSectionEnd(onGetInputLines[i])) {
      // found Answer
      _answerActions = [];
      _answerAnswerList = _getAnswers(i, onGetInputLines[i], onGetInputLines[i - 1], _cartridgeVariables);

      for (var answer in _answerAnswerList) {
        if (answer != 'NIL') {
          resultAnswerData.add(WherigoAnswerData(
            AnswerAnswer: answer,
            AnswerHash: _answerHash,
            AnswerActions: _answerActions,
          ));
        }
      }
    } else if (onGetInputLines[i].trimLeft().startsWith('Buttons')) {
      do {
        i++;
        onGetInputLines[i] = onGetInputLines[i].trim();
        if (!(onGetInputLines[i] == '}' || onGetInputLines[i] == '},')) {
          int obfuscation = _getObfuscatorFunction(onGetInputLines[i], _obfuscatorFunction);
          //if (onGetInputLines[i].startsWith()) {
          if (obfuscation > 0) {
            _answerActions.add(WherigoActionMessageElementData(
                ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                ActionMessageContent: deobfuscateUrwigoText(
                    onGetInputLines[i].trim().replaceAll(_obfuscatorFunction[obfuscation] + '("', '').replaceAll('")', ''),
                    _obfuscatorTable[obfuscation])));
          } else {
            _answerActions.add(WherigoActionMessageElementData(
                ActionMessageType: WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                ActionMessageContent:
                    onGetInputLines[i]));
          }
        }
      } while (!onGetInputLines[i].startsWith('}'));
    } // end buttons

    else {
      if (_isMessageActionElement(onGetInputLines[i].trimLeft())) {
        _answerActions.add(_handleAnswerLine(onGetInputLines[i].trimLeft()));
      }
    } // end if other line content
  }
  return WherigoAnswer(
    InputFunction: resultInputFunction,
    InputAnswers: resultAnswerData,
  );
}

int _getObfuscatorFunction(String line, List<String> obfuscatorFunction) {
  int result = 0;
  for (int i = 0; i < obfuscatorFunction.length; i++) {
    if (line.contains(obfuscatorFunction[i])) {
      result = i;
      break;
    }
  }
  return result;
}

List<String> _getAnswers(int i, String line, String lineBefore, List<WherigoVariableData> variables) {
  line = line.trim();
  if (line == 'else') {
    return ['-<ELSE>-'];
  }
  line = line.replaceAll('tonumber', '').replaceAll('""', '').replaceAll('(', '').replaceAll(')', '');
  if (line.startsWith('if input == ') ||
      line.startsWith('if input >= ') ||
      line.startsWith('if input > ') ||
      line.startsWith('if input < ') ||
      line.startsWith('if input <= ') ||
      line.startsWith('elseif input == ') ||
      line.startsWith('elseif input >= ') ||
      line.startsWith('elseif input > ') ||
      line.startsWith('elseif input < ') ||
      line.startsWith('elseif input <= ') ||
      line.startsWith('if ' + _answerVariable + ' == ') ||
      line.startsWith('elseif ' + _answerVariable + ' == ')) {
    if ((line.contains('<=') && line.contains('>=')) || (line.contains('<') && line.contains('>'))) {
      return [
        line
            .replaceAll('if', '')
            .replaceAll('else', '')
            //.replaceAll('=', '')
            //.replaceAll('>', '')
            //.replaceAll('<', '')
            .replaceAll('input', '')
            .replaceAll('then', '')
            .replaceAll(' ', '')
            .replaceAll('and', ' && ')
            .replaceAll('or', ' || ')
      ];
    }
    String answers = line
        .replaceAll('if', '')
        .replaceAll('else', '')
        .replaceAll('input', '')
        .replaceAll('==', '')
        //.replaceAll('>', '')
        //.replaceAll('<', '')
        .replaceAll('then', '')
        //.replaceAll(_answerVariable, '')
        .replaceAll(' ', '')
        .replaceAll('"', '')
        .replaceAll('and', ' && ');
        //.replaceAll('or', ' || ');
    if (answers.length > _answerVariable.length) {
      answers = answers.replaceAll(_answerVariable, '');
    }

    return answers.split(RegExp(r'(or)'));
  } else if (RegExp(r'(_Urwigo.Hash)').hasMatch(line)) {
    List<String> results = [];
    int hashvalue = 0;
    line = line.split('and')[0];
    line = line
        .trim()
        .replaceAll('if ', '')
        .replaceAll('elseif ', '')
        .replaceAll('_Urwigo.Hash', '')
        .replaceAll('input', '')
        .replaceAll('=', '')
        .replaceAll('string.lower', '')
        .replaceAll('string.upper', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('then', '')
        .replaceAll('else', '')
        .replaceAll('true', '')
        .replaceAll('and', '')
        .replaceAll('Contains', '')
        .replaceAll('Player', '')
        .replaceAll(':', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^or0-9]'), '+')
        .replaceAll('o+', '+')
        .replaceAll('+r', '+')
        .replaceAll('+', '');
    line.split('or').forEach((element) {
      hashvalue = int.parse(element.replaceAll('D+', ''));
      results.add(hashvalue.toString() +
          '\x01' +
          breakUrwigoHash(hashvalue, HASH.ALPHABETICAL).toString() +
          '\x01' +
          breakUrwigoHash(hashvalue, HASH.NUMERIC).toString());
    });

    return results;
  } else if (line.trim().startsWith('if Wherigo.NoCaseEquals') ||
      line.trim().startsWith('elseif Wherigo.NoCaseEquals')) {
    if (_answerVariable.isEmpty) _answerVariable = _getVariable(lineBefore);
    line = line
        .trim()
        .replaceAll('if ', '')
        .replaceAll('elseif ', '')
        .replaceAll('Wherigo.NoCaseEquals', '')
        .replaceAll(_answerVariable, '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('"', '')
        .replaceAll(',', '')
        .replaceAll('then', '')
        .replaceAll('tostring', '')
        .replaceAll('else', '')
        .replaceAll('input', '')
        .replaceAll('Answer,', '')
        .trim();
    line = line.split(' or ').map((element) {
      return element.trim();
    }).join('\n');
    line = removeWWB(line);
    // check if variable then provide information
    for (int i = 0; i < variables.length; i++) {
      if (line == variables[i].VariableLUAName) {
        line = variables[i].VariableName + '\x01' + line;
        i = variables.length;
      }
    }
    if (line.isEmpty) {
      return ['NIL'];
    }

    return [line];
  }
  return [];
}

bool _OnGetInputSectionEnd(String line) {
  line = line.trim();
  if (line.startsWith('if input == ') ||
      line.startsWith('if input >= ') ||
      line.startsWith('if input > ') ||
      line.startsWith('if input < ') ||
      line.startsWith('if input <= ') ||
      line.startsWith('elseif input == ') ||
      line.startsWith('elseif input >= ') ||
      line.startsWith('elseif input > ') ||
      line.startsWith('elseif input < ') ||
      line.startsWith('elseif input <= ') ||
      line.startsWith('if _Urwigo.Hash(') ||
      line.startsWith('if (_Urwigo.Hash(') ||
      line.startsWith('elseif _Urwigo.Hash(') ||
      line.startsWith('elseif (_Urwigo.Hash(') ||
      line.startsWith('if Wherigo.NoCaseEquals(') ||
      line.startsWith('elseif Wherigo.NoCaseEquals(') ||
      line.startsWith('if ' + _answerVariable + ' == ') ||
      line.startsWith('elseif ' + _answerVariable + ' == ') ||
      line.trim() == 'else') {
    return true;
  } else {
    return false;
  }
}
