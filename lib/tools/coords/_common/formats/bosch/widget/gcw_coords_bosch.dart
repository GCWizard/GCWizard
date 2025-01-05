part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoBosch extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.BOSCH;
  @override
  String get i18nKey => boschKey;
  @override
  String get name => 'Bosch';
  @override
  String get example => '2CDKRQQD';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsBosch(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsBosch extends _GCWCoordWidget {
  _GCWCoordsBosch({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is BoschCoordinate ? coordinates : BoschFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsBoschState createState() => _GCWCoordsBoschState();
}

class _GCWCoordsBoschState extends State<_GCWCoordsBosch> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '#' * 100, filter: {"#": RegExp(r'[A-Za-z0-9]')});

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentCoord);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialize) {
      var bosch = widget.coordinates as BoschCoordinate;
      _currentCoord = bosch.toString();

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          controller: _controller,
          inputFormatters: [_maskInputFormatter],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(BoschCoordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
