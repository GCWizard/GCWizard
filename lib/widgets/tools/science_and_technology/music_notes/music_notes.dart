import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/music_notes.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_segmentdisplay_output.dart';
import 'package:gc_wizard/widgets/common/gcw_toolbar.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/registry.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/music_notes/music_notes_segment_display.dart';

class MusicNotes extends StatefulWidget {
  @override
  MusicNotesState createState() => MusicNotesState();
}

class MusicNotesState extends State<MusicNotes> {
  String _currentEncodeInput = '';
  TextEditingController _encodeController;
  var _gcwTextStyle = gcwTextStyle();
  var _currentCode = NotesCodebook.TREBLE;

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWDropDownButton(
        value: _currentCode,
        onChanged: (value) {
          setState(() {
            _currentCode = value;
          });
        },
        items: NotesCodebook.values.map((codeBook) {
          switch (codeBook) {
            case NotesCodebook.ALT:
              var tool = registeredTools.firstWhere((tool) => tool.i18nPrefix.contains('altoclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.ALT, child: _buildDropDownMenuItem(tool.icon, tool.toolName, null));
            case NotesCodebook.TREBLE:
              var tool = registeredTools.firstWhere((tool) => tool.i18nPrefix.contains('trebleclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.TREBLE, child: _buildDropDownMenuItem(tool.icon, tool.toolName, null));
            case NotesCodebook.BASS:
              var tool = registeredTools.firstWhere((tool) => tool.i18nPrefix.contains('bassclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.BASS, child: _buildDropDownMenuItem(tool.icon, tool.toolName, null));
            default:
              return null;
          }
        }).toList(),
      ),
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      if (_currentMode == GCWSwitchPosition.left) // encrypt: input number => output segment
        GCWTextField(
          controller: _encodeController,
          onChanged: (text) {
            setState(() {
              _currentEncodeInput = text;
            });
          },
        )
      else
        Column(
          // decrpyt: input segment => output number
          children: <Widget>[_buildVisualDecryption()],
        ),
      _buildOutput()
    ]);
  }

  Widget _buildVisualDecryption() {
    Map<String, bool> currentDisplay;

    var displays = _currentDisplays;
    if (displays != null && displays.length > 0) {
      currentDisplay = Map<String, bool>.fromIterable(displays.last ?? [], key: (e) => e, value: (e) => true);
      currentDisplay.remove(altClef);
      currentDisplay.remove(bassClef);
      currentDisplay.remove(trebleClef);
    } else
      currentDisplay = {};

    switch (_currentCode) {
      case NotesCodebook.ALT:
        currentDisplay.addAll({altClef: true});
        break;
      case NotesCodebook.BASS:
        currentDisplay.addAll({bassClef: true});
        break;
      case NotesCodebook.TREBLE:
        currentDisplay.addAll({trebleClef: true});
        break;
    }

    var onChanged = (Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        newSegments.sort();

        if (_currentDisplays.length == 0) _currentDisplays.add([]);

        _currentDisplays[_currentDisplays.length - 1] = newSegments;
      });
    };

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          height: 300,
          padding: EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: NotesSegmentDisplay(
                  segments: currentDisplay,
                  onChanged: onChanged,
                ),
              )
            ],
          ),
        ),
        GCWToolBar(children: [
          GCWIconButton(
            icon: Icons.space_bar,
            onPressed: () {
              setState(() {
                _currentDisplays.add([]);
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                if (_currentDisplays.length > 0) _currentDisplays.removeLast();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = [];
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    return GCWSegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          displayedSegments = filterVisibleHelpLines(displayedSegments);
          return NotesSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        horizontalSymbolPadding: 0,
        verticalSymbolPadding: 10,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      List<List<String>> segments = encodeNotes(_currentEncodeInput, _currentCode, _buildTranslationMap(_currentCode));
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.map((character) {
        if (character != null) return character.join();
      }).toList();
      var segments = decodeNotes(output, _currentCode);

      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments['displays']),
          GCWDefaultOutput(child: _normalize(segments['chars'], _currentCode)),
        ],
      );
    }
  }

  String _normalize(List<String> input, NotesCodebook codeBook) {
    return input.map((note) {
      switch (codeBook) {
        case NotesCodebook.ALT:
          return i18n(context, 'symboltables_notes_names_altoclef_' + note) ?? UNKNOWN_ELEMENT;
        case NotesCodebook.BASS:
          return i18n(context, 'symboltables_notes_names_bassclef_' + note) ?? UNKNOWN_ELEMENT;
        case NotesCodebook.TREBLE:
          return i18n(context, 'symboltables_notes_names_trebleclef_' + note) ?? UNKNOWN_ELEMENT;
      }
    }).join(' ');
  }

  Map<String, String> _buildTranslationMap(NotesCodebook codeBook) {
    var keys = possibleNoteKeys(codeBook);
    var translationMap = Map<String, String>();
    String translation;

    keys.forEach((note) {
      switch (codeBook) {
        case NotesCodebook.ALT:
          translation = i18n(context, 'symboltables_notes_names_altoclef_' + note);
          break;
        case NotesCodebook.BASS:
          translation = i18n(context, 'symboltables_notes_names_bassclef_' + note);
          break;
        case NotesCodebook.TREBLE:
          translation = i18n(context, 'symboltables_notes_names_trebleclef_' + note);
          break;
        default:
          translation = null;
      }
      if (translation != null && translation != '') translationMap.addAll({note: translation});
    });
    return translationMap;
  }

  Widget _buildDropDownMenuItem(dynamic icon, String toolName, String description) {
    return Row(children: [
      Container(
        child: (icon != null) ? icon : Container(width: 50),
        margin: EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 10),
      ),
      Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(toolName, style: _gcwTextStyle),
          ]))
    ]);
  }
}
