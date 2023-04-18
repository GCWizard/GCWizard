part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsReverseWherigoWaldmeister extends StatefulWidget {
  final void Function(ReverseWherigoWaldmeister?) onChanged;
  final ReverseWherigoWaldmeister coordinates;
  final bool isDefault;

  const _GCWCoordsReverseWherigoWaldmeister({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsReverseWherigoWaldmeisterState createState() => _GCWCoordsReverseWherigoWaldmeisterState();
}

class _GCWCoordsReverseWherigoWaldmeisterState extends State<_GCWCoordsReverseWherigoWaldmeister> {
  late TextEditingController _ControllerA;
  late TextEditingController _ControllerB;
  late TextEditingController _ControllerC;

  final _FocusNodeA = FocusNode();
  final _FocusNodeB = FocusNode();
  final _FocusNodeC = FocusNode();

  var _currentA = 0;
  var _currentB = 0;
  var _currentC = 0;

  final _integerInputFormatter = GCWIntegerTextInputFormatter(min: 0, max: 999999);

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ControllerA = TextEditingController(text: _currentA.toString());
    _ControllerB = TextEditingController(text: _currentB.toString());
    _ControllerC = TextEditingController(text: _currentC.toString());
  }

  @override
  void dispose() {
    _ControllerA.dispose();
    _ControllerB.dispose();
    _ControllerC.dispose();

    _FocusNodeA.dispose();
    _FocusNodeB.dispose();
    _FocusNodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDefault && !_initialized) {
      var waldmeister = widget.coordinates;
      _currentA = waldmeister.a;
      _currentB = waldmeister.b;
      _currentC = waldmeister.c;

      _ControllerA.text = waldmeister.a.toString().padLeft(6, '0');
      _ControllerB.text = waldmeister.b.toString().padLeft(6, '0');
      _ControllerC.text = waldmeister.c.toString().padLeft(6, '0');

      _initialized = true;
    }

    return Column(children: <Widget>[
      GCWTextField(
        controller: _ControllerA,
        focusNode: _FocusNodeA,
        inputFormatters: [_integerInputFormatter],
        onChanged: (String value) {
          _currentA = extractIntegerFromText(value);

          if (_ControllerA.text.length == 6) FocusScope.of(context).requestFocus(_FocusNodeB);
          _setCurrentValueAndEmitOnChange();
        },
      ),
      GCWTextField(
        controller: _ControllerB,
        focusNode: _FocusNodeB,
        inputFormatters: [_integerInputFormatter],
        onChanged: (String value) {
          _currentB = extractIntegerFromText(value);

          if (_ControllerB.text.toString().length == 6) FocusScope.of(context).requestFocus(_FocusNodeC);
          _setCurrentValueAndEmitOnChange();
        },
      ),
      GCWTextField(
        controller: _ControllerC,
        focusNode: _FocusNodeC,
        inputFormatters: [_integerInputFormatter],
        onChanged: (String value) {
          _currentC = extractIntegerFromText(value);
          _setCurrentValueAndEmitOnChange();
        },
      )
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(ReverseWherigoWaldmeister.parse(
        _currentA.toString() + '\n' + _currentB.toString() + '\n' + _currentC.toString()));
  }
}
