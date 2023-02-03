part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsGeo3x3 extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsGeo3x3({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsGeo3x3State createState() => _GCWCoordsGeo3x3State();
}

class _GCWCoordsGeo3x3State extends State<_GCWCoordsGeo3x3> {
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
      var geo3x3 = widget.coordinates is Geo3x3
          ? widget.coordinates as Geo3x3
          : Geo3x3.fromLatLon(widget.coordinates.toLatLng(), 20);
      _currentCoord = geo3x3.text;

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_geo3x3_locator'),
          controller: _controller,
          inputFormatters: [_Geo3x3TextInputFormatter()],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(Geo3x3.parse(_currentCoord));
    } catch (e) {}
  }
}
