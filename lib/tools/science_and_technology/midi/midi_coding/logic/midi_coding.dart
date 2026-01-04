import 'package:gc_wizard/tools/science_and_technology/midi/_common/logic/midi_data.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const Map<int, String> MIDI_CODING = {
  0: 'midi_frequency',
  1: 'midi_helmholtz',
  2: 'midi_scientific',
  3: 'midi_german',
  4: 'midi_latin',
};

Map<int, String> mapIntMIDIKEYSToMapIntString(
    Map<int, MIDIKey> source,
    String Function(MIDIKey m) selector,
    ) {
  return source.map(
        (key, value) => MapEntry(key, selector(value)),
  );
}

Map<int, String> getCodeBook(int type) {
  Map<int, String> result = {};
  switch (type) {
    case 0:
      result = mapIntMIDIKEYSToMapIntString( MIDI_KEYS, (m) => m.frequency, );
    case 1:
      result = mapIntMIDIKEYSToMapIntString( MIDI_KEYS, (m) => m.helmholtz, );
    case 2:
      result = mapIntMIDIKEYSToMapIntString( MIDI_KEYS, (m) => m.scientific, );
    case 3:
      result = mapIntMIDIKEYSToMapIntString( MIDI_KEYS, (m) => m.german, );
    case 4:
      result = mapIntMIDIKEYSToMapIntString( MIDI_KEYS, (m) => m.latin, );
  }
  return result;
}

String encodeMIDI(String _currentEncodeInput, int _currentType) {
  Map<int, String> CODEBOOK = getCodeBook(_currentType);

  return _currentEncodeInput.split('').map((character) {
    var code = CODEBOOK[character.codeUnitAt(0)];
    return code ?? '';
  }).join(' ');
}

String decodeMIDI(String _currentEncodeInput, int _currentType){

  if ( _currentEncodeInput.isEmpty) return '';

  Map<String, int> CODEBOOK = switchMapKeyValue(getCodeBook(_currentType));

  return _currentEncodeInput.split(' ').map((code) {
    var ascii = CODEBOOK[code];
    return ascii != null ? String.fromCharCode(ascii) : '';
  }).join('');
}