part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsReverseWherigoDay1976 extends StatefulWidget {
  final void Function(ReverseWherigoDay1976?) onChanged;
  final ReverseWherigoDay1976 coordinates;
  final bool isDefault;

  const _GCWCoordsReverseWherigoDay1976({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsReverseWherigoDay1976State createState() => _GCWCoordsReverseWherigoDay1976State();
}

class _GCWCoordsReverseWherigoDay1976State extends State<_GCWCoordsReverseWherigoDay1976> {
  late TextEditingController _ControllerA;
  late TextEditingController _ControllerB;

  final FocusNode _FocusNodeA = FocusNode();
  final FocusNode _FocusNodeB = FocusNode();

  var _currentA = '';
  var _currentB = '';

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ControllerA = TextEditingController(text: _currentA);
    _ControllerB = TextEditingController(text: _currentB);
  }

  @override
  void dispose() {
    _ControllerA.dispose();
    _ControllerB.dispose();

    _FocusNodeA.dispose();
    _FocusNodeB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDefault && !_initialized) {
      var day1976 = widget.coordinates;
      _currentA = day1976.s;
      _currentB = day1976.t;

      _ControllerA.text = _currentA.toString();
      _ControllerB.text = _currentB.toString();

      _initialized = true;
    }

    return Column(children: <Widget>[
      GCWTextField(
        controller: _ControllerA,
        focusNode: _FocusNodeA,
        onChanged: (value) {
          _currentA = value;

          if (_ControllerA.text.length == 5) FocusScope.of(context).requestFocus(_FocusNodeB);
          _setCurrentValueAndEmitOnChange();
        },
      ),
      GCWTextField(
        controller: _ControllerB,
        focusNode: _FocusNodeB,
        onChanged: (value) {
          _currentB = value;

          if (_ControllerB.text.toString().length == 5) FocusScope.of(context).requestFocus(_FocusNodeA);
          _setCurrentValueAndEmitOnChange();
        },
      ),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(ReverseWherigoDay1976.parse(_currentA.toString() + '\n' + _currentB.toString()));
  }
}
