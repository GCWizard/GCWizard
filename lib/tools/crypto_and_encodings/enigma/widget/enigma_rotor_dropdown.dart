part of 'package:gc_wizard/tools/crypto_and_encodings/enigma/widget/enigma.dart';

class EnigmaRotorDropDown extends StatefulWidget {
  final Function onChanged;
  final EnigmaRotorType type;
  final position;

  const EnigmaRotorDropDown(
      {Key key,
      this.position,
      this.type: EnigmaRotorType.STANDARD,
      this.onChanged})
      : super(key: key);

  @override
  EnigmaRotorDropDownState createState() => EnigmaRotorDropDownState();
}

class EnigmaRotorDropDownState extends State<EnigmaRotorDropDown> {
  var _currentRotor;
  var _currentOffset = 1;
  var _currentSetting = 1;

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case EnigmaRotorType.STANDARD:
        _currentRotor = defaultRotorStandard;
        break;
      case EnigmaRotorType.ENTRY_ROTOR:
        _currentRotor = defaultRotorEntryRotor;
        break;
      case EnigmaRotorType.REFLECTOR:
        _currentRotor = defaultRotorReflector;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
                child: GCWDropDown(
                  value: _currentRotor,
                  items: allEnigmaRotors
                      .where((rotor) => rotor.type == widget.type)
                      .map((rotor) {
                    return GCWDropDownMenuItem(
                      value: rotor.name,
                      child: '${rotor.name}',
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currentRotor = value;
                      _setCurrentValueAndEmitOnChange();
                    });
                  },
                ),
                padding: EdgeInsets.only(right: DEFAULT_MARGIN)),
            flex: 2),
        widget.type == EnigmaRotorType.STANDARD
            ? Expanded(
                child: Container(
                  child: GCWABCDropDown(
                    value: _currentOffset,
                    onChanged: (value) {
                      setState(() {
                        _currentOffset = value;
                        _setCurrentValueAndEmitOnChange();
                      });
                    },
                  ),
                  padding: EdgeInsets.symmetric(horizontal: DEFAULT_MARGIN),
                ),
                flex: 1)
            : Container(),
        widget.type == EnigmaRotorType.STANDARD
            ? Expanded(
                child: Container(
                  child: GCWABCDropDown(
                    value: _currentSetting,
                    onChanged: (value) {
                      setState(() {
                        _currentSetting = value;
                        _setCurrentValueAndEmitOnChange();
                      });
                    },
                  ),
                  padding: EdgeInsets.only(left: DEFAULT_MARGIN),
                ),
                flex: 1)
            : Container(),
      ],
    );
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged({
      'position': widget.position,
      'rotorConfiguration': EnigmaRotorConfiguration(
          getEnigmaRotorByName(_currentRotor),
          offset: _currentOffset,
          setting: _currentSetting)
    });
  }
}
