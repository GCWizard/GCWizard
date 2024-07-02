part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoLambert extends GCWCoordWidgetWithSubtypeInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.LAMBERT;
  @override
  CoordinateFormatKey get subtype => defaultLambertType;
  @override
  String get i18nKey => lambertKey;
  @override
  String get name => 'coords_formatconverter_lambert';
  @override
  String get example => 'X: 8837763.4, Y: 5978799.1';

  @override
  List<_GCWCoordWidgetSubtypeInfo> get subtypes => [
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93, 'coords_formatconverter_lambert_93'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT2008, 'coords_formatconverter_lambert_2008'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.ETRS89LCC, 'coords_formatconverter_lambert_etrs89lcc'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT72, 'coords_formatconverter_lambert_72'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC42, 'coords_formatconverter_lambert_l93cc42'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC43, 'coords_formatconverter_lambert_l93cc43'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC44, 'coords_formatconverter_lambert_l93cc44'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC45, 'coords_formatconverter_lambert_l93cc45'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC46, 'coords_formatconverter_lambert_l93cc46'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC47, 'coords_formatconverter_lambert_l93cc47'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC48, 'coords_formatconverter_lambert_l93cc48'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC49, 'coords_formatconverter_lambert_l93cc49'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.LAMBERT93_CC50, 'coords_formatconverter_lambert_l93cc50')
      ];

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsLambert(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }

  @override
  Widget _buildSubtypeWidget(
      {required BuildContext context,
      required CoordinateFormatKey value,
      required void Function(CoordinateFormatKey) onChanged}) {
    var _onChanged = onChanged;
    return GCWDropDown<CoordinateFormatKey>(
      value: value,
      items: subtypes.map((subtype) {
        return GCWDropDownMenuItem(
          value: subtype.type,
          child: i18n(context, subtype.name),
        );
      }).toList(),
      onChanged: (value) => _onChanged(value),
    );
  }
}

class _GCWCoordsLambert extends _GCWCoordWidget {
  _GCWCoordsLambert({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(coordinates: coordinates is LambertCoordinate ? coordinates : LambertFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsLambertState createState() => _GCWCoordsLambertState();
}

class _GCWCoordsLambertState extends State<_GCWCoordsLambert> {
  late TextEditingController _eastingController;
  late TextEditingController _northingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  var _currentSubtype = (LambertFormatDefinition.defaultCoordinate as BaseCoordinateWithSubtypes).defaultSubtype;

  @override
  void initState() {
    super.initState();

    _eastingController = TextEditingController(text: _currentEasting.text);
    _northingController = TextEditingController(text: _currentNorthing.text);
  }

  @override
  void dispose() {
    _eastingController.dispose();
    _northingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentSubtype = widget.coordinates?.format.subtype ?? defaultLambertType;

    if (_subtypeChanged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (widget.initialize) {
      var lambert = widget.coordinates as LambertCoordinate;
      _currentEasting.value = lambert.easting;
      _currentNorthing.value = lambert.northing;

      _eastingController.text = _currentEasting.value.toString();
      _northingController.text = _currentNorthing.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _eastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _northingController,
          onChanged: (ret) {
            setState(() {
              _currentNorthing = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentSubtype != widget.coordinates?.format.subtype;
  }

  void _setCurrentValueAndEmitOnChange() {
    var lambert = LambertCoordinate(_currentEasting.value, _currentNorthing.value, _currentSubtype);
    widget.onChanged(lambert);
  }
}
