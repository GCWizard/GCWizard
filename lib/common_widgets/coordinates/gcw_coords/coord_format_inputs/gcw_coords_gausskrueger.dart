part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsGaussKrueger extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;
  final String subtype;

  const _GCWCoordsGaussKrueger({Key key, this.onChanged, this.coordinates, this.subtype: keyCoordsGaussKruegerGK1})
      : super(key: key);

  @override
  _GCWCoordsGaussKruegerState createState() => _GCWCoordsGaussKruegerState();
}

class _GCWCoordsGaussKruegerState extends State<_GCWCoordsGaussKrueger> {
  TextEditingController _eastingController;
  TextEditingController _northingController;

  var _currentEasting = {'text': '', 'value': 0.0};
  var _currentNorthing = {'text': '', 'value': 0.0};

  var _currentSubtype = 1;

  @override
  void initState() {
    super.initState();

    _currentSubtype = getGkSubTypeCode(widget.subtype);

    _eastingController = TextEditingController(text: _currentEasting['text']);
    _northingController = TextEditingController(text: _currentNorthing['text']);
  }

  @override
  void dispose() {
    _eastingController.dispose();
    _northingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.coordinates != null) {
      var gausskrueger = widget.coordinates is GaussKrueger
          ? widget.coordinates as GaussKrueger
          : GaussKrueger.fromLatLon(widget.coordinates.toLatLng(), _currentSubtype, defaultEllipsoid());
      _currentEasting['value'] = gausskrueger.easting;
      _currentNorthing['value'] = gausskrueger.northing;
      _currentSubtype = gausskrueger.code;

      _eastingController.text = _currentEasting['value'].toString();
      _northingController.text = _currentNorthing['value'].toString();
    } else if (_subtypeChanged()) {
      _currentSubtype = getGkSubTypeCode(widget.subtype);
      WidgetsBinding.instance.addPostFrameCallback((_) => _setCurrentValueAndEmitOnChange());
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
    return _currentSubtype != getGkSubTypeCode(widget.subtype);
  }

  _setCurrentValueAndEmitOnChange() {
    var code = _currentSubtype;
    var gaussKrueger = GaussKrueger(code, _currentEasting['value'], _currentNorthing['value']);

    widget.onChanged(gaussKrueger);
  }
}
