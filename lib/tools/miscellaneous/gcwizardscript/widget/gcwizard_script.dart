import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_export_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_code_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';
import 'package:gc_wizard/tools/miscellaneous/gcwizardscript/widget/gcwizard_script_help.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

class GCWizardScript extends StatefulWidget {
  const GCWizardScript({Key? key}) : super(key: key);

  @override
  GCWizardScriptState createState() => GCWizardScriptState();
}

class GCWizardScriptState extends State<GCWizardScript> {
  late TextEditingController _programController;
  late TextEditingController _outputController;

  String _currentProgram = '';
  String _currentInput = '';

  GCWizardScriptOutput _currentOutput = GCWizardScriptOutput.empty();

  Uint8List _outGraphicData = Uint8List.fromList([]);
  bool _loadFile = false;

  bool _loadCoords = false;
  var _currentCoords = defaultBaseCoordinate;

  @override
  void initState() {
    super.initState();
    _programController = TextEditingController(text: _currentProgram);
    _outputController = TextEditingController(text: '');

    _programController = CodeController(
      text: _currentProgram,
      language: getLanguage(CodeHighlightingLanguage.BASIC),
      stringMap: _buildHiglightMap(),
    );
  }

  @override
  void dispose() {
    _programController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWCodeTextField(
          lineNumbers: false,
          lineNumberStyle: const GCWCodeTextFieldLineNumberStyle(width: 48),
          controller: _programController,
          language: CodeHighlightingLanguage.BASIC,
          readOnly: false,
          onChanged: (text) {
            setState(() {
              _currentProgram = text;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GCWIconButton(
              icon: Icons.run_circle_outlined,
              size: IconButtonSize.SMALL,
              onPressed: () {
                _currentInput = '';
                _currentOutput.continueState = null;
                _interpretGCWScriptAsync();
              },
            ),
            GCWIconButton(
              icon: Icons.file_open,
              size: IconButtonSize.SMALL,
              onPressed: () {
                setState(() {
                  _loadFile = !_loadFile;
                });
              },
            ),
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              onPressed: () {
                _exportFile(context, Uint8List.fromList(_currentProgram.codeUnits), GCWizardScriptFileType.PROGRAM);
              },
            ),
            GCWIconButton(
              icon: Icons.clear,
              size: IconButtonSize.SMALL,
              onPressed: () {
                setState(() {
                  _programController.text = '';
                  _currentProgram = '';
                  _currentOutput = GCWizardScriptOutput.empty();
                });
              },
            ),
            GCWIconButton(
              icon: Icons.help_outline,
              size: IconButtonSize.SMALL,
              onPressed: () {
                _openHelpWidget(context);
              },
            ),
            GCWIconButton(
              icon: Icons.location_on,
              size: IconButtonSize.SMALL,
              onPressed: () {
                setState(() {
                  _loadCoords = !_loadCoords;
                });
              },
            ),
          ],
        ),
        if (_loadFile)
          GCWOpenFile(
            onLoaded: (_file) {
              if (_file == null) {
                showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
                _loadFile = !_loadFile;
                return;
              }

              _currentProgram = String.fromCharCodes(_file.bytes);
              _programController.text = _currentProgram;
              _loadFile = !_loadFile;
              setState(() {});
            },
          ),
        if (_loadCoords)
          GCWCoords(
            title: i18n(context, 'gcwizard_script_coords'),
            coordsFormat: _currentCoords.format,
            onChanged: (ret) {
              setState(() {
                if (ret != null) {
                  _currentCoords = ret;
                }
              });
            },
          ),
        _buildOutput(context),
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    return Column(
      children: <Widget>[
        _builOutputGraphics(),
        _buildOutputText(),
        _buildOutputWaypoints(),
        _buildOutputErrorText(),
        _buildOutputMemoryDump(),
      ],
    );
  }

  Widget _buildOutputText() {
    if (_outputController.text == '') {
      return Container();
    } else {
      if (_currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.TEXT ||
          _currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.TEXTGRAPHIC) {
        return GCWDefaultOutput(
            trailing: Row(
              children: <Widget>[
                GCWIconButton(
                  icon: Icons.clear,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    setState(() {
                      _currentOutput = GCWizardScriptOutput.empty();
                      _outputController.text = '';
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.copy,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    insertIntoGCWClipboard(context, _outputController.text);
                  },
                ),
                GCWIconButton(
                  icon: Icons.save,
                  size: IconButtonSize.SMALL,
                  onPressed: () {
                    _exportFile(
                        context, Uint8List.fromList(_outputController.text.codeUnits), GCWizardScriptFileType.OUTPUT);
                  },
                ),
              ],
            ),
            child: GCWCodeTextField(
              lineNumbers: false,
              controller: _outputController,
              readOnly: true,
              onChanged: (text) {
                setState(() {});
              },
            ));
      } else {
        return Container();
      }
    }
  }

  Widget _builOutputGraphics() {
    if (_currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.GRAPHIC ||
        _currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.TEXTGRAPHIC) {
      return GCWDefaultOutput(
        child: (_outGraphicData.isNotEmpty)
            ? GCWImageView(
                imageData: GCWImageViewData(GCWFile(bytes: _outGraphicData)),
                suppressOpenInTool: const {
                  GCWImageViewOpenInTools.METADATA,
                  GCWImageViewOpenInTools.HIDDENDATA,
                  GCWImageViewOpenInTools.HEXVIEW
                },
              )
            : Container(),
      );
    } else {
      return Container();
    }
  }

  Widget _buildOutputWaypoints() {
    if (_currentOutput.Points.isNotEmpty) {
      return Column(children: <Widget>[
        GCWTextDivider(
          trailing: Row(
            children: <Widget>[
              GCWIconButton(
                icon: Icons.my_location,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  _openInMap(_currentOutput.Points);
                },
              ),
              GCWIconButton(
                icon: Icons.save,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  _exportCoordinates(context, _currentOutput.Points);
                },
              ),
            ],
          ),
          text: i18n(context, 'gcwizard_script_waypoints'),
        ),
        GCWOutput(
          child: GCWOutputText(
            style: gcwMonotypeTextStyle(),
            text: _buildWayPointList(_currentOutput.Points),
            isMonotype: true,
          ),
        ),
      ]);
    } else {
      return Container();
    }
  }

  Widget _buildOutputMemoryDump() {
    if (_currentOutput.VariableDump.isNotEmpty) {
      List<List<String>> memoryDump = [
        [i18n(context, 'gcwizard_script_dump_variable'), i18n(context, 'gcwizard_script_dump_value')]
      ];
      memoryDump.addAll(_currentOutput.VariableDump);
      return GCWExpandableTextDivider(
        suppressTopSpace: false,
        expanded: false,
        text: i18n(context, 'gcwizard_script_dump'),
        child: GCWColumnedMultilineOutput(
          data: memoryDump,
          hasHeader: true,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildOutputErrorText() {
    if (_currentOutput.ErrorMessage.isEmpty) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          GCWOutputText(
            style: gcwMonotypeTextStyle(),
            text: _currentOutput.STDOUT +
                '\n' +
                i18n(context, _currentOutput.ErrorMessage) +
                '\n' +
                i18n(context, 'gcwizard_script_error_line') +
                ' ' +
                _printFaultyLine(_currentProgram, _currentOutput.ErrorPosition) +
                '\n' +
                i18n(context, 'gcwizard_script_error_position') +
                ' ' +
                _currentOutput.ErrorPosition.toString() +
                '\n' +
                '=> ' +
                _printFaultyProgram(_currentProgram, _currentOutput.ErrorPosition),
            isMonotype: true,
          ),
        ],
      );
    }
  }

  Future<GCWAsyncExecuterParameters?> _buildInterpreterJobData() async {
    return GCWAsyncExecuterParameters(InterpreterJobData(
        jobDataScript: _currentProgram,
        jobDataInput: _currentInput,
        jobDataCoords: _currentCoords.toLatLng()!,
        continueState: _currentOutput.continueState));
  }

  void _showInterpreterOutput(GCWizardScriptOutput output) {
    _currentOutput = output;
    _outputController.text = _currentOutput.STDOUT;

    if (output.continueState != null) {
      switch (output.BreakType) {
        case GCWizardScriptBreakType.INPUT:
          _outputController.text = _currentOutput.STDOUT;
          break;
        case GCWizardScriptBreakType.PRINT:
          _outputController.text = _currentOutput.STDOUT;
          break;
        case GCWizardScriptBreakType.OPENFILE:
          break;
        case GCWizardScriptBreakType.SAVEFILE:
          break;
        case GCWizardScriptBreakType.NULL:
          break;
      }
    } else {
      _outputController.text = _currentOutput.STDOUT;
      if (_currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.GRAPHIC ||
          _currentOutput.Graphic.GCWizardScriptScreenMode == GCWizardSCript_SCREENMODE.TEXTGRAPHIC) {
        _createImage(_currentOutput.Graphic).then((value) {
          setState(() {
            _outGraphicData = value;
          });
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        switch (output.BreakType) {
          case GCWizardScriptBreakType.INPUT:
            _showDialogBoxInput(context, output.continueState?.quotestr ?? '');
            break;
          case GCWizardScriptBreakType.PRINT:
            if (_currentOutput.continueState != null) {
              _interpretGCWScriptAsync();
            }
            break;
          case GCWizardScriptBreakType.OPENFILE:
            _openFile();
            break;
          case GCWizardScriptBreakType.SAVEFILE:
            _currentOutput.continueState!.fileSaved = true;
            _exportFile(context, Uint8List.fromList(_currentOutput.FILE), GCWizardScriptFileType.FILE);
            _interpretGCWScriptAsync();
            break;
          case GCWizardScriptBreakType.NULL:
            break;
        }
      });
    });
  }

  void _interpretGCWScriptAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<GCWizardScriptOutput>(
              isolatedFunction: GCWizardScriptInterpretScriptAsync,
              parameter: _buildInterpreterJobData,
              onReady: (data) => _showInterpreterOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  String _printFaultyLine(String program, int position) {
    String line = '';
    int pc = position >= program.length ? program.length - 1 : position;
    if (program.isNotEmpty) {
      while (pc > 0 && program[pc] != '\n') {
        line = program[pc] + line;
        pc--;
      }
      pc = position + 1;
      while (pc < program.length && program[pc] != '\n') {
        line = line + program[pc];
        pc++;
      }
    }
    return line;
  }

  String _printFaultyProgram(String program, int position) {
    String result = '';

    if (program.isNotEmpty) {
      if (position > 0) {
        result = (position < program.length) ? program[position - 1] : program[program.length - 1];
      }
      for (int i = position; (i < program.length && i < position + 6); i++) {
        result = result + program[i];
      }
    }
    return result.replaceAll('\n', '↩') + '\n' + '   ^';
  }

  void _showDialogBoxInput(BuildContext context, String text) {
    showGCWDialog(
        context,
        text,
        SizedBox(
          width: 300,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GCWTextField(
                autofocus: true,
                filled: true,
                onChanged: (text) {
                  _currentInput = text;
                },
              ),
            ],
          ),
        ),
        [
          GCWDialogButton(
            text: i18n(context, 'common_ok'),
            onPressed: () {
              if (_currentOutput.continueState != null) {
                _currentOutput.continueState!.addInput(_currentInput);
                _interpretGCWScriptAsync();
              }
            },
          )
        ],
        cancelButton: false);
  }

  void _exportFile(BuildContext context, Uint8List data, GCWizardScriptFileType fileType) async {
    bool value = false;
    String filename = '';

    switch (fileType) {
      case GCWizardScriptFileType.IMAGE:
        filename = buildFileNameWithDate('img_', FileType.PNG);
        break;
      case GCWizardScriptFileType.PROGRAM:
        filename = buildFileNameWithDate('prg_', null) + '.script';
        break;
      case GCWizardScriptFileType.OUTPUT:
        filename = buildFileNameWithDate('out_', null) + '.out';
        break;
      case GCWizardScriptFileType.WAYPOINT:
        filename = buildFileNameWithDate('out_', null) + '.wpt';
        break;
      case GCWizardScriptFileType.FILE:
        filename = buildFileNameWithDate('out_', null) + '.dat';
        break;
    }
    value = await saveByteDataToFile(context, data, filename);
    if (value) showExportedFileDialog(context);
  }

  void _openFile() async {
    openFileExplorer(allowedFileTypes: []).then((GCWFile? file) {
      if (file != null) {
        if (_currentOutput.continueState != null) {
          _currentOutput.continueState!.addFile(file.bytes);
          _interpretGCWScriptAsync();
        }
      } else {
        showSnackBar(i18n(context, 'common_loadfile_exception_nofile'), context);
      }
    });
  }

  Future<bool> _exportCoordinates(BuildContext context, List<GCWMapPoint> points) async {
    if (points.isNotEmpty) {
      showCoordinatesExportDialog(context, points, []);
    }
    return false;
  }

  void _openHelpWidget(
    BuildContext context,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: const GCWizardScriptHelp(),
                toolName: i18n(context, 'gcwizard_script_title') + ' ' + i18n(context, 'gcwizard_script_help'),
                id: '')));
  }

  void _openInMap(
    List<GCWMapPoint> points,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute<GCWTool>(
            builder: (context) => GCWTool(
                tool: GCWMapView(
                  points: List<GCWMapPoint>.from(points),
                  isEditable: false, // false: open in Map
                  // true:  open in FreeMap
                ),
                id: 'coords_map_view',
                autoScroll: false,
                suppressToolMargin: true)));
  }

  String _buildWayPointList(List<GCWMapPoint> points) {
    List<String> result = [];
    for (GCWMapPoint point in points) {
      result.add(
          point.point.latitude.toStringAsFixed(6).padLeft(10) + point.point.longitude.toStringAsFixed(6).padLeft(12));
    }
    return result.join('\n');
  }

  Future<Uint8List> _createImage(GraphicState graphic) async {
    double imageWidth = graphic.GCWizardSCriptScreenWidth.toDouble();
    double imageHeight = graphic.GCWizardSCriptScreenHeight.toDouble();
    double pointsize = 1.0;
    List<String> graphicCommand = [];

    final canvasRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(canvasRecorder, ui.Rect.fromLTWH(0, 0, imageWidth, imageHeight));

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = pointsize.toDouble();

    canvas.drawRect(Rect.fromLTWH(0, 0, imageWidth, imageHeight), paint);
    for (String command in graphic.graphics) {
      graphicCommand = command.split(' ');
      switch (graphicCommand[0]) {
        case 'TEXT': // TEXT(T,X,Y,S)
          final textStyle = ui.TextStyle(
            color: paint.color,
            fontSize: double.parse(graphicCommand[4]),
          );
          final paragraphStyle = ui.ParagraphStyle(
            textDirection: ui.TextDirection.ltr,
          );
          final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
            ..pushStyle(textStyle)
            ..addText(graphicCommand[1].replaceAll('⟳', ' '));
          const constraints = ui.ParagraphConstraints(width: 300);
          final paragraph = paragraphBuilder.build();
          paragraph.layout(constraints);
          canvas.drawParagraph(paragraph, Offset(double.parse(graphicCommand[2]), double.parse(graphicCommand[3])));
          break;
        case 'BOX':
          canvas.drawRect(
              Rect.fromLTRB(double.parse(graphicCommand[1]), double.parse(graphicCommand[2]),
                  double.parse(graphicCommand[3]), double.parse(graphicCommand[4])),
              paint);
          break;
        case 'OVAL':
          canvas.drawOval(
              Rect.fromLTRB(double.parse(graphicCommand[1]), double.parse(graphicCommand[2]),
                  double.parse(graphicCommand[3]), double.parse(graphicCommand[4])),
              paint);
          break;
        case 'CIRCLE':
          canvas.drawCircle(Offset(double.parse(graphicCommand[1]), double.parse(graphicCommand[2])),
              double.parse(graphicCommand[3]), paint);
          break;
        case 'LINE':
          canvas.drawLine(Offset(double.parse(graphicCommand[1]), double.parse(graphicCommand[2])),
              Offset(double.parse(graphicCommand[3]), double.parse(graphicCommand[4])), paint);
          break;
        case 'POINT':
          canvas.drawCircle(Offset(double.parse(graphicCommand[1]), double.parse(graphicCommand[2])), 2.0, paint);
          //canvas.drawLine(Offset(double.parse(graphicCommand[1]), double.parse(graphicCommand[2])), Offset(double.parse(graphicCommand[1]), double.parse(graphicCommand[2])), paint);
          break;
        case 'COLOR':
          paint.color = Color.fromARGB(
            255,
            int.parse(graphicCommand[1]),
            int.parse(graphicCommand[2]),
            int.parse(graphicCommand[3]),
          );
          break;
        case 'ARC':
          canvas.drawArc(
              Rect.fromLTRB(
                  double.parse(graphicCommand[1]) - double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[2]) - double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[1]) + double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[2]) + double.parse(graphicCommand[3])),
              double.parse(graphicCommand[4]),
              double.parse(graphicCommand[5]),
              false,
              paint);
          break;
        case 'PIE':
          canvas.drawArc(
              Rect.fromLTRB(
                  double.parse(graphicCommand[1]) - double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[2]) - double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[1]) + double.parse(graphicCommand[3]),
                  double.parse(graphicCommand[2]) + double.parse(graphicCommand[3])),
              double.parse(graphicCommand[4]),
              double.parse(graphicCommand[5]),
              true,
              paint);
          break;
        case 'FILL':
          if (graphicCommand[1] == '0') {
            paint.style = PaintingStyle.stroke;
          } else {
            paint.style = PaintingStyle.fill;
          }
          break;
        case 'STROKE':
          paint.strokeWidth = double.parse(graphicCommand[1]);
          break;
      }
    }

    final img = await canvasRecorder.endRecording().toImage(imageWidth.floor(), imageHeight.floor());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) {
      throw Exception('Image data not created.');
    }
    return trimNullBytes(data.buffer.asUint8List());
  }

  Map<String, TextStyle> _buildHiglightMap() {
    var highlightMap = <String, TextStyle>{};

    GCWizardScriptFunctions().forEach((entry) {
      highlightMap.addAll({entry.toLowerCase(): const TextStyle(color: Colors.purple)});
      highlightMap.addAll({entry.toUpperCase(): const TextStyle(color: Colors.purple)});
    });
    GCWizardScriptConsts().forEach((entry) {
      highlightMap.addAll({entry.toLowerCase(): const TextStyle(color: Colors.purpleAccent)});
      highlightMap.addAll({entry.toUpperCase(): const TextStyle(color: Colors.purpleAccent)});
    });
    GCWizardScriptCommands().forEach((entry) {
      highlightMap.addAll({entry.toLowerCase(): const TextStyle(color: Colors.blue)});
      highlightMap.addAll({entry.toUpperCase(): const TextStyle(color: Colors.blue)});
    });
    GCWizardScriptControls().forEach((entry) {
      highlightMap.addAll({entry.toLowerCase(): const TextStyle(color: Colors.red)});
      highlightMap.addAll({entry.toUpperCase(): const TextStyle(color: Colors.red)});
    });
    for (var entry in GCWizardScriptParantheses) {
      highlightMap.addAll({entry: const TextStyle(color: Colors.orange)});
    }
    return highlightMap;
  }
}
