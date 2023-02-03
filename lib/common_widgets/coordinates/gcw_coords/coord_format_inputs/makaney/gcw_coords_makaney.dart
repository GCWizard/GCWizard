part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsMakaney extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsMakaney({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsMakaneyState createState() => _GCWCoordsMakaneyState();
}

class _GCWCoordsMakaneyState extends State<_GCWCoordsMakaney> {
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
      var makaney = widget.coordinates is Makaney
          ? widget.coordinates as Makaney
          : Makaney.fromLatLon(widget.coordinates.toLatLng());
      _currentCoord = makaney.toString();

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_makaney_locator'),
          controller: _controller,
          inputFormatters: [_MakaneyTextInputFormatter()],
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
      widget.onChanged(Makaney.parse(_currentCoord));
    } catch (e) {}
  }
}
