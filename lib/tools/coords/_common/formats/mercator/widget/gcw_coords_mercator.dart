part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoMercator extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.MERCATOR;
  @override
  String get i18nKey => mercatorKey;
  @override
  String get name => 'Mercator';
  @override
  String get example => 'Y: 5667450.4, X: -13626989.9';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsMercator(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsMercator extends _GCWCoordWidget {
  _GCWCoordsMercator({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates: coordinates is MercatorCoordinate ? coordinates : MercatorFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsMercatorState createState() => _GCWCoordsMercatorState();
}

class _GCWCoordsMercatorState extends State<_GCWCoordsMercator> {
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
      var mercator = widget.coordinates as MercatorCoordinate;
      _currentEasting.value = mercator.easting;
      _currentNorthing.value = mercator.northing;

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
    var mercator = MercatorCoordinate(_currentEasting.value, _currentNorthing.value);

    widget.onChanged(mercator);
  }
}
