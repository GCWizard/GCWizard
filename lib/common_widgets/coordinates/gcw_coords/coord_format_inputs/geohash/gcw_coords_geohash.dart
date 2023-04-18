part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsGeohash extends StatefulWidget {
  final void Function(Geohash?) onChanged;
  final Geohash coordinates;
  final bool isDefault;

  const _GCWCoordsGeohash({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsGeohashState createState() => _GCWCoordsGeohashState();
}

class _GCWCoordsGeohashState extends State<_GCWCoordsGeohash> {
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
      var geohash = widget.coordinates;
      _currentCoord = geohash.text;

      _controller.text = _currentCoord;

      _initialized = true;
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

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(Geohash.parse(_currentCoord));
  }
}
