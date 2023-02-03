part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsDutchGrid extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsDutchGrid({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsDutchGridState createState() => _GCWCoordsDutchGridState();
}

class _GCWCoordsDutchGridState extends State<_GCWCoordsDutchGrid> {
  TextEditingController _xController;
  TextEditingController _yController;

  var _currentX = {'text': '', 'value': 0.0};
  var _currentY = {'text': '', 'value': 0.0};

  @override
  void initState() {
    super.initState();
    _xController = TextEditingController(text: _currentX['text']);
    _yController = TextEditingController(text: _currentY['text']);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coordinates != null) {
      var dutchGrid = widget.coordinates is DutchGrid
          ? widget.coordinates as DutchGrid
          : DutchGrid.fromLatLon(widget.coordinates.toLatLng());
      _currentX['value'] = dutchGrid.x;
      _currentY['value'] = dutchGrid.y;

      _xController.text = _currentX['value'].toString();
      _yController.text = _currentY['value'].toString();
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

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged(DutchGrid(_currentX['value'], _currentY['value']));
  }
}
