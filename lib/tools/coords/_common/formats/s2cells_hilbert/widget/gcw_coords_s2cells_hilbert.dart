part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoS2CellsHilbert extends GCWCoordWidgetWithSubtypeInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.S2CELLS_HILBERT;
  @override
  CoordinateFormatKey get subtype => defaultS2CellsHilbertType;
  @override
  String get i18nKey => s2CellsHilbertKey;
  @override
  String get name => 'coords_formatconverter_s2cellshilbert';
  @override
  String get example => '549578c7248ec045';

  @override
  List<_GCWCoordWidgetSubtypeInfo> get subtypes => [
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.S2CELLS_HILBERT_QUADRATIC, 'coords_formatconverter_s2cellshilbert_quadratic'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.S2CELLS_HILBERT_TAN, 'coords_formatconverter_s2cellshilbert_tan'),
        const _GCWCoordWidgetSubtypeInfo(CoordinateFormatKey.S2CELLS_HILBERT_LINEAR, 'coords_formatconverter_s2cellshilbert_linear')
      ];

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsS2Cells(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
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

class _GCWCoordsS2Cells extends _GCWCoordWidget {
  _GCWCoordsS2Cells({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(coordinates: coordinates is S2CellsHilbertCoordinate ? coordinates : S2CellsHilbertFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsS2CellsState createState() => _GCWCoordsS2CellsState();
}

class _GCWCoordsS2CellsState extends State<_GCWCoordsS2Cells> {
  late TextEditingController _tokenController;

  var _currentToken = '';

  var _currentSubtype = (S2CellsHilbertFormatDefinition.defaultCoordinate as BaseCoordinateWithSubtypes).defaultSubtype;

  @override
  void initState() {
    super.initState();

    _tokenController = TextEditingController(text: _currentToken);
  }

  @override
  void dispose() {
    _tokenController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentSubtype = widget.coordinates?.format.subtype ?? defaultS2CellsHilbertType;

    if (_subtypeChanged()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
    } else if (widget.initialize) {
      var s2cells = widget.coordinates as S2CellsHilbertCoordinate;
      _currentToken = s2cells.token;

      _tokenController.text = _currentToken;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_s2cellshilbert_token'),
          controller: _tokenController,
          onChanged: (ret) {
            setState(() {
              _currentToken = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  bool _subtypeChanged() {
    return _currentSubtype != widget.coordinates?.format.subtype;
  }

  void _setCurrentValueAndEmitOnChange() {
    var s2cells = S2CellsHilbertCoordinate(_currentToken, _currentSubtype);
    widget.onChanged(s2cells);
  }
}
