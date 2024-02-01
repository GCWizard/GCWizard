part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoGaussKrueger extends GCWCoordWidgetWithSubtypeInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.GAUSS_KRUEGER;
  @override
  CoordinateFormatKey get subtype => defaultGaussKruegerType;
  @override
  String get i18nKey => gausKruegerKey;
  @override
  String get name => 'coords_formatconverter_gausskrueger';
  @override
  String get example => 'R: 8837763.4, H: 5978799.1';

  @override
  List<_GCWCoordWidgetSubtypeInfo> get subtypes => [
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.GAUSS_KRUEGER_GK1, 'coords_formatconverter_gausskrueger_gk1'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.GAUSS_KRUEGER_GK2, 'coords_formatconverter_gausskrueger_gk2'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.GAUSS_KRUEGER_GK3, 'coords_formatconverter_gausskrueger_gk3'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.GAUSS_KRUEGER_GK4, 'coords_formatconverter_gausskrueger_gk4'),
    const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.GAUSS_KRUEGER_GK5, 'coords_formatconverter_gausskrueger_gk5'),
  ];

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsGaussKrueger(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }

  @override
  Widget _buildSubtypeWidget({
    required BuildContext context,
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

class _GCWCoordsGaussKrueger extends _GCWCoordWidget {

  _GCWCoordsGaussKrueger({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is GaussKruegerCoordinate ? coordinates : GaussKruegerFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsGaussKruegerState createState() => _GCWCoordsGaussKruegerState();
}

class _GCWCoordsGaussKruegerState extends State<_GCWCoordsGaussKrueger> {
  late TextEditingController _eastingController;
  late TextEditingController _northingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  var _currentSubtype = (GaussKruegerFormatDefinition.defaultCoordinate as BaseCoordinateWithSubtypes).defaultSubtype;

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
    _currentSubtype = widget.coordinates?.format.subtype ?? defaultGaussKruegerType;

    if (_subtypeChanged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (widget.initialize) {
      var gausskrueger = widget.coordinates as GaussKruegerCoordinate;
      _currentEasting.value = gausskrueger.easting;
      _currentNorthing.value = gausskrueger.northing;

      _eastingController.text = _currentEasting.value.toString();
      _northingController.text = _currentNorthing.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_gausskrueger_easting'),
          controller: _eastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_gausskrueger_northing'),
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
    var subtype = _currentSubtype;
    var gaussKrueger = GaussKruegerCoordinate(_currentEasting.value, _currentNorthing.value, subtype);

    widget.onChanged(gaussKrueger);
  }
}
