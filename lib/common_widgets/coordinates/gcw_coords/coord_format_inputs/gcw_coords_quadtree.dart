part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsQuadtree extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsQuadtree({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsQuadtreeState createState() => _GCWCoordsQuadtreeState();
}

class _GCWCoordsQuadtreeState extends State<_GCWCoordsQuadtree> {
  TextEditingController _controller;
  var _currentCoord = '';

  var _maskInputFormatter = WrapperForMaskTextInputFormatter(mask: '#' * 100, filter: {"#": RegExp(r'[0123]')});

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
      var quadtree = widget.coordinates is Quadtree
          ? widget.coordinates as Quadtree
          : Quadtree.fromLatLon(widget.coordinates.toLatLng());
      _currentCoord = quadtree.toString();

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
      widget.onChanged(Quadtree.parse(_currentCoord));
    } catch (e) {}
  }
}
