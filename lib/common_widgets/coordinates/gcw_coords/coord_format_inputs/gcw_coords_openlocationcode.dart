part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsOpenLocationCode extends StatefulWidget {
  final void Function(OpenLocationCode?) onChanged;
  final OpenLocationCode coordinates;
  final bool isDefault;

  const _GCWCoordsOpenLocationCode({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsOpenLocationCodeState createState() => _GCWCoordsOpenLocationCodeState();
}

class _GCWCoordsOpenLocationCodeState extends State<_GCWCoordsOpenLocationCode> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = WrapperForMaskTextInputFormatter(
      mask: '**#################',
      filter: {"*": RegExp(r'[23456789CFGHJMPQRVcfghjmpqrv]'), "#": RegExp(r'[23456789CFGHJMPQRVWXcfghjmpqrvwx+]')});

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
      var openLocationCode = widget.coordinates;
      _currentCoord = openLocationCode.text;

      _controller.text = _currentCoord;

      _initialized = true;
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
      widget.onChanged(OpenLocationCode.parse(_currentCoord));
    } catch (e) {}
  }
}
