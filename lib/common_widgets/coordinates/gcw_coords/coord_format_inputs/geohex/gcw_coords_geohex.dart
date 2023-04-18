part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsGeoHex extends StatefulWidget {
  final void Function(GeoHex?) onChanged;
  final GeoHex coordinates;
  final bool isDefault;

  const _GCWCoordsGeoHex({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsGeoHexState createState() => _GCWCoordsGeoHexState();
}

class _GCWCoordsGeoHexState extends State<_GCWCoordsGeoHex> {
  late TextEditingController _controller;
  var _currentCoord = '';

  bool _initialized = false;

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
    if (!widget.isDefault && !_initialized) {
      var geohHex = widget.coordinates;
      _currentCoord = geohHex.text;

      _controller.text = _currentCoord;

      _initialized = true;
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
      widget.onChanged(GeoHex.parse(_currentCoord));
    } catch (e) {}
  }
}
