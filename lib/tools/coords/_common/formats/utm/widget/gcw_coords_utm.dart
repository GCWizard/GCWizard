part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoUTM extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.UTM;
  @override
  String get i18nKey => utmKey;
  @override
  String get name => 'UTM';
  @override
  String get example => '10 N 546003.6 5015445.0';

  @override
  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize}) {
    return _GCWCoordsUTM(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsUTM extends _GCWCoordWidget {
  _GCWCoordsUTM({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize})
      : super(coordinates: coordinates is UTMREFCoordinate ? coordinates : UTMREFFormatDefinition.defaultCoordinate);

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
    if (widget.initialize) {
      var utm = widget.coordinates as UTMREFCoordinate;
      _currentLonZone.value = utm.zone.lonZone;
      _currentEasting.value = utm.easting;
      _currentNorthing.value = utm.northing;
      _currentLatZone = utm.zone.latZone;

      _LonZoneController.text = _currentLonZone.value.toString();
      _EastingController.text = _currentEasting.value.toString();
      _NorthingController.text = _currentNorthing.value.toString();
    }

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
    var utm = UTMREFCoordinate(zone, _currentEasting.value, _currentNorthing.value);

    widget.onChanged(utm);
  }
}
