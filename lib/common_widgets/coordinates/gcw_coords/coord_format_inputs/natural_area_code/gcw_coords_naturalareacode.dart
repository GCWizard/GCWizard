part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsNaturalAreaCode extends StatefulWidget {
  final void Function(NaturalAreaCode) onChanged;
  final NaturalAreaCode coordinates;

  const _GCWCoordsNaturalAreaCode({Key? key, required this.onChanged, required this.coordinates}) : super(key: key);

  @override
  _GCWCoordsNaturalAreaCodeState createState() => _GCWCoordsNaturalAreaCodeState();
}

class _GCWCoordsNaturalAreaCodeState extends State<_GCWCoordsNaturalAreaCode> {
  late TextEditingController _controllerX;
  late TextEditingController _controllerY;
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
    var naturalAreaCode = widget.coordinates;
    _currentX = naturalAreaCode.x;
    _currentY = naturalAreaCode.y;

    _controllerX.text = _currentX;
    _controllerY.text = _currentY;

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

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(NaturalAreaCode(_currentX, _currentY));
  }
}
