part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsOpenLocationCode extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsOpenLocationCode({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsOpenLocationCodeState createState() => _GCWCoordsOpenLocationCodeState();
}

class _GCWCoordsOpenLocationCodeState extends State<_GCWCoordsOpenLocationCode> {
  TextEditingController _controller;
  var _currentCoord = '';

  var _maskInputFormatter = WrapperForMaskTextInputFormatter(
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
    if (widget.coordinates != null) {
      var openLocationCode = widget.coordinates is OpenLocationCode
          ? widget.coordinates as OpenLocationCode
          : OpenLocationCode.fromLatLon(widget.coordinates.toLatLng(), codeLength: 14);
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

  _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(OpenLocationCode.parse(_currentCoord));
    } catch (e) {}
  }
}
