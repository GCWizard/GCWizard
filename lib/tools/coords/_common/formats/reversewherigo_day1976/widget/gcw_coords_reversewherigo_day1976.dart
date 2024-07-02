part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoReverseWherigoDay1976 extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.REVERSE_WIG_DAY1976;
  @override
  String get i18nKey => reverseWhereigoDay1976Key;
  @override
  String get name => 'Reverse Wherigo (Day1976)';
  @override
  String get example => '3f8f1, z4ee4';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsReverseWherigoDay1976(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsReverseWherigoDay1976 extends _GCWCoordWidget {
  _GCWCoordsReverseWherigoDay1976(
      {super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is ReverseWherigoDay1976Coordinate
                ? coordinates
                : ReverseWherigoDay1976FormatDefinition.defaultCoordinate);

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
    if (widget.initialize) {
      var day1976 = widget.coordinates as ReverseWherigoDay1976Coordinate;
      _currentA = day1976.s;
      _currentB = day1976.t;

      _ControllerA.text = _currentA.toString();
      _ControllerB.text = _currentB.toString();
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
    widget.onChanged(ReverseWherigoDay1976Coordinate.parse(_currentA.toString() + '\n' + _currentB.toString()));
  }
}
