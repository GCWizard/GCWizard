part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsSwissGrid extends StatefulWidget {
  final void Function(SwissGrid) onChanged;
  final BaseCoordinate coordinates;
  final bool isDefault;

  const _GCWCoordsSwissGrid({Key? key, required this.onChanged, required this.coordinates, this.isDefault = true}) : super(key: key);

  @override
  _GCWCoordsSwissGridState createState() => _GCWCoordsSwissGridState();
}

class _GCWCoordsSwissGridState extends State<_GCWCoordsSwissGrid> {
  late TextEditingController _EastingController;
  late TextEditingController _NorthingController;

  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  bool _initialized = false;

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
    if (!widget.isDefault && !_initialized) {
      var swissGrid = widget.coordinates is SwissGrid
          ? widget.coordinates as SwissGrid
          : SwissGrid.fromLatLon(widget.coordinates.toLatLng() ?? defaultCoordinate, defaultEllipsoid);
      _currentEasting.value = swissGrid.easting;
      _currentNorthing.value = swissGrid.northing;

      _EastingController.text = _currentEasting.value.toString();
      _NorthingController.text = _currentNorthing.value.toString();

      _initialized = true;
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
    widget.onChanged(SwissGrid(_currentEasting.value, _currentNorthing.value));
  }
}
