part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoReverseWherigoHebi63 extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.REVERSE_WIG_HEBI63;
  @override
  String get i18nKey => reverseWherigoHebi63Key;
  @override
  String get name => 'Reverse Wherigo (Hebi63)';
  @override
  String get example => '114331, 124458, 274932';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
        required void Function(BaseCoordinate?) onChanged,
        required BaseCoordinate? coordinates,
        bool? initialize}) {
    return _GCWCoordsReverseWherigoHebi63(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsReverseWherigoHebi63 extends _GCWCoordWidget {
  _GCWCoordsReverseWherigoHebi63(
      {super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
      coordinates: coordinates is ReverseWherigoHebi63Coordinate
          ? coordinates
          : ReverseWherigoHebi63FormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsReverseWherigoHebi63State createState() => _GCWCoordsReverseWherigoHebi63State();
}

class _GCWCoordsReverseWherigoHebi63State extends State<_GCWCoordsReverseWherigoHebi63> {
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
    if (widget.initialize) {
      var waldmeister = widget.coordinates as ReverseWherigoHebi63Coordinate;
      _currentA = waldmeister.a;
      _currentB = waldmeister.b;
      _currentC = waldmeister.c;

      _ControllerA.text = waldmeister.a.toString().padLeft(6, '0');
      _ControllerB.text = waldmeister.b.toString().padLeft(6, '0');
      _ControllerC.text = waldmeister.c.toString().padLeft(6, '0');
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
    widget.onChanged(ReverseWherigoHebi63Coordinate(_currentA, _currentB, _currentC));
  }
}
