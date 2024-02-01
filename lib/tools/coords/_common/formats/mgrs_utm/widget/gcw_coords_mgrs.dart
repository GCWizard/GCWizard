part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GCWCoordWidgetInfoMGRS extends GCWCoordWidgetInfo {
  @override
  CoordinateFormatKey get type => CoordinateFormatKey.MGRS;
  @override
  String get i18nKey => mgrsKey;
  @override
  String get name => 'MGRS';
  @override
  String get example => '10T ER 46003.6 15445.0';

  @override
  _GCWCoordWidget mainWidget({
    Key? key,
    required void Function(BaseCoordinate?) onChanged,
    required BaseCoordinate? coordinates,
    bool? initialize
  }) {
    return _GCWCoordsMGRS(key: key, onChanged: onChanged, coordinates: coordinates, initialize: initialize ?? false);
  }
}

class _GCWCoordsMGRS extends _GCWCoordWidget {

  _GCWCoordsMGRS({super.key, required super.onChanged, required BaseCoordinate? coordinates, super.initialize}) :
        super(coordinates: coordinates is MGRSCoordinate ? coordinates : MGRSFormatDefinition.defaultCoordinate);

  @override
  _GCWCoordsMGRSState createState() => _GCWCoordsMGRSState();
}

class _GCWCoordsMGRSState extends State<_GCWCoordsMGRS> {
  late TextEditingController _LonZoneController;
  late TextEditingController _EastingController;
  late TextEditingController _NorthingController;

  var _currentLatZone = 'A';
  var _currentDigraphEasting = 'A';
  var _currentDigraphNorthing = 'A';

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
      var mgrs = widget.coordinates as MGRSCoordinate;
      _currentEasting.value = mgrs.easting;
      _currentNorthing.value = mgrs.northing;

      _currentLonZone.value = mgrs.utmZone.lonZone;
      _currentLatZone = mgrs.utmZone.latZone;
      _currentDigraphEasting = mgrs.digraph[0];
      _currentDigraphNorthing = mgrs.digraph[1];

      _LonZoneController.text = _currentLonZone.value.toString();
      _EastingController.text = _currentEasting.value.toString();
      _NorthingController.text = _currentNorthing.value.toString();
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
            child: GCWIntegerTextField(
                hintText: i18n(context, 'coords_formatconverter_mgrs_lonzone'),
                textInputFormatter: _UTMLonZoneTextInputFormatter(),
                controller: _LonZoneController,
                onChanged: (IntegerText ret) {
                  setState(() {
                    _currentLonZone = ret;
                    //   _setCurrentValueAndEmitOnChange();
                  });
                }),
          )),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                  child: GCWDropDown<String>(
                    value: _currentLatZone,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentLatZone = newValue;
                        // _setCurrentValueAndEmitOnChange();
                      });
                    },
                    items: digraphLettersEast.split('').map((char) {
                      return GCWDropDownMenuItem(
                        value: char,
                        child: char,
                      );
                    }).toList(),
                  ))),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
            child: GCWDropDown<String>(
              value: _currentDigraphEasting,
              onChanged: (String newValue) {
                setState(() {
                  _currentDigraphEasting = newValue;
                  // _setCurrentValueAndEmitOnChange();
                });
              },
              items: digraphLettersEast.split('').map((char) {
                return GCWDropDownMenuItem(
                  value: char,
                  child: char,
                );
              }).toList(),
            ),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
            child: GCWDropDown<String>(
              value: _currentDigraphNorthing,
              onChanged: (String newValue) {
                setState(() {
                  _currentDigraphNorthing = newValue;
                  //_setCurrentValueAndEmitOnChange();
                });
              },
              items: digraphLettersNorth.split('').map((char) {
                return GCWDropDownMenuItem(
                  value: char,
                  child: char,
                );
              }).toList(),
            ),
          ))
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
    double easting = _currentEasting.value;
    easting = fillUpNumber(easting, _EastingController.text, 5);

    double northing = _currentNorthing.value;
    northing = fillUpNumber(northing, _NorthingController.text, 5);

    var _lonZone = _currentLonZone.value;
    var zone = UTMZone(_lonZone, _lonZone, _currentLatZone);
    var mgrs = MGRSCoordinate(zone, _currentDigraphEasting + _currentDigraphNorthing, easting, northing);

    widget.onChanged(mgrs);
  }
}
