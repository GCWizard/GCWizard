part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsXYZ extends StatefulWidget {
  final void Function(XYZ) onChanged;
  final BaseCoordinate coordinates;
  final bool isDefault;

  const _GCWCoordsXYZ({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

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

  bool _initialized = false;

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
    if (!widget.isDefault && !_initialized) {
      var xyz = widget.coordinates is XYZ
          ? widget.coordinates as XYZ
          : XYZ.fromLatLon(widget.coordinates.toLatLng() ?? defaultCoordinate, defaultEllipsoid);
      _currentX = xyz.x;
      _currentY = xyz.y;
      _currentZ = xyz.z;

      _ControllerX.text = _currentX.toString();
      _ControllerY.text = _currentY.toString();
      _ControllerZ.text = _currentZ.toString();

      _initialized = true;
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
    widget.onChanged(XYZ(_currentX, _currentY, _currentZ));
  }
}
