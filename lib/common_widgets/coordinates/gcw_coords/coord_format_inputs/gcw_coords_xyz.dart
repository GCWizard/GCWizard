part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsXYZ extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsXYZ({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsXYZState createState() => _GCWCoordsXYZState();
}

class _GCWCoordsXYZState extends State<_GCWCoordsXYZ> {
  TextEditingController _ControllerX;
  TextEditingController _ControllerY;
  TextEditingController _ControllerZ;

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
    if (widget.coordinates != null) {
      var xyz = widget.coordinates is XYZ
          ? widget.coordinates as XYZ
          : XYZ.fromLatLon(widget.coordinates.toLatLng(), defaultEllipsoid());
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

  _setCurrentValueAndEmitOnChange() {
    // widget.onChanged(XYZ(_currentX, _currentY, _currentZ));
  }
}
