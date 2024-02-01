import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/gcw_touchcanvas.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/music_notes/logic/music_notes.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_painter.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/utils/constants.dart';

part 'package:gc_wizard/tools/science_and_technology/music_notes/music_notes/widget/music_notes_segment_display.dart';

class MusicNotes extends StatefulWidget {
  const MusicNotes({Key? key}) : super(key: key);

  @override
  _MusicNotesState createState() => _MusicNotesState();
}

class _MusicNotesState extends State<MusicNotes> {
  String _currentEncodeInput = '';
  late TextEditingController _encodeController;
  final _gcwTextStyle = gcwTextStyle();
  var _currentCode = NotesCodebook.TREBLE;

  var _currentDisplays = Segments.Empty();
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
      GCWDropDown<NotesCodebook>(
        value: _currentCode,
        onChanged: (value) {
          setState(() {
            _currentCode = value;
          });
        },
        items: NotesCodebook.values.map((codeBook) {
          switch (codeBook) {
            case NotesCodebook.ALT:
              var tool = registeredTools.firstWhere((tool) => tool.id.contains('altoclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.ALT, child: _buildDropDownMenuItem(tool.icon, tool.toolName!, null));
            case NotesCodebook.TREBLE:
              var tool = registeredTools.firstWhere((tool) => tool.id.contains('trebleclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.TREBLE, child: _buildDropDownMenuItem(tool.icon, tool.toolName!, null));
            case NotesCodebook.BASS:
              var tool = registeredTools.firstWhere((tool) => tool.id.contains('bassclef'));
              return GCWDropDownMenuItem(
                  value: NotesCodebook.BASS, child: _buildDropDownMenuItem(tool.icon, tool.toolName!, null));
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
    var currentDisplay = buildSegmentMap(_currentDisplays);
    currentDisplay.remove(altClef);
    currentDisplay.remove(bassClef);
    currentDisplay.remove(trebleClef);

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

    onChanged(Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        _currentDisplays.replaceLastSegment(newSegments);
      });
    }

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          height: 300,
          padding: const EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _NotesSegmentDisplay(
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
                _currentDisplays.addEmptySegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                _currentDisplays.removeLastSegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = Segments.Empty();
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(Segments segments) {
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          displayedSegments = filterVisibleHelpLines(displayedSegments);
          return _NotesSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        horizontalSymbolPadding: 0,
        verticalSymbolPadding: 10,
        readOnly: true);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeNotes(_currentEncodeInput, _currentCode, _buildTranslationMap(_currentCode));
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.buildOutput();
      var segments = decodeNotes(output, _currentCode);

      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWDefaultOutput(child: _normalize(segments.chars, _currentCode)),
        ],
      );
    }
  }

  String _normalize(List<String> input, NotesCodebook codeBook) {
    return input.map((note) {
      switch (codeBook) {
        case NotesCodebook.ALT:
          return i18n(context, 'symboltables_notes_names_altoclef_' + note, ifTranslationNotExists: UNKNOWN_ELEMENT);
        case NotesCodebook.BASS:
          return i18n(context, 'symboltables_notes_names_bassclef_' + note, ifTranslationNotExists: UNKNOWN_ELEMENT);
        case NotesCodebook.TREBLE:
          return i18n(context, 'symboltables_notes_names_trebleclef_' + note, ifTranslationNotExists: UNKNOWN_ELEMENT);
      }
    }).join(' ');
  }

  Map<String, String> _buildTranslationMap(NotesCodebook codeBook) {
    var keys = possibleNoteKeys(codeBook);
    var translationMap = <String, String>{};
    String translation;

    for (var note in keys) {
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
          translation = '';
      }
      if (translation.isNotEmpty) translationMap.addAll({note: translation});
    }
    return translationMap;
  }

  Widget _buildDropDownMenuItem(GCWSymbolContainer? icon, String toolName, String? description) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 10),
        child: (icon != null) ? icon : Container(width: 50),
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
