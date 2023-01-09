import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/converter/mgrs.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_double_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_textfield.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/coords_integer_utm_lonzone_textinputformatter.dart';

class GCWCoordsMGRS extends StatefulWidget {
  final Function onChanged;
  final BaseCoordinates coordinates;

  const GCWCoordsMGRS({Key key, this.onChanged, this.coordinates}) : super(key: key);

  @override
  GCWCoordsMGRSState createState() => GCWCoordsMGRSState();
}

class GCWCoordsMGRSState extends State<GCWCoordsMGRS> {
  TextEditingController _LonZoneController;
  TextEditingController _EastingController;
  TextEditingController _NorthingController;

  var _currentLatZone = 'A';
  var _currentDigraphEasting = 'A';
  var _currentDigraphNorthing = 'A';

  var _currentLonZone = {'text': '', 'value': 0};
  var _currentEasting = {'text': '', 'value': 0.0};
  var _currentNorthing = {'text': '', 'value': 0.0};

  @override
  void initState() {
    super.initState();
    _LonZoneController = TextEditingController(text: _currentLonZone['text']);

    _EastingController = TextEditingController(text: _currentEasting['text']);
    _NorthingController = TextEditingController(text: _currentNorthing['text']);
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
    if (widget.coordinates != null) {
      var mgrs = widget.coordinates is MGRS
          ? widget.coordinates as MGRS
          : MGRS.fromLatLon(widget.coordinates.toLatLng(), defaultEllipsoid());
      _currentEasting['value'] = mgrs.easting;
      _currentNorthing['value'] = mgrs.northing;

      _currentLonZone['value'] = mgrs.utmZone.lonZone;
      _currentLatZone = mgrs.utmZone.latZone;
      _currentDigraphEasting = mgrs.digraph[0];
      _currentDigraphNorthing = mgrs.digraph[1];

      _LonZoneController.text = _currentLonZone['value'].toString();
      _EastingController.text = _currentEasting['value'].toString();
      _NorthingController.text = _currentNorthing['value'].toString();
    }

    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: GCWIntegerTextField(
                hintText: i18n(context, 'coords_formatconverter_mgrs_lonzone'),
                textInputFormatter: CoordsIntegerUTMLonZoneTextInputFormatter(),
                controller: _LonZoneController,
                onChanged: (ret) {
                  setState(() {
                    _currentLonZone = ret;
                    //   _setCurrentValueAndEmitOnChange();
                  });
                }),
            padding: EdgeInsets.only(right: DEFAULT_MARGIN),
          )),
          Expanded(
              child: Container(
                  child: GCWDropDownButton(
                    value: _currentLatZone,
                    onChanged: (newValue) {
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
                  ),
                  padding: EdgeInsets.only(left: DEFAULT_MARGIN))),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: GCWDropDownButton(
              value: _currentDigraphEasting,
              onChanged: (newValue) {
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
            padding: EdgeInsets.only(right: DEFAULT_MARGIN),
          )),
          Expanded(
              child: Container(
            child: GCWDropDownButton(
              value: _currentDigraphNorthing,
              onChanged: (newValue) {
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
            padding: EdgeInsets.only(left: DEFAULT_MARGIN),
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

  _setCurrentValueAndEmitOnChange() {
    double easting = _currentEasting['value'];
    easting = fillUpNumber(easting, _EastingController.text, 5);

    double northing = _currentNorthing['value'];
    northing = fillUpNumber(northing, _NorthingController.text, 5);

    var _lonZone = _currentLonZone['value'];
    var zone = UTMZone(_lonZone, _lonZone, _currentLatZone);
    var mgrs = MGRS(zone, _currentDigraphEasting + _currentDigraphNorthing, easting, northing);

    widget.onChanged(mgrs);
  }
}
