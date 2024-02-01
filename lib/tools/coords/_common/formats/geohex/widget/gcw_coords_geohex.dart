part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoGeoHex extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.GEOHEX;
  @override
  String get i18nKey => geoHexKey;
  @override
  String get name => 'GeoHex';
  @override
  String get example => 'RU568425483853568';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsGeoHex(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsGeoHex extends _GCWCoordWidget {

  _GCWCoordsGeoHex({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is GeoHexCoordinate ? coordinates : GeoHexFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsGeoHexState createState() => _GCWCoordsGeoHexState();
}

class _GCWCoordsGeoHexState extends State<_GCWCoordsGeoHex> {
  late TextEditingController _controller;
  var _currentCoord = '';

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
      var geohHex = widget.coordinates as GeoHexCoordinate;
      _currentCoord = geohHex.text;

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_geohex_locator'),
          controller: _controller,
          inputFormatters: [_GeoHexTextInputFormatter()],
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
      widget.onChanged(GeoHexCoordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
