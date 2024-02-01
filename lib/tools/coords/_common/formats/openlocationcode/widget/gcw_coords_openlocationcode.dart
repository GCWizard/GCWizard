part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoOpenLocationCode extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.OPEN_LOCATION_CODE;
  @override
  String get i18nKey => openLocationCodeKey;
  @override
  String get name => 'OpenLocationCode (OLC, PlusCode)';
  @override
  String get example => '84QV7HRP+CM3';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsOpenLocationCode(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsOpenLocationCode extends _GCWCoordWidget {

  _GCWCoordsOpenLocationCode({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is OpenLocationCodeCoordinate ? coordinates : OpenLocationCodeFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsOpenLocationCodeState createState() => _GCWCoordsOpenLocationCodeState();
}

class _GCWCoordsOpenLocationCodeState extends State<_GCWCoordsOpenLocationCode> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = GCWMaskTextInputFormatter(
      mask: '**#################',
      filter: {"*": RegExp(r'[23456789CFGHJMPQRVcfghjmpqrv]'), "#": RegExp(r'[23456789CFGHJMPQRVWXcfghjmpqrvwx+]')});

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
      var openLocationCode = widget.coordinates as OpenLocationCodeCoordinate;
      _currentCoord = openLocationCode.text;

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
      widget.onChanged(OpenLocationCodeCoordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
