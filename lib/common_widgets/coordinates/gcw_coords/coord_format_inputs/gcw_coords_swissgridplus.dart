part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsSwissGridPlus extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const _GCWCoordsSwissGridPlus({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  _GCWCoordsSwissGridPlusState createState() => _GCWCoordsSwissGridPlusState();
}

class _GCWCoordsSwissGridPlusState extends State<_GCWCoordsSwissGridPlus> {
  TextEditingController _EastingController;
  TextEditingController _NorthingController;

  var _currentEasting = {'text': '', 'value': 0.0};
  var _currentNorthing = {'text': '', 'value': 0.0};

  @override
  void initState() {
    super.initState();
    _EastingController = TextEditingController(text: _currentEasting['text']);
    _NorthingController = TextEditingController(text: _currentNorthing['text']);
  }

  @override
  void dispose() {
    _EastingController.dispose();
    _NorthingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coordinates != null) {
      var swissGridPlus = widget.coordinates is SwissGridPlus
          ? widget.coordinates as SwissGridPlus
          : SwissGridPlus.fromLatLon(widget.coordinates.toLatLng(), defaultEllipsoid());
      _currentEasting['value'] = swissGridPlus.easting;
      _currentNorthing['value'] = swissGridPlus.northing;

      _EastingController.text = _currentEasting['value'].toString();
      _NorthingController.text = _currentNorthing['value'].toString();
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

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged(SwissGridPlus(_currentEasting['value'], _currentNorthing['value']));
  }
}
