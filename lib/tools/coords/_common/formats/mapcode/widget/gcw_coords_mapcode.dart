part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

var _currentTerritory = '';
void Function()? _onChangedIntern;

class _GCWCoordWidgetInfoMapCode extends GCWCoordWidgetWithSubtypeInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.MAPCODE;
  @override
  CoordinateFormatKey get subtype => defaultMapCodeType;
  @override
  String get i18nKey => mapCodeKey;
  @override
  String get name => 'MapCode';
  @override
  String get example => 'VJMM4.DTYX';

  @override
  List<_GCWCoordWidgetSubtypeInfo> get subtypes => [
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.MAPCODE_LOCAL, 'coords_formatconverter_mapcode_local'),
        const _GCWCoordWidgetSubtypeInfo(
            CoordinateFormatKey.MAPCODE_INTERNATIONAL, 'coords_formatconverter_mapcode_international'),
      ];

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsMapCode(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }

  /// TerritorysDropDown
  @override
  Widget inputWidget(
      {required BuildContext context,
      required CoordinateFormatKey value,
      required void Function(CoordinateFormatKey) onChanged}) {
    return GCWDropDown<String>(
        value: _currentTerritory,
        items: _buildTerritorysList().map((entry) {
          return GCWDropDownMenuItem(
            value: entry.key,
            child: entry.value,
          );
        }).toList(),
        onChanged: (value) {
          _currentTerritory = value;
          if (_onChangedIntern != null) {
            _onChangedIntern!();
          }
        });
  }

  List<MapEntry<String, String>> _buildTerritorysList() {
    var list = iso3166alpha
        .mapIndexed((index, entry) =>
            MapEntry(entry, entry + ' (' + isofullname[index].replaceAll(RegExp(r"\(.*\)"), '').trim() + ')'))
        .toList();
    list.sort((e1, e2) => e1.key.compareTo(e2.key));
    list.insert(0, const MapEntry<String, String>('', ''));

    return list;
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

class _GCWCoordsMapCode extends _GCWCoordWidget {
  _GCWCoordsMapCode({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(coordinates: coordinates is MapCode ? coordinates : MapCodeFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsMapCodeState createState() => _GCWCoordsMapCodeState();
}

class _GCWCoordsMapCodeState extends State<_GCWCoordsMapCode> {
  late TextEditingController _controller;
  var _currentCoord = '';
  CoordinateFormatKey _currentSubtype = defaultMapCodeType;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentCoord);
    _onChangedIntern = _setCurrentValueAndEmitOnChange;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentSubtype = widget.coordinates?.format.subtype ?? defaultMapCodeType;

    if (_subtypeChanged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (widget.initialize) {
      var mapcode = widget.coordinates;
      _currentCoord = mapcode.toString();

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          controller: _controller,
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentSubtype != widget.coordinates?.format.subtype;
  }

  void _setCurrentValueAndEmitOnChange() {
    try {
      var mapCode = MapCode.parse(_currentCoord, territory: _currentTerritory);

      widget.onChanged(mapCode);
    } catch (e) {}
  }
}
