import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_engine/flutter_midi_engine.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/midi/_commin/logic/midi_data.dart';

class MIDI extends StatefulWidget {
  const MIDI({super.key});

  @override
  _MIDIState createState() => _MIDIState();
}

class _MIDIState extends State<MIDI> {
  var _currentSort = 0;
  var _currentIndex = 9; // Key number 1
  final List<String> _currentSortList = [
    'piano_number',
    'piano_color',
    'piano_frequency',
    'piano_helmholtz',
    'piano_scientific',
    'piano_german',
    'piano_midi',
    'piano_latin',
    'piano_keyboard',
  ];

  var _currentColor = GCWSwitchPosition.left;
  var _isColorSort = false;

  final FlutterMidiEngine _midiEngine = FlutterMidiEngine();
  bool _isInitialized = false;
  int _currentProgram = 0;
  int _currentVolume = 100;
  int _currentMIDINote = 0;
  final String _ASSET_PATH = 'lib/tools/science_and_technology/midi/assets/VelocityGrandPiano.sf2';

  static const Map<String, int> _instruments = {
    // https://en.wikipedia.org/wiki/General_MIDI#Program_change_events
    'Acoustic Grand Piano': 0,
    'Electric Piano': 4,
    'Church Organ': 19,
    'Acoustic Guitar': 24,
    'Electric Guitar': 27,
    'Violin': 40,
    'Trumpet': 56,
    'Flute': 73,
    'Synth Lead': 80,
  };

  Future<void> _initializeMidi() async {
    try {
      await _midiEngine.unmute();
      // https://rkhive.com/rk-download/piano/velocity_grand_piano.zip
      // Creative Commons 1.0

      try {
        final byteData = await DefaultAssetBundle.of(context).load(_ASSET_PATH);
        print(byteData);
        //final file = await _writeBytesToFile(
        //  byteData,
        //  fileName ?? assetPath.split('/').last,
        //);
        //if (file == null) return false;
        //return await loadSoundfont(file.path);
      } catch (e) {
        debugPrint('Error loading soundfont from asset: $e');
        //return false;
      }

      final success = await _midiEngine.loadSoundfontFromAsset(_ASSET_PATH);

      if (success) {
        await _midiEngine.setVolume(volume: _currentVolume);

        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to initialize MIDI: $e');
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
      velocity: 100,
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
    var field = _currentSort == 0 ? PianoFields.values.first : PianoFields.values.elementAt(_currentSort - 1);

    return Column(
      children: <Widget>[
        GCWDropDown<int>(
          title: i18n(context, 'piano_sort'),
          value: _currentSort,
          onChanged: (value) {
            setState(() {
              _currentSort = value;
              _isColorSort = _currentSort == 1;
            });
            field = _currentSort == 0 ? PianoFields.values.first : PianoFields.values.elementAt(_currentSort - 1);
          },
          items: _currentSortList
              .asMap()
              .map((index, field) {
            return MapEntry(index, GCWDropDownMenuItem(value: index, child: i18n(context, field)));
          })
              .values
              .toList(),
        ),
        _isColorSort
            ? GCWTwoOptionsSwitch(
          title: i18n(context, 'piano_color'),
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
          items: PIANO_KEYS.values.where((e) => e.getField(field).isNotEmpty).map((e) {
            return ((_currentSort == 0) ? e.number : e.getField(field)).toString();
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  Widget _buildOutput() {
    Widget dataSet = Container();

    if (_isColorSort) {
      var chosenColor = _currentColor == GCWSwitchPosition.left ? 'white' : 'black';
      var dataIdx = <void Function()>[() => {}];
      var data = PIANO_KEYS.entries.toList().asMap().entries.where((element) => element.value.value.color.endsWith(chosenColor)).map((element) {
        dataIdx.add( () {
          setState(() {
            _currentSort = 0;
            _currentIndex = element.key;
            _isColorSort = false;
          });
        });
        return [element.value.value.number, element.value.value.frequency];
      }).toList();

      data.insert(0, [i18n(context, 'piano_number'), i18n(context, 'piano_frequency')]);

      return GCWColumnedMultilineOutput(data: data, hasHeader: true, flexValues: const [1, 2],
          tappables: dataIdx
      );
    } else {
      var keyNumber = PIANO_KEYS.keys.toList()[_currentIndex];
      _currentMIDINote = int.parse(PIANO_KEYS[keyNumber]!.midi);
      dataSet = GCWColumnedMultilineOutput(data: [
        [i18n(context, 'piano_number'), PIANO_KEYS[keyNumber]!.number],
        [i18n(context, 'piano_color'), i18n(context, PIANO_KEYS[keyNumber]!.color)],
        [i18n(context, 'piano_frequency'), PIANO_KEYS[keyNumber]!.frequency],
        [i18n(context, 'piano_helmholtz'), PIANO_KEYS[keyNumber]!.helmholtz],
        [i18n(context, 'piano_scientific'), PIANO_KEYS[keyNumber]!.scientific],
        [i18n(context, 'piano_german'), PIANO_KEYS[keyNumber]!.german],
        [i18n(context, 'piano_midi'), PIANO_KEYS[keyNumber]!.midi],
        [i18n(context, 'piano_latin'), PIANO_KEYS[keyNumber]!.latin],
        [i18n(context, 'piano_keyboard'), PIANO_KEYS[keyNumber]!.keyboard],
      ], flexValues: const [
        1,
        2
      ]);
    }
    return Column(
        children: [
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
        ]
    );
  }
}
