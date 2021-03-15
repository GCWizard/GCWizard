import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/converter/gauss_krueger.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/common/gcw_double_textfield.dart';
import 'package:latlong/latlong.dart';

class GCWCoordsGaussKrueger extends StatefulWidget {
  final Function onChanged;
  final LatLng coordinates;
  final String subtype;

  const GCWCoordsGaussKrueger({Key key, this.onChanged, this.coordinates, this.subtype: keyCoordsGaussKruegerGK1})
      : super(key: key);

  @override
  GCWCoordsGaussKruegerState createState() => GCWCoordsGaussKruegerState();
}

class GCWCoordsGaussKruegerState extends State<GCWCoordsGaussKrueger> {
  var _eastingController;
  var _northingController;

  var _currentEasting = {'text': '', 'value': 0.0};
  var _currentNorthing = {'text': '', 'value': 0.0};

  var _currentSubtype = 1;

  @override
  void initState() {
    super.initState();

    _currentSubtype = _getSubTypeCode(widget.subtype);

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
      var gauskrueger = latLonToGaussKrueger(widget.coordinates, _currentSubtype, defaultEllipsoid());
      _currentEasting['value'] = gauskrueger.easting;
      _currentNorthing['value'] = gauskrueger.northing;
      _currentSubtype = gauskrueger.code;

      _eastingController.text = _currentEasting['value'].toString();
      _northingController.text = _currentNorthing['value'].toString();
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

  int _getSubTypeCode(String subtype) {
    var code = 1;
    switch (subtype) {
      case keyCoordsGaussKruegerGK1:
        code = 1;
        break;
      case keyCoordsGaussKruegerGK2:
        code = 2;
        break;
      case keyCoordsGaussKruegerGK3:
        code = 3;
        break;
      case keyCoordsGaussKruegerGK4:
        code = 4;
        break;
      case keyCoordsGaussKruegerGK5:
        code = 5;
        break;
    }
    return code;
  }

  String _getSubTypeString(int code) {
    var subtype = keyCoordsGaussKruegerGK1;
    switch (code) {
      case 1:
        subtype = keyCoordsGaussKruegerGK1;
        break;
      case 2:
        subtype = keyCoordsGaussKruegerGK2;
        break;
      case 3:
        subtype = keyCoordsGaussKruegerGK3;
        break;
      case 4:
        subtype = keyCoordsGaussKruegerGK4;
        break;
      case 5:
        subtype = keyCoordsGaussKruegerGK5;
        break;
    }

    return subtype;
  }

  _setCurrentValueAndEmitOnChange() {
    var code = _currentSubtype;
    var gaussKrueger = GaussKrueger(code, _currentEasting['value'], _currentNorthing['value']);
    LatLng coords = gaussKruegerToLatLon(gaussKrueger, defaultEllipsoid());

    widget.onChanged(coords);
  }
}
