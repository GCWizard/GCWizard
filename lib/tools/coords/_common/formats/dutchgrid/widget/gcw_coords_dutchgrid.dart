part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoDutchGrid extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.DUTCH_GRID;
  @override
  String get i18nKey => dutchGridKey;
  @override
  String get name => 'RD (Rijksdriehoeks, DutchGrid)';
  @override
  String get example => 'X: 221216.7, Y: 550826.2';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsDutchGrid(
        key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsDutchGrid extends _GCWCoordWidget {
  _GCWCoordsDutchGrid({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(
            coordinates:
                coordinates is DutchGridCoordinate ? coordinates : DutchGridFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsDutchGridState createState() => _GCWCoordsDutchGridState();
}

class _GCWCoordsDutchGridState extends State<_GCWCoordsDutchGrid> {
  late TextEditingController _xController;
  late TextEditingController _yController;

  var _currentX = defaultDoubleText;
  var _currentY = defaultDoubleText;

  @override
  void initState() {
    super.initState();

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
    if (widget.initialize) {
      var dutchGrid = widget.coordinates as DutchGridCoordinate;
      _currentX.value = dutchGrid.x;
      _currentY.value = dutchGrid.y;

      _xController.text = _currentX.value.toString();
      _yController.text = _currentY.value.toString();
    }

    return Column(children: <Widget>[
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          controller: _xController,
          onChanged: (ret) {
            setState(() {
              _currentX = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          controller: _yController,
          onChanged: (ret) {
            setState(() {
              _currentY = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
    ]);
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DutchGridCoordinate(_currentX.value, _currentY.value));
  }
}
