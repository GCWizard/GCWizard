part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

bool _insideSectionOnGetInput(String currentLine, String nextLine) {
  if (currentLine.trim().startsWith('end') &&
      (nextLine.trim().startsWith('function') || nextLine.trim().startsWith('return'))) {
    return false;
  }
  return true;
}

void _analyzeAndExtractOnGetInputSectionData(List<String> lines) {
  bool _insideInputFunction = true;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().endsWith('= tonumber(input)')) {
      _answerVariable = lines[i].trim().replaceAll(' = tonumber(input)', '');
    } else if (lines[i].trim().endsWith(' = input')) {
      _answerVariable = lines[i].trim().replaceAll(' = input', '');
    } else if (lines[i].trimLeft() == 'if input == nil then') {
      i++;
      lines[i] = lines[i].trim();
      _answerVariable = 'input';
      // suppress this
      //answer = 'NIL';
      _sectionAnalysed = false;
      do {
        i++;
        lines[i] = lines[i].trim();
        if (lines[i].trim() == 'end') _sectionAnalysed = true;
      } while (!_sectionAnalysed); // end of section
    } // end of NIL

    else if (_OnGetInputSectionEnd(lines[i])) {
      if (_insideInputFunction) {
        for (var answer in _answerList) {
          if (answer != 'NIL') {
            if (_Answers[_inputObject] == null) {
              continue; // TODO Thomas Maybe not necessary if concrete return value is used
            }

            _Answers[_inputObject]!.add(WherigoAnswerData(
              answer,
              _answerHash,
              _answerActions,
            ));
          }
        }
        _answerActions = [];
        _answerList = _getAnswers(i, lines[i], lines[i - 1], _cartridgeVariables);
      }
    } else if ((i + 1 < lines.length - 1) && _OnGetInputFunctionEnd(lines[i], lines[i + 1].trim())) {
      if (_insideInputFunction) {
        _insideInputFunction = false;
        for (var answer in _answerList) {
          if (_Answers[_inputObject] == null) continue;

          if (answer != 'NIL') {
            _Answers[_inputObject]!.add(WherigoAnswerData(
              answer,
              _answerHash,
              _answerActions,
            ));
          }
        }
        _answerActions = [];
        _answerList = [];
        _answerVariable = '';
      }
    } else if (lines[i].trimLeft().startsWith('Buttons')) {
      do {
        i++;
        lines[i] = lines[i].trim();
        if (!(lines[i].trim() == '}' || lines[i].trim() == '},')) {
          if (lines[i].trimLeft().startsWith(_obfuscatorFunction)) {
            _answerActions.add(WherigoActionMessageElementData(
                WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                deobfuscateUrwigoText(lines[i].trim().replaceAll(_obfuscatorFunction + '("', '').replaceAll('")', ''),
                    _obfuscatorTable)));
          } else {
            _answerActions.add(WherigoActionMessageElementData(WHERIGO_ACTIONMESSAGETYPE.BUTTON,
                lines[i].trim().replaceAll(_obfuscatorFunction + '("', '').replaceAll('")', '')));
          }
        }
      } while (!lines[i].trim().startsWith('}'));
    } // end buttons

    else {
      if (_isMessageActionElement(lines[i].trimLeft())) {
        _answerActions.add(_handleAnswerLine(lines[i].trimLeft()));
      }
    } // end if other line content
  }
}
