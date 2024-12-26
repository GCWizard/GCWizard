part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

class InterpreterJobData {
  final String jobDataScript;
  final String jobDataInput;
  final LatLng jobDataCoords;
  final ScriptState? continueState;

  InterpreterJobData(
      {required this.jobDataScript, required this.jobDataInput, required this.jobDataCoords, this.continueState});
}

class GCWizardScriptOutput {
  final String STDOUT;
  final GraphicState Graphic;
  final List<GCWMapPoint> Points;
  final String ErrorMessage;
  final int ErrorPosition;
  final List<List<String>> VariableDump;
  final GCWizardScriptBreakType BreakType;
  ScriptState? continueState;
  final List<int> FILE;
  final bool fileSaved;
  final double randomNumber;

  GCWizardScriptOutput({
    required this.STDOUT,
    required this.Graphic,
    required this.Points,
    required this.ErrorMessage,
    required this.ErrorPosition,
    required this.VariableDump,
    required this.BreakType,
    required this.FILE,
    required this.fileSaved,
    required this.randomNumber,
    this.continueState,
  });

  static GCWizardScriptOutput empty() {
    return GCWizardScriptOutput(
      STDOUT: '',
      Graphic: GraphicState(),
      Points: [],
      ErrorMessage: '',
      ErrorPosition: 0,
      VariableDump: [],
      FILE: Uint8List.fromList([]),
      fileSaved: false,
      randomNumber: 0.0,
      BreakType: GCWizardScriptBreakType.NULL,
    );
  }
}

class GraphicState {
  List<String> graphics = [];
  GCWizardSCript_SCREENMODE GCWizardScriptScreenMode = GCWizardSCript_SCREENMODE.TEXT;
  int GCWizardSCriptScreenWidth = 0;
  int GCWizardSCriptScreenHeight = 0;
  int GCWizardSCriptScreenColors = 0;
  bool graphic = false;
}

class _GCWizardScriptClassFunctionDefinition {
  final Function functionName;
  final int functionParamCount;
  final bool functionReturn;

  const _GCWizardScriptClassFunctionDefinition(this.functionName, this.functionParamCount,
      {this.functionReturn = true});
}

class _GCWizardScriptClassLabelStack {
  Map<String, int> _contents = {};

  _GCWizardScriptClassLabelStack() {
    _contents = {};
  }

  int push(String key, int value) {
    if (_contents[key] == null) {
      _contents[key] = value;
      return 0;
    } else {
      return -1;
    }
  }

  int? get(String key) {
    return _contents[key];
  }

  @override
  String toString() {
    String result = '';
    _contents.forEach((key, value) {
      result = result + key + ', ' + value.toString() + '\n';
    });
    return result;
  }

  void clear() {
    _contents.clear();
  }
}

class _GCWizardScriptClassForLoopInfo {
  late String loopVariable; // counter variable
  late num targetValue; // target value
  late bool descending;
  late num stepValue;
  late int loopStart; // index in source code to loop to
}

class ScriptState {
  late String script;
  late String inputData;
  GCWizardScriptBreakType BreakType = GCWizardScriptBreakType.NULL;
  Map<String, Object?> variables = _GCWIZARDSCRIPT_SCIENCE_CONST;
  List<String> get graphics {
    return graficOutput.graphics;
  }

  GraphicState graficOutput = GraphicState();
  List<GCWMapPoint> waypoints = [];

  int scriptIndex = 0;

  List<Object?> STDIN = [];
  String STDOUT = '';
  num step = 1.0;

  String token = '';
  int tokenType = 0;

  int keywordToken = 0;

  bool executeElse = false;

  List<Object?> listDATA = [];
  int pointerDATA = 0;
  String quotestr = '';
  bool continueLoop = false;

  List<int> FILE = [];
  int FILEINDEX = 0;
  bool fileSaved = false;

  double randomNumber = 0.0;

  _GCWizardScriptClassLabelStack labelTable = _GCWizardScriptClassLabelStack();
  datastack.Stack<_GCWizardScriptClassForLoopInfo> forStack = datastack.Stack<_GCWizardScriptClassForLoopInfo>();
  datastack.Stack<int> gosubStack = datastack.Stack<int>();
  datastack.Stack<int> repeatStack = datastack.Stack<int>();
  datastack.Stack<int> whileStack = datastack.Stack<int>();
  datastack.Stack<String> switchStack = datastack.Stack<String>();
  datastack.Stack<bool> ifStack = datastack.Stack<bool>();
  datastack.Stack<int> controlStack = datastack.Stack<int>();

  //errors
  bool halt = false;
  String errorMessage = '';
  int errorPosition = 0;

  double GCWizardScript_LAT = 0.0;
  double GCWizardScript_LON = 0.0;

  ScriptState({LatLng? coords}) {
    // Initialize for new program run.
    scriptIndex = 0;
    forStack = datastack.Stack<_GCWizardScriptClassForLoopInfo>();
    gosubStack = datastack.Stack<int>();
    repeatStack = datastack.Stack<int>();
    whileStack = datastack.Stack<int>();
    variables = {}; //SCIENCE_CONST;
    STDOUT = '';

    randomNumber = 0.0;
    step = 1.0;
    listDATA = [];
    FILE = [];
    FILEINDEX = 0;
    fileSaved = false;

    pointerDATA = 0;
    waypoints = [];

    if (coords != null) {
      GCWizardScript_LAT = coords.latitude;
      GCWizardScript_LON = coords.longitude;
    }
  }

  void addInput(String inputData) {
    inputData.split(' ').forEach((element) {
      if (element.isEmpty) {
      } else if (int.tryParse(element) != null) {
        STDIN.add(int.parse(element).toDouble());
      } else if (double.tryParse(element) != null) {
        STDIN.add(double.parse(element));
      } else {
        STDIN.add(element);
      }
    });
  }

  void addFile(Uint8List inputFile) {
    FILE = inputFile;
  }
}
