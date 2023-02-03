part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsGeohash extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsGeohash({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsGeohashState createState() => _GCWCoordsGeohashState();
}

class _GCWCoordsGeohashState extends State<_GCWCoordsGeohash> {
  TextEditingController _controller;
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
    if (widget.coordinates != null) {
      var geohash = widget.coordinates is Geohash
          ? widget.coordinates as Geohash
          : Geohash.fromLatLon(widget.coordinates.toLatLng(), 14);
      _currentCoord = geohash.text;

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_geohash_locator'),
          controller: _controller,
          inputFormatters: [_GeohashTextInputFormatter()],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged(Geohash.parse(_currentCoord));
  }
}
