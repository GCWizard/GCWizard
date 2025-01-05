part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoQuadtree extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.QUADTREE;
  @override
  String get i18nKey => quadtreeKey;
  @override
  String get name => 'Quadtree';
  @override
  String get example => '021230223311203323';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsQuadtree(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsQuadtree extends _GCWCoordWidget {
  _GCWCoordsQuadtree({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is QuadtreeCoordinate ? coordinates : QuadtreeFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsQuadtreeState createState() => _GCWCoordsQuadtreeState();
}

class _GCWCoordsQuadtreeState extends State<_GCWCoordsQuadtree> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '#' * 100, filter: {"#": RegExp(r'[0123]')});

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
      var quadtree = widget.coordinates as QuadtreeCoordinate;
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

  void _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(QuadtreeCoordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
