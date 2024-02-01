part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoNaturalAreaCode extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.NATURAL_AREA_CODE;
  @override
  String get i18nKey => naturalAreaCodeKey;
  @override
  String get name => 'Natural Area Code (NAC)';
  @override
  String get example => 'X: 4RZ000, Y: QJFMGZ';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsNaturalAreaCode(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsNaturalAreaCode extends _GCWCoordWidget {

  _GCWCoordsNaturalAreaCode({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is NaturalAreaCodeCoordinate ? coordinates : NaturalAreaCodeFormatDefinition.defaultCoordinate);

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
    if (widget.initialize) {
      var naturalAreaCode = widget.coordinates as NaturalAreaCodeCoordinate;
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

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(NaturalAreaCodeCoordinate(_currentX, _currentY));
  }
}
