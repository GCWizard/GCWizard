part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoSwissGridPlus extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.SWISS_GRID_PLUS;
  @override
  String get i18nKey => swissGridPlusKey;
  @override
  String get name => 'SwissGrid (CH1903+/LV95)';
  @override
  String get example => 'Y: 2720660.2, X: 1167765.3';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsSwissGridPlus(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsSwissGridPlus extends _GCWCoordWidget {
  _GCWCoordsSwissGridPlus({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates:
                coordinates is SwissGridPlusCoordinate ? coordinates : SwissGridPlusFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsSwissGridPlusState createState() => _GCWCoordsSwissGridPlusState();
}

class _GCWCoordsSwissGridPlusState extends State<_GCWCoordsSwissGridPlus> {
  late TextEditingController _EastingController;
  late TextEditingController _NorthingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  @override
  void initState() {
    super.initState();
    _EastingController = TextEditingController(text: _currentEasting.text);
    _NorthingController = TextEditingController(text: _currentNorthing.text);
  }

  @override
  void dispose() {
    _EastingController.dispose();
    _NorthingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialize) {
      var swissGridPlus = widget.coordinates as SwissGridPlusCoordinate;
      _currentEasting.value = swissGridPlus.easting;
      _currentNorthing.value = swissGridPlus.northing;

      _EastingController.text = _currentEasting.value.toString();
      _NorthingController.text = _currentNorthing.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _EastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _NorthingController,
          onChanged: (ret) {
            setState(() {
              _currentNorthing = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(SwissGridPlusCoordinate(_currentEasting.value, _currentNorthing.value));
  }
}
