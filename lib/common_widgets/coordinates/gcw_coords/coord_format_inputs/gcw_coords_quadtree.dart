part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsQuadtree extends StatefulWidget {
  final void Function(Quadtree?) onChanged;
  final BaseCoordinate coordinates;
  final bool isDefault;

  const _GCWCoordsQuadtree({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsQuadtreeState createState() => _GCWCoordsQuadtreeState();
}

class _GCWCoordsQuadtreeState extends State<_GCWCoordsQuadtree> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = WrapperForMaskTextInputFormatter(mask: '#' * 100, filter: {"#": RegExp(r'[0123]')});

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
      var quadtree = widget.coordinates;
      _currentCoord = quadtree.toString();

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
      widget.onChanged(Quadtree.parse(_currentCoord));
    } catch (e) {}
  }
}
