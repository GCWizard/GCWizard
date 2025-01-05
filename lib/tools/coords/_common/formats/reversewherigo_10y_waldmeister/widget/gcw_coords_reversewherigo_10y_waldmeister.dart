part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoReverseWherigo10YWaldmeister extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER;
  @override
  String get i18nKey => reverseWherigo10YWaldmeisterKey;
  @override
  String get name => 'Reverse Wherigo (10Y Waldmeister)';
  @override
  String get example => '237787, 953944, 469026';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsReverseWherigo10YWaldmeister(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsReverseWherigo10YWaldmeister extends _GCWCoordWidget {
  _GCWCoordsReverseWherigo10YWaldmeister(
      {super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is ReverseWherigo10YWaldmeisterCoordinate
                ? coordinates
                : ReverseWherigo10YWaldmeisterFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsReverseWherigo10YWaldmeisterState createState() => _GCWCoordsReverseWherigo10YWaldmeisterState();
}

class _GCWCoordsReverseWherigo10YWaldmeisterState extends State<_GCWCoordsReverseWherigo10YWaldmeister> {
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
      var waldmeister = widget.coordinates as ReverseWherigo10YWaldmeisterCoordinate;
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
    widget.onChanged(ReverseWherigo10YWaldmeisterCoordinate(_currentA, _currentB, _currentC));
  }
}
