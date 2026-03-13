import 'package:flutter/material.dart';
import 'package:flutter_midi_engine/flutter_midi_engine.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_threeoptionsswitch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/_common/logic/midi_data.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/midi_overview/logic/midi_overview.dart';

class MIDI extends StatefulWidget {
  const MIDI({super.key});

  @override
  _MIDIState createState() => _MIDIState();
}

class _MIDIState extends State<MIDI> {
  int _currentMIDIData = 0;
  var _currentSort = 0;
  var _currentIndex = 0; // Key number 1
  final List<String> _currentSortList = [
    'midi_midi',
    'midi_color',
    'midi_frequency',
    'midi_helmholtz',
    'midi_scientific',
    'midi_german',
    'midi_piano',
    'midi_latin',
    'midi_keyboard',
  ];
  List<String> _currentDropDownSpinnerList = [];
  var _currentField = MIDIFields.values.first;

  var _currentColor = GCWSwitchPosition.left;
  var _isColorSort = false;

  final FlutterMidiEngine _midiEngine = FlutterMidiEngine();
  bool _isInitialized = false;
  int _currentProgram = 0;
  int _currentVolume = 100;
  int _currentMIDINote = 0;
  final String _ASSET_PATH =
      'lib/tools/science_and_technology/midi/assets/VelocityGrandPiano.sf2';

  Future<void> _initializeMidi() async {
    try {
      await _midiEngine.unmute();
      final success = await _midiEngine.loadSoundfontFromAsset(_ASSET_PATH);

      if (success) {
        await _midiEngine.setVolume(volume: _currentVolume);
        await _midiEngine.changeProgram(program: _currentProgram);

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      showSnackBar(i18n(context, 'midi_load_error') + ': $e', context);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeMidi();
  }

  @override
  void dispose() {
    _midiEngine.stopAllNotes();
    _midiEngine.unloadSoundfont();
    super.dispose();
  }

  Future<void> _playNote(int note) async {
    if (!_isInitialized) return;

    await _midiEngine.playNote(
      note: note,
      velocity: _currentVolume,
    );
  }

  Future<void> _stopNote(int note) async {
    if (!_isInitialized) return;

    await _midiEngine.stopNote(note: note);
  }

  Future<void> _changeInstrument(int program) async {
    if (!_isInitialized) return;

    await _midiEngine.changeProgram(program: program);

    setState(() {
      _currentProgram = program;
    });
  }

  Future<void> _changeVolume(double volume) async {
    if (!_isInitialized) return;

    final volumeInt = volume.toInt();
    await _midiEngine.setVolume(volume: volumeInt);

    setState(() {
      _currentVolume = volumeInt;
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentField = _currentSort == 0
        ? MIDIFields.values.first
        : MIDIFields.values.elementAt(_currentSort - 1);

    _currentDropDownSpinnerList = MIDI_KEYS.values
        .where((e) => e.getField(_currentField).isNotEmpty)
        .map((e) {
      return ((_currentSort == 0) ? e.midi : e.getField(_currentField))
          .toString();
    }).toList();

    return Column(
      children: <Widget>[
        GCWThreeOptionsSwitch(
          labels: [i18n(context, 'midi_notes'), i18n(context, 'midi_instruments'), i18n(context, 'midi_percussions')],
          position: _currentMIDIData,
            onChanged: (position) {
              setState(() {
                _currentMIDIData = position;
              });
            }),
        if (_currentMIDIData == 0) _buildInputMIDINotes(),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  Widget _buildInputMIDINotes(){
    return Column(
      children: <Widget>[
        GCWDropDown<int>(
          title: i18n(context, 'midi_sort'),
          value: _currentSort,
          onChanged: (value) {
            setState(() {
              _currentSort = value;
              _isColorSort = _currentSort == 1;
            });
            _currentField = _currentSort == 0
                ? MIDIFields.values.first
                : MIDIFields.values.elementAt(_currentSort - 1);
          },
          items: _currentSortList
              .asMap()
              .map((index, field) {
            return MapEntry(
                index,
                GCWDropDownMenuItem(
                    value: index, child: i18n(context, field)));
          })
              .values
              .toList(),
        ),
        _isColorSort
            ? GCWTwoOptionsSwitch(
          title: i18n(context, 'midi_color'),
          leftValue: i18n(context, 'common_color_white'),
          rightValue: i18n(context, 'common_color_black'),
          value: _currentColor,
          onChanged: (value) {
            setState(() {
              _currentColor = value;
            });
          },
        )
            : GCWDropDownSpinner(
          index: _currentIndex,
          items: _currentDropDownSpinnerList,
          onChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'common_options'),
          expanded: false,
          child: Column(
            children: [
              GCWIntegerSpinner(
                title: i18n(context, 'midi_volume'),
                min: 0,
                max: 127,
                value: _currentVolume,
                onChanged: (int value) {
                  setState(() {
                    _currentVolume = value;
                    _changeVolume(_currentVolume.toDouble());
                  });
                },
              ),
              GCWDropDownSpinner(
                title: i18n(context, 'midi_program'),
                index: _currentProgram,
                items: MIDI_INSTRUMENTS
                    .map((key, value) {
                  return MapEntry(key, value);
                })
                    .values
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _currentProgram = value;
                    _changeInstrument(_currentProgram);
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutputMIDINotes(){
    Widget dataSet = Container();

    if (_isColorSort) {
      var chosenColor =
      _currentColor == GCWSwitchPosition.left ? 'white' : 'black';
      var dataIdx = <void Function()>[() => {}];
      var data = MIDI_KEYS.entries
          .toList()
          .asMap()
          .entries
          .where((element) => element.value.value.color.endsWith(chosenColor))
          .map((element) {
        dataIdx.add(() {
          setState(() {
            _currentSort = 0;
            _currentIndex = element.key;
            _isColorSort = false;
          });
        });
        return [element.value.value.midi, element.value.value.frequency];
      }).toList();

      data.insert(
          0, [i18n(context, 'midi_number'), i18n(context, 'midi_frequency')]);

      return GCWColumnedMultilineOutput(
          data: data,
          hasHeader: true,
          flexValues: const [1, 2],
          tappables: dataIdx);
    } else {
      int? key = 0;
      if (_currentSort == 0) {
        key = _currentIndex;
      } else {
        switch (_currentField) {
          case MIDIFields.KEYBOARD:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.keyboard,
              _currentDropDownSpinnerList[_currentIndex],
            );
            break;
          case MIDIFields.PIANO:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.piano,
              _currentDropDownSpinnerList[_currentIndex],
            );
            break;
          case MIDIFields.COLOR:
            break;
          case MIDIFields.FREQUENCY:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.frequency,
              _currentDropDownSpinnerList[_currentIndex],
            );
          case MIDIFields.HELMHOLTZ:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.helmholtz,
              _currentDropDownSpinnerList[_currentIndex],
            );
          case MIDIFields.SCIENTIFIC:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.scientific,
              _currentDropDownSpinnerList[_currentIndex],
            );
          case MIDIFields.GERMAN:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.german,
              _currentDropDownSpinnerList[_currentIndex],
            );
          case MIDIFields.LATIN:
            key = findKeyByField<MIDIKey, String>(
              MIDI_KEYS,
                  (p) => p.latin,
              _currentDropDownSpinnerList[_currentIndex],
            );
        }
      }
      key ??= 0;

      var keyNumber = MIDI_KEYS.keys.toList()[key]; //_currentIndex];
      _currentMIDINote = int.parse(MIDI_KEYS[keyNumber]!.midi);
      dataSet = GCWColumnedMultilineOutput(data: [
        [i18n(context, 'midi_midi'), MIDI_KEYS[keyNumber]!.midi],
        [
          i18n(context, 'midi_color'),
          i18n(context, MIDI_KEYS[keyNumber]!.color)
        ],
        [i18n(context, 'midi_frequency'), MIDI_KEYS[keyNumber]!.frequency],
        [i18n(context, 'midi_helmholtz'), MIDI_KEYS[keyNumber]!.helmholtz],
        [i18n(context, 'midi_scientific'), MIDI_KEYS[keyNumber]!.scientific],
        [i18n(context, 'midi_german'), MIDI_KEYS[keyNumber]!.german],
        [i18n(context, 'midi_piano'), MIDI_KEYS[keyNumber]!.piano],
        [i18n(context, 'midi_latin'), MIDI_KEYS[keyNumber]!.latin],
        [i18n(context, 'midi_keyboard'), MIDI_KEYS[keyNumber]!.keyboard],
      ], flexValues: const [
        1,
        2
      ]);
    }
    return Column(children: [
      dataSet,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GCWIconButton(
            icon: Icons.play_arrow,
            onPressed: () {
              setState(() {
                _playNote(_currentMIDINote);
              });
            },
          ),
          GCWIconButton(
            icon: Icons.stop,
            onPressed: () {
              setState(() {
                _stopNote(_currentMIDINote);
              });
            },
          ),
        ],
      ),
    ]);

  }

  Widget _buildOutputMIDIInstruments(){
    List<List<String>> data = MIDI_INSTRUMENTS.entries.map((e) => [e.key.toString(), e.value]) .toList();
    return GCWColumnedMultilineOutput(data: data, flexValues: const [1, 6]);
  }

  Widget _buildOutputMIDIPercussions(){
    List<List<String>> data = MIDI_PERCUSSIONS.entries.map((e) => [e.key.toString(), e.value]) .toList();
    return GCWColumnedMultilineOutput(data: data, flexValues: const [1, 6]);
  }

  Widget _buildOutput() {
    Widget result = Container();
    switch (_currentMIDIData) {
      case 0: result = _buildOutputMIDINotes();
      case 1: result =  _buildOutputMIDIInstruments();
      case 2: result =  _buildOutputMIDIPercussions();
    }
    return result;
  }
}
