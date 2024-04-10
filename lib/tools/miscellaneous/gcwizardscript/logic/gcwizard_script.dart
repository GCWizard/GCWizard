import 'dart:core';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_arithmetic_mean/logic/centroid_arithmetic_mean.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dutchgrid/logic/dutchgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/geo3x3.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohash/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohex/logic/geohex.dart';
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/formats/maidenhead/logic/maidenhead.dart';
import 'package:gc_wizard/tools/coords/_common/formats/makaney/logic/makaney.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mercator/logic/mercator.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/openlocationcode/logic/open_location_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/quadtree/logic/quadtree.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/formats/slippymap/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/utm/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/xyz/logic/xyz.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/abaddon/logic/abaddon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/avemaria/logic/avemaria.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/logic/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enclosed_areas/logic/enclosed_areas.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/logic/gc_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/tools/science_and_technology/complex_numbers/logic/complex_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';
import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/tools/science_and_technology/ieee754/logic/ieee754.dart';
import 'package:gc_wizard/tools/science_and_technology/mathematical_constants/logic/mathematical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/physical_constants/logic/physical_constants.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:stack/stack.dart' as datastack;

part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_classes.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_consts.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_enums.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_error_handling.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_codes_base.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_codes_crypto.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_codes_hash.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_coordinates.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_datetime.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_definitions.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_files.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_geocaching.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_graphic.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_list.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_math.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_string.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_typetests.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_functions_waypoints.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_help.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_test_datatypes.dart';
part 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script_variables.dart';

// Tiny BASIC
//  uses lessons from Herbert Schildt's book "C, power user's guide" P.247ff
//  McGraw Hill has no objection according to their letter dated from 18. Januar 2023
//  https://archive.org/details/cpowerusersguide00schi_0/page/n9/mode/2up
//
// convert from: https://gist.github.com/pmachapman/661f0fff9814231fde48
// https://github.com/generalram/cpowerusers
// https://beramodo.tistory.com/12

// extended/enhanced to
// - use Strings
// - use math-/String-Functions
// - use bitwise operators
// - use GC Wizard functions like bww, rot, LatLontoWGS84, RomanToDec, DecToRoman
// - use REPEAT-UNTIL, WHILE-WEND, STEP
// - use ELSEIF-ELSE-ENDIF
// - use SWITCH-CASE_DEFAULT-ENDSWITCH
// - use SLEEP, RANDOMIZE, RND
// - use REM
// - use DATA, RESTORE, READ
// - use SCREEN, CIRCLE, LINE, POINT, ARC, COLOR, FILL, TEXT, BOX, OVAL
// - use BREAK
// - use DIM, implement List as Datatype
// - use variable names longer than one letter
// - handle case sensitiveness
// - handle INPUT async like whitespace, piet
// - use WRITETOFILE, READFROMFILE, DUMPFILE, EOF
// - use NEWFILE, async OPENFILE, async SAVEFILE
// - use VERSION

// TODO
// Enhance Performance
// async PRINT
// BEEP
// http://www.mopsos.net/Script.html => Dreiecke

ScriptState? state;

Future<GCWizardScriptOutput> GCWizardScriptInterpretScriptAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! InterpreterJobData) {
    return Future.value(GCWizardScriptOutput.empty());
  }
  var interpreter = jobData!.parameters as InterpreterJobData;
  var output = await GCWizardScriptInterpretScript(
      interpreter.jobDataScript, interpreter.jobDataInput, interpreter.jobDataCoords, interpreter.continueState,
      sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);
  return output;
}

Future<GCWizardScriptOutput> GCWizardScriptInterpretScript(
    String script, String input, LatLng coords, ScriptState? continueState,
    {SendPort? sendAsyncPort}) async {
  if (script == '') {
    return GCWizardScriptOutput.empty();
  }

  _GCWizardSCriptInterpreter interpreter =
      _GCWizardSCriptInterpreter(script, input, coords, continueState, sendAsyncPort);
  return interpreter.run();
}

class _GCWizardSCriptInterpreter {
  static const MAXITERATIONS = 1000000000;
  static const PROGRESS_STEP = 10000.0;

  // internal representation of loop types
  static const FORLOOP = 0;
  static const WHILELOOP = 1;
  static const REPEATLOOP = 2;
  static const SWITCHSTATEMENT = 3;

  // internal representation of token types
  static const NONE = 0;
  static const DELIMITER = 1;
  static const VARIABLE = 2;
  static const NUMBER = 3;
  static const COMMAND = 4;
  static const QUOTEDSTR = 5;
  static const FUNCTION = 6;

  // Internal representation of the GCWScript keywords.
  static const UNKNOWNCOMMAND = 0;
  static const PRINT = 1;
  static const INPUT = 2;
  static const IF = 3;
  static const THEN = 4;
  static const FOR = 5;
  static const NEXT = 6;
  static const TO = 7;
  static const GOTO = 8;
  static const GOSUB = 9;
  static const RETURN = 10;
  static const END = 11;
  static const EOL = 12;
  static const REPEAT = 13;
  static const UNTIL = 14;
  static const CLS = 15;
  //static const BEEP = 16;
  static const SLEEP = 17;
  static const RANDOMIZE = 18;
  static const RND = 19;
  static const WHILE = 20;
  static const WEND = 21;
  static const STEP = 22;
  static const REM = 23;
  static const DATA = 24;
  static const READ = 25;
  static const RESTORE = 26;
  static const SCREEN = 27;
  static const ELSE = 28;
  static const ELSEIF = 29;
  static const ENDIF = 30;
  static const SWITCH = 31;
  static const CASE = 32;
  static const DEFAULT = 33;
  static const ENDSWITCH = 34;
  static const BREAK = 35;
  static const CONTINUE = 36;
  static const DIM = 37;
  static const NEWFILE = 38;
  static const OPENFILE = 39;
  static const SAVEFILE = 40;
  static const VERSION = 41;

  static const EOP = 'EOP';
  static const LF = '\n';
  static const CR = '\r';

  static const LE = '1'; // <=
  static const GE = '2'; // >=
  static const NE = '3'; // !=
  static const AND = '4'; // &&
  static const OR = '5'; // ||

  static const Map<String, int> registeredKeywordsControls = {
    "if": IF,
    "then": THEN,
    "goto": GOTO,
    "for": FOR,
    "next": NEXT,
    "to": TO,
    "gosub": GOSUB,
    "return": RETURN,
    "end": END,
    "repeat": REPEAT,
    "until": UNTIL,
    "while": WHILE,
    "wend": WEND,
    "step": STEP,
    "elseif": ELSEIF,
    "else": ELSE,
    "endif": ENDIF,
    "switch": SWITCH,
    "case": CASE,
    "default": DEFAULT,
    "endswitch": ENDSWITCH,
    "break": BREAK,
    "continue": CONTINUE,
  };
  static const Map<String, int> registeredKeywordsCommands = {
    "print": PRINT,
    "input": INPUT,
    "cls": CLS,
    //"beep": BEEP,
    "sleep": SLEEP,
    "randomize": RANDOMIZE,
    "rnd": RND,
    "rem": REM,
    "data": DATA,
    "read": READ,
    "restore": RESTORE,
    "screen": SCREEN,
    "dim": DIM,
    "newfile": NEWFILE,
    "openfile": OPENFILE,
    "savefile": SAVEFILE,
    "version": VERSION,
  };
  Map<String, int> registeredKeywords = {};

  static const Map<int, Map<String, Object?>> SCREEN_MODES = {
    0: {
      _GCWizardScriptGraphicMode: GCWizardSCript_SCREENMODE.TEXT,
      _GCWizardScriptGraphicWidthT: 80,
      _GCWizardScriptGraphicHeightT: 25,
      _GCWizardScriptGraphicColors: 256,
    },
    1: {
      _GCWizardScriptGraphicMode: GCWizardSCript_SCREENMODE.GRAPHIC,
      _GCWizardScriptGraphicWidthT: 80,
      _GCWizardScriptGraphicHeightT: 25,
      _GCWizardScriptGraphicWidthG: 1920,
      _GCWizardScriptGraphicHeightG: 1080,
      _GCWizardScriptGraphicColors: 256,
    },
    2: {
      _GCWizardScriptGraphicMode: GCWizardSCript_SCREENMODE.GRAPHIC,
      _GCWizardScriptGraphicWidthT: 80,
      _GCWizardScriptGraphicHeightT: 25,
      _GCWizardScriptGraphicWidthG: 1920,
      _GCWizardScriptGraphicHeightG: 1080,
      _GCWizardScriptGraphicColors: 256,
    },
  };

  late ScriptState state;
  GCWizardScriptBreakType BreakType = GCWizardScriptBreakType.NULL;

  SendPort? sendAsyncPort;

  static const List<String> relationOperators = [AND, OR, GE, NE, LE, '<', '>', '=', '0'];

  _GCWizardSCriptInterpreter(
      String script, String inputData, LatLng coords, ScriptState? continueState, this.sendAsyncPort) {
    registeredKeywords.addAll(registeredKeywordsCommands);
    registeredKeywords.addAll(registeredKeywordsControls);

    if (continueState == null) {
      state = ScriptState(coords: coords);

      state.script = script.replaceAll('RND()', 'RND(1)') + '\n';

      state.addInput(inputData);
    } else {
      state = continueState;
    }

    _state = state; // for global routines
  }

  GCWizardScriptOutput run() {
    _resetErrors();
    if (state.script == '') {
      return GCWizardScriptOutput.empty();
    }

    if (!state.continueLoop) {
      getLabels(); // find the labels in the program
      getDATA(); // find the DATA in the program
    }
    return scriptInterpreter(); // execute
  }

  GCWizardScriptOutput scriptInterpreter() {
    int iterations = 0;
    do {
      getToken();
      switch (state.tokenType) {
        case NUMBER:
          break;
        case VARIABLE:
          putBack();
          executeAssignment();
          break;
        case FUNCTION:
          executeFunction(state.token, state.tokenType);
          break;
        default:
          executeCommand();
      }

      iterations++;
      if (sendAsyncPort != null && iterations % PROGRESS_STEP == 0) {
        sendAsyncPort?.send(DoubleText(PROGRESS, (iterations / MAXITERATIONS)));
      }
    } while (state.token != EOP && !state.halt && iterations < MAXITERATIONS);

    if (iterations == MAXITERATIONS) _handleError(_INFINITELOOP);
    state.continueLoop = true;
    return GCWizardScriptOutput(
      STDOUT: state.STDOUT.trimRight(),
      Graphic: state.graficOutput,
      Points: state.waypoints,
      FILE: state.FILE,
      fileSaved: state.fileSaved,
      ErrorMessage: state.errorMessage,
      ErrorPosition: state.errorPosition,
      VariableDump: _variableDump(),
      randomNumber: state.randomNumber,

      continueState: (state.errorMessage == _errorMessages[_INPUTMISSING] ||
              state.errorMessage == _errorMessages[_FILEMISSING] ||
              state.errorMessage == _errorMessages[_FILESAVING] ||
              state.errorMessage == _errorMessages[_PRINTERROR])
          ? state
          : null, // state ans widget übergeben, damit es weis, das es noch weiter geht

      BreakType: BreakType,
      //  continueState: state.errorMessage == _errorMessages[_INPUTMISSING] ? state : null
      //  continueState: state.BreakType != GCWizardScriptBreakType.NULL ? state : null
    );
  }

  List<List<String>> _variableDump() {
    List<List<String>> dump = [];
    state.variables.forEach((key, value) {
      dump.add([key, value.toString()]);
    });
    return dump;
  }

  void getDATA() {
    state.script.split('\n').forEach((line) {
      line = line.trim();
      if (line.substring(0, line.length > 5 ? 5 : line.length).toUpperCase() == 'DATA ') {
        line.substring(5).split(',').forEach((data) {
          data = data.trim().replaceAll('"', '');
          if (int.tryParse(data) != null) {
            state.listDATA.add(int.parse(data));
          } else if (double.tryParse(data) != null) {
            state.listDATA.add(double.parse(data));
          } else {
            state.listDATA.add(data);
          }
        });
      }
    });
  }

  void getLabels() {
    int result;

    getToken();
    if (state.tokenType == NUMBER) {
      state.labelTable.push(state.token, state.scriptIndex);
    }

    findEOL();

    do {
      getToken();
      if (state.tokenType == NUMBER) {
        result = state.labelTable.push(state.token, state.scriptIndex);
        if (result == -1) _handleError(_DUPLICATEABEL);
      }

      if (state.keywordToken != EOL) findEOL();
    } while (state.token != EOP);
    state.scriptIndex = 0;
  }

  void findEOL() {
    while (state.scriptIndex < state.script.length && state.script[state.scriptIndex] != LF) {
      ++state.scriptIndex;
    }
    if (state.scriptIndex < state.script.length) state.scriptIndex++;
  }

  void executeAssignment() {
    Object? value;
    String variableName;

    getToken();
    variableName = state.token;

    getToken();
    if (state.token != "=") {
      _handleError(_EQUALEXPECTED);
      return;
    }

    value = evaluateExpression();

    state.variables[variableName] = value;
  }

  void executeCommand() {
    BreakType = GCWizardScriptBreakType.NULL;
    switch (state.keywordToken) {
      case PRINT:
        BreakType = GCWizardScriptBreakType.PRINT;
        executeCommandPRINT();
        break;
      case GOTO:
        executeCommandGOTO();
        break;
      case IF:
        executeCommandIF();
        break;
      case ELSEIF:
        executeCommandELSEIF();
        break;
      case THEN:
        executeCommandTHEN();
        break;
      case ELSE:
        executeCommandELSE();
        break;
      case ENDIF:
        executeCommandENDIF();
        break;
      case SWITCH:
        executeCommandSWITCH();
        break;
      case CASE:
        executeCommandCASE();
        break;
      case DEFAULT:
        executeCommandDEFAULT();
        break;
      case ENDSWITCH:
        executeCommandENDSWITCH();
        break;
      case FOR:
        executeCommandFOR();
        break;
      case NEXT:
        executeCommandNEXT();
        break;
      case INPUT:
        BreakType = GCWizardScriptBreakType.INPUT;
        executeCommandINPUT();
        break;
      case GOSUB:
        executeCommandGOSUB();
        break;
      case RETURN:
        executeCommandRETURN();
        break;
      case REPEAT:
        executeCommandREPEAT();
        break;
      case UNTIL:
        executeCommandUNTIL();
        break;
      case CLS:
        executeCommandCLS();
        break;
      //case BEEP:
      //  executeCommandBEEP();
      //  break;
      case SLEEP:
        executeCommandSLEEP();
        break;
      case RANDOMIZE:
        executeCommandRANDOMIZE();
        break;
      case WHILE:
        executeCommandWHILE();
        break;
      case WEND:
        executeCommandWEND();
        break;
      case REM:
        executeCommandREM();
        break;
      case DATA:
        executeCommandDATA();
        break;
      case READ:
        executeCommandREAD();
        break;
      case RESTORE:
        executeCommandRESTORE();
        break;
      case SCREEN:
        executeCommandSCREEN();
        break;
      case BREAK:
        executeCommandBREAK();
        break;
      case CONTINUE:
        executeCommandCONTINUE();
        break;
      case DIM:
        executeCommandDIM();
        break;
      case NEWFILE:
        executeCommandNEWFILE();
        break;
      case OPENFILE:
        BreakType = GCWizardScriptBreakType.OPENFILE;
        executeCommandOPENFILE();
        break;
      case SAVEFILE:
        BreakType = GCWizardScriptBreakType.SAVEFILE;
        executeCommandSAVEFILE();
        break;
      case VERSION:
        executeCommandVERSION();
        break;
      case END:
      case UNKNOWNCOMMAND:
        state.halt = true;
    }
  }

  void executeCommandVERSION() {
    state.STDOUT = state.STDOUT +
        '********** GC Wizard  Skript **********\n' +
        '*      Version as of  2023.09.09      *\n' +
        '*  based on the work of Herb Schildt  *\n' +
        '*  The Art of C, 1991, © McGraw Hill  *\n' +
        '* Enhancement for GC Wizard permitted *\n' +
        '***************************************\n';
  }

  void executeCommandNEWFILE() {
    state.FILE = [];
    state.FILEINDEX = 0;
  }

  void executeCommandOPENFILE() {
    state.FILE = [];
    state.FILEINDEX = 0;
    int scriptIndex_save = state.scriptIndex;

    state.continueLoop = false;

    if (state.FILE.isNotEmpty) {
      state.continueLoop = false;
    } else {
      _handleError(_FILEMISSING);
      state.scriptIndex = scriptIndex_save; // continue entry point
    }
  }

  void executeCommandSAVEFILE() {
    int scriptIndex_save = state.scriptIndex;

    state.continueLoop = false;

    if (state.fileSaved) {
      state.continueLoop = false;
    } else {
      _handleError(_FILESAVING);
      state.scriptIndex = scriptIndex_save; // continue entry point
    }
  }

  void executeCommandREM() {
    findEOL();
  }

  void executeCommandDATA() {
    findEOL();
  }

  void executeCommandREAD() {
    String vname = '';
    do {
      getToken(); // get next list item
      if (state.keywordToken == EOL || state.token == EOP || state.token == '\r\n' || state.token == '\n') break;
      if (state.token != ',') {
        vname = state.token;
        //if (isNotAVariable(vname)) {
        //  state.variables[vname] = 0;
        //}
        if (state.pointerDATA < state.listDATA.length) {
          state.variables[vname] = state.listDATA[state.pointerDATA];
          state.pointerDATA++;
        } else {
          _handleError(_DATAOUTOFRANGE);
        }
      }
    } while (state.keywordToken != EOL && state.token != EOP);
  }

  void executeCommandRESTORE() {
    state.pointerDATA = 0;
  }

  void executeCommandCLS() {
    state.STDOUT = '';
  }

  void executeCommandBEEP() {
    int maxBeep = 1;
    getToken();
    if (state.token != '\n') {
      if (int.tryParse(state.token) == null) {
        _handleError(_SYNTAXERROR);
        return;
      } else {
        maxBeep = int.parse(state.token);
      }
    }
    for (int i = 1; i < maxBeep; i++) {
      SystemSound.play(SystemSoundType.click);
      sleep(const Duration(seconds: 1));
    }
  }

  void executeCommandSLEEP() {
    int maxSleep = 1;
    getToken();
    if (state.token != '\n') {
      if (int.tryParse(state.token) == null) {
        _handleError(_SYNTAXERROR);
        return;
      } else {
        maxSleep = int.parse(state.token);
      }
    }
    sleep(Duration(seconds: maxSleep));
  }

  void executeCommandRANDOMIZE() {}

  void executeCommandDIM() {
    getToken();
    if (state.tokenType == VARIABLE) {
      state.variables[state.token] = _GCWList();
      do {
        getToken();
        if (state.tokenType == VARIABLE) {
          state.variables[state.token] = _GCWList();
        }
        if (state.keywordToken == EOL || state.token == EOP || state.token == '\r\n' || state.token == '\n') break;
      } while (state.keywordToken != EOL || state.token != EOP || state.token != '\r\n' || state.token != '\n');
    } else {
      _handleError(_SYNTAXERROR);
    }
  }

  void executeCommandPRINT() {
    Object? result;
    int len = 0;
    int spaces = 0;
    String lastDelimiter = "";

    // wenn state.continueLoop dann wenn nötig mit der Sonderbehandlung auswerten oder den Codeblock überspringen, damit er nicht doppelt ausgewertet wird
    //if (!state.continueLoop) {
    do {
      getToken();
      if (state.keywordToken == EOL || state.token == EOP) break;

      if (state.tokenType == QUOTEDSTR) {
        state.STDOUT += state.token;
        len += state.token.length;
        getToken();
      } else {
        putBack();
        result = evaluateExpression();
        getToken();
        state.STDOUT += result.toString();

        var t = result;
        len += t.toString().length; // save length
      }
      lastDelimiter = state.token;

      if (lastDelimiter == ",") {
        spaces = 8 - (len % 8);
        len += spaces;
        while (spaces != 0) {
          state.STDOUT += " ";
          spaces--;
        }
      } else if (state.token == ";") {
        state.STDOUT += " ";
        len++;
      } else if (state.keywordToken != EOL && state.token != EOP) {
        _handleError(_SYNTAXERROR);
      }
    } while (lastDelimiter == ";" || lastDelimiter == ",");

    //state.continueLoop = true;
    //}

    if (state.keywordToken == EOL || state.token == EOP) {
      if (lastDelimiter != ";" && lastDelimiter != ",") state.STDOUT += LF;
    } else {
      _handleError(_SYNTAXERROR);
    }

    //if (state.continueLoop) {
    //  _handleError(_PRINTERROR); // Ablauf unterbrechen und zum widget zurück gehen (Error extr dafür erstellt)
    //  int scriptIndex_save = state.scriptIndex; // - "print".length; // Wiedereinsprungspunkt werken

    //  state.scriptIndex = scriptIndex_save; // continue entry point
    //  state.continueLoop = false; // normaler Ablauf
    //} else {
    //  state.continueLoop = false; // normaler Ablauf
    //}
  }

  void executeCommandGOTO() {
    int? location;

    getToken();

    location = state.labelTable.get(state.token);

    if (location == null) {
      _handleError(_LABELNOTDEFINED);
    } else {
      state.scriptIndex = location;
    }
  }

  void executeCommandIF() {
    double result;
    Object? expression = evaluateExpression();

    if (_isNotANumber(expression)) {
      _handleError(_INVALIDTYPECAST);
      return;
    }

    if (_isAInt(expression)) {
      result = (expression as int).toDouble();
    } else {
      result = expression as double;
    }

    state.executeElse = false;

    if (result != 0.0) {
      state.ifStack.push(true);
      getToken();
      if (state.keywordToken != THEN) {
        _handleError(_THENEXPECTED);
        return;
      } // else, target statement will be executed
    } else {
      state.ifStack.push(false);
      state.executeElse = true;
      findEOL();
      findCorrespondingELSE();
    }
    // findEOL();
  }

  void executeCommandELSEIF() {
    double result;

    if (state.ifStack.pop()) {
      state.ifStack.push(true);
      findCorrespondingENDIF();
    } else {
      result = evaluateExpression() as double;
      state.executeElse = false;

      if (result != 0.0) {
        state.ifStack.push(true);
        getToken();
        if (state.keywordToken != THEN) {
          _handleError(_THENEXPECTED);
          return;
        } // else, target statement will be executed
      } else {
        state.ifStack.push(false);
        state.executeElse = true;
        findEOL();
        findCorrespondingELSE();
      }
      // findEOL();
    }
  }

  void executeCommandTHEN() {
    findEOL();
  }

  void findCorrespondingELSE() {
    List<int> ifList = [];
    int result = 0;
    bool doElseIf = false;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('ENDIF')) {
        if (ifList.isEmpty) {
          result = pc + 5;
          break;
        } else {
          ifList.removeLast();
        }
      } else if (state.script.substring(pc).toUpperCase().startsWith('IF ')) {
        ifList.add(pc);
      } else if (state.script.substring(pc).toUpperCase().startsWith('ELSEIF')) {
        if (ifList.isEmpty) {
          result = pc;
          doElseIf = true;
          break;
        } else {
          //ifList.removeLast();
        }
      } else {
        if (state.script.substring(pc).toUpperCase().startsWith('ELSE')) {
          if (ifList.isEmpty) {
            result = pc + 4;
            break;
          } else {
            //ifList.removeLast();
          }
        }
      }
    }
    if (result == 0) {
      _handleError(_MISSINGENDIF);
    } else {
      state.scriptIndex = result;
      if (doElseIf) {
        getToken();
        executeCommandELSEIF();
      }
    }
  }

  void findCorrespondingENDIF() {
    List<int> ifList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('ELSEIF')) {
        pc += 6;
      }
      if (state.script.substring(pc).toUpperCase().startsWith('IF')) {
        ifList.add(pc);
        pc += 2;
      }
      if (state.script.substring(pc).toUpperCase().startsWith('ENDIF')) {
        if (ifList.isEmpty) {
          result += 5;
          break;
        } else {
          ifList.removeLast();
          pc += 5;
        }
      }
    }
    if (result == 0) {
      _handleError(_MISSINGENDIF);
    }
    state.scriptIndex = result;
  }

  void executeCommandELSE() {
    if (!state.executeElse) {
      findCorrespondingELSE();
    } else {}
    findEOL();
    state.executeElse = !state.executeElse;
  }

  void executeCommandENDIF() {
    state.ifStack.pop();
  }

  void executeCommandSWITCH() {
    state.controlStack.push(SWITCHSTATEMENT);
    String variableName;

    getToken();
    variableName = state.token;

    if (isNotAVariable(variableName)) {
      state.variables[variableName] = 0.0;
    }

    state.switchStack.push(variableName);
    findEOL();
  }

  void executeCommandCASE() {
    double result;
    String variable = state.switchStack.top();

    result = evaluateExpression() as double;
    if (state.variables[variable] != result) {
      findNextCASE();
    }
  }

  void findNextCASE() {
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('CASE') ||
          state.script.substring(pc).toUpperCase().startsWith('DEFAULT')) {
        result = pc;
        break;
      }
    }
    if (result == 0) {
      _handleError(_SWITCHWITHOUTEND);
    }
    state.scriptIndex = result;
  }

  void executeCommandDEFAULT() {
    findEOL();
  }

  void findCorrespondingENDSWITCH() {
    List<int> switchList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('SWITCH')) switchList.add(pc);
      if (state.script.substring(pc).toUpperCase().startsWith('ENDSWITCH')) {
        if (switchList.isEmpty) {
          {
            result = pc + 9;
          }
        } else {
          switchList.removeLast();
        }
      }
    }
    if (result == 0) {
      _handleError(_SWITCHWITHOUTEND);
    }
    state.scriptIndex = result;
  }

  void exitSwitchStatement() {
    findCorrespondingENDSWITCH();
  }

  void executeCommandENDSWITCH() {
    state.switchStack.pop();
  }

  void executeCommandFOR() {
    _GCWizardScriptClassForLoopInfo stckvar = _GCWizardScriptClassForLoopInfo();
    state.controlStack.push(FORLOOP);
    Object? valueStart;
    Object? valueTarget;
    String vname;
    Object? stepValue;

    getToken();
    vname = state.token;
    if (isNotAVariable(vname)) {
      state.variables[vname] = 0.0;
    }

    stckvar.loopVariable = vname;

    getToken();
    if (state.token[0] != '=') {
      _handleError(_EQUALEXPECTED);
      return;
    }

    valueStart = evaluateExpression();
    if (_isANumber(valueStart)) {
      state.variables[stckvar.loopVariable] = (valueStart as num);
    } else {
      _handleError(_INVALIDTYPECAST);
    }

    getToken();
    if (state.keywordToken != TO) _handleError(_TOEXPECTED);

    valueTarget = evaluateExpression();
    if (_isANumber(valueTarget)) {
      stckvar.targetValue = valueTarget as num;
    } else {
      _handleError(_INVALIDTARGETVALUE);
      return;
    }

    stckvar.descending = ((valueStart as num) > (valueTarget));

    getToken();
    if (state.keywordToken != STEP) {
      putBack();
      stckvar.stepValue = 1;
    } else {
      stepValue = evaluateExpression();
      if (_isAInt(stepValue)) {
        stckvar.stepValue = (stepValue as int).toInt();
      } else if (_isADouble(stepValue)) {
        stckvar.stepValue = (stepValue as num).toDouble();
      } else {
        _handleError(_INVALIDTYPECAST);
        return;
      }
    }

    if (stckvar.descending) {
      if (valueTarget <= (state.variables[stckvar.loopVariable] as num)) {
        stckvar.loopStart = state.scriptIndex;
        state.forStack.push(stckvar);
      } else {
        while (state.keywordToken != NEXT) {
          getToken();
        }
      }
    } else {
      if (valueTarget >= (state.variables[stckvar.loopVariable] as num)) {
        stckvar.loopStart = state.scriptIndex;
        state.forStack.push(stckvar);
      } else {
        while (state.keywordToken != NEXT) {
          getToken();
        }
      }
    }
  }

  void exitLoopNEXT() {
    List<int> forList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('FOR')) {
        forList.add(pc);
      }
      if (state.script.substring(pc).toUpperCase().startsWith('NEXT')) {
        if (forList.isEmpty) {
          result = pc + 4;
        } else {
          forList.removeLast();
        }
      }
    }
    if (result == 0) {
      _handleError(_FORWITHOUTNEXT);
      return;
    }
    state.scriptIndex = result;
  }

  void findCorrespondingNEXT() {
    List<int> forList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('FOR')) forList.add(pc);
      if (state.script.substring(pc).toUpperCase().startsWith('NEXT')) {
        if (forList.isEmpty) {
          result = pc - 1;
        } else {
          forList.removeLast();
        }
      }
    }
    if (result == 0) {
      _handleError(_FORWITHOUTNEXT);
      return;
    }
    state.scriptIndex = result;
  }

  void executeCommandNEXT() {
    _GCWizardScriptClassForLoopInfo stckvar;
    try {
      stckvar = state.forStack.pop();

      state.variables[stckvar.loopVariable] = (state.variables[stckvar.loopVariable] as num) + stckvar.stepValue;
      if (stckvar.descending) {
        if ((state.variables[stckvar.loopVariable] as num) < stckvar.targetValue) return;
      } else {
        if ((state.variables[stckvar.loopVariable] as num) > stckvar.targetValue) return;
      }
      state.forStack.push(stckvar);
      state.scriptIndex = stckvar.loopStart;
    } catch (IllegalOperationException) {
      _handleError(_NEXTWITHOUTFOR);
      return;
    }
  }

  void executeCommandREPEAT() {
    state.repeatStack.push(state.scriptIndex);
    state.controlStack.push(REPEATLOOP);
  }

  void exitLoopUNTIL() {
    List<int> repeatList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('REPEAT')) {
        repeatList.add(pc);
      }
      if (state.script.substring(pc).toUpperCase().startsWith('UNTIL')) {
        if (repeatList.isEmpty) {
          result = pc + 5;
        } else {
          repeatList.removeLast();
        }
      }
    }
    if (result == 0) {
      _handleError(_REPEATWITHOUTUNTIL);
      return;
    }
    state.scriptIndex = result;
  }

  void findCorrespondingUNTIL() {
    List<int> repeatList = [];
    int result = 0;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('REPEAT')) {
        repeatList.add(pc);
      }
      if (state.script.substring(pc).toUpperCase().startsWith('UNTIL')) {
        if (repeatList.isEmpty) {
          result = pc;
        } else {
          repeatList.removeLast();
        }
      }
    }
    if (result == 0) {
      _handleError(_REPEATWITHOUTUNTIL);
      return;
    }
    state.scriptIndex = result;
  }

  void executeCommandUNTIL() {
    int repeat = 0;
    try {
      repeat = state.repeatStack.pop();
    } catch (IllegalOperationException) {
      _handleError(_UNTILWITHOUTREPEAT);
      return;
    }

    double result;
    result = evaluateExpression() as double; // get value of expression
    if (result != 0.0) {
      findEOL();
      state.controlStack.pop();
    } else {
      state.scriptIndex = repeat;
      state.repeatStack.push(repeat);
    }
  }

  void executeCommandWHILE() {
    state.whileStack.push(state.scriptIndex - 5);
    state.controlStack.push(WHILELOOP);
    double result = evaluateExpression() as double;
    if (result == 0.0) {
      state.controlStack.pop();
      findCorrespondingWEND();
    }
  }

  void exitLoopWEND() {
    List<int> whileList = [];
    int result = 0;
    bool foundWend = false;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('WHILE')) {
        whileList.add(pc);
      } else {
        if (state.script.substring(pc).toUpperCase().startsWith('WEND')) {
          if (whileList.isEmpty) {
            result = pc + 4;
            foundWend = true;
          } else {
            whileList.removeLast();
          }
        }
      }
      if (foundWend) break;
    }
    if (result == 0) {
      _handleError(_WHILEWITHOUTWEND);
      return;
    }
    state.scriptIndex = result;
  }

  void findCorrespondingWEND() {
    List<int> wendList = [];
    int result = 0;
    bool foundWend = false;
    for (int pc = state.scriptIndex; pc < state.script.length; pc++) {
      if (state.script.substring(pc).toUpperCase().startsWith('WHILE')) {
        wendList.add(pc);
      } else {
        if (state.script.substring(pc).toUpperCase().startsWith('WEND')) {
          if (wendList.isEmpty) {
            result = pc + 4;
            foundWend = true;
            state.whileStack.pop();
          } else {
            wendList.removeLast();
          }
        }
      }
      if (foundWend) break;
    }
    if (result == 0) {
      _handleError(_WHILEWITHOUTWEND);
      return;
    }
    state.scriptIndex = result;
  }

  void executeCommandWEND() {
    try {
      state.scriptIndex = state.whileStack.pop();
    } catch (IllegalOperationException) {
      _handleError(_WENDWITHOUTWHILE);
      return;
    }
  }

  void executeCommandINPUT() {
    String variable;
    Object? input;
    int scriptIndex_save = state.scriptIndex - "input".length;

    getToken();
    if (state.tokenType == QUOTEDSTR) {
      if (!state.continueLoop) {
        state.quotestr = state.token;
        state.STDOUT += state.quotestr + LF;
      }
      getToken();
      if (state.token != ",") {
        _handleError(_SYNTAXERROR);
        return;
      }
      getToken();
    } else if (!state.continueLoop) {
      state.quotestr = '? ';
      state.STDOUT += state.quotestr + LF;
    }
    state.continueLoop = false;

    variable = state.token;
    //if (isNotAVariable(variable)) {
    //  state.variables[variable] = 0;
    //}

    if (state.STDIN.isNotEmpty) {
      input = state.STDIN[0];
      state.STDIN.removeAt(0);
      if (input != null) {
        state.variables[variable] = input;
      } else {
        _handleError(_INPUTIOERROR);
        return;
      }
    } else {
      _handleError(_INPUTMISSING);
      state.scriptIndex = scriptIndex_save; // continue entry point
      return;
    }
  }

  void executeCommandGOSUB() {
    int? location;

    getToken();

    location = state.labelTable.get(state.token);

    if (location == null) {
      _handleError(_LABELNOTDEFINED);
      return;
    } else {
      state.gosubStack.push(state.scriptIndex);

      state.scriptIndex = location;
    }
  }

  void executeCommandRETURN() {
    int location;

    try {
      location = state.gosubStack.pop();
      state.scriptIndex = location;
    } catch (IllegalOperationException) {
      _handleError(_RETURNWITHOUTGOSUB);
      return;
    }
  }

  void executeCommandSCREEN() {
    getToken();
    if (state.token.toString() == '(') {
      getToken();
      if (int.tryParse(state.token) != null) {
        findEOL();
        switch (double.parse(state.token).toInt()) {
          case 0:
            state.graficOutput.GCWizardScriptScreenMode = GCWizardSCript_SCREENMODE.TEXT;
            state.graficOutput.graphics = [];
            state.graficOutput.graphic = false;
            break;
          case 1:
            state.graficOutput.GCWizardScriptScreenMode = GCWizardSCript_SCREENMODE.GRAPHIC;
            state.graficOutput.graphics = [];
            state.graficOutput.graphic = true;
            state.graficOutput.GCWizardSCriptScreenWidth =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicWidthG] as int;
            state.graficOutput.GCWizardSCriptScreenHeight =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicHeightG] as int;
            state.graficOutput.GCWizardSCriptScreenColors =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicColors] as int;
            break;
          case 2:
            state.graficOutput.GCWizardScriptScreenMode = GCWizardSCript_SCREENMODE.TEXTGRAPHIC;
            state.graficOutput.graphics = [];
            state.graficOutput.graphic = true;
            state.graficOutput.GCWizardSCriptScreenWidth =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicWidthG] as int;
            state.graficOutput.GCWizardSCriptScreenHeight =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicHeightG] as int;
            state.graficOutput.GCWizardSCriptScreenColors =
                SCREEN_MODES[double.parse(state.token).toInt()]![_GCWizardScriptGraphicColors] as int;
            break;
          default:
            _handleError(_INVALIDSCREEN);
            return;
        }
      } else {
        _handleError(_INVALIDSCREEN);
        return;
      }
    } else {
      _handleError(_INVALIDSCREEN);
      return;
    }
  }

  void executeCommandBREAK() {
    switch (state.controlStack.pop()) {
      case FORLOOP:
        exitLoopNEXT();
        break;
      case WHILELOOP:
        exitLoopWEND();
        break;
      case REPEATLOOP:
        exitLoopUNTIL();
        break;
      case SWITCHSTATEMENT:
        exitSwitchStatement();
        break;
    }
    findEOL();
  }

  void executeCommandCONTINUE() {
    switch (state.controlStack.top()) {
      case FORLOOP:
        findCorrespondingNEXT();
        break;
      case WHILELOOP:
        findCorrespondingWEND();
        break;
      case REPEATLOOP:
        findCorrespondingUNTIL();
        break;
    }
  }

  Object? executeFunction(String command, int tokType) {
    Object? partialResult1;
    Object? partialResult2;
    Object? partialResult3;
    Object? partialResult4;
    Object? partialResult5;
    Object? partialResult6;
    Object? result = '';

    void executeFunction_0_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        if (state.token == ")") {
          if (_FUNCTIONS[command]!.functionReturn) {
            result = _FUNCTIONS[command]!.functionName();
          } else {
            _FUNCTIONS[command]!.functionName();
          }
          getToken();
        } else {
          _handleError(_INVALIDNUMBEROFPARAMETER);
          result = '';
          return;
        }
      } else {
        _handleError(_SYNTAXERROR);
        result = '';
        return;
      }
    }

    void executeFunction_1_parameter() {
      getToken();
      partialResult1 = evaluateExpressionParantheses();
      if (_FUNCTIONS[command]!.functionReturn) {
        result = _FUNCTIONS[command]!.functionName(partialResult1);
      } else {
        _FUNCTIONS[command]!.functionName(partialResult1);
      }
    }

    void executeFunction_2_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        partialResult1 = evaluateExpressionAddSubOperators();
        if (state.token == ')') {
          _handleError(_INVALIDNUMBEROFPARAMETER);
          return;
        } else if (state.token != ",") {
          _handleError(_MISSINGPARAMETER);
          return;
        } else {
          getToken();
          partialResult2 = evaluateExpressionAddSubOperators();
          if (state.token != ")") {
            _handleError(_UNBALANCEDPARENTHESES);
            return;
          } else {
            if (_FUNCTIONS[command]!.functionReturn) {
              result = _FUNCTIONS[command]!.functionName(partialResult1, partialResult2);
            } else {
              _FUNCTIONS[command]!.functionName(partialResult1, partialResult2);
            }
            getToken();
          }
        }
      } else {
        _handleError(_UNBALANCEDPARENTHESES);
        return;
      }
    }

    void executeFunction_3_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        partialResult1 = evaluateExpressionAddSubOperators();
        if (state.token == ')') {
          _handleError(_INVALIDNUMBEROFPARAMETER);
          return;
        } else if (state.token != ",") {
          _handleError(_MISSINGPARAMETER);
          return;
        } else {
          getToken();
          partialResult2 = evaluateExpressionAddSubOperators();
          if (state.token == ')') {
            _handleError(_INVALIDNUMBEROFPARAMETER);
            return;
          } else if (state.token != ",") {
            _handleError(_MISSINGPARAMETER);
            return;
          } else {
            getToken();
            partialResult3 = evaluateExpressionAddSubOperators();
            if (state.token != ")") {
              _handleError(_UNBALANCEDPARENTHESES);
              return;
            } else {
              getToken();
              if (_FUNCTIONS[command]!.functionReturn) {
                result = _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3);
              } else {
                _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3);
              }
            }
          }
        }
      } else {
        _handleError(_UNBALANCEDPARENTHESES);
        return;
      }
    }

    void executeFunction_4_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        partialResult1 = evaluateExpressionAddSubOperators();
        if (state.token == ')') {
          _handleError(_INVALIDNUMBEROFPARAMETER);
          return;
        } else if (state.token != ",") {
          _handleError(_MISSINGPARAMETER);
          return;
        } else {
          getToken();
          partialResult2 = evaluateExpressionAddSubOperators();
          if (state.token == ')') {
            _handleError(_INVALIDNUMBEROFPARAMETER);
            return;
          } else if (state.token != ",") {
            _handleError(_MISSINGPARAMETER);
            return;
          } else {
            getToken();
            partialResult3 = evaluateExpressionAddSubOperators();
            if (state.token == ')') {
              _handleError(_INVALIDNUMBEROFPARAMETER);
              return;
            } else if (state.token != ",") {
              _handleError(_MISSINGPARAMETER);
              return;
            } else {
              getToken();
              partialResult4 = evaluateExpressionAddSubOperators();
              if (state.token != ")") {
                _handleError(_UNBALANCEDPARENTHESES);
                return;
              } else {
                if (_FUNCTIONS[command]!.functionReturn) {
                  result =
                      _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3, partialResult4);
                } else {
                  _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3, partialResult4);
                }
                getToken();
              }
            }
          }
        }
      } else {
        _handleError(_UNBALANCEDPARENTHESES);
        return;
      }
    }

    void executeFunction_5_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        partialResult1 = evaluateExpressionAddSubOperators();
        if (state.token == ")") {
          _handleError(_UNBALANCEDPARENTHESES);
          return;
        } else if (state.token != ",") {
          _handleError(_MISSINGPARAMETER);
          return;
        } else {
          getToken();
          partialResult2 = evaluateExpressionAddSubOperators();
          if (state.token == ")") {
            _handleError(_UNBALANCEDPARENTHESES);
            return;
          } else if (state.token != ",") {
            _handleError(_MISSINGPARAMETER);
            return;
          } else {
            getToken();
            partialResult3 = evaluateExpressionAddSubOperators();
            if (state.token == ")") {
              _handleError(_UNBALANCEDPARENTHESES);
              return;
            } else if (state.token != ",") {
              _handleError(_MISSINGPARAMETER);
              return;
            } else {
              getToken();
              partialResult4 = evaluateExpressionAddSubOperators();
              if (state.token == ")") {
                _handleError(_UNBALANCEDPARENTHESES);
                return;
              } else if (state.token != ",") {
                _handleError(_MISSINGPARAMETER);
                return;
              } else {
                getToken();
                partialResult5 = evaluateExpressionAddSubOperators();
                if (state.token != ")") {
                  _handleError(_UNBALANCEDPARENTHESES);
                  return;
                } else {
                  if (_FUNCTIONS[command]!.functionReturn) {
                    result = _FUNCTIONS[command]!
                        .functionName(partialResult1, partialResult2, partialResult3, partialResult4, partialResult5);
                  } else {
                    _FUNCTIONS[command]!
                        .functionName(partialResult1, partialResult2, partialResult3, partialResult4, partialResult5);
                  }
                  getToken();
                }
              }
            }
          }
        }
      } else {
        _handleError(_UNBALANCEDPARENTHESES);
        return;
      }
    }

    void executeFunction_6_parameter() {
      getToken();
      if (state.token == "(") {
        getToken();
        partialResult1 = evaluateExpressionAddSubOperators();
        if (state.token == ')') {
          _handleError(_INVALIDNUMBEROFPARAMETER);
          return;
        } else if (state.token != ",") {
          _handleError(_MISSINGPARAMETER);
          return;
        } else {
          getToken();
          partialResult2 = evaluateExpressionAddSubOperators();
          if (state.token == ')') {
            _handleError(_INVALIDNUMBEROFPARAMETER);
            return;
          } else if (state.token != ",") {
            _handleError(_MISSINGPARAMETER);
            return;
          } else {
            getToken();
            partialResult3 = evaluateExpressionAddSubOperators();
            if (state.token == ')') {
              _handleError(_INVALIDNUMBEROFPARAMETER);
              return;
            } else if (state.token != ",") {
              _handleError(_MISSINGPARAMETER);
              return;
            } else {
              getToken();
              partialResult4 = evaluateExpressionAddSubOperators();
              if (state.token == ')') {
                _handleError(_INVALIDNUMBEROFPARAMETER);
                return;
              } else if (state.token != ",") {
                _handleError(_MISSINGPARAMETER);
                return;
              } else {
                getToken();
                partialResult5 = evaluateExpressionAddSubOperators();
                if (state.token == ')') {
                  _handleError(_INVALIDNUMBEROFPARAMETER);
                  return;
                } else if (state.token != ",") {
                  _handleError(_MISSINGPARAMETER);
                  return;
                } else {
                  getToken();
                  partialResult6 = evaluateExpressionAddSubOperators();
                  if (state.token != ")") {
                    _handleError(_UNBALANCEDPARENTHESES);
                    return;
                  } else {
                    if (_FUNCTIONS[command]!.functionReturn) {
                      result = _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3,
                          partialResult4, partialResult5, partialResult6);
                    } else {
                      _FUNCTIONS[command]!.functionName(partialResult1, partialResult2, partialResult3, partialResult4,
                          partialResult5, partialResult6);
                    }
                    getToken();
                  }
                }
              }
            }
          }
        }
      } else {
        _handleError(_UNBALANCEDPARENTHESES);
        return;
      }
    }

    try {
      switch (_FUNCTIONS[command]!.functionParamCount) {
        case 0:
          executeFunction_0_parameter();
          break;
        case 1:
          executeFunction_1_parameter();
          break;
        case 2:
          executeFunction_2_parameter();
          break;
        case 3:
          executeFunction_3_parameter();
          break;
        case 4:
          executeFunction_4_parameter();
          break;
        case 5:
          executeFunction_5_parameter();
          break;
        case 6:
          executeFunction_6_parameter();
          break;
        default:
          _handleError(_INVALIDNUMBEROFPARAMETER);
          result = '';
      }
      return result;
    } catch (exception) {
      if (exception.toString().split(' ').contains("'_GCWList?'")) {
        _handleError(_LISTNOTDEFINED);
        return '';
      }
    }
    return '';
  }

  Object? evaluateExpression() {
    Object? result;

    getToken();
    if (state.token == EOP) {
      _handleError(_NOEXPRESSION);
      return null;
    }

    result = evaluateExpressionRelationalOperation();

    putBack();

    return result;
  }

  Object? evaluateExpressionRelationalOperation() {
    Object? l_temp, r_temp, result;
    String op;

    result = evaluateExpressionAddSubOperators();

    if (state.token == EOP) return result;

    op = state.token[0];

    if (isRelationalOperator(op)) {
      l_temp = result;
      getToken();

      r_temp = evaluateExpressionRelationalOperation();

      if (_isNotANumber(l_temp) || _isNotANumber(r_temp)) {
        _handleError(_INVALIDTYPECAST);
        result = 0.0;
      } else {
        if (_isAString(l_temp)) {
          switch (op) {
            case '<':
            case LE:
            case '>':
            case GE:
            case OR:
            case AND:
              _handleError(_INVALIDTYPECAST);
              result = 0.0;
              break;
            case '=':
              if ((l_temp as String) == (r_temp as String)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case NE:
              if ((l_temp as String) != (r_temp as String)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
          }
        } else {
          switch (op) {
            case '<':
              if ((l_temp as num) < (r_temp as num)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case LE:
              if ((l_temp as num) <= (r_temp as num)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case '>':
              if ((l_temp as num) > (r_temp as num)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case GE:
              if ((l_temp as num) >= (r_temp as num)) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case '=':
              if (l_temp == r_temp) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case NE:
              if (l_temp != r_temp) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
            case OR:
              if (l_temp == 0.0 && r_temp == 0.0) {
                result = 0.0;
              } else {
                result = 1.0;
              }
              break;
            case AND:
              if (l_temp != 0.0 && r_temp != 0.0) {
                result = 1.0;
              } else {
                result = 0.0;
              }
              break;
          }
        }
      }
    }
    return result;
  }

  Object? evaluateExpressionAddSubOperators() {
    String op;
    Object? result;
    Object? partialResult;

    result = evaluateExpressionMultDivOperators();

    while ((op = state.token[0]) == '+' || op == '-') {
      getToken();
      partialResult = evaluateExpressionMultDivOperators();
      if (_isAList(result) || _isAList(partialResult)) {
        _handleError(_INVALIDTYPECAST);
      } else {
        switch (op) {
          case '-':
            if (_isNotANumber(result)) {
              //Todo only on minus (no plus)
              _handleError(_INVALIDSTRINGOPERATION);
            } else {
              result = (result as num) - (partialResult as num);
            }
            break;
          case '+':
            if (_isAString(result) && _isAString(partialResult)) {
              result = (result as String) + (partialResult as String);
            } else if (_isANumber(result) && _isANumber(partialResult)) {
              result = (result as num) + (partialResult as num);
            } else {
              _handleError(_INVALIDSTRINGOPERATION);
            }
            break;
        }
      }
    }
    return result;
  }

  Object? evaluateExpressionMultDivOperators() {
    String op;
    Object? result;
    Object? partialResult;

    result = evaluateExpressionExponentOperator();
    while ((op = state.token[0]) == '*' || op == '/' || op == '%') {
      getToken();
      partialResult = evaluateExpressionExponentOperator();
      if (_isNotANumber(result) || _isNotANumber(partialResult)) {
        _handleError(_INVALIDTYPECAST);
      } else {
        switch (op) {
          case '*':
            result = (result as num) * (partialResult as num);
            break;
          case '/':
            if (partialResult == 0.0) {
              _handleError(_DIVISIONBYZERO);
              result = 0;
            } else {
              result = (result as num) / (partialResult as num);
            }
            break;
          case '%':
            if (partialResult == 0.0) {
              _handleError(_DIVISIONBYZERO);
              result = 0;
            } else {
              result = (result as num) % (partialResult as num);
            }
            break;
        }
      }
    }
    return result;
  }

  Object? evaluateExpressionExponentOperator() {
    Object? result;
    Object? partialResult;
    Object? base;

    //result = evaluateExpressionUnaryFunctionOperator();
    result = evaluateExpressionBitwiseOperators();

    if (state.token == "^") {
      getToken();
      partialResult = evaluateExpressionExponentOperator();
      if (_isNotANumber(result) || _isNotANumber(partialResult)) {
        _handleError(_INVALIDTYPECAST);
        return 0.0;
      }
      base = result;
      if (_isNotANumber(result) || _isNotANumber(partialResult)) {
        _handleError(_INVALIDTYPECAST);
      } else if (partialResult == 0.0) {
        result = 1.0;
      } else {
        result = pow((base as num), (partialResult as num));
      }
    }
    return result;
  }

  Object? evaluateExpressionBitwiseOperators() {
    String op;
    Object? result;
    Object? partialResult;

    result = evaluateExpressionUnaryFunctionOperator();

    while ((op = state.token[0]) == '→' || op == '←' || op == '&' || op == '|') {
      getToken();
      partialResult = evaluateExpressionUnaryFunctionOperator();
      if (_isNotAInt(partialResult) || _isNotAInt(result)) {
        _handleError(_INVALIDTYPECAST);
      } else {
        switch (op) {
          case '→': // shift right
            result = (result as int) >> (partialResult as int);
            break;
          case '←': // shift left
            result = (result as int) << (partialResult as int);
            break;
          case '&': // and
            result = (result as int) & (partialResult as int);
            break;
          case '|': // or
            result = (result as int) | (partialResult as int);
            break;
        }
      }
    }

    return result;
  }

  Object? evaluateExpressionUnaryFunctionOperator() {
    Object? result;
    String op = '';

    if ((state.tokenType == DELIMITER) && state.token == "+" || state.token == "-" || state.token == "~") {
      op = state.token;
      getToken();
    }
    if (state.tokenType == FUNCTION) {
      result = executeFunction(state.token, state.tokenType);
    } else {
      result = evaluateExpressionParantheses();
    }

    if (op == "-") {
      result = -(result as dynamic);
    } else {
      if (op == "~") {
        if (_isNotAInt(result)) {
          _handleError(_INVALIDTYPECAST);
        } else {
          result = ~(result as dynamic);
        }
      }
    }
    return result;
  }

  Object? evaluateExpressionParantheses() {
    Object? result;
    if (state.token == "(") {
      getToken();
      result = evaluateExpressionAddSubOperators();
      if (state.token != ")") _handleError(_UNBALANCEDPARENTHESES);
      getToken();
    } else {
      result = getValueOfAtomExpression();
    }
    return result;
  }

  Object? getValueOfAtomExpression() {
    Object? result;
    switch (state.tokenType) {
      case QUOTEDSTR:
        result = state.token;
        getToken();
        break;
      case NUMBER:
        try {
          result = int.tryParse(state.token);
          result ??= double.parse(state.token);
        } catch (NumberFormatException) {
          _handleError(_SYNTAXERROR);
        }
        getToken();
        break;
      case VARIABLE:
        result = getValueOfVariable(state.token);
        getToken();
        break;
      case FUNCTION:
        result = state.token;
        getToken();
        break;
      default:
        _handleError(_SYNTAXERROR);
        break;
    }
    return result;
  }

  Object? getValueOfVariable(String variableName) {
    if (_GCWIZARDSCRIPT_SCIENCE_CONST[variableName.toUpperCase()] != null) {
      return _GCWIZARDSCRIPT_SCIENCE_CONST[variableName.toUpperCase()];
    } else {
      if (isNotAVariable(variableName)) {
        state.variables[variableName] = 0.0;
      }
      return state.variables[variableName];
    }
  }

  void putBack() {
    if (state.token == EOP) return;
    for (int i = 0; i < state.token.length; i++) {
      state.scriptIndex--;
    }
  }

  bool isTokenAFunction() {
    for (int i = 17; i > 1; i--) {
      if (_IMPLEMENTED_FUNCTIONS[i]!.contains(state.script
          .substring(state.scriptIndex,
              (state.scriptIndex + (i + 1) < state.script.length) ? state.scriptIndex + (i + 1) : state.scriptIndex)
          .toUpperCase())) {
        state.token = state.script.substring(state.scriptIndex, state.scriptIndex + i).toUpperCase();
        state.scriptIndex += i;
        return true;
      }
    }
    return false;
  }

  void getToken() {
    String character;

    state.tokenType = NONE;
    state.token = "";
    state.keywordToken = UNKNOWNCOMMAND;

    if (state.scriptIndex >= state.script.length) {
      state.token = EOP;
      return;
    }

    while (state.scriptIndex < state.script.length && isSpaceOrTab(state.script[state.scriptIndex])) {
      state.scriptIndex++;
    }

    if (state.scriptIndex == state.script.length) {
      state.token = EOP;
      state.tokenType = DELIMITER;
      return;
    }

    if (state.script[state.scriptIndex] == CR) {
      state.scriptIndex += 2;
      state.keywordToken = EOL;
      state.token = "\r\n";
      return;
    }

    if (state.script[state.scriptIndex] == LF) {
      state.scriptIndex += 1;
      state.keywordToken = EOL;
      state.token = "\n";
      return;
    }

    character = state.script[state.scriptIndex];
    if (character == '<' || character == '>' || character == '|' || character == '&' || character == '!') {
      if (state.scriptIndex + 1 == state.script.length) _handleError(_SYNTAXERROR);

      switch (character) {
        case '<':
          if (state.script[state.scriptIndex + 1] == '>') {
            state.scriptIndex += 2;
            state.token = NE.toString();
          } else if (state.script[state.scriptIndex + 1] == '=') {
            state.scriptIndex += 2;
            state.token = LE.toString();
          } else {
            state.scriptIndex++;
            state.token = "<";
          }
          break;
        case '>':
          if (state.script[state.scriptIndex + 1] == '=') {
            state.scriptIndex += 2;
            state.token = GE.toString();
          } else {
            state.scriptIndex++;
            state.token = ">";
          }
          break;
        case '!':
          if (state.script[state.scriptIndex + 1] == '=') {
            state.scriptIndex += 2;
            state.token = NE.toString();
          } else {
            state.scriptIndex++;
            state.token = "!";
          }
          break;
        case '&':
          if (state.script[state.scriptIndex + 1] == '&') {
            state.scriptIndex += 2;
            state.token = AND.toString();
          } else {
            state.scriptIndex++;
            state.token = "&";
          }
          break;
        case '|':
          if (state.script[state.scriptIndex + 1] == '|') {
            state.scriptIndex += 2;
            state.token = OR.toString();
          } else {
            state.scriptIndex++;
            state.token = "|";
          }
          break;
      }
      state.tokenType = DELIMITER;
      return;
    }

    if (isTokenAFunction()) {
      state.tokenType = FUNCTION;
    } else if (isDelimiter(state.script[state.scriptIndex])) {
      state.token += state.script[state.scriptIndex];
      state.scriptIndex++;
      state.tokenType = DELIMITER;
    } else if (_isALetter(state.script[state.scriptIndex])) {
      while (!isDelimiter(state.script[state.scriptIndex])) {
        state.token += state.script[state.scriptIndex];
        state.scriptIndex++;
        if (state.scriptIndex >= state.script.length) break;
      }
      state.keywordToken = lookUpToken(state.token);
      if (state.keywordToken == UNKNOWNCOMMAND) {
        state.tokenType = VARIABLE;
      } else {
        state.tokenType = COMMAND;
      }
    } else if (_isADigit(state.script[state.scriptIndex])) {
      while (!isDelimiter(state.script[state.scriptIndex])) {
        state.token += state.script[state.scriptIndex];
        state.scriptIndex++;
        if (state.scriptIndex >= state.script.length) break;
      }
      state.tokenType = NUMBER;
    } else if (state.script[state.scriptIndex] == '"') {
      state.scriptIndex++;
      character = state.script[state.scriptIndex];
      while (character != '"' && (character != CR || character != LF)) {
        state.token += character;
        state.scriptIndex++;
        character = state.script[state.scriptIndex];
      }
      if (character == CR || character == LF) _handleError(_MISSINGQUOTE);
      state.scriptIndex++;
      state.tokenType = QUOTEDSTR;
    } else {
      state.token = EOP;
      return;
    }
  }

  bool isDelimiter(String c) {
    if ((" \n\r,;<>+-/*%^=()&|←→~".contains(c))) return true;
    return false;
  }

  bool isSpaceOrTab(String c) {
    if (c == ' ' || c == '\t') return true;
    return false;
  }

  bool isRelationalOperator(String c) {
    if (relationOperators.contains(c)) return true;
    return false;
  }

  int lookUpToken(String s) {
    s = s.toLowerCase();

    if (registeredKeywords[s] != null) {
      return registeredKeywords[s] as int;
    } else {
      return UNKNOWNCOMMAND;
    }
  }

  bool isNotAVariable(String vname) {
    if (state.variables[vname] == null) return true;
    return false;
  }
}
