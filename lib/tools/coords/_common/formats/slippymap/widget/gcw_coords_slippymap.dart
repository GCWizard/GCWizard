part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoSlippyMap extends GCWCoordWidgetWithSubtypeInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.SLIPPY_MAP;
  @override
  CoordinateFormatKey get subtype => defaultSlippyMapType;
  @override
  String get i18nKey => slippyMapKey;
  @override
  String get name => 'Slippy Map Tiles';
  @override
  String get example => 'Z: 15, X: 5241, Y: 11749';

  @override
  List<_GCWCoordWidgetSubtypeInfo> get subtypes => [
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_0, '0'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_1, '1'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_2, '2'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_3, '3'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_4, '4'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_5, '5'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_6, '6'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_7, '7'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_8, '8'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_9, '9'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_10, '10'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_11, '11'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_12, '12'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_13, '13'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_14, '14'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_15, '15'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_16, '16'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_17, '17'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_18, '18'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_19, '19'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_20, '20'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_21, '21'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_22, '22'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_23, '23'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_24, '24'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_25, '25'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_26, '26'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_27, '27'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_28, '28'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_29, '29'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.SLIPPYMAP_30, '30'),
  ];
  
  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsSlippyMap(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }

  @override
  Widget _buildSubtypeWidget({
    required BuildContext context,
    required CoordinateFormatKey value,
    required void Function(CoordinateFormatKey) onChanged}) {

    var _onChanged = onChanged;
    return GCWIntegerSpinner(
      min: 0,
      max: 30,
      title: i18n(context, 'coords_formatconverter_slippymap_zoom') + ' (Z)',
      value: switchMapKeyValue(SLIPPY_MAP_ZOOM)[value]!,
      onChanged: (value) => _onChanged(SLIPPY_MAP_ZOOM[value]!),
    );
  }
}

class _GCWCoordsSlippyMap extends _GCWCoordWidget {

  _GCWCoordsSlippyMap({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is SlippyMapCoordinate ? coordinates : SlippyMapFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsSlippyMapState createState() => _GCWCoordsSlippyMapState();
}

class _GCWCoordsSlippyMapState extends State<_GCWCoordsSlippyMap> {
  late TextEditingController _xController;
  late TextEditingController _yController;

  var _currentX = defaultDoubleText;
  var _currentY = defaultDoubleText;

  late int _currentZoom;

  @override
  void initState() {
    super.initState();

    _currentZoom = _slippyMapZoom();

    _xController = TextEditingController(text: _currentX.text);
    _yController = TextEditingController(text: _currentY.text);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_subtypeChanged()) {
      _currentZoom = _slippyMapZoom();
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (widget.initialize) {
      var slippyMap = widget.coordinates as SlippyMapCoordinate;
      _currentX.value = slippyMap.x;
      _currentY.value = slippyMap.y;

      _xController.text = _currentX.value.toString();
      _yController.text = _currentY.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: 'X',
          min: 0.0,
          controller: _xController,
          onChanged: (ret) {
            setState(() {
              _currentX = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: 'Y',
          min: 0.0,
          controller: _yController,
          onChanged: (ret) {
            setState(() {
              _currentY = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentZoom != _slippyMapZoom();
  }

  int _slippyMapZoom() {
    return switchMapKeyValue(SLIPPY_MAP_ZOOM)[widget.coordinates?.format.subtype ?? defaultSlippyMapType]!;
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(SlippyMapCoordinate(_currentX.value, _currentY.value, widget.coordinates?.format.subtype ?? defaultSlippyMapType));
  }
}
