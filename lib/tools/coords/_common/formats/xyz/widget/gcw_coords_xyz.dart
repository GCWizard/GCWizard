part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoXYZ extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.XYZ;
  @override
  String get i18nKey => xyzKey;
  @override
  String get name => 'XYZ (ECEF)';
  @override
  String get example => 'X: -2409244, Y: -3794410, Z: 4510158';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsXYZ(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsXYZ extends _GCWCoordWidget {

  _GCWCoordsXYZ({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is XYZCoordinate ? coordinates : XYZFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsXYZState createState() => _GCWCoordsXYZState();
}

class _GCWCoordsXYZState extends State<_GCWCoordsXYZ> {
  late TextEditingController _ControllerX;
  late TextEditingController _ControllerY;
  late TextEditingController _ControllerZ;

  var _currentX = 0.0;
  var _currentY = 0.0;
  var _currentZ = 0.0;

  @override
  void initState() {
    super.initState();
    _ControllerX = TextEditingController(text: _currentX.toString());
    _ControllerY = TextEditingController(text: _currentY.toString());
    _ControllerZ = TextEditingController(text: _currentZ.toString());
  }

  @override
  void dispose() {
    _ControllerX.dispose();
    _ControllerY.dispose();
    _ControllerZ.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialize) {
      var xyz = widget.coordinates as XYZCoordinate;
      _currentX = xyz.x;
      _currentY = xyz.y;
      _currentZ = xyz.z;

      _ControllerX.text = _currentX.toString();
      _ControllerY.text = _currentY.toString();
      _ControllerZ.text = _currentZ.toString();
    }

    return Column(children: <Widget>[
      GCWDistance(
          controller: _ControllerX,
          value: _currentX,
          hintText: 'X',
          allowNegativeValues: true,
          onChanged: (value) {
            setState(() {
              _currentX = value;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDistance(
          controller: _ControllerY,
          value: _currentY,
          hintText: 'Y',
          allowNegativeValues: true,
          onChanged: (value) {
            setState(() {
              _currentY = value;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDistance(
          controller: _ControllerZ,
          value: _currentZ,
          hintText: 'Z',
          allowNegativeValues: true,
          onChanged: (value) {
            setState(() {
              _currentZ = value;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(XYZCoordinate(_currentX, _currentY, _currentZ));
  }
}
