part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoDfciGrid extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.DFCI_GRID;
  @override
  String get i18nKey => dfciGridKey;
  @override
  String get name => 'DFCI Grid';
  @override
  String get example => 'W7392967941169';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsDfciGrid(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsDfciGrid extends _GCWCoordWidget {
  _GCWCoordsDfciGrid({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(coordinates: coordinates is DfciGridCoordinate ? coordinates : DfciGridFormatDefinition.defaultCoordinate);

  @override
  _GCWCoords_GCWCoordsDfciGridState createState() => _GCWCoords_GCWCoordsDfciGridState();
}

class _GCWCoords_GCWCoordsDfciGridState extends State<_GCWCoordsDfciGrid> {
  late TextEditingController _controller;
  var _currentCoord = '';

  final _maskInputFormatter = GCWMaskTextInputFormatter(mask: '12334567', filter: {
    "1": RegExp(r'[a-hA-Hk-nK-N]'),
    "2": RegExp(r'[b-hB-Hk-nK-N]'),
    '3': RegExp(r'[02468]'),
    "4": RegExp(r'[a-hA-Hk-lK-L]'),
    '5': RegExp(r'[0-9]'),
    '6': RegExp(r'[.]'),
    "7": RegExp(r'[1-5]')});

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentCoord);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialize) {
      var dfciGrid = widget.coordinates as DfciGridCoordinate;
      _currentCoord = dfciGrid.text;

      _controller.text = _currentCoord;
    }

    return Column(children: <Widget>[
      GCWTextField(
          hintText: i18n(context, 'coords_formatconverter_dfci_grid'),
          controller: _controller,
          inputFormatters: [_maskInputFormatter],
          onChanged: (ret) {
            setState(() {
              _currentCoord = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    try {
      widget.onChanged(Geo3x3Coordinate.parse(_currentCoord));
    } catch (e) {}
  }
}
