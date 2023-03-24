part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GCWCoordsUTM extends StatefulWidget {
  final void Function(UTMREF) onChanged;
  final BaseCoordinate coordinates;

  const _GCWCoordsUTM({Key? key, required this.onChanged, required this.coordinates}) : super(key: key);

  @override
  _GCWCoordsUTMState createState() => _GCWCoordsUTMState();
}

class _GCWCoordsUTMState extends State<_GCWCoordsUTM> {
  late TextEditingController _LonZoneController;
  late TextEditingController _EastingController;
  late TextEditingController _NorthingController;

  var _currentLatZone = 'U';
  var _currentLonZone = defaultIntegerText;
  var _currentEasting = defaultDoubleText;
  var _currentNorthing = defaultDoubleText;

  @override
  void initState() {
    super.initState();
    _LonZoneController = TextEditingController(text: _currentLonZone.text);

    _EastingController = TextEditingController(text: _currentEasting.text);
    _NorthingController = TextEditingController(text: _currentNorthing.text);
  }

  @override
  void dispose() {
    _LonZoneController.dispose();
    _EastingController.dispose();
    _NorthingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var utm = widget.coordinates is UTMREF
        ? widget.coordinates as UTMREF
        : UTMREF.fromLatLon(widget.coordinates.toLatLng() ?? defaultCoordinate, defaultEllipsoid);
    _currentLonZone.value = utm.zone.lonZone;
    _currentEasting.value = utm.easting;
    _currentNorthing.value = utm.northing;
    _currentLatZone = utm.zone.latZone;

    _LonZoneController.text = _currentLonZone.value.toString();
    _EastingController.text = _currentEasting.value.toString();
    _NorthingController.text = _currentNorthing.value.toString();

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: GCWIntegerTextField(
                hintText: i18n(context, 'coords_formatconverter_utm_lonzone'),
                textInputFormatter: _UTMLonZoneTextInputFormatter(),
                controller: _LonZoneController,
                onChanged: (ret) {
                  setState(() {
                    _currentLonZone = ret;
                    _setCurrentValueAndEmitOnChange();
                  });
                }),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
            child: GCWDropDown<String>(
              value: _currentLatZone,
              onChanged: (String newValue) {
                setState(() {
                  _currentLatZone = newValue;
                  _setCurrentValueAndEmitOnChange();
                });
              },
              items: latZones.split('').map((char) {
                return GCWDropDownMenuItem(
                  value: char,
                  child: char,
                );
              }).toList(),
            ),
          )),
        ],
      ),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_easting'),
          min: 0.0,
          controller: _EastingController,
          onChanged: (ret) {
            setState(() {
              _currentEasting = ret;
              _setCurrentValueAndEmitOnChange();
            });
          }),
      GCWDoubleTextField(
          hintText: i18n(context, 'coords_formatconverter_northing'),
          min: 0.0,
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
    var _lonZone = _currentLonZone.value;

    var zone = UTMZone(_lonZone, _lonZone, _currentLatZone);
    var utm = UTMREF(zone, _currentEasting.value, _currentNorthing.value);

    widget.onChanged(utm);
  }
}
