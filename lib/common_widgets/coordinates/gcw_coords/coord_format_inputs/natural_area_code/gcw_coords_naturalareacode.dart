part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsNaturalAreaCode extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsNaturalAreaCode({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsNaturalAreaCodeState createState() => _GCWCoordsNaturalAreaCodeState();
}

class _GCWCoordsNaturalAreaCodeState extends State<_GCWCoordsNaturalAreaCode> {
  TextEditingController _controllerX;
  TextEditingController _controllerY;
  var _currentX = '';
  var _currentY = '';

  @override
  void initState() {
    super.initState();

    _controllerX = TextEditingController(text: _currentX);
    _controllerY = TextEditingController(text: _currentY);
  }

  @override
  void dispose() {
    _controllerX.dispose();
    _controllerY.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coordinates != null) {
      var naturalAreaCode = widget.coordinates is NaturalAreaCode
          ? widget.coordinates as NaturalAreaCode
          : NaturalAreaCode.fromLatLon(widget.coordinates.toLatLng());
      _currentX = naturalAreaCode.x;
      _currentY = naturalAreaCode.y;

      _controllerX.text = _currentX;
      _controllerY.text = _currentY;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _controllerX,
          inputFormatters: [_NaturalAreaCodeTextInputFormatter()],
          onChanged: (ret) {
            setState(() {
              _currentX = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _controllerY,
          inputFormatters: [_NaturalAreaCodeTextInputFormatter()],
          onChanged: (ret) {
            setState(() {
              _currentY = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged(NaturalAreaCode(_currentX, _currentY));
  }
}
