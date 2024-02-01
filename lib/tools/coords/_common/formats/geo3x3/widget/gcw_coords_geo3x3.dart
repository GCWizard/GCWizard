part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoGeo3x3 extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.GEO3X3;
  @override
  String get i18nKey => geo3x3Key;
  @override
  String get name => 'Geo3x3';
  @override
  String get example => 'W7392967941169';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsGeo3x3(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsGeo3x3 extends _GCWCoordWidget {

  _GCWCoordsGeo3x3({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is Geo3x3Coordinate ? coordinates : Geo3x3FormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsGeo3x3State createState() => _GCWCoordsGeo3x3State();
}

class _GCWCoordsGeo3x3State extends State<_GCWCoordsGeo3x3> {
  late TextEditingController _controller;
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
    if (widget.initialize) {
      var geo3x3 = widget.coordinates as Geo3x3Coordinate;
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

  void _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(Geo3x3Coordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
